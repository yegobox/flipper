import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/data/mapper/transaction_to_accounts.dart';
import 'package:flipper_web/modules/accounting/data/repository/accounting_repository.dart';
import '../../../helpers/fake_accounting_ledger_repository.dart';
import '../../../helpers/fake_accounting_repository.dart';
import '../../../helpers/accounting_unit_test_overrides.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

ProviderContainer _container({
  AccountingRepository? repo,
  FakeAccountingLedgerRepository? ledger,
  String branchId = '1',
  String businessId = 'biz-test',
  List<Map<String, dynamic>> transactions = const [],
  List<Map<String, dynamic>> items = const [],
  List<JournalEntry>? journalEntries,
}) {
  final container = ProviderContainer(
    overrides: [
      ...accountingUnitTestOverrides(),
      accountingRepositoryProvider.overrideWithValue(
        repo ?? FakeAccountingRepository(transactions: transactions, items: items),
      ),
      accountingLedgerRepositoryProvider.overrideWithValue(
        ledger ?? FakeAccountingLedgerRepository(entries: journalEntries),
      ),
      accountingBranchIdProvider.overrideWithValue(branchId),
      accountingBusinessIdProvider.overrideWithValue(businessId),
      accountingDateRangeProvider.overrideWith(
        (ref) => (DateTime(2026, 1, 1), DateTime(2026, 12, 31)),
      ),
    ],
  );
  container.listen(rawTransactionStreamProvider, (_, __) {});
  container.listen(rawAllTransactionsStreamProvider, (_, __) {});
  container.listen(chartOfAccountsStreamProvider, (_, __) {});
  container.listen(journalEntriesStreamProvider, (_, __) {});
  return container;
}

final _cashSale = {
  'id': 'txn-1',
  'status': 'completed',
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
  'status': 'completed',
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

void main() {
  group('rawTransactionStreamProvider', () {
    test('emits injected transactions', () async {
      final container = _container(transactions: [_cashSale]);
      addTearDown(container.dispose);

      await container.read(rawTransactionStreamProvider.future);
      expect(container.read(rawTransactionStreamProvider).value?.length, 1);
    });
  });

  group('accountingCoaProvider', () {
    test('loads seeded chart of accounts', () async {
      final container = _container();
      addTearDown(container.dispose);

      await container.read(chartOfAccountsStreamProvider.future);
      final coa = container.read(accountingCoaProvider);
      expect(coa.any((a) => a.code == '3010'), isTrue);
    });
  });

  group('accountingJournalProvider', () {
    test('reads journal entries from ledger', () async {
      final entry = JournalEntry(
        id: 'JE-1',
        date: 'May 1',
        memo: 'Test',
        ref: 'T-1',
        status: JournalStatus.posted,
        src: 'Manual',
        lines: const [JournalLine(ac: '1010', dr: 100)],
      );
      final container = _container(journalEntries: [entry]);
      addTearDown(container.dispose);

      await container.read(journalEntriesStreamProvider.future);
      expect(container.read(accountingJournalProvider).length, 1);
    });
  });

  group('accountingAccountsProvider', () {
    test('applies posted journal balances to COA', () async {
      final entry = JournalEntry(
        id: 'JE-1',
        date: 'May 1',
        memo: 'Sale',
        ref: '42',
        status: JournalStatus.posted,
        src: 'POS',
        lines: const [
          JournalLine(ac: '1010', dr: 118000),
          JournalLine(ac: '4010', cr: 100000),
          JournalLine(ac: '2100', cr: 18000),
        ],
      );
      final container = _container(journalEntries: [entry]);
      addTearDown(container.dispose);

      await container.read(chartOfAccountsStreamProvider.future);
      await container.read(journalEntriesStreamProvider.future);

      final accounts = container.read(accountingAccountsProvider);
      final cash = accounts.firstWhere((a) => a.code == '1010');
      expect(cash.bal, 118000);
    });
  });

  group('accountingTrendProvider', () {
    test('returns empty when no transactions', () async {
      final container = _container();
      addTearDown(container.dispose);

      await container.read(rawTransactionStreamProvider.future);
      expect(container.read(accountingTrendProvider), isEmpty);
    });

    test('returns live trend when transactions exist', () async {
      final container = _container(transactions: [_cashSale]);
      addTearDown(container.dispose);

      await container.read(rawTransactionStreamProvider.future);
      expect(container.read(accountingTrendProvider).any((t) => t.m == 'May'), isTrue);
    });
  });

  group('accountingVatProvider', () {
    test('sums output VAT from sales', () async {
      final container = _container(transactions: [_cashSale]);
      addTearDown(container.dispose);

      await container.read(rawTransactionStreamProvider.future);
      final vat = container.read(accountingVatProvider);
      expect(vat?.outputVat, 18000);
    });
  });

  group('accountingArAgingProvider', () {
    test('returns empty when no open loan sales', () async {
      final container = _container(transactions: [_cashSale]);
      addTearDown(container.dispose);

      await container.read(rawAllTransactionsStreamProvider.future);
      expect(container.read(accountingArAgingProvider), isEmpty);
    });

    test('includes parked loan with remaining balance', () async {
      final loanSale = {
        ..._cashSale,
        'status': 'parked',
        'is_loan': true,
        'remaining_balance': 40000,
        'customer_name': 'Karake',
      };
      final container = _container(transactions: [loanSale]);
      addTearDown(container.dispose);

      await container.read(rawAllTransactionsStreamProvider.future);
      final rows = container.read(accountingArAgingProvider);
      expect(rows, hasLength(1));
      expect(rows.first.name, 'Karake');
      expect(rows.first.total, 40000);
    });
  });

  group('accountingApAgingProvider', () {
    test('returns empty when no open bills', () async {
      final container = _container(transactions: [_cashExpense]);
      addTearDown(container.dispose);

      await container.read(rawAllTransactionsStreamProvider.future);
      expect(container.read(accountingApAgingProvider), isEmpty);
    });
  });

  group('pendingCountProvider', () {
    test('counts pending entries from ledger', () async {
      final pending = JournalEntry(
        id: 'JE-P',
        date: 'May 1',
        memo: 'Pending',
        ref: 'P-1',
        status: JournalStatus.pending,
        src: 'Manual',
        lines: const [
          JournalLine(ac: '6010', dr: 100),
          JournalLine(ac: '1020', cr: 100),
        ],
      );
      final container = _container(journalEntries: [pending]);
      addTearDown(container.dispose);

      await container.read(journalEntriesStreamProvider.future);
      expect(container.read(pendingCountProvider), 1);
    });

    test('returns 0 when no pending entries', () async {
      final container = _container();
      addTearDown(container.dispose);

      await container.read(journalEntriesStreamProvider.future);
      expect(container.read(pendingCountProvider), 0);
    });
  });

  group('TransactionToAccounts', () {
    test('still derives journal lines from transactions for poster', () {
      final journal = TransactionToAccounts.toJournal([_cashSale], [_item]);
      expect(journal, hasLength(1));
      expect(journal.first.lines.any((l) => l.ac == '1010' && l.dr > 0), isTrue);
    });
  });
}
