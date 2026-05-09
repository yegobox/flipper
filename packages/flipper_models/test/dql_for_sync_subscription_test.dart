import 'package:test/test.dart';
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';

void main() {
  group('dqlForSyncSubscription', () {
    test('removes ORDER BY on one line', () {
      expect(
        dqlForSyncSubscription(
          'SELECT * FROM leads WHERE branchId = :a ORDER BY lastTouched DESC',
        ),
        'SELECT * FROM leads WHERE branchId = :a',
      );
    });

    test('removes ORDER BY after newline', () {
      expect(
        dqlForSyncSubscription('''SELECT * FROM t
WHERE x = 1
ORDER BY y DESC'''),
        'SELECT * FROM t\nWHERE x = 1',
      );
    });

    test('removes LIMIT and OFFSET', () {
      expect(
        dqlForSyncSubscription(
          'SELECT * FROM t WHERE id = :id LIMIT :limit OFFSET :offset',
        ),
        'SELECT * FROM t WHERE id = :id',
      );
    });

    test('removes trailing semicolon', () {
      expect(
        dqlForSyncSubscription(
          'SELECT * FROM t ORDER BY z;',
        ),
        'SELECT * FROM t',
      );
    });

    test('prepareDqlSyncSubscription drops limit binding when LIMIT is stripped',
        () {
      final prepared = prepareDqlSyncSubscription(
        'SELECT * FROM stock_requests WHERE mainBranchId = :branchId '
            "AND (status = 'pending') ORDER BY createdAt DESC LIMIT :limit",
        {'branchId': 'b1', 'status': 'pending', 'limit': 50},
      );
      expect(
        prepared.dql,
        "SELECT * FROM stock_requests WHERE mainBranchId = :branchId "
            "AND (status = 'pending')",
      );
      expect(prepared.arguments, {'branchId': 'b1'});
    });

    test('variants()-shaped query: NOT IN, ORDER BY, LIMIT/OFFSET, tax binds', () {
      const raw =
          "SELECT * FROM variants WHERE branchId = :branchId "
          "AND name NOT IN ('Cash In', 'Cash Out', 'Utility', 'Custom Amount') "
          'AND (imptItemSttsCd IS NULL OR imptItemSttsCd NOT IN (\'2\', \'4\')) '
          "AND taxTyCd IN (:tax0, :tax1) "
          'ORDER BY lastTouched DESC LIMIT :limit OFFSET :offset';
      final prepared = prepareDqlSyncSubscription(
        raw,
        {
          'branchId': 'b1',
          'tax0': 'A',
          'tax1': 'B',
          'limit': 20,
          'offset': 0,
        },
      );
      expect(
        prepared.dql,
        "SELECT * FROM variants WHERE branchId = :branchId "
        "AND name NOT IN ('Cash In', 'Cash Out', 'Utility', 'Custom Amount') "
        'AND (imptItemSttsCd IS NULL OR imptItemSttsCd NOT IN (\'2\', \'4\')) '
        "AND taxTyCd IN (:tax0, :tax1)",
      );
      expect(prepared.arguments, {
        'branchId': 'b1',
        'tax0': 'A',
        'tax1': 'B',
      });
    });

    test('NBSP before ORDER BY is normalized and stripped', () {
      expect(
        dqlForSyncSubscription(
          'SELECT * FROM t WHERE id = :id\u00A0ORDER BY z',
        ),
        'SELECT * FROM t WHERE id = :id',
      );
    });

    test('removes FETCH FIRST ROWS ONLY suffix', () {
      expect(
        dqlForSyncSubscription(
          'SELECT * FROM t WHERE a = 1 OFFSET 0 ROWS FETCH FIRST 10 ROWS ONLY',
        ),
        'SELECT * FROM t WHERE a = 1',
      );
    });

    test('describeDqlSyncSubscriptionAttempt includes sanitized preview', () {
      final desc = describeDqlSyncSubscriptionAttempt(
        'SELECT * FROM x WHERE id = :id ORDER BY id LIMIT 1',
        {'id': '1'},
        maxChars: 50,
      );
      expect(desc, contains('sanitized'));
      expect(desc, contains('args_out'));
    });
  });
}
