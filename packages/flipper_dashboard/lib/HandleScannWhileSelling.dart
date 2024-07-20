import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_models/view_models/coreViewModel.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    /// if the state is not true then we are not in search mode, we are in scan mode
    /// this means that we can simply search and display item as user search
    /// this is useful when a customer want to search item mabybe want to edit it while not in
    /// selling mode.
    if (!ref.read(toggleProvider.notifier).state) {
      ref.read(searchStringProvider.notifier).emitString(value: '');
      if (value.isNotEmpty) {
        Variant? variant = ProxyService.realm.variant(name: value);
        if (variant != null && variant.id != null) {
          Stock? stock = ProxyService.realm
              .stockByVariantId(variantId: variant.id!, nonZeroValue: false);
          ITransaction currentTransaction = ProxyService.realm
              .manageTransaction(transactionType: TransactionType.sale);

          await model.saveTransaction(
              variation: variant,
              amountTotal: variant.retailPrice,
              customItem: false,
              pendingTransaction: currentTransaction,
              currentStock: stock!.currentStock,
              partOfComposite: false);
          final pendingTransaction =
              ref.watch(pendingTransactionProvider(TransactionType.sale));

          await Future.delayed(Duration(microseconds: 500));
          ref.refresh(transactionItemsProvider(pendingTransaction.value?.id));
          await Future.delayed(Duration(microseconds: 500));
          ref.refresh(transactionItemsProvider(pendingTransaction.value?.id));
        }
      }
    } else {
      /// we do normal search of item
    }
  }
}
