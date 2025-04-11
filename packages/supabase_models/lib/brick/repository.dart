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
// ignore: depend_on_referenced_packages
import 'package:logging/logging.dart';
// ignore: depend_on_referenced_packages
export 'package:brick_core/query.dart'
    show And, Or, Query, QueryAction, Where, WherePhrase, Compare, OrderBy;

import 'repository/backup_manager.dart';
import 'repository/database_manager.dart';
import 'repository/queue_manager.dart';
import 'repository/platform_helpers.dart';
import 'repository/local_storage.dart';

// Default values that will be used if LocalStorage is not available
const defaultDbFileName = 'flipper_v17.sqlite';
const defaultQueueName = 'brick_offline_queue_v17.sqlite';
const maxBackupCount = 3; // Maximum number of backups to keep

// Interface for retrieving database configuration
/// This allows the Repository to get database filenames from any storage implementation
abstract class DatabaseConfigStorage {
  /// Get the main database filename
  String getDatabaseFilename();

  /// Get the queue filename
  String getQueueFilename();
}

/// Main repository class that serves as an entry point to the database operations
/// This class maintains backward compatibility with the original implementation
class Repository extends OfflineFirstWithSupabaseRepository {
  static Repository? _singleton;
  static final _logger = Logger('Repository');
  static DatabaseConfigStorage? _configStorage;
  static SharedPreferenceStorage? _sharedPreferenceStorage;

  // Managers for different responsibilities
  late final BackupManager _backupManager;
  late final DatabaseManager _databaseManager;
  late final QueueManager _queueManager;

  /// Set the storage for database configuration
  static void setConfigStorage(DatabaseConfigStorage storage) {
    _configStorage = storage;
    _logger.info('Database configuration storage set');
    _logger.info('Using database filename: ${dbFileName}');
    _logger.info('Using queue filename: ${queueName}');
  }

  /// Get the shared preference storage instance
  static Future<SharedPreferenceStorage> getSharedPreferenceStorage() async {
    if (_sharedPreferenceStorage == null) {
      _logger.info('Initializing SharedPreferenceStorage');
      final storage = SharedPreferenceStorage();
      _sharedPreferenceStorage =
          await storage.initializePreferences() as SharedPreferenceStorage;
      _logger.info('SharedPreferenceStorage initialized successfully');
    }
    return _sharedPreferenceStorage!;
  }

  // Get the database filename from storage or use default
  static String get dbFileName =>
      _configStorage?.getDatabaseFilename() ?? defaultDbFileName;

  // Get the queue filename from storage or use default
  static String get queueName =>
      _configStorage?.getQueueFilename() ?? defaultQueueName;

  // The setConfigStorage method is already defined above

  Repository._({
    required super.supabaseProvider,
    required super.sqliteProvider,
    required super.migrations,
    required super.offlineRequestQueue,
    required String dbPath,
    super.memoryCacheProvider,
  }) {
    _backupManager = BackupManager(maxBackupCount: maxBackupCount);
    _databaseManager =
        DatabaseManager(dbFileName: dbFileName, backupManager: _backupManager);
    _queueManager = QueueManager(offlineRequestQueue);
  }

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
    // Initialize SharedPreferenceStorage first to ensure it's available
    await getSharedPreferenceStorage();

    String dbPath;
    String queuePath;

    if (kIsWeb) {
      // For web, use in-memory database or a web-specific approach
      dbPath = PlatformHelpers.getInMemoryDatabasePath();
      queuePath = PlatformHelpers.getInMemoryDatabasePath();
    } else {
      // Initialize FFI for Windows platforms
      PlatformHelpers.initializePlatform();

      // Get the appropriate directory path for native platforms
      final directory = await DatabasePath.getDatabaseDirectory();

      // Create database manager for initialization
      final databaseManager = DatabaseManager(dbFileName: dbFileName);
      final backupManager = BackupManager(maxBackupCount: maxBackupCount);

      // Ensure the directory exists
      await databaseManager.initializeDatabaseDirectory(directory);

      // Construct the full database path
      dbPath = databaseManager.getDatabasePath(directory);
      queuePath = join(directory, queueName);

      // Check if the database exists and verify its integrity
      if (await File(dbPath).exists()) {
        try {
          // Try to open the database to check if it's valid
          final db = await databaseFactoryToUse.openDatabase(
            dbPath,
          );
          await db.close();
          _logger.info('Database integrity check passed');
        } catch (e) {
          _logger.warning('Database corruption detected: $e');
          // Database is corrupted, try to restore from backup
          final restored = await backupManager.restoreLatestBackup(
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
          ? PlatformHelpers.getInMemoryDatabasePath()
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
      dbPath: dbPath,
    );

    // Configure the database after initialization (non-web only)
    if (!kIsWeb && !DatabasePath.isTestEnvironment()) {
      try {
        // Create a backup of the database after successful initialization
        if (await File(dbPath).exists()) {
          await _singleton!._backupManager.createVersionedBackup(dbPath);
        }

        // Configure the database with WAL mode and other settings
        if (await File(dbPath).exists()) {
          await _singleton!._databaseManager
              .configureDatabaseSettings(dbPath, databaseFactoryToUse);
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
      PlatformHelpers.getInMemoryDatabasePath(),
      databaseFactory: PlatformHelpers.getDatabaseFactory(),
      modelDictionary: sqliteModelDictionary,
    );

    // Create a client and queue using the helper method
    final (_, dummyQueue) = OfflineFirstWithSupabaseRepository.clientQueue(
      databaseFactory: PlatformHelpers.getDatabaseFactory(),
      databasePath: PlatformHelpers.getInMemoryDatabasePath(),
      onReattempt: (_, __) {},
      onRequestException: (_, __) {},
    );

    return Repository._(
      supabaseProvider: dummySupabaseProvider,
      sqliteProvider: dummySqliteProvider,
      migrations: migrations,
      offlineRequestQueue: dummyQueue,
      memoryCacheProvider: MemoryCacheProvider(),
      dbPath: PlatformHelpers.getInMemoryDatabasePath(),
    );
  }

  static Future<void> initializeSupabaseAndConfigure({
    required String supabaseUrl,
    required String supabaseAnonKey,
  }) async {
    // Create variables to hold the appropriate database factory
    final databaseFactoryToUse = PlatformHelpers.getDatabaseFactory();

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
    if (kIsWeb) {
      return 0;
    }
    return await _queueManager.availableQueue();
  }

  /// Clear any locked requests in the queue
  /// This method is called from CoreSync.dart
  Future<void> deleteUnprocessedRequests() async {
    if (kIsWeb) {
      return;
    }
    await _queueManager.deleteUnprocessedRequests();
  }

  /// Get information about the queue status
  /// Returns a map with counts of locked (failed) and unlocked (waiting) requests
  Future<Map<String, int>> getQueueStatus() async {
    if (kIsWeb) {
      return {'locked': 0, 'unlocked': 0, 'total': 0};
    }
    return await _queueManager.getQueueStatus();
  }

  /// Delete only failed requests from the queue
  /// Returns the number of requests deleted
  Future<int> deleteFailedRequests() async {
    if (kIsWeb) {
      return 0;
    }
    return await _queueManager.deleteFailedRequests();
  }

  /// Cleanup failed requests from the queue
  /// This method is designed to be called from CronService
  /// Returns the number of failed requests that were cleaned up
  Future<int> cleanupFailedRequests() async {
    if (kIsWeb) {
      return 0;
    }

    // Check if queue manager is properly initialized
    try {
      // This will throw an exception if not properly initialized
      await _queueManager.getQueueStatus();
    } catch (e) {
      _logger
          .warning('Queue manager not fully initialized, skipping cleanup: $e');
      return 0;
    }

    return await _queueManager.cleanupFailedRequests();
  }

  /// Configure the database for better crash resilience
  Future<void> configureDatabase() async {
    if (kIsWeb || PlatformHelpers.isTestEnvironment()) {
      return;
    }

    try {
      final dbPath =
          join(await DatabasePath.getDatabaseDirectory(), dbFileName);
      await _databaseManager.configureDatabaseSettings(
          dbPath, PlatformHelpers.getDatabaseFactory());
      _logger.info('Database configured for better crash resilience');
    } catch (e) {
      _logger.warning('Error during database configuration: $e');
    }
  }

  /// Create a backup of the database
  Future<void> backupDatabase() async {
    if (kIsWeb || PlatformHelpers.isTestEnvironment()) {
      return;
    }

    try {
      final dbPath =
          join(await DatabasePath.getDatabaseDirectory(), dbFileName);
      await _backupManager.createVersionedBackup(dbPath);
      _logger.info('Database backup created successfully');
    } catch (e) {
      _logger.warning('Error during database backup: $e');
    }
  }

  /// Restore the database from backup if needed
  Future<bool> restoreFromBackupIfNeeded() async {
    if (kIsWeb || PlatformHelpers.isTestEnvironment()) {
      return false;
    }

    try {
      final directory = await DatabasePath.getDatabaseDirectory();
      final dbPath = join(directory, dbFileName);
      return await _databaseManager.restoreIfCorrupted(
          directory, dbPath, PlatformHelpers.getDatabaseFactory());
    } catch (e) {
      _logger.severe('Error during database restore process: $e');
      return false;
    }
  }

  /// Perform a periodic backup if enough time has passed since the last backup
  /// Returns true if a backup was performed, false otherwise
  Future<bool> performPeriodicBackup(
      {Duration minInterval = const Duration(minutes: 20)}) async {
    if (kIsWeb || PlatformHelpers.isTestEnvironment()) {
      return false;
    }

    // Add a small delay to allow any pending operations to complete
    await Future.delayed(const Duration(milliseconds: 100));

    try {
      // Get the database directory and path
      final directory = await DatabasePath.getDatabaseDirectory();
      final dbPath = join(directory, dbFileName);

      // Verify the database file exists before attempting backup
      if (!await File(dbPath).exists()) {
        _logger.info('Database file does not exist, skipping backup');
        return false;
      }

      // Get the database factory to ensure transaction-safe backups
      final dbFactory = PlatformHelpers.getDatabaseFactory();

      // Use a try-catch block specifically for the backup operation
      try {
        final result = await _backupManager.performPeriodicBackup(
          dbPath,
          minInterval: minInterval,
          dbFactory: dbFactory,
          currentBackupPath: dbFileName,
        );
        return result;
      } catch (e) {
        // Log the specific backup error but don't rethrow
        _logger.warning('Backup operation failed: $e');
        return false;
      }
    } catch (e) {
      _logger.warning('Error during periodic database backup setup: $e');
      return false;
    }
  }
}
