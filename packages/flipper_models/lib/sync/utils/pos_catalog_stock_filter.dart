import 'dart:convert';
import 'dart:isolate';

import 'package:flipper_models/sync/utils/stock_qty_milli.dart';
import 'package:meta/meta.dart';

/// Which part of the catalog the POS grid lists while nobody is searching.
///
/// A search always ignores this and matches every item: a cashier who types a
/// name or scans a barcode has to find the product even when it is sold out.
enum PosStockFilter {
  inStock,
  outOfStock,
  all;

  /// The `inStock` argument `VariantInterface.variants` takes; null is no
  /// stock filter at all.
  bool? get inStockArg => switch (this) {
    PosStockFilter.inStock => true,
    PosStockFilter.outOfStock => false,
    PosStockFilter.all => null,
  };
}

/// On-hand quantity of a raw `stocks` row, resolved the way the Capella stock
/// reader does it: the `currentStockMilli` COUNTER wins over the
/// `currentStock` register (see `reference-stock-milli-counter`).
double stockRowQty(Map<String, dynamic> row) {
  final milli = parseStockMilli(row[stockCurrentStockMilliField]);
  if (milli != null) return fromMilli(milli);
  final register = row['currentStock'];
  if (register is num) return register.toDouble();
  if (register is String) return double.tryParse(register) ?? 0;
  return 0;
}

/// Whether a POS tile would render [qty] as sellable. Tiles floor the quantity
/// before comparing (`RowItem._physicalStockValue`), so 0.4 left is already
/// "Out of stock" there — the filter has to agree or it would hide a tile the
/// grid shows as sellable, or list one it refuses to sell.
bool posTileHasStock(num qty) => qty.floor() > 0;

/// Whether a variant's RRA item type is a service (`itemTyCd` `3`). A service
/// keeps no stock, so the POS always sells it and the stock filter lists it
/// as in stock — the same rule Pay's stock check and stock deduction follow.
bool isServiceItemType(Object? itemTyCd) => itemTyCd?.toString().trim() == '3';

/// Quantity per stock id, indexed under both `_id` and `id` because a
/// variant's `stockId` may hold either.
Map<String, double> stockQtyByIdKeys(Iterable<Map<String, dynamic>> rows) {
  final out = <String, double>{};
  for (final row in rows) {
    final qty = stockRowQty(row);
    for (final key in [row['_id'], row['id']]) {
      if (key is String && key.trim().isNotEmpty) out[key.trim()] = qty;
    }
  }
  return out;
}

/// Trimmed `stockId` of a variant row, or null when it has none.
String? variantRowStockId(Map<String, dynamic> row) {
  final sid = row['stockId'];
  if (sid is! String) return null;
  final trimmed = sid.trim();
  return trimmed.isEmpty ? null : trimmed;
}

/// Ditto `_id`s of the variant [rows] on the requested side of the stock line,
/// in the order given.
///
/// A service (see [isServiceItemType]) always counts as in stock. Any other
/// variant with no stock id, or whose stock row is unknown, counts as out of
/// stock — the tile shows it as 0 on hand.
List<String> variantIdsMatchingStock({
  required Iterable<Map<String, dynamic>> rows,
  required Map<String, double> qtyByStockId,
  required bool inStock,
}) {
  final out = <String>[];
  for (final row in rows) {
    final id = row['_id'];
    if (id is! String || id.isEmpty) continue;
    final sid = variantRowStockId(row);
    final has =
        isServiceItemType(row['itemTyCd']) ||
        (sid != null && posTileHasStock(qtyByStockId[sid] ?? 0));
    if (has == inStock) out.add(id);
  }
  return out;
}

/// The light catalog walk behind the stock filter: the same filters as the
/// page query, projected to `_id, stockId, itemTyCd` (plus the sort field,
/// so the ORDER BY never references a column the projection dropped), in the
/// page query's order but without its LIMIT/OFFSET (the filter pages after
/// matching).
///
/// [filterQuery] is the `SELECT * FROM variants WHERE …` the page query was
/// built from; [orderSuffix] is its `ORDER BY …[ LIMIT … OFFSET …]` tail.
String stockFilterCatalogQuery(String filterQuery, String orderSuffix) {
  assert(filterQuery.startsWith('SELECT * '));
  final orderBy = orderSuffix.split(' LIMIT ').first;
  return '${filterQuery.replaceFirst('SELECT * ', 'SELECT _id, stockId, lastTouched, itemTyCd ')}'
      '$orderBy';
}

/// One page of [ids]; every id when the caller is not paging.
List<String> pageOfIds(List<String> ids, {int? page, int? itemsPerPage}) {
  if (page == null || itemsPerPage == null) return ids;
  return ids.skip(page * itemsPerPage).take(itemsPerPage).toList();
}

/// `:id0, :id1, …` placeholders and their arguments for an `IN (…)` lookup —
/// the binding style the POS stock batch read already relies on.
({String placeholders, Map<String, dynamic> arguments}) idInLookup(
  List<String> ids,
) {
  return (
    placeholders: [for (var i = 0; i < ids.length; i++) ':id$i'].join(', '),
    arguments: {for (var i = 0; i < ids.length; i++) 'id$i': ids[i]},
  );
}

/// Stock rows reduced to what [stockRowQty] and [stockQtyByIdKeys] read.
///
/// The filter scans a whole branch's stock, so `SELECT *` would decode every
/// field of every row just to compare one number. The COUNTER is still
/// declared: STRICT_MODE needs the `COLLECTION … (… COUNTER)` form to read it.
String stockQtySelectDql({required String whereClause}) =>
    'SELECT _id, id, currentStock, $stockCurrentStockMilliField '
    'FROM COLLECTION stocks ($stockCurrentStockMilliField COUNTER) '
    'WHERE $whereClause';

/// A catalog row whose stock id no stock row given to the walk answered for
/// (a stock row with no `branchId`). [at] is the row's place in the walk's
/// `matching` list: where it sits while it counts as 0 on hand (out of stock
/// side), or where it goes once it turns out to have stock (in stock side).
typedef UnresolvedStockRow = ({String variantId, String stockId, int at});

/// What one walk of the stock filter found: every catalog row on the asked
/// side of the stock line, in display order.
class StockFilterWalk {
  const StockFilterWalk({
    required this.matching,
    required this.catalogSize,
    this.unresolved = const [],
  });

  /// Ditto `_id`s of the matching variants, in the catalog's order. A row in
  /// [unresolved] counts as 0 on hand here, as its tile shows it.
  final List<String> matching;

  /// Rows the catalog walk saw, matching or not.
  final int catalogSize;

  /// Rows whose stock the walk could not see, in catalog order; see
  /// [withExtraQty].
  final List<UnresolvedStockRow> unresolved;

  /// The distinct stock ids of [unresolved], to look up separately.
  List<String> get unresolvedStockIds => [
    ...{for (final row in unresolved) row.stockId},
  ];

  /// Rows the filter hid.
  int get filteredOut => catalogSize - matching.length;

  /// This walk with [unresolved] settled by [extraQty] (quantities read
  /// separately, by stock id), as if those stock rows had been in the walk.
  ///
  /// One pass over [matching] and no decode: the catalog and its stock are
  /// not walked again. A stock id still missing from [extraQty] stays 0 on
  /// hand. [inStock] must be the side the walk was made for.
  StockFilterWalk withExtraQty(
    Map<String, double> extraQty, {
    required bool inStock,
  }) {
    if (unresolved.isEmpty) return this;
    final stocked = [
      for (final row in unresolved)
        if (posTileHasStock(extraQty[row.stockId] ?? 0)) row,
    ];
    final List<String> settled;
    if (stocked.isEmpty) {
      settled = matching;
    } else if (inStock) {
      // Rows that have stock after all join the list at their place.
      settled = <String>[];
      var next = 0;
      for (final row in stocked) {
        settled
          ..addAll(matching.sublist(next, row.at))
          ..add(row.variantId);
        next = row.at;
      }
      settled.addAll(matching.sublist(next));
    } else {
      // Rows that have stock after all leave the out-of-stock list.
      final leaving = {for (final row in stocked) row.at};
      settled = [
        for (var i = 0; i < matching.length; i++)
          if (!leaving.contains(i)) matching[i],
      ];
    }
    return StockFilterWalk(matching: settled, catalogSize: catalogSize);
  }
}

/// The stock filter's join, from the raw JSON Ditto hands back for each row
/// ([catalogJson]: the `_id, stockId, itemTyCd` projection; [stockJson]:
/// [stockQtySelectDql] rows).
///
/// Pure Dart on purpose, so [runStockFilterWalk] can run it off the UI
/// isolate: decoding a whole catalog and its stock is the part that froze
/// 2 GB phones for seconds. Matches [variantIdsMatchingStock] row for row,
/// and also records the rows whose stock row it was not given.
StockFilterWalk walkStockFilter({
  required List<String> catalogJson,
  required List<String> stockJson,
  required bool inStock,
}) {
  final qty = stockQtyByIdKeys([
    for (final json in stockJson) jsonDecode(json) as Map<String, dynamic>,
  ]);
  final matching = <String>[];
  final unresolved = <UnresolvedStockRow>[];
  for (final json in catalogJson) {
    final row = jsonDecode(json) as Map<String, dynamic>;
    final id = row['_id'];
    if (id is! String || id.isEmpty) continue;
    final bool has;
    if (isServiceItemType(row['itemTyCd'])) {
      has = true;
    } else {
      final sid = variantRowStockId(row);
      final known = sid == null ? null : qty[sid];
      if (sid != null && known == null) {
        unresolved.add((variantId: id, stockId: sid, at: matching.length));
      }
      has = known != null && posTileHasStock(known);
    }
    if (has == inStock) matching.add(id);
  }
  return StockFilterWalk(
    matching: matching,
    catalogSize: catalogJson.length,
    unresolved: unresolved,
  );
}

/// Rows (catalog plus stock) from which [runStockFilterWalk] moves the walk
/// to a background isolate. Below it, starting an isolate costs more than the
/// walk itself.
const int stockFilterIsolateMinRows = 300;

/// Runs a stock filter walk somewhere other than the calling isolate.
typedef StockFilterIsolateRunner =
    Future<StockFilterWalk> Function(StockFilterWalk Function() walk);

Future<StockFilterWalk> _runOnIsolate(StockFilterWalk Function() walk) =>
    Isolate.run(walk, debugName: 'pos_stock_filter');

/// Runs [walkStockFilter], through [isolateRunner] (a background isolate)
/// once the input reaches [stockFilterIsolateMinRows] rows. Only plain
/// strings and numbers cross the isolate boundary; every Ditto call stays on
/// the caller's isolate.
Future<StockFilterWalk> runStockFilterWalk({
  required List<String> catalogJson,
  required List<String> stockJson,
  required bool inStock,
  @visibleForTesting StockFilterIsolateRunner isolateRunner = _runOnIsolate,
}) {
  StockFilterWalk walk() => walkStockFilter(
    catalogJson: catalogJson,
    stockJson: stockJson,
    inStock: inStock,
  );
  if (catalogJson.length + stockJson.length < stockFilterIsolateMinRows) {
    return Future.value(walk());
  }
  return isolateRunner(walk);
}

/// The key a [StockFilterMatchCache] entry is stored under: the catalog
/// query, its arguments (in key order) and the side of the stock line.
String stockFilterMatchKey(
  String catalogQuery,
  Map<String, dynamic> arguments, {
  required bool inStock,
}) {
  final keys = arguments.keys.toList()..sort();
  final args = jsonEncode({for (final k in keys) k: arguments[k]});
  return '$inStock|$catalogQuery|$args';
}

/// Recent stock filter walks, so paging through a listing does not walk the
/// whole catalog and its stock again for every page.
///
/// The first page of a listing (build, refresh, search cleared) always walks
/// afresh and stores the result here; later pages, prefetches, a resize and
/// scroll "load more" — every fetch that keeps the total it already has —
/// page through the stored ids. A product that sells out meanwhile stays
/// listed on those pages until the next first page, and its tile still shows
/// the live quantity; a deleted one simply drops out, because its document is
/// gone. [ttl] bounds how long that can last.
class StockFilterMatchCache {
  StockFilterMatchCache({
    this.ttl = const Duration(minutes: 2),
    this.maxEntries = 4,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final Duration ttl;
  final int maxEntries;
  final DateTime Function() _clock;
  final Map<String, ({StockFilterWalk walk, DateTime at})> _entries = {};

  /// The walk stored under [key], or null when there is none or it is older
  /// than [ttl].
  StockFilterWalk? lookup(String key) {
    final entry = _entries[key];
    if (entry == null) return null;
    if (_clock().difference(entry.at) > ttl) {
      _entries.remove(key);
      return null;
    }
    return entry.walk;
  }

  /// Stores [walk] under [key], dropping the oldest entry past [maxEntries].
  StockFilterWalk store(String key, StockFilterWalk walk) {
    _entries.remove(key);
    _entries[key] = (walk: walk, at: _clock());
    while (_entries.length > maxEntries) {
      _entries.remove(_entries.keys.first);
    }
    return walk;
  }

  void clear() => _entries.clear();
}
