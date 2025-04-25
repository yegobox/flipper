import 'dart:io';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
// ignore: depend_on_referenced_packages
import 'package:logging/logging.dart';
// ignore: depend_on_referenced_packages
export 'package:brick_core/query.dart'
    show And, Or, Query, QueryAction, Where, WherePhrase, Compare, OrderBy;

import 'backup_manager.dart';
import 'connection_manager.dart';

/// Manages database operations, configuration, and integrity
class DatabaseManager {
  static final _logger = Logger('DatabaseManager');
  final BackupManager backupManager;
  final String dbFileName;
  ConnectionManager? _connectionManager;

  // Default timeout for database operations
  static const Duration defaultTimeout = Duration(seconds: 10);
  // Default busy timeout in milliseconds
  static const int defaultBusyTimeout = 5000;

  DatabaseManager({
    required this.dbFileName,
    BackupManager? backupManager,
  }) : backupManager = backupManager ?? BackupManager();

  /// Get the connection manager, creating it if needed
  ConnectionManager _getConnectionManager(DatabaseFactory dbFactory) {
    _connectionManager ??= ConnectionManager(dbFactory);
    return _connectionManager!;
  }

  /// Configure database settings for better performance and crash resilience
  Future<void> configureDatabaseSettings(
      String dbPath, DatabaseFactory dbFactory) async {
    try {
      final connectionManager = _getConnectionManager(dbFactory);

      await connectionManager.executeOperation(
        dbPath,
        (db) async {
          try {
            // Platform-specific PRAGMA configuration
            if (Platform.isAndroid) {
              // Android: Safe to use all PRAGMAs
              await db.execute('PRAGMA journal_mode = WAL');
              await db.execute('PRAGMA synchronous = FULL');
              await db.execute('PRAGMA busy_timeout = $defaultBusyTimeout');
            } else if (Platform.isWindows) {
              // Windows desktop: Safe to use all PRAGMAs
              await db.execute('PRAGMA journal_mode = WAL');
              await db.execute('PRAGMA synchronous = FULL');
              await db.execute('PRAGMA busy_timeout = $defaultBusyTimeout');
            } else if (Platform.isIOS || Platform.isMacOS) {
              // iOS/macOS: Avoid WAL and busy_timeout due to iCloud and file locking issues
              // Only set synchronous for data safety
              await db.execute('PRAGMA synchronous = FULL');
              // Optionally, you can wrap busy_timeout in a try/catch if you want to experiment:
              // try {
              //   await db.execute('PRAGMA busy_timeout = $defaultBusyTimeout');
              // } catch (e) {
              //   if (e.toString().contains('not an error')) {
              //     _logger.info('Ignored harmless busy_timeout warning: $e');
              //   } else {
              //     rethrow;
              //   }
              // }
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
          return null;
        },
        busyTimeout: defaultBusyTimeout,
        timeout: defaultTimeout,
      );
    } catch (e) {
      _logger.warning('Error configuring database settings: $e');
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
          await db.query('sqlite_master', limit: 1);
          return null;
        },
        busyTimeout: defaultBusyTimeout,
        timeout: defaultTimeout,
      );

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

      // Close any existing connections before restoration
      final connectionManager = _getConnectionManager(dbFactory);
      await connectionManager.closeConnection(dbPath);

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

  /// Close all database connections
  Future<void> closeAllConnections() async {
    if (_connectionManager != null) {
      await _connectionManager!.closeAllConnections();
    }
  }
}
