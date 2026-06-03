import 'package:flipper_models/providers/outer_variant_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/product.model.dart';

void main() {
  group('saved product list sync', () {
    test('VAT product appears in the list after save', () {
      final savedVatProduct = _product(id: 'vat-product', name: 'VAT Product');

      final products = mergeProductsById(const [], [savedVatProduct]);

      expect(products, contains(savedVatProduct));
      expect(products.single.id, savedVatProduct.id);
      expect(products.single.name, savedVatProduct.name);
    });

    test('non-VAT product appears in the list after save', () {
      final savedNonVatProduct = _product(
        id: 'non-vat-product',
        name: 'Non VAT Product',
      );

      final products = mergeProductsById(const [], [savedNonVatProduct]);

      expect(products, contains(savedNonVatProduct));
      expect(products.single.id, savedNonVatProduct.id);
      expect(products.single.name, savedNonVatProduct.name);
    });

    test('saved product replaces stale draft already in the list', () {
      final draftProduct = _product(id: 'vat-product', name: 'temp');
      final savedVatProduct = _product(id: 'vat-product', name: 'VAT Product');

      final products = mergeProductsById([draftProduct], [savedVatProduct]);

      expect(products, hasLength(1));
      expect(products.single.id, savedVatProduct.id);
      expect(products.single.name, savedVatProduct.name);
    });
  });
}

Product _product({required String id, required String name}) {
  return Product(
    id: id,
    name: name,
    color: '#0984e3',
    businessId: 'business-1',
    branchId: 'branch-1',
  );
}
