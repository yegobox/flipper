import 'package:flipper_dashboard/typeDef.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flipper_ui/style_widget/button.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_models/providers/pay_button_provider.dart';

class PreviewSaleButton extends ConsumerWidget {
  const PreviewSaleButton({
    super.key,
    this.completeTransaction,
    this.previewCart,
    this.wording,
    required this.mode,
    required this.digitalPaymentEnabled,
    required this.transactionId,
    this.icon,
    this.enabled = true,
  });

  final CompleteTransaction? completeTransaction;
  final PreviewCart? previewCart;
  /// Null resolves to the localized "Pay" label at build time.
  final String? wording;
  final SellingMode mode;
  final IconData? icon;
  final bool digitalPaymentEnabled;
  final String transactionId;
  final bool enabled;

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
        //
        // The digital-payment path returns *while still waiting* for the
        // customer to confirm on their phone, so its only exit is
        // [onPaymentFailed]. Passing null here left the 60s timeout with
        // nothing to call: no error, and a Pay button that spun forever with
        // `onPressed: null` — the till could not even retry.
        final stillWaitingForPayment =
            await completeTransaction?.call(
              immediateCompletion,
              null,
              (String error) {
                if (!ref.context.mounted) return;
                loadingNotifier.stopLoading(buttonType);
                showCustomSnackBarUtil(
                  ref.context,
                  error,
                  backgroundColor: Colors.red,
                  showCloseButton: true,
                );
              },
            ) ??
            false;

        // Release the spinner here rather than trusting the flow to do it.
        // Every stopLoading() down the completion path is guarded by the *host*
        // widget's `mounted` / `context.mounted` (QuickSellingView, the checkout
        // shell). When that host is torn down or its context goes defunct
        // mid-sale — a layout swap, a pop, a rebuild after the cart clears —
        // none of those guards fire, while this button is a different widget
        // that stays mounted and keeps rendering a dead spinner with
        // `onPressed: null`. Stopping again when the flow already stopped is a
        // no-op; only a pending out-of-band payment keeps it spinning.
        if (!stillWaitingForPayment && ref.context.mounted) {
          loadingNotifier.stopLoading(buttonType);
        }
      } catch (e) {
        if (ref.context.mounted) {
          loadingNotifier.stopLoading(buttonType); // Stop loading on error
        }
        // Handle error (e.g., show a snackbar or log error)
      }
    } else if (mode == SellingMode.forOrdering && previewCart != null) {
      // stop any other loading button
      loadingNotifier.stopLoading();
      // end of stop
      loadingNotifier.startLoading(buttonType); // Start loading

      try {
        // Call the preview cart function
        previewCart?.call();
      } catch (e) {
        // Handle error (e.g., show a snackbar or log error)
      } finally {
        if (ref.context.mounted) {
          loadingNotifier.stopLoading(buttonType); // Stop loading in finally to ensure it always stops
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payButtonLoading = ref.watch(payButtonStateProvider);
    final showCompleteNow =
        mode == SellingMode.forSelling && digitalPaymentEnabled;

    return SizedBox(
      height: 64,
      width: double.infinity,
      child: Row(
        children: [
          // Left Side: Main Button (Pay/Preview Cart)
          Expanded(
            child: icon == null
                ? FlipperButton(
                    width: double.infinity,
                    height: 64,
                    key: const Key("PaymentButton"),
                    color: const Color(0xFF2563EB),
                    text: wording ?? context.flipperL10n.pay,
                    onPressed: (!enabled ||
                            (payButtonLoading[ButtonType.pay] ?? false))
                        ? null
                        : () => _handleButtonPress(
                            ref,
                            buttonType: ButtonType.pay,
                          ),
                    isLoading: payButtonLoading[ButtonType.pay] ?? false,
                  )
                : FlipperIconButton(
                    width: double.infinity,
                    height: 64,
                    color: const Color(0xFF2563EB),
                    key: const Key("PaymentButton"),
                    icon: icon!,
                    onPressed: (!enabled ||
                            (payButtonLoading[ButtonType.pay] ?? false))
                        ? null
                        : () => _handleButtonPress(
                            ref,
                            buttonType: ButtonType.pay,
                          ),
                    isLoading: payButtonLoading[ButtonType.pay] ?? false,
                  ),
          ),
          // Only show divider and Complete Now button when in selling mode
          if (showCompleteNow) ...[
            Container(width: 1, color: Colors.grey.shade300),
            Expanded(
              child: icon == null
                  ? FlipperButton(
                      width: double.infinity,
                      isLoading:
                          payButtonLoading[ButtonType.completeNow] ?? false,
                      height: 64,
                      key: const Key("ImmediateCompletionButton"),
                      color: Colors.green,
                      text: 'Complete Now',
                      onPressed: !enabled
                          ? null
                          : () => _handleButtonPress(
                                ref,
                                immediateCompletion: true,
                                buttonType: ButtonType.completeNow,
                              ),
                    )
                  : FlipperIconButton(
                      width: double.infinity,
                      color: const Color(0xFF2563EB),
                      isLoading:
                          payButtonLoading[ButtonType.completeNow] ?? false,
                      height: 64,
                      key: const Key("ImmediateCompletionButton"),
                      text: 'Complete Now',
                      onPressed: !enabled
                          ? null
                          : () => _handleButtonPress(
                                ref,
                                immediateCompletion: true,
                                buttonType: ButtonType.completeNow,
                              ),
                      icon: icon!,
                    ),
            ),
          ],
        ],
      ),
    );
  }
}
