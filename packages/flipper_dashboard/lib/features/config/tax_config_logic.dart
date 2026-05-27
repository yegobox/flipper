/// Pure helpers for tax configuration change detection (unit-tested).
library;

/// Trim-only normalization for URLs and codes (no slash stripping).
String trimTaxConfigUrl(String? value) => (value ?? '').trim();

/// Empty or whitespace-only optional URL → `null` for persistence / equality.
String? normalizeOptionalConnectorUrl(String? value) {
  final t = trimTaxConfigUrl(value);
  return t.isEmpty ? null : t;
}

/// Snapshot of tax config fields used for dirty checking.
class TaxConfigSnapshot {
  const TaxConfigSnapshot({
    required this.serverUrl,
    required this.dataConnectorUrlOrNull,
    required this.bhfId,
    required this.mrc,
    required this.vatEnabled,
  });

  /// Tax server URL — trim only (trailing slash preserved when non-empty).
  final String serverUrl;

  /// Data connector base URL; `null` means unset / empty field.
  final String? dataConnectorUrlOrNull;

  final String bhfId;
  final String mrc;
  final bool vatEnabled;

  /// Build a snapshot from raw form strings and VAT flag.
  factory TaxConfigSnapshot.fromInputs({
    required String serverUrl,
    required String dataConnectorUrl,
    required String bhfId,
    required String mrc,
    required bool vatEnabled,
  }) {
    return TaxConfigSnapshot(
      serverUrl: trimTaxConfigUrl(serverUrl),
      dataConnectorUrlOrNull:
          normalizeOptionalConnectorUrl(dataConnectorUrl),
      bhfId: trimTaxConfigUrl(bhfId),
      mrc: trimTaxConfigUrl(mrc),
      vatEnabled: vatEnabled,
    );
  }
}

/// Whether the user changed any persisted field compared to [initial].
bool taxConfigHasChanges(
  TaxConfigSnapshot initial,
  TaxConfigSnapshot current,
) {
  return initial.serverUrl != current.serverUrl ||
      initial.dataConnectorUrlOrNull != current.dataConnectorUrlOrNull ||
      initial.bhfId != current.bhfId ||
      initial.mrc != current.mrc ||
      initial.vatEnabled != current.vatEnabled;
}
