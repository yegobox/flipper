import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_models/providers/payment_verification_provider.dart';
import 'package:flipper_models/helperModels/talker.dart';

/// A button widget that triggers payment verification when pressed
class PaymentVerificationButton extends ConsumerWidget {
  final String label;
  final IconData icon;
  final Color? color;
  final bool showLoading;

  const PaymentVerificationButton({
    Key? key,
    this.label = 'Verify Payment',
    this.icon = Icons.payment,
    this.color,
    this.showLoading = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final verificationState = ref.watch(verifyPaymentProvider);

    return ElevatedButton.icon(
      onPressed: verificationState.isLoading
          ? null
          : () {
              talker.info('Manual payment verification triggered');
              // Refresh the provider and ignore the result since we don't need it
              final _ = ref.refresh(forcePaymentVerificationProvider);
            },
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

/// A menu item that triggers payment verification when selected
class PaymentVerificationMenuItem extends ConsumerWidget {
  final String label;
  final IconData icon;

  const PaymentVerificationMenuItem({
    Key? key,
    this.label = 'Verify Payment Status',
    this.icon = Icons.payment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: () {
        talker.info('Manual payment verification triggered from menu');
        // Refresh the provider and ignore the result since we don't need it
        final _ = ref.refresh(forcePaymentVerificationProvider);
      },
    );
  }
}
