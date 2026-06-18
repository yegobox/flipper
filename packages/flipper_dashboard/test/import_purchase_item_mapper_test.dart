import 'package:flipper_models/imports_purchases_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/variant.model.dart';

void main() {
  test('buildPurchaseItemMapper groups purchase line ids by target variant', () {
    final line1 = Variant(id: 'pv-1', name: 'Line 1', branchId: 'b');
    final line2 = Variant(id: 'pv-2', name: 'Line 2', branchId: 'b');
    final line3 = Variant(id: 'pv-3', name: 'Line 3', branchId: 'b');

    final mapper = buildPurchaseItemMapper({
      'catalog-a': [line1, line2],
      'catalog-b': [line3],
    });

    expect(mapper, {
      'catalog-a': ['pv-1', 'pv-2'],
      'catalog-b': ['pv-3'],
    });
  });

  test('buildPurchaseItemMapper skips empty target groups', () {
    final mapper = buildPurchaseItemMapper({});
    expect(mapper, isEmpty);
  });
}
