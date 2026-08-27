import 'package:flipper_dashboard/payment/payment_tokens.dart';
import 'package:flipper_dashboard/payment/payment_typography.dart';
import 'package:flipper_services/payment_rail.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

/// Mobile Money / Card selector, styled to match [PaymentSegment2].
///
/// Only shown when the connector reports the card rail as sellable — a business
/// on a deployment without Dodo configured sees the screen exactly as it was,
/// which is the whole point of gating this on `GET /api/dodo/health`.
class PaymentRailSelector extends StatelessWidget {
  const PaymentRailSelector({
    super.key,
    required this.rail,
    required this.onChanged,
    this.enabled = true,
  });

  final PaymentRail rail;
  final ValueChanged<PaymentRail> onChanged;

  /// False while a payment is in flight: switching rails mid-charge is how you
  /// end up with two subscriptions on one plan.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'How would you like to pay?',
            style: PaymentTypography.sectionLabel(),
          ),
        ),
        Opacity(
          opacity: enabled ? 1 : 0.55,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final thumbWidth = (constraints.maxWidth - 8) / 2;
              return Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: PaymentTokens.surface2,
                  border: Border.all(color: PaymentTokens.line),
                  borderRadius: BorderRadius.circular(PaymentTokens.rMd),
                ),
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 260),
                      curve: Curves.easeOutCubic,
                      top: 4,
                      bottom: 4,
                      left: rail.isCard ? 4 + thumbWidth : 4,
                      width: thumbWidth,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: PaymentTokens.gradBtn,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: PaymentTokens.shBlue,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _RailTap(
                            label: PaymentRail.mtnMomo.label,
                            icon: FluentIcons.phone_20_regular,
                            selected: rail.isMomo,
                            onTap: enabled
                                ? () => onChanged(PaymentRail.mtnMomo)
                                : null,
                          ),
                        ),
                        Expanded(
                          child: _RailTap(
                            label: PaymentRail.card.label,
                            icon: FluentIcons.credit_card_person_20_regular,
                            selected: rail.isCard,
                            onTap: enabled
                                ? () => onChanged(PaymentRail.card)
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(rail.description, style: PaymentTypography.hint()),
        ),
      ],
    );
  }
}

class _RailTap extends StatelessWidget {
  const _RailTap({
    required this.label,
    required this.icon,
    required this.selected,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? Colors.white : PaymentTokens.ink2;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 44,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 17, color: color),
              const SizedBox(width: 7),
              Flexible(
                child: Text(
                  label,
                  style: PaymentTypography.segmentButton(color: color),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
