import 'package:flipper_ui/dialogs/payment_mode_modal.dart';
import 'package:flipper_dashboard/PreviewSaleButton.dart';
import 'package:flipper_dashboard/view_models/ordering_view_model.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/digital_payment_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PreviewSaleButtonWrapper extends ConsumerWidget {
  const PreviewSaleButtonWrapper({
    Key? key,
    required this.transaction,
    required this.orderCount,
    required this.isOrdering,
    required this.model,
  }) : super(key: key);

  final ITransaction transaction;
  final int orderCount;
  final bool isOrdering;
  final OrderingViewModel model;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final digitalPaymentEnabled =
        ref.watch(isDigitalPaymentEnabledProvider).asData?.value ?? false;
    final isPreviewing = ref.watch(previewingCart);
    final buttonText = isPreviewing
        ? "Place order"
        : orderCount > 0
        ? "Preview Cart ($orderCount)"
        : "Preview Cart";

    return Container(
      width: 350,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: PreviewSaleButton(
        digitalPaymentEnabled: digitalPaymentEnabled,
        transactionId: transaction.id,
        wording: buttonText,
        mode: SellingMode.forOrdering,
        previewCart: () async {
          if (isPreviewing && orderCount > 0) {
            // If already previewing and has items, show payment modal
            await showPaymentModeModal(
              context: context,
              onPaymentModeSelected: (provider) async {
                // NOTE: Do NOT pop the payment mode modal here!
                await model.handleOrderPlacement(
                  ref,
                  transaction,
                  isOrdering,
                  provider,
                  context,
                );
              },
            );
          } else {
            // Otherwise handle preview logic (toggle preview or show error)
            await model.handlePreviewCart(
              ref,
              orderCount,
              transaction,
              isOrdering,
              context,
            );
          }
        },
      ),
    );
  }
}
