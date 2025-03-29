// ignore_for_file: unused_result

import 'dart:async';

import 'package:flipper_dashboard/TextEditingControllersMixin.dart';
import 'package:flipper_models/view_models/mixins/_transaction.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';

mixin BaseCartMixin<T extends ConsumerStatefulWidget>
    on ConsumerState<T>, TransactionMixinOld, TextEditingControllersMixin {
  Future<void> refreshTransactionItems({required String transactionId}) async {
    ref.refresh(transactionItemsProvider(transactionId: transactionId));

    ref.refresh(pendingTransactionStreamProvider(isExpense: false));

    ref.refresh(pendingTransactionStreamProvider(isExpense: false));

    ref.refresh(transactionItemsProvider(transactionId: transactionId));
  }

  String getCartItemCount({required String transactionId}) {
    return ref
            .watch(transactionItemsProvider(transactionId: transactionId))
            .value
            ?.length
            .toString() ??
        '0';
  }

  double getSumOfItems({required String transactionId}) {
    final transactionItems =
        ref.watch(transactionItemsProvider(transactionId: transactionId));

    if (transactionItems.hasValue) {
      return transactionItems.value!.fold(
        0,
        (sum, item) => sum + (item.price * item.qty),
      );
    }
    return 0.0;
  }

  void handleTicketNavigation(ITransaction transaction) {
    locator<RouterService>()
        .navigateTo(TicketsListRoute(transaction: transaction));
  }
}
