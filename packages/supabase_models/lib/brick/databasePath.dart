// ignore: file_names
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart'
    if (dart.library.io) 'package:path_provider/path_provider.dart'; // Conditional import

mixin DatabasePath {
  static Future<String> getDatabaseDirectory() async {
    if (isTestEnvironment()) {
      return '.db';
    }
    final appDir = await getApplicationDocumentsDirectory();
    return join(appDir.path, kDebugMode ? 'db' : '.db');
  }

  static bool isTestEnvironment() {
    return const bool.fromEnvironment('FLUTTER_TEST_ENV') == true;
  }
}
