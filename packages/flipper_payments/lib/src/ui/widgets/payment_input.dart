import 'package:flipper_payments/src/ui/payment_tokens.dart';
import 'package:flipper_payments/src/ui/payment_typography.dart';
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
    this.enabled = true,
    this.mono = false,
    this.suffixText,
    this.trailing,
    this.borderColor,
    this.textCapitalization = TextCapitalization.none,
  });

  final TextEditingController controller;
  final String? hintText;
  final IconData? leadingIcon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final bool autofocus;
  final bool enabled;

  /// Geist Mono, as the handover uses for amounts, phone numbers and codes —
  /// digits line up column-wise when they are the thing being checked.
  final bool mono;

  /// Static text pinned to the right, e.g. the cadence suffix `/month`.
  final String? suffixText;

  /// A widget in the right slot — the search field's clear button.
  final Widget? trailing;

  /// Overrides the resting border, for a field showing a validation state.
  final Color? borderColor;

  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    final textStyle = mono
        ? PaymentTypography.monoPrice(
            color: PaymentTokens.ink1,
            size: 16,
            weight: FontWeight.w600,
          )
        : PaymentTypography.inlineLabel().copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          );

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: PaymentTokens.surface,
        borderRadius: BorderRadius.circular(PaymentTokens.rMd),
        border: Border.all(
          color: borderColor ?? PaymentTokens.line,
          width: 1.5,
        ),
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
              enabled: enabled,
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
              onChanged: onChanged,
              textCapitalization: textCapitalization,
              style: textStyle,
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
          if (suffixText != null) ...[
            const SizedBox(width: 8),
            Text(
              suffixText!,
              style: PaymentTypography.totalPeriod(),
            ),
          ],
          if (trailing != null) ...[
            const SizedBox(width: 8),
            trailing!,
          ],
        ],
      ),
    );
  }
}

/// The small round clear button the handover puts inside the search field.
class PaymentInputClearButton extends StatelessWidget {
  const PaymentInputClearButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: PaymentTokens.line,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(6),
        child: const SizedBox(
          width: 22,
          height: 22,
          child: Icon(
            FluentIcons.dismiss_12_regular,
            size: 12,
            color: PaymentTokens.ink2,
          ),
        ),
      ),
    );
  }
}

class PaymentInputHint extends StatelessWidget {
  const PaymentInputHint({
    super.key,
    required this.text,
    this.color = PaymentTokens.ink3,
  });

  final String text;

  /// The handover tints both the icon and the text when the field is showing
  /// a problem, so one colour drives both.
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(
              FluentIcons.info_16_regular,
              size: 14,
              color: color,
            ),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(text, style: PaymentTypography.hint(color: color)),
          ),
        ],
      ),
    );
  }
}
