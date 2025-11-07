import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_services/proxy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profit_provider.g.dart';

@riverpod
class Profit extends _$Profit {
  @override
  Future<double> build(int branchId) async {
    try {
      final capella = await ProxyService.getStrategy(Strategy.capella);
      final transactions = await capella.transactions(
        branchId: branchId,
        status: 'complete',
      );
      double totalRevenue = 0;
      double totalCost = 0;
      String bId = (await ProxyService.strategy.branch(serverId: branchId))!.id.toString();
      for (final transaction in transactions) {
        totalRevenue += transaction.subTotal ?? 0;
        try {
          final items = await capella.transactionItems(
            branchId: bId,
            transactionId: transaction.id.toString(),
          );
          for (final item in items) {
            totalCost += (item.supplyPrice ?? 0) * item.qty;
          }
        } catch (e) {
          continue;
        }
      }
      return totalRevenue - totalCost;
    } catch (e) {
      return 0.0;
    }
  }
}
