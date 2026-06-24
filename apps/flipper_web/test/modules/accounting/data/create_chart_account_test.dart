import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/chart_account_resolver.dart';
import '../../../helpers/fake_accounting_ledger_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('createChartOfAccount', () {
    test('adds account and exposes it via expenseCategories', () async {
      final repo = FakeAccountingLedgerRepository();
      const businessId = 'biz-1';

      await repo.createChartOfAccount(
        businessId: businessId,
        account: const Account(
          code: '6060',
          name: 'Office Supplies',
          type: AccountType.expense,
          sub: 'Operating expenses',
          normal: AccountNormal.debit,
          bal: 0,
        ),
      );

      final coa = await repo.watchChartOfAccounts(businessId: businessId).first;
      final categories = ChartAccountResolver(coa).expenseCategories;

      expect(categories.any((a) => a.code == '6060'), isTrue);
      expect(repo.lastCreatedAccount?.name, 'Office Supplies');
    });

    test('rejects duplicate account codes', () async {
      final repo = FakeAccountingLedgerRepository();
      const businessId = 'biz-1';
      const account = Account(
        code: '6010',
        name: 'Duplicate Rent',
        type: AccountType.expense,
        sub: 'Operating expenses',
        normal: AccountNormal.debit,
        bal: 0,
      );

      expect(
        () => repo.createChartOfAccount(businessId: businessId, account: account),
        throwsA(isA<StateError>()),
      );
    });
  });
}
