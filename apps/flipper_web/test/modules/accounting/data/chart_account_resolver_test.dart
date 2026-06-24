import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/chart_account_resolver.dart';
import 'package:flipper_web/modules/accounting/data/default_chart_of_accounts_seed.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChartAccountResolver', () {
    late ChartAccountResolver resolver;

    setUp(() {
      resolver = ChartAccountResolver(defaultChartOfAccountsSeed);
    });

    test('resolves standard roles from default COA', () {
      expect(resolver.cashOnHand, '1010');
      expect(resolver.bank, '1020');
      expect(resolver.receivable, '1100');
      expect(resolver.payable, '2010');
      expect(resolver.salesRevenue, '4010');
      expect(resolver.vatPayable, '2100');
    });

    test('matches by name when codes differ', () {
      final custom = [
        const Account(
          code: 'A100',
          name: 'Accounts Receivable',
          type: AccountType.asset,
          sub: 'Current assets',
          normal: AccountNormal.debit,
          bal: 0,
        ),
        const Account(
          code: 'L200',
          name: 'Accounts Payable',
          type: AccountType.liability,
          sub: 'Current liabilities',
          normal: AccountNormal.credit,
          bal: 0,
        ),
      ];
      final r = ChartAccountResolver(custom);
      expect(r.receivable, 'A100');
      expect(r.payable, 'L200');
    });
  });
}
