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
    return await ref.refresh(manualPaymentVerificationProvider.future);
  } catch (e, st) {
    talker.error('Manual payment verification failed: $e', st);
    rethrow;
  }
}

/// A button widget that checks subscription status and navigates when pressed.
class PaymentVerificationButton extends ConsumerWidget {
  final String label;
  final IconData icon;
  final Color? color;
  final bool showLoading;

  const PaymentVerificationButton({
    super.key,
    this.label = 'Check subscription',
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
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        disabledBackgroundColor: Colors.grey.shade300,
      ),
    );
  }
}

/// A menu item that checks subscription status and navigates when selected.
class PaymentVerificationMenuItem extends ConsumerWidget {
  final String label;
  final String? subtitle;
  final IconData icon;

  const PaymentVerificationMenuItem({
    super.key,
    this.label = 'Check subscription',
    this.subtitle = 'Refresh status after payment',
    this.icon = Icons.payment,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final verificationState = ref.watch(manualPaymentVerificationProvider);

    return ListTile(
      leading: verificationState.isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(icon),
      title: Text(label),
      subtitle: subtitle != null ? Text(subtitle!) : null,
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
      return 'Subscription is active.';
    case PaymentVerificationResult.noPlan:
      return 'No plan found — opening payment setup.';
    case PaymentVerificationResult.planExistsButInactive:
      return 'Plan found but not active — opening payment screen.';
    case PaymentVerificationResult.error:
      return response.errorMessage ?? 'Could not verify payment status.';
  }
}
