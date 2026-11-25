/// Phone add/edit product building blocks, drawn from the mobile POS tokens
/// (the same look as Add Customer and checkout) so the form matches the rest
/// of Flipper on a phone.
library;

import 'package:flipper_dashboard/theme/mpos_tokens.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flutter/material.dart';

/// A white, softly bordered group of fields.
class MobileEntryCard extends StatelessWidget {
  const MobileEntryCard({super.key, this.title, required this.child});

  final String? title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PosTokens.surface,
        borderRadius: BorderRadius.circular(MposTokens.radiusMd),
        border: Border.all(color: PosTokens.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null) ...[
            Text(title!, style: mobileEntrySectionTitleStyle),
            const SizedBox(height: 14),
          ],
          child,
        ],
      ),
    );
  }
}

const TextStyle mobileEntrySectionTitleStyle = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w700,
  color: PosTokens.ink1,
);

const TextStyle mobileEntryHintStyle = TextStyle(
  fontSize: 12.5,
  color: PosTokens.ink3,
);

/// The bold label that sits above a field.
class MobileEntryFieldLabel extends StatelessWidget {
  const MobileEntryFieldLabel(this.text, {super.key, this.required = false});

  final String text;
  final bool required;

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      fontSize: 13.5,
      fontWeight: FontWeight.w700,
      color: PosTokens.ink1,
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Flexible(child: Text(text, style: style)),
          if (required)
            Text(' *', style: style.copyWith(color: PosTokens.loss)),
        ],
      ),
    );
  }
}

const TextStyle mobileEntryInputTextStyle = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w500,
  color: PosTokens.ink1,
);

OutlineInputBorder _border(Color color, [double width = 1]) =>
    OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: width),
    );

/// Text field decoration: white fill, hairline border, brand-blue focus.
InputDecoration mobileEntryInputDecoration({
  String? hint,
  String? prefixText,
  Widget? suffixIcon,
  bool locked = false,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(
      color: PosTokens.ink4,
      fontWeight: FontWeight.w400,
    ),
    prefixText: prefixText == null ? null : '$prefixText ',
    prefixStyle: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: PosTokens.ink3,
    ),
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: locked ? PosTokens.surface2 : PosTokens.surface,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
    border: _border(PosTokens.line),
    enabledBorder: _border(PosTokens.line),
    focusedBorder: _border(PosTokens.blue, 1.5),
    errorBorder: _border(PosTokens.loss),
    focusedErrorBorder: _border(PosTokens.loss, 1.5),
  );
}

/// Full-width primary action: the brand-blue gradient used by checkout.
class MobileEntryPrimaryButton extends StatelessWidget {
  const MobileEntryPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isBusy = false,
  });

  final String label;

  /// Null greys the button out (the form isn't ready yet).
  final VoidCallback? onPressed;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isBusy;
    return SizedBox(
      width: double.infinity,
      height: MposTokens.checkoutPrimaryHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: enabled ? MposTokens.gradBtn : null,
          color: enabled ? null : PosTokens.ink4,
          borderRadius: BorderRadius.circular(MposTokens.radiusMd),
          boxShadow: enabled ? MposTokens.shadowBlue : null,
        ),
        child: ElevatedButton(
          onPressed: enabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            disabledForegroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(MposTokens.radiusMd),
            ),
          ),
          child: isBusy
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ),
      ),
    );
  }
}

/// Secondary action: brand-blue outline on a blue tint, never a second hue.
class MobileEntrySecondaryButton extends StatelessWidget {
  const MobileEntrySecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  /// Full width and checkout height, for a stacked second action.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final style = OutlinedButton.styleFrom(
      foregroundColor: PosTokens.blue,
      backgroundColor: PosTokens.blueTint,
      side: const BorderSide(color: PosTokens.blue),
      padding: EdgeInsets.symmetric(
        horizontal: expand ? 16 : 12,
        vertical: expand ? 0 : 10,
      ),
      minimumSize: expand
          ? const Size.fromHeight(MposTokens.checkoutPrimaryHeight)
          : const Size(0, 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(expand ? MposTokens.radiusMd : 12),
      ),
    );
    // Styled on the Text, not ButtonStyle.textStyle: that one replaces the
    // theme's label style, font family included.
    final text = Text(
      label,
      style: TextStyle(fontSize: expand ? 16 : 14, fontWeight: FontWeight.w700),
    );
    if (icon == null) {
      return OutlinedButton(onPressed: onPressed, style: style, child: text);
    }
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: style,
      icon: Icon(icon, size: 18),
      label: text,
    );
  }
}

/// The same field look as [mobileEntryInputDecoration], as a theme, for forms
/// whose fields set their own floating labels (the variant sheet).
InputDecorationThemeData mobileEntryInputTheme() => InputDecorationThemeData(
  filled: true,
  fillColor: PosTokens.surface,
  hintStyle: const TextStyle(
    color: PosTokens.ink4,
    fontWeight: FontWeight.w400,
  ),
  labelStyle: const TextStyle(color: PosTokens.ink3),
  floatingLabelStyle: const TextStyle(
    color: PosTokens.blue,
    fontWeight: FontWeight.w600,
  ),
  helperStyle: mobileEntryHintStyle,
  border: _border(PosTokens.line),
  enabledBorder: _border(PosTokens.line),
  focusedBorder: _border(PosTokens.blue, 1.5),
  errorBorder: _border(PosTokens.loss),
  focusedErrorBorder: _border(PosTokens.loss, 1.5),
  disabledBorder: _border(PosTokens.line),
);
