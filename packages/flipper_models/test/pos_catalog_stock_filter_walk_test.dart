import 'dart:convert';

import 'package:flipper_models/sync/utils/pos_catalog_stock_filter.dart';
import 'package:flutter_test/flutter_test.dart';

/// The stock filter's join runs on raw JSON so it can leave the UI isolate:
/// decoding a whole catalog and its stock on the main isolate stalled 2 GB
/// phones for seconds (PostHog `ui_stall`, `variants:stock_*`).
void main() {
  String row(String id, {String? stockId, String? itemTyCd}) => jsonEncode({
    '_id': id,
    'stockId': ?stockId,
    'itemTyCd': ?itemTyCd,
    'lastTouched': '2026-11-20T00:00:00Z',
  });
  String stock(String id, double qty) =>
      jsonEncode({'_id': id, 'id': id, 'currentStock': qty});

  final catalog = [
    row('v1', stockId: 's1'), // 5 on hand
    row('v2', stockId: 's2'), // 0
    row('v3'), // no stock id
    row('v4', stockId: 's4'), // 0.5: the tile shows it out
    row('v5', itemTyCd: '3'), // service
    row('v6', stockId: 's6'), // stock row not in the branch scan
  ];
  final stocks = [stock('s1', 5), stock('s2', 0), stock('s4', 0.5)];

  group('walkStockFilter', () {
    test('lists each side of the stock line in catalog order', () {
      final inStock = walkStockFilter(
        catalogJson: catalog,
        stockJson: stocks,
        inStock: true,
      );
      expect(inStock.matching, ['v1', 'v5']);
      expect(inStock.catalogSize, 6);
      expect(inStock.filteredOut, 4);

      final out = walkStockFilter(
        catalogJson: catalog,
        stockJson: stocks,
        inStock: false,
      );
      expect(out.matching, ['v2', 'v3', 'v4', 'v6']);
    });

    test('names the stock ids the branch scan did not answer for', () {
      final walk = walkStockFilter(
        catalogJson: catalog,
        stockJson: stocks,
        inStock: true,
      );
      expect(walk.unresolvedStockIds, ['s6']);
    });

    test('a quantity read separately counts like a scanned one', () {
      final walk = walkStockFilter(
        catalogJson: catalog,
        stockJson: stocks,
        inStock: true,
        extraQty: {'s6': 2},
      );
      expect(walk.matching, ['v1', 'v5', 'v6']);
      expect(walk.unresolvedStockIds, isEmpty);
    });

    test('agrees with the map-based join it replaced', () {
      final rows = [
        for (final json in catalog) jsonDecode(json) as Map<String, dynamic>,
      ];
      final qty = stockQtyByIdKeys([
        for (final json in stocks) jsonDecode(json) as Map<String, dynamic>,
      ]);
      for (final side in [true, false]) {
        expect(
          walkStockFilter(
            catalogJson: catalog,
            stockJson: stocks,
            inStock: side,
          ).matching,
          variantIdsMatchingStock(rows: rows, qtyByStockId: qty, inStock: side),
        );
      }
    });
  });

  group('runStockFilterWalk', () {
    test(
      'a large catalog walks on a background isolate, same answer',
      () async {
        final bigCatalog = [
          for (var i = 0; i < stockFilterIsolateMinRows; i++)
            row('v$i', stockId: 's$i'),
        ];
        final bigStock = [
          for (var i = 0; i < stockFilterIsolateMinRows; i++)
            stock('s$i', i.isEven ? 3 : 0),
        ];
        final walk = await runStockFilterWalk(
          catalogJson: bigCatalog,
          stockJson: bigStock,
          inStock: true,
        );
        final inline = walkStockFilter(
          catalogJson: bigCatalog,
          stockJson: bigStock,
          inStock: true,
        );
        expect(walk.matching, inline.matching);
        expect(walk.matching, hasLength(stockFilterIsolateMinRows ~/ 2));
        expect(walk.catalogSize, stockFilterIsolateMinRows);
      },
    );

    test('a small catalog walks inline', () async {
      final walk = await runStockFilterWalk(
        catalogJson: catalog,
        stockJson: stocks,
        inStock: true,
        extraQty: {'s6': 1},
      );
      expect(walk.matching, ['v1', 'v5', 'v6']);
    });
  });

  group('StockFilterMatchCache', () {
    const walk = StockFilterWalk(matching: ['a'], catalogSize: 3);

    test('keys ignore argument order but not the stock side', () {
      const q = 'SELECT _id FROM variants';
      expect(
        stockFilterMatchKey(q, {'a': 1, 'b': 2}, inStock: true),
        stockFilterMatchKey(q, {'b': 2, 'a': 1}, inStock: true),
      );
      expect(
        stockFilterMatchKey(q, {'a': 1}, inStock: true),
        isNot(stockFilterMatchKey(q, {'a': 1}, inStock: false)),
      );
      expect(
        stockFilterMatchKey(q, {
          'ex': ['x'],
        }, inStock: true),
        isNot(
          stockFilterMatchKey(q, {
            'ex': ['y'],
          }, inStock: true),
        ),
      );
    });

    test('serves a walk until it is older than the ttl', () {
      var now = DateTime(2026, 11, 23, 10);
      final cache = StockFilterMatchCache(
        ttl: const Duration(minutes: 2),
        clock: () => now,
      );
      expect(cache.lookup('k'), isNull);
      expect(cache.store('k', walk), same(walk));

      now = now.add(const Duration(minutes: 2));
      expect(cache.lookup('k'), same(walk));

      now = now.add(const Duration(seconds: 1));
      expect(cache.lookup('k'), isNull);
    });

    test('keeps only the newest entries', () {
      final cache = StockFilterMatchCache(maxEntries: 2);
      cache
        ..store('a', walk)
        ..store('b', walk)
        ..store('c', walk);
      expect(cache.lookup('a'), isNull);
      expect(cache.lookup('b'), same(walk));
      expect(cache.lookup('c'), same(walk));

      cache.clear();
      expect(cache.lookup('c'), isNull);
    });

    test('a re-stored key counts as new', () {
      final cache = StockFilterMatchCache(maxEntries: 2);
      cache
        ..store('a', walk)
        ..store('b', walk)
        ..store('a', walk)
        ..store('c', walk);
      expect(cache.lookup('b'), isNull);
      expect(cache.lookup('a'), same(walk));
    });
  });
}
