import 'package:flipper_payments/src/catalog/billing_cadence.dart';
import 'package:flipper_payments/src/ui/payment_tokens.dart';
import 'package:flipper_payments/src/ui/payment_typography.dart';
import 'package:flutter/material.dart';

/// Daily / Monthly / Yearly billing segment with a sliding thumb.
///
/// Supersedes `PaymentSegment2`, whose `bool isYearly` cannot express a third
/// cadence. That widget is kept for screens still on the two-way choice.
///
/// [cadences] is ordered left to right and defaults to all three; pass a
/// shorter list to hide one (a rail that cannot bill daily, say).
class PaymentCadenceSegment extends StatelessWidget {
  const PaymentCadenceSegment({
    super.key,
    required this.cadence,
    required this.onChanged,
    this.yearlyDiscountPercent = 20,
    this.cadences = BillingCadence.values,
  });

  final BillingCadence cadence;
  final ValueChanged<BillingCadence> onChanged;
  final double yearlyDiscountPercent;
  final List<BillingCadence> cadences;

  @override
  Widget build(BuildContext context) {
    final options = cadences.isEmpty ? BillingCadence.values : cadences;
    // A cadence that is not on offer must not leave the thumb off-screen.
    final selected = options.contains(cadence) ? cadence : options.first;
    final index = options.indexOf(selected);
    final discount = yearlyDiscountPercent.round();

    return LayoutBuilder(
      builder: (context, constraints) {
        final thumbWidth = (constraints.maxWidth - 8) / options.length;
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
                left: 4 + thumbWidth * index,
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
                  for (final option in options)
                    Expanded(
                      child: _CadenceTap(
                        label: option.label,
                        // Only worth the space when it is the saving on offer;
                        // three labels plus a tag is too much for a phone.
                        saveTag: option == BillingCadence.yearly &&
                                options.length < 3
                            ? '($discount% off)'
                            : null,
                        selected: option == selected,
                        onTap: () => onChanged(option),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CadenceTap extends StatelessWidget {
  const _CadenceTap({
    required this.label,
    required this.selected,
    required this.onTap,
    this.saveTag,
  });

  final String label;
  final String? saveTag;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textColor = selected ? Colors.white : PaymentTokens.ink2;
    final saveColor =
        selected ? Colors.white.withValues(alpha: 0.85) : PaymentTokens.blue;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 40,
        child: Center(
          child: saveTag == null
              ? Text(
                  label,
                  style: PaymentTypography.segmentButton(color: textColor),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                )
              : Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '$label ',
                        style: PaymentTypography.segmentButton(color: textColor),
                      ),
                      TextSpan(
                        text: saveTag,
                        style: PaymentTypography.segmentButton(color: saveColor)
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
        ),
      ),
    );
  }
}
