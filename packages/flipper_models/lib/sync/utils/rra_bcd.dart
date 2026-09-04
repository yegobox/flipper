/// RRA rejects `bcd` longer than 20 characters on `saveItems`, `saveSales` and
/// `saveStockItems` ("size must be between 0 and 20"), but Flipper generates
/// barcodes from a variant name plus a millisecond timestamp, which overflows
/// as soon as the name is longer than a few characters.
const int kRraBcdMaxLength = 20;

/// Cuts [bcd] down to what RRA accepts, keeping the tail.
///
/// The tail is what carries the uniqueness in generated barcodes
/// ("Variant A 1781672471286" — the name repeats across variants, the
/// timestamp does not), so trimming from the front keeps lookups by `bcd`
/// distinct where cutting the last characters off would collide.
/// Returns null for a null/blank barcode so the field stays out of the payload.
String? rraSafeBcd(String? bcd) {
  final trimmed = bcd?.trim();
  if (trimmed == null || trimmed.isEmpty) return null;
  if (trimmed.length <= kRraBcdMaxLength) return trimmed;
  return trimmed.substring(trimmed.length - kRraBcdMaxLength);
}

/// True when RRA answered with the `bcd` length validation error.
bool isRraBcdSizeError(String? msg) {
  if (msg == null || msg.isEmpty) return false;
  final lower = msg.toLowerCase();
  return lower.contains('bcd') &&
      lower.contains('size must be between 0 and $kRraBcdMaxLength');
}
