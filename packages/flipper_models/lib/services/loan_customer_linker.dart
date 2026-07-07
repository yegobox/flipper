import 'dart:async';

import 'package:flipper_accounting/audit_trail_recorder.dart';
import 'package:flipper_models/domain/party/customer_factory.dart';
import 'package:flipper_models/domain/party/party_draft.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:supabase_models/brick/models/all_models.dart';
import 'package:talker/talker.dart';

/// Links a sale to a canonical customer record so accounting always shows a
/// real customer (debtors for loans, named customers for any sale) rather than
/// free-text name/phone.
///
/// Runs fire-and-forget AFTER the sale has completed — it adds zero latency
/// to checkout. Resolution order:
///   1. transaction already linked → no-op
///   2. no customer info typed (name and phone both empty) → no-op
///      (anonymous walk-in cash sales never create junk customers)
///   3. an existing customer matches the typed phone (or name when no phone)
///      → link it
///   4. otherwise → auto-create a customer record from the typed name/phone
///      and link it
class LoanCustomerLinker {
  LoanCustomerLinker._();

  static final Talker _talker = Talker();

  /// Delay before processing: lets deferred-persist sale paths write the
  /// transaction first, so the link update never races the initial insert.
  static const _settleDelay = Duration(seconds: 3);

  /// Never throws.
  ///
  /// Links the customer for ANY sale that captured a name/phone — not just
  /// loans — so the accounting software always sees a real customer. Matching
  /// is by phone (the unique key); only when no phone was typed does it fall
  /// back to name. [markAsLoan] now only affects audit wording (it signalled
  /// loan-ness when [transaction.isLoan] was not yet persisted in-memory).
  static Future<void> ensureLinked({
    required ITransaction transaction,
    required String branchId,
    bool? markAsLoan,
  }) async {
    try {
      final isLoan = markAsLoan ?? (transaction.isLoan == true);
      if ((transaction.customerId ?? '').isNotEmpty) return;

      final phone = transaction.customerPhone?.trim() ?? '';
      final name = transaction.customerName?.trim() ?? '';
      if (phone.isEmpty && name.isEmpty) return;

      await Future.delayed(_settleDelay);

      final customer = await _resolveCustomer(
        branchId: branchId,
        phone: phone,
        name: name,
        tin: transaction.customerTin,
        transactionId: transaction.id,
      );
      if (customer == null) return;

      await ProxyService.strategy.assignCustomerToTransaction(
        customer: customer,
        transaction: transaction,
      );
      _talker.info(
        '[LoanCustomerLinker] ${isLoan ? 'loan' : 'sale'} ${transaction.id} '
        'linked to customer ${customer.id} (${customer.custNm})',
      );

      final businessId = ProxyService.box.getBusinessId();
      if (businessId != null && businessId.isNotEmpty) {
        await AuditTrailRecorder(DittoService.instance).record(
          businessId: businessId,
          id: 'audit_link_${transaction.id}',
          action: 'Customer linked',
          target: customer.custNm ?? customer.id,
          detail:
              '${isLoan ? 'Loan' : 'Sale'} ${transaction.receiptNumber ?? transaction.id} '
              'linked to customer record',
          user: ProxyService.box.getUserPhone() ?? 'POS',
          role: 'Cashier',
          iconName: 'Users',
          src: 'POS',
        );
      }
    } catch (e, s) {
      _talker.error('[LoanCustomerLinker] link failed: $e', s);
    }
  }

  /// Resolves and attaches the customer to the IN-MEMORY [transaction] BEFORE
  /// its completed status is persisted, so the data-connector (which posts the
  /// journal when a transaction becomes `completed`) never sees a finalized sale
  /// with no customer attached. The caller's single completion write then
  /// persists `customerId` together with the status — no second write, no race.
  ///
  /// Best-effort and bounded by [timeout]: on miss/timeout/error it leaves the
  /// transaction unchanged and the fire-and-forget [ensureLinked] backfills the
  /// link later. Does NOT upsert — the caller persists the transaction once.
  static Future<void> attachBeforeCompletion({
    required ITransaction transaction,
    required String branchId,
    Duration timeout = const Duration(seconds: 4),
  }) async {
    try {
      if ((transaction.customerId ?? '').isNotEmpty) return;
      final phone = transaction.customerPhone?.trim() ?? '';
      final name = transaction.customerName?.trim() ?? '';
      if (phone.isEmpty && name.isEmpty) return;

      final customer = await _resolveCustomer(
        branchId: branchId,
        phone: phone,
        name: name,
        tin: transaction.customerTin,
        transactionId: transaction.id,
      ).timeout(timeout);
      if (customer == null) return;

      // In-memory only — the caller's completion upsert persists these fields.
      transaction.customerId = customer.id;
      transaction.customerName = customer.custNm;
      transaction.customerTin = customer.custTin;
      transaction.customerPhone = customer.telNo;
      transaction.currentSaleCustomerPhoneNumber = customer.telNo;
      _talker.info(
        '[LoanCustomerLinker] pre-completion attached customer ${customer.id} '
        '(${customer.custNm}) to ${transaction.id}',
      );
    } catch (e) {
      // Never block or break sale completion; the backfill linker recovers.
      _talker.warning('[LoanCustomerLinker] pre-completion attach skipped: $e');
    }
  }

  /// Match an existing customer by phone (name fallback only when no phone),
  /// else auto-create one. Shared by [ensureLinked] and [attachBeforeCompletion].
  static Future<Customer?> _resolveCustomer({
    required String branchId,
    required String phone,
    required String name,
    required String transactionId,
    String? tin,
  }) async {
    // Phone is far more unique than a free-text name; only fall back to name
    // matching when no phone was captured.
    Customer? customer;
    try {
      final searchKey = phone.isNotEmpty ? phone : name;
      final matches = await ProxyService.strategy.customers(
        branchId: branchId,
        key: searchKey,
      );
      final exact = matches
          .where((c) => phone.isNotEmpty
              ? (c.telNo ?? '').trim() == phone
              : (c.custNm ?? '').trim().toLowerCase() == name.toLowerCase())
          .toList()
        ..sort((a, b) => a.id.compareTo(b.id));
      if (exact.isNotEmpty) customer = exact.first;
    } catch (e) {
      _talker.warning('[LoanCustomerLinker] customer lookup failed: $e');
    }

    customer ??= await _createCustomer(
      branchId: branchId,
      name: name.isNotEmpty ? name : phone,
      phone: phone,
      tin: tin,
      transactionId: transactionId,
    );

    // Mirror the resolved customer into the Ditto `customers` collection so the
    // Books web client (which reads Ditto, not Brick) shows it immediately.
    // Covers BOTH a matched-existing customer and a freshly auto-created one:
    // the native POS (CoreSync) persists customers to Brick/Supabase only, so
    // without this mirror they never reach the collection Books reads — which
    // is exactly why "Customer linked" audit events show up with no matching
    // customer in the list. Fire-and-forget so it never affects the caller's
    // timeout budget (attachBeforeCompletion) or checkout latency.
    if (customer != null) {
      unawaited(_mirrorCustomerToDitto(customer, branchId));
    }
    return customer;
  }

  static Future<Customer?> _createCustomer({
    required String branchId,
    required String name,
    required String phone,
    required String transactionId,
    String? tin,
  }) async {
    final draft = PartyDraft(
      name: name,
      phone: phone,
      tin: tin,
      customerType: 'Individual',
      branchId: branchId,
      bhfId: await ProxyService.box.bhfId() ?? '00',
    );
    final customer = customerFromDraft(draft);
    try {
      final created = await ProxyService.strategy.addCustomer(
        customer: customer,
        transactionId: transactionId,
      );
      return created ?? customer;
    } on UnimplementedError {
      // Capella strategy has no addCustomer; the Ditto mirror in
      // [_resolveCustomer] persists the canonical `customers` doc Books reads.
      return customer;
    }
  }

  /// Best-effort mirror of [customer] into the Ditto `customers` collection —
  /// the store the Books web lists observe. Never throws.
  ///
  /// The document shape matches [PartyDraft.toDittoRow] / PartyRowMapper so the
  /// Books party mapper reads it back correctly. `branchId` is keyed on the
  /// branch UUID (same key Books queries with).
  static Future<void> _mirrorCustomerToDitto(
    Customer customer,
    String branchId,
  ) async {
    try {
      final ditto = DittoService.instance;
      if (!ditto.isReady()) {
        _talker.warning(
          '[LoanCustomerLinker] Ditto not ready — customer mirror skipped '
          '(PartyBackfill will heal from Supabase)',
        );
        return;
      }
      await ditto.upsertPartyDoc('customers', customer.id, {
        'custNm': customer.custNm,
        'email': customer.email,
        'telNo': customer.telNo,
        'adrs': customer.adrs,
        'branchId': customer.branchId ?? branchId,
        'updatedAt':
            (customer.updatedAt ?? DateTime.now().toUtc()).toIso8601String(),
        'custNo': customer.custNo,
        'custTin': customer.custTin,
        'regrNm': customer.regrNm,
        'regrId': customer.regrId,
        'modrNm': customer.modrNm,
        'modrId': customer.modrId,
        'ebmSynced': customer.ebmSynced ?? false,
        'bhfId': customer.bhfId ?? '00',
        'useYn': customer.useYn ?? 'N',
        'customerType': customer.customerType,
      });
      _talker.info(
        '[LoanCustomerLinker] mirrored customer ${customer.id} '
        '(${customer.custNm}) into Ditto customers for branch $branchId',
      );
    } catch (e) {
      _talker.warning('[LoanCustomerLinker] Ditto customer mirror failed: $e');
    }
  }
}
