import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/outer_variant_provider.dart';
import 'package:flipper_services/proxy.dart';
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
