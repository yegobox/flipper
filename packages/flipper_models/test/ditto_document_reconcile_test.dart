import 'package:flipper_models/sync/capella/ditto_document_reconcile.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> doc(
  String docId,
  String id, {
  String? touched,
  String? name,
}) =>
    {
      '_id': docId,
      'id': id,
      if (touched != null) 'lastTouched': touched,
      if (name != null) 'name': name,
    };

void main() {
  group('planDittoDocumentReconcile', () {
    test('leaves an already-canonical collection untouched', () {
      final plan = planDittoDocumentReconcile([
        doc('p1', 'p1', touched: '2026-08-01T00:00:00Z'),
        doc('p2', 'p2', touched: '2026-08-02T00:00:00Z'),
      ]);
      expect(plan.isEmpty, isTrue);
    });

    test('re-keys a single stray copy onto the app id', () {
      final plan = planDittoDocumentReconcile([
        doc('ditto-random', 'p1', touched: '2026-08-01T00:00:00Z', name: 'Sugar'),
      ]);

      expect(plan.upserts, hasLength(1));
      expect(plan.upserts.single['_id'], 'p1');
      expect(plan.upserts.single['id'], 'p1');
      expect(plan.upserts.single['name'], 'Sugar');
      expect(plan.deletes, ['ditto-random']);
    });

    test('keeps the freshest duplicate and drops the rest', () {
      final plan = planDittoDocumentReconcile([
        doc('r1', 'p1', touched: '2026-08-01T00:00:00Z', name: 'old'),
        doc('r2', 'p1', touched: '2026-08-05T00:00:00Z', name: 'newest'),
        doc('r3', 'p1', touched: '2026-08-03T00:00:00Z', name: 'middle'),
      ]);

      expect(plan.upserts.single['name'], 'newest');
      expect(plan.upserts.single['_id'], 'p1');
      expect(plan.deletes, ['r1', 'r2', 'r3']);
    });

    test('a stamped copy beats an unstamped one', () {
      final plan = planDittoDocumentReconcile([
        doc('r1', 'p1', name: 'no timestamp'),
        doc('r2', 'p1', touched: '2026-01-01T00:00:00Z', name: 'stamped'),
      ]);
      expect(plan.upserts.single['name'], 'stamped');
    });

    test('on an equal timestamp the canonical copy wins', () {
      final plan = planDittoDocumentReconcile([
        doc('zzz-random', 'p1', touched: '2026-08-01T00:00:00Z', name: 'stray'),
        doc('p1', 'p1', touched: '2026-08-01T00:00:00Z', name: 'canonical'),
      ]);

      expect(plan.upserts.single['name'], 'canonical');
      // The canonical _id is never scheduled for deletion.
      expect(plan.deletes, ['zzz-random']);
    });

    test('never deletes the document it is about to write', () {
      final plan = planDittoDocumentReconcile([
        doc('r1', 'p1', touched: '2026-08-01T00:00:00Z'),
        doc('r2', 'p1', touched: '2026-08-02T00:00:00Z'),
      ]);

      for (final upsert in plan.upserts) {
        expect(plan.deletes, isNot(contains(upsert['_id'])));
      }
    });

    test('ignores documents with no usable app id', () {
      // No `id` field means no identity to re-key onto — dropping these could
      // lose the only copy of a record.
      final plan = planDittoDocumentReconcile([
        {'_id': 'orphan-1', 'name': 'no id field'},
        {'_id': 'orphan-2', 'id': '', 'name': 'empty id'},
      ]);
      expect(plan.isEmpty, isTrue);
    });

    test('handles many records independently', () {
      final plan = planDittoDocumentReconcile([
        doc('r1', 'p1', touched: '2026-08-01T00:00:00Z'),
        doc('r2', 'p1', touched: '2026-08-02T00:00:00Z'),
        doc('p2', 'p2', touched: '2026-08-02T00:00:00Z'),
        doc('r4', 'p3', touched: '2026-08-02T00:00:00Z'),
      ]);

      expect(plan.upserts.map((d) => d['_id']), ['p1', 'p3']);
      expect(plan.deletes, ['r1', 'r2', 'r4']);
    });

    test('is idempotent — re-running the plan output changes nothing', () {
      final first = planDittoDocumentReconcile([
        doc('r1', 'p1', touched: '2026-08-01T00:00:00Z'),
        doc('r2', 'p1', touched: '2026-08-02T00:00:00Z'),
      ]);

      final second = planDittoDocumentReconcile(first.upserts);
      expect(second.isEmpty, isTrue);
    });

    test('accepts a DateTime lastTouched as well as an ISO string', () {
      final plan = planDittoDocumentReconcile([
        {
          '_id': 'r1',
          'id': 'p1',
          'lastTouched': DateTime.utc(2026, 8, 1),
          'name': 'old',
        },
        {
          '_id': 'r2',
          'id': 'p1',
          'lastTouched': DateTime.utc(2026, 8, 5),
          'name': 'newest',
        },
      ]);
      expect(plan.upserts.single['name'], 'newest');
    });
  });
}
