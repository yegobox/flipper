import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;

/// Copies / merges the most recent pre-rename `<baseName>_v<N>.json` file into
/// [targetFileName] when the stable target is missing, empty, or incomplete.
///
/// The preferences (and preferences-backup) files used to be named with the
/// shared `dbVersion` embedded in the filename. Every unrelated `dbVersion`
/// bump therefore pointed [SharedPreferenceStorage] at a fresh, empty path and
/// silently dropped all local preferences — including session/auth state
/// (`userId`, `bearerToken`, `encryptionKey`, etc.). Mirrors the fix already
/// applied to the main database in `migrateLegacyMainDatabaseIfNeeded`.
///
/// Incomplete targets (e.g. a file that only contains MFA keys after a bad
/// write) are merged with the richest legacy file so session keys return.
Future<void> migrateLegacyPreferencesFileIfNeeded({
  required String directory,
  required String baseName,
  required String targetFileName,
}) async {
  final logger = Logger('LegacyPreferencesMigration');
  final targetPath = p.join(directory, targetFileName);
  final targetFile = File(targetPath);

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

  Map<String, dynamic> readJson(File file) {
    try {
      final decoded = jsonDecode(file.readAsStringSync());
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) {
        return decoded.map((k, v) => MapEntry(k.toString(), v));
      }
    } catch (_) {}
    return <String, dynamic>{};
  }

  final targetExists = targetFile.existsSync() && targetFile.lengthSync() > 0;
  final targetMap = targetExists ? readJson(targetFile) : <String, dynamic>{};
  final targetLooksHealthy = targetMap.containsKey('userId') ||
      targetMap.containsKey('businessId') ||
      targetMap.containsKey('bearerToken');

  if (targetLooksHealthy) {
    return;
  }

  if (bestFile == null) {
    return;
  }

  final legacyMap = readJson(bestFile);
  if (legacyMap.isEmpty && targetMap.isEmpty) return;

  // Legacy fills session keys; target wins on overlap (e.g. MFA keys).
  final merged = <String, dynamic>{...legacyMap, ...targetMap};
  logger.warning(
    'Repairing preferences $targetFileName from legacy '
    '${p.basename(bestFile.path)} (targetHealthy=$targetLooksHealthy, '
    'legacyKeys=${legacyMap.length}, targetKeys=${targetMap.length}, '
    'mergedKeys=${merged.length})',
  );
  await targetFile.writeAsString(jsonEncode(merged), flush: true);
}
