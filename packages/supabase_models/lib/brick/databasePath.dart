// ignore: file_names
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common/sqflite.dart';

mixin DatabasePath {
  static Future<String>  getDatabaseDirectory() async {
    if (Platform.isWindows) {
      final appDir = await getApplicationDocumentsDirectory();
      return join(appDir.path, '_db');
    } else if (Platform.isAndroid) {
      return await getDatabasesPath();
    } else if (Platform.isIOS || Platform.isMacOS) {
      final documents = await getApplicationDocumentsDirectory();
      return documents.path;
    } else {
      // For other platforms, use application documents directory
      final appDir = await getApplicationDocumentsDirectory();
      return join(appDir.path, '_db');
    }
  }
}
