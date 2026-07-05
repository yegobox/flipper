import 'package:flipper_dashboard/payment/payment_tokens.dart';
import 'package:flipper_dashboard/payment/payment_typography.dart';
import 'package:flutter/material.dart';

class PaymentLoadingOverlay extends StatelessWidget {
  const PaymentLoadingOverlay({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(gradient: PaymentTokens.screenBackground),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 46,
                  height: 46,
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                    color: PaymentTokens.blue,
                    backgroundColor: PaymentTokens.line,
                  ),
                ),
                const SizedBox(height: 18),
                Text(message, style: PaymentTypography.hint()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
