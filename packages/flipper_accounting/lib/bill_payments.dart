import 'package:flipper_accounting/accounting_ditto_store.dart';
import 'package:flipper_accounting/accounting_models.dart';
import 'package:flipper_accounting/audit_trail_recorder.dart';
import 'package:flipper_accounting/chart_account_resolver.dart';
import 'package:flipper_accounting/ditto_accounting_ledger_repository.dart';
import 'package:flipper_accounting/journal_entry_id.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

/// Ditto collection holding one document per supplier payment against a bill.
///
/// Payments are separate documents (never a counter on the bill) so two
/// devices paying the same bill offline both survive the merge. The bill's
/// `amount_paid` / `balance` / `status` fields are a cache recomputed from this
/// collection after every payment.
const String billPaymentsCollection = 'bill_payments';

/// One payment toward a bill (money the business owes a supplier).
class BillPayment {
  const BillPayment({
    required this.id,
    required this.businessId,
    required this.billDocId,
    required this.amount,
    required this.accountCode,
    required this.paidAt,
    this.paidBy,
    this.cashbookTxnId,
  });

  final String id;
  final String businessId;

  /// Ditto `_id` of the bill in `accounting_documents`.
  final String billDocId;
  final int amount;

  /// Ledger account the money left from (1010 cash, 1020 bank, 1030 MoMo).
  final String accountCode;
  final DateTime paidAt;
  final String? paidBy;

  /// Cashbook cash-out recorded for the same payment, so the till reconciles.
  /// Transaction posters skip that transaction: the AP entry already exists.
  final String? cashbookTxnId;

  Map<String, dynamic> toRow() => {
    'id': id,
    'business_id': businessId,
    'businessId': businessId,
    'bill_doc_id': billDocId,
    'billDocId': billDocId,
    'amount': amount,
    'account_code': accountCode,
    'accountCode': accountCode,
    'paid_at': paidAt.toUtc().toIso8601String(),
    'paidAt': paidAt.toUtc().toIso8601String(),
    if (paidBy != null) 'paid_by': paidBy,
    if (cashbookTxnId != null) 'cashbook_txn_id': cashbookTxnId,
    if (cashbookTxnId != null) 'cashbookTxnId': cashbookTxnId,
  };

  static BillPayment fromRow(Map<String, dynamic> row) {
    String str(String snake, String camel) =>
        (row[snake] ?? row[camel] ?? '').toString();
    final cashbook = str('cashbook_txn_id', 'cashbookTxnId');
    final paidBy = (row['paid_by'] ?? '').toString();
    return BillPayment(
      id: (row['id'] ?? row['_id'] ?? '').toString(),
      businessId: str('business_id', 'businessId'),
      billDocId: str('bill_doc_id', 'billDocId'),
      amount: num.tryParse('${row['amount']}')?.round() ?? 0,
      accountCode: str('account_code', 'accountCode'),
      paidAt: DateTime.tryParse(str('paid_at', 'paidAt')) ?? DateTime.now(),
      paidBy: paidBy.isEmpty ? null : paidBy,
      cashbookTxnId: cashbook.isEmpty ? null : cashbook,
    );
  }
}

/// What is owed on a bill: [total] less money paid at purchase time
/// ([paidUpfront]) and later [payments].
class BillBalance {
  const BillBalance({
    required this.total,
    this.paidUpfront = 0,
    this.paidLater = 0,
  });

  factory BillBalance.from({
    required int total,
    int paidUpfront = 0,
    Iterable<BillPayment> payments = const [],
  }) {
    var later = 0;
    for (final p in payments) {
      later += p.amount;
    }
    return BillBalance(
      total: total,
      paidUpfront: paidUpfront,
      paidLater: later,
    );
  }

  final int total;
  final int paidUpfront;
  final int paidLater;

  int get amountPaid => paidUpfront + paidLater;

  /// Never negative: an overpayment settles the bill, it does not make the
  /// supplier owe us.
  int get balance => (total - amountPaid).clamp(0, total < 0 ? 0 : total);

  bool get isSettled => balance <= 0;

  /// Stored status. Supabase only accepts draft/sent/paid/overdue, so a part
  /// payment stays `sent`; readers derive "partially paid" from amounts.
  String get storedStatus => isSettled ? 'paid' : 'sent';

  /// Cached summary fields written onto the bill document.
  Map<String, dynamic> toBillFields() => {
    'total': total,
    'paid_upfront': paidUpfront,
    'amount_paid': amountPaid,
    'balance': balance,
    'status': storedStatus,
  };
}

/// Shared date format for bill documents (`d MMM y`, e.g. `3 Oct 2026`).
final DateFormat billDateFormat = DateFormat('d MMM y');

/// Parses a bill's due date: ISO `due_at` first, then the display string.
DateTime? parseBillDueDate(Map<String, dynamic> row) {
  final iso = (row['due_at'] ?? row['dueAt'])?.toString();
  if (iso != null && iso.isNotEmpty) {
    // Stored in UTC; back to local so the calendar day matches what the
    // owner picked (Kigali is UTC+2).
    final parsed = DateTime.tryParse(iso);
    if (parsed != null) return parsed.toLocal();
  }
  final display = (row['due_date'] ?? row['dueDate'])?.toString() ?? '';
  if (display.isEmpty) return null;
  try {
    return billDateFormat.parseLoose(display);
  } catch (_) {
    return null;
  }
}

/// Records supplier payments against bills and keeps the ledger in step:
/// every payment posts Dr Accounts Payable / Cr the account the money left.
class BillPaymentPoster {
  BillPaymentPoster(this._ditto, {AuditTrailRecorder? audit}) : _audit = audit;

  final AccountingDittoStore _ditto;
  final AuditTrailRecorder? _audit;

  /// Deterministic journal entry id, so a retried payment never posts twice.
  static String entryId(
    String businessId,
    String billDocId,
    String paymentId,
  ) =>
      'je_${businessId}_${slugifyJournalIdPart(billDocId)}_pay_'
      '${slugifyJournalIdPart(paymentId)}';

  Future<List<BillPayment>> paymentsFor(String billDocId) async {
    final rows = await _ditto.queryCollection(
      billPaymentsCollection,
      'SELECT * FROM $billPaymentsCollection WHERE billDocId = :billDocId',
      {'billDocId': billDocId},
    );
    return rows.map(BillPayment.fromRow).toList();
  }

  Stream<List<BillPayment>> watchPayments(String businessId) {
    return _ditto
        .watchCollection(
          billPaymentsCollection,
          'SELECT * FROM $billPaymentsCollection WHERE businessId = :businessId',
          {'businessId': businessId},
        )
        .map((rows) => rows.map(BillPayment.fromRow).toList());
  }

  Future<Map<String, dynamic>?> _bill(String billDocId) async {
    final rows = await _ditto.queryCollection(
      'accounting_documents',
      'SELECT * FROM accounting_documents WHERE _id = :id',
      {'id': billDocId},
    );
    return rows.isEmpty ? null : rows.first;
  }

  /// Records [amount] paid toward the bill [billDocId] from [paymentAccount]
  /// and returns the bill's new balance.
  ///
  /// [fallbackTotal] is used only for bills written before `total` was stored
  /// (their total was derived from the lines).
  Future<BillBalance> recordPayment({
    required String businessId,
    required String billDocId,
    required int amount,
    required String paymentAccount,
    required List<Account> accounts,
    int? fallbackTotal,
    DateTime? paidAt,
    String? paidBy,
    String? cashbookTxnId,
    String? paymentId,
  }) async {
    if (amount <= 0) {
      throw ArgumentError.value(amount, 'amount', 'must be positive');
    }
    final bill = await _bill(billDocId);
    if (bill == null) {
      throw StateError('Bill $billDocId not found');
    }
    // A draft is a purchase still waiting for approval: nothing is owed yet,
    // and declining it deletes the bill.
    if (bill['status'] == 'draft') {
      throw StateError('Approve the purchase before paying this bill');
    }
    final ap = ChartAccountResolver(accounts).payable;
    if (ap == null) {
      throw StateError('Chart of accounts has no Accounts Payable account');
    }

    final payment = BillPayment(
      id: paymentId ?? const Uuid().v4(),
      businessId: businessId,
      billDocId: billDocId,
      amount: amount,
      accountCode: paymentAccount,
      paidAt: paidAt ?? DateTime.now(),
      paidBy: paidBy,
      cashbookTxnId: cashbookTxnId,
    );
    await _ditto.upsertPartyDoc(
      billPaymentsCollection,
      payment.id,
      payment.toRow(),
    );

    final docNumber = (bill['doc_number'] ?? bill['docNumber'] ?? '')
        .toString();
    final party = (bill['party_name'] ?? bill['partyName'] ?? '').toString();
    final ledger = DittoAccountingLedgerRepository(_ditto);
    await ledger.ensureSeeded(businessId: businessId);
    final jeId = entryId(businessId, billDocId, payment.id);
    if (!await ledger.entryExists(businessId: businessId, entryId: jeId)) {
      final entry = JournalEntry(
        id: 'PAY-$docNumber',
        date: billDateFormat.format(payment.paidAt),
        memo: 'Bill payment — $party',
        ref: 'PAY-$docNumber',
        status: JournalStatus.posted,
        src: 'Bill',
        lines: [
          JournalLine(ac: ap, dr: amount),
          JournalLine(ac: paymentAccount, cr: amount),
        ],
      );
      await ledger.createJournalEntry(
        businessId: businessId,
        entry: entry,
        transactionId: '$billDocId-pay-${payment.id}',
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
        src: 'Bill',
      );
    }

    return refreshBalance(
      billDocId: billDocId,
      bill: bill,
      fallbackTotal: fallbackTotal,
    );
  }

  /// Recomputes and caches the bill's paid/balance/status from its payments.
  Future<BillBalance> refreshBalance({
    required String billDocId,
    Map<String, dynamic>? bill,
    int? fallbackTotal,
  }) async {
    final row = bill ?? await _bill(billDocId);
    if (row == null) {
      throw StateError('Bill $billDocId not found');
    }
    final balance = BillBalance.from(
      total: num.tryParse('${row['total']}')?.round() ?? fallbackTotal ?? 0,
      paidUpfront: num.tryParse('${row['paid_upfront']}')?.round() ?? 0,
      payments: await paymentsFor(billDocId),
    );
    final fields = balance.toBillFields();
    // A payment synced in from another device must not promote a draft.
    if (row['status'] == 'draft') fields.remove('status');
    await _ditto.executeUpdate('accounting_documents', billDocId, fields);
    return balance;
  }
}
