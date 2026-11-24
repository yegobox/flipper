import 'package:flipper_models/perf/ui_stall_watchdog.dart';
import 'package:flipper_models/sync/utils/pos_catalog_stock_filter.dart';
import 'package:meta/meta.dart';

/// Runs one stock filter walk; [runStockFilterWalk] unless a test counts them.
typedef StockFilterWalkRunner =
    Future<StockFilterWalk> Function({
      required List<String> catalogJson,
      required List<String> stockJson,
      required bool inStock,
    });

/// The POS grid's stock filter, from the Ditto store to the matching
/// variant ids: reads the catalog projection and the branch's stock as raw
/// JSON, walks them once (off the UI isolate when large, see
/// [runStockFilterWalk]) and keeps recent walks in [matches].
///
/// [ditto] arguments are a `Ditto` (or a test double with the same
/// `store.execute`): rows are read through `items[].jsonString` and
/// `items[].value`.
class PosStockFilterWalker {
  PosStockFilterWalker({
    StockFilterMatchCache? matches,
    @visibleForTesting StockFilterWalkRunner runWalk = runStockFilterWalk,
  }) : matches = matches ?? StockFilterMatchCache(),
       _runWalk = runWalk;

  /// Chunk size for `IN (…)` id lookups, matching the cart cleanup path.
  static const int idLookupChunkSize = 80;

  /// Recent walks; see [StockFilterMatchCache].
  final StockFilterMatchCache matches;

  final StockFilterWalkRunner _runWalk;

  /// The walk for [catalogQuery] with [catalogArgs] (no LIMIT/OFFSET): the
  /// stored one unless [fresh], else a new walk that is stored for the pages
  /// after it.
  ///
  /// The walk covers the whole catalog, so it runs once per listing: a fetch
  /// that keeps the caller's total (next page, prefetch, resize, scroll)
  /// pages through the stored walk instead.
  Future<StockFilterWalk> listing(
    dynamic ditto, {
    required String branchId,
    required String catalogQuery,
    required Map<String, dynamic> catalogArgs,
    required bool inStock,
    required bool fresh,
  }) async {
    final key = stockFilterMatchKey(
      catalogQuery,
      catalogArgs,
      inStock: inStock,
    );
    final stored = fresh ? null : matches.lookup(key);
    if (stored != null) return stored;
    // Raw JSON only: decoding thousands of rows here is what stalled the UI
    // thread on 2 GB phones.
    final catalogJson = await PerfOpTrail.instance.track(
      'variants:stock_catalog',
      () async {
        final r = await ditto.store.execute(
          catalogQuery,
          arguments: catalogArgs,
        );
        return <String>[for (final doc in r.items) doc.jsonString as String];
      },
    );
    return matches.store(
      key,
      await PerfOpTrail.instance.track(
        'variants:stock_qty',
        () => walk(ditto, branchId, catalogJson, inStock: inStock),
      ),
    );
  }

  /// Walks the stock filter for [catalogJson] (the catalog projection's raw
  /// rows) against the branch's stock.
  ///
  /// One scan of the branch's stock rows (`stocks.branchId` is indexed), then a
  /// by-id lookup for any stock id that scan did not return — a row with no
  /// `branchId` still feeds the tile's live stock, so it must count here too.
  /// Those few quantities settle the walk in one cheap pass
  /// ([StockFilterWalk.withExtraQty]); the catalog is decoded and walked once.
  Future<StockFilterWalk> walk(
    dynamic ditto,
    String branchId,
    List<String> catalogJson, {
    required bool inStock,
  }) async {
    final branchStock = await ditto.store.execute(
      stockQtySelectDql(whereClause: 'branchId = :branchId'),
      arguments: {'branchId': branchId},
    );
    final walk = await _runWalk(
      catalogJson: catalogJson,
      stockJson: <String>[
        for (final doc in branchStock.items) doc.jsonString as String,
      ],
      inStock: inStock,
    );
    final missing = walk.unresolvedStockIds;
    if (missing.isEmpty) return walk;

    final extraQty = <String, double>{};
    for (var i = 0; i < missing.length; i += idLookupChunkSize) {
      final end = i + idLookupChunkSize < missing.length
          ? i + idLookupChunkSize
          : missing.length;
      // No catch here: a failed lookup must not read as "0 on hand", which
      // would hide sellable items. It propagates to the caller, which lists
      // the unfiltered page instead. A lookup that simply finds no row still
      // leaves the item out of stock, as the tile shows it.
      final lookup = idInLookup(missing.sublist(i, end));
      final found = await ditto.store.execute(
        stockQtySelectDql(
          whereClause:
              '_id IN (${lookup.placeholders}) OR id IN (${lookup.placeholders})',
        ),
        arguments: lookup.arguments,
      );
      extraQty.addAll(
        stockQtyByIdKeys([
          for (final doc in found.items) Map<String, dynamic>.from(doc.value),
        ]),
      );
    }
    return walk.withExtraQty(extraQty, inStock: inStock);
  }
}
