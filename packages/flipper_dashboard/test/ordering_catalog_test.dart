import 'package:flipper_dashboard/ordering/ordering_catalog.dart';
import 'package:flipper_dashboard/ordering/ordering_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/stock.model.dart';
import 'package:supabase_models/brick/models/variant.model.dart';

/// Pure-logic cover for the purchase-order catalogue derivation. No Brick
/// repository, no Ditto, no widgets — see the dashboard's other widget tests,
/// which cannot load at all.
Variant _variant({
  required String id,
  required String name,
  String? category,
  String? sku,
  double? stock,
  double cost = 1000,
  double retail = 1500,
}) {
  return Variant(
    id: id,
    name: name,
    productId: 'p-$id',
    branchId: 'b1',
    categoryName: category,
    sku: sku,
    supplyPrice: cost,
    retailPrice: retail,
    stock: stock == null
        ? null
        : Stock(id: 's-$id', branchId: 'b1', currentStock: stock),
  );
}

OrderingCatalog _build(
  List<Variant> products, {
  String category = kOrderingAllCategories,
  String query = '',
  bool stockOnly = false,
  bool groupByCategory = true,
}) {
  return buildOrderingCatalog(
    products: products,
    category: category,
    query: query,
    stockOnly: stockOnly,
    groupByCategory: groupByCategory,
  );
}

void main() {
  final tools = _variant(
    id: '1',
    name: 'EQUERRE NTO',
    category: 'Tools',
    sku: 'EQ-NTO',
    stock: 600,
  );
  final plumbing = _variant(
    id: '2',
    name: 'COUDE ADAPTER',
    category: 'Plumbing',
    sku: 'CA-034',
    stock: 12,
  );
  final soldOut = _variant(
    id: '3',
    name: 'ATTACH 25',
    category: 'Plumbing',
    sku: 'AT-25',
    stock: 0,
  );
  final unknownStock = _variant(
    id: '4',
    name: 'MANCHO PPR',
    category: 'Plumbing',
    sku: 'MN-PPR',
  );
  final all = [tools, plumbing, soldOut, unknownStock];

  group('categories', () {
    test('lead with All and count the whole catalogue, not the view', () {
      final catalog = _build(all, query: 'equerre');

      expect(catalog.visible, hasLength(1));
      expect(catalog.categories.first.name, kOrderingAllCategories);
      expect(catalog.categories.first.count, 4);
      final plumbingCategory = catalog.categories.firstWhere(
        (c) => c.name == 'Plumbing',
      );
      expect(plumbingCategory.count, 3);
    });

    test('file a row with no category under Uncategorised', () {
      final catalog = _build([_variant(id: '9', name: 'Loose item')]);

      expect(
        catalog.categories.map((c) => c.name),
        [kOrderingAllCategories, kOrderingUncategorised],
      );
    });
  });

  group('filters', () {
    test('a category selection hides the other categories', () {
      final catalog = _build(all, category: 'Tools');

      expect(catalog.visible, [tools]);
    });

    test('search matches name and sku, case-insensitively', () {
      expect(_build(all, query: 'coude').visible, [plumbing]);
      expect(_build(all, query: 'mn-ppr').visible, [unknownStock]);
    });

    test('search matches a scanned barcode', () {
      final scanned = Variant(
        id: '10',
        name: 'SHOWER SET',
        productId: 'p10',
        branchId: 'b1',
        categoryName: 'Plumbing',
        sku: 'SH-SET',
        bcd: '6001234567890',
      );

      expect(_build([...all, scanned], query: '6001234567890').visible, [
        scanned,
      ]);
    });

    test('in-stock-only hides a known zero but keeps an unknown', () {
      final catalog = _build(all, stockOnly: true);

      expect(catalog.visible, contains(unknownStock));
      expect(catalog.visible, isNot(contains(soldOut)));
    });

    test('filters compose', () {
      final catalog = _build(
        all,
        category: 'Plumbing',
        stockOnly: true,
        query: 'a',
      );

      // COUDE ADAPTER and MANCHO PPR both match "a" and are not known-zero;
      // ATTACH 25 matches but has none.
      expect(catalog.visible, [plumbing, unknownStock]);
    });
  });

  group('grouping', () {
    test('sections by category, dropping ones the filters emptied', () {
      final catalog = _build(all, query: 'coude');

      expect(catalog.groups, hasLength(1));
      expect(catalog.groups.single.label, 'Plumbing');
      expect(catalog.groups.single.items, [plumbing]);
    });

    test('ungrouped collapses to one unlabelled section', () {
      final catalog = _build(all, groupByCategory: false);

      expect(catalog.groups, hasLength(1));
      expect(catalog.groups.single.label, isEmpty);
      expect(catalog.groups.single.items, hasLength(4));
    });

    test('no rows means no sections', () {
      final catalog = _build(all, query: 'nothing matches this');

      expect(catalog.groups, isEmpty);
      expect(catalog.visible, isEmpty);
    });
  });

  group('top match', () {
    test('is the first visible row, so Enter adds what is on top', () {
      expect(_build(all, query: 'coude').topMatch, plumbing);
    });

    test('is null when nothing matches', () {
      expect(_build(all, query: 'zzz').topMatch, isNull);
    });
  });

  test('result label counts the view against the catalogue', () {
    expect(_build(all, query: 'coude').resultLabel, '1 of 4 products');
    expect(_build(all).resultLabel, '4 of 4 products');
  });

  test('an empty catalogue derives nothing rather than throwing', () {
    final catalog = _build(const []);

    expect(catalog.categories, isEmpty);
    expect(catalog.groups, isEmpty);
    expect(catalog.topMatch, isNull);
    expect(catalog.totalCount, 0);
  });

  group('field fallbacks', () {
    test('sku falls back to itemCd, then a dash', () {
      expect(orderingSkuOf(_variant(id: 'a', name: 'X', sku: 'S-1')), 'S-1');
      expect(
        orderingSkuOf(
          Variant(
            id: 'b',
            name: 'X',
            productId: 'p',
            branchId: 'b1',
            itemCd: 'IC-9',
          ),
        ),
        'IC-9',
      );
      expect(orderingSkuOf(_variant(id: 'c', name: 'X')), '—');
    });

    test('unit prefers unit over qtyUnitCd', () {
      expect(
        orderingUnitOf(
          Variant(
            id: 'a',
            name: 'X',
            productId: 'p',
            branchId: 'b1',
            unit: 'box',
            qtyUnitCd: 'BX',
          ),
        ),
        'box',
      );
      expect(
        orderingUnitOf(
          Variant(
            id: 'b',
            name: 'X',
            productId: 'p',
            branchId: 'b1',
            qtyUnitCd: 'BX',
          ),
        ),
        'BX',
      );
      expect(orderingUnitOf(_variant(id: 'c', name: 'X')), 'ea');
    });
  });
}
