import 'package:flipper_dashboard/theme/mpos_tokens.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flutter/material.dart';

/// White rounded card, as on the SMS Bridge page.
class OnlineShopCard extends StatelessWidget {
  const OnlineShopCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    // Material, not a decorated Container: the switch tiles inside paint
    // their ink on the nearest Material.
    return Material(
      color: PosTokens.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MposTokens.radiusMd),
        side: const BorderSide(color: PosTokens.line),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(18),
        child: SizedBox(width: double.infinity, child: child),
      ),
    );
  }
}

/// Full-width brand-blue action.
class OnlineShopPrimaryButton extends StatelessWidget {
  const OnlineShopPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.busy = false,
  });

  final String label;
  final bool busy;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: PosTokens.blue,
          disabledBackgroundColor: PosTokens.blue.withValues(alpha: 0.4),
          disabledForegroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: busy ? null : onPressed,
        child: busy
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}

/// Small grey heading above a group of fields.
class OnlineShopSectionLabel extends StatelessWidget {
  const OnlineShopSectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 24, 4, 8),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.6,
          color: PosTokens.ink3,
        ),
      ),
    );
  }
}

/// A labelled text field in the page's style.
class OnlineShopField extends StatelessWidget {
  const OnlineShopField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.enabled = true,
    this.keyboardType,
    this.maxLines = 1,
    this.errorText,
    this.prefixText,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool enabled;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? errorText;
  final String? prefixText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        maxLines: maxLines,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          helperText: hint,
          errorText: errorText,
          prefixText: prefixText,
          isDense: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
