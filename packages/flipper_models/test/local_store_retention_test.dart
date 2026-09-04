import 'package:flipper_models/sync/dql_for_sync_subscription.dart';
import 'package:flipper_models/sync/utils/local_store_retention.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 9, 4, 12);
  final cutoff = DateTime.utc(2026, 8, 5, 12).toIso8601String();

  group('windowing an open-ended history subscription', () {
    test('adds a floor to a branch-wide transactions subscription', () {
      final out = applyLocalHistoryWindow(
        'SELECT * FROM transactions WHERE branchId = :branchId',
        {'branchId': 'b1'},
        now: now,
      );

      expect(
        out.dql,
        'SELECT * FROM transactions WHERE branchId = :branchId AND '
        '(createdAt >= :historyWindowStart OR status IN :openTicketStatuses)',
      );
      expect(out.arguments['historyWindowStart'], cutoff);
      expect(out.arguments['branchId'], 'b1');
    });

    test('adds a WHERE when the subscription has none', () {
      final out = applyLocalHistoryWindow(
        'SELECT * FROM transaction_items',
        const {},
        now: now,
      );

      expect(
        out.dql,
        'SELECT * FROM transaction_items WHERE '
        '(createdAt >= :historyWindowStart OR status IN :openTicketStatuses)',
      );
    });

    test('an open ticket stays in scope however old it is', () {
      final out = applyLocalHistoryWindow(
        'SELECT * FROM transactions WHERE branchId = :branchId',
        {'branchId': 'b1'},
        now: now,
      );

      final statuses = out.arguments['openTicketStatuses'] as List;
      expect(statuses, containsAll(<String>['pending', 'parked']));
      expect(statuses, contains('awaitingHandover'));
    });
  });

  group('subscriptions that must not be narrowed', () {
    test('a report asking for an explicit date range is left alone', () {
      const dql =
          'SELECT * FROM transactions WHERE branchId = :branchId AND '
          'createdAt >= :startDate AND createdAt <= :endDate';

      final out = applyLocalHistoryWindow(dql, {
        'branchId': 'b1',
        'startDate': '2026-01-01T00:00:00.000',
        'endDate': '2026-03-01T00:00:00.000',
      }, now: now);

      expect(out.dql, dql, reason: 'narrowing this truncates the report');
      expect(out.arguments.containsKey('historyWindowStart'), isFalse);
    });

    test('a subscription pinned to one transaction is left alone', () {
      const dql =
          'SELECT * FROM transaction_items WHERE transactionId = :transactionId';

      final out = applyLocalHistoryWindow(dql, {'transactionId': 't1'},
          now: now);

      expect(out.dql, dql);
    });

    test('a subscription pinned by id is left alone', () {
      const dql = 'SELECT * FROM transactions WHERE _id = :id';

      expect(applyLocalHistoryWindow(dql, {'id': 't1'}, now: now).dql, dql);
    });

    test('catalog collections keep syncing in full', () {
      for (final dql in const [
        'SELECT * FROM variants WHERE branchId = :branchId',
        'SELECT * FROM products WHERE branchId = :branchId',
        'SELECT * FROM stocks WHERE branchId = :branchId',
        'SELECT * FROM customers WHERE branchId = :branchId',
      ]) {
        expect(
          applyLocalHistoryWindow(dql, {'branchId': 'b1'}, now: now).dql,
          dql,
          reason: 'the POS cannot sell what it cannot see',
        );
      }
    });
  });

  group('through prepareDqlSyncSubscription', () {
    test('windows the query and binds only what survives', () {
      final prepared = prepareDqlSyncSubscription(
        'SELECT * FROM transactions WHERE branchId = :branchId '
        'ORDER BY createdAt DESC LIMIT 50',
        {'branchId': 'b1', 'limit': 50},
      );

      // ORDER BY / LIMIT still stripped for Ditto 5...
      expect(prepared.dql.toLowerCase(), isNot(contains('order by')));
      expect(prepared.dql.toLowerCase(), isNot(contains('limit')));
      // ...and the window applied to what remains.
      expect(prepared.dql, contains('historyWindowStart'));
      expect(prepared.arguments.containsKey('historyWindowStart'), isTrue);
      expect(prepared.arguments.containsKey('openTicketStatuses'), isTrue);
      expect(prepared.arguments.containsKey('limit'), isFalse);
    });

    test('an ORDER BY on createdAt is not mistaken for a date bound', () {
      final prepared = prepareDqlSyncSubscription(
        'SELECT * FROM transactions WHERE branchId = :branchId '
        'ORDER BY createdAt DESC',
        {'branchId': 'b1'},
      );

      expect(prepared.dql, contains('historyWindowStart'));
    });
  });

  test('the window is the documented retention period', () {
    expect(kLocalHistoryRetentionDays, 30);
    expect(
      localHistoryWindowStart(now: now),
      DateTime.utc(2026, 8, 5, 12),
    );
  });
}
