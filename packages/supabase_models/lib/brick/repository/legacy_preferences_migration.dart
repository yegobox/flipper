import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_models/brick/repository/session_prefs_keys.dart';

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
///
/// **A logout is not an incomplete target.** `clearSessionKeys()` removes
/// exactly the keys this migration used to treat as proof of health (`userId`,
/// `businessId`, `bearerToken`), so on the next launch every signed-out device
/// that still had a legacy `_v<N>.json` lying around got its previous session
/// merged straight back in — and because nothing consumes the legacy file, it
/// happened again on every launch, forever. [kSessionClearedAtKey] is the tell:
/// when a clear was recorded *after* the legacy snapshot, the legacy file may
/// still repair device-level prefs but must not carry [kSessionPrefKeys].
///
/// [siblingFileNames] are the other stable preference files in [directory]
/// (main <-> backup). They are consulted for [kSessionClearedAtKey] so a logout
/// is still honoured when the target file itself was lost.
Future<void> migrateLegacyPreferencesFileIfNeeded({
  required String directory,
  required String baseName,
  required String targetFileName,
  List<String> siblingFileNames = const [],
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

  final targetExists = targetFile.existsSync() && targetFile.lengthSync() > 0;
  final targetMap = targetExists ? _readJson(targetFile) : <String, dynamic>{};
  final targetLooksHealthy = targetMap.containsKey('userId') ||
      targetMap.containsKey('businessId') ||
      targetMap.containsKey('bearerToken');

  if (targetLooksHealthy) {
    return;
  }

  if (bestFile == null) {
    return;
  }

  final legacyMap = _readJson(bestFile);
  if (legacyMap.isEmpty && targetMap.isEmpty) return;

  // A logout recorded after the legacy snapshot outranks it: the missing
  // session keys are the point, not damage to repair.
  final clearedAt = _latestSessionClearedAt(
    directory: directory,
    targetMap: targetMap,
    siblingFileNames: siblingFileNames,
    targetFileName: targetFileName,
  );
  final sessionClearedAfterLegacy = clearedAt > _sessionClearedAt(legacyMap);

  final donor = sessionClearedAfterLegacy
      ? (Map<String, dynamic>.from(legacyMap)
        ..removeWhere((key, _) => kSessionPrefKeys.contains(key)))
      : legacyMap;

  // Nothing the target is missing — leave the file (and its mtime) alone.
  if (!donor.keys.any((key) => !targetMap.containsKey(key))) {
    if (sessionClearedAfterLegacy) {
      logger.info(
        'Skipping preferences repair of $targetFileName from '
        '${p.basename(bestFile.path)}: session was cleared at $clearedAt',
      );
    }
    return;
  }

  // Legacy fills the gaps; target wins on overlap (e.g. MFA keys).
  final merged = <String, dynamic>{...donor, ...targetMap};
  logger.warning(
    'Repairing preferences $targetFileName from legacy '
    '${p.basename(bestFile.path)} (targetHealthy=$targetLooksHealthy, '
    'sessionClearedAfterLegacy=$sessionClearedAfterLegacy, '
    'legacyKeys=${legacyMap.length}, targetKeys=${targetMap.length}, '
    'mergedKeys=${merged.length})',
  );
  await targetFile.writeAsString(jsonEncode(merged), flush: true);
}

Map<String, dynamic> _readJson(File file) {
  try {
    final decoded = jsonDecode(file.readAsStringSync());
    if (decoded is Map<String, dynamic>) return decoded;
    if (decoded is Map) {
      return decoded.map((k, v) => MapEntry(k.toString(), v));
    }
  } catch (_) {}
  return <String, dynamic>{};
}

int _sessionClearedAt(Map<String, dynamic> map) {
  final raw = map[kSessionClearedAtKey];
  if (raw is num) return raw.toInt();
  if (raw is String) return int.tryParse(raw) ?? 0;
  return 0;
}

/// Newest logout timestamp across the target and its sibling stable files.
///
/// The main file and its backup are written together, but a logout that only
/// survived in one of them must still win — otherwise repairing the other one
/// hands the session back.
int _latestSessionClearedAt({
  required String directory,
  required Map<String, dynamic> targetMap,
  required List<String> siblingFileNames,
  required String targetFileName,
}) {
  var newest = _sessionClearedAt(targetMap);
  for (final name in siblingFileNames) {
    if (name == targetFileName) continue;
    final file = File(p.join(directory, name));
    if (!file.existsSync() || file.lengthSync() == 0) continue;
    final value = _sessionClearedAt(_readJson(file));
    if (value > newest) newest = value;
  }
  return newest;
}
