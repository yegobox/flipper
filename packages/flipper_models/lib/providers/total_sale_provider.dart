import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_services/proxy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'total_sale_provider.g.dart';

@riverpod
Future<double> TotalSale(Ref ref, {required int branchId}) async {
  try {
    final capella = await ProxyService.getStrategy(Strategy.capella);
    final transactions = await capella.transactions(
      branchId: branchId,
      status: 'complete',
    );
    return transactions.fold<double>(0, (sum, transaction) => sum + (transaction.subTotal ?? 0));
  } catch (e) {
    return 0.0;
  }
}
