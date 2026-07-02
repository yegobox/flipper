import 'package:flipper_dashboard/payment/payment_typography.dart';
import 'package:flipper_dashboard/payment/widgets/payment_input.dart';
import 'package:flipper_dashboard/payment/widgets/payment_toggle_switch.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class PaymentDiscountSection extends StatefulWidget {
  const PaymentDiscountSection({
    super.key,
    required this.onCodeChanged,
    this.errorMessage,
    this.isValidating = false,
    this.label = 'Apply Discount Code',
    this.hint = 'Enter the code exactly as it appears.',
  });

  final ValueChanged<String> onCodeChanged;
  final String? errorMessage;
  final bool isValidating;
  final String label;
  final String hint;

  @override
  State<PaymentDiscountSection> createState() => _PaymentDiscountSectionState();
}

class _PaymentDiscountSectionState extends State<PaymentDiscountSection> {
  bool _enabled = false;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.label, style: PaymentTypography.inlineLabel()),
              PaymentToggleSwitch(
                value: _enabled,
                onChanged: (v) {
                  setState(() {
                    _enabled = v;
                    if (!v) {
                      _controller.clear();
                      widget.onCodeChanged('');
                    }
                  });
                },
              ),
            ],
          ),
        ),
        if (_enabled) ...[
          const SizedBox(height: 12),
          PaymentInput(
            controller: _controller,
            hintText: 'Discount code',
            leadingIcon: FluentIcons.tag_20_regular,
            onChanged: widget.onCodeChanged,
          ),
          PaymentInputHint(text: widget.hint),
          if (widget.isValidating)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  const SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 8),
                  Text('Validating code…', style: PaymentTypography.hint()),
                ],
              ),
            ),
          if (widget.errorMessage != null && widget.errorMessage!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                widget.errorMessage!,
                style: PaymentTypography.hint().copyWith(
                  color: const Color(0xFFDC2626),
                ),
              ),
            ),
        ],
      ],
    );
  }
}
