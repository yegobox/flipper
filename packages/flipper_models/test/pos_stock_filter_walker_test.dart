import 'dart:convert';

import 'package:flipper_models/sync/utils/pos_catalog_stock_filter.dart';
import 'package:flipper_models/sync/utils/pos_stock_filter_walker.dart';
import 'package:flutter_test/flutter_test.dart';

class _Item {
  _Item(this.value);
  final Map<String, dynamic> value;
  String get jsonString => jsonEncode(value);
}

class _Result {
  _Result(this.items);
  final List<_Item> items;
}

/// Answers the three statements the walker issues: the catalog projection,
/// the branch stock scan and the by-id stock lookup.
class _Store {
  _Store({required this.catalog, required this.branchStock, this.offBranch});

  final List<Map<String, dynamic>> catalog;
  final List<Map<String, dynamic>> branchStock;

  /// Stock rows with no `branchId`, found only by id.
  final List<Map<String, dynamic>>? offBranch;

  final executed = <String>[];
  Object? failLookup;

  Future<_Result> execute(String sql, {Map<String, dynamic>? arguments}) async {
    executed.add(sql);
    if (sql.contains('branchId = :branchId')) {
      return _Result([for (final row in branchStock) _Item(row)]);
    }
    if (sql.contains('_id IN (')) {
      if (failLookup != null) throw failLookup!;
      final ids = arguments!.values.toSet();
      return _Result([
        for (final row in offBranch ?? const <Map<String, dynamic>>[])
          if (ids.contains(row['_id'])) _Item(row),
      ]);
    }
    return _Result([for (final row in catalog) _Item(row)]);
  }

  int count(String fragment) =>
      executed.where((sql) => sql.contains(fragment)).length;
}

class _Ditto {
  _Ditto(this.store);
  final _Store store;
}

/// The POS stock filter reads the catalog and stock once per listing and,
/// when some stock rows have no `branchId`, settles them without a second
/// walk: on a 2 GB phone a second decode of the catalog was a second stall.
void main() {
  Map<String, dynamic> variant(String id, {String? stockId, String? type}) => {
    '_id': id,
    'stockId': ?stockId,
    'itemTyCd': ?type,
  };
  Map<String, dynamic> stock(String id, double qty) => {
    '_id': id,
    'id': id,
    'currentStock': qty,
  };

  final catalog = [
    variant('v1', stockId: 's1'), // 5 on hand
    variant('v2', stockId: 's2'), // 0
    variant('v3'), // no stock id
    variant('v4', stockId: 's6'), // stock row with no branchId: 2 on hand
    variant('v5', type: '3'), // service
    variant('v6', stockId: 's7'), // stock row nowhere
  ];
  final branchStock = [stock('s1', 5), stock('s2', 0)];
  final offBranch = [stock('s6', 2)];

  ({PosStockFilterWalker walker, List<bool> walks}) counted() {
    final walks = <bool>[];
    return (
      walker: PosStockFilterWalker(
        runWalk:
            ({
              required List<String> catalogJson,
              required List<String> stockJson,
              required bool inStock,
            }) {
              walks.add(inStock);
              return runStockFilterWalk(
                catalogJson: catalogJson,
                stockJson: stockJson,
                inStock: inStock,
              );
            },
      ),
      walks: walks,
    );
  }

  List<String> json(List<Map<String, dynamic>> rows) => [
    for (final row in rows) jsonEncode(row),
  ];

  test('unresolved stock ids cost one walk, with the answer of two', () async {
    for (final side in [true, false]) {
      final store = _Store(
        catalog: catalog,
        branchStock: branchStock,
        offBranch: offBranch,
      );
      final c = counted();
      final walk = await c.walker.walk(
        _Ditto(store),
        'b1',
        json(catalog),
        inStock: side,
      );

      expect(c.walks, [side], reason: 'one walk, inStock: $side');
      expect(store.count('_id IN ('), 1);

      // What the old second walk, with the looked-up stock, answered.
      final twoWalks = walkStockFilter(
        catalogJson: json(catalog),
        stockJson: json([...branchStock, ...offBranch]),
        inStock: side,
      );
      expect(walk.matching, twoWalks.matching);
      expect(walk.catalogSize, twoWalks.catalogSize);
      expect(walk.unresolved, isEmpty);
    }
  });

  test('the in-stock side lists a row whose stock has no branchId', () async {
    final walk = await PosStockFilterWalker().walk(
      _Ditto(
        _Store(
          catalog: catalog,
          branchStock: branchStock,
          offBranch: offBranch,
        ),
      ),
      'b1',
      json(catalog),
      inStock: true,
    );
    expect(walk.matching, ['v1', 'v4', 'v5']);
    expect(walk.filteredOut, 3);
  });

  test('every stock row in the branch scan: no lookup', () async {
    final store = _Store(
      catalog: catalog,
      branchStock: [...branchStock, ...offBranch, stock('s7', 0)],
    );
    final c = counted();
    final walk = await c.walker.walk(
      _Ditto(store),
      'b1',
      json(catalog),
      inStock: false,
    );
    expect(c.walks, [false]);
    expect(store.count('_id IN ('), 0);
    expect(walk.matching, ['v2', 'v3', 'v6']);
  });

  test('lookups go in chunks of the documented size', () async {
    final many = [
      for (var i = 0; i < PosStockFilterWalker.idLookupChunkSize + 5; i++)
        variant('m$i', stockId: 'x$i'),
    ];
    final store = _Store(
      catalog: many,
      branchStock: const [],
      offBranch: [
        for (var i = 0; i < many.length; i++) stock('x$i', i.isEven ? 1 : 0),
      ],
    );
    final c = counted();
    final walk = await c.walker.walk(
      _Ditto(store),
      'b1',
      json(many),
      inStock: true,
    );
    expect(c.walks, hasLength(1));
    expect(store.count('_id IN ('), 2);
    expect(walk.matching, [for (var i = 0; i < many.length; i += 2) 'm$i']);
  });

  test('a failed lookup is an error, never "0 on hand"', () async {
    final store = _Store(catalog: catalog, branchStock: branchStock)
      ..failLookup = StateError('ditto closed');
    await expectLater(
      PosStockFilterWalker().walk(
        _Ditto(store),
        'b1',
        json(catalog),
        inStock: true,
      ),
      throwsStateError,
    );
  });

  group('listing', () {
    Future<StockFilterWalk> list(
      PosStockFilterWalker walker,
      _Store store, {
      required bool fresh,
      bool inStock = true,
    }) => walker.listing(
      _Ditto(store),
      branchId: 'b1',
      catalogQuery: 'SELECT _id, stockId FROM variants',
      catalogArgs: {'branchId': 'b1'},
      inStock: inStock,
      fresh: fresh,
    );

    test('pages after the first reuse its walk; a fresh one walks', () async {
      final store = _Store(
        catalog: catalog,
        branchStock: branchStock,
        offBranch: offBranch,
      );
      final c = counted();

      final first = await list(c.walker, store, fresh: true);
      expect(first.matching, ['v1', 'v4', 'v5']);
      expect(c.walks, hasLength(1));

      final next = await list(c.walker, store, fresh: false);
      expect(next, same(first));
      expect(c.walks, hasLength(1));
      expect(store.count('FROM variants'), 1);

      await list(c.walker, store, fresh: true);
      expect(c.walks, hasLength(2));
      expect(store.count('FROM variants'), 2);
    });

    test('the other side of the stock line is its own walk', () async {
      final store = _Store(catalog: catalog, branchStock: branchStock);
      final c = counted();
      await list(c.walker, store, fresh: true);
      final out = await list(c.walker, store, fresh: false, inStock: false);
      expect(c.walks, [true, false]);
      expect(out.matching, ['v2', 'v3', 'v4', 'v6']);
    });
  });
}
