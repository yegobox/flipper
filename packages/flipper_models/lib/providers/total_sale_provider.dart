import 'package:flipper_models/providers/business_analytic_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'total_sale_provider.g.dart';

@riverpod
Future<double> TotalSale(Ref ref, {required int branchId}) async {
  final analytics =
      await ref.watch(fetchStockPerformanceProvider(branchId).future);
  return analytics.fold<double>(0, (sum, analytic) => sum + analytic.value);
}
