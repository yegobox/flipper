import 'package:flipper_dashboard/features/product_editor/product_editor_tokens.dart';
import 'package:flipper_design_system/flipper_design_system.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';

/// The product editor's header: Flipper's [CustomAppBar] with the product's
/// live name as the title and the breadcrumb ("NEW PRODUCT", "EDIT COMBO"…)
/// underneath.
class ProductEditorTopBar extends StatelessWidget {
  const ProductEditorTopBar({
    super.key,
    required this.isEditMode,
    required this.isComposite,
    this.productName,
    this.productNameController,
    required this.onBack,
    this.isSaving = false,
    this.icon = Icons.arrow_back,
  }) : assert(productName != null || productNameController != null);

  final bool isEditMode;
  final bool isComposite;
  final String? productName;
  final TextEditingController? productNameController;
  final VoidCallback onBack;
  final bool isSaving;

  /// [Icons.close] on a phone, where the editor is a full-screen task.
  final IconData icon;

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

    Widget bar(String name) => CustomAppBar(
      title: _displayName(context, name),
      subtitle: breadcrumb,
      icon: icon,
      // Leaving mid-save would drop the half-written product.
      onPop: isSaving ? null : onBack,
      barBackgroundColor: ProductEditorTokens.surface,
      bottomSpacer: ProductEditorTokens.topBarHeight,
    );

    final controller = productNameController;
    if (controller == null) return bar(productName!);
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) => bar(controller.text),
    );
  }
}
