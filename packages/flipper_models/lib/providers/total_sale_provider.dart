import 'package:flipper_services/proxy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'total_sale_provider.g.dart';

@riverpod
Stream<double> TotalSale(Ref ref, {required int branchId}) {
  return ProxyService.strategy.totalSales(branchId: branchId);
}
