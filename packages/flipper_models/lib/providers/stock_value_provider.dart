import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_services/proxy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stock_value_provider.g.dart';

@riverpod
Future<double> StockValue(Ref ref, {required String branchId}) async {
  try {
    final capella = await ProxyService.getStrategy(Strategy.capella);
    final analytics = await capella.analytics(branchId: branchId);

    // Sum up stock values from the latest analytics records
    return analytics.fold<double>(
      0,
      (sum, analytic) => sum + analytic.stockValue!,
    );
  } catch (e) {
    return 0.0;
  }
}
