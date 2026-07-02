import 'package:flipper_dashboard/payment/payment_tokens.dart';
import 'package:flipper_dashboard/payment/payment_typography.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class PaymentAccordion extends StatefulWidget {
  const PaymentAccordion({
    super.key,
    required this.title,
    required this.subtitleOpen,
    required this.subtitleClosed,
    required this.child,
    this.initiallyOpen = true,
    this.icon = FluentIcons.arrow_swap_20_regular,
  });

  final String title;
  final String subtitleOpen;
  final String subtitleClosed;
  final Widget child;
  final bool initiallyOpen;
  final IconData icon;

  @override
  State<PaymentAccordion> createState() => _PaymentAccordionState();
}

class _PaymentAccordionState extends State<PaymentAccordion> {
  late bool _open = widget.initiallyOpen;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: PaymentTokens.surface,
        borderRadius: BorderRadius.circular(PaymentTokens.rLg),
        border: Border.all(color: PaymentTokens.line),
        boxShadow: PaymentTokens.sh1,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _open = !_open),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: PaymentTokens.blueTint,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(widget.icon, size: 20, color: PaymentTokens.blue),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: PaymentTypography.planName(),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _open ? widget.subtitleOpen : widget.subtitleClosed,
                          style: PaymentTypography.hint(),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _open ? 0.5 : 0,
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeOutCubic,
                    child: const Icon(
                      FluentIcons.chevron_down_20_regular,
                      size: 20,
                      color: PaymentTokens.ink3,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  widget.child,
                ],
              ),
            ),
            secondChild: const SizedBox.shrink(),
            crossFadeState:
                _open ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 280),
            sizeCurve: Curves.easeOutCubic,
          ),
        ],
      ),
    );
  }
}
