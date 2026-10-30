import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flipper_web/core/utils/database_path.dart';
import 'package:path/path.dart' as p;

import 'local_mode_marker_keys.dart';

const _kMarkerFile = '.flipper_local_mode';
const _kInstallIdFile = '.flipper_install_id';

/// Same directory [DittoSingleton] opens for the session store.
Future<File> _markerFile() => _storeFile(_kMarkerFile);

Future<File> _storeFile(String name) async {
  final dir = await DatabasePath.getDatabaseDirectory(subDirectory: 'db2');
  return File(p.join(dir, name));
}

Future<Map<String, dynamic>?> readLocalModeMarker() async {
  final file = await _markerFile();
  if (!await file.exists()) return null;
  // A marker that exists but can't be read or parsed still means the user
  // chose local mode; never fall back to cloud sync (and its paywall) because
  // of a bad write or a locked file. Its owner is unknown, which is not the
  // same as unowned: say so rather than return a marker without a business.
  try {
    final raw = await file.readAsString();
    if (raw.trim().isEmpty) return _unreadable;
    return Map<String, dynamic>.from(jsonDecode(raw) as Map);
  } catch (_) {
    return _unreadable;
  }
}

const _unreadable = {kLocalModeMarkerUnreadable: true};

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

/// This store's random id, made on first use. It lives in its own file so a
/// corrupt marker can't take it along: it is what names the store's owner
/// when the marker can't (hostnames repeat; every Android phone is
/// "localhost").
Future<String> readOrCreateLocalModeInstallId() async {
  final file = await _storeFile(_kInstallIdFile);
  if (await file.exists()) {
    final id = (await file.readAsString()).trim();
    if (id.isNotEmpty) return id;
  }
  final random = Random.secure();
  final id = List.generate(
    16,
    (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
  ).join();
  final tmp = File('${file.path}.tmp');
  await tmp.writeAsString(id, flush: true);
  await tmp.rename(file.path);
  return id;
}
