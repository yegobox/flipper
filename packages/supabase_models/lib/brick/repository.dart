import 'dart:io';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:brick_supabase/testing.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_sqlite/memory_cache_provider.dart';
import 'package:brick_supabase/brick_supabase.dart' hide Supabase;
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http show Request;
import 'package:supabase_models/brick/brick.g.dart';
import 'package:supabase_models/brick/databasePath.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite_common/sqlite_api.dart';
import 'package:supabase_models/brick/models/configuration.model.dart';
import 'package:supabase_models/brick/models/customer.model.dart';
import 'package:supabase_models/brick/models/stock.model.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';
import 'package:supabase_models/services/ebm_sync_service.dart';
import 'package:supabase_models/brick/models/variant.model.dart';
import 'package:supabase_models/cache/cache_manager.dart';
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
import 'models/counter.model.dart';

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

  // Constants for database filenames and versioning
  static const _dbFileBaseName = 'flipper';
  static const _queueFileBaseName = 'brick_offline_queue';
  static const _standardVersion = 19;
  static const _mobileTargetVersion = 19;

  // Flag to override version increment behavior (null = use platform default)
  static bool? _overrideVersionIncrement;

  // Managers for different responsibilities
  late final BackupManager _backupManager;
  late final DatabaseManager _databaseManager;
  late final QueueManager _queueManager;

  // Lock detection
  static bool _isBackupInProgress = false;
  static bool _isCleanupInProgress = false;
  static bool _isMigrationInProgress = false;
  static DateTime? _lastBackupTime;

  /// Override the default version increment behavior
  ///
  /// @param incrementOverride - Controls version increment behavior:
  ///   - null: Use platform default (increment on mobile, default on others)
  ///   - true: Force increment on all platforms
  ///   - false: Force no increment on all platforms
  static void setVersionIncrementOverride(bool? incrementOverride) {
    _overrideVersionIncrement = incrementOverride;
    _logger
        .info('Database version increment override set to: $incrementOverride');
    _logger.info('Using database filename: $_generatedDefaultDbFileName');
    _logger.info('Using queue filename: $_generatedDefaultQueueFileName');
  }

  // Dynamic version getter based on platform and override flag
  static int get _effectiveVersion {
    // If override is set, use it
    if (_overrideVersionIncrement != null) {
      return _overrideVersionIncrement!
          ? _mobileTargetVersion
          : _standardVersion;
    }

    // Otherwise use platform default (mobile version on mobile platforms)
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      return _mobileTargetVersion;
    }
    return _standardVersion;
  }

  static String get _generatedDefaultDbFileName {
    return '${_dbFileBaseName}_v$_effectiveVersion.sqlite';
  }

  static String get _generatedDefaultQueueFileName {
    return '${_queueFileBaseName}_v$_effectiveVersion.sqlite';
  }

  /// Set the storage for database configuration
  static void setConfigStorage(DatabaseConfigStorage storage) {
    _configStorage = storage;
    _logger.info('Database configuration storage set');
    _logger.info('Using database filename: $dbFileName');
    _logger.info('Using queue filename: $queueName');
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

  // Get the database filename from storage or use dynamic default
  static String get dbFileName =>
      _configStorage?.getDatabaseFilename() ?? _generatedDefaultDbFileName;

  // Get the queue filename from storage or use dynamic default
  static String get queueName =>
      _configStorage?.getQueueFilename() ?? _generatedDefaultQueueFileName;

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

    // Log the final database filename being used
    _logger.info('FINAL DATABASE FILENAME: $dbFileName');
    _logger.info('FINAL DATABASE PATH: $dbPath');
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
    bool configureDatabase = true,
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

      // Ensure the queue directory exists (this was in the old implementation)
      final queueDir = Directory(dirname(queuePath));
      if (!await queueDir.exists()) {
        await queueDir.create(recursive: true);
      }

      // Ensure the queue database is properly initialized
      await _ensureQueueDatabaseInitialized(queuePath);

      // Check if the database exists and verify its integrity
      if (await File(dbPath).exists()) {
        try {
          // Try to open the database to check if it's valid
          // await connectionManager.executeOperation(
          //   dbPath,
          //   (db) async {
          //     // Just query to check if database is accessible
          //     await db.query('sqlite_master', limit: 1);
          //     return null;
          //   },
          //   busyTimeout: 5000,
          //   timeout: const Duration(seconds: 10),
          // );
          _logger.info('Database integrity check passed');
        } catch (e) {
          _logger.warning('Database corruption detected: $e');
          // Close any existing connections before restoration
          // await connectionManager.closeConnection(dbPath);

          // Database is corrupted, try to restore from backup
          final restored = await backupManager.restoreLatestBackup(
              directory, dbPath, PlatformHelpers.getDatabaseFactory());
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
      databaseFactory: PlatformHelpers.getDatabaseFactory(),
      databasePath: queuePath,
      onReattempt: (http.Request request, dynamic object) async {
        _logger.info('Reattempting offline request: ${request.url}');
        try {
          final statusBefore = await _singleton?._queueManager.getQueueStatus();
          _logger.info(
              'Queue status before deletion (onReattempt): $statusBefore');
          await _singleton?._queueManager.deleteFailedRequests();
          final statusAfter = await _singleton?._queueManager.getQueueStatus();
          _logger
              .info('Queue status after deletion (onReattempt): $statusAfter');
        } catch (e) {
          _logger.severe('Error handling queue cleanup on reattempt: $e');
        }
      },
      onRequestException: (request, object) async {
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
      databaseFactory: PlatformHelpers.getDatabaseFactory(),
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
    if (configureDatabase && !kIsWeb && !DatabasePath.isTestEnvironment()) {
      try {
        // Backup creation moved to explicit calls
        // Database backups should be called explicitly using performPeriodicBackup() or backupDatabase()
        // instead of during initialization to improve startup performance
        // if (await File(dbPath).exists()) {
        //   await _singleton!._backupManager.createVersionedBackup(dbPath);
        // }

        // Configure the database with WAL mode and other settings
        if (await File(dbPath).exists()) {
          await _singleton!._databaseManager.configureDatabaseSettings(
              dbPath, PlatformHelpers.getDatabaseFactory());
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
      onRequestException: (_, __) async {},
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
    bool configureDatabase = true,
  }) async {
    // Use the helper method to initialize and configure the database
    await _configureAndInitializeDatabase(
      supabaseUrl: supabaseUrl,
      supabaseAnonKey: supabaseAnonKey,
      configureDatabase: configureDatabase,
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

    // Prevent concurrent cleanup operations
    if (_isCleanupInProgress) {
      _logger.info('Cleanup already in progress, skipping');
      return 0;
    }

    _isCleanupInProgress = true;

    try {
      // Check if queue manager is properly initialized
      try {
        // This will throw an exception if not properly initialized
        await _queueManager.getQueueStatus();
      } catch (e) {
        _logger.warning(
            'Queue manager not fully initialized, skipping cleanup: $e');
        _isCleanupInProgress = false;
        return 0;
      }

      // Add a longer delay before cleanup to allow any pending operations to complete
      await Future.delayed(const Duration(milliseconds: 500));

      final result = await _queueManager.cleanupFailedRequests();
      _isCleanupInProgress = false;
      return result;
    } catch (e) {
      _logger.warning('Error during cleanup: $e');
      _isCleanupInProgress = false;
      return 0;
    }
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

    // Prevent concurrent backup operations
    if (_isBackupInProgress) {
      _logger.info('Backup already in progress, skipping');
      return false;
    }

    // Check if enough time has passed since the last backup
    if (_lastBackupTime != null) {
      final timeSinceLastBackup = DateTime.now().difference(_lastBackupTime!);
      if (timeSinceLastBackup < minInterval) {
        _logger.fine('Not enough time passed since last backup, skipping');
        return false;
      }
    }

    _isBackupInProgress = true;

    // Reduced delay to improve performance (was 500ms)
    await Future.delayed(const Duration(milliseconds: 100));

    try {
      // Get the database directory and path
      final directory = await DatabasePath.getDatabaseDirectory();
      final dbPath = join(directory, dbFileName);

      // Verify the database file exists before attempting backup
      if (!await File(dbPath).exists()) {
        _logger.info('Database file does not exist, skipping backup');
        _isBackupInProgress = false;
        return false;
      }

      // Get the database factory to ensure transaction-safe backups
      final dbFactory = PlatformHelpers.getDatabaseFactory();

      // Use a try-catch block specifically for the backup operation
      try {
        // Close any active connections before backup
        await _databaseManager.closeAllConnections();

        final result = await _backupManager.performPeriodicBackup(
          dbPath,
          minInterval: minInterval,
          dbFactory: dbFactory,
          currentBackupPath: dbFileName,
        );

        if (result) {
          _lastBackupTime = DateTime.now();
        }

        _isBackupInProgress = false;
        return result;
      } catch (e) {
        // Log the specific backup error but don't rethrow
        _logger.warning('Backup operation failed: $e');
        _isBackupInProgress = false;
        return false;
      }
    } catch (e) {
      _logger.warning('Error during periodic database backup setup: $e');
      _isBackupInProgress = false;
      return false;
    }
  }

  static double calculateTotalTax(double tax, Configurations config) {
    final percentage = config.taxPercentage ?? 0;
    return (tax * percentage) / 100 + percentage;
  }

  @override
  Future<TModel> upsert<TModel extends OfflineFirstWithSupabaseModel>(
    TModel instance, {
    OfflineFirstUpsertPolicy policy = OfflineFirstUpsertPolicy.optimisticLocal,
    Query? query,
  }) async {
    if (instance is Counter) {
      // Only upsert locally for Counter
      return await super.upsert(instance,
          policy: OfflineFirstUpsertPolicy.optimisticLocal, query: query);
    }
    if (instance is Stock) {
      // Only upsert locally for Stock
      await CacheManager().saveStocks([instance]);
    }
    if (instance is ITransaction) {
      if (instance.ebmSynced == false &&
          instance.transactionType == TransactionType.adjustment &&
          instance.status == COMPLETE &&
          instance.items?.isNotEmpty == true) {
        final serverUrl = await ProxyService.box.getServerUrl();
        final ebmSyncService = EbmSyncService(this);
        await ebmSyncService.syncTransactionWithEbm(
          instance: instance,
          serverUrl: serverUrl!,
        );
      }
    }
    if (instance is Customer) {
      if (instance.ebmSynced == false) {
        final serverUrl = await ProxyService.box.getServerUrl();
        final ebmSyncService = EbmSyncService(this);
        await ebmSyncService.syncCustomerWithEbm(
          instance: instance,
          serverUrl: serverUrl!,
        );
      }
    }
    if (instance is Variant) {
      if (instance.ebmSynced == false) {
        final serverUrl = await ProxyService.box.getServerUrl();
        final ebmSyncService = EbmSyncService(this);
        final synced = await ebmSyncService.syncVariantWithEbm(
          variant: instance,
          serverUrl: serverUrl!,
        );
        if (synced) {
          return instance;
        }
      }
    }
    return await super.upsert(instance, policy: policy, query: query);
  }

  @override
  Future<bool> delete<TModel extends OfflineFirstWithSupabaseModel>(
    TModel instance, {
    OfflineFirstDeletePolicy policy = OfflineFirstDeletePolicy.optimisticLocal,
    Query? query,
  }) async {
    if (instance is Counter) {
      // Only delete locally for Counter
      return await super.delete(instance,
          policy: OfflineFirstDeletePolicy.optimisticLocal, query: query);
    }
    return await super.delete(instance, policy: policy, query: query);
  }

  /// Ensures that the queue database is properly initialized with the required tables
  /// This is especially important for Windows platforms where migrations might fail
  static Future<void> _ensureQueueDatabaseInitialized(String queuePath) async {
    if (kIsWeb) {
      return;
    }

    _logger.info('Ensuring queue database is initialized: $queuePath');
    final dbFactory = PlatformHelpers.getDatabaseFactory();

    try {
      // Open the database with explicit creation of tables
      final db = await dbFactory.openDatabase(
        queuePath,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (Database db, int version) async {
            _logger.info('Creating queue database tables');
            await db.execute('''
              CREATE TABLE IF NOT EXISTS "HttpJobs" (
                "id" INTEGER,
                "attempts" INTEGER DEFAULT 1,
                "body" TEXT,
                "encoding" TEXT,
                "headers" TEXT,
                "locked" INTEGER DEFAULT 0,
                "request_method" TEXT,
                "updated_at" INTEGER DEFAULT 0,
                "url" TEXT,
                "created_at" INTEGER DEFAULT 0,
                PRIMARY KEY("id" AUTOINCREMENT)
              );
            ''');
          },
          onOpen: (Database db) async {
            // Verify the table exists, create it if it doesn't
            final tables = await db.query('sqlite_master',
                columns: ['name'],
                where: "type = 'table' AND name = 'HttpJobs'");

            if (tables.isEmpty) {
              _logger
                  .warning('Queue database missing tables, creating them now');
              await db.execute('''
                CREATE TABLE IF NOT EXISTS "HttpJobs" (
                  "id" INTEGER,
                  "attempts" INTEGER DEFAULT 1,
                  "body" TEXT,
                  "encoding" TEXT,
                  "headers" TEXT,
                  "locked" INTEGER DEFAULT 0,
                  "request_method" TEXT,
                  "updated_at" INTEGER DEFAULT 0,
                  "url" TEXT,
                  "created_at" INTEGER DEFAULT 0,
                  PRIMARY KEY("id" AUTOINCREMENT)
                );
              ''');
            } else {
              _logger.info('Queue database tables verified');
            }
          },
        ),
      );

      await db.close();
      _logger.info('Queue database initialization complete');
    } catch (e) {
      _logger.severe('Error initializing queue database: $e');
      // Try a more direct approach if the standard approach fails
      await _directQueueDatabaseInitialization(queuePath);
    }
  }

  /// A more direct approach to initialize the queue database
  /// Used as a fallback when the standard approach fails
  static Future<void> _directQueueDatabaseInitialization(
      String queuePath) async {
    _logger.info('Attempting direct queue database initialization');

    try {
      // If the file doesn't exist, create it
      final file = File(queuePath);
      if (!await file.exists()) {
        await file.create(recursive: true);
      }

      final dbFactory = PlatformHelpers.getDatabaseFactory();
      Database? db;

      try {
        db = await dbFactory.openDatabase(queuePath);

        // Create the requests table directly
        await db.execute('''
          CREATE TABLE IF NOT EXISTS "HttpJobs" (
            "id" INTEGER,
            "attempts" INTEGER DEFAULT 1,
            "body" TEXT,
            "encoding" TEXT,
            "headers" TEXT,
            "locked" INTEGER DEFAULT 0,
            "request_method" TEXT,
            "updated_at" INTEGER DEFAULT 0,
            "url" TEXT,
            "created_at" INTEGER DEFAULT 0,
            PRIMARY KEY("id" AUTOINCREMENT)
          );
        ''');

        _logger.info('Direct queue database initialization successful');
      } finally {
        await db?.close();
      }
    } catch (e) {
      _logger.severe('Direct queue database initialization failed: $e');
    }
  }

  /// Manually initialize the queue database with a SQL script
  /// This can be used as a last resort when other methods fail
  ///
  /// [sqlScriptPath] - Path to the SQL script file for the queue database
  /// Returns true if successful, false otherwise
  Future<bool> initializeQueueWithScript(String sqlScriptPath) async {
    if (kIsWeb) {
      _logger.warning('Cannot initialize queue database on web platform');
      return false;
    }

    if (_isMigrationInProgress) {
      _logger.info('Another migration is already in progress, skipping');
      return false;
    }

    _isMigrationInProgress = true;

    try {
      final directory = await DatabasePath.getDatabaseDirectory();
      final queuePath = join(directory, queueName);

      // Read the SQL script file
      final file = File(sqlScriptPath);
      if (!await file.exists()) {
        _logger.severe('SQL script file not found: $sqlScriptPath');
        _isMigrationInProgress = false;
        return false;
      }

      final script = await file.readAsString();

      // Close any active connections to the queue database
      // We don't have direct access to close connections through QueueManager
      // so we'll rely on the database factory's mechanisms

      // Split the script into individual statements
      final statements = script
          .split(';')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      final dbFactory = PlatformHelpers.getDatabaseFactory();
      Database? db;

      try {
        db = await dbFactory.openDatabase(queuePath);

        // Execute each statement
        for (final statement in statements) {
          await db.execute(statement);
        }

        _logger.info('Queue database initialization with script successful');
        _isMigrationInProgress = false;
        return true;
      } finally {
        await db?.close();
      }
    } catch (e) {
      _logger.severe('Error initializing queue database with script: $e');
      _isMigrationInProgress = false;
      return false;
    }
  }
}
