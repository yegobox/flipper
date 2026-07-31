import 'dart:convert';
import 'dart:io';

import 'package:supabase_models/brick/databasePath.dart';

/// Device-local TOTP secrets for offline authenticator login.
///
/// Stored in a dedicated JSON file (not SharedPreferenceStorage) so:
/// - keys are not blocked by the prefs allowlist
/// - MFA writes cannot wipe the main preferences file
/// - secrets survive across preference migrations
abstract final class LocalMfaSecretCache {
  static const _fileName = 'mfa_totp_secrets.json';

  static Map<String, String>? _memory;

  static String keyForUserId(String userId) => 'user:$userId';

  static String keyForPin(int pin) => 'pin:$pin';

  static Future<File> _file() async {
    final directory = await DatabasePath.getDatabaseDirectory();
    await Directory(directory).create(recursive: true);
    return File('$directory/$_fileName');
  }

  static Future<Map<String, String>> _load() async {
    if (_memory != null) return _memory!;
    try {
      final file = await _file();
      if (await file.exists()) {
        final decoded = jsonDecode(await file.readAsString());
        if (decoded is Map) {
          _memory = decoded.map(
            (key, value) => MapEntry(key.toString(), value.toString()),
          );
        } else {
          _memory = <String, String>{};
        }
      } else {
        _memory = <String, String>{};
      }
    } catch (_) {
      _memory = <String, String>{};
    }

    if (_memory!.isEmpty) {
      await _importLegacyPreferenceKeys();
    }
    return _memory!;
  }

  /// One-time import from SharedPreferenceStorage keys written before the
  /// dedicated MFA secrets file existed.
  static Future<void> _importLegacyPreferenceKeys() async {
    try {
      final directory = await DatabasePath.getDatabaseDirectory();
      final prefsFile = File('$directory/flipper_preferences.json');
      if (!await prefsFile.exists()) return;
      final decoded = jsonDecode(await prefsFile.readAsString());
      if (decoded is! Map) return;
      await migrateFromPrefsMap(
        decoded.map((k, v) => MapEntry(k.toString(), v)),
      );
    } catch (_) {}
  }

  static Future<void> _persist() async {
    final data = _memory;
    if (data == null) return;
    final file = await _file();
    await file.writeAsString(jsonEncode(data), flush: true);
  }

  static Future<void> save({
    required String userId,
    required String secret,
    int? pin,
  }) async {
    final id = userId.trim();
    final cleaned = secret.trim();
    if (id.isEmpty || cleaned.isEmpty) return;
    final map = await _load();
    map[keyForUserId(id)] = cleaned;
    if (pin != null && pin > 0) {
      map[keyForPin(pin)] = cleaned;
    }
    await _persist();
  }

  static Future<String?> read(String userId, {int? pin}) async {
    final map = await _load();
    final id = userId.trim();
    if (id.isNotEmpty) {
      final byUser = map[keyForUserId(id)];
      if (byUser != null && byUser.trim().isNotEmpty) {
        return byUser.trim();
      }
    }
    if (pin != null && pin > 0) {
      final byPin = map[keyForPin(pin)];
      if (byPin != null && byPin.trim().isNotEmpty) {
        return byPin.trim();
      }
    }
    return null;
  }

  static Future<void> clear(String userId, {int? pin}) async {
    final map = await _load();
    final id = userId.trim();
    if (id.isNotEmpty) {
      map.remove(keyForUserId(id));
    }
    if (pin != null && pin > 0) {
      map.remove(keyForPin(pin));
    }
    await _persist();
  }

  /// Import secrets previously written into SharedPreferenceStorage allowlist
  /// keys (`mfa_totp_secret_*`) into this dedicated file.
  static Future<void> migrateFromPrefsMap(Map<String, dynamic> prefs) async {
    final map = await _load();
    var changed = false;
    for (final entry in prefs.entries) {
      final key = entry.key;
      final value = entry.value;
      if (value is! String || value.trim().isEmpty) continue;
      if (key.startsWith('mfa_totp_secret_pin_')) {
        final pin = int.tryParse(key.substring('mfa_totp_secret_pin_'.length));
        if (pin != null && pin > 0) {
          map[keyForPin(pin)] = value.trim();
          changed = true;
        }
      } else if (key.startsWith('mfa_totp_secret_')) {
        final userId = key.substring('mfa_totp_secret_'.length);
        if (userId.isNotEmpty && !userId.startsWith('pin_')) {
          map[keyForUserId(userId)] = value.trim();
          changed = true;
        }
      }
    }
    if (changed) await _persist();
  }
}
