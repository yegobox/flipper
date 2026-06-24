import 'dart:io';

import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;

/// Last main-DB filename version before `flipper.sqlite` (no suffix).
/// Keep aligned with `dbVersion` in `flipper_services/constants.dart`.
const _legacyMainDbSchemaVersion = 45;

/// Copies a pre-rename main Brick database into the current [targetFileName].
///
/// Upgrades from `flipper_v45.sqlite` (sqflite/Turso) to `flipper.sqlite` left
/// the old file on disk but pointed new builds at an empty path, which triggers
/// Turso Cloud `bootstrapIfEmpty` and can hang or fail startup on Windows.
Future<void> migrateLegacyMainDatabaseIfNeeded({
  required String directory,
  required String targetFileName,
}) async {
  final logger = Logger('LegacyDatabaseMigration');
  final targetPath = p.join(directory, targetFileName);
  final targetFile = File(targetPath);

  if (targetFile.existsSync() && targetFile.lengthSync() > 0) {
    return;
  }

  final legacyNames = <String>{
    'flipper_v$_legacyMainDbSchemaVersion.sqlite',
    for (var version = _legacyMainDbSchemaVersion - 1; version >= 40; version--)
      'flipper_v$version.sqlite',
  };

  for (final legacyName in legacyNames) {
    final legacyPath = p.join(directory, legacyName);
    final legacyFile = File(legacyPath);
    if (!legacyFile.existsSync() || legacyFile.lengthSync() == 0) {
      continue;
    }

    logger.warning(
      'Migrating legacy main database $legacyName -> $targetFileName',
    );
    if (targetFile.existsSync()) {
      await targetFile.delete();
    }
    await legacyFile.copy(targetPath);
    return;
  }
}
