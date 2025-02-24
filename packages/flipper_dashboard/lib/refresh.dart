// ignore_for_file: unused_result

import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';

mixin Refresh<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  Future<void> refreshTransactionItems({required String transactionId}) async {
    try {
      /// clear the current cart
      ref.refresh(transactionItemsProvider(transactionId: transactionId));

      ref.read(loadingProvider.notifier).stopLoading();
    } catch (e) {}
  }

  Future<void> newTransaction(
      {required bool typeOfThisTransactionIsExpense}) async {
    await ref.refresh(pendingTransactionStreamProvider(isExpense: false));
  }

  Future<void> refreshPendingTransactionWithExpense(
      {required String transactionId}) async {
    /// clear the current cart

    ref.refresh(pendingTransactionStreamProvider(isExpense: true));
  }
}
