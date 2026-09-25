import 'package:flipper_models/sync/utils/stock_qty_milli.dart';

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
/// A variant with no stock id, or whose stock row is unknown, counts as out of
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
    final has = sid != null && posTileHasStock(qtyByStockId[sid] ?? 0);
    if (has == inStock) out.add(id);
  }
  return out;
}

/// The light catalog walk behind the stock filter: the same filters as the
/// page query, projected to `_id, stockId` (plus the sort field, so the
/// ORDER BY never references a column the projection dropped), in the page
/// query's order but without its LIMIT/OFFSET (the filter pages after
/// matching).
///
/// [filterQuery] is the `SELECT * FROM variants WHERE …` the page query was
/// built from; [orderSuffix] is its `ORDER BY …[ LIMIT … OFFSET …]` tail.
String stockFilterCatalogQuery(String filterQuery, String orderSuffix) {
  assert(filterQuery.startsWith('SELECT * '));
  final orderBy = orderSuffix.split(' LIMIT ').first;
  return '${filterQuery.replaceFirst('SELECT * ', 'SELECT _id, stockId, lastTouched ')}'
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
