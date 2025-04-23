import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:talker_flutter/talker_flutter.dart';

/// Migrates all `.sqlite` and `.json` files from the old `_db` folder to the new `.db` folder.
/// Only copies files that do not already exist in the new folder.
Future<void> migrateOldDbFiles({
  required String appDir,
  required Talker talker,
}) async {
  final oldDir = Directory(p.join(appDir, '_db'));
  final newDir = Directory(p.join(appDir, '.db'));
  if (!(await oldDir.exists())) {
    talker.info('Old DB folder does not exist, skipping migration.');
    return;
  }
  if (!(await newDir.exists())) {
    await newDir.create(recursive: true);
    talker.info('Created new DB directory at: ${newDir.path}');
  }
  // Migrate both .sqlite and .json files
  final oldFiles = oldDir
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.sqlite') || f.path.endsWith('.json'));
  for (final file in oldFiles) {
    final fileName = p.basename(file.path);
    final newFilePath = p.join(newDir.path, fileName);
    final newFile = File(newFilePath);
    if (await newFile.exists()) {
      talker.info('File already exists in new location: $fileName');
      continue;
    }
    try {
      await file.copy(newFilePath);
      talker.info('Migrated DB file: $fileName');
    } catch (e) {
      talker.error('Failed to migrate $fileName: $e');
    }
  }
  // Optionally: Remove old folder if empty (not required, but safe cleanup)
  final remaining = oldDir
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.sqlite') || f.path.endsWith('.json'))
      .isNotEmpty;
  if (!remaining) {
    try {
      await oldDir.delete(recursive: true);
      talker.info('Deleted old DB folder after migration.');
    } catch (e) {
      talker.warning('Could not delete old DB folder: $e');
    }
  }
}
