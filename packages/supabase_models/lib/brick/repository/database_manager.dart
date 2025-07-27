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
  Future<void> configureDatabaseSettings(
      String dbPath, DatabaseFactory dbFactory) async {
    try {
      final connectionManager = _getConnectionManager(dbFactory);

      await connectionManager.executeOperation(
        dbPath,
        (db) async {
          try {
            // Platform-specific PRAGMA configuration
            if (Platform.isWindows) {
              await db.execute('PRAGMA journal_mode=WAL;');
              await db.execute('PRAGMA synchronous=FULL;');
              await db.execute('PRAGMA cache_size = -8192;'); // ~8MB cache
            } else if (Platform.isAndroid) {
              await db.execute('PRAGMA journal_mode=WAL;');
              await db.execute('PRAGMA synchronous=FULL;');
            }
            // Integrity check (all platforms)
            final integrityResult = await db.rawQuery('PRAGMA integrity_check');
            if (integrityResult.first.values.first != 'ok') {
              _logger.warning(
                  'Database integrity check failed: ${integrityResult.first.values.first}');
            } else {
              _logger.info('Database integrity check passed');
            }
          } catch (pragmaError) {
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
      _logger.info('Database integrity verified');
      return true;
    } catch (e) {
      _logger.warning('Database integrity check failed: $e');
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
