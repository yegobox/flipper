import 'package:flipper_models/providers/business_analytic_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profit_provider.g.dart';

@riverpod
class Profit extends _$Profit {
  @override
  Future<double> build(int branchId) async {
    final analytics =
        await ref.watch(fetchStockPerformanceProvider(branchId).future);
    return analytics.fold<double>(
        0, (sum, analytic) => sum + (analytic.profit));
  }
}
