import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:supabase_models/brick/repository/legacy_database_migration.dart';
import 'package:test/test.dart';

void main() {
  test('copies flipper_v45.sqlite when flipper.sqlite is missing', () async {
    final directory = Directory.systemTemp.createTempSync('flipper_legacy_db_');
  try {
    final legacyPath = p.join(directory.path, 'flipper_v45.sqlite');
    await File(legacyPath).writeAsBytes([1, 2, 3]);

    await migrateLegacyMainDatabaseIfNeeded(
      directory: directory.path,
      targetFileName: 'flipper.sqlite',
    );

    final targetPath = p.join(directory.path, 'flipper.sqlite');
    expect(File(targetPath).existsSync(), isTrue);
    expect(File(targetPath).lengthSync(), 3);
    expect(File(legacyPath).existsSync(), isTrue);
  } finally {
    directory.deleteSync(recursive: true);
  }
  });

  test('skips migration when flipper.sqlite already has data', () async {
    final directory = Directory.systemTemp.createTempSync('flipper_legacy_db_');
    try {
      final targetPath = p.join(directory.path, 'flipper.sqlite');
      await File(targetPath).writeAsBytes([9]);
      final legacyPath = p.join(directory.path, 'flipper_v45.sqlite');
      await File(legacyPath).writeAsBytes([1, 2, 3]);

      await migrateLegacyMainDatabaseIfNeeded(
        directory: directory.path,
        targetFileName: 'flipper.sqlite',
      );

      expect(File(targetPath).lengthSync(), 1);
    } finally {
      directory.deleteSync(recursive: true);
    }
  });
}
