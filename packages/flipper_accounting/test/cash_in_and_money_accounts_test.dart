import 'package:flipper_accounting/accounting_models.dart';
import 'package:flipper_accounting/accounting_transaction_semantics.dart';
import 'package:flipper_accounting/transaction_to_accounts.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _cashIn({
  int sub = 100000,
  String? receiptType = 'Cash In',
  String transactionType = 'Owner deposit',
  String paymentType = 'CASH',
  bool isExpense = false,
  String id = 'c1',
}) => {
  'id': id,
  'status': 'completed',
  'subTotal': sub,
  'receiptType': ?receiptType,
  'transactionType': transactionType,
  'paymentType': paymentType,
  'isExpense': isExpense,
  'createdAt': '2026-10-10T09:00:00',
};

Map<String, dynamic> _sale(
  int sub, {
  String createdAt = '2026-10-11T09:00:00',
}) => {
  'id': 's-$sub',
  'status': 'completed',
  'subTotal': sub,
  'receiptType': 'NS',
  'transactionType': 'Sale',
  'paymentType': 'CASH',
  'createdAt': createdAt,
};

Map<String, dynamic> _cashOut(int sub) => {
  'id': 'o-$sub',
  'status': 'completed',
  'subTotal': sub,
  'receiptType': 'Cash Out',
  'transactionType': 'Rent',
  'paymentType': 'CASH',
  'isExpense': true,
  'createdAt': '2026-10-12T09:00:00',
};

Account _acct(String code, int bal) => Account(
  code: code,
  name: code,
  type: AccountType.asset,
  sub: 'Current assets',
  normal: AccountNormal.debit,
  bal: bal,
);

void main() {
  group('isAccountingCashIn', () {
    test('receiptType "Cash In" decides, whatever the category', () {
      expect(isAccountingCashIn(_cashIn()), isTrue);
      expect(
        isAccountingCashIn(_cashIn(transactionType: 'Loan received')),
        isTrue,
      );
    });

    test(
      'legacy NS rows count only with transactionType "Cash In" and not expense',
      () {
        expect(
          isAccountingCashIn(
            _cashIn(receiptType: 'NS', transactionType: 'Cash In'),
          ),
          isTrue,
        );
        expect(
          isAccountingCashIn(
            _cashIn(receiptType: null, transactionType: 'Cash In'),
          ),
          isTrue,
        );
        expect(
          isAccountingCashIn(
            _cashIn(
              receiptType: 'NS',
              transactionType: 'Cash In',
              isExpense: true,
            ),
          ),
          isFalse,
        );
      },
    );

    test('sales, refunds, Cash Out and purchase mirrors are not Cash In', () {
      expect(isAccountingCashIn(_sale(500)), isFalse);
      expect(isAccountingCashIn(_cashOut(500)), isFalse);
      expect(
        isAccountingCashIn(
          _cashIn(receiptType: 'NR', transactionType: 'Cash In'),
        ),
        isFalse,
      );
      expect(isAccountingCashIn(_cashIn(id: 'purchase_exp_1')), isFalse);
    });
  });

  group('TransactionToAccounts.toTrend', () {
    test(
      'Cash In is neither revenue nor expense; sales and Cash Out unchanged',
      () {
        final trend = TransactionToAccounts.toTrend([
          _cashIn(sub: 100000),
          _sale(20000),
          _cashOut(15000),
        ]);
        expect(trend, hasLength(1));
        expect(trend.single.rev, 20000);
        expect(trend.single.exp, 15000);
      },
    );
  });

  group('TransactionToAccounts.toJournal', () {
    test('Cash In posts Dr money account / Cr 3010, never revenue or COGS', () {
      final entry = TransactionToAccounts.toJournal(
        [_cashIn(sub: 50000, paymentType: 'MOBILE MONEY')],
        [
          {'transactionId': 'c1', 'splyAmt': 9000},
        ],
      ).single;
      expect(entry.src, 'Cash In');
      expect(entry.memo, 'Cash In · Owner deposit');
      expect(
        [for (final l in entry.lines) (l.ac, l.dr, l.cr)],
        [('1030', 50000, 0), ('3010', 0, 50000)],
      );
    });

    test('a sale still posts revenue', () {
      final entry = TransactionToAccounts.toJournal([
        _sale(20000),
      ], const []).single;
      expect(entry.src, 'POS');
      expect(entry.lines.any((l) => l.ac == '4010' && l.cr == 20000), isTrue);
    });
  });

  group('TransactionToAccounts.liquidBalances', () {
    test('cash, mobile money, bank in that order; missing accounts are 0', () {
      final balances = TransactionToAccounts.liquidBalances([
        _acct('1020', 700),
        _acct('1010', 105000),
        _acct('1200', 999),
      ]);
      expect(balances, [
        (code: '1010', bal: 105000),
        (code: '1030', bal: 0),
        (code: '1020', bal: 700),
      ]);
    });

    test('each bank and wallet account counts in its group', () {
      final balances = TransactionToAccounts.liquidBalances([
        _acct('1020', 700),
        _acct('1021', 50000),
        _acct('1022', -20000),
        _acct('1031', 3000),
        _acct('1010', 100),
      ]);
      expect(balances, [
        (code: '1010', bal: 100),
        (code: '1030', bal: 3000),
        (code: '1020', bal: 30700),
      ]);
    });

    test('the total is exactly the sum of the parts', () {
      final accounts = [
        _acct('1010', 105000),
        _acct('1030', -5000),
        _acct('1020', 700),
        _acct('1100', 123),
      ];
      final parts = TransactionToAccounts.liquidBalances(accounts);
      expect(
        TransactionToAccounts.cashAndBankTotal(accounts),
        parts.fold<int>(0, (s, b) => s + b.bal),
      );
      expect(TransactionToAccounts.cashAndBankTotal(accounts), 100700);
    });
  });
}
