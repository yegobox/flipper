// ignore: file_names
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart'
    if (dart.library.io) 'package:path_provider/path_provider.dart'; // Conditional import

mixin DatabasePath {
  static Future<String> getDatabaseDirectory() async {
    if (isTestEnvironment()) {
      final testDir = Directory('.db');
      if (!await testDir.exists()) {
        await testDir.create(recursive: true);
      }
      return '.db';
    }

    Directory appDir;
    try {
      // This is the preferred, more persistent location.
      appDir = await getApplicationDocumentsDirectory();
    } catch (e) {
      // Fallback for Windows configurations where Documents directory is not available.
      appDir = await getApplicationDocumentsDirectory();
    }

    final dbPath = join(appDir.path, 'Flipper');

    // Ensure the directory exists, mimicking the successful pattern from local_storage.dart
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
