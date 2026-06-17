/// Debounce before firing POS catalog Ditto search (name / barcode).
const Duration posCatalogSearchDebounce = Duration(milliseconds: 200);

/// True when the user is probably scanning/typing a barcode or fuel itemCd.
bool isLikelyCatalogBarcodeQuery(String q) {
  final t = q.trim().toLowerCase();
  if (t.length < 4 || t.contains(' ')) return false;
  return RegExp(r'^[a-z0-9]+$').hasMatch(t);
}
