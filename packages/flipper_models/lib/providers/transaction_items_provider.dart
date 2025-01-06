import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transaction_items_provider.g.dart';

@riverpod
Future<List<TransactionItem>> transactionItems(
  Ref ref, {
  required String transactionId,
  required int branchId,
}) async {
  return await ProxyService.strategy.transactionItems(
    transactionId: transactionId,
    doneWithTransaction: false,
    branchId: branchId,
    active: true,
  );
}

@riverpod
Stream<List<TransactionItem>> transactionItemsStream(
  Ref ref, {
  required String transactionId,
  required int branchId,
}) {
  return ProxyService.strategy.transactionItemsStreams(
    branchId: branchId,
    transactionId: transactionId,
    doneWithTransaction: false,
    active: true,
  );
}
