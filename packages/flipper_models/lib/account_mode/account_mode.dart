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

/// One business's cached mode, with the server's `changedAt` when known.
class CachedAccountMode {
  const CachedAccountMode(this.mode, {this.changedAt});

  final AccountMode mode;
  final DateTime? changedAt;
}

DateTime? _time(Object? value) =>
    value is String ? DateTime.tryParse(value.trim())?.toUtc() : null;

/// The cached entry of [businessId] from the [kAccountModeCacheKey] value.
/// Reads both the current `{mode, changedAt}` form and the older plain
/// string. `null` when this device has never seen one.
CachedAccountMode? cachedAccountModeEntry(String? raw, String businessId) {
  final value = _decode(raw)[businessId];
  if (value == null) return null;
  if (value is Map) {
    return CachedAccountMode(
      parseAccountMode(value['mode']),
      changedAt: _time(value['changedAt']),
    );
  }
  return CachedAccountMode(parseAccountMode(value));
}

/// Reads the cached mode of [businessId]. `null` when never seen.
AccountMode? cachedAccountMode(String? raw, String businessId) =>
    cachedAccountModeEntry(raw, businessId)?.mode;

/// The [kAccountModeCacheKey] value with [businessId] set to [mode].
String withCachedAccountMode(
  String? raw,
  String businessId,
  AccountMode mode, {
  DateTime? changedAt,
}) {
  final map = _decode(raw)
    ..[businessId] = {
      'mode': mode.value,
      if (changedAt != null) 'changedAt': changedAt.toUtc().toIso8601String(),
    };
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

/// `changedAt` of a server-written Ditto doc.
DateTime? accountModeDocChangedAt(Map<String, dynamic>? doc) =>
    _time(doc?['changedAt']);

/// The mode a device should use, from what it knows locally. `null` when
/// nothing knows.
///
/// The Ditto doc is the server's, but it only changes once the connector's
/// write syncs back. A switch made on this device is cached with the
/// server's `changedAt` the moment the server answers, so whichever of the
/// two is **newer** wins: right after a switch that is the cache, and once
/// the doc catches up it is the doc again. A cache entry with no time never
/// beats a doc. Without a doc, a personal signup still waiting for the
/// server is personal, then the cache.
AccountMode? localAccountMode({
  required Map<String, dynamic>? dittoDoc,
  required String? pending,
  required CachedAccountMode? cached,
}) {
  if (dittoDoc != null) {
    final docAt = accountModeDocChangedAt(dittoDoc);
    final cachedAt = cached?.changedAt;
    if (cachedAt != null && (docAt == null || cachedAt.isAfter(docAt))) {
      return cached!.mode;
    }
    return parseAccountMode(dittoDoc['mode']);
  }
  if (parseAccountMode(pending).isPersonal) return AccountMode.personal;
  return cached?.mode;
}
