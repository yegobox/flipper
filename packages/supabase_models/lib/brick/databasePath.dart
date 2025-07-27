// ignore: file_names
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart'
    if (dart.library.io) 'package:path_provider/path_provider.dart'; // Conditional import
import 'package:sqflite_common/sqflite.dart';

mixin DatabasePath {
  static Future<String> getDatabaseDirectory() async {
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
    } else {
      // iOS, macOS, Windows, Linux
      final supportDir = await getApplicationSupportDirectory();
      dbPath = join(supportDir.path, 'Flipper');
    }

    final dbDir = Directory(dbPath);
    if (!await dbDir.exists()) {
      await dbDir.create(recursive: true);
    }

    return dbDir.path;
  }

  static bool isTestEnvironment() {
    return const bool.fromEnvironment('FLUTTER_TEST_ENV') == true;
  }
}
