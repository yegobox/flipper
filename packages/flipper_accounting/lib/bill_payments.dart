import 'package:flipper_accounting/accounting_ditto_store.dart';
import 'package:flipper_accounting/accounting_models.dart';
import 'package:flipper_accounting/accounting_transaction_semantics.dart';
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

  /// From the summary a bill caches after every payment
  /// ([toBillFields]); [fallbackTotal] for bills written before `total` was
  /// stored.
  factory BillBalance.fromBillRow(
    Map<String, dynamic> row, {
    int fallbackTotal = 0,
  }) {
    int field(String key) => num.tryParse('${row[key]}')?.round() ?? 0;
    final total = num.tryParse('${row['total']}')?.round() ?? fallbackTotal;
    final paidUpfront = field('paid_upfront');
    final amountPaid = field('amount_paid');
    return BillBalance(
      total: total,
      paidUpfront: paidUpfront,
      paidLater: (amountPaid - paidUpfront).clamp(0, amountPaid.abs()),
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

/// Approved purchases' bills by purchase id: the bill's Ditto `_id` and what
/// is still owed. Drafts (purchases still waiting) owe nothing yet, and bills
/// not raised from a purchase are left out.
Map<String, ({String docId, BillBalance balance})> purchaseBillsFromRows(
  Iterable<Map<String, dynamic>> rows,
) => {
  for (final row in rows)
    if (row['status'] != 'draft' &&
        '${row['purchase_id'] ?? row['purchaseId'] ?? ''}'.isNotEmpty)
      '${row['purchase_id'] ?? row['purchaseId']}': (
        docId: '${row['_id'] ?? row['id']}',
        balance: BillBalance.fromBillRow(row),
      ),
};

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

/// The branch (and cashier) whose expenses list a supplier payment as a
/// cash-out: home screen, Cashbook, Transaction Report and the daily email.
class BillPaymentCashOut {
  const BillPaymentCashOut({required this.branchId, this.agentId});

  final String branchId;
  final String? agentId;
}

/// POS payment-type label for the account a supplier was paid from.
String billPaymentTypeLabel(String accountCode) => switch (accountCode) {
  '1020' => 'BANK CHECK',
  '1030' => 'MOBILE MONEY',
  _ => 'CASH',
};

/// `transactions` id of a supplier payment's cash-out: one per payment.
String billPaymentCashOutTxnId(String paymentId) => 'bill_pay_$paymentId';

/// A supplier payment as a completed cash-out, in the shape Capella writes
/// transactions. Marked [purchaseExpenseReceiptType] so neither ledger poster
/// books it: the payment already posted Dr Accounts Payable / Cr cash.
///
/// Times are local without an offset, like every other cash-out, because
/// report windows compare them as local wall-clock strings.
Map<String, dynamic> billPaymentCashOutRow({
  required BillPayment payment,
  required BillPaymentCashOut cashOut,
  required String supplierName,
  required String docNumber,
}) {
  final id = billPaymentCashOutTxnId(payment.id);
  final at = payment.paidAt.toLocal().toIso8601String();
  final supplier = supplierName.trim().isEmpty ? 'Supplier' : supplierName;
  final amount = payment.amount.toDouble();
  return {
    '_id': id,
    'id': id,
    'branchId': cashOut.branchId,
    'status': accountingSaleStatusCompleted,
    'transactionType': 'Supplier payment',
    'receiptType': purchaseExpenseReceiptType,
    'paymentType': billPaymentTypeLabel(payment.accountCode),
    'subTotal': amount,
    'cashReceived': amount,
    'customerChangeDue': 0.0,
    'remainingBalance': 0.0,
    'isIncome': false,
    'isExpense': true,
    'isOriginalTransaction': true,
    'agentId': cashOut.agentId,
    'customerName': supplier,
    'note': 'Payment to $supplier · bill $docNumber',
    'reference': 'PAY-$docNumber',
    'createdAt': at,
    'updatedAt': at,
    'lastTouched': at,
  };
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
    BillPaymentCashOut? cashOut,
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

    final id = paymentId ?? const Uuid().v4();
    final payment = BillPayment(
      id: id,
      businessId: businessId,
      billDocId: billDocId,
      amount: amount,
      accountCode: paymentAccount,
      paidAt: paidAt ?? DateTime.now(),
      paidBy: paidBy,
      cashbookTxnId:
          cashbookTxnId ??
          (cashOut == null ? null : billPaymentCashOutTxnId(id)),
    );
    await _ditto.upsertPartyDoc(
      billPaymentsCollection,
      payment.id,
      payment.toRow(),
    );

    final docNumber = (bill['doc_number'] ?? bill['docNumber'] ?? '')
        .toString();
    final party = (bill['party_name'] ?? bill['partyName'] ?? '').toString();
    if (cashOut != null && cashbookTxnId == null) {
      await _writeCashOut(
        payment: payment,
        cashOut: cashOut,
        supplierName: party,
        docNumber: docNumber,
      );
    }
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

  /// Where a payment on [billDocId] shows as a cash-out: the branch of the
  /// purchase the bill is for, else [fallbackBranchId]. Null for bills not
  /// raised from a purchase (no till was involved).
  Future<BillPaymentCashOut?> purchaseCashOut(
    String billDocId, {
    String? agentId,
    String? fallbackBranchId,
  }) async {
    final bill = await _bill(billDocId);
    final purchaseId =
        (bill?['purchase_id'] ?? bill?['purchaseId'])?.toString() ?? '';
    if (purchaseId.isEmpty) return null;
    final rows = await _ditto.queryCollection(
      'purchases',
      'SELECT * FROM purchases WHERE _id = :id',
      {'id': purchaseId},
    );
    final own = rows.isEmpty
        ? ''
        : (rows.first['branchId'] ?? rows.first['branch_id'] ?? '').toString();
    final branchId = own.isNotEmpty ? own : (fallbackBranchId ?? '');
    if (branchId.isEmpty) return null;
    return BillPaymentCashOut(branchId: branchId, agentId: agentId);
  }

  /// Gives a payment recorded without one (Books "Pay bill" before payments
  /// wrote cash-outs) its cash-out. Returns false when it already has one.
  Future<bool> backfillCashOut({
    required BillPayment payment,
    required BillPaymentCashOut cashOut,
  }) async {
    final txnId = payment.cashbookTxnId ?? billPaymentCashOutTxnId(payment.id);
    // Only our own cash-out id can be written here; a payment linked to some
    // other cashbook entry already reconciles the till.
    if (txnId != billPaymentCashOutTxnId(payment.id)) return false;
    final existing = await _ditto.queryCollection(
      'transactions',
      'SELECT * FROM transactions WHERE _id = :id',
      {'id': txnId},
    );
    if (existing.isNotEmpty) return false;
    final bill = await _bill(payment.billDocId);
    await _writeCashOut(
      payment: payment,
      cashOut: cashOut,
      supplierName: (bill?['party_name'] ?? bill?['partyName'] ?? '')
          .toString(),
      docNumber: (bill?['doc_number'] ?? bill?['docNumber'] ?? '').toString(),
    );
    if (payment.cashbookTxnId == null) {
      await _ditto.executeUpdate(billPaymentsCollection, payment.id, {
        'cashbook_txn_id': txnId,
        'cashbookTxnId': txnId,
      });
    }
    return true;
  }

  Future<void> _writeCashOut({
    required BillPayment payment,
    required BillPaymentCashOut cashOut,
    required String supplierName,
    required String docNumber,
  }) => _ditto.upsertPartyDoc(
    'transactions',
    billPaymentCashOutTxnId(payment.id),
    billPaymentCashOutRow(
      payment: payment,
      cashOut: cashOut,
      supplierName: supplierName,
      docNumber: docNumber,
    ),
  );

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
