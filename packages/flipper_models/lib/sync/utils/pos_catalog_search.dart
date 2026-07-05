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

/// Exact bcd/itemCd match for barcode-like catalog searches.
///
/// [filterQuery] must contain the WHERE filters only (no ORDER BY/LIMIT) —
/// the suffix is appended here exactly once. Binds `:bcdExact`.
String catalogBarcodeExactQuery(String filterQuery, String orderSuffix) {
  return "$filterQuery AND (LOWER(TRIM(COALESCE(bcd, ''))) = :bcdExact OR "
      "LOWER(TRIM(COALESCE(itemCd, ''))) = :bcdExact)$orderSuffix";
}

/// Name/itemNm/productName substring fallback when the exact barcode search
/// found nothing (e.g. numeric product names). Binds `:searchLike`.
String catalogBarcodeNameFallbackQuery(String filterQuery, String orderSuffix) {
  return "$filterQuery AND (LOWER(COALESCE(name, '')) LIKE :searchLike OR "
      "LOWER(COALESCE(itemNm, '')) LIKE :searchLike OR "
      "LOWER(COALESCE(productName, '')) LIKE :searchLike)$orderSuffix";
}
