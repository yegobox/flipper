import 'package:flipper_models/sync/utils/pos_catalog_stock_filter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('stockRowQty', () {
    test('the milli COUNTER wins over the register', () {
      // A concurrent sale INCREMENTed the counter; the register is stale.
      expect(
        stockRowQty({'currentStockMilli': 2000, 'currentStock': 9.0}),
        2.0,
      );
    });

    test('falls back to the register when there is no counter', () {
      expect(stockRowQty({'currentStock': 4.0}), 4.0);
      expect(stockRowQty({'currentStock': '3.5'}), 3.5);
    });

    test('a counter surfaced as a nested map still resolves', () {
      expect(
        stockRowQty({
          'currentStockMilli': {'value': 1500},
        }),
        1.5,
      );
    });

    test('a row with no quantity reads as zero', () {
      expect(stockRowQty({}), 0);
    });
  });

  group('posTileHasStock agrees with the tile', () {
    test('whole units are sellable', () {
      expect(posTileHasStock(1), isTrue);
      expect(posTileHasStock(12.7), isTrue);
    });

    test('zero, negative and a fraction under one are out', () {
      // RowItem floors before comparing, so 0.4 shows "Out of stock".
      expect(posTileHasStock(0), isFalse);
      expect(posTileHasStock(-3), isFalse);
      expect(posTileHasStock(0.4), isFalse);
    });
  });

  group('variantIdsMatchingStock', () {
    final rows = <Map<String, dynamic>>[
      {'_id': 'v-stocked', 'stockId': 's-stocked'},
      {'_id': 'v-empty', 'stockId': 's-empty'},
      {'_id': 'v-no-stock-id'},
      {'_id': 'v-blank-stock-id', 'stockId': '  '},
      {'_id': 'v-unknown-stock', 'stockId': 's-missing'},
      {'_id': 'v-by-id-key', 'stockId': 's-legacy'},
    ];
    final qty = stockQtyByIdKeys([
      {'_id': 's-stocked', 'currentStockMilli': 5000},
      {'_id': 's-empty', 'currentStockMilli': 0, 'currentStock': 7.0},
      // Legacy row whose variant points at `id`, not `_id`.
      {'_id': 'doc-1', 'id': 's-legacy', 'currentStock': 2.0},
    ]);

    test('in stock keeps only sellable variants, in order', () {
      expect(
        variantIdsMatchingStock(rows: rows, qtyByStockId: qty, inStock: true),
        ['v-stocked', 'v-by-id-key'],
      );
    });

    test(
      'out of stock takes everything else, including no or unknown stock',
      () {
        expect(
          variantIdsMatchingStock(
            rows: rows,
            qtyByStockId: qty,
            inStock: false,
          ),
          ['v-empty', 'v-no-stock-id', 'v-blank-stock-id', 'v-unknown-stock'],
        );
      },
    );

    test('the two sides partition the catalog', () {
      final inStock = variantIdsMatchingStock(
        rows: rows,
        qtyByStockId: qty,
        inStock: true,
      );
      final outOfStock = variantIdsMatchingStock(
        rows: rows,
        qtyByStockId: qty,
        inStock: false,
      );
      expect(inStock.toSet().intersection(outOfStock.toSet()), isEmpty);
      expect(inStock.length + outOfStock.length, rows.length);
    });

    test('a row without a Ditto _id is skipped rather than fetched', () {
      expect(
        variantIdsMatchingStock(
          rows: [
            {'id': 'no-underscore-id', 'stockId': 's-stocked'},
          ],
          qtyByStockId: qty,
          inStock: true,
        ),
        isEmpty,
      );
    });
  });

  group('stockFilterCatalogQuery', () {
    const filter =
        "SELECT * FROM variants WHERE branchId = :branchId AND name NOT IN ('Cash In')";

    test('projects the same filters and keeps the display order', () {
      expect(
        stockFilterCatalogQuery(filter, ' ORDER BY lastTouched DESC'),
        "SELECT _id, stockId, lastTouched FROM variants WHERE branchId = :branchId "
        "AND name NOT IN ('Cash In') ORDER BY lastTouched DESC",
      );
    });

    test('drops the page window: the filter pages after matching', () {
      expect(
        stockFilterCatalogQuery(
          filter,
          ' ORDER BY lastTouched DESC LIMIT :limit OFFSET :offset',
        ),
        endsWith(' ORDER BY lastTouched DESC'),
      );
    });
  });

  group('pageOfIds', () {
    final ids = [for (var i = 0; i < 7; i++) 'v$i'];

    test('slices the requested page', () {
      expect(pageOfIds(ids, page: 0, itemsPerPage: 3), ['v0', 'v1', 'v2']);
      expect(pageOfIds(ids, page: 2, itemsPerPage: 3), ['v6']);
      expect(pageOfIds(ids, page: 3, itemsPerPage: 3), isEmpty);
    });

    test('returns everything when not paging', () {
      expect(pageOfIds(ids), ids);
    });
  });

  test('idInLookup binds one placeholder per id', () {
    final lookup = idInLookup(['a', 'b']);
    expect(lookup.placeholders, ':id0, :id1');
    expect(lookup.arguments, {'id0': 'a', 'id1': 'b'});
  });

  test('PosStockFilter maps onto the variants() inStock argument', () {
    expect(PosStockFilter.inStock.inStockArg, isTrue);
    expect(PosStockFilter.outOfStock.inStockArg, isFalse);
    expect(PosStockFilter.all.inStockArg, isNull);
  });
}
