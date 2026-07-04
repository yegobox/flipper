/// Debounce before firing POS catalog Ditto search (name / barcode).
const Duration posCatalogSearchDebounce = Duration(milliseconds: 200);

/// True when the user is probably scanning/typing a barcode or fuel itemCd.
///
/// Pure letter tokens ("pain", "coupe") are product-name searches, not barcodes.
/// Require at least one digit so EAN/UPC and mixed itemCds still use exact match.
bool isLikelyCatalogBarcodeQuery(String q) {
  final t = q.trim().toLowerCase();
  if (t.length < 4 || t.contains(' ')) return false;
  if (!RegExp(r'^[a-z0-9]+$').hasMatch(t)) return false;
  return RegExp(r'[0-9]').hasMatch(t);
}
