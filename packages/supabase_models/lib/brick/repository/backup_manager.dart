import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:logging/logging.dart';
// ignore: depend_on_referenced_packages
export 'package:brick_core/query.dart'
    show And, Or, Query, QueryAction, Where, WherePhrase, Compare, OrderBy;

/// Manages database backup and restoration operations
class BackupManager {
  static final _logger = Logger('BackupManager');
  final int maxBackupCount;

  BackupManager({this.maxBackupCount = 3});

  /// Creates a versioned backup of the database file
  Future<void> createVersionedBackup(String dbPath) async {
    try {
      final directory = dirname(dbPath);
      final filename = basename(dbPath);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final backupPath = join(directory, '${filename}_backup_$timestamp');

      // Create the new backup
      await File(dbPath).copy(backupPath);
      _logger.info('Created versioned backup: $backupPath');

      // Clean up old backups if we have too many
      await cleanupOldBackups(directory, filename);
    } catch (e) {
      _logger.warning('Failed to create versioned backup: $e');
    }
  }

  /// Cleans up old backups, keeping only the most recent ones
  Future<void> cleanupOldBackups(String directory, String baseFilename) async {
    try {
      final dir = Directory(directory);
      final backupPrefix = '${baseFilename}_backup_';

      // List all backup files
      final backupFiles = await dir
          .list()
          .where((entity) =>
              entity is File && basename(entity.path).startsWith(backupPrefix))
          .cast<File>()
          .toList();

      // Sort by modification time (newest first)
      backupFiles
          .sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));

      // Keep only the most recent backups
      if (backupFiles.length > maxBackupCount) {
        for (var i = maxBackupCount; i < backupFiles.length; i++) {
          await backupFiles[i].delete();
          _logger.info('Deleted old backup: ${backupFiles[i].path}');
        }
      }
    } catch (e) {
      _logger.warning('Error during backup cleanup: $e');
    }
  }

  /// Attempts to restore the database from the most recent backup
  Future<bool> restoreLatestBackup(
      String directory, String dbPath, DatabaseFactory dbFactory) async {
    try {
      final filename = basename(dbPath);
      final backupPrefix = '${filename}_backup_';
      final dir = Directory(directory);

      // List all backup files
      final backupFiles = await dir
          .list()
          .where((entity) =>
              entity is File && basename(entity.path).startsWith(backupPrefix))
          .cast<File>()
          .toList();

      // Sort by modification time (newest first)
      backupFiles
          .sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));

      // Try each backup in order until one works
      for (final backupFile in backupFiles) {
        try {
          // Delete corrupted database if it exists
          if (await File(dbPath).exists()) {
            await File(dbPath).delete();
          }

          // Copy backup to main database file
          await backupFile.copy(dbPath);

          // Verify the restored database
          final db = await dbFactory.openDatabase(dbPath);
          await db.query('sqlite_master', limit: 1);
          await db.close();

          _logger.info('Successfully restored from backup: ${backupFile.path}');
          return true;
        } catch (e) {
          _logger
              .warning('Failed to restore from backup ${backupFile.path}: $e');
          // Continue to the next backup
        }
      }

      // If we get here, all backups failed
      _logger.severe('All backup restoration attempts failed');
      return false;
    } catch (e) {
      _logger.severe('Error during backup restoration process: $e');
      return false;
    }
  }
}
