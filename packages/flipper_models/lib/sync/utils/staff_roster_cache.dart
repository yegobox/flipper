import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';

/// Offline copy of the shared-register staff roster (hotel desk, bar lock,
/// POS user switch).
///
/// The roster normally comes from Supabase on every open, so a device that
/// starts offline showed nobody to sign in. The last good roster is kept in
/// the box under [staffRosterCacheKey] — with PINs stored only as salted
/// PBKDF2-HMAC-SHA256 verifiers, never as the PIN itself.
///
/// Tenants restored from the cache carry `pin == null`; [barPinMatchesTenant]
/// falls back to [staffRosterPinMatches] for them. The verifier is attached to
/// the restored [Tenant] object itself, so a live tenant with the same id (e.g.
/// one whose PIN was since removed) never inherits it.
///
/// A six-digit PIN has only 10^6 values, so no KDF makes the verifiers safe
/// once the box file is copied off the device; the iteration count only makes
/// that search slower than a single hash.

const String staffRosterCacheKeyPrefix = 'staff_roster_';

/// v1 stored single SHA-256 hashes and never shipped; it is ignored on read.
const int _staffRosterCacheVersion = 2;

/// PBKDF2 rounds for new cache writes. Stored per cache, so it can be raised
/// without a version bump.
const int staffRosterPinIterations = 10000;
const int _maxPinIterations = 1000000;

String staffRosterCacheKey(String businessId) =>
    '$staffRosterCacheKeyPrefix$businessId';

typedef _PinVerifier = ({String salt, String hash, int iterations});

/// Verifiers for tenants restored by [decodeStaffRoster], keyed by object.
final Expando<_PinVerifier> _verifierOf = Expando('staffRosterPinVerifier');

/// Last derivation, so checking one PIN against several managers costs one KDF.
({String salt, int iterations, String pin, String hash})? _lastDerived;

/// Leading zeros are dropped, matching the int compare in [barPinMatchesTenant].
String _normalizePin(String pin) {
  final trimmed = pin.trim();
  return int.tryParse(trimmed)?.toString() ?? trimmed;
}

/// PBKDF2-HMAC-SHA256, one 32-byte block.
Uint8List _pbkdf2(List<int> password, List<int> salt, int iterations) {
  final hmac = Hmac(sha256, password);
  var u = hmac.convert([...salt, 0, 0, 0, 1]).bytes;
  final out = Uint8List.fromList(u);
  for (var i = 1; i < iterations; i++) {
    u = hmac.convert(u).bytes;
    for (var j = 0; j < out.length; j++) {
      out[j] ^= u[j];
    }
  }
  return out;
}

String hashStaffPin(
  String salt,
  String pin, {
  int iterations = staffRosterPinIterations,
}) => base64Url.encode(
  _pbkdf2(utf8.encode(_normalizePin(pin)), utf8.encode(salt), iterations),
);

String _newSalt() {
  final rnd = Random.secure();
  return base64Url.encode(List<int>.generate(16, (_) => rnd.nextInt(256)));
}

List<Map<String, dynamic>> _rowsOf(List<Tenant> tenants) => tenants
    .map(
      (t) => <String, dynamic>{
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
        'pin': t.pin,
      },
    )
    .toList();

typedef _EncodeJob = ({
  List<Map<String, dynamic>> rows,
  String salt,
  String savedAt,
  int iterations,
});

String _encodeRows(_EncodeJob job) {
  final rows = job.rows.map((row) {
    final out = Map<String, dynamic>.of(row);
    final pin = out.remove('pin') as int?;
    if (pin != null && pin != 0) {
      out['pin_hash'] = hashStaffPin(
        job.salt,
        pin.toString(),
        iterations: job.iterations,
      );
    }
    return out;
  }).toList();
  return jsonEncode({
    'v': _staffRosterCacheVersion,
    'savedAt': job.savedAt,
    'salt': job.salt,
    'iterations': job.iterations,
    'staff': rows,
  });
}

_EncodeJob _jobFor(
  List<Tenant> tenants,
  String? salt,
  DateTime? now,
  int iterations,
) => (
  rows: _rowsOf(tenants),
  salt: salt ?? _newSalt(),
  savedAt: (now ?? DateTime.now()).toUtc().toIso8601String(),
  iterations: iterations,
);

/// Serialises [tenants] for the box. PINs are hashed; the plain value is dropped.
String encodeStaffRoster(
  List<Tenant> tenants, {
  String? salt,
  DateTime? now,
  int iterations = staffRosterPinIterations,
}) => _encodeRows(_jobFor(tenants, salt, now, iterations));

/// [encodeStaffRoster] on a background isolate — one KDF per PIN is too slow
/// for the UI thread with a full roster.
Future<String> encodeStaffRosterInBackground(List<Tenant> tenants) => compute(
  _encodeRows,
  _jobFor(tenants, null, null, staffRosterPinIterations),
);

/// Identifies a roster's contents (PINs included) so an unchanged roster is
/// not re-hashed and rewritten on every fetch. Kept in memory only.
String staffRosterFingerprint(List<Tenant> tenants) =>
    sha256.convert(utf8.encode(jsonEncode(_rowsOf(tenants)))).toString();

/// Whether a re-read roster differs from the one on screen enough to swap it
/// in: someone joined or left, or a name, role or user changed, or a PIN
/// changed. Set [bothLive] when both rosters are fresh Supabase reads, so a
/// PIN removed since counts too.
///
/// A cached tenant carries no PIN (only its verifier), so going from the
/// offline copy to the same people read live is not a change: swapping would
/// reload the lock screen and drop a PIN being typed, for nothing new.
bool staffRosterChanged(
  List<Tenant> previous,
  List<Tenant> next, {
  bool bothLive = false,
}) {
  if (previous.length != next.length) return true;
  final byId = {for (final t in previous) t.id: t};
  for (final t in next) {
    final old = byId[t.id];
    if (old == null ||
        old.userId != t.userId ||
        old.name != t.name ||
        old.type != t.type ||
        old.allowBusinessLogin != t.allowBusinessLogin ||
        ((bothLive || (old.pin != null && t.pin != null)) &&
            old.pin != t.pin)) {
      return true;
    }
  }
  return false;
}

/// One cached verifier checked against the PIN a re-read has for that tenant.
typedef _PinCheck = ({String salt, String hash, int iterations, String pin});

/// Up to this many KDF rounds in total are checked inline; more go to a
/// background isolate (a real roster costs one 10,000-round KDF per PIN).
const int _inlinePinCheckIterations = 1000;

bool _anyPinCheckFails(List<_PinCheck> checks) => checks.any(
  (c) => hashStaffPin(c.salt, c.pin, iterations: c.iterations) != c.hash,
);

/// Whether a tenant in [previous] restored from the offline copy still
/// unlocks with a PIN [next] no longer has for them: the verifier does not
/// match the PIN read live, the PIN was removed since, or a newer copy holds
/// another verifier. [staffRosterChanged] cannot see this, as a cached
/// tenant carries no PIN; without it, the old PIN kept unlocking the desk
/// after a live read.
///
/// A cached tenant with no verifier unlocks with nothing locally (the server
/// check covers a PIN set since), so it is no change.
Future<bool> staffRosterCachedPinsChanged(
  List<Tenant> previous,
  List<Tenant> next,
) async {
  final byId = {for (final t in previous) t.id: t};
  final checks = <_PinCheck>[];
  for (final t in next) {
    final old = byId[t.id];
    if (old == null || old.pin != null) continue;
    final was = _verifierOf[old];
    if (was == null) continue;
    final now = _verifierOf[t];
    final livePin = t.pin != null && t.pin != 0 ? t.pin.toString() : null;
    if (now != null) {
      if (now != was) return true;
    } else if (livePin == null) {
      return true;
    } else {
      checks.add((
        salt: was.salt,
        hash: was.hash,
        iterations: was.iterations,
        pin: livePin,
      ));
    }
  }
  if (checks.isEmpty) return false;
  final rounds = checks.fold<int>(0, (sum, c) => sum + c.iterations);
  return rounds <= _inlinePinCheckIterations
      ? _anyPinCheckFails(checks)
      : compute(_anyPinCheckFails, checks);
}

/// Restores a roster written by [encodeStaffRoster] and attaches its PIN
/// verifiers for [staffRosterPinMatches]. Returns `[]` for missing/corrupt data.
List<Tenant> decodeStaffRoster(String? raw) {
  if (raw == null || raw.isEmpty) return const [];
  try {
    final decoded = jsonDecode(raw);
    if (decoded is! Map || decoded['v'] != _staffRosterCacheVersion) {
      return const [];
    }
    final salt = decoded['salt'];
    final iterations = decoded['iterations'];
    final staff = decoded['staff'];
    if (salt is! String ||
        iterations is! int ||
        iterations < 1 ||
        iterations > _maxPinIterations ||
        staff is! List) {
      return const [];
    }

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
        _verifierOf[tenant] = (salt: salt, hash: hash, iterations: iterations);
      }
      out.add(tenant);
    }
    return out;
  } catch (_) {
    return const [];
  }
}

/// [raw] (a roster written by [encodeStaffRoster]) without [removed], matched
/// by row id or user id. Everyone else, PIN verifiers included, is kept as
/// stored. Null when [raw] is unreadable or does not list [removed].
String? removeFromStaffRoster(String? raw, Tenant removed) {
  if (raw == null || raw.isEmpty) return null;
  try {
    final decoded = jsonDecode(raw);
    if (decoded is! Map || decoded['v'] != _staffRosterCacheVersion) {
      return null;
    }
    final staff = decoded['staff'];
    if (staff is! List) return null;
    final userId = removed.userId?.trim();
    bool matches(Object? row) =>
        row is Map &&
        (row['id']?.toString() == removed.id ||
            (userId != null &&
                userId.isNotEmpty &&
                row['user_id']?.toString() == userId));
    final kept = staff.where((row) => !matches(row)).toList();
    if (kept.length == staff.length) return null;
    return jsonEncode({...decoded, 'staff': kept});
  } catch (_) {
    return null;
  }
}

/// Whether [tenant] was restored from the cache with a PIN on record.
bool staffRosterHasCachedPin(Tenant tenant) => _verifierOf[tenant] != null;

/// Checks [enteredPin] against the cached verifier for [tenant] (offline path).
bool staffRosterPinMatches(Tenant tenant, String enteredPin) {
  final v = _verifierOf[tenant];
  if (v == null) return false;
  final pin = _normalizePin(enteredPin);
  final last = _lastDerived;
  final String hash;
  if (last != null &&
      last.salt == v.salt &&
      last.iterations == v.iterations &&
      last.pin == pin) {
    hash = last.hash;
  } else {
    hash = hashStaffPin(v.salt, pin, iterations: v.iterations);
    _lastDerived = (
      salt: v.salt,
      iterations: v.iterations,
      pin: pin,
      hash: hash,
    );
  }
  return hash == v.hash;
}
