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

  Future<void> _handleButtonPress(WidgetRef ref,
      {bool immediateCompletion = false}) async {
    final loadingNotifier = ref.read(payButtonLoadingProvider.notifier);

    if (mode == SellingMode.forSelling && completeTransaction != null) {
      try {
        loadingNotifier.startLoading(); // Start loading for the Pay button

        // Pass the immediateCompletion parameter to the callback
        completeTransaction?.call(immediateCompletion);

        if (immediateCompletion) {
          // Stop loading immediately if immediateCompletion is true
          loadingNotifier.stopLoading();
        }
      } catch (e) {
        loadingNotifier.stopLoading(); // Stop loading on error
        // Handle error (e.g., show a snackbar or dialog)
      }
    } else if (mode == SellingMode.forOrdering && previewCart != null) {
      try {
        loadingNotifier.startLoading(); // Start loading for the Pay button
        previewCart?.call();
      } catch (e) {
        loadingNotifier.stopLoading(); // Stop loading on error
        // Handle error (e.g., show a snackbar or dialog)
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPayButtonLoading = ref.watch(payButtonLoadingProvider);

    return SizedBox(
      height: 64,
      width: digitalPaymentEnabled ? 320 : 160,
      child: Row(
        children: [
          // Left Side: Main Button (Loading State)
          Expanded(
            child: FlipperButton(
              height: 64,
              key: const Key("PaymentButton"),
              color: Colors.blue.shade700,
              text: wording,
              onPressed:
                  isPayButtonLoading ? null : () => _handleButtonPress(ref),
              isLoading: isPayButtonLoading,
            ),
          ),
          // Right Side: Immediate Completion Button (Conditional)
          if (digitalPaymentEnabled)
            Container(
              width: 1,
              color: Colors.grey.shade300, // Divider between the two buttons
            ),
          if (digitalPaymentEnabled)
            Expanded(
              child: FlipperButton(
                height: 64,
                key: const Key("ImmediateCompletionButton"),
                color: Colors.green,
                text: 'Complete Now',
                onPressed: () =>
                    _handleButtonPress(ref, immediateCompletion: true),
              ),
            ),
        ],
      ),
    );
  }
}
