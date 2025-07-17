import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
// ignore: depend_on_referenced_packages
import 'package:logging/logging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// ignore: depend_on_referenced_packages
export 'package:brick_core/query.dart'
    show And, Or, Query, QueryAction, Where, WherePhrase, Compare, OrderBy;

// For database operations
import 'package:sqflite_common/sqlite_api.dart';
import 'package:supabase_models/brick/repository.dart';

/// Manages database backup and restoration operations
class BackupManager {
  static final _logger = Logger('BackupManager');
  final int maxBackupCount;

  /// Timestamp of the last backup
  DateTime? _lastBackupTime;

  /// Flag to track if a backup is currently in progress
  bool _isBackupInProgress = false;

  BackupManager({this.maxBackupCount = 3});

  /// Creates a versioned backup of the database file
  /// When dbFactory is provided, uses a transaction-safe approach
  /// Otherwise falls back to file copying (less safe during concurrent operations)
  Future<void> createVersionedBackup(String dbPath,
      {DatabaseFactory? dbFactory}) async {
    // Set flag to indicate backup is in progress
    if (_isBackupInProgress) {
      _logger.info('Backup already in progress, skipping this request');
      return;
    }

    _isBackupInProgress = true;

    try {
      final directory = dirname(dbPath);
      final filename = basename(dbPath);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final backupPath = join(directory, '${filename}_backup_$timestamp');

      // If no database factory is provided, fall back to file copying
      // This is less safe but doesn't require the database factory
      if (dbFactory == null) {
        _logger.info(
            'No database factory provided, using file copy for backup (less safe during writes)');
        await File(dbPath).copy(backupPath);
        _logger.info('Created versioned backup via file copy: $backupPath');
        await cleanupOldBackups(directory, filename);
        return;
      }

      // Use the provided database factory for a transaction-safe backup
      final factory = dbFactory;
      Database? sourceDb;

      try {
        // Open the source database in read-only mode to avoid interfering with ongoing transactions
        sourceDb = await factory.openDatabase(
          dbPath,
          options: OpenDatabaseOptions(readOnly: true),
        );
      } catch (e) {
        _logger.warning('Failed to open database for backup: $e');
        // If we can't open the database, try file copying as a fallback
        if (await File(dbPath).exists()) {
          _logger.info('Falling back to file copy backup method');
          await File(dbPath).copy(backupPath);
          _logger.info(
              'Created versioned backup via file copy fallback: $backupPath');
          await cleanupOldBackups(directory, filename);
        }
        return;
      }

      try {
        // Create the backup database
        final backupDb = await factory.openDatabase(
          backupPath,
          options: OpenDatabaseOptions(readOnly: false),
        );

        try {
          // Use SQLite's backup API via batch operations to safely copy the database
          // This is done by backing up the schema first, then the data

          // Get all tables from the source database
          final tables = await sourceDb.query('sqlite_master',
              where:
                  "type = 'table' AND name != 'sqlite_sequence' AND name != 'android_metadata'");

          // Begin transaction on the backup database
          await backupDb.execute('BEGIN TRANSACTION');

          // Copy each table schema and data
          for (final table in tables) {
            final tableName = table['name'] as String;

            // Get the CREATE TABLE statement
            final createTableSql = table['sql'] as String;
            await backupDb.execute(createTableSql);

            // Copy the data
            final rows = await sourceDb.query(tableName);
            for (final row in rows) {
              // Build insert statement with proper escaping
              final columns = row.keys.join(', ');
              final values = row.values.map((value) {
                if (value == null) return 'NULL';
                if (value is num) return value.toString();
                return "'${value.toString().replaceAll("'", "''")}'";
              }).join(', ');

              await backupDb.execute(
                  'INSERT INTO $tableName ($columns) VALUES ($values)');
            }
          }

          // Commit the transaction
          await backupDb.execute('COMMIT');
          _logger.info('Created versioned backup: $backupPath');
        } catch (e) {
          // Rollback if there was an error
          try {
            await backupDb.execute('ROLLBACK');
          } catch (_) {}
          rethrow;
        } finally {
          // Close the backup database
          await backupDb.close();
        }
      } catch (e) {
        _logger.warning('Error during backup database operations: $e');
        // Clean up the incomplete backup file if it exists
        try {
          final backupFile = File(backupPath);
          if (await backupFile.exists()) {
            await backupFile.delete();
          }
        } catch (_) {}
        rethrow;
      } finally {
        // Close the source database if it was successfully opened
        try {
          await sourceDb.close();
        } catch (e) {
          _logger.warning('Error closing source database during backup: $e');
        }
      }

      // Clean up old backups if we have too many
      await cleanupOldBackups(directory, filename);
    } catch (e) {
      _logger.warning('Failed to create versioned backup: $e');
    } finally {
      // Reset the backup in progress flag
      _isBackupInProgress = false;
    }
  }

  /// Cleans up old backups, keeping only the most recent ones
  Future<void> cleanupOldBackups(String directory, String baseFilename,
      {String? currentBackupPath}) async {
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

  /// Performs a periodic backup if enough time has passed since the last backup
  /// Returns true if a backup was performed, false otherwise
  ///
  /// The dbFactory parameter is required for transaction-safe backups.
  /// If not provided, will fall back to file copying (less safe during concurrent operations).
  Future<bool> performPeriodicBackup(String dbPath,
      {Duration minInterval = const Duration(minutes: 20),
      DatabaseFactory? dbFactory,
      String? currentBackupPath}) async {
    // Skip for web or if the database doesn't exist
    if (kIsWeb) {
      return false;
    }

    try {
      if (!await File(dbPath).exists()) {
        return false;
      }
    } catch (e) {
      _logger.warning('Error checking if database exists: $e');
      return false;
    }

    // Check if a backup is already in progress
    if (_isBackupInProgress) {
      _logger.info('Backup already in progress, skipping this periodic backup');
      return false;
    }

    final now = DateTime.now();

    // Check if enough time has passed since the last backup
    if (_lastBackupTime != null) {
      final timeSinceLastBackup = now.difference(_lastBackupTime!);
      if (timeSinceLastBackup < minInterval) {
        _logger.info(
            'Skipping backup: last backup was ${timeSinceLastBackup.inMinutes} minutes ago');
        return false;
      }
    }

    // Set a flag to prevent concurrent backups
    _isBackupInProgress = true;

    try {
      // Use file copying as a safer alternative when we're doing periodic backups
      // This avoids potential database_closed errors from opening the database
      final directory = dirname(dbPath);
      final filename = basename(dbPath);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final backupPath = join(directory, '${filename}_backup_$timestamp');

      try {
        await File(dbPath).copy(backupPath);
        _logger.info('Created periodic backup via file copy: $backupPath');
        await cleanupOldBackups(directory, filename,
            currentBackupPath: backupPath);
        _lastBackupTime = now;
        return true;
      } catch (e) {
        // If direct file copy fails, try the more complex approach with dbFactory
        _logger
            .warning('File copy backup failed, trying alternative method: $e');

        if (dbFactory != null) {
          await createVersionedBackup(dbPath, dbFactory: dbFactory);
          _lastBackupTime = now;
          _logger.info(
              'Periodic backup created successfully via alternative method');
          return true;
        } else {
          _logger.warning('Cannot perform backup: both methods failed');
          return false;
        }
      }
    } catch (e) {
      _logger.warning('Error during periodic backup: $e');
      return false;
    } finally {
      // Always reset the backup flag
      _isBackupInProgress = false;
    }
  }
}
