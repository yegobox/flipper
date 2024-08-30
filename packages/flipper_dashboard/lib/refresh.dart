// ignore_for_file: unused_result

import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin Refresh<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  Future<void> refreshTransactionItems({required int transactionId}) async {
    /// clear the current cart
    ref.refresh(freshtransactionItemsProviderByIdProvider(
        (transactionId: transactionId)));

    ref.refresh(pendingTransactionProviderNonStream(
        (isExpense: false, mode: TransactionType.sale)));

    /// get new transaction id
    ref.refresh(pendingTransactionProvider(
        (mode: TransactionType.sale, isExpense: false)));

   
    ref.refresh(transactionItemsProvider((isExpense: false)));
    ref.read(loadingProvider.notifier).state = false;
  }
}
