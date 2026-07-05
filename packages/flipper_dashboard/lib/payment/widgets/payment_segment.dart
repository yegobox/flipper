import 'package:flipper_dashboard/payment/payment_tokens.dart';
import 'package:flipper_dashboard/payment/payment_typography.dart';
import 'package:flutter/material.dart';

/// Monthly / Yearly billing segment with sliding thumb.
class PaymentSegment2 extends StatelessWidget {
  const PaymentSegment2({
    super.key,
    required this.isYearly,
    required this.onChanged,
    this.yearlyDiscountPercent = 20,
  });

  final bool isYearly;
  final ValueChanged<bool> onChanged;
  final double yearlyDiscountPercent;

  @override
  Widget build(BuildContext context) {
    final discount = yearlyDiscountPercent.round();

    return LayoutBuilder(
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
                left: isYearly ? 4 + thumbWidth : 4,
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
                    child: _SegmentTap(
                      label: 'Monthly',
                      selected: !isYearly,
                      onTap: () => onChanged(false),
                    ),
                  ),
                  Expanded(
                    child: _SegmentTap(
                      label: 'Yearly',
                      saveTag: '($discount% off)',
                      selected: isYearly,
                      onTap: () => onChanged(true),
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

class _SegmentTap extends StatelessWidget {
  const _SegmentTap({
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
    final saveColor = selected
        ? Colors.white.withValues(alpha: 0.85)
        : PaymentTokens.blue;

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
                        style:
                            PaymentTypography.segmentButton(color: textColor),
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
