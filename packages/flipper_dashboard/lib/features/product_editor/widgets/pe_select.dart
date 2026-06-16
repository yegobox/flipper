import 'package:flipper_dashboard/features/product_editor/product_editor_tokens.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PeSelect<T> extends StatelessWidget {
  const PeSelect({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint,
    this.enabled = true,
    this.displayBuilder,
  });

  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? hint;
  final bool enabled;
  final String Function(T value)? displayBuilder;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ProductEditorTokens.fieldHeight,
      child: Stack(
      alignment: Alignment.centerRight,
      children: [
        DropdownButtonFormField<T>(
          value: items.any((i) => i.value == value) ? value : null,
          items: items,
          onChanged: enabled ? onChanged : null,
          isExpanded: true,
          icon: const SizedBox.shrink(),
          decoration: InputDecoration(
            filled: true,
            fillColor: ProductEditorTokens.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: ProductEditorTokens.line,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: ProductEditorTokens.line,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: ProductEditorTokens.blue,
                width: 1.5,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: ProductEditorTokens.line,
                width: 1.5,
              ),
            ),
            hintText: hint,
            hintStyle: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: ProductEditorTokens.ink4,
            ),
          ),
          style: GoogleFonts.outfit(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: enabled ? ProductEditorTokens.ink1 : ProductEditorTokens.ink3,
          ),
          dropdownColor: ProductEditorTokens.surface,
        ),
        const Padding(
          padding: EdgeInsets.only(right: 14),
          child: Icon(
            Icons.expand_more,
            size: 18,
            color: ProductEditorTokens.ink3,
          ),
        ),
      ],
      ),
    );
  }
}
