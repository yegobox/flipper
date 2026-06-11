import 'package:flipper_accounting/accounting_models.dart';
import 'package:flipper_accounting/accounting_transaction_semantics.dart';

/// Maps raw Supabase / Ditto row maps to the accounting model types used by
/// [accounting_derive.dart].
///
/// Field access uses `??` fallbacks to handle both naming conventions:
///   - snake_case  (Supabase / data-connector output)
///   - camelCase   (Ditto document convention)
///
/// All monetary values are stored as [int] (minor units, e.g. RWF centimes or
/// whole RWF depending on business configuration).  The mapper rounds doubles
/// to ints using [num.round].
///
/// **Accrual principle:** revenue and VAT are recognized at sale time
/// (`completed` or `parked`). Collected cash debits liquid accounts; unpaid
/// loan/credit balances debit Accounts Receivable (1100).
class TransactionToAccounts {
  TransactionToAccounts._();

  static const _arCode = '1100';
  static const _revenueCode = '4010';
  static const _vatCode = '2100';
  static const _opexCode = '6000';
  static const _cogsCode = '5010';
  static const _inventoryCode = '1200';

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Derive [Account] balances from finalized transaction rows + line items.
  static List<Account> deriveAccounts(
    List<Map<String, dynamic>> transactions,
    List<Map<String, dynamic>> items, {
    List<Account> staticAccounts = const [],
  }) {
    final recognized =
        transactions.where(isAccountingRecognizedTransaction).toList();
    final sales = recognized.where((t) => !isAccountingExpense(t)).toList();
    final expenses = recognized.where(isAccountingExpense).toList();

    // Revenue & VAT (full sale amount at recognition — accrual)
    final grossRevenue = _sumSubTotal(sales);
    final vatTotal = _sumTax(sales);
    final netRevenue = grossRevenue - vatTotal;

    // Liquid assets: collected portions only (not full subtotal on loans)
    var cashBal = 0;
    var bankBal = 0;
    var momoBal = 0;
    for (final s in sales) {
      final collected = accountingCollectedAmount(s);
      if (collected <= 0) continue;
      switch (accountingLiquidAccountCode(s)) {
        case '1020':
          bankBal += collected;
        case '1030':
          momoBal += collected;
        default:
          cashBal += collected;
      }
    }

    for (final e in expenses) {
      final sub = accountingSubTotal(e);
      switch (accountingLiquidAccountCode(e)) {
        case '1020':
          bankBal -= sub;
        case '1030':
          momoBal -= sub;
        default:
          cashBal -= sub;
      }
    }

    // Open AR = sum of remaining balances on loan sales
    final arBalance = sales
        .where(isOpenReceivable)
        .fold<int>(0, (s, t) => s + accountingRemainingBalance(t));

    final cogs = _sumField(items, 'sply_amt', 'splyAmt');
    final opex = _sumSubTotal(expenses);

    final derived = <Account>[
      Account(
        code: '1010',
        name: 'Cash on Hand',
        type: AccountType.asset,
        sub: 'Current assets',
        normal: AccountNormal.debit,
        bal: cashBal.clamp(0, double.maxFinite).toInt(),
      ),
      Account(
        code: '1020',
        name: 'Bank',
        type: AccountType.asset,
        sub: 'Current assets',
        normal: AccountNormal.debit,
        bal: bankBal.clamp(0, double.maxFinite).toInt(),
      ),
      Account(
        code: '1030',
        name: 'Mobile Money (MoMo)',
        type: AccountType.asset,
        sub: 'Current assets',
        normal: AccountNormal.debit,
        bal: momoBal.clamp(0, double.maxFinite).toInt(),
      ),
      if (arBalance > 0)
        Account(
          code: _arCode,
          name: 'Accounts Receivable',
          type: AccountType.asset,
          sub: 'Current assets',
          normal: AccountNormal.debit,
          bal: arBalance,
        ),
      Account(
        code: _revenueCode,
        name: 'Sales Revenue',
        type: AccountType.income,
        sub: 'Operating income',
        normal: AccountNormal.credit,
        bal: netRevenue,
      ),
      Account(
        code: _vatCode,
        name: 'VAT Payable',
        type: AccountType.liability,
        sub: 'Current liabilities',
        normal: AccountNormal.credit,
        bal: vatTotal,
      ),
      if (cogs > 0)
        Account(
          code: '5010',
          name: 'Cost of Goods Sold',
          type: AccountType.expense,
          sub: 'Cost of sales',
          normal: AccountNormal.debit,
          bal: cogs,
        ),
      if (opex > 0)
        Account(
          code: _opexCode,
          name: 'Operating Expenses',
          type: AccountType.expense,
          sub: 'Operating expenses',
          normal: AccountNormal.debit,
          bal: opex,
        ),
    ];

    final derivedCodes = {for (final a in derived) a.code};
    return [
      ...derived,
      ...staticAccounts.where((a) => !derivedCodes.contains(a.code)),
    ];
  }

  /// Convert finalized transactions into balanced double-entry [JournalEntry]
  /// records (debits = credits).
  static List<JournalEntry> toJournal(
    List<Map<String, dynamic>> transactions,
    List<Map<String, dynamic>> items,
  ) {
    final itemsByTxn = _groupItemsByTransaction(items);
    return [
      for (final txn in transactions.where(isAccountingRecognizedTransaction))
        _txnToEntry(txn, itemsByTxn[_id(txn)] ?? []),
    ];
  }

  /// Entry for a single loan repayment event: Dr liquid account / Cr AR.
  ///
  /// The sale entry already carries the full at-sale split (collected +
  /// open AR), so each later payment only moves the paid amount out of AR.
  static JournalEntry paymentToEntry({
    required Map<String, dynamic> txn,
    required int amount,
    required String dateIso,
  }) {
    final id = _id(txn);
    final ref =
        (txn['receipt_number'] ?? txn['receiptNumber'])?.toString() ??
        (txn['reference'] as String?) ??
        id.substring(0, id.length.clamp(0, 8));
    final customer =
        txn['customer_name'] ?? txn['customerName'] ?? ref;
    return JournalEntry(
      id: 'JE-${ref.substring(0, ref.length.clamp(0, 8)).toUpperCase()}-P',
      date: _formatDate(dateIso),
      memo: 'Loan payment · $customer',
      ref: ref,
      status: JournalStatus.posted,
      src: 'POS',
      lines: [
        JournalLine(ac: accountingLiquidAccountCode(txn), dr: amount),
        JournalLine(ac: _arCode, cr: amount),
      ],
    );
  }

  static List<TrendPoint> toTrend(List<Map<String, dynamic>> transactions) {
    final monthly = <String, ({int rev, int exp})>{};
    final order = <String>[];

    for (final txn in transactions.where(isAccountingRecognizedTransaction)) {
      final dt = _parseDate(txn['created_at'] ?? txn['createdAt']);
      if (dt == null) continue;
      final key = '${dt.year}-${dt.month.toString().padLeft(2, '0')}';
      if (!monthly.containsKey(key)) {
        monthly[key] = (rev: 0, exp: 0);
        order.add(key);
      }
      final sub = accountingSubTotal(txn);
      final cur = monthly[key]!;
      monthly[key] = isAccountingExpense(txn)
          ? (rev: cur.rev, exp: cur.exp + sub)
          : (rev: cur.rev + sub, exp: cur.exp);
    }

    order.sort();
    return order.reversed.take(6).toList().reversed.map((key) {
      final dt = DateTime.parse('$key-01');
      final data = monthly[key]!;
      return TrendPoint(m: _monthAbbr(dt.month), rev: data.rev, exp: data.exp);
    }).toList();
  }

  static int cashAndBankTotal(List<Account> accounts) {
    return accounts
        .where((a) => {'1010', '1020', '1030'}.contains(a.code))
        .fold(0, (s, a) => s + a.bal);
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  static Map<String, List<Map<String, dynamic>>> _groupItemsByTransaction(
    List<Map<String, dynamic>> items,
  ) {
    final map = <String, List<Map<String, dynamic>>>{};
    for (final item in items) {
      final tid =
          item['transaction_id'] as String? ?? item['transactionId'] as String?;
      if (tid == null) continue;
      map.putIfAbsent(tid, () => []).add(item);
    }
    return map;
  }

  static JournalEntry _txnToEntry(
    Map<String, dynamic> txn,
    List<Map<String, dynamic>> items,
  ) {
    final id = _id(txn);
    final sub = accountingSubTotal(txn);
    final tax = accountingTaxAmount(txn);
    final netRev = sub - tax;
    final ref =
        (txn['receipt_number'] ?? txn['receiptNumber'])?.toString() ??
        (txn['reference'] as String?) ??
        id.substring(0, id.length.clamp(0, 8));
    final dateStr = _formatDate(txn['created_at'] ?? txn['createdAt']);
    final isExp = isAccountingExpense(txn);
    final memo = isExp
        ? 'Expense · ${txn['note'] ?? txn['reference'] ?? ref}'
        : 'Sale · ${txn['customer_name'] ?? txn['customerName'] ?? ref}';

    // Cost of goods sold for the sale, summed from the line-item supply cost.
    final cogs = isExp ? 0 : _sumField(items, 'sply_amt', 'splyAmt');

    final lines = isExp
        ? _expenseLines(sub, accountingLiquidAccountCode(txn))
        : _saleLines(txn, sub, netRev, tax, cogs);

    return JournalEntry(
      id: 'JE-${ref.substring(0, ref.length.clamp(0, 8)).toUpperCase()}',
      date: dateStr,
      memo: memo,
      ref: ref,
      status: JournalStatus.posted,
      src: isExp ? 'Expense' : 'POS',
      lines: lines,
    );
  }

  /// Dr expense / Cr liquid account.
  static List<JournalLine> _expenseLines(int sub, String liquidAc) => [
        JournalLine(ac: _opexCode, dr: sub),
        JournalLine(ac: liquidAc, cr: sub),
      ];

  /// Accrual sale: Dr cash (collected) + Dr AR (open) / Cr revenue / Cr VAT,
  /// plus the matching cost entry Dr COGS / Cr Inventory when item cost is known.
  ///
  /// Both halves are self-balancing, so the compound entry stays balanced
  /// (total debits == total credits) regardless of whether [cogs] is present.
  static List<JournalLine> _saleLines(
    Map<String, dynamic> txn,
    int sub,
    int netRev,
    int tax,
    int cogs,
  ) {
    final collected = accountingCollectedAmount(txn);
    final ar = isOpenReceivable(txn) ? accountingRemainingBalance(txn) : 0;
    final liquidAc = accountingLiquidAccountCode(txn);

    final debits = <JournalLine>[];
    if (collected > 0) {
      debits.add(JournalLine(ac: liquidAc, dr: collected));
    }
    if (ar > 0) {
      debits.add(JournalLine(ac: _arCode, dr: ar));
    }
    // Fully paid non-loan: entire subtotal to liquid (fallback if both zero)
    if (debits.isEmpty && sub > 0) {
      debits.add(JournalLine(ac: liquidAc, dr: sub));
    }

    return [
      ...debits,
      JournalLine(ac: _revenueCode, cr: netRev),
      if (tax > 0) JournalLine(ac: _vatCode, cr: tax),
      // Matching principle: recognize cost of the sale and relieve inventory.
      if (cogs > 0) ...[
        JournalLine(ac: _cogsCode, dr: cogs),
        JournalLine(ac: _inventoryCode, cr: cogs),
      ],
    ];
  }

  static String _id(Map<String, dynamic> row) =>
      (row['id'] ?? row['_id'] ?? '').toString();

  static int _sumSubTotal(List<Map<String, dynamic>> rows) =>
      rows.fold(0, (s, r) => s + accountingSubTotal(r));

  static int _sumTax(List<Map<String, dynamic>> rows) =>
      rows.fold(0, (s, r) => s + accountingTaxAmount(r));

  static int _sumField(
    List<Map<String, dynamic>> rows,
    String snakeKey,
    String camelKey,
  ) =>
      rows.fold(0, (s, r) => s + _rawInt(r[snakeKey] ?? r[camelKey]));

  static int _rawInt(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.round();
    return int.tryParse(v.toString()) ?? 0;
  }

  static String _formatDate(dynamic raw) {
    final dt = _parseDate(raw);
    if (dt == null) return '';
    return '${_monthAbbr(dt.month)} ${dt.day}';
  }

  static DateTime? _parseDate(dynamic raw) {
    if (raw is String) return DateTime.tryParse(raw);
    if (raw is DateTime) return raw;
    return null;
  }

  static String _monthAbbr(int m) => const [
        '',
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ][m];
}
