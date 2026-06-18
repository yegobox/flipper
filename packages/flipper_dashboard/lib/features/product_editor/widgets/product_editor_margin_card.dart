import 'package:flipper_dashboard/features/product_editor/product_editor_tokens.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ProductEditorMarginCard extends StatelessWidget {
  const ProductEditorMarginCard({
    super.key,
    this.retailText,
    this.supplyText,
    this.retailController,
    this.supplyController,
    this.isComposite = false,
  }) : assert(
         (retailText != null && supplyText != null) ||
             (retailController != null && supplyController != null),
       );

  final String? retailText;
  final String? supplyText;
  final TextEditingController? retailController;
  final TextEditingController? supplyController;
  final bool isComposite;

  @override
  Widget build(BuildContext context) {
    if (retailController != null && supplyController != null) {
      return ListenableBuilder(
        listenable: Listenable.merge([retailController!, supplyController!]),
        builder: (context, _) => _MarginBody(
          retailText: retailController!.text,
          supplyText: supplyController!.text,
          isComposite: isComposite,
        ),
      );
    }
    return _MarginBody(
      retailText: retailText!,
      supplyText: supplyText!,
      isComposite: isComposite,
    );
  }
}

class _MarginBody extends StatelessWidget {
  const _MarginBody({
    required this.retailText,
    required this.supplyText,
    required this.isComposite,
  });

  final String retailText;
  final String supplyText;
  final bool isComposite;

  @override
  Widget build(BuildContext context) {
    final retail = double.tryParse(retailText) ?? 0;
    final supply = double.tryParse(supplyText) ?? 0;
    final profit = retail - supply;
    final pct = retail > 0 ? (profit / retail) * 100 : 0.0;
    final negative = profit < 0;
    final fmt = NumberFormat('#,##0', 'en_US');

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: ProductEditorTokens.surface2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ProductEditorTokens.line),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Profit per unit',
                style: GoogleFonts.outfit(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: ProductEditorTokens.ink2,
                ),
              ),
              Text(
                '${negative ? '−' : ''}RWF ${fmt.format(profit.abs())}',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: negative
                      ? ProductEditorTokens.loss
                      : ProductEditorTokens.gain,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Margin',
                style: GoogleFonts.outfit(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: ProductEditorTokens.ink2,
                ),
              ),
              Text(
                '${pct.toStringAsFixed(0)}%',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: negative
                      ? ProductEditorTokens.loss
                      : ProductEditorTokens.ink1,
                ),
              ),
            ],
          ),
          if (isComposite) ...[
            const SizedBox(height: 6),
            Text(
              'Supply price calculated from components',
              style: GoogleFonts.outfit(
                fontSize: 11.5,
                color: ProductEditorTokens.ink3,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
