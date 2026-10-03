import 'package:flutter/foundation.dart';
import 'package:flipper_accounting/accounting_ditto_store.dart';
import 'package:flipper_accounting/accounting_models.dart';
import 'package:flipper_accounting/audit_trail_recorder.dart';
import 'package:flipper_accounting/bill_payments.dart';
import 'package:flipper_accounting/chart_account_resolver.dart';
import 'package:flipper_accounting/ditto_accounting_ledger_repository.dart';
import 'package:flipper_accounting/purchase_posting_input.dart';

/// Posts purchase bills and journal entries using the same rules as Books
/// [DocumentJournalPoster.postBillRecorded], extended for payment type.
class PurchaseJournalPoster {
  PurchaseJournalPoster(this._ditto, {AuditTrailRecorder? audit})
      : _audit = audit;

  final AccountingDittoStore _ditto;
  final AuditTrailRecorder? _audit;

  static String entryId(String businessId, String purchaseId) =>
      'je_${businessId}_${purchaseId}_purchase';

  static String billDocId(String businessId, String billNumber) =>
      '${businessId}_bill_$billNumber';

  /// Upserts the purchase's bill document and optionally posts the GL entry.
  ///
  /// The bill is the record of what the business owes the supplier:
  /// * Cash, bank, card, MoMo, other (`01`, `04`–`07`): settled at purchase
  ///   time, so the bill is written as `paid` with nothing owed.
  /// * Credit (`02`): the whole total goes to Accounts Payable.
  /// * Cash/Credit (`03`): [PurchasePostingInput.paidUpfront] is credited to
  ///   cash and only the rest goes to Accounts Payable.
  ///
  /// With [postToLedger] false (a purchase saved as waiting) the bill is a
  /// `draft` that carries the credit terms (due date, part paid upfront) until
  /// approval posts it.
  Future<void> postPurchaseRecorded({
    required String businessId,
    required PurchasePostingInput purchase,
    required List<Account> accounts,
    bool postToLedger = true,
  }) async {
    if (businessId.isEmpty || !_ditto.isReady()) return;

    final roles = ChartAccountResolver(accounts);
    final inventory = roles.inventory ?? roles.operatingExpense;
    final vat = roles.vatPayable;
    final ap = roles.payable;
    // Cash/Credit settles its upfront part in cash; every other type settles
    // in full through its own account.
    final settleAc = purchase.pmtTyCd == '03'
        ? roles.cashOnHand
        : roles.purchaseCreditAccount(purchase.pmtTyCd);
    if (inventory == null ||
        vat == null ||
        settleAc == null ||
        (purchase.isOnCredit && ap == null)) {
      debugPrint(
        '[PurchaseJournalPoster] skipped — missing COA roles '
        '(inventory=$inventory vat=$vat settle=$settleAc ap=$ap)',
      );
      return;
    }

    final billId = 'BILL-${purchase.invoiceNo}';
    final docUuid = billDocId(businessId, billId);
    final existing = await _billRow(docUuid);

    final issueDate = purchase.purchaseDate ?? DateTime.now();
    final dateStr = billDateFormat.format(issueDate);
    final due = purchase.dueDate ??
        (existing == null ? null : parseBillDueDate(existing)) ??
        issueDate.add(const Duration(days: 30));
    final plannedUpfront = purchase.paidUpfront ??
        num.tryParse('${existing?['paid_upfront']}')?.toDouble();
    final paidUpfront = purchase.paidAtPurchase(plannedUpfront);
    final owed = purchase.total - paidUpfront;

    final payments = existing == null
        ? const <BillPayment>[]
        : await BillPaymentPoster(_ditto).paymentsFor(docUuid);
    final balance = BillBalance.from(
      total: purchase.total,
      paidUpfront: paidUpfront,
      payments: payments,
    );

    final docRow = {
      'id': docUuid,
      'business_id': businessId,
      'businessId': businessId,
      'doc_kind': 'bill',
      'docKind': 'bill',
      'doc_number': billId,
      'docNumber': billId,
      'party_name': purchase.supplierName,
      'partyName': purchase.supplierName,
      'issue_date': dateStr,
      'issueDate': dateStr,
      'due_date': billDateFormat.format(due),
      'dueDate': billDateFormat.format(due),
      'due_at': due.toUtc().toIso8601String(),
      'lines': [
        for (final l in purchase.lines)
          {
            'desc': l.description,
            'qty': l.qty,
            'price': l.unitPrice,
          },
      ],
      'purchase_id': purchase.purchaseId,
      'purchaseId': purchase.purchaseId,
      'source': 'purchase',
      if (purchase.supplierId != null) 'supplier_id': purchase.supplierId,
      ...balance.toBillFields(),
      if (!postToLedger) 'status': 'draft',
    };

    await _ditto.upsertAccountingDocument(businessId, docRow, docUuid);

    if (!postToLedger) return;

    final ledger = DittoAccountingLedgerRepository(_ditto);
    await ledger.ensureSeeded(businessId: businessId);

    final jeId = entryId(businessId, purchase.purchaseId);
    final exists = await ledger.entryExists(
      businessId: businessId,
      entryId: jeId,
    );
    if (exists) return;

    final entry = JournalEntry(
      id: 'JE-${purchase.invoiceNo}',
      date: dateStr,
      memo: 'Purchase $billId — ${purchase.supplierName}',
      ref: billId,
      status: JournalStatus.posted,
      src: 'Purchase',
      lines: [
        JournalLine(ac: inventory, dr: purchase.netInventory),
        JournalLine(ac: vat, dr: purchase.vat),
        if (owed > 0) JournalLine(ac: ap!, cr: owed),
        if (paidUpfront > 0) JournalLine(ac: settleAc, cr: paidUpfront),
      ],
    );

    await ledger.createJournalEntry(
      businessId: businessId,
      entry: entry,
      transactionId: purchase.purchaseId,
      journalCode: 'misc',
      entryId: jeId,
    );
    await ledger.postJournalEntry(businessId: businessId, entryId: jeId);

    await _audit?.record(
      businessId: businessId,
      id: 'audit_$jeId',
      action: 'Posted',
      target: entry.id,
      detail: entry.memo,
      src: 'Purchase',
    );
  }

  /// Removes the draft bill of a declined purchase. Posted bills are kept:
  /// once a purchase is in the ledger it must be reversed, not deleted.
  Future<void> discardDraftBill({
    required String businessId,
    required int invoiceNo,
  }) async {
    if (businessId.isEmpty || !_ditto.isReady()) return;
    final docUuid = billDocId(businessId, 'BILL-$invoiceNo');
    final row = await _billRow(docUuid);
    if (row == null || row['status'] != 'draft') return;
    await _ditto.deletePartyDoc('accounting_documents', docUuid);
  }

  Future<Map<String, dynamic>?> _billRow(String docUuid) async {
    final rows = await _ditto.queryCollection(
      'accounting_documents',
      'SELECT * FROM accounting_documents WHERE _id = :id',
      {'id': docUuid},
    );
    return rows.isEmpty ? null : rows.first;
  }
}

/// Builds an [AccountingContact] extension row for Ditto `accounting_contacts`.
Map<String, dynamic> supplierContactToRow({
  required String businessId,
  required String docId,
  required String localId,
  required String partyId,
  required String name,
  String phone = '',
  String email = '',
  String tin = '',
  String sinceLabel = '',
  String terms = 'Net 30',
}) {
  return {
    'id': docId,
    'business_id': businessId,
    'businessId': businessId,
    'contact_kind': 'supplier',
    'contactKind': 'supplier',
    'local_id': localId,
    'localId': localId,
    'name': name,
    'contact_name': name,
    'contactName': name,
    'phone': phone,
    'email': email,
    'tin': tin,
    'since_label': sinceLabel,
    'sinceLabel': sinceLabel,
    'terms': terms,
    'party_id': partyId,
    'partyId': partyId,
  };
}
