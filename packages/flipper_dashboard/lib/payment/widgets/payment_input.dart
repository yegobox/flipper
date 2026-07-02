import 'package:flipper_dashboard/payment/payment_tokens.dart';
import 'package:flipper_dashboard/payment/payment_typography.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaymentInput extends StatelessWidget {
  const PaymentInput({
    super.key,
    required this.controller,
    this.hintText,
    this.leadingIcon,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.autofocus = false,
  });

  final TextEditingController controller;
  final String? hintText;
  final IconData? leadingIcon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: PaymentTokens.surface,
        borderRadius: BorderRadius.circular(PaymentTokens.rMd),
        border: Border.all(color: PaymentTokens.line, width: 1.5),
      ),
      child: Row(
        children: [
          if (leadingIcon != null) ...[
            Icon(leadingIcon, size: 19, color: PaymentTokens.ink3),
            const SizedBox(width: 11),
          ],
          Expanded(
            child: TextField(
              controller: controller,
              autofocus: autofocus,
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
              onChanged: onChanged,
              style: PaymentTypography.inlineLabel().copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: PaymentTypography.hint().copyWith(
                  fontSize: 16,
                  color: PaymentTokens.ink4,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentInputHint extends StatelessWidget {
  const PaymentInputHint({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 2),
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
          Expanded(child: Text(text, style: PaymentTypography.hint())),
        ],
      ),
    );
  }
}
