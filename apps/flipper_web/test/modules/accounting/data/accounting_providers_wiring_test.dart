import 'package:flipper_web/core/analytics/analytics_provider.dart';
import 'package:flipper_web/core/supabase_provider.dart';
import 'package:flipper_web/modules/accounting/data/accounting_backend_config.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/data/repository/ditto_accounting_ledger_repository.dart';
import 'package:flipper_web/modules/accounting/data/repository/supabase_accounting_ledger_repository.dart';
import 'package:flipper_web/modules/accounting/data/services/accounting_bootstrap_service.dart';
import 'package:flipper_web/modules/accounting/data/services/bank_statement_service.dart';
import 'package:flipper_web/modules/accounting/data/services/journal_approval_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show SupabaseClient;

import '../../../helpers/accounting_unit_test_overrides.dart';
import '../../../helpers/fake_accounting_ledger_repository.dart';
import '../../../helpers/fake_accounting_repository.dart';
import '../../../helpers/fake_product_analytics.dart';

class _MockSupabaseClient extends Mock implements SupabaseClient {}

/// Records which transactions the items were fetched for.
class _ItemsRepository extends FakeAccountingRepository {
  _ItemsRepository({super.transactions, super.items});

  final asked = <List<String>>[];

  @override
  Future<List<Map<String, dynamic>>> fetchTransactionItems({
    required List<String> transactionIds,
  }) {
    asked.add(transactionIds);
    return super.fetchTransactionItems(transactionIds: transactionIds);
  }
}

class _InventoryLedger extends FakeAccountingLedgerRepository {
  final branches = <String>[];

  @override
  Future<int> fetchInventoryValue({required String branchId}) async {
    branches.add(branchId);
    return 4200;
  }
}

ProviderContainer _container(List<Override> overrides) {
  final container = ProviderContainer(overrides: overrides);
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('no journal approval is pending until one is chosen', () {
    expect(_container([]).read(approvalActionsProvider), isEmpty);
  });

  test('statement and approval services report to product analytics', () {
    final container = _container([
      productAnalyticsProvider.overrideWithValue(FakeProductAnalytics()),
    ]);
    expect(
      container.read(bankStatementServiceProvider),
      isA<BankStatementService>(),
    );
    expect(
      container.read(journalApprovalServiceProvider),
      isA<JournalApprovalService>(),
    );
  });

  test('the ledger repository follows the backend strategy', () {
    final ditto = _container([
      accountingBackendStrategyProvider.overrideWithValue(
        AccountingBackendStrategy.ditto,
      ),
    ]);
    expect(
      ditto.read(accountingLedgerRepositoryProvider),
      isA<DittoAccountingLedgerRepository>(),
    );

    final supabase = _container([
      ...accountingUnitTestOverrides(),
      supabaseProvider.overrideWithValue(_MockSupabaseClient()),
    ]);
    expect(
      supabase.read(accountingLedgerRepositoryProvider),
      isA<SupabaseAccountingLedgerRepository>(),
    );
  });

  test(
    'an unreachable bootstrap server falls back to the offline path',
    () async {
      var offline = 0;
      kickoffAccountingServerBootstrap(
        AccountingBootstrapService(
          baseUrl: 'http://connector.test',
          client: MockClient((_) async => throw http.ClientException('down')),
        ),
        'biz',
        onOffline: () => offline++,
      );
      await pumpEventQueue();
      expect(offline, 1);
    },
  );

  test('transaction streams stay empty until Ditto is ready', () async {
    final container = _container([
      accountingBackendStrategyProvider.overrideWithValue(
        AccountingBackendStrategy.ditto,
      ),
    ]);
    container.listen(rawTransactionStreamProvider, (_, _) {});
    container.listen(rawAllTransactionsStreamProvider, (_, _) {});
    await pumpEventQueue();
    expect(container.read(rawTransactionStreamProvider).value, isEmpty);
    expect(container.read(rawAllTransactionsStreamProvider).hasValue, isFalse);
  });

  test('line items are fetched for the period\'s transactions', () async {
    final repo = _ItemsRepository(
      transactions: [
        {'id': 't1'},
        {'_id': 't2'},
        {'id': ''},
      ],
      items: [
        {'id': 'item-1', 'transaction_id': 't1'},
      ],
    );
    final container = _container([
      ...accountingUnitTestOverrides(),
      accountingRepositoryProvider.overrideWithValue(repo),
      accountingBranchIdProvider.overrideWithValue('br'),
    ]);
    container.listen(rawTransactionItemsProvider, (_, _) {});
    await container.read(rawTransactionStreamProvider.future);
    await pumpEventQueue();

    final items = await container.read(rawTransactionItemsProvider.future);
    expect(items.single['id'], 'item-1');
    expect(repo.asked.last, ['t1', 't2']);
  });

  test('inventory value is read for the selected branch', () async {
    final ledger = _InventoryLedger();
    final container = _container([
      ...accountingUnitTestOverrides(),
      accountingLedgerRepositoryProvider.overrideWithValue(ledger),
      accountingBranchIdProvider.overrideWithValue('br'),
    ]);
    expect(await container.read(accountingInventoryValueProvider.future), 4200);
    expect(ledger.branches, ['br']);
  });
}
