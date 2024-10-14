import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_models/view_models/coreViewModel.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';

mixin HandleScannWhileSelling<T extends ConsumerStatefulWidget>
    on ConsumerState<T> {
  late bool hasText;
  late FocusNode focusNode;
  void processDebouncedValue(
      String value, CoreViewModel model, TextEditingController controller) {
    ref.read(searchStringProvider.notifier).emitString(value: value);
    focusNode.requestFocus();

    handleScanningMode(value, model, controller);
  }

  void handleScanningMode(String value, CoreViewModel model,
      TextEditingController controller) async {
    controller.clear();
    hasText = false;
    // 121312121
    /// if the state is not true then we are not in search mode, we are in scan mode
    /// this means that we can simply search and display item as user search
    /// this is useful when a customer want to search item mabybe want to edit it while not in
    /// selling mode.
    if (!ref.read(toggleProvider.notifier).state) {
      if (value.isNotEmpty) {
        Variant? variant = ProxyService.local.variant(name: value);
        if (variant != null) {
          ITransaction currentTransaction = ProxyService.local
              .manageTransaction(
                  branchId: ProxyService.box.getBranchId()!,
                  transactionType: TransactionType.sale,
                  isExpense: false);

          await model.saveTransaction(
              variation: variant,
              amountTotal: variant.retailPrice,
              customItem: false,
              pendingTransaction: currentTransaction,
              currentStock: variant.stock!.currentStock,
              partOfComposite: false);

          ref.refresh(transactionItemsProvider((isExpense: false)));
        }
      }
    }
  }
}
