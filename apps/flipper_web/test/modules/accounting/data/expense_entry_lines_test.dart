import 'package:flipper_web/modules/accounting/data/chart_account_resolver.dart';
import 'package:flipper_web/modules/accounting/data/default_chart_of_accounts_seed.dart';
import 'package:flipper_web/modules/accounting/data/expense_entry_posting.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('buildExpenseJournalLines', () {
    test('posts Dr expense and Cr funding for the same amount', () {
      final lines = buildExpenseJournalLines(
        expenseCode: '6010',
        fundingCode: '1020',
        amount: 50000,
      );

      expect(lines, hasLength(2));
      expect(lines[0].ac, '6010');
      expect(lines[0].dr, 50000);
      expect(lines[0].cr, 0);
      expect(lines[1].ac, '1020');
      expect(lines[1].cr, 50000);
      expect(lines[1].dr, 0);

      final totalDr = lines.fold<int>(0, (s, l) => s + l.dr);
      final totalCr = lines.fold<int>(0, (s, l) => s + l.cr);
      expect(totalDr, totalCr);
    });
  });

  group('fundingCodeForPaymentMethod', () {
    final roles = ChartAccountResolver(defaultChartOfAccountsSeed);

    test('maps cash, bank, and momo to liquid accounts', () {
      expect(
        fundingCodeForPaymentMethod(roles, ExpensePaymentMethod.cash),
        '1010',
      );
      expect(
        fundingCodeForPaymentMethod(roles, ExpensePaymentMethod.bank),
        '1020',
      );
      expect(
        fundingCodeForPaymentMethod(roles, ExpensePaymentMethod.momo),
        '1030',
      );
    });
  });

  group('suggestNextExpenseCode', () {
    test('skips used 60xx codes', () {
      expect(
        suggestNextExpenseCode(defaultChartOfAccountsSeed),
        '6060',
      );
    });
  });
}
