import 'dart:async';

import 'package:flipper_accounting/audit_trail_recorder.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/domain/party/customer_factory.dart';
import 'package:flipper_models/domain/party/party_draft.dart';
import 'package:flipper_models/domain/party/party_validation.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:meta/meta.dart';
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
///   3. an existing customer matches typed phone+name (same phone may map to
///      different people — name disambiguates; phone-only when name empty)
///   4. otherwise → auto-create a customer record from the typed name/phone
///      and link it
///
/// Customer list/create always go through Capella (Ditto): that is what the
/// Customers screen and POS attach flows read. Using [ProxyService.strategy]
/// (Brick/cloudSync on native) looks up a different store and re-creates
/// duplicates that then get mirrored into Ditto.
class LoanCustomerLinker {
  LoanCustomerLinker._();

  static final Talker _talker = Talker();

  /// POS customer store — same strategy as [customersStreamProvider].
  static DatabaseSyncInterface get _customers =>
      ProxyService.getStrategy(Strategy.capella);

  /// Delay before processing: lets deferred-persist sale paths write the
  /// transaction first, so the link update never races the initial insert.
  static const _settleDelay = Duration(seconds: 3);

  /// In-flight resolve futures keyed by `branchId:phone|name:…` so concurrent
  /// [attachBeforeCompletion] + [ensureLinked] share one create.
  static final Map<String, Future<Customer?>> _inflight = {};

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

      // attachBeforeCompletion may have linked while we waited.
      if ((transaction.customerId ?? '').isNotEmpty) {
        _talker.info(
          '[LoanCustomerLinker] ensureLinked skipped — already linked to '
          '${transaction.customerId}',
        );
        return;
      }

      final customer = await _resolveCustomer(
        branchId: branchId,
        phone: phone,
        name: name,
        tin: transaction.customerTin,
        transactionId: transaction.id,
      );
      if (customer == null) return;

      // Re-check after resolve: another path may have linked the same sale.
      if ((transaction.customerId ?? '').isNotEmpty &&
          transaction.customerId != customer.id) {
        _talker.info(
          '[LoanCustomerLinker] ensureLinked skipped create-link — txn already '
          'has customerId=${transaction.customerId}',
        );
        return;
      }

      await _customers.assignCustomerToTransaction(
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
    Duration timeout = const Duration(seconds: 6),
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
      // In-flight resolve may still finish and populate _inflight for ensureLinked.
      _talker.warning('[LoanCustomerLinker] pre-completion attach skipped: $e');
    }
  }

  /// Match an existing customer by phone (name fallback only when no phone),
  /// else auto-create one. Shared by [ensureLinked] and [attachBeforeCompletion].
  ///
  /// Concurrent callers with the same branch+phone (or name) share one Future
  /// so Capella cannot insert two UUIDs for one typed number.
  static Future<Customer?> _resolveCustomer({
    required String branchId,
    required String phone,
    required String name,
    required String transactionId,
    String? tin,
  }) {
    final lockKey = _resolveLockKey(branchId, phone, name);
    final existing = _inflight[lockKey];
    if (existing != null) {
      _talker.info(
        '[LoanCustomerLinker] reusing in-flight resolve for $lockKey',
      );
      return existing;
    }

    final future = _resolveCustomerUnlocked(
      branchId: branchId,
      phone: phone,
      name: name,
      tin: tin,
      transactionId: transactionId,
    );
    _inflight[lockKey] = future;
    future.whenComplete(() {
      if (identical(_inflight[lockKey], future)) {
        _inflight.remove(lockKey);
      }
    });
    return future;
  }

  static String _resolveLockKey(String branchId, String phone, String name) {
    final normalizedPhone = normalizePartyPhone(phone);
    if (normalizedPhone.isNotEmpty) {
      return '$branchId:phone:$normalizedPhone';
    }
    return '$branchId:name:${name.trim().toLowerCase()}';
  }

  static Future<Customer?> _resolveCustomerUnlocked({
    required String branchId,
    required String phone,
    required String name,
    required String transactionId,
    String? tin,
  }) async {
    Customer? customer;
    try {
      customer = await _lookupExisting(
        branchId: branchId,
        phone: phone,
        name: name,
      );
      if (customer != null) {
        _talker.info(
          '[LoanCustomerLinker] matched existing customer ${customer.id} '
          '(${customer.custNm}) — skip create',
        );
      }
    } catch (e) {
      _talker.warning('[LoanCustomerLinker] customer lookup failed: $e');
    }

    if (customer == null) {
      customer = await _createCustomer(
        branchId: branchId,
        name: name.isNotEmpty ? name : phone,
        phone: phone,
        tin: tin,
        transactionId: transactionId,
      );
    }

    // Capella addCustomer already upserts into Ditto. Mirror remains a safety
    // net if create returned a draft without a successful upsert.
    if (customer != null) {
      unawaited(_mirrorCustomerToDitto(customer, branchId));
    }
    return customer;
  }

  /// Capella phone lookup (execute + retries); name search only when no phone.
  static Future<Customer?> _lookupExisting({
    required String branchId,
    required String phone,
    required String name,
  }) async {
    final List<Customer> matches;
    if (phone.isNotEmpty) {
      matches = await _customers.findCustomersByPhone(
        branchId: branchId,
        phone: phone,
      );
    } else {
      matches = List<Customer>.from(
        await _customers.customers(
          branchId: branchId,
          key: name,
        ),
      );
    }

    return pickMatchingCustomer(
      candidates: matches,
      phone: phone,
      name: name,
    );
  }

  /// Picks a matching customer. Exposed for tests.
  ///
  /// Same phone may belong to different people (e.g. mura + Auriella) — that is
  /// allowed. When both phone and name are typed, require **both** to match so
  /// a sale typed as Auriella is not linked to an older mura on the same number
  /// (which would overwrite the receipt name). Phone-only matching applies only
  /// when no name was typed.
  @visibleForTesting
  static Customer? pickMatchingCustomer({
    required List<Customer> candidates,
    required String phone,
    required String name,
  }) {
    final trimmedName = name.trim();
    final nameKey = trimmedName.toLowerCase();

    bool nameMatches(Customer c) =>
        (c.custNm ?? '').trim().toLowerCase() == nameKey;

    final List<Customer> exact;
    if (phone.isNotEmpty && trimmedName.isNotEmpty) {
      exact = candidates
          .where((c) => partyPhonesMatch(c.telNo, phone) && nameMatches(c))
          .toList();
    } else if (phone.isNotEmpty) {
      exact =
          candidates.where((c) => partyPhonesMatch(c.telNo, phone)).toList();
    } else if (trimmedName.isNotEmpty) {
      exact = candidates.where(nameMatches).toList();
    } else {
      return null;
    }

    exact.sort((a, b) => a.id.compareTo(b.id));
    return exact.isEmpty ? null : exact.first;
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
      final created = await _customers.addCustomer(
        customer: customer,
        transactionId: transactionId,
      );
      return created ?? customer;
    } on UnimplementedError {
      _talker.warning(
        '[LoanCustomerLinker] Capella addCustomer unimplemented — '
        'using draft + mirror',
      );
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

  @visibleForTesting
  static void clearInflightForTest() => _inflight.clear();

  /// Test seam: resolve with injectable lookup/create (no ProxyService/Ditto).
  @visibleForTesting
  static Future<Customer?> resolveWithDepsForTest({
    required String branchId,
    required String phone,
    required String name,
    required String transactionId,
    String? tin,
    required Future<List<Customer>> Function() lookup,
    required Future<Customer> Function() create,
  }) {
    final lockKey = _resolveLockKey(branchId, phone, name);
    final existing = _inflight[lockKey];
    if (existing != null) return existing;

    final future = () async {
      Customer? customer;
      try {
        final matches = await lookup();
        customer = pickMatchingCustomer(
          candidates: matches,
          phone: phone,
          name: name,
        );
        if (customer != null) {
          _talker.info(
            '[LoanCustomerLinker] matched existing ${customer.id} — skip create',
          );
        }
      } catch (e) {
        _talker.warning('[LoanCustomerLinker] test lookup failed: $e');
      }
      customer ??= await create();
      return customer;
    }();

    _inflight[lockKey] = future;
    future.whenComplete(() {
      if (identical(_inflight[lockKey], future)) {
        _inflight.remove(lockKey);
      }
    });
    return future;
  }
}
