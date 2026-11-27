/// Whether the product editor's Save is allowed, on every layout.
///
/// A new product needs a name, a valid retail price, and a category (a combo
/// needs its components instead).
///
/// Editing needs less: the product already has prices and a category on its
/// variants, so a change to one field (its name, say) must be savable on its
/// own. Only the name is required. A blank retail price keeps each variant's
/// own price, and no category keeps each variant's own category. Text that is
/// not a number is still refused, and a combo still needs a component.
bool productCanSave({
  required bool isEditMode,
  required bool isComposite,
  required String name,
  required String retailText,
  required bool hasCategory,
  required bool hasComponents,
}) {
  if (name.trim().isEmpty) return false;
  final retail = retailText.trim();
  final retailValid = double.tryParse(retail) != null;
  if (isComposite && !hasComponents) return false;
  if (isEditMode) return retail.isEmpty || retailValid;
  if (!retailValid) return false;
  return isComposite || hasCategory;
}

/// The price an edit should write to every variant, or null to keep each
/// variant's own price. A price is written only when the user typed a
/// different amount: a blank field, or the price the editor opened with in any
/// spelling ("1000" for "1000.0"), changes nothing, so renaming a product
/// never flattens its variants' prices.
double? editedPrice({required String text, required String loadedText}) {
  final typed = double.tryParse(text.trim());
  if (typed == null || typed == double.tryParse(loadedText.trim())) {
    return null;
  }
  return typed;
}

/// A loaded price as the editor shows it: blank for none, never "null".
String priceFieldText(double? price) => price?.toString() ?? '';
