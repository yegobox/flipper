import 'dart:convert';
import 'dart:io';

import 'package:flipper_web/core/utils/database_path.dart';
import 'package:path/path.dart' as p;

const _kMarkerFile = '.flipper_local_mode';

/// Same directory [DittoSingleton] opens for the session store.
Future<File> _markerFile() async {
  final dir = await DatabasePath.getDatabaseDirectory(subDirectory: 'db2');
  return File(p.join(dir, _kMarkerFile));
}

Future<Map<String, dynamic>?> readLocalModeMarker() async {
  final file = await _markerFile();
  if (!await file.exists()) return null;
  // A marker that exists but can't be read or parsed still means the user
  // chose local mode; never fall back to cloud sync (and its paywall) because
  // of a bad write or a locked file.
  try {
    final raw = await file.readAsString();
    if (raw.trim().isEmpty) return const {};
    return Map<String, dynamic>.from(jsonDecode(raw) as Map);
  } catch (_) {
    return const {};
  }
}

/// Writes through a temporary file and renames it over the marker, so an
/// interrupted write never leaves a truncated marker that has lost its
/// `businessId`.
Future<void> writeLocalModeMarker(Map<String, dynamic> data) async {
  final file = await _markerFile();
  final tmp = File('${file.path}.tmp');
  await tmp.writeAsString(jsonEncode(data), flush: true);
  await tmp.rename(file.path);
}

Future<void> deleteLocalModeMarker() async {
  final file = await _markerFile();
  if (await file.exists()) await file.delete();
}
