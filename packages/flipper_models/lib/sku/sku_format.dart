/// How a SKU is written. Pure functions only: data-connector
/// (`src/sku/mod.rs`) applies the same rules, so keep the two in step.
///
/// A SKU is the shop's own code for an item, unique within the business and
/// shared by that item's copies at every branch. It is never the barcode
/// (`Variant.bcd`, the manufacturer's GTIN) nor the RRA item code
/// (`Variant.itemCd`).
///
/// Shape: `<PREFIX>-<number padded to 5>`, e.g. `BEV-00042`. Extra variants
/// of one product reuse the base number with a suffix of two digits or more:
/// `BEV-00042-02`, `BEV-00042-03`, ..., `BEV-00042-100`. The number comes
/// from one counter per business, so the number alone is unique and renaming
/// a prefix can never create a clash.
///
/// Rust's `split_sku` still takes two-digit suffixes only, so a `-100` sibling
/// is invisible to the connector sweep (it would pick `-100` again there).
library;

/// Prefix used when an item has no category, or the category name has fewer
/// than two letters or digits.
const String kDefaultSkuPrefix = 'SKU';

final RegExp _prefixPattern = RegExp(r'^[A-Z0-9]{2,6}$');
// The suffix is two digits or more: the 100th variant is `-100`.
final RegExp _basePattern = RegExp(r'^([A-Z0-9]{2,6}-[0-9]{5,})(-[0-9]{2,})?$');
final RegExp _legacyInteger = RegExp(r'^[0-9]{1,7}$');
final RegExp _prefixedNumber = RegExp(
  r'^[A-Za-z0-9]{1,6}-([0-9]{1,9})(-[0-9]{2,})?$',
);

/// Whether [value] is a valid stored prefix (`categories.sku_prefix`).
bool isValidSkuPrefix(String? value) =>
    value != null && _prefixPattern.hasMatch(value);

/// The prefix for an item in a category.
///
/// A valid [skuPrefix] set on the category wins. Otherwise the category name
/// is upper-cased and reduced to ASCII letters and digits; the first three of
/// those (or two, if only two remain) form the prefix. Anything shorter, or no
/// category at all, gives [kDefaultSkuPrefix].
String deriveSkuPrefix({String? skuPrefix, String? categoryName}) {
  final explicit = skuPrefix?.trim();
  if (isValidSkuPrefix(explicit)) return explicit!;
  // Strip to ASCII before upper-casing, as data-connector does: Dart's
  // toUpperCase turns "ß" into "SS" and "ı" into "I", Rust's ASCII filter
  // drops them.
  final kept = (categoryName ?? '')
      .replaceAll(RegExp(r'[^A-Za-z0-9]'), '')
      .toUpperCase();
  if (kept.length < 2) return kDefaultSkuPrefix;
  return kept.substring(0, kept.length >= 3 ? 3 : 2);
}

/// `PREFIX-00042`, plus `-NN` when [variantIndex] is greater than 1.
String formatSku(String prefix, int number, {int variantIndex = 1}) {
  final base = '$prefix-${number.toString().padLeft(5, '0')}';
  if (variantIndex <= 1) return base;
  return '$base-${variantIndex.toString().padLeft(2, '0')}';
}

/// The base part of a generated SKU (`BEV-00042` for `BEV-00042-03`), or null
/// when [sku] was not generated in this format (a typed or legacy SKU).
String? skuBase(String? sku) {
  final match = _basePattern.firstMatch(sku?.trim() ?? '');
  return match?.group(1);
}

/// The variant index of a generated SKU: 1 for the base, N for `-NN`.
/// Null when [sku] is not in the generated format.
int? skuVariantIndex(String? sku) {
  final match = _basePattern.firstMatch(sku?.trim() ?? '');
  if (match == null) return null;
  final suffix = match.group(2);
  return suffix == null ? 1 : int.parse(suffix.substring(1));
}

/// SKU for one more variant of the product whose first SKU is [baseSku].
///
/// The index is one past the highest index among [siblingSkus] that share the
/// base (the base alone counts as 1). Returns null when [baseSku] is not a
/// generated SKU, so the caller allocates a fresh number instead.
String? nextVariantSku(String baseSku, Iterable<String?> siblingSkus) {
  final base = skuBase(baseSku);
  if (base == null) return null;
  var highest = 1;
  for (final sibling in siblingSkus) {
    if (skuBase(sibling) != base) continue;
    final index = skuVariantIndex(sibling)!;
    if (index > highest) highest = index;
  }
  return '$base-${(highest + 1).toString().padLeft(2, '0')}';
}

/// The counter number a SKU already used, for seeding a counter so new SKUs
/// never repeat it. Counts plain integers of up to 7 digits (the old per-branch
/// sequence) and the `PREFIX-number` form. Longer runs of digits are barcodes
/// typed into the SKU field and are ignored, as is anything else.
int? legacySkuNumber(String? sku) {
  final value = sku?.trim() ?? '';
  if (_legacyInteger.hasMatch(value)) return int.parse(value);
  final match = _prefixedNumber.firstMatch(value);
  if (match == null) return null;
  return int.parse(match.group(1)!);
}

/// Normalised form used to compare SKUs: trimmed and lower-cased, matching
/// the server's unique index on `(branch_id, lower(sku))`.
String normalizeSku(String? sku) => sku?.trim().toLowerCase() ?? '';
