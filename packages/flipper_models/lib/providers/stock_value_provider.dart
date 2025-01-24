import 'package:flipper_services/proxy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stock_value_provider.g.dart';

@riverpod
Stream<double> StockValue(Ref ref, {required int branchId}) {
  return ProxyService.strategy.wholeStockValue(branchId: branchId);
}
