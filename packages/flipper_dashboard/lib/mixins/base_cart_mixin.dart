// ignore_for_file: unused_result

import 'dart:async';

import 'package:flipper_dashboard/TextEditingControllersMixin.dart';
import 'package:flipper_models/view_models/mixins/_transaction.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

mixin BaseCartMixin<T extends ConsumerStatefulWidget>
    on ConsumerState<T>, TransactionMixin, TextEditingControllersMixin {
  Future<void> refreshTransactionItems({required String transactionId}) async {
    ref.refresh(freshtransactionItemsProviderByIdProvider(
        (transactionId: transactionId)));

    ref.refresh(pendingTransactionProviderNonStream(
        (isExpense: false, mode: TransactionType.sale)));

    final branchId = ProxyService.box.getBranchId()!;
    ref.refresh(pendingTransactionProvider(
        (mode: TransactionType.sale, isExpense: false, branchId: branchId)));

    ref.refresh(transactionItemsProvider((isExpense: false)));
  }

  String getCartItemCount() {
    return ref
            .watch(transactionItemsProvider((isExpense: false)))
            .value
            ?.length
            .toString() ??
        '0';
  }

  double getSumOfItems() {
    final transactionItems =
        ref.watch(transactionItemsProvider((isExpense: false)));

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
