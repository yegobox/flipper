import 'dart:async';

import 'package:flipper_accounting/audit_trail_recorder.dart';
import 'package:flipper_models/domain/party/customer_factory.dart';
import 'package:flipper_models/domain/party/party_draft.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:supabase_models/brick/models/all_models.dart';
import 'package:talker/talker.dart';

/// Links loan transactions to a canonical customer record so accounting
/// tracks debtors by customer id rather than free-text name.
///
/// Runs fire-and-forget AFTER the sale has completed — it adds zero latency
/// to checkout. Resolution order:
///   1. transaction already linked → no-op
///   2. an existing customer matches the typed phone (or name when no phone)
///      → link it
///   3. otherwise → auto-create a customer record from the typed name/phone
///      and link it
class LoanCustomerLinker {
  LoanCustomerLinker._();

  static final Talker _talker = Talker();

  /// Delay before processing: lets deferred-persist sale paths write the
  /// transaction first, so the link update never races the initial insert.
  static const _settleDelay = Duration(seconds: 3);

  /// Never throws.
  ///
  /// [markAsLoan] lets callers signal loan-ness when [transaction.isLoan] is
  /// not yet persisted on the in-memory object (e.g. partial-tender sales where
  /// the parked status is the loan signal).
  static Future<void> ensureLinked({
    required ITransaction transaction,
    required String branchId,
    bool? markAsLoan,
  }) async {
    try {
      final isLoan = markAsLoan ?? (transaction.isLoan == true);
      if (!isLoan) return;
      if ((transaction.customerId ?? '').isNotEmpty) return;

      final phone = transaction.customerPhone?.trim() ?? '';
      final name = transaction.customerName?.trim() ?? '';
      if (phone.isEmpty && name.isEmpty) return;

      await Future.delayed(_settleDelay);

      // Phone is far more unique than a free-text name; only fall back to
      // name matching when no phone was captured.
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
        tin: transaction.customerTin,
        transactionId: transaction.id,
      );
      if (customer == null) return;

      await ProxyService.strategy.assignCustomerToTransaction(
        customer: customer,
        transaction: transaction,
      );
      _talker.info(
        '[LoanCustomerLinker] loan ${transaction.id} linked to customer '
        '${customer.id} (${customer.custNm})',
      );

      final businessId = ProxyService.box.getBusinessId();
      if (businessId != null && businessId.isNotEmpty) {
        await AuditTrailRecorder(DittoService.instance).record(
          businessId: businessId,
          id: 'audit_link_${transaction.id}',
          action: 'Customer linked',
          target: customer.custNm ?? customer.id,
          detail: 'Loan ${transaction.receiptNumber ?? transaction.id} '
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
      // Capella strategy has no addCustomer; write the canonical Ditto
      // `customers` doc directly (same shape the Books party repo reads).
      final ditto = DittoService.instance;
      if (!ditto.isReady()) {
        _talker.warning(
          '[LoanCustomerLinker] Ditto not ready — customer not created',
        );
        return null;
      }
      await ditto.upsertPartyDoc('customers', draft.id, draft.toDittoRow());
      return customer;
    }
  }
}
