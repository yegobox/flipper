import 'dart:io';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
// ignore: depend_on_referenced_packages
import 'package:logging/logging.dart';
// ignore: depend_on_referenced_packages
export 'package:brick_core/query.dart'
    show And, Or, Query, QueryAction, Where, WherePhrase, Compare, OrderBy;

import 'connection_manager.dart';

/// Manages database operations, configuration, and integrity
class DatabaseManager {
  static final _logger = Logger('DatabaseManager');
  final String dbFileName;
  ConnectionManager? _connectionManager;

  // Default timeout for database operations
  static const Duration defaultTimeout = Duration(seconds: 10);
  // Default busy timeout in milliseconds
  static const int defaultBusyTimeout = 5000;

  DatabaseManager({
    required this.dbFileName,
  });

  /// Get the connection manager, creating it if needed
  ConnectionManager _getConnectionManager(DatabaseFactory dbFactory) {
    _connectionManager ??= ConnectionManager(dbFactory);
    return _connectionManager!;
  }

  /// Configure database settings for better performance and crash resilience
  /// This method opens a NEW connection with PRAGMA configuration enabled
  Future<void> configureDatabaseSettings(
      String dbPath, DatabaseFactory dbFactory) async {
    try {
      print(
          '🔧 [DatabaseManager] Starting database configuration for: $dbPath');

      // Close existing connection if any, to ensure we can configure PRAGMAs in onConfigure
      final connectionManager = _getConnectionManager(dbFactory);
      await connectionManager.closeConnection(dbPath);

      // Open with configurePragmas flag to enable PRAGMA setup in onConfigure callback
      print(
          '🔧 [DatabaseManager] Opening database with PRAGMA configuration...');
      final db =
          await connectionManager.getConnection(dbPath, configurePragmas: true);

      // Run integrity checks AFTER configuration
      try {
        print('🔧 [DatabaseManager] Running integrity checks...');

        // Integrity check (all platforms)
        final integrityResult = await db.rawQuery('PRAGMA integrity_check');
        if (integrityResult.first.values.first != 'ok') {
          final error =
              'Database integrity check failed: ${integrityResult.first.values.first}';
          print('❌ [DatabaseManager] $error');
          _logger.severe(error);
        } else {
          print('✅ [DatabaseManager] Database integrity check passed');
          _logger.info('Database integrity check passed');
        }

        // Quick check - verifies database structure
        final quickCheck = await db.rawQuery('PRAGMA quick_check');
        if (quickCheck.first.values.first != 'ok') {
          final warning =
              'Database quick check found issues: ${quickCheck.first.values.first}';
          print('⚠️  [DatabaseManager] $warning');
          _logger.warning(warning);
        } else {
          print('✅ [DatabaseManager] Database quick check passed');
        }

        print(
            '🎉 [DatabaseManager] Database configuration completed successfully!');
      } catch (checkError) {
        final errorMsg = 'Error running integrity checks: $checkError';
        print('⚠️  [DatabaseManager] $errorMsg');
        _logger.warning(errorMsg);
      }
    } catch (e) {
      final errorMsg = 'Error configuring database settings: $e';
      print('❌ [DatabaseManager] $errorMsg');
      _logger.warning(errorMsg);
    }
  }

  /// Verify database integrity and create a backup if valid
  Future<bool> verifyDatabaseIntegrity(
      String dbPath, DatabaseFactory dbFactory) async {
    try {
      final connectionManager = _getConnectionManager(dbFactory);

      await connectionManager.executeOperation(
        dbPath,
        (db) async {
          // Comprehensive integrity check
          final integrityResult = await db.rawQuery('PRAGMA integrity_check');
          if (integrityResult.first.values.first != 'ok') {
            _logger.severe(
                'Database integrity check failed: ${integrityResult.first.values.first}');
            throw Exception('Database integrity check failed');
          }

          // Test basic operations
          await db.query('sqlite_master', limit: 1);
          return null;
        },
        busyTimeout: defaultBusyTimeout,
        timeout: defaultTimeout,
      );

      // If we get here, the database is valid - create a backup
      await _createBackup(dbPath);
      _logger.info('Database integrity verified and backup created');
      return true;
    } catch (e) {
      _logger.severe('Database integrity check failed: $e');
      // Attempt to restore from backup
      final restored = await _restoreFromBackup(dbPath);
      if (restored) {
        _logger.info('Database restored from backup successfully');
        return true;
      }
      return false;
    }
  }

  /// Create a backup of the database
  Future<void> _createBackup(String dbPath) async {
    try {
      final dbFile = File(dbPath);
      if (!await dbFile.exists()) return;

      final backupPath = '$dbPath.backup';
      await dbFile.copy(backupPath);
      _logger.info('Database backup created: $backupPath');

      // Keep only the last 3 backups to save space
      await _cleanOldBackups(dbPath);
    } catch (e) {
      _logger.warning('Failed to create backup: $e');
    }
  }

  /// Restore database from backup
  Future<bool> _restoreFromBackup(String dbPath) async {
    try {
      final backupPath = '$dbPath.backup';
      final backupFile = File(backupPath);

      if (!await backupFile.exists()) {
        _logger.warning('No backup file found for restoration');
        return false;
      }

      // Delete corrupted database
      final dbFile = File(dbPath);
      if (await dbFile.exists()) {
        await dbFile.delete();
      }

      // Restore from backup
      await backupFile.copy(dbPath);
      _logger.info('Database restored from backup');
      return true;
    } catch (e) {
      _logger.severe('Failed to restore from backup: $e');
      return false;
    }
  }

  /// Clean old backup files, keeping only the most recent ones
  Future<void> _cleanOldBackups(String dbPath) async {
    try {
      final directory = Directory(dirname(dbPath));
      final backupFiles = await directory
          .list()
          .where((file) =>
              file is File &&
              file.path.contains(basename(dbPath)) &&
              file.path.endsWith('.backup'))
          .cast<File>()
          .toList();

      // Sort by modification date (newest first)
      backupFiles
          .sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));

      // Keep only the 3 most recent backups
      const maxBackups = 3;
      if (backupFiles.length > maxBackups) {
        for (var i = maxBackups; i < backupFiles.length; i++) {
          await backupFiles[i].delete();
          _logger.info('Deleted old backup: ${backupFiles[i].path}');
        }
      }
    } catch (e) {
      _logger.warning('Failed to clean old backups: $e');
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

  /// Close all database connections
  Future<void> closeAllConnections() async {
    if (_connectionManager != null) {
      await _connectionManager!.closeAllConnections();
    }
  }
}
