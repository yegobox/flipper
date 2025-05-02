import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:talker_flutter/talker_flutter.dart';

/// Migrates all files from the old `_db` folder to the new `.db` folder.
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
  // Migrate all files from oldDir to newDir
  final oldFiles = oldDir.listSync().whereType<File>();
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
  // Remove old folder if all files are migrated
  final hasAnyFiles = oldDir.listSync().whereType<File>().isNotEmpty;
  if (!hasAnyFiles) {
    try {
      await oldDir.delete(recursive: true);
      talker
          .info('Deleted old DB folder and all its contents after migration.');
    } catch (e) {
      talker.warning('Could not delete old DB folder: $e');
    }
  }

  // Hide .db folder on Windows if it exists
  final dbDir = Directory(p.join(appDir, '.db'));
  if (Platform.isWindows && await dbDir.exists()) {
    try {
      final result = await Process.run('attrib', ['+h', dbDir.path]);
      if (result.exitCode == 0) {
        talker.info('DB folder is now hidden (Windows attrib +h succeeded).');
      } else {
        talker.warning('Failed to hide DB folder: \\${result.stderr}');
      }
    } catch (e) {
      talker.warning('Error running attrib to hide DB folder: \\${e}');
    }
  }
}
