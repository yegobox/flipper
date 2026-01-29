import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'transaction_items_provider.g.dart';

@riverpod
Future<List<TransactionItem>> transactionItems(
  Ref ref, {
  String? transactionId,
  String? requestId,
  String? branchId,
  bool fetchRemote = false,
  bool doneWithTransaction = false,
}) async {
  final effectiveBranchId = branchId ?? ProxyService.box.getBranchId()!;
  return await ProxyService.strategy.transactionItems(
    transactionId: transactionId,
    doneWithTransaction: doneWithTransaction,
    branchId: effectiveBranchId,
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
  final effectiveBranchId = branchId ?? ProxyService.box.getBranchId();
  return ProxyService.strategy.transactionItemsStreams(
    branchId: effectiveBranchId,
    transactionId: transactionId,
    doneWithTransaction: doneWithTransaction,
    active: true,
    requestId: requestId,
    fetchRemote: fetchRemote,
    forceRealData: forceRealData,
  );
}
