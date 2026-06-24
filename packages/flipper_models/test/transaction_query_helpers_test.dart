import 'package:flipper_models/sync/transaction_query_helpers.dart';
import 'package:test/test.dart';

void main() {
  group('capellaTransactionsSyncSubscription', () {
    test('branch-only matches legacy POS / reports subscription', () {
      final prepared = capellaTransactionsSyncSubscription(
        branchId: 'branch-7c19',
      );
      expect(prepared, isNotNull);
      expect(
        prepared!.dql,
        'SELECT * FROM transactions WHERE branchId = :branchId',
      );
      expect(prepared.arguments, {'branchId': 'branch-7c19'});
    });

    test('attributed agent uses cross-branch subscription (commission)', () {
      final prepared = capellaTransactionsSyncSubscription(
        attributedAgentUserId: 'c0c843a0-1ed4-4405-b249-a65fecf4b002',
        branchId: 'branch-7c19',
      );
      expect(prepared, isNotNull);
      expect(
        prepared!.dql,
        'SELECT * FROM transactions WHERE attributedAgentUserId = :attributedAgentUserId',
      );
      expect(prepared.arguments, {
        'attributedAgentUserId': 'c0c843a0-1ed4-4405-b249-a65fecf4b002',
      });
      expect(prepared.arguments.containsKey('branchId'), isFalse);
    });

    test('empty attributedAgentUserId falls back to branch subscription', () {
      final prepared = capellaTransactionsSyncSubscription(
        branchId: 'branch-1',
        attributedAgentUserId: '',
      );
      expect(prepared, isNotNull);
      expect(prepared!.arguments, {'branchId': 'branch-1'});
    });

    test('neither branch nor agent returns null (no subscription)', () {
      expect(capellaTransactionsSyncSubscription(), isNull);
      expect(
        capellaTransactionsSyncSubscription(branchId: '', attributedAgentUserId: ''),
        isNull,
      );
    });
  });

  group('transactionsShouldWaitForRemoteSync', () {
    test('commission fetchRemote waits when list may be syncing', () {
      expect(
        transactionsShouldWaitForRemoteSync(
          fetchRemote: true,
          attributedAgentUserId: 'agent-1',
        ),
        isTrue,
      );
    });

    test('does not wait without fetchRemote', () {
      expect(
        transactionsShouldWaitForRemoteSync(
          fetchRemote: false,
          attributedAgentUserId: 'agent-1',
        ),
        isFalse,
      );
    });

    test('does not wait for single-id or receipt lookups', () {
      expect(
        transactionsShouldWaitForRemoteSync(
          fetchRemote: true,
          id: 'tx-1',
          attributedAgentUserId: 'agent-1',
        ),
        isFalse,
      );
      expect(
        transactionsShouldWaitForRemoteSync(
          fetchRemote: true,
          receiptNumber: ['123'],
          attributedAgentUserId: 'agent-1',
        ),
        isFalse,
      );
    });
  });

  group('transactionsPeriodDateField', () {
    test('default preserves lastTouched for existing callers', () {
      expect(transactionsPeriodDateField(), 'lastTouched');
      expect(transactionsPeriodDateField(filterPeriodByCreatedAt: false), 'lastTouched');
    });

    test('commission opt-in uses createdAt', () {
      expect(
        transactionsPeriodDateField(filterPeriodByCreatedAt: true),
        'createdAt',
      );
    });
  });
}
