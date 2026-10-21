import 'dart:convert';

/// Whether a business runs a shop or is used for personal money management.
///
/// Supabase `businesses.account_mode` is the truth; data-connector
/// (`POST /api/account-mode`) is its only writer and mirrors it into the Ditto
/// [kAccountModesCollection] doc this app observes. See
/// `docs/personal_mode.md`.
///
/// **Anything unknown is [business].** A missing doc, an old cache, a typo or a
/// failed lookup all keep today's shop experience, so a business account can
/// never be shown the personal app by accident.
enum AccountMode {
  business,
  personal;

  bool get isPersonal => this == AccountMode.personal;

  /// The wire value.
  String get value => name;
}

/// Only an exact `'personal'` (trimmed) is personal.
AccountMode parseAccountMode(Object? value) =>
    value is String && value.trim() == 'personal'
    ? AccountMode.personal
    : AccountMode.business;

/// One doc per business, `_id` = business id, `{mode, changedAt}`.
const String kAccountModesCollection = 'business_account_modes';

/// Box key: JSON `{businessId: mode}` of every mode this device has seen, so a
/// cold start before Ditto is up opens the right shell.
const String kAccountModeCacheKey = 'accountModes';

/// Box key: `'personal'` after a personal signup until the server confirmed
/// it. The device behaves as personal meanwhile.
const String kPendingAccountModeKey = 'pendingAccountMode';

/// Reads the cached mode of [businessId] from the [kAccountModeCacheKey]
/// value. `null` when this device has never seen one.
AccountMode? cachedAccountMode(String? raw, String businessId) {
  final map = _decode(raw);
  final value = map[businessId];
  return value == null ? null : parseAccountMode(value);
}

/// The [kAccountModeCacheKey] value with [businessId] set to [mode].
String withCachedAccountMode(String? raw, String businessId, AccountMode mode) {
  final map = _decode(raw)..[businessId] = mode.value;
  return jsonEncode(map);
}

Map<String, Object?> _decode(String? raw) {
  if (raw == null || raw.trim().isEmpty) return {};
  try {
    final decoded = jsonDecode(raw);
    if (decoded is Map) {
      return {for (final e in decoded.entries) '${e.key}': e.value};
    }
  } catch (_) {
    // A corrupt cache is an empty one.
  }
  return {};
}

/// The mode a device should use, from what it knows locally, in order of
/// trust: the Ditto doc (server-written), a signup still waiting for the
/// server, then the cache. `null` when none of them knows.
AccountMode? localAccountMode({
  required Map<String, dynamic>? dittoDoc,
  required String? pending,
  required AccountMode? cached,
}) {
  if (dittoDoc != null) return parseAccountMode(dittoDoc['mode']);
  if (parseAccountMode(pending).isPersonal) return AccountMode.personal;
  return cached;
}
