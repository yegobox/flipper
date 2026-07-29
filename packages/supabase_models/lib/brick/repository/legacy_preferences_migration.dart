import 'dart:io';

import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;

/// Copies the most recent pre-rename `<baseName>_v<N>.json` file into
/// [targetFileName], if [targetFileName] does not already exist with data.
///
/// The preferences (and preferences-backup) files used to be named with the
/// shared `dbVersion` embedded in the filename. Every unrelated `dbVersion`
/// bump therefore pointed [SharedPreferenceStorage] at a fresh, empty path and
/// silently dropped all local preferences — including session/auth state
/// (`userId`, `bearerToken`, `encryptionKey`, etc.). Mirrors the fix already
/// applied to the main database in `migrateLegacyMainDatabaseIfNeeded`.
Future<void> migrateLegacyPreferencesFileIfNeeded({
  required String directory,
  required String baseName,
  required String targetFileName,
}) async {
  final logger = Logger('LegacyPreferencesMigration');
  final targetPath = p.join(directory, targetFileName);
  final targetFile = File(targetPath);

  if (targetFile.existsSync() && targetFile.lengthSync() > 0) {
    return;
  }

  final dir = Directory(directory);
  if (!dir.existsSync()) return;

  final pattern = RegExp('^${RegExp.escape(baseName)}_v(\\d+)\\.json\$');
  int? bestVersion;
  File? bestFile;

  for (final entity in dir.listSync()) {
    if (entity is! File) continue;
    final match = pattern.firstMatch(p.basename(entity.path));
    if (match == null) continue;
    if (entity.lengthSync() == 0) continue;

    final version = int.tryParse(match.group(1)!);
    if (version == null) continue;
    if (bestVersion == null || version > bestVersion) {
      bestVersion = version;
      bestFile = entity;
    }
  }

  if (bestFile == null) return;

  logger.warning(
    'Migrating legacy preferences file ${p.basename(bestFile.path)} -> $targetFileName',
  );
  if (targetFile.existsSync()) {
    await targetFile.delete();
  }
  await bestFile.copy(targetPath);
}
