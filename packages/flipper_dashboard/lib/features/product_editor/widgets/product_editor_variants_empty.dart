import 'package:flipper_dashboard/features/product_editor/product_editor_tokens.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Handoff `.pe-var-empty` placeholder.
class ProductEditorVariantsEmpty extends StatelessWidget {
  const ProductEditorVariantsEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        color: ProductEditorTokens.surface2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: ProductEditorTokens.lineStrong,
          width: 1.5,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: ProductEditorTokens.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: ProductEditorTokens.line),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              size: 22,
              color: ProductEditorTokens.ink3,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'No variants yet',
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: ProductEditorTokens.ink1,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'Scan or type a variant name above to add one',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 12.5,
              color: ProductEditorTokens.ink3,
            ),
          ),
        ],
      ),
    );
  }
}
