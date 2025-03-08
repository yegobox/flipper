import 'package:flipper_dashboard/typeDef.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_ui/style_widget/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_models/providers/pay_button_provider.dart';

class PreviewSaleButton extends ConsumerWidget {
  const PreviewSaleButton({
    super.key,
    this.completeTransaction,
    this.previewCart,
    this.wording = 'Pay',
    required this.mode,
    required this.digitalPaymentEnabled,
    required this.transactionId,
  });

  final CompleteTransaction? completeTransaction;
  final PreviewCart? previewCart;
  final String wording;
  final SellingMode mode;
  final bool digitalPaymentEnabled;
  final String transactionId;

  Future<void> _handleButtonPress(
    WidgetRef ref, {
    bool immediateCompletion = false,
    required ButtonType buttonType,
  }) async {
    final loadingNotifier = ref.read(payButtonStateProvider.notifier);

    if (mode == SellingMode.forSelling && completeTransaction != null) {
      try {
        // stop any other loading button
        loadingNotifier.stopLoading();
        // end of stop
        loadingNotifier.startLoading(buttonType); // Start loading

        // Call the transaction function
        completeTransaction?.call(immediateCompletion);

        // The transaction function is responsible for stopping the loading state.
      } catch (e) {
        loadingNotifier.stopLoading(buttonType); // Stop loading on error
        // Handle error (e.g., show a snackbar or log error)
      }
    } else if (mode == SellingMode.forOrdering && previewCart != null) {
      try {
        previewCart?.call();
      } catch (e) {
        loadingNotifier.stopLoading(buttonType); // Stop loading on error
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payButtonLoading = ref.watch(payButtonStateProvider);

    return SizedBox(
      height: 64,
      width: digitalPaymentEnabled ? 320 : 160,
      child: Row(
        children: [
          // Left Side: Main Button (Pay)
          Expanded(
            child: FlipperButton(
              height: 64,
              key: const Key("PaymentButton"),
              color: Colors.blue.shade700,
              text: wording,
              onPressed: (payButtonLoading[ButtonType.pay] ?? false)
                  ? null
                  : () => _handleButtonPress(ref, buttonType: ButtonType.pay),
              isLoading: payButtonLoading[ButtonType.pay] ?? false,
            ),
          ),
          // Divider between buttons (if digital payment is enabled)
          if (digitalPaymentEnabled)
            Container(
              width: 1,
              color: Colors.grey.shade300,
            ),
          // Right Side: "Complete Now" Button (if digital payment is enabled)
          if (digitalPaymentEnabled)
            Expanded(
              child: FlipperButton(
                isLoading: payButtonLoading[ButtonType.completeNow] ?? false,
                height: 64,
                key: const Key("ImmediateCompletionButton"),
                color: Colors.green,
                text: 'Complete Now',
                onPressed: () => _handleButtonPress(
                  ref,
                  immediateCompletion: true,
                  buttonType: ButtonType.completeNow,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
