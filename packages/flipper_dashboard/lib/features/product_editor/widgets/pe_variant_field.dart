import 'package:flipper_dashboard/features/product_editor/product_editor_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class PeVariantField extends StatelessWidget {
  const PeVariantField({
    super.key,
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.outfit(
            fontSize: 10.5,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
            color: ProductEditorTokens.ink3,
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

class PeVariantBox extends StatelessWidget {
  const PeVariantBox({
    super.key,
    required this.child,
    this.prefix,
    this.suffix,
    this.onTap,
    this.expirationStyle = false,
  });

  final Widget child;
  final String? prefix;
  final String? suffix;
  final VoidCallback? onTap;
  final bool expirationStyle;

  @override
  Widget build(BuildContext context) {
    final box = Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 11),
      decoration: BoxDecoration(
        color: ProductEditorTokens.surface,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: ProductEditorTokens.line, width: 1.5),
      ),
      child: Row(
        children: [
          if (prefix != null) ...[
            Text(
              prefix!,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: ProductEditorTokens.ink3,
              ),
            ),
            const SizedBox(width: 6),
          ],
          Expanded(child: child),
          if (suffix != null) ...[
            const SizedBox(width: 6),
            Text(
              suffix!,
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: ProductEditorTokens.ink3,
              ),
            ),
          ],
        ],
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(9),
          child: box,
        ),
      );
    }
    return box;
  }
}

class PeVariantTextInput extends StatelessWidget {
  const PeVariantTextInput({
    super.key,
    this.controller,
    this.onChanged,
    this.keyboardType,
    this.inputFormatters,
    this.placeholder,
    this.mono = true,
    this.readOnly = false,
    this.onTap,
    this.prefix,
    this.suffix,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? placeholder;
  final bool mono;
  final bool readOnly;
  final VoidCallback? onTap;
  final String? prefix;
  final String? suffix;

  @override
  Widget build(BuildContext context) {
    return PeVariantBox(
      prefix: prefix,
      suffix: suffix,
      onTap: onTap,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: (mono ? GoogleFonts.jetBrainsMono : GoogleFonts.outfit)(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: ProductEditorTokens.ink1,
        ),
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          hintText: placeholder,
          hintStyle: GoogleFonts.outfit(
            fontSize: 13.5,
            color: ProductEditorTokens.ink4,
          ),
        ),
      ),
    );
  }
}

class PeVariantQtyButton extends StatelessWidget {
  const PeVariantQtyButton({
    super.key,
    required this.quantity,
    required this.onTap,
  });

  final double? quantity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final display = (quantity ?? 0).toStringAsFixed(1);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: ProductEditorTokens.surface,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: ProductEditorTokens.line, width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                display,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1D4ED8),
                ),
              ),
              const Icon(
                Icons.edit_outlined,
                size: 14,
                color: ProductEditorTokens.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PeVariantPhotoCell extends StatelessWidget {
  const PeVariantPhotoCell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 38,
      height: 38,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: ProductEditorTokens.surface,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: ProductEditorTokens.lineStrong,
            width: 1.5,
            style: BorderStyle.solid,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: child,
        ),
      ),
    );
  }
}
