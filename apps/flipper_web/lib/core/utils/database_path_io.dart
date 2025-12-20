import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common/sqflite.dart';

mixin DatabasePath {
  static Future<String> getDatabaseDirectory({String? subDirectory}) async {
    if (isTestEnvironment()) {
      final testDir = Directory('.db');
      if (!await testDir.exists()) {
        await testDir.create(recursive: true);
      }
      return testDir.path;
    }

    String dbPath;

    if (Platform.isAndroid) {
      dbPath = await getDatabasesPath();
    } else if (Platform.isWindows) {
      // Windows: Use AppData/Local/rw.flipper for database storage
      final supportDir = await getApplicationSupportDirectory();
      dbPath = join(supportDir.path, 'rw.flipper', subDirectory ?? '');
    } else if (Platform.isMacOS || Platform.isIOS) {
      // macOS/iOS: Use Application Documents directory directly (no subdirectory)
      final supportDir = await getApplicationDocumentsDirectory();
      dbPath = join(supportDir.path, subDirectory ?? '');
    } else {
      // Linux and others: Use Application Documents with rw.flipper subdirectory
      final supportDir = await getApplicationDocumentsDirectory();
      dbPath = join(supportDir.path, 'rw.flipper', subDirectory ?? '');
    }

    debugPrint('Database path: $dbPath');
    final dbDir = Directory(dbPath);
    if (!await dbDir.exists()) {
      await dbDir.create(recursive: true);
    }

    // 👇 Hide DB folder on Windows
    if (Platform.isWindows) {
      await _hideWindowsFolder(dbDir);
    }

    return dbDir.path;
  }

  static bool isTestEnvironment() {
    return const bool.fromEnvironment('FLUTTER_TEST_ENV') == true;
  }

  /// Helper to hide the DB folder on Windows
  static Future<void> _hideWindowsFolder(Directory dbDir) async {
    try {
      final result = await Process.run('attrib', ['+h', '+s', dbDir.path]);
      if (result.exitCode == 0) {
        debugPrint(
          '✅ DB folder is now hidden (Windows attrib +h +s succeeded).',
        );
      } else {
        debugPrint('⚠️ Failed to hide DB folder: ${result.stderr}');
      }
    } catch (e) {
      debugPrint('⚠️ Error running attrib to hide DB folder: $e');
    }
  }
}
