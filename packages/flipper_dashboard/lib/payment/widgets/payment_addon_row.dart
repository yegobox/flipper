import 'package:flipper_dashboard/payment/payment_tokens.dart';
import 'package:flipper_dashboard/payment/payment_typography.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flipper_dashboard/payment/widgets/payment_toggle_switch.dart';

class PaymentAddonRow extends StatelessWidget {
  const PaymentAddonRow({
    super.key,
    required this.name,
    required this.priceLine,
    required this.enabled,
    required this.onChanged,
    this.icon = FluentIcons.document_text_20_regular,
  });

  final String name;
  final String priceLine;
  final bool enabled;
  final ValueChanged<bool> onChanged;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      decoration: BoxDecoration(
        color: PaymentTokens.surface,
        borderRadius: BorderRadius.circular(PaymentTokens.rLg),
        border: Border.all(
          color: enabled ? PaymentTokens.blueTint2 : PaymentTokens.line,
        ),
        boxShadow: [
          ...PaymentTokens.sh1,
          if (enabled)
            BoxShadow(
              color: PaymentTokens.blueTint,
              spreadRadius: 3,
              blurRadius: 0,
            ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: PaymentTokens.blueTint,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: PaymentTokens.blue),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: PaymentTypography.planName()),
                const SizedBox(height: 2),
                Text(
                  priceLine,
                  style: PaymentTypography.monoPrice(
                    color: PaymentTokens.ink2,
                    size: 12.5,
                  ),
                ),
              ],
            ),
          ),
          PaymentToggleSwitch(value: enabled, onChanged: onChanged),
        ],
      ),
    );
  }
}

class PaymentSectionLabel extends StatelessWidget {
  const PaymentSectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 6, 4, 0),
      child: Text(
        text.toUpperCase(),
        style: PaymentTypography.sectionLabel(),
      ),
    );
  }
}
