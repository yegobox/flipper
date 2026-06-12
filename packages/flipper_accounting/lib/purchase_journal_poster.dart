import 'package:flutter/foundation.dart';
import 'package:flipper_accounting/accounting_ditto_store.dart';
import 'package:flipper_accounting/accounting_models.dart';
import 'package:flipper_accounting/audit_trail_recorder.dart';
import 'package:flipper_accounting/chart_account_resolver.dart';
import 'package:flipper_accounting/ditto_accounting_ledger_repository.dart';
import 'package:flipper_accounting/purchase_posting_input.dart';
import 'package:intl/intl.dart';

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

  /// Upserts an accounting bill document and optionally posts the GL entry.
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
    final creditAc = roles.purchaseCreditAccount(purchase.pmtTyCd);
    if (inventory == null || vat == null || creditAc == null) {
      debugPrint(
        '[PurchaseJournalPoster] skipped — missing COA roles '
        '(inventory=$inventory vat=$vat credit=$creditAc)',
      );
      return;
    }

    final billId = 'BILL-${purchase.invoiceNo}';
    final docUuid = billDocId(businessId, billId);
    final issueDate = purchase.purchaseDate ?? DateTime.now();
    final dateStr = DateFormat('d MMM y').format(issueDate);
    final dueDate = DateFormat('d MMM y')
        .format(issueDate.add(const Duration(days: 30)));

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
      'due_date': dueDate,
      'dueDate': dueDate,
      'status': postToLedger ? 'sent' : 'draft',
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

    final net = purchase.netInventory;
    final vatAmt = purchase.vat;
    final total = purchase.total;

    final entry = JournalEntry(
      id: 'JE-${purchase.invoiceNo}',
      date: dateStr,
      memo: 'Purchase $billId — ${purchase.supplierName}',
      ref: billId,
      status: JournalStatus.posted,
      src: 'Purchase',
      lines: [
        JournalLine(ac: inventory, dr: net),
        JournalLine(ac: vat, dr: vatAmt),
        JournalLine(ac: creditAc, cr: total),
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
