import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/mapper/transaction_to_accounts.dart';
import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// Fixtures
// ---------------------------------------------------------------------------

Map<String, dynamic> _sale({
  String id = 'txn-1',
  int subTotal = 118000,
  int taxAmount = 18000,
  String paymentType = 'CASH',
  bool isLoan = false,
  int remainingBalance = 0,
  String status = 'completed',
  String createdAt = '2026-05-15T10:00:00.000Z',
}) => {
  'id': id,
  'status': status,
  'sub_total': subTotal,
  'tax_amount': taxAmount,
  'payment_type': paymentType,
  'is_expense': false,
  'is_income': true,
  'is_loan': isLoan,
  if (isLoan && remainingBalance > 0) 'remaining_balance': remainingBalance,
  'created_at': createdAt,
  'customer_name': 'Test Customer',
  'receipt_number': '001',
};

Map<String, dynamic> _expense({
  String id = 'exp-1',
  int subTotal = 50000,
  String paymentType = 'CASH',
  String createdAt = '2026-05-15T12:00:00.000Z',
  String? note,
}) => {
  'id': id,
  'status': 'completed',
  'sub_total': subTotal,
  'tax_amount': 0,
  'payment_type': paymentType,
  'is_expense': true,
  'is_income': false,
  'created_at': createdAt,
  'note': note ?? 'Rent',
};

Map<String, dynamic> _item({
  String transactionId = 'txn-1',
  double splyAmt = 70000,
}) => {
  'transaction_id': transactionId,
  'sply_amt': splyAmt,
  'qty': 1.0,
  'price': 100000.0,
};

// Camel-case variants (Ditto convention) to verify fallback parsing
Map<String, dynamic> _saleCamel({
  String id = 'txn-c1',
  int subTotal = 236000,
  int taxAmount = 36000,
  String paymentType = 'MoMo',
}) => {
  'id': id,
  'status': 'completed',
  'subTotal': subTotal,
  'taxAmount': taxAmount,
  'paymentType': paymentType,
  'isExpense': false,
  'isIncome': true,
  'isLoan': false,
  'createdAt': '2026-04-10T08:00:00.000Z',
};

Map<String, dynamic> _itemCamel({
  String transactionId = 'txn-c1',
  double splyAmt = 140000,
}) => {
  'transactionId': transactionId,
  'splyAmt': splyAmt,
};

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('TransactionToAccounts.deriveAccounts', () {
    test('net revenue = subTotal - taxAmount for a single cash sale', () {
      final accounts = TransactionToAccounts.deriveAccounts(
        [_sale(subTotal: 118000, taxAmount: 18000)],
        [],
      );
      final revenue = accounts.firstWhere((a) => a.code == '4010');
      expect(revenue.bal, 100000); // 118000 - 18000
    });

    test('VAT payable equals total tax across sales', () {
      final accounts = TransactionToAccounts.deriveAccounts(
        [
          _sale(id: 'a', subTotal: 118000, taxAmount: 18000),
          _sale(id: 'b', subTotal: 59000, taxAmount: 9000),
        ],
        [],
      );
      final vat = accounts.firstWhere((a) => a.code == '2100');
      expect(vat.bal, 27000);
    });

    test('cash account receives cash sales minus cash expenses', () {
      final accounts = TransactionToAccounts.deriveAccounts(
        [
          _sale(id: 's1', subTotal: 100000, paymentType: 'CASH'),
          _expense(id: 'e1', subTotal: 30000, paymentType: 'CASH'),
        ],
        [],
      );
      final cash = accounts.firstWhere((a) => a.code == '1010');
      expect(cash.bal, 70000);
    });

    test('MoMo sales route to account 1030', () {
      final accounts = TransactionToAccounts.deriveAccounts(
        [_sale(id: 'momo', subTotal: 50000, taxAmount: 0, paymentType: 'MoMo')],
        [],
      );
      final momo = accounts.firstWhere((a) => a.code == '1030');
      expect(momo.bal, 50000);
      // Cash account should be 0 / absent or 0
      final cash = accounts.firstWhere((a) => a.code == '1010');
      expect(cash.bal, 0);
    });

    test('COGS derived from item sply_amt', () {
      final accounts = TransactionToAccounts.deriveAccounts(
        [_sale()],
        [_item(splyAmt: 70000), _item(splyAmt: 30000)],
      );
      final cogs = accounts.firstWhere((a) => a.code == '5010');
      expect(cogs.bal, 100000);
    });

    test('accounts receivable uses open loan balance not full subtotal', () {
      final noLoan = TransactionToAccounts.deriveAccounts([_sale()], []);
      expect(noLoan.any((a) => a.code == '1100'), isFalse);

      final withLoan = TransactionToAccounts.deriveAccounts(
        [
          _sale(
            isLoan: true,
            status: 'parked',
            subTotal: 200000,
            remainingBalance: 75000,
            paymentType: 'CASH',
          ),
        ],
        [],
      );
      expect(withLoan.any((a) => a.code == '1100'), isTrue);
      expect(withLoan.firstWhere((a) => a.code == '1100').bal, 75000);
      // Collected portion hits cash, not full subtotal
      expect(withLoan.firstWhere((a) => a.code == '1010').bal, 125000);
    });

    test('static accounts fill codes not covered by derived accounts', () {
      const staticEquity = Account(
        code: '3010',
        name: "Owner's Capital",
        type: AccountType.equity,
        sub: 'Equity',
        normal: AccountNormal.credit,
        bal: 6000000,
      );
      final accounts = TransactionToAccounts.deriveAccounts(
        [_sale()],
        [],
        staticAccounts: [staticEquity],
      );
      expect(accounts.any((a) => a.code == '3010'), isTrue);
    });

    test('derived account beats static on same code', () {
      const staticRevenue = Account(
        code: '4010',
        name: 'Sales Revenue',
        type: AccountType.income,
        sub: 'Operating income',
        normal: AccountNormal.credit,
        bal: 999, // stale static
      );
      final accounts = TransactionToAccounts.deriveAccounts(
        [_sale(subTotal: 118000, taxAmount: 18000)],
        [],
        staticAccounts: [staticRevenue],
      );
      final rev = accounts.firstWhere((a) => a.code == '4010');
      expect(rev.bal, 100000); // derived, not 999
    });

    test('handles camelCase fields (Ditto convention)', () {
      final accounts = TransactionToAccounts.deriveAccounts(
        [_saleCamel(subTotal: 236000, taxAmount: 36000)],
        [_itemCamel(splyAmt: 140000)],
      );
      final rev = accounts.firstWhere((a) => a.code == '4010');
      expect(rev.bal, 200000); // 236000 - 36000
      final cogs = accounts.firstWhere((a) => a.code == '5010');
      expect(cogs.bal, 140000);
    });

    test('empty transactions produce zero-balance derived accounts', () {
      final accounts = TransactionToAccounts.deriveAccounts([], []);
      // All cash accounts should be 0
      for (final code in ['1010', '1020', '1030']) {
        final a = accounts.firstWhere((a) => a.code == code);
        expect(a.bal, 0);
      }
      final rev = accounts.firstWhere((a) => a.code == '4010');
      expect(rev.bal, 0);
    });
  });

  // -------------------------------------------------------------------------

  group('TransactionToAccounts.toJournal', () {
    test('cash sale produces Dr cash / Cr revenue / Cr VAT lines', () {
      final journal = TransactionToAccounts.toJournal(
        [_sale(subTotal: 118000, taxAmount: 18000, paymentType: 'CASH')],
        [],
      );
      expect(journal.length, 1);
      final entry = journal.first;
      expect(entry.status, JournalStatus.posted);
      expect(entry.src, 'POS');

      final dr = entry.lines.where((l) => l.dr > 0).toList();
      final cr = entry.lines.where((l) => l.cr > 0).toList();
      expect(dr.length, 1);
      expect(dr.first.ac, '1010'); // cash
      expect(dr.first.dr, 118000);
      expect(cr.any((l) => l.ac == '4010'), isTrue);
      expect(cr.any((l) => l.ac == '2100'), isTrue);
      expect(cr.firstWhere((l) => l.ac == '4010').cr, 100000);
      expect(cr.firstWhere((l) => l.ac == '2100').cr, 18000);
    });

    test('expense produces Dr expense / Cr cash lines', () {
      final journal = TransactionToAccounts.toJournal(
        [_expense(subTotal: 50000, paymentType: 'CASH')],
        [],
      );
      expect(journal.length, 1);
      final entry = journal.first;
      expect(entry.src, 'Expense');
      expect(entry.lines.length, 2);
      expect(entry.lines.any((l) => l.ac == '6000' && l.dr == 50000), isTrue);
      expect(entry.lines.any((l) => l.ac == '1010' && l.cr == 50000), isTrue);
    });

    test('MoMo sale routes debit to account 1030', () {
      final journal = TransactionToAccounts.toJournal(
        [_sale(subTotal: 59000, taxAmount: 9000, paymentType: 'MoMo')],
        [],
      );
      final dr = journal.first.lines.firstWhere((l) => l.dr > 0);
      expect(dr.ac, '1030');
    });

    test('no VAT line when taxAmount is zero', () {
      final journal = TransactionToAccounts.toJournal(
        [_sale(taxAmount: 0, subTotal: 100000)],
        [],
      );
      expect(journal.first.lines.any((l) => l.ac == '2100'), isFalse);
    });

    test('each transaction becomes exactly one journal entry', () {
      final txns = [
        _sale(id: 'a'), _sale(id: 'b'), _expense(id: 'c'),
      ];
      final journal = TransactionToAccounts.toJournal(txns, []);
      expect(journal.length, 3);
    });

    test('empty input returns empty list', () {
      expect(TransactionToAccounts.toJournal([], []), isEmpty);
    });

    test('partial loan sale debits cash and AR with balanced entry', () {
      final journal = TransactionToAccounts.toJournal(
        [
          _sale(
            isLoan: true,
            status: 'parked',
            subTotal: 118000,
            taxAmount: 18000,
            remainingBalance: 50000,
            paymentType: 'CASH',
          ),
        ],
        [],
      );
      final entry = journal.single;
      final totalDr =
          entry.lines.fold<int>(0, (s, l) => s + l.dr);
      final totalCr =
          entry.lines.fold<int>(0, (s, l) => s + l.cr);
      expect(totalDr, totalCr);
      expect(totalDr, 118000);

      expect(
        entry.lines.any((l) => l.ac == '1010' && l.dr == 68000),
        isTrue,
      );
      expect(
        entry.lines.any((l) => l.ac == '1100' && l.dr == 50000),
        isTrue,
      );
      expect(
        entry.lines.any((l) => l.ac == '4010' && l.cr == 100000),
        isTrue,
      );
      expect(
        entry.lines.any((l) => l.ac == '2100' && l.cr == 18000),
        isTrue,
      );
    });

    test('credit-only loan debits AR for full sale amount', () {
      final journal = TransactionToAccounts.toJournal(
        [
          _sale(
            isLoan: true,
            status: 'parked',
            subTotal: 100000,
            taxAmount: 0,
            remainingBalance: 100000,
            paymentType: 'CREDIT',
          ),
        ],
        [],
      );
      final entry = journal.single;
      expect(entry.lines.any((l) => l.ac == '1100' && l.dr == 100000), isTrue);
      expect(entry.lines.any((l) => l.dr > 0 && l.ac == '1010'), isFalse);
      expect(entry.lines.any((l) => l.ac == '4010' && l.cr == 100000), isTrue);
    });
  });

  // -------------------------------------------------------------------------

  group('TransactionToAccounts.toTrend', () {
    test('aggregates revenue and expenses by month', () {
      final txns = [
        _sale(id: 'a', subTotal: 100000, createdAt: '2026-05-01T00:00:00Z'),
        _sale(id: 'b', subTotal: 200000, createdAt: '2026-05-15T00:00:00Z'),
        _expense(id: 'c', subTotal: 50000, createdAt: '2026-05-10T00:00:00Z'),
        _sale(id: 'd', subTotal: 80000, createdAt: '2026-04-20T00:00:00Z'),
      ];
      final trend = TransactionToAccounts.toTrend(txns);
      final may = trend.firstWhere((t) => t.m == 'May');
      final apr = trend.firstWhere((t) => t.m == 'Apr');
      expect(may.rev, 300000);
      expect(may.exp, 50000);
      expect(apr.rev, 80000);
      expect(apr.exp, 0);
    });

    test('returns at most 6 months', () {
      final txns = List.generate(
        24,
        (i) => _sale(
          id: 'tx$i',
          subTotal: 10000,
          createdAt: '2026-${(i % 12 + 1).toString().padLeft(2, '0')}-01T00:00:00Z',
        ),
      );
      final trend = TransactionToAccounts.toTrend(txns);
      expect(trend.length, lessThanOrEqualTo(6));
    });

    test('empty list returns empty trend', () {
      expect(TransactionToAccounts.toTrend([]), isEmpty);
    });
  });

  // -------------------------------------------------------------------------

  group('TransactionToAccounts.cashAndBankTotal', () {
    test('sums balances of accounts 1010, 1020, 1030', () {
      const accounts = [
        Account(code: '1010', name: 'Cash', type: AccountType.asset, sub: 'Current assets', normal: AccountNormal.debit, bal: 100),
        Account(code: '1020', name: 'Bank', type: AccountType.asset, sub: 'Current assets', normal: AccountNormal.debit, bal: 200),
        Account(code: '1030', name: 'MoMo', type: AccountType.asset, sub: 'Current assets', normal: AccountNormal.debit, bal: 300),
        Account(code: '4010', name: 'Revenue', type: AccountType.income, sub: 'Operating income', normal: AccountNormal.credit, bal: 999),
      ];
      expect(TransactionToAccounts.cashAndBankTotal(accounts), 600);
    });

    test('returns 0 when no cash accounts present', () {
      expect(TransactionToAccounts.cashAndBankTotal([]), 0);
    });
  });
}
