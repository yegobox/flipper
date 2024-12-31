// ignore_for_file: unused_result

import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin Refresh<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  Future<void> refreshTransactionItems({required String transactionId}) async {
    try {
      final isOrdering = ProxyService.box.isOrdering() ?? false;

      /// clear the current cart
      ref.refresh(freshtransactionItemsProviderByIdProvider(
          (transactionId: transactionId)));

      ref.refresh(pendingTransactionProviderNonStream(
          (isExpense: isOrdering, mode: TransactionType.sale)));
final branchId = ProxyService.box.getBranchId()!;
      /// get new transaction id
      ref.refresh(pendingTransactionProvider(
          (mode: TransactionType.sale, isExpense: isOrdering,branchId: branchId)));

      ref.refresh(transactionItemsProvider((isExpense: isOrdering)));
      ref.read(loadingProvider.notifier).stopLoading();
    } catch (e) {}
  }

  Future<void> refreshPendingTransactionWithExpense() async {
    /// clear the current cart

    ref.refresh(pendingTransactionProviderNonStream(
        (isExpense: true, mode: TransactionType.cashOut)));
final branchId = ProxyService.box.getBranchId()!;
    /// get new transaction id
    ref.refresh(pendingTransactionProvider(
        (mode: TransactionType.cashOut, isExpense: true,branchId: branchId)));

    ref.refresh(transactionItemsProvider((isExpense: true)));
  }
}
