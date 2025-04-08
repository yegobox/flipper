import 'dart:io';
import 'package:brick_supabase/testing.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_sqlite/memory_cache_provider.dart';
import 'package:brick_supabase/brick_supabase.dart' hide Supabase;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http show Request;
import 'package:supabase_models/brick/brick.g.dart';
import 'package:supabase_models/brick/databasePath.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'db/schema.g.dart';
import 'package:path/path.dart';
import 'package:logging/logging.dart';
// ignore: depend_on_referenced_packages
export 'package:brick_core/query.dart'
    show And, Or, Query, QueryAction, Where, WherePhrase, Compare, OrderBy;

const dbFileName = "flipper_v17.sqlite";
const queueName = "brick_offline_queue_v17.sqlite";
const maxBackupCount = 3; // Maximum number of backups to keep

class Repository extends OfflineFirstWithSupabaseRepository {
  static Repository? _singleton;
  static final _logger = Logger('Repository');

  Repository._({
    required super.supabaseProvider,
    required super.sqliteProvider,
    required super.migrations,
    required super.offlineRequestQueue,
    super.memoryCacheProvider,
  });

  factory Repository() {
    // For web or uninitialized cases, return a dummy repository instead of throwing
    if (_singleton == null) {
      if (kIsWeb) {
        // Create and return a dummy repository for web that silently does nothing
        return _createDummyRepository();
      } else {
        // For non-web platforms, still throw an error as it's likely a real issue
        throw StateError(
            'Repository not initialized. Call initializeSupabaseAndConfigure first.');
      }
    }
    return _singleton!;
  }

  // Static helper methods for database operations
  static Future<void> _configureAndInitializeDatabase({
    required String supabaseUrl,
    required String supabaseAnonKey,
    required DatabaseFactory databaseFactoryToUse,
  }) async {
    String dbPath;
    String queuePath;

    if (kIsWeb) {
      // For web, use in-memory database or a web-specific approach
      dbPath = inMemoryDatabasePath;
      queuePath = inMemoryDatabasePath;

      // Initialize FFI is not needed for web
    } else {
      // Initialize FFI for Windows platforms
      if (Platform.isWindows) {
        sqfliteFfiInit();
        _logger.info('Initialized SQLite FFI for Windows');
      }

      // Get the appropriate directory path for native platforms
      final directory = await DatabasePath.getDatabaseDirectory();

      // Ensure the directory exists
      if (!await Directory(directory).exists()) {
        await Directory(directory).create(recursive: true);
        _logger.info('Created database directory: $directory');
      }

      // Construct the full database path
      dbPath = join(directory, dbFileName);
      queuePath = join(directory, queueName);

      // Check if the database exists and verify its integrity
      if (await File(dbPath).exists()) {
        try {
          // Try to open the database to check if it's valid
          final db = await databaseFactoryToUse.openDatabase(
            dbPath,
            options: OpenDatabaseOptions(readOnly: true),
          );
          await db.close();
          _logger.info('Database integrity check passed');
        } catch (e) {
          _logger.warning('Database corruption detected: $e');
          // Database is corrupted, try to restore from backup
          final restored = await _restoreLatestBackup(
              directory, dbPath, databaseFactoryToUse);
          if (!restored) {
            _logger.severe(
                'Failed to restore from any backup, creating new database');
            // If restore fails, delete corrupted database to start fresh
            if (await File(dbPath).exists()) {
              await File(dbPath).delete();
            }
          }
        }
      }
    }

    final (client, queue) = OfflineFirstWithSupabaseRepository.clientQueue(
      databaseFactory: databaseFactoryToUse,
      databasePath: queuePath,
      onReattempt: (http.Request request, dynamic object) {
        _logger.info('Reattempting offline request: ${request.url}');
      },
      onRequestException: (request, object) {
        // Handle failed requests by logging the error
        try {
          _logger.warning('Offline request failed: ${request.url}');
        } catch (e) {
          _logger.severe('Error handling offline request exception: $e');
        }
      },
    );

    final SupabaseClient supabaseClient;
    final mock = SupabaseMockServer(modelDictionary: supabaseModelDictionary);

    if (DatabasePath.isTestEnvironment()) {
      // Use the mocked client in a test environment
      await mock.setUp();
      supabaseClient =
          SupabaseClient(mock.serverUrl, mock.apiKey, httpClient: client);
    } else {
      // Initialize the real Supabase client in a non-test environment
      supabaseClient = (await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
        httpClient: client,
      ))
          .client;
    }

    final provider = SupabaseProvider(
      supabaseClient,
      modelDictionary: supabaseModelDictionary,
    );

    // Create the SQLite provider with robust settings
    final sqliteProvider = SqliteProvider(
      DatabasePath.isTestEnvironment() || kIsWeb
          ? inMemoryDatabasePath
          : dbPath,
      databaseFactory: databaseFactoryToUse,
      modelDictionary: sqliteModelDictionary,
    );

    _singleton = Repository._(
      supabaseProvider: provider,
      sqliteProvider: sqliteProvider,
      migrations: migrations,
      offlineRequestQueue: queue,
      memoryCacheProvider: MemoryCacheProvider(),
    );

    // Configure the database after initialization (non-web only)
    if (!kIsWeb && !DatabasePath.isTestEnvironment()) {
      try {
        // Create a backup of the database after successful initialization
        if (await File(dbPath).exists()) {
          await _createVersionedBackup(dbPath);
        }

        // Configure the database with WAL mode and other settings
        if (await File(dbPath).exists()) {
          await _configureDatabaseSettings(dbPath, databaseFactoryToUse);
        }
      } catch (e) {
        _logger.warning('Error during database configuration: $e');
      }
    }
  }

  // Creates a dummy repository that does nothing (for web)
  static Repository _createDummyRepository() {
    // Create minimal implementations that do nothing for web
    final dummySupabaseProvider = SupabaseProvider(
      SupabaseClient('dummy-url', 'dummy-key'),
      modelDictionary: supabaseModelDictionary,
    );

    final dummySqliteProvider = SqliteProvider(
      inMemoryDatabasePath,
      databaseFactory: databaseFactory,
      modelDictionary: sqliteModelDictionary,
    );

    // Create a client and queue using the helper method
    final (_, dummyQueue) = OfflineFirstWithSupabaseRepository.clientQueue(
      databaseFactory: databaseFactory,
      databasePath: inMemoryDatabasePath,
      onReattempt: (_, __) {},
      onRequestException: (_, __) {},
    );

    return Repository._(
      supabaseProvider: dummySupabaseProvider,
      sqliteProvider: dummySqliteProvider,
      migrations: migrations,
      offlineRequestQueue: dummyQueue,
      memoryCacheProvider: MemoryCacheProvider(),
    );
  }

  static Future<void> initializeSupabaseAndConfigure({
    required String supabaseUrl,
    required String supabaseAnonKey,
  }) async {
    // Create variables to hold the appropriate database factory
    final databaseFactoryToUse = kIsWeb
        ? databaseFactory
        : (Platform.isWindows || DatabasePath.isTestEnvironment()
            ? databaseFactoryFfi
            : databaseFactory);

    // Use the helper method to initialize and configure the database
    await _configureAndInitializeDatabase(
      supabaseUrl: supabaseUrl,
      supabaseAnonKey: supabaseAnonKey,
      databaseFactoryToUse: databaseFactoryToUse,
    );
  }

  /// Get the number of requests in the queue
  /// This method is called from CoreSync.dart
  Future<int> availableQueue() async {
    // On web, silently return 0 without trying to access the queue
    if (kIsWeb) {
      return 0;
    }

    try {
      final requests = await offlineRequestQueue.requestManager
          .unprocessedRequests(onlyLocked: true);
      return requests.length;
    } catch (e) {
      // Handle any errors gracefully
      _logger.warning("Error checking queue: $e");
      return 0;
    }
  }

  /// Clear any locked requests in the queue
  /// This method is called from CoreSync.dart
  Future<void> deleteUnprocessedRequests() async {
    // On web, silently do nothing
    if (kIsWeb) {
      return;
    }

    try {
      // Retrieve unprocessed requests
      final requests = await offlineRequestQueue.requestManager
          .unprocessedRequests(onlyLocked: true);

      // Extract the primary key column name
      final primaryKeyColumn =
          offlineRequestQueue.requestManager.primaryKeyColumn;

      // Create a list to hold the futures for deletion operations
      final List<Future<void>> deletionFutures = [];

      // Iterate through the unprocessed requests
      for (final request in requests) {
        // Retrieve the request ID using the primary key column
        final requestId = request[primaryKeyColumn] as int;

        // Add the deletion future to the list
        deletionFutures.add(
          offlineRequestQueue.requestManager
              .deleteUnprocessedRequest(requestId),
        );
      }

      // Wait for all deletion operations to complete
      await Future.wait(deletionFutures);

      _logger.info("All locked requests have been cleared.");
    } catch (e) {
      _logger.warning("An error occurred while clearing locked requests: $e");
    }
  }

  /// Configure the database for better crash resilience
  Future<void> configureDatabase() async {
    if (kIsWeb || DatabasePath.isTestEnvironment()) {
      return;
    }

    try {
      // Access the database directly using the database factory
      final directory = await DatabasePath.getDatabaseDirectory();
      final dbPath = join(directory, dbFileName);

      if (await File(dbPath).exists()) {
        await _configureDatabaseSettings(dbPath, databaseFactory);
        _logger.info('Database configured for better crash resilience');
      }
    } catch (e) {
      _logger.warning('Error during database configuration: $e');
    }
  }

  /// Create a backup of the database
  Future<void> backupDatabase() async {
    if (kIsWeb || DatabasePath.isTestEnvironment()) {
      return;
    }

    try {
      final directory = await DatabasePath.getDatabaseDirectory();
      final dbPath = join(directory, dbFileName);

      // Create backup only if the database exists
      if (await File(dbPath).exists()) {
        await _createVersionedBackup(dbPath);
        _logger.info('Database backup created successfully');
      }
    } catch (e) {
      _logger.warning('Error during database backup: $e');
    }
  }

  /// Restore the database from backup if needed
  Future<bool> restoreFromBackupIfNeeded() async {
    if (kIsWeb || DatabasePath.isTestEnvironment()) {
      return false;
    }

    try {
      final directory = await DatabasePath.getDatabaseDirectory();
      final dbPath = join(directory, dbFileName);

      // Check if the database exists but might be corrupted
      if (await File(dbPath).exists()) {
        try {
          // Try to open the database to check if it's valid
          final db = await databaseFactory.openDatabase(dbPath);
          await db.query('sqlite_master', limit: 1);
          await db.close();

          // If we get here, the database is likely valid
          // Create a backup for safety
          await _createVersionedBackup(dbPath);
          _logger.info('Database integrity verified, created backup');
          return false;
        } catch (e) {
          _logger
              .warning('Database corruption detected during restore check: $e');
          // Database is corrupted, try to restore from backup
          final restored =
              await _restoreLatestBackup(directory, dbPath, databaseFactory);
          if (restored) {
            _logger.info('Successfully restored database from backup');
          } else {
            _logger.severe('Failed to restore database from any backup');
          }
          return restored;
        }
      }
      return false;
    } catch (e) {
      _logger.severe('Error during database restore process: $e');
      return false;
    }
  }

  // Helper method to create a versioned backup
  static Future<void> _createVersionedBackup(String dbPath) async {
    try {
      final directory = dirname(dbPath);
      final filename = basename(dbPath);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final backupPath = join(directory, '${filename}_backup_$timestamp');

      // Create the new backup
      await File(dbPath).copy(backupPath);
      _logger.info('Created versioned backup: $backupPath');

      // Clean up old backups if we have too many
      await _cleanupOldBackups(directory, filename);
    } catch (e) {
      _logger.warning('Failed to create versioned backup: $e');
    }
  }

  // Helper method to clean up old backups
  static Future<void> _cleanupOldBackups(
      String directory, String baseFilename) async {
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

  // Helper method to restore from the latest backup
  static Future<bool> _restoreLatestBackup(
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

  // Helper method to configure database settings
  static Future<void> _configureDatabaseSettings(
      String dbPath, DatabaseFactory dbFactory) async {
    try {
      final db = await dbFactory.openDatabase(dbPath);

      // Enable Write-Ahead Logging for better crash recovery
      await db.execute('PRAGMA journal_mode = WAL');
      // Ensure data is immediately written to disk
      await db.execute('PRAGMA synchronous = FULL');
      // Run integrity check
      final integrityResult = await db.rawQuery('PRAGMA integrity_check');
      if (integrityResult.isNotEmpty &&
          integrityResult.first.values.first != 'ok') {
        _logger.warning(
            'Database integrity check failed: ${integrityResult.first.values.first}');
      } else {
        _logger.info('Database integrity check passed');
      }

      // Close the database after configuration
      await db.close();
    } catch (e) {
      _logger.warning('Error configuring database settings: $e');
    }
  }
}
