import 'package:flipper_dashboard/payment/payment_tokens.dart';
import 'package:flipper_dashboard/payment/payment_typography.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

/// Single-select plan tile with gradient when selected.
class PaymentPlanTile extends StatelessWidget {
  const PaymentPlanTile({
    super.key,
    required this.name,
    required this.priceLine,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String name;
  final String priceLine;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final nameColor = selected ? Colors.white : PaymentTokens.ink1;
    final priceColor =
        selected ? Colors.white.withValues(alpha: 0.82) : PaymentTokens.ink3;
    final iconBg = selected
        ? Colors.white.withValues(alpha: 0.2)
        : PaymentTokens.surface2;
    final iconColor = selected ? Colors.white : PaymentTokens.ink2;
    final iconBorder = selected ? Colors.transparent : PaymentTokens.line;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
        decoration: BoxDecoration(
          gradient: selected ? PaymentTokens.gradBtn : null,
          color: selected ? null : PaymentTokens.surface,
          borderRadius: BorderRadius.circular(PaymentTokens.rMd),
          border: Border.all(
            color: selected ? Colors.transparent : PaymentTokens.line,
            width: 1.5,
          ),
          boxShadow: selected ? PaymentTokens.shBlue : null,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(11),
                border: Border.all(color: iconBorder),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: PaymentTypography.planName(color: nameColor),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    priceLine,
                    style: PaymentTypography.monoPrice(
                      color: priceColor,
                      size: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (selected)
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.22),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  FluentIcons.checkmark_16_regular,
                  size: 15,
                  color: Colors.white,
                ),
              )
            else
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: PaymentTokens.lineStrong, width: 2),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
