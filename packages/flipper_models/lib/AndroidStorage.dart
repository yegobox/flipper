import 'dart:io';
import 'package:path_provider/path_provider.dart';

class AndroidStorage {
  // App-specific internal storage
  Future<String> getInternalStoragePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // App-specific external storage
  Future<String> getExternalStoragePath() async {
    final directory = await getExternalStorageDirectory();
    return directory?.path ?? (await getApplicationDocumentsDirectory()).path;
  }

  // Cache directory
  Future<String> getCachePath() async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }

  Future<File> saveFile(
      String content, String fileName, StorageType type) async {
    String path;
    switch (type) {
      case StorageType.internal:
        path = await getInternalStoragePath();
        break;
      case StorageType.external:
        path = await getExternalStoragePath();
        break;
      case StorageType.cache:
        path = await getCachePath();
        break;
    }

    File file = File('$path/$fileName');
    return file.writeAsString(content);
  }
}

enum StorageType {
  internal,
  external,
  cache,
}
