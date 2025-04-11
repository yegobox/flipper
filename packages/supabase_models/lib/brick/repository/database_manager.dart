import 'dart:io';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:logging/logging.dart';
// ignore: depend_on_referenced_packages
export 'package:brick_core/query.dart'
    show And, Or, Query, QueryAction, Where, WherePhrase, Compare, OrderBy;

import 'backup_manager.dart';

/// Manages database operations, configuration, and integrity
class DatabaseManager {
  static final _logger = Logger('DatabaseManager');
  final BackupManager backupManager;
  final String dbFileName;

  DatabaseManager({
    required this.dbFileName,
    BackupManager? backupManager,
  }) : backupManager = backupManager ?? BackupManager();

  /// Configure database settings for better performance and crash resilience
  Future<void> configureDatabaseSettings(
      String dbPath, DatabaseFactory dbFactory) async {
    try {
      // Use proper open options instead of PRAGMA statements for Android compatibility
      final db = await dbFactory.openDatabase(
        dbPath,
        options: OpenDatabaseOptions(
          // Set WAL mode via options instead of PRAGMA for Android compatibility
          version: 1,
          // This is the proper way to enable WAL on Android
          singleInstance: true,
        ),
      );

      try {
        // For platforms that support direct PRAGMA statements
        if (!Platform.isAndroid) {
          // Enable Write-Ahead Logging for better crash recovery
          await db.execute('PRAGMA journal_mode = WAL');
          // Ensure data is immediately written to disk
          await db.execute('PRAGMA synchronous = FULL');
        }

        // Run integrity check which works on all platforms
        final integrityResult = await db.rawQuery('PRAGMA integrity_check');
        if (integrityResult.isNotEmpty &&
            integrityResult.first.values.first != 'ok') {
          _logger.warning(
              'Database integrity check failed: ${integrityResult.first.values.first}');
        } else {
          _logger.info('Database integrity check passed');
        }
      } catch (pragmaError) {
        // Log but don't fail if PRAGMA commands aren't supported
        _logger.warning('Could not execute PRAGMA commands: $pragmaError');
      }

      // Close the database after configuration
      await db.close();
    } catch (e) {
      _logger.warning('Error configuring database settings: $e');
    }
  }

  /// Verify database integrity and create a backup if valid
  Future<bool> verifyDatabaseIntegrity(
      String dbPath, DatabaseFactory dbFactory) async {
    try {
      final db = await dbFactory.openDatabase(dbPath);
      await db.query('sqlite_master', limit: 1);
      await db.close();

      // If we get here, the database is likely valid
      // Create a backup for safety
      await backupManager.createVersionedBackup(dbPath);
      _logger.info('Database integrity verified, created backup');
      return true;
    } catch (e) {
      _logger.warning('Database integrity check failed: $e');
      return false;
    }
  }

  /// Attempt to restore database from backup if corrupted
  Future<bool> restoreIfCorrupted(
      String directory, String dbPath, DatabaseFactory dbFactory) async {
    try {
      if (await verifyDatabaseIntegrity(dbPath, dbFactory)) {
        return false; // Database is fine, no need to restore
      }

      _logger.warning('Database corruption detected, attempting restoration');
      // Database is corrupted, try to restore from backup
      final restored =
          await backupManager.restoreLatestBackup(directory, dbPath, dbFactory);
      if (restored) {
        _logger.info('Successfully restored database from backup');
      } else {
        _logger.severe('Failed to restore database from any backup');
        // If restore fails, delete corrupted database to start fresh
        if (await File(dbPath).exists()) {
          await File(dbPath).delete();
          _logger.info('Deleted corrupted database to start fresh');
        }
      }
      return restored;
    } catch (e) {
      _logger.severe('Error during database restore process: $e');
      return false;
    }
  }

  /// Initialize the database directory and ensure it exists
  Future<String> initializeDatabaseDirectory(String directory) async {
    if (!await Directory(directory).exists()) {
      await Directory(directory).create(recursive: true);
      _logger.info('Created database directory: $directory');
    }
    return directory;
  }

  /// Get the full database path
  String getDatabasePath(String directory) {
    return join(directory, dbFileName);
  }
}
