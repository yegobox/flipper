import 'package:flipper_dashboard/features/product_editor/product_editor_tokens.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductEditorTopBar extends StatelessWidget {
  const ProductEditorTopBar({
    super.key,
    required this.isEditMode,
    required this.isComposite,
    this.productName,
    this.productNameController,
    required this.onBack,
    this.isSaving = false,
  }) : assert(productName != null || productNameController != null);

  final bool isEditMode;
  final bool isComposite;
  final String? productName;
  final TextEditingController? productNameController;
  final VoidCallback onBack;
  final bool isSaving;

  String _displayName(BuildContext context, String raw) => raw.trim().isEmpty
      ? context.flipperL10n.productEditorUntitledProduct
      : raw.trim();

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final breadcrumb = isEditMode
        ? (isComposite
              ? l10n.productEditorBreadcrumbEditComposite
              : l10n.productEditorBreadcrumbEditProduct)
        : (isComposite
              ? l10n.productEditorBreadcrumbNewComposite
              : l10n.productEditorBreadcrumbNewProduct);

    Widget title;
    if (productNameController != null) {
      title = ListenableBuilder(
        listenable: productNameController!,
        builder: (context, _) => Text(
          _displayName(context, productNameController!.text),
          style: GoogleFonts.outfit(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
            color: ProductEditorTokens.ink1,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      );
    } else {
      title = Text(
        _displayName(context, productName!),
        style: GoogleFonts.outfit(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
          color: ProductEditorTokens.ink1,
        ),
        overflow: TextOverflow.ellipsis,
      );
    }

    return Container(
      height: ProductEditorTokens.topBarHeight,
      decoration: const BoxDecoration(
        color: ProductEditorTokens.surface,
        border: Border(bottom: BorderSide(color: ProductEditorTokens.line)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Row(
        children: [
          Material(
            color: ProductEditorTokens.surface2,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: isSaving ? null : onBack,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: ProductEditorTokens.line),
                ),
                child: Icon(
                  Icons.chevron_left,
                  size: 20,
                  color: isSaving
                      ? ProductEditorTokens.ink4
                      : ProductEditorTokens.ink2,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  breadcrumb,
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: ProductEditorTokens.ink3,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                title,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
