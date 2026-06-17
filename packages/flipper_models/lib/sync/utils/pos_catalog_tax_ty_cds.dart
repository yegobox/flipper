/// Tax type codes shown in POS product catalog search and browse.
///
/// Includes [F] (regulated fuel) synced via data-connector `fuel_reference`.
List<String> posCatalogTaxTyCds({required bool vatEnabled}) {
  if (vatEnabled) {
    return const ['A', 'B', 'C', 'F', 'TT'];
  }
  return const ['D', 'F', 'TT'];
}
