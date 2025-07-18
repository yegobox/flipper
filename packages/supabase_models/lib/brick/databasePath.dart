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
      return '.db';
    }

    String dbPath;
    if (Platform.isAndroid) {
      // Use the dedicated databases directory on Android
      dbPath = await getDatabasesPath();
    } else {
      // For all desktop platforms (Windows, macOS, Linux) and iOS
      final appDir = await getApplicationDocumentsDirectory();
      dbPath = join(appDir.path, 'Flipper');
    }

    // Ensure the directory exists
    final dbDir = Directory(dbPath);
    if (!await dbDir.exists()) {
      await dbDir.create(recursive: true);
    }

    return dbPath;
  }

  static bool isTestEnvironment() {
    return const bool.fromEnvironment('FLUTTER_TEST_ENV') == true;
  }
}
