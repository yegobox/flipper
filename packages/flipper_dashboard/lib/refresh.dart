// ignore_for_file: unused_result

import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';

mixin Refresh<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  Future<void> refreshTransactionItems({required String transactionId}) async {
    try {
      final isOrdering = ProxyService.box.isOrdering() ?? false;

      /// clear the current cart
      ref.refresh(transactionItemsProvider(transactionId: transactionId));

      ref.refresh(pendingTransactionStreamProvider(isExpense: isOrdering));

      /// get new transaction id
      ref.refresh(pendingTransactionStreamProvider(isExpense: isOrdering));

      ref.refresh(transactionItemsProvider(transactionId: transactionId));
      ref.read(loadingProvider.notifier).stopLoading();
    } catch (e) {}
  }

  Future<void> refreshPendingTransactionWithExpense(
      {required String transactionId}) async {
    /// clear the current cart

    ref.refresh(pendingTransactionStreamProvider(isExpense: true));

    /// get new transaction id
    ref.refresh(pendingTransactionStreamProvider(isExpense: true));

    ref.refresh(transactionItemsProvider(transactionId: transactionId));
  }
}
