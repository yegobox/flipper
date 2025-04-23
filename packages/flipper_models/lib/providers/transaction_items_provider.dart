import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'transaction_items_provider.g.dart';

@riverpod
Future<List<TransactionItem>> transactionItems(Ref ref,
    {String? transactionId,
    String? requestId,
    int? branchId,
    bool fetchRemote = false,
    bool doneWithTransaction = false}) async {
  return await ProxyService.strategy.transactionItems(
    transactionId: transactionId,
    doneWithTransaction: doneWithTransaction,
    branchId: (await ProxyService.strategy.activeBranch()).id,
    active: true,
    fetchRemote: fetchRemote,
    requestId: requestId,
  );
}

@riverpod
Stream<List<TransactionItem>> transactionItemsStream(
  Ref ref, {
  String? transactionId,
  int? branchId,
  String? requestId,
  bool fetchRemote = false,
  bool doneWithTransaction = false,
}) {
  return ProxyService.strategy.transactionItemsStreams(
    branchId: branchId,
    transactionId: transactionId,
    doneWithTransaction: doneWithTransaction,
    active: true,
    requestId: requestId,
    fetchRemote: fetchRemote,
  );
}
