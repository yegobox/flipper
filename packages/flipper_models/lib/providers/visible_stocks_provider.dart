import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/outer_variant_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show StreamProvider;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'visible_stocks_provider.g.dart';

/// One Ditto observer for all stock rows on the current catalog page (max ~15).
///
/// [stockFilter] must match the catalog the grid renders, or the observer
/// watches another page's stock rows.
@riverpod
Stream<Map<String, Stock?>> stocksForVisibleVariants(
  Ref ref,
  String branchId, {
  PosStockFilter stockFilter = PosStockFilter.all,
}) {
  final variantsAsync = ref.watch(
    outerVariantsProvider(branchId, stockFilter: stockFilter),
  );
  final variants = variantsAsync.asData?.value ?? const <Variant>[];
  final stockIds = variants
      .map((v) => v.stockId)
      .whereType<String>()
      .where((id) => id.isNotEmpty)
      .toSet()
      .toList();

  if (stockIds.isEmpty) {
    return Stream.value(const {});
  }

  return ProxyService.getStrategy(Strategy.capella).watchStocksByIds(stockIds);
}

/// The key [stocksByIdsProvider] is read with: the stock ids of a list's
/// rows, sorted, so the same rows in another order share one observer.
String stockIdsKey(Iterable<Variant> variants) {
  final ids =
      variants
          .map((v) => v.stockId?.trim() ?? '')
          .where((id) => id.isNotEmpty)
          .toSet()
          .toList()
        ..sort();
  return ids.join(',');
}

/// One Ditto observer for the stock of every row in a list that is not the
/// POS catalog (the ordering grid, the Items dialog). Read it with
/// [stockIdsKey].
///
/// Each row used to open its own observer, a synchronous Ditto call on the UI
/// thread, again on every search keystroke. While Ditto was busy that froze
/// the till (2026-11-09).
final stocksByIdsProvider = StreamProvider.autoDispose
    .family<Map<String, Stock?>, String>((ref, key) {
      if (key.isEmpty) return Stream.value(const <String, Stock?>{});
      return ProxyService.getStrategy(
        Strategy.capella,
      ).watchStocksByIds(key.split(','));
    });
