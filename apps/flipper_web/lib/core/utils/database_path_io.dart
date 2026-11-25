import 'dart:io';
import 'package:flutter/foundation.dart' hide Category;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common/sqflite.dart';

mixin DatabasePath {
  /// Tests set this to take the Android branch on any host, even under
  /// FLUTTER_TEST_ENV, with it standing in for sqflite's databases path.
  @visibleForTesting
  static Future<String> Function()? debugAndroidDatabasesPath;

  static Future<String> getDatabaseDirectory({String? subDirectory}) async {
    final androidRoot = debugAndroidDatabasesPath;
    if (isTestEnvironment() && androidRoot == null) {
      final testDir = Directory('.db');
      if (!await testDir.exists()) {
        await testDir.create(recursive: true);
      }
      return testDir.path;
    }

    String dbPath;

    if (Platform.isAndroid || androidRoot != null) {
      dbPath = androidDirectory(
        await (androidRoot ?? getDatabasesPath)(),
        subDirectory,
      );
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

  /// Android stores have always lived in the databases root, so the main
  /// store (`db2`) stays there and existing installs keep their data. Every
  /// other store gets its own subdirectory: two Ditto stores in one
  /// directory lock each other out.
  @visibleForTesting
  static String androidDirectory(String root, String? subDirectory) {
    if (subDirectory == null || subDirectory == 'db2') return root;
    return join(root, subDirectory);
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
