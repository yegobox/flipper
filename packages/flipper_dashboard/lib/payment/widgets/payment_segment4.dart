import 'package:flipper_dashboard/payment/payment_format.dart';
import 'package:flipper_dashboard/payment/payment_tokens.dart';
import 'package:flipper_dashboard/payment/payment_typography.dart';
import 'package:flipper_dashboard/payment/widgets/payment_toggle_switch.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

/// 1× / 3× / 6× / 12× installment segment.
class PaymentSegment4 extends StatelessWidget {
  const PaymentSegment4({
    super.key,
    required this.selectedCount,
    required this.onChanged,
  });

  final int selectedCount;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final index = installmentIndex(selectedCount);

    return LayoutBuilder(
      builder: (context, constraints) {
        final thumbWidth = (constraints.maxWidth - 8) / 4;
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
                  for (final count in paymentInstallmentOptions)
                    Expanded(
                      child: GestureDetector(
                        onTap: () => onChanged(count),
                        behavior: HitTestBehavior.opaque,
                        child: SizedBox(
                          height: 40,
                          child: Center(
                            child: Text(
                              '${count}×',
                              style: PaymentTypography.segmentMono(
                                color: selectedCount == count
                                    ? Colors.white
                                    : PaymentTokens.ink2,
                              ),
                            ),
                          ),
                        ),
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

/// Split payments toggle + optional installment reveal.
class PaymentSplitSection extends StatelessWidget {
  const PaymentSplitSection({
    super.key,
    required this.splitEnabled,
    required this.onSplitChanged,
    required this.installmentCount,
    required this.onInstallmentChanged,
    required this.total,
  });

  final bool splitEnabled;
  final ValueChanged<bool> onSplitChanged;
  final int installmentCount;
  final ValueChanged<int> onInstallmentChanged;
  final num total;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Split into payments',
                style: PaymentTypography.inlineLabel(),
              ),
              PaymentToggleSwitch(
                value: splitEnabled,
                onChanged: onSplitChanged,
              ),
            ],
          ),
        ),
        if (splitEnabled) ...[
          const SizedBox(height: 12),
          PaymentSegment4(
            selectedCount: installmentCount,
            onChanged: onInstallmentChanged,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 1),
                  child: Icon(
                    FluentIcons.info_16_regular,
                    size: 14,
                    color: PaymentTokens.ink3,
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      style: PaymentTypography.hint(),
                      children: _hintSpans(
                        installmentHint(
                          installments: installmentCount,
                          total: total,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  List<InlineSpan> _hintSpans(String text) {
    final boldPattern = RegExp(r'RWF [\d,]+(?:\.\d+)?|\d+ payments');
    final spans = <InlineSpan>[];
    var start = 0;
    for (final match in boldPattern.allMatches(text)) {
      if (match.start > start) {
        spans.add(TextSpan(text: text.substring(start, match.start)));
      }
      spans.add(
        TextSpan(
          text: match.group(0),
          style: PaymentTypography.monoPrice(
            color: PaymentTokens.ink2,
            size: 12.5,
            weight: FontWeight.w700,
          ),
        ),
      );
      start = match.end;
    }
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }
    return spans;
  }
}
