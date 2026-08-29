import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:supabase_models/brick/repository/legacy_preferences_migration.dart';
import 'package:test/test.dart';

void main() {
  test('copies the highest-versioned legacy preferences file forward',
      () async {
    final directory =
        Directory.systemTemp.createTempSync('flipper_legacy_prefs_');
    try {
      await File(p.join(directory.path, 'flipper_preferences_v37.json'))
          .writeAsString('{"old":true}');
      await File(p.join(directory.path, 'flipper_preferences_v45.json'))
          .writeAsString('{"userId":"123"}');

      await migrateLegacyPreferencesFileIfNeeded(
        directory: directory.path,
        baseName: 'flipper_preferences',
        targetFileName: 'flipper_preferences.json',
      );

      final targetPath = p.join(directory.path, 'flipper_preferences.json');
      expect(File(targetPath).existsSync(), isTrue);
      expect(
        await File(targetPath).readAsString(),
        '{"userId":"123"}',
      );
    } finally {
      directory.deleteSync(recursive: true);
    }
  });

  test('skips migration when the target file already holds a session', () async {
    final directory =
        Directory.systemTemp.createTempSync('flipper_legacy_prefs_');
    try {
      final targetPath = p.join(directory.path, 'flipper_preferences.json');
      await File(targetPath).writeAsString('{"userId":"current"}');
      await File(p.join(directory.path, 'flipper_preferences_v45.json'))
          .writeAsString('{"userId":"123"}');

      await migrateLegacyPreferencesFileIfNeeded(
        directory: directory.path,
        baseName: 'flipper_preferences',
        targetFileName: 'flipper_preferences.json',
      );

      expect(await File(targetPath).readAsString(), '{"userId":"current"}');
    } finally {
      directory.deleteSync(recursive: true);
    }
  });

  test('gap-fills a target damaged by a bad write', () async {
    // The case this migration exists for: prefs went missing without a logout,
    // so the legacy snapshot is allowed to hand the session back.
    final directory =
        Directory.systemTemp.createTempSync('flipper_legacy_prefs_');
    try {
      final targetPath = p.join(directory.path, 'flipper_preferences.json');
      await File(targetPath).writeAsString('{"mfa_totp_secret_123":"secret"}');
      await File(p.join(directory.path, 'flipper_preferences_v45.json'))
          .writeAsString('{"userId":"123","encryptionKey":"key-1"}');

      await migrateLegacyPreferencesFileIfNeeded(
        directory: directory.path,
        baseName: 'flipper_preferences',
        targetFileName: 'flipper_preferences.json',
      );

      final result = jsonDecode(await File(targetPath).readAsString())
          as Map<String, dynamic>;
      expect(result['userId'], '123');
      expect(result['encryptionKey'], 'key-1');
      expect(result['mfa_totp_secret_123'], 'secret');
    } finally {
      directory.deleteSync(recursive: true);
    }
  });

  test('a logged-out target is not "repaired" back into a session', () async {
    // clearSessionKeys() removes exactly userId/businessId/bearerToken, which
    // used to be this migration's proof of health — so every launch after a
    // logout merged the previous session back in from the leftover _v<N> file.
    final directory =
        Directory.systemTemp.createTempSync('flipper_legacy_prefs_');
    try {
      final targetPath = p.join(directory.path, 'flipper_preferences.json');
      await File(targetPath).writeAsString(jsonEncode({
        'sessionClearedAt': 2000,
        'encryptionKey': 'key-1',
        'thisDeviceId': 'device-1',
      }));
      await File(p.join(directory.path, 'flipper_preferences_v45.json'))
          .writeAsString(jsonEncode({
        'userId': '123',
        'userIdString': '123',
        'businessId': 'biz-1',
        'branchId': 'branch-1',
        'bearerToken': 'token-1',
        'authComplete': true,
        'encryptionKey': 'key-1',
      }));

      await migrateLegacyPreferencesFileIfNeeded(
        directory: directory.path,
        baseName: 'flipper_preferences',
        targetFileName: 'flipper_preferences.json',
        siblingFileNames: const [
          'flipper_preferences.json',
          'flipper_preferences_backup.json',
        ],
      );

      final result =
          jsonDecode(await File(targetPath).readAsString()) as Map<String, dynamic>;
      expect(result['userId'], isNull);
      expect(result['userIdString'], isNull);
      expect(result['businessId'], isNull);
      expect(result['branchId'], isNull);
      expect(result['bearerToken'], isNull);
      expect(result['authComplete'], isNull);
      expect(result['encryptionKey'], 'key-1');
    } finally {
      directory.deleteSync(recursive: true);
    }
  });

  test('honours a logout recorded only in the sibling backup file', () async {
    final directory =
        Directory.systemTemp.createTempSync('flipper_legacy_prefs_');
    try {
      final targetPath = p.join(directory.path, 'flipper_preferences.json');
      await File(p.join(directory.path, 'flipper_preferences_backup.json'))
          .writeAsString(jsonEncode({'sessionClearedAt': 2000}));
      await File(p.join(directory.path, 'flipper_preferences_v45.json'))
          .writeAsString(jsonEncode({
        'userId': '123',
        'encryptionKey': 'key-1',
      }));

      await migrateLegacyPreferencesFileIfNeeded(
        directory: directory.path,
        baseName: 'flipper_preferences',
        targetFileName: 'flipper_preferences.json',
        siblingFileNames: const [
          'flipper_preferences.json',
          'flipper_preferences_backup.json',
        ],
      );

      final result =
          jsonDecode(await File(targetPath).readAsString()) as Map<String, dynamic>;
      expect(result['userId'], isNull);
      expect(result['encryptionKey'], 'key-1');
    } finally {
      directory.deleteSync(recursive: true);
    }
  });

  test('still restores the session when the legacy file is newer than the '
      'last logout', () async {
    // Logged out, then signed in again, then the dbVersion bump wiped prefs.
    final directory =
        Directory.systemTemp.createTempSync('flipper_legacy_prefs_');
    try {
      final targetPath = p.join(directory.path, 'flipper_preferences.json');
      await File(targetPath).writeAsString(jsonEncode({
        'sessionClearedAt': 1000,
        'mfa_totp_secret_123': 'secret',
      }));
      await File(p.join(directory.path, 'flipper_preferences_v45.json'))
          .writeAsString(jsonEncode({
        'sessionClearedAt': 1000,
        'userId': '123',
        'businessId': 'biz-1',
      }));

      await migrateLegacyPreferencesFileIfNeeded(
        directory: directory.path,
        baseName: 'flipper_preferences',
        targetFileName: 'flipper_preferences.json',
        siblingFileNames: const ['flipper_preferences.json'],
      );

      final result =
          jsonDecode(await File(targetPath).readAsString()) as Map<String, dynamic>;
      expect(result['userId'], '123');
      expect(result['businessId'], 'biz-1');
      expect(result['mfa_totp_secret_123'], 'secret');
    } finally {
      directory.deleteSync(recursive: true);
    }
  });

  test('is a no-op when no legacy file exists', () async {
    final directory =
        Directory.systemTemp.createTempSync('flipper_legacy_prefs_');
    try {
      await migrateLegacyPreferencesFileIfNeeded(
        directory: directory.path,
        baseName: 'flipper_preferences',
        targetFileName: 'flipper_preferences.json',
      );

      final targetPath = p.join(directory.path, 'flipper_preferences.json');
      expect(File(targetPath).existsSync(), isFalse);
    } finally {
      directory.deleteSync(recursive: true);
    }
  });
}
