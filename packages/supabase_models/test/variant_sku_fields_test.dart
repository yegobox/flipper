import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/variant.model.dart';

// flutter test test/variant_sku_fields_test.dart --no-test-assets --dart-define=FLUTTER_TEST_ENV=true
void main() {
  group('Variant SKU flags', () {
    test('are read from the Ditto document', () {
      final variant = Variant.fromJson({
        'id': 'v1',
        'branchId': 'b1',
        'name': 'Juice',
        'sku': null,
        'skuPending': true,
        'skuConflict': true,
      });
      expect(variant.skuPending, isTrue);
      expect(variant.skuConflict, isTrue);
    });

    test('are false when the document has none', () {
      final variant =
          Variant.fromJson({'id': 'v1', 'branchId': 'b1', 'name': 'Juice'});
      expect(variant.skuPending, isFalse);
      expect(variant.skuConflict, isFalse);
    });

    test('are written only when known', () {
      final known = Variant(
        id: 'v1',
        branchId: 'b1',
        name: 'Juice',
        sku: 'BEV-00042',
        skuPending: false,
        skuConflict: true,
      ).toFlipperJson();
      expect(known['skuPending'], isFalse);
      expect(known['skuConflict'], isTrue);

      // A variant read from Brick knows neither; writing false would clear a
      // flag another device or data-connector set.
      final unknown =
          Variant(id: 'v2', branchId: 'b1', name: 'Juice').toFlipperJson();
      expect(unknown.containsKey('skuPending'), isFalse);
      expect(unknown.containsKey('skuConflict'), isFalse);
    });

    test('copyWith keeps or replaces them', () {
      final pending =
          Variant(id: 'v1', branchId: 'b1', name: 'Juice', skuPending: true);
      expect(pending.copyWith(name: 'Juice 1L').skuPending, isTrue);
      final assigned = pending.copyWith(
          sku: 'BEV-00042', skuPending: false, skuConflict: true);
      expect(assigned.skuPending, isFalse);
      expect(assigned.skuConflict, isTrue);
    });
  });
}
