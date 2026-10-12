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
  final raw = await file.readAsString();
  if (raw.trim().isEmpty) return const {};
  try {
    return Map<String, dynamic>.from(jsonDecode(raw) as Map);
  } catch (_) {
    // A damaged marker still means the user chose local mode; never fall back
    // to cloud sync (and its paywall) because of a bad write.
    return const {};
  }
}

Future<void> writeLocalModeMarker(Map<String, dynamic> data) async {
  final file = await _markerFile();
  await file.writeAsString(jsonEncode(data), flush: true);
}

Future<void> deleteLocalModeMarker() async {
  final file = await _markerFile();
  if (await file.exists()) await file.delete();
}
