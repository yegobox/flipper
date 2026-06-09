import 'package:flipper_web/modules/accounting/data/accounting_derive.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/default_chart_of_accounts_seed.dart';
import 'package:flutter_test/flutter_test.dart';

List<Account> _sampleAccounts() {
  return [
    const Account(
      code: '1010',
      name: 'Cash',
      type: AccountType.asset,
      sub: 'Current assets',
      normal: AccountNormal.debit,
      bal: 100000,
    ),
    const Account(
      code: '4010',
      name: 'Revenue',
      type: AccountType.income,
      sub: 'Operating income',
      normal: AccountNormal.credit,
      bal: 100000,
    ),
    const Account(
      code: '5010',
      name: 'COGS',
      type: AccountType.expense,
      sub: 'Cost of sales',
      normal: AccountNormal.debit,
      bal: 40000,
    ),
    const Account(
      code: '6010',
      name: 'Rent',
      type: AccountType.expense,
      sub: 'Operating expenses',
      normal: AccountNormal.debit,
      bal: 10000,
    ),
    ...defaultChartOfAccountsSeed.where(
      (a) => !{'1010', '4010', '5010', '6010'}.contains(a.code),
    ),
  ];
}

void main() {
  group('accounting derive', () {
    test('trial balance debits equal credits for balanced sample', () {
      final tb = trialBalance(_sampleAccounts());
      expect(tb.balanced, isTrue);
      expect(tb.totDr, tb.totCr);
    });

    test('income statement computes net income', () {
      final pl = incomeStatement(_sampleAccounts());
      expect(pl.netRevenue, 100000);
      expect(pl.netIncome, 100000 - 40000 - 10000);
    });

    test('balance sheet uses equity from COA', () {
      final bs = balanceSheet(_sampleAccounts());
      expect(bs.totalAssets, greaterThan(0));
    });

    test('money formats negatives in parentheses', () {
      expect(money(-1234), '(1,234)');
      expect(money(1234567), '1,234,567');
    });

    test('profitOrLossLabel follows IAS 1 wording', () {
      expect(profitOrLossLabel(100), 'Net income');
      expect(profitOrLossLabel(0), 'Net income');
      expect(profitOrLossLabel(-200), 'Net loss');
    });

    test('pendingJournalCount counts pending only', () {
      final journal = [
        const JournalEntry(
          id: 'JE-1',
          date: 'May 1',
          memo: 'A',
          ref: 'A',
          status: JournalStatus.pending,
          src: 'Manual',
          lines: [],
        ),
        const JournalEntry(
          id: 'JE-2',
          date: 'May 2',
          memo: 'B',
          ref: 'B',
          status: JournalStatus.posted,
          src: 'POS',
          lines: [],
        ),
      ];
      expect(pendingJournalCount(journal), 1);
    });
  });
}
