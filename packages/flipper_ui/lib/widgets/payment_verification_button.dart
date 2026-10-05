import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_models/providers/payment_verification_provider.dart';
import 'package:flipper_models/services/payment_verification_service.dart';
import 'package:flipper_models/helperModels/talker.dart';

Future<PaymentVerificationResponse> triggerManualPaymentVerification(
  WidgetRef ref,
) async {
  talker.info('Manual payment verification triggered');
  try {
    return await ref.read(manualPaymentVerificationProvider.notifier).run();
  } catch (e, st) {
    talker.error('Manual payment verification failed: $e', st);
    rethrow;
  }
}

/// A button widget that checks subscription status and navigates when pressed.
class PaymentVerificationButton extends ConsumerWidget {
  /// Defaults to the localized "Check subscription".
  final String? label;
  final IconData icon;
  final Color? color;
  final bool showLoading;

  const PaymentVerificationButton({
    super.key,
    this.label,
    this.icon = Icons.payment,
    this.color,
    this.showLoading = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final verificationState = ref.watch(manualPaymentVerificationProvider);

    return ElevatedButton.icon(
      onPressed: verificationState.isLoading
          ? null
          : () => triggerManualPaymentVerification(ref),
      icon: verificationState.isLoading && showLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(icon),
      label: Text(label ?? context.flipperL10n.checkSubscription),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        disabledBackgroundColor: Colors.grey.shade300,
      ),
    );
  }
}

/// A menu item that checks subscription status and navigates when selected.
class PaymentVerificationMenuItem extends ConsumerWidget {
  /// Defaults to the localized "Check subscription".
  final String? label;

  /// Defaults to the localized "Refresh status after payment"; pass an empty
  /// string to hide it.
  final String? subtitle;
  final IconData icon;

  const PaymentVerificationMenuItem({
    super.key,
    this.label,
    this.subtitle,
    this.icon = Icons.payment,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final verificationState = ref.watch(manualPaymentVerificationProvider);
    final l10n = context.flipperL10n;
    final subtitleText = subtitle ?? l10n.uiRefreshStatusAfterPayment;

    return ListTile(
      leading: verificationState.isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(icon),
      title: Text(label ?? l10n.checkSubscription),
      subtitle: subtitleText.isNotEmpty ? Text(subtitleText) : null,
      enabled: !verificationState.isLoading,
      onTap: verificationState.isLoading
          ? null
          : () => triggerManualPaymentVerification(ref),
    );
  }
}

String paymentVerificationResultMessage(PaymentVerificationResponse response) {
  switch (response.result) {
    case PaymentVerificationResult.active:
      return FlipperL10n.current.uiSubscriptionActive;
    case PaymentVerificationResult.noPlan:
      return FlipperL10n.current.uiNoPlanOpeningSetup;
    case PaymentVerificationResult.planExistsButInactive:
      return FlipperL10n.current.uiPlanInactiveOpeningPayment;
    case PaymentVerificationResult.error:
      return response.errorMessage ??
          FlipperL10n.current.uiCouldNotVerifyPayment;
  }
}
