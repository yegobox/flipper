import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_services/proxy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stock_value_provider.g.dart';

@riverpod
Future<double> StockValue(Ref ref, {required int branchId}) async {
  try {
    final capella = await ProxyService.getStrategy(Strategy.capella);
    final variants = await capella.variants(branchId: branchId, taxTyCds: ['A','B','C','D','TT']);
    double totalValue = 0;
    
    for (final variant in variants.variants) {
      if (variant.stockId != null) {
        try {
          final stock = await capella.getStockById(id: variant.stockId!);
          totalValue += (stock.currentStock ?? 0) * (variant.retailPrice ?? 0);
        } catch (e) {
          // Skip this variant if stock not found
          continue;
        }
      }
    }
    return totalValue;
  } catch (e) {
    return 0.0;
  }
}
