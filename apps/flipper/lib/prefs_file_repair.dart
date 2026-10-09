import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// File the Windows and Linux shared_preferences plugins keep their map in,
/// inside the application support directory.
const sharedPreferencesFileName = 'shared_preferences.json';

/// Test hook: forces the platform check without running on Windows/Linux.
@visibleForTesting
bool? debugPrefsFileRepairPlatformOverride;

/// Moves aside a `shared_preferences.json` that no longer decodes as JSON.
///
/// On Windows and Linux the plugin `json.decode`s that file with no
/// try/catch, so a till that lost power mid-write (Windows leaves the file
/// full of NUL bytes) makes every `SharedPreferences.getInstance()` throw
/// `FormatException: Unexpected character (at character 1)` — Books then
/// stops at "Could not restore business context". Renaming the file lets the
/// plugin start from an empty map; the keys in it are caches that rebuild
/// from the user profile. Must run before anything opens SharedPreferences.
///
/// Never throws.
Future<void> repairCorruptSharedPreferencesFile({Directory? supportDir}) async {
  final applies = debugPrefsFileRepairPlatformOverride ??
      (!kIsWeb && (Platform.isWindows || Platform.isLinux));
  if (!applies) return;

  try {
    final dir = supportDir ?? await getApplicationSupportDirectory();
    final file = File(
      '${dir.path}${Platform.pathSeparator}'
      '$sharedPreferencesFileName',
    );
    if (!file.existsSync()) return;

    // allowMalformed: bytes that are not UTF-8 also break the plugin's
    // readAsStringSync, so they must land in the move below, not the catch.
    final contents = utf8.decode(file.readAsBytesSync(), allowMalformed: true);
    if (contents.isEmpty) return;
    try {
      if (json.decode(contents) is Map) return;
    } on FormatException {
      // Falls through to the move below.
    }

    final backup =
        '${file.path}.corrupt-${DateTime.now().millisecondsSinceEpoch}';
    file.renameSync(backup);
    debugPrint('[prefs] moved corrupt $sharedPreferencesFileName to $backup');
  } catch (e) {
    debugPrint('[prefs] could not check $sharedPreferencesFileName: $e');
  }
}
