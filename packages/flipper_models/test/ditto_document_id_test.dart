import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/all_models.dart';

/// Every model written to Ditto via `INSERT INTO <c> DOCUMENTS (:doc) ON ID
/// CONFLICT DO UPDATE` must carry `_id`. Ditto keys documents by `_id`; when it
/// is absent Ditto generates a fresh one, so the conflict clause never matches
/// and each save inserts a duplicate instead of updating the existing row.
void main() {
  group('Ditto document identity', () {
    test('Product.toJson carries _id matching id', () {
      final product = Product(
        id: 'product-1',
        name: 'Sugar',
        color: '#000000',
        businessId: 'biz-1',
        branchId: 'branch-1',
      );
      final doc = product.toJson();
      expect(doc['_id'], 'product-1');
      expect(doc['_id'], doc['id']);
    });

    test('SKU.toJson carries _id matching id', () {
      final sku = SKU(
        id: 'sku-1',
        sku: 42,
        branchId: 'branch-1',
        businessId: 'biz-1',
      );
      final doc = sku.toJson();
      expect(doc['_id'], 'sku-1');
      expect(doc['_id'], doc['id']);
    });

    test('Stock.toJson carries _id', () {
      final stock = Stock(id: 'stock-1', branchId: 'branch-1');
      expect(stock.toJson()['_id'], 'stock-1');
    });

    test('Variant.toFlipperJson carries _id', () {
      final variant =
          Variant(id: 'variant-1', name: 'Sugar 1kg', branchId: 'branch-1');
      expect(variant.toFlipperJson()['_id'], 'variant-1');
    });

    test('Product.fromJson still reads a doc written before the _id fix', () {
      // Pre-fix documents carry a Ditto-generated _id and the real app id in
      // `id` — reading must follow `id`, not `_id`.
      final product = Product.fromJson({
        '_id': 'ditto-generated-abc',
        'id': 'product-1',
        'name': 'Sugar',
        'businessId': 'biz-1',
        'branchId': 'branch-1',
      });
      expect(product.id, 'product-1');
    });
  });
}
