import 'package:flipper_models/realm_model_export.dart';
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
    final isScanningModeEnabled = ref.read(toggleProvider.notifier).state;

    if (isScanningModeEnabled) {
      if (value.isNotEmpty) {
        Variant? variant = (await ProxyService.strategy.variants(
                bcd: value, branchId: ProxyService.box.getBranchId()!))
            .firstOrNull;
        if (variant != null) {
          ITransaction currentTransaction = await ProxyService.strategy
              .manageTransaction(
                  branchId: ProxyService.box.getBranchId()!,
                  transactionType: TransactionType.sale,
                  isExpense: false);

          await model.saveTransaction(
              variation: variant,
              amountTotal: variant.retailPrice!,
              customItem: false,
              pendingTransaction: currentTransaction,
              currentStock: variant.stock!.currentStock!,
              partOfComposite: false);

          ref.refresh(transactionItemsProvider((isExpense: false)));

          ref.read(searchStringProvider.notifier).emitString(value: "d");
        }
      }
    }
  }
}
