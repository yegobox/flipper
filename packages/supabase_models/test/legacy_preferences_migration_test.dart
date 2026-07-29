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

  test('skips migration when the target file already has data', () async {
    final directory =
        Directory.systemTemp.createTempSync('flipper_legacy_prefs_');
    try {
      final targetPath = p.join(directory.path, 'flipper_preferences.json');
      await File(targetPath).writeAsString('{"current":true}');
      await File(p.join(directory.path, 'flipper_preferences_v45.json'))
          .writeAsString('{"userId":"123"}');

      await migrateLegacyPreferencesFileIfNeeded(
        directory: directory.path,
        baseName: 'flipper_preferences',
        targetFileName: 'flipper_preferences.json',
      );

      expect(await File(targetPath).readAsString(), '{"current":true}');
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
