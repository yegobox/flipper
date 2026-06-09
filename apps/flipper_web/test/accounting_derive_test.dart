import 'package:flipper_web/modules/accounting/data/accounting_derive.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('accounting derive', () {
    test('trial balance debits equal credits at 23420000', () {
      final tb = trialBalance();
      expect(tb.balanced, isTrue);
      expect(tb.totDr, 23420000);
      expect(tb.totCr, 23420000);
    });

    test('income statement net income is 1920000', () {
      final pl = incomeStatement();
      expect(pl.netRevenue, 7480000);
      expect(pl.grossProfit, 3280000);
      expect(pl.totalOpex, 1360000);
      expect(pl.netIncome, 1920000);
    });

    test('balance sheet balances', () {
      final bs = balanceSheet();
      expect(bs.totalAssets, 16840000);
      expect(bs.totalLiabEquity, 16840000);
      expect(bs.totalAssets, bs.totalLiabEquity);
    });

    test('money formats negatives in parentheses', () {
      expect(money(-1234), '(1,234)');
      expect(money(1234567), '1,234,567');
    });
  });
}
