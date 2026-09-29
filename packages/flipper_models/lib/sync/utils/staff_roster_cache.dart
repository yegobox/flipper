import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';

/// Offline copy of the shared-register staff roster (hotel desk, bar lock,
/// POS user switch).
///
/// The roster normally comes from Supabase on every open, so a device that
/// starts offline showed nobody to sign in. The last good roster is kept in
/// the box under [staffRosterCacheKey] — with PINs stored only as salted
/// SHA-256 hashes, never as the PIN itself.
///
/// Tenants restored from the cache carry `pin == null`; [barPinMatchesTenant]
/// falls back to [staffRosterPinMatches] for them.

const String staffRosterCacheKeyPrefix = 'staff_roster_';
const int _staffRosterCacheVersion = 1;

String staffRosterCacheKey(String businessId) =>
    '$staffRosterCacheKeyPrefix$businessId';

/// Salted PIN hashes for tenants restored from the cache, keyed by tenant id.
final Map<String, ({String salt, String hash})> _pinHashesByTenantId = {};

/// Leading zeros are dropped, matching the int compare in [barPinMatchesTenant].
String _normalizePin(String pin) {
  final trimmed = pin.trim();
  return int.tryParse(trimmed)?.toString() ?? trimmed;
}

String hashStaffPin(String salt, String pin) =>
    sha256.convert(utf8.encode('$salt:${_normalizePin(pin)}')).toString();

String _newSalt() {
  final rnd = Random.secure();
  return base64Url.encode(List<int>.generate(16, (_) => rnd.nextInt(256)));
}

/// Serialises [tenants] for the box. PINs are hashed; the plain value is dropped.
String encodeStaffRoster(List<Tenant> tenants, {String? salt, DateTime? now}) {
  final s = salt ?? _newSalt();
  final rows = tenants.map((t) {
    final pin = t.pin;
    return <String, dynamic>{
      'id': t.id,
      'name': t.name,
      'phone_number': t.phoneNumber,
      'email': t.email,
      'nfc_enabled': t.nfcEnabled,
      'business_id': t.businessId,
      'user_id': t.userId,
      'image_url': t.imageUrl,
      'is_default': t.isDefault,
      'type': t.type,
      'allow_business_login': t.allowBusinessLogin,
      if (pin != null && pin != 0) 'pin_hash': hashStaffPin(s, pin.toString()),
    };
  }).toList();
  return jsonEncode({
    'v': _staffRosterCacheVersion,
    'savedAt': (now ?? DateTime.now()).toUtc().toIso8601String(),
    'salt': s,
    'staff': rows,
  });
}

/// Restores a roster written by [encodeStaffRoster] and registers its PIN
/// hashes for [staffRosterPinMatches]. Returns `[]` for missing/corrupt data.
List<Tenant> decodeStaffRoster(String? raw) {
  if (raw == null || raw.isEmpty) return const [];
  try {
    final decoded = jsonDecode(raw);
    if (decoded is! Map || decoded['v'] != _staffRosterCacheVersion) {
      return const [];
    }
    final salt = decoded['salt'];
    final staff = decoded['staff'];
    if (salt is! String || staff is! List) return const [];

    final out = <Tenant>[];
    for (final item in staff) {
      if (item is! Map) continue;
      final id = item['id']?.toString();
      if (id == null || id.isEmpty) continue;
      final tenant = Tenant(
        id: id,
        name: item['name'] as String?,
        phoneNumber: item['phone_number'] as String?,
        email: item['email'] as String?,
        nfcEnabled: (item['nfc_enabled'] as bool?) ?? false,
        businessId: item['business_id'] as String?,
        userId: item['user_id'] as String?,
        imageUrl: item['image_url'] as String?,
        isDefault: item['is_default'] as bool?,
        type: (item['type'] as String?) ?? 'Agent',
        allowBusinessLogin: (item['allow_business_login'] as bool?) ?? false,
      );
      final hash = item['pin_hash'];
      if (hash is String && hash.isNotEmpty) {
        _pinHashesByTenantId[id] = (salt: salt, hash: hash);
      } else {
        _pinHashesByTenantId.remove(id);
      }
      out.add(tenant);
    }
    return out;
  } catch (_) {
    return const [];
  }
}

/// Whether [tenant] was restored from the cache with a PIN on record.
bool staffRosterHasCachedPin(Tenant tenant) =>
    _pinHashesByTenantId.containsKey(tenant.id);

/// Checks [enteredPin] against the cached hash for [tenant] (offline path).
bool staffRosterPinMatches(Tenant tenant, String enteredPin) {
  final entry = _pinHashesByTenantId[tenant.id];
  if (entry == null) return false;
  return hashStaffPin(entry.salt, enteredPin) == entry.hash;
}
