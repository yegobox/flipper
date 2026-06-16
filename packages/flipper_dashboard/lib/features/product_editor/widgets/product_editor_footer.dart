import 'package:flipper_dashboard/features/product_editor/product_editor_tokens.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductEditorFooter extends StatelessWidget {
  const ProductEditorFooter({
    super.key,
    required this.doneCount,
    required this.totalCount,
    required this.canSave,
    required this.isSaving,
    required this.onClose,
    required this.onSave,
    this.hideClose = false,
  });

  final int doneCount;
  final int totalCount;
  final bool canSave;
  final bool isSaving;
  final VoidCallback onClose;
  final VoidCallback onSave;
  final bool hideClose;

  @override
  Widget build(BuildContext context) {
    final pct = totalCount == 0 ? 0.0 : doneCount / totalCount;
    final allDone = doneCount >= totalCount && totalCount > 0;
    final narrow = MediaQuery.sizeOf(context).width <= ProductEditorTokens.breakpointStack;

    return Container(
      height: ProductEditorTokens.footerHeight,
      decoration: BoxDecoration(
        color: ProductEditorTokens.surface,
        border: const Border(top: BorderSide(color: ProductEditorTokens.line)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF102040).withValues(alpha: 0.12),
            offset: const Offset(0, -4),
            blurRadius: 16,
            spreadRadius: -8,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: narrow ? 18 : 36),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: pct,
                      minHeight: 7,
                      backgroundColor: ProductEditorTokens.line,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        ProductEditorTokens.blue,
                      ),
                    ),
                  ),
                ),
                if (!narrow) ...[
                  const SizedBox(width: 12),
                  Text(
                    allDone
                        ? 'Ready to save'
                        : '$doneCount of $totalCount sections complete',
                    style: GoogleFonts.outfit(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: allDone
                          ? ProductEditorTokens.gain
                          : ProductEditorTokens.ink2,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (!hideClose) ...[
            _GhostButton(
              label: 'Close',
              onPressed: isSaving ? null : onClose,
            ),
            const SizedBox(width: 12),
          ],
          _PrimaryButton(
            label: 'Save product',
            onPressed: (canSave && !isSaving) ? onSave : null,
            isSaving: isSaving,
          ),
        ],
      ),
    );
  }
}

class _GhostButton extends StatelessWidget {
  const _GhostButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ProductEditorTokens.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: ProductEditorTokens.lineStrong, width: 1.5),
            boxShadow: ProductEditorTokens.surface == Colors.white
                ? const [
                    BoxShadow(
                      color: Color(0x0D102040),
                      offset: Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: ProductEditorTokens.ink2,
            ),
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.onPressed,
    required this.isSaving,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return Material(
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: enabled ? ProductEditorTokens.gradBtn : null,
            color: enabled ? null : ProductEditorTokens.blue.withValues(alpha: 0.45),
            boxShadow: enabled
                ? const [
                    BoxShadow(
                      color: Color(0x402563EB),
                      offset: Offset(0, 3),
                      blurRadius: 8,
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSaving)
                const SizedBox(
                  width: 17,
                  height: 17,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              else
                const Icon(Icons.check, size: 17, color: Colors.white),
              const SizedBox(width: 9),
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
