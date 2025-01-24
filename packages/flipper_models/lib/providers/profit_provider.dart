import 'package:flipper_services/proxy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profit_provider.g.dart';

@riverpod
class Profit extends _$Profit {
  @override
  Future<double> build(int branchId) async {
    // Fetch profit and cost from your data source
    final profit = await ProxyService.strategy.fetchProfit(branchId);
    final cost = await ProxyService.strategy.fetchCost(branchId);
    return profit - cost; // Calculate profit vs cost
  }
}
