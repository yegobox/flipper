// ignore: file_names
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite_common/sqflite.dart';
import 'package:path_provider/path_provider.dart'
    if (dart.library.io) 'package:path_provider/path_provider.dart'; // Conditional import

mixin DatabasePath {
  static Future<String> getDatabaseDirectory() async {
    if (isTestEnvironment()) {
      return '.';
    }

    if (Platform.isWindows) {
      final appDir = await getApplicationDocumentsDirectory();
      return join(appDir.path, '_db');
    } else if (Platform.isAndroid) {
      return await getDatabasesPath();
    } else if (Platform.isIOS || Platform.isMacOS) {
      final documents = await getApplicationDocumentsDirectory();
      // print the path
      print('Database path: ${documents.path}');
      return documents.path;
    } else {
      // For other platforms, use application documents directory
      final appDir = await getApplicationDocumentsDirectory();
      return join(appDir.path, '_db');
    }
  }

  static bool isTestEnvironment() {
    return const bool.fromEnvironment('FLUTTER_TEST_ENV') == true;
  }
}
