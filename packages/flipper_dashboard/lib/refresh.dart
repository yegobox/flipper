// ignore_for_file: unused_result

import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin Refresh<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  Future<void> refreshTransactionItems({required int transactionId}) async {
    try {
      final isOrdering = ProxyService.box.isOrdering() ?? false;

      /// clear the current cart
      ref.refresh(freshtransactionItemsProviderByIdProvider(
          (transactionId: transactionId)));

      ref.refresh(pendingTransactionProviderNonStream(
          (isExpense: isOrdering, mode: TransactionType.sale)));

      /// get new transaction id
      ref.refresh(pendingTransactionProvider(
          (mode: TransactionType.sale, isExpense: isOrdering)));

      ref.refresh(transactionItemsProvider((isExpense: isOrdering)));
      ref.read(loadingProvider.notifier).state = false;
    } catch (e) {}
  }

  Future<void> refreshPendingTransactionWithExpense() async {
    /// clear the current cart

    ref.refresh(pendingTransactionProviderNonStream(
        (isExpense: true, mode: TransactionType.cashOut)));

    /// get new transaction id
    ref.refresh(pendingTransactionProvider(
        (mode: TransactionType.cashOut, isExpense: true)));

    ref.refresh(transactionItemsProvider((isExpense: true)));
  }
}
