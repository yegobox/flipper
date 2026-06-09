import 'package:flipper_web/modules/accounting/data/accounting_models.dart';

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
/// Static accounts that cannot be derived from transaction data (equity, fixed
/// assets, long-term liabilities) are accepted via [staticAccounts] so callers
/// can merge in a configured chart of accounts without changing this class.
class TransactionToAccounts {
  TransactionToAccounts._();

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Derive [Account] balances from completed transaction rows + their line
  /// items.  Pass [staticAccounts] to merge in accounts that cannot be derived
  /// (e.g. equity, fixed assets). Derived accounts win on code collision.
  static List<Account> deriveAccounts(
    List<Map<String, dynamic>> transactions,
    List<Map<String, dynamic>> items, {
    List<Account> staticAccounts = const [],
  }) {
    final sales = transactions.where(_isSale).toList();
    final expenses = transactions.where(_isExpense).toList();

    // Revenue & VAT
    final grossRevenue = _sumField(sales, 'sub_total', 'subTotal');
    final vatTotal = _sumField(sales, 'tax_amount', 'taxAmount');
    final netRevenue = grossRevenue - vatTotal;

    // Cash accounts by payment type
    final cashSales = _sumByPayType(sales, {'cash'});
    final bankSales = _sumByPayType(sales, {'bank', 'card', 'transfer'});
    final momoSales = _sumByPayType(sales, {'momo', 'mobile_money', 'mobile money'});

    final cashExp = _sumByPayType(expenses, {'cash'});
    final bankExp = _sumByPayType(expenses, {'bank', 'card'});
    final momoExp = _sumByPayType(expenses, {'momo', 'mobile_money', 'mobile money'});

    // Accounts Receivable (loan / credit sales)
    final arBalance = _sumField(
      sales.where(_isLoan).toList(),
      'sub_total',
      'subTotal',
    );

    // COGS from item supply amounts
    final cogs = _sumField(items, 'sply_amt', 'splyAmt');

    // Operating expenses (single bucket; expanded via staticAccounts later)
    final opex = _sumField(expenses, 'sub_total', 'subTotal');

    final derived = <Account>[
      Account(
        code: '1010',
        name: 'Cash on Hand',
        type: AccountType.asset,
        sub: 'Current assets',
        normal: AccountNormal.debit,
        bal: (cashSales - cashExp).clamp(0, double.maxFinite).toInt(),
      ),
      Account(
        code: '1020',
        name: 'Bank',
        type: AccountType.asset,
        sub: 'Current assets',
        normal: AccountNormal.debit,
        bal: (bankSales - bankExp).clamp(0, double.maxFinite).toInt(),
      ),
      Account(
        code: '1030',
        name: 'Mobile Money (MoMo)',
        type: AccountType.asset,
        sub: 'Current assets',
        normal: AccountNormal.debit,
        bal: (momoSales - momoExp).clamp(0, double.maxFinite).toInt(),
      ),
      if (arBalance > 0)
        Account(
          code: '1100',
          name: 'Accounts Receivable',
          type: AccountType.asset,
          sub: 'Current assets',
          normal: AccountNormal.debit,
          bal: arBalance,
        ),
      Account(
        code: '4010',
        name: 'Sales Revenue',
        type: AccountType.income,
        sub: 'Operating income',
        normal: AccountNormal.credit,
        bal: netRevenue,
      ),
      Account(
        code: '2100',
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
          code: '6000',
          name: 'Operating Expenses',
          type: AccountType.expense,
          sub: 'Operating expenses',
          normal: AccountNormal.debit,
          bal: opex,
        ),
    ];

    // Merge: derived wins, static fills gaps
    final derivedCodes = {for (final a in derived) a.code};
    return [
      ...derived,
      ...staticAccounts.where((a) => !derivedCodes.contains(a.code)),
    ];
  }

  /// Convert completed transactions into double-entry [JournalEntry] records.
  ///
  /// Each sale:  Dr cash-account (by payment type) / Cr revenue / Cr VAT
  /// Each expense: Dr expense / Cr cash-account
  static List<JournalEntry> toJournal(
    List<Map<String, dynamic>> transactions,
    List<Map<String, dynamic>> items,
  ) {
    final itemsByTxn = _groupItemsByTransaction(items);
    return [
      for (final txn in transactions)
        _txnToEntry(txn, itemsByTxn[_id(txn)] ?? []),
    ];
  }

  /// Aggregate transactions into monthly [TrendPoint] records (last 6 months,
  /// oldest first).
  static List<TrendPoint> toTrend(List<Map<String, dynamic>> transactions) {
    final monthly = <String, ({int rev, int exp})>{};
    final order = <String>[];

    for (final txn in transactions) {
      final dt = _parseDate(txn['created_at'] ?? txn['createdAt']);
      if (dt == null) continue;
      final key = '${dt.year}-${dt.month.toString().padLeft(2, '0')}';
      if (!monthly.containsKey(key)) {
        monthly[key] = (rev: 0, exp: 0);
        order.add(key);
      }
      final sub = _rawInt(txn['sub_total'] ?? txn['subTotal']);
      final cur = monthly[key]!;
      monthly[key] = _isExpense(txn)
          ? (rev: cur.rev, exp: cur.exp + sub)
          : (rev: cur.rev + sub, exp: cur.exp);
    }

    // Sort ascending, take last 6
    order.sort();
    return order.reversed.take(6).toList().reversed.map((key) {
      final dt = DateTime.parse('$key-01');
      final data = monthly[key]!;
      return TrendPoint(m: _monthAbbr(dt.month), rev: data.rev, exp: data.exp);
    }).toList();
  }

  /// Sum cash + bank + MoMo balances from a derived account list.
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
    final sub = _rawInt(txn['sub_total'] ?? txn['subTotal']);
    final tax = _rawInt(txn['tax_amount'] ?? txn['taxAmount']);
    final netRev = sub - tax;
    final payType = (txn['payment_type'] ?? txn['paymentType'] ?? 'CASH')
        .toString();
    final cashAc = _payTypeToAccount(payType);
    final ref =
        (txn['receipt_number'] ?? txn['receiptNumber'])?.toString() ??
        (txn['reference'] as String?) ??
        id.substring(0, id.length.clamp(0, 8));
    final dateStr = _formatDate(txn['created_at'] ?? txn['createdAt']);
    final isExp = _isExpense(txn);
    final memo = isExp
        ? 'Expense · ${txn['note'] ?? txn['reference'] ?? ref}'
        : 'Sale · ${txn['customer_name'] ?? txn['customerName'] ?? ref}';

    final lines = isExp
        ? [JournalLine(ac: '6000', dr: sub), JournalLine(ac: cashAc, cr: sub)]
        : [
            JournalLine(ac: cashAc, dr: sub),
            JournalLine(ac: '4010', cr: netRev),
            if (tax > 0) JournalLine(ac: '2100', cr: tax),
          ];

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

  // --- field readers ---

  static String _id(Map<String, dynamic> row) =>
      (row['id'] ?? row['_id'] ?? '').toString();

  static int _rawInt(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.round();
    return int.tryParse(v.toString()) ?? 0;
  }

  static int _sumField(
    List<Map<String, dynamic>> rows,
    String snakeKey,
    String camelKey,
  ) =>
      rows.fold(0, (s, r) => s + _rawInt(r[snakeKey] ?? r[camelKey]));

  static int _sumByPayType(
    List<Map<String, dynamic>> rows,
    Set<String> normalised,
  ) =>
      rows
          .where((r) {
            final pt = (r['payment_type'] ?? r['paymentType'] ?? '')
                .toString()
                .toLowerCase()
                .replaceAll('_', ' ');
            return normalised.any((n) => pt.contains(n));
          })
          .fold(0, (s, r) => s + _rawInt(r['sub_total'] ?? r['subTotal']));

  // --- predicates ---

  static bool _isSale(Map<String, dynamic> t) => !_isExpense(t);

  static bool _isExpense(Map<String, dynamic> t) =>
      t['is_expense'] == true || t['isExpense'] == true;

  static bool _isLoan(Map<String, dynamic> t) =>
      t['is_loan'] == true || t['isLoan'] == true;

  // --- formatters ---

  static String _payTypeToAccount(String payType) {
    final p = payType.toLowerCase();
    if (p.contains('momo') || p.contains('mobile')) return '1030';
    if (p.contains('bank') || p.contains('card') || p.contains('transfer')) {
      return '1020';
    }
    return '1010';
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

