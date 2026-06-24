import 'package:flipper_dashboard/features/product_editor/product_editor_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class PeField extends StatelessWidget {
  const PeField({
    super.key,
    required this.label,
    this.required = false,
    this.optional = false,
    this.hint,
    required this.child,
  });

  final String label;
  final bool required;
  final bool optional;
  final String? hint;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: ProductEditorTokens.ink2,
              ),
            ),
            if (required)
              Text(
                ' *',
                style: GoogleFonts.outfit(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: ProductEditorTokens.loss,
                ),
              ),
            if (optional)
              Text(
                ' · optional',
                style: GoogleFonts.outfit(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: ProductEditorTokens.ink4,
                ),
              ),
          ],
        ),
        const SizedBox(height: 7),
        child,
        if (hint != null) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.info_outline, size: 13, color: ProductEditorTokens.ink4),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  hint!,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: ProductEditorTokens.ink3,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class PeTextInput extends StatelessWidget {
  const PeTextInput({
    super.key,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.validator,
    this.placeholder,
    this.prefix,
    this.suffix,
    this.mono = false,
    this.readOnly = false,
    this.keyboardType,
    this.inputFormatters,
    this.textInputAction,
    this.onFieldSubmitted,
    this.obscureText = false,
    this.maxLines = 1,
    this.enabled = true,
    this.locked = false,
    this.onTap,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final String? placeholder;
  final String? prefix;
  final Widget? suffix;
  final bool mono;
  final bool readOnly;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final bool obscureText;
  final int maxLines;
  final bool enabled;
  final bool locked;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final filled = (controller?.text.isNotEmpty ?? false);
    return Container(
      height: ProductEditorTokens.fieldHeight,
      decoration: BoxDecoration(
        color: locked
            ? ProductEditorTokens.surface2
            : filled
            ? ProductEditorTokens.surface2
            : ProductEditorTokens.surface,
        borderRadius: BorderRadius.circular(PosTokensRadius.md),
        border: Border.all(
          color: locked ? ProductEditorTokens.line : ProductEditorTokens.line,
          width: 1.5,
          style: locked ? BorderStyle.solid : BorderStyle.solid,
        ),
      ),
      foregroundDecoration: locked
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(PosTokensRadius.md),
              border: Border.all(
                color: ProductEditorTokens.line,
                width: 1.5,
                style: BorderStyle.solid,
              ),
            )
          : null,
      child: Row(
        children: [
          if (prefix != null) ...[
            Padding(
              padding: const EdgeInsets.only(left: 14),
              child: Text(
                prefix!,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: ProductEditorTokens.ink3,
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: TextFormField(
              controller: controller,
              focusNode: focusNode,
              onChanged: onChanged,
              validator: validator,
              readOnly: readOnly || locked,
              enabled: enabled,
              onTap: onTap,
              obscureText: obscureText,
              maxLines: maxLines,
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
              textInputAction: textInputAction,
              onFieldSubmitted: onFieldSubmitted,
              style: GoogleFonts.outfit(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: locked ? ProductEditorTokens.ink2 : ProductEditorTokens.ink1,
                fontFeatures: mono ? const [FontFeature.tabularFigures()] : null,
              ).copyWith(
                fontFamily: mono ? GoogleFonts.jetBrainsMono().fontFamily : null,
              ),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: prefix == null ? 14 : 0,
                  vertical: 14,
                ),
                hintText: placeholder,
                hintStyle: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: ProductEditorTokens.ink4,
                ),
              ),
            ),
          ),
          if (locked)
            const Padding(
              padding: EdgeInsets.only(right: 14),
              child: Icon(Icons.lock, size: 16, color: ProductEditorTokens.ink4),
            )
          else if (suffix != null)
            Padding(padding: const EdgeInsets.only(right: 10), child: suffix),
        ],
      ),
    );
  }
}

/// Alias for radius from pos tokens used in pe widgets.
abstract final class PosTokensRadius {
  static const double md = 14;
}
