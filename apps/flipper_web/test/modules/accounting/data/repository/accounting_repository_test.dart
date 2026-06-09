import 'package:flipper_web/modules/accounting/data/repository/supabase_accounting_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show SupabaseClient;
import '../../../../helpers/fake_accounting_repository.dart';

// ---------------------------------------------------------------------------
// Mocks for Supabase client chain
// ---------------------------------------------------------------------------

class _MockSupabaseClient extends Mock implements SupabaseClient {}
// ---------------------------------------------------------------------------
// SupabaseAccountingRepository tests
// ---------------------------------------------------------------------------

void main() {
  group('SupabaseAccountingRepository', () {
    late _MockSupabaseClient client;
    late SupabaseAccountingRepository repo;

    setUp(() {
      client = _MockSupabaseClient();
      repo = SupabaseAccountingRepository(client);
    });

    test(
      'fetchTransactionItems returns empty list without querying when ids is empty',
      () async {
        // No mock setup needed — should short-circuit
        final result = await repo.fetchTransactionItems(transactionIds: []);
        expect(result, isEmpty);
        // SupabaseClient.from was never called
        verifyNever(() => client.from(any()));
      },
    );
  });

  // -------------------------------------------------------------------------
  // FakeAccountingRepository (used by provider tests)
  // -------------------------------------------------------------------------

  group('FakeAccountingRepository', () {
    final sampleTxns = [
      {
        'id': 'txn-1',
        'status': 'completed',
        'sub_total': 100000,
        'tax_amount': 0,
        'payment_type': 'CASH',
        'is_expense': false,
        'created_at': '2026-05-01T00:00:00Z',
      },
    ];
    final sampleItems = [
      {'transaction_id': 'txn-1', 'sply_amt': 60000},
    ];

    test('fetchTransactions returns injected list', () async {
      final repo = FakeAccountingRepository(transactions: sampleTxns);
      final result = await repo.fetchTransactions(branchId: 'branch-1');
      expect(result, sampleTxns);
    });

    test('fetchTransactionItems returns injected items', () async {
      final repo = FakeAccountingRepository(items: sampleItems);
      final result = await repo.fetchTransactionItems(
        transactionIds: ['txn-1'],
      );
      expect(result, sampleItems);
    });

    test('watchTransactions emits a single event with injected list', () async {
      final repo = FakeAccountingRepository(transactions: sampleTxns);
      final emitted = await repo.watchTransactions(branchId: 'branch-1').first;
      expect(emitted, sampleTxns);
    });

    test(
      'fetchTransactionItems with empty ids skips real query (empty repo)',
      () async {
        final repo = FakeAccountingRepository();
        final result = await repo.fetchTransactionItems(transactionIds: []);
        expect(result, isEmpty);
      },
    );
  });

  // -------------------------------------------------------------------------
  // DittoAccountingRepository: tested via FakeAccountingRepository contract
  // (Ditto SDK requires native libs — integration-tested separately).
  // -------------------------------------------------------------------------
}
