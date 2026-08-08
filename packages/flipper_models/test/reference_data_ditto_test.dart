import 'package:flipper_models/sync/capella/reference_data_ditto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/all_models.dart';

void main() {
  group('colour Ditto mapping', () {
    test('round-trips every persisted field', () {
      final touched = DateTime.utc(2026, 8, 8, 9, 30);
      final deleted = DateTime.utc(2026, 8, 9);
      final color = PColor(
        id: 'colour-1',
        name: 'Emerald',
        branchId: 'branch-7',
        active: true,
        lastTouched: touched,
        deletedAt: deleted,
      );

      final back = colorFromDittoDoc(colorToDittoDoc(color));

      expect(back.id, 'colour-1');
      expect(back.name, 'Emerald');
      expect(back.branchId, 'branch-7');
      expect(back.active, isTrue);
      expect(back.lastTouched, touched);
      expect(back.deletedAt, deleted);
    });

    test('writes _id alongside id so ON ID CONFLICT can match', () {
      final doc = colorToDittoDoc(PColor(id: 'c9', active: false));
      expect(doc['_id'], 'c9');
      expect(doc['id'], 'c9');
    });

    test('falls back to _id when the doc has no id field', () {
      final back = colorFromDittoDoc({'_id': 'c9', 'active': false});
      expect(back.id, 'c9');
    });

    test('reads active written as a string or number', () {
      expect(colorFromDittoDoc({'_id': 'a', 'active': 'true'}).active, isTrue);
      expect(colorFromDittoDoc({'_id': 'b', 'active': 1}).active, isTrue);
      expect(colorFromDittoDoc({'_id': 'c', 'active': 0}).active, isFalse);
      expect(colorFromDittoDoc({'_id': 'd'}).active, isFalse);
    });
  });

  group('unit Ditto mapping', () {
    test('round-trips every persisted field', () {
      final touched = DateTime.utc(2026, 8, 8, 9, 30);
      final unit = IUnit(
        id: 'unit-1',
        branchId: 'branch-7',
        name: 'Kg',
        value: 'kg',
        active: true,
        code: 'KG',
        description: 'Kilogram',
        lastTouched: touched,
        createdAt: '2026-08-01',
      );

      final back = unitFromDittoDoc(unitToDittoDoc(unit));

      expect(back.id, 'unit-1');
      expect(back.branchId, 'branch-7');
      expect(back.name, 'Kg');
      expect(back.value, 'kg');
      expect(back.active, isTrue);
      expect(back.code, 'KG');
      expect(back.description, 'Kilogram');
      expect(back.lastTouched, touched);
      expect(back.createdAt, '2026-08-01');
    });

    test('keeps active null when absent, so it is distinct from false', () {
      expect(unitFromDittoDoc({'_id': 'u1'}).active, isNull);
      expect(unitFromDittoDoc({'_id': 'u2', 'active': false}).active, isFalse);
    });

    test('tolerates a malformed date instead of throwing', () {
      final back = unitFromDittoDoc({'_id': 'u3', 'lastTouched': 'not-a-date'});
      expect(back.lastTouched, isNull);
    });
  });
}
