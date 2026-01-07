import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'transaction_items_provider.g.dart';

@riverpod
Future<List<TransactionItem>> transactionItems(Ref ref,
    {String? transactionId,
    String? requestId,
    String? branchId,
    bool fetchRemote = false,
    bool doneWithTransaction = false}) async {
  return await ProxyService.getStrategy(Strategy.capella).transactionItems(
    transactionId: transactionId,
    doneWithTransaction: doneWithTransaction,
    branchId: (await ProxyService.strategy
            .activeBranch(branchId: ProxyService.box.getBranchId()!))
        .id,
    active: true,
    fetchRemote: fetchRemote,
    requestId: requestId,
  );
}

@riverpod
Stream<List<TransactionItem>> transactionItemsStream(
  Ref ref, {
  String? transactionId,
  String? branchId,
  String? requestId,
  bool fetchRemote = false,
  bool doneWithTransaction = false,
  bool forceRealData = true,
}) {
  return ProxyService.strategy.transactionItemsStreams(
    branchId: branchId,
    transactionId: transactionId,
    doneWithTransaction: doneWithTransaction,
    active: true,
    requestId: requestId,
    fetchRemote: fetchRemote,
    forceRealData: forceRealData,
  );
}
