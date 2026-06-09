import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/data/repository/accounting_repository.dart';
import '../../../helpers/fake_accounting_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Build a [ProviderContainer] with the repository and branch ID overridden.
///
/// In Riverpod 3.x all providers are auto-disposed when they have no listeners.
/// We immediately attach a no-op listener to [rawTransactionStreamProvider] so
/// that [StreamProvider.future] resolves instead of hanging until the 30-second
/// test timeout fires.
ProviderContainer _container({
  AccountingRepository? repo,
  String branchId = 'branch-test',
  List<Map<String, dynamic>> transactions = const [],
  List<Map<String, dynamic>> items = const [],
}) {
  final container = ProviderContainer(
    overrides: [
      accountingRepositoryProvider.overrideWithValue(
        repo ?? FakeAccountingRepository(transactions: transactions, items: items),
      ),
      accountingBranchIdProvider.overrideWithValue(branchId),
      // Pin date range so tests are deterministic
      accountingDateRangeProvider.overrideWith(
        (ref) => (DateTime(2026, 1, 1), DateTime(2026, 12, 31)),
      ),
    ],
  );
  // Keep the stream provider alive; container.dispose() cleans up the subscription.
  container.listen(rawTransactionStreamProvider, (_, __) {});
  return container;
}

final _cashSale = {
  'id': 'txn-1',
  'status': 'COMPLETE',
  'sub_total': 118000,
  'tax_amount': 18000,
  'payment_type': 'CASH',
  'is_expense': false,
  'is_income': true,
  'is_loan': false,
  'created_at': '2026-05-15T10:00:00Z',
  'customer_name': 'Alice',
  'receipt_number': '42',
};

final _cashExpense = {
  'id': 'exp-1',
  'status': 'COMPLETE',
  'sub_total': 30000,
  'tax_amount': 0,
  'payment_type': 'CASH',
  'is_expense': true,
  'is_income': false,
  'is_loan': false,
  'created_at': '2026-05-16T09:00:00Z',
  'note': 'Rent',
};

final _item = {
  'transaction_id': 'txn-1',
  'sply_amt': 70000,
};

// ---------------------------------------------------------------------------

void main() {
  group('accountingRepositoryProvider', () {
    test('is overridable — fake returns injected transactions', () async {
      final container = _container(transactions: [_cashSale]);
      addTearDown(container.dispose);

      final repo = container.read(accountingRepositoryProvider);
      final rows = await repo.fetchTransactions(branchId: 'branch-test');
      expect(rows.length, 1);
      expect(rows.first['id'], 'txn-1');
    });
  });

  group('rawTransactionStreamProvider', () {
    test('emits injected transactions', () async {
      final container = _container(transactions: [_cashSale]);
      addTearDown(container.dispose);

      // Wait for the stream to emit
      await container
          .read(rawTransactionStreamProvider.future);

      final value = container.read(rawTransactionStreamProvider).value;
      expect(value, isNotNull);
      expect(value!.length, 1);
    });

    test('emits empty list when no transactions', () async {
      final container = _container();
      addTearDown(container.dispose);

      await container.read(rawTransactionStreamProvider.future);
      expect(container.read(rawTransactionStreamProvider).value, isEmpty);
    });
  });

  group('accountingAccountsProvider', () {
    test('derives revenue account from a sale', () async {
      final container = _container(
        transactions: [_cashSale],
        items: [_item],
      );
      addTearDown(container.dispose);

      // Trigger stream
      await container.read(rawTransactionStreamProvider.future);
      // Trigger items
      await container.read(rawTransactionItemsProvider.future);

      final accounts = container.read(accountingAccountsProvider);
      final revenue = accounts.firstWhere((a) => a.code == '4010');
      expect(revenue.bal, 100000); // 118000 - 18000
    });

    test('derives COGS from item sply_amt', () async {
      final container = _container(
        transactions: [_cashSale],
        items: [_item],
      );
      addTearDown(container.dispose);

      await container.read(rawTransactionStreamProvider.future);
      await container.read(rawTransactionItemsProvider.future);

      final accounts = container.read(accountingAccountsProvider);
      final cogs = accounts.firstWhere((a) => a.code == '5010');
      expect(cogs.bal, 70000);
    });

    test('merges static (demo) accounts for equity codes', () async {
      final container = _container(transactions: [_cashSale]);
      addTearDown(container.dispose);

      await container.read(rawTransactionStreamProvider.future);
      await container.read(rawTransactionItemsProvider.future);

      final accounts = container.read(accountingAccountsProvider);
      // 3010 = Owner's Capital — from demoAccounts static merge
      expect(accounts.any((a) => a.code == '3010'), isTrue);
    });

    test('returns accounts even with no items', () async {
      final container = _container(transactions: [_cashSale]);
      addTearDown(container.dispose);

      await container.read(rawTransactionStreamProvider.future);
      await container.read(rawTransactionItemsProvider.future);

      final accounts = container.read(accountingAccountsProvider);
      expect(accounts, isNotEmpty);
    });
  });

  group('accountingJournalProvider', () {
    test('produces one entry per transaction', () async {
      final container = _container(transactions: [_cashSale, _cashExpense]);
      addTearDown(container.dispose);

      await container.read(rawTransactionStreamProvider.future);
      await container.read(rawTransactionItemsProvider.future);

      final journal = container.read(accountingJournalProvider);
      expect(journal.length, 2);
    });

    test('sale entry has correct debit account', () async {
      final container = _container(transactions: [_cashSale]);
      addTearDown(container.dispose);

      await container.read(rawTransactionStreamProvider.future);
      await container.read(rawTransactionItemsProvider.future);

      final entry = container.read(accountingJournalProvider).first;
      final drLine = entry.lines.firstWhere((l) => l.dr > 0);
      expect(drLine.ac, '1010'); // CASH
    });

    test('empty transactions returns empty journal', () async {
      final container = _container();
      addTearDown(container.dispose);

      await container.read(rawTransactionStreamProvider.future);
      await container.read(rawTransactionItemsProvider.future);

      expect(container.read(accountingJournalProvider), isEmpty);
    });
  });

  group('accountingIncomeStatementProvider', () {
    test('net income equals revenue minus COGS minus opex', () async {
      final container = _container(
        transactions: [_cashSale, _cashExpense],
        items: [_item],
      );
      addTearDown(container.dispose);

      await container.read(rawTransactionStreamProvider.future);
      await container.read(rawTransactionItemsProvider.future);

      final pl = container.read(accountingIncomeStatementProvider);
      // net revenue = 100000, cogs = 70000, opex = 30000
      expect(pl.netRevenue, 100000);
      expect(pl.cogs, 70000);
      expect(pl.netIncome, 0); // 100000 - 70000 - 30000
    });
  });

  group('accountingCashBankTotalProvider', () {
    test('sums cash account balances', () async {
      final container = _container(transactions: [_cashSale]);
      addTearDown(container.dispose);

      await container.read(rawTransactionStreamProvider.future);
      await container.read(rawTransactionItemsProvider.future);

      final total = container.read(accountingCashBankTotalProvider);
      // Cash account = 118000 (full subTotal goes to cash Dr)
      expect(total, greaterThan(0));
    });
  });

  group('accountingTrendProvider', () {
    test('falls back to demo trend when no live data', () async {
      final container = _container();
      addTearDown(container.dispose);

      await container.read(rawTransactionStreamProvider.future);

      final trend = container.read(accountingTrendProvider);
      expect(trend, isNotEmpty); // demo fallback
    });

    test('returns live trend when transactions exist', () async {
      final container = _container(transactions: [_cashSale]);
      addTearDown(container.dispose);

      await container.read(rawTransactionStreamProvider.future);

      final trend = container.read(accountingTrendProvider);
      expect(trend.any((t) => t.m == 'May'), isTrue);
    });
  });

  group('pendingCountProvider', () {
    test('returns 0 for live journal (all entries are posted)', () async {
      final container = _container(transactions: [_cashSale]);
      addTearDown(container.dispose);

      await container.read(rawTransactionStreamProvider.future);
      await container.read(rawTransactionItemsProvider.future);

      expect(container.read(pendingCountProvider), 0);
    });

    test('falls back to demo pending count when journal is empty', () async {
      final container = _container();
      addTearDown(container.dispose);

      await container.read(rawTransactionStreamProvider.future);
      await container.read(rawTransactionItemsProvider.future);

      // Demo journal has 2 pending entries
      expect(container.read(pendingCountProvider), greaterThan(0));
    });
  });

  group('backend switch', () {
    test('swapping repository implementation changes derived data', () async {
      final highRevRepo = FakeAccountingRepository(
        transactions: [
          {..._cashSale, 'sub_total': 1000000, 'tax_amount': 0},
        ],
      );
      final container = _container(repo: highRevRepo);
      addTearDown(container.dispose);

      await container.read(rawTransactionStreamProvider.future);
      await container.read(rawTransactionItemsProvider.future);

      final pl = container.read(accountingIncomeStatementProvider);
      expect(pl.netRevenue, 1000000);
    });
  });
}
