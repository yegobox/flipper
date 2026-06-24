import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_v3_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_document_math.dart';
import 'package:flipper_web/modules/accounting/data/chart_account_resolver.dart';
import 'package:flipper_web/modules/accounting/data/repository/accounting_ledger_repository.dart';
import 'package:intl/intl.dart';

/// Auto-posts balanced journal entries for invoices, bills, and payments.
class DocumentJournalPoster {
  const DocumentJournalPoster(this._ledger, this._accounts);

  final AccountingLedgerRepository _ledger;
  final List<Account> _accounts;

  ChartAccountResolver get _roles => ChartAccountResolver(_accounts);

  Future<void> postInvoiceSent({
    required String businessId,
    required AccountingDocument doc,
  }) async {
    final totals = docTotals(doc.lines);
    final ar = _roles.receivable;
    final revenue = _roles.salesRevenue;
    final vat = _roles.vatPayable;
    if (ar == null || revenue == null || vat == null) return;

    await _post(
      businessId: businessId,
      entry: _entry(
        doc: doc,
        memo: 'Invoice ${doc.id} — ${doc.who}',
        src: 'Invoice',
        lines: [
          JournalLine(ac: ar, dr: totals.total),
          JournalLine(ac: revenue, cr: totals.subtotal),
          JournalLine(ac: vat, cr: totals.vat),
        ],
      ),
      journalCode: 'sales',
      transactionId: doc.id,
    );
  }

  Future<void> postBillRecorded({
    required String businessId,
    required AccountingDocument doc,
  }) async {
    final totals = docTotals(doc.lines);
    final inventory = _roles.inventory ?? _roles.operatingExpense;
    final vat = _roles.vatPayable;
    final ap = _roles.payable;
    if (inventory == null || vat == null || ap == null) return;

    await _post(
      businessId: businessId,
      entry: _entry(
        doc: doc,
        memo: 'Bill ${doc.id} — ${doc.who}',
        src: 'Bill',
        lines: [
          JournalLine(ac: inventory, dr: totals.subtotal),
          JournalLine(ac: vat, dr: totals.vat),
          JournalLine(ac: ap, cr: totals.total),
        ],
      ),
      journalCode: 'misc',
      transactionId: doc.id,
    );
  }

  Future<void> postInvoicePayment({
    required String businessId,
    required AccountingDocument doc,
    required String paymentAccount,
    required int amount,
  }) async {
    final ar = _roles.receivable;
    if (ar == null) return;

    await _post(
      businessId: businessId,
      entry: _entry(
        doc: doc,
        memo: 'Payment received — ${doc.who}',
        src: 'Invoice',
        ref: 'RCT-${doc.id}',
        lines: [
          JournalLine(ac: paymentAccount, dr: amount),
          JournalLine(ac: ar, cr: amount),
        ],
      ),
      journalCode: 'sales',
      transactionId: '${doc.id}-pay-${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  Future<void> postBillPayment({
    required String businessId,
    required AccountingDocument doc,
    required String paymentAccount,
    required int amount,
  }) async {
    final ap = _roles.payable;
    if (ap == null) return;

    await _post(
      businessId: businessId,
      entry: _entry(
        doc: doc,
        memo: 'Bill payment — ${doc.who}',
        src: 'Bill',
        ref: 'PAY-${doc.id}',
        lines: [
          JournalLine(ac: ap, dr: amount),
          JournalLine(ac: paymentAccount, cr: amount),
        ],
      ),
      journalCode: 'misc',
      transactionId: '${doc.id}-pay-${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  JournalEntry _entry({
    required AccountingDocument doc,
    required String memo,
    required String src,
    required List<JournalLine> lines,
    String? ref,
  }) {
    final n = DateTime.now().microsecondsSinceEpoch % 10000;
    return JournalEntry(
      id: 'JE-${1040 + n}',
      date: DateFormat('d MMM y').format(DateTime.now()),
      memo: memo,
      ref: ref ?? doc.id,
      status: JournalStatus.posted,
      src: src,
      lines: lines,
    );
  }

  Future<void> _post({
    required String businessId,
    required JournalEntry entry,
    required String journalCode,
    required String transactionId,
  }) async {
    await _ledger.ensureSeeded(businessId: businessId);

    final existing = await _ledger.findEntryIdByTransactionId(
      businessId: businessId,
      transactionId: transactionId,
    );
    if (existing != null) return;

    final entryId = await _ledger.createJournalEntry(
      businessId: businessId,
      entry: entry,
      transactionId: transactionId,
      journalCode: journalCode,
    );
    await _ledger.postJournalEntry(businessId: businessId, entryId: entryId);
  }
}
