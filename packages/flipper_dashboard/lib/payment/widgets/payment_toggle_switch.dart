import 'package:flipper_dashboard/payment/payment_tokens.dart';
import 'package:flutter/material.dart';

/// Custom 50×30 toggle matching handover `.pi-switch`.
class PaymentToggleSwitch extends StatelessWidget {
  const PaymentToggleSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        width: 50,
        height: 30,
        decoration: BoxDecoration(
          color: value ? PaymentTokens.blue : PaymentTokens.lineStrong,
          borderRadius: BorderRadius.circular(999),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 220),
          curve: const Cubic(0.3, 0.7, 0.4, 1),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.all(3),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: PaymentTokens.ink1.withValues(alpha: 0.28),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
