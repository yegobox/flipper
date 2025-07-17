// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:async';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:brick_supabase/testing.dart';
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_sqlite/memory_cache_provider.dart';
import 'package:brick_supabase/brick_supabase.dart' hide Supabase;
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/event_bus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http show Request;
import 'package:supabase_models/brick/brick.g.dart';
import 'package:supabase_models/brick/databasePath.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite_common/sqlite_api.dart';
import 'package:supabase_models/brick/models/configuration.model.dart';
import 'package:supabase_models/brick/models/customer.model.dart';
import 'package:supabase_models/brick/models/stock.model.dart';
import 'package:supabase_models/cache/cache_manager.dart';
import 'db/schema.g.dart';
import 'package:path/path.dart';
// ignore: depend_on_referenced_packages
import 'package:logging/logging.dart';
// ignore: depend_on_referenced_packages
export 'package:brick_core/query.dart'
    show And, Or, Query, QueryAction, Where, WherePhrase, Compare, OrderBy;

import 'repository/database_manager.dart';
import 'repository/queue_manager.dart';
import 'repository/platform_helpers.dart';
import 'repository/local_storage.dart';
import 'models/counter.model.dart';

/// Main repository class that serves as an entry point to the database operations
/// This class maintains backward compatibility with the original implementation
class Repository extends OfflineFirstWithSupabaseRepository {
  static Repository? _singleton;
  static final _logger = Logger('Repository');

  static SharedPreferenceStorage? _sharedPreferenceStorage;
  // Flag to track if the singleton has been explicitly disposed and its resources released.
  static bool _isDisposed = false;
  // Flag to prevent multiple concurrent calls to initializeSupabaseAndConfigure.
  static bool _isInitializing = false;

  // Constants for database filenames and versioning
  static const _dbFileBaseName = 'flipper';
  static const _queueFileBaseName = 'brick_offline_queue';
  static const _standardVersion = dbVersion;
  static const _mobileTargetVersion = dbVersion;

  // Flag to override version increment behavior (null = use platform default)
  static bool? _overrideVersionIncrement;

  // Managers for different responsibilities
  late final DatabaseManager _databaseManager;
  late final QueueManager _queueManager;

  // Thread-safe locks using Completer for specific operations
  static Completer<void>? _cleanupCompleter;
  static Completer<void>? _migrationCompleter;

  // Timeout for operations
  static const _operationTimeout = Duration(seconds: 30);

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
    try {
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        return _mobileTargetVersion;
      }
    } catch (e) {
      _logger.warning('Error detecting platform, using standard version: $e');
    }
    return _standardVersion;
  }

  static String get _generatedDefaultDbFileName {
    return '${_dbFileBaseName}_v$_effectiveVersion.sqlite';
  }

  static String get _generatedDefaultQueueFileName {
    return '${_queueFileBaseName}_v$_effectiveVersion.sqlite';
  }

  /// Get the shared preference storage instance
  static Future<SharedPreferenceStorage?> getSharedPreferenceStorage() async {
    if (_sharedPreferenceStorage == null) {
      try {
        _logger.info('Initializing SharedPreferenceStorage');
        final storage = SharedPreferenceStorage();
        _sharedPreferenceStorage =
            await storage.initializePreferences() as SharedPreferenceStorage;
        _logger.info('SharedPreferenceStorage initialized successfully');
      } catch (e) {
        _logger.severe('Failed to initialize SharedPreferenceStorage: $e');
        return null;
      }
    }
    return _sharedPreferenceStorage;
  }

  // Get the database filename from storage or use dynamic default
  static String get dbFileName => _generatedDefaultDbFileName;

  // Get the queue filename from storage or use dynamic default
  static String get queueName => _generatedDefaultQueueFileName;

  // Private constructor: Only called internally to create the singleton instance.
  Repository._({
    required super.supabaseProvider,
    required super.sqliteProvider,
    required super.migrations,
    required super.offlineRequestQueue,
    required String dbPath,
    super.memoryCacheProvider,
  }) {
    _databaseManager = DatabaseManager(dbFileName: dbFileName);
    _queueManager = QueueManager(offlineRequestQueue);
    // Reset the disposed flag when a new instance is successfully created.
    _isDisposed = false;
    _logger.info('FINAL DATABASE FILENAME: $dbFileName');
    _logger.info('FINAL DATABASE PATH: $dbPath');
  }

  /// Factory constructor to retrieve the singleton instance.
  /// Throws [StateError] if the repository has not been initialized
  /// or if it was previously disposed and not re-initialized.
  factory Repository() {
    // If the singleton is null or has been disposed, throw an error (unless on web).
    if (_singleton == null || _isDisposed) {
      if (kIsWeb) {
        _logger.warning(
            'Repository not initialized on web or disposed, returning dummy repository');
        return _createDummyRepository();
      } else {
        throw StateError(
            'Repository not initialized or already disposed. Call initializeSupabaseAndConfigure first.');
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
    final storage = await getSharedPreferenceStorage();
    if (storage == null) {
      throw StateError('Failed to initialize SharedPreferenceStorage');
    }

    String dbPath;
    String queuePath;

    if (kIsWeb) {
      // For web, use in-memory database or a web-specific approach
      dbPath = PlatformHelpers.getInMemoryDatabasePath();
      queuePath = PlatformHelpers.getInMemoryDatabasePath();
    } else {
      // Initialize FFI for Windows platforms (no-op on other platforms)
      PlatformHelpers.initializePlatform();

      // Get the appropriate directory path for native platforms
      final directory = await DatabasePath.getDatabaseDirectory();

      // Use the generated filenames directly
      final dbFileName = _generatedDefaultDbFileName;
      final queueFileName = _generatedDefaultQueueFileName;

      // Create database manager for initialization
      final databaseManager = DatabaseManager(dbFileName: dbFileName);

      // Ensure the database directory exists
      await databaseManager.initializeDatabaseDirectory(directory);

      // Construct the full database path
      dbPath = databaseManager.getDatabasePath(directory);
      queuePath = join(directory, queueFileName);

      // Atomically ensure the queue directory exists
      await _ensureDirectoryExists(dirname(queuePath));

      // Ensure the queue database is properly initialized (schema setup).
      // This static method opens a temporary connection and closes it.
      await _ensureQueueDatabaseInitialized(queuePath);
    }

    // Create the client and queue for OfflineFirst
    final (client, queue) = OfflineFirstWithSupabaseRepository.clientQueue(
      databaseFactory: PlatformHelpers.getDatabaseFactory(),
      databasePath: queuePath, // This is the path for the queue database
      onReattempt: (http.Request request, dynamic object) async {
        _logger.info('Reattempting offline request: ${request.url}');
        try {
          final instance = _singleton;
          if (instance != null) {
            final statusBefore = await instance._queueManager.getQueueStatus();
            _logger.info(
                'Queue status before deletion (onReattempt): $statusBefore');
            await instance._queueManager.deleteFailedRequests();
            final statusAfter = await instance._queueManager.getQueueStatus();
            _logger.info(
                'Queue status after deletion (onReattempt): $statusAfter');
          }
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
      // Use in-memory for tests/web, file path for native
      DatabasePath.isTestEnvironment() || kIsWeb
          ? PlatformHelpers.getInMemoryDatabasePath()
          : dbPath, // This is the path for the main SQLite database
      databaseFactory: PlatformHelpers.getDatabaseFactory(),
      modelDictionary: sqliteModelDictionary,
    );

    // Create and assign the singleton instance
    _singleton = Repository._(
      supabaseProvider: provider,
      sqliteProvider: sqliteProvider,
      migrations: migrations,
      offlineRequestQueue: queue,
      memoryCacheProvider: MemoryCacheProvider(),
      dbPath: dbPath,
    );

    // Configure the main database after initialization (non-web only)
    if (configureDatabase && !kIsWeb && !DatabasePath.isTestEnvironment()) {
      try {
        // Configure the database with WAL mode and other settings
        if (await File(dbPath).exists()) {
          await _singleton!._databaseManager.configureDatabaseSettings(
              dbPath, PlatformHelpers.getDatabaseFactory());
        }
      } catch (e) {
        _logger.warning('Error during database configuration: $e');
        // Continue without database configuration as it's not critical
      }
    }
  }

  /// Atomically ensure directory exists
  static Future<void> _ensureDirectoryExists(String dirPath) async {
    try {
      final dir = Directory(dirPath);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
    } catch (e) {
      _logger.severe('Failed to create directory $dirPath: $e');
      rethrow;
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
      onReattempt: (_, __) async {},
      onRequestException: (_, __) async {},
    );

    // Dummy repository also sets _isDisposed to false internally
    return Repository._(
      supabaseProvider: dummySupabaseProvider,
      sqliteProvider: dummySqliteProvider,
      migrations: migrations,
      offlineRequestQueue: dummyQueue,
      memoryCacheProvider: MemoryCacheProvider(),
      dbPath: PlatformHelpers.getInMemoryDatabasePath(),
    );
  }

  /// Initializes the Supabase client and configures the Repository.
  /// This method should be called once at the start of the application.
  /// It prevents concurrent initialization and handles re-initialization after disposal.
  static Future<void> initializeSupabaseAndConfigure({
    required String supabaseUrl,
    required String supabaseAnonKey,
    bool configureDatabase = true,
  }) async {
    // Prevent concurrent initialization attempts
    if (_isInitializing) {
      _logger.info(
          'Repository initialization already in progress, waiting or skipping.');
      // You might want to await a Completer here if multiple callers need to wait
      // for the first initialization to complete. For simplicity, we just return.
      return;
    }

    // If already initialized and not disposed, skip re-initialization
    if (_singleton != null && !_isDisposed) {
      _logger.info(
          'Repository already initialized and not disposed. Skipping re-initialization.');
      return;
    }

    _isInitializing = true;
    _logger.info(
        'Starting Repository initialization (first time or after disposal).');

    try {
      await _configureAndInitializeDatabase(
        supabaseUrl: supabaseUrl,
        supabaseAnonKey: supabaseAnonKey,
        configureDatabase: configureDatabase,
      );
      _logger.info('Repository initialization complete.');
    } finally {
      // Ensure the initialization flag is reset
      _isInitializing = false;
    }
  }

  /// Get the number of requests in the queue
  /// This method is called from CoreSync.dart
  Future<int> availableQueue() async {
    if (kIsWeb) {
      return 0;
    }
    // Check if the repository is disposed before proceeding
    if (_isDisposed) {
      _logger.warning(
          'Attempted to call availableQueue on a disposed Repository.');
      return 0;
    }
    try {
      return await _queueManager.availableQueue();
    } catch (e) {
      _logger.warning('Error getting available queue count: $e');
      return 0;
    }
  }

  /// Clear any locked requests in the queue
  /// This method is called from CoreSync.dart
  Future<void> deleteUnprocessedRequests() async {
    if (kIsWeb) {
      return;
    }
    if (_isDisposed) {
      _logger.warning(
          'Attempted to call deleteUnprocessedRequests on a disposed Repository.');
      return;
    }
    try {
      await _queueManager.deleteUnprocessedRequests();
    } catch (e) {
      _logger.warning('Error deleting unprocessed requests: $e');
    }
  }

  /// Get information about the queue status
  /// Returns a map with counts of locked (failed) and unlocked (waiting) requests
  Future<Map<String, int>> getQueueStatus() async {
    if (kIsWeb) {
      return {'locked': 0, 'unlocked': 0, 'total': 0};
    }
    if (_isDisposed) {
      _logger.warning(
          'Attempted to call getQueueStatus on a disposed Repository.');
      return {'locked': 0, 'unlocked': 0, 'total': 0};
    }
    try {
      return await _queueManager.getQueueStatus();
    } catch (e) {
      _logger.warning('Error getting queue status: $e');
      return {'locked': 0, 'unlocked': 0, 'total': 0};
    }
  }

  /// Delete only failed requests from the queue
  /// Returns the number of requests deleted
  Future<int> deleteFailedRequests() async {
    if (kIsWeb) {
      return 0;
    }
    if (_isDisposed) {
      _logger.warning(
          'Attempted to call deleteFailedRequests on a disposed Repository.');
      return 0;
    }
    try {
      return await _queueManager.deleteFailedRequests();
    } catch (e) {
      _logger.warning('Error deleting failed requests: $e');
      return 0;
    }
  }

  /// Cleanup failed requests from the queue with thread safety
  /// This method is designed to be called from CronService
  /// Returns the number of failed requests that were cleaned up
  Future<int> cleanupFailedRequests() async {
    if (kIsWeb) {
      return 0;
    }
    if (_isDisposed) {
      _logger.warning(
          'Attempted to call cleanupFailedRequests on a disposed Repository.');
      return 0;
    }

    // Thread-safe cleanup operation
    if (_cleanupCompleter != null && !_cleanupCompleter!.isCompleted) {
      _logger.info('Cleanup already in progress, waiting for completion');
      await _cleanupCompleter!.future;
      return 0;
    }

    _cleanupCompleter = Completer<void>();

    try {
      // Check if queue manager is properly initialized with timeout
      try {
        await _queueManager.getQueueStatus().timeout(_operationTimeout);
      } catch (e) {
        _logger.warning(
            'Queue manager not fully initialized or timeout, skipping cleanup: $e');
        _cleanupCompleter!.complete();
        return 0;
      }

      // Add a longer delay before cleanup to allow any pending operations to complete
      await Future.delayed(const Duration(milliseconds: 500));

      final result = await _queueManager
          .cleanupFailedRequests()
          .timeout(_operationTimeout);

      _cleanupCompleter!.complete();
      return result;
    } catch (e) {
      _logger.warning('Error during cleanup: $e');
      _cleanupCompleter!.complete();
      return 0;
    }
  }

  /// Configure the database for better crash resilience
  Future<void> configureDatabase() async {
    if (kIsWeb || PlatformHelpers.isTestEnvironment()) {
      return;
    }
    if (_isDisposed) {
      _logger.warning(
          'Attempted to call configureDatabase on a disposed Repository.');
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
      // Continue without throwing as this is not critical
    }
  }

  /// Fixed tax calculation
  static double calculateTotalTax(double tax, Configurations config) {
    final percentage = config.taxPercentage ?? 0;
    // Fixed: Add the calculated tax to the original tax amount
    return tax + (tax * percentage) / 100;
  }

  @override
  Future<TModel> upsert<TModel extends OfflineFirstWithSupabaseModel>(
    TModel instance, {
    OfflineFirstUpsertPolicy policy = OfflineFirstUpsertPolicy.optimisticLocal,
    Query? query,
  }) async {
    if (_isDisposed) {
      _logger.warning(
          'Attempted to call upsert on a disposed Repository. Operation aborted.');
      throw StateError('Repository is disposed');
    }
    try {
      instance = await super.upsert(instance, policy: policy, query: query);

      if (instance is Stock) {
        // Only upsert locally for Stock
        await CacheManager().saveStocks([instance]);
      }
      if (instance is Customer) {
        EventBus().fire(CustomerUpserted(instance));
      }

      return instance;
    } catch (e) {
      _logger.severe('Error during upsert: $e');
      rethrow;
    }
  }

  @override
  Future<bool> delete<TModel extends OfflineFirstWithSupabaseModel>(
    TModel instance, {
    OfflineFirstDeletePolicy policy = OfflineFirstDeletePolicy.optimisticLocal,
    Query? query,
  }) async {
    if (_isDisposed) {
      _logger.warning(
          'Attempted to call delete on a disposed Repository. Operation aborted.');
      throw StateError('Repository is disposed');
    }
    try {
      if (instance is Counter) {
        // Only delete locally for Counter
        return await super.delete(instance,
            policy: OfflineFirstDeletePolicy.optimisticLocal, query: query);
      }
      return await super.delete(instance, policy: policy, query: query);
    } catch (e) {
      _logger.severe('Error during delete: $e');
      rethrow;
    }
  }

  /// Ensures that the queue database is properly initialized with the required tables
  /// This is especially important for Windows platforms where migrations might fail
  static Future<void> _ensureQueueDatabaseInitialized(String queuePath) async {
    if (kIsWeb) {
      return;
    }

    _logger.info('Ensuring queue database is initialized: $queuePath');
    final dbFactory = PlatformHelpers.getDatabaseFactory();
    Database? db;

    try {
      // Open the database with explicit creation of tables
      db = await dbFactory.openDatabase(
        queuePath,
        options: OpenDatabaseOptions(
          version: 1, // Version of the queue DB schema
          onCreate: (Database database, int version) async {
            _logger.info('Creating queue database tables');
            await database.execute('''
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
          onOpen: (Database database) async {
            // Verify the table exists, create it if it doesn't
            final tables = await database.query('sqlite_master',
                columns: ['name'],
                where: "type = 'table' AND name = 'HttpJobs'");

            if (tables.isEmpty) {
              _logger
                  .warning('Queue database missing tables, creating them now');
              await database.execute('''
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

      _logger.info('Queue database initialization complete');
    } catch (e) {
      _logger.severe('Error initializing queue database: $e');
      // Try a more direct approach if the standard approach fails
      await _directQueueDatabaseInitialization(queuePath);
    } finally {
      // IMPORTANT: Properly close the temporary database connection used for schema setup.
      // This does NOT close the persistent connection created later for offlineRequestQueue.
      try {
        await db?.close();
      } catch (e) {
        _logger
            .warning('Error closing queue database during initialization: $e');
      }
    }
  }

  /// A more direct approach to initialize the queue database
  /// Used as a fallback when the standard approach fails
  static Future<void> _directQueueDatabaseInitialization(
      String queuePath) async {
    _logger.info('Attempting direct queue database initialization');
    Database? db;

    try {
      // Ensure the file exists
      await _ensureFileExists(queuePath);

      final dbFactory = PlatformHelpers.getDatabaseFactory();
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
    } catch (e) {
      _logger.severe('Direct queue database initialization failed: $e');
      rethrow;
    } finally {
      // IMPORTANT: Properly close the temporary database connection used for schema setup.
      try {
        await db?.close();
      } catch (e) {
        _logger
            .warning('Error closing database during direct initialization: $e');
      }
    }
  }

  /// Atomically ensure file exists
  static Future<void> _ensureFileExists(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        await file.create(recursive: true);
      }
    } catch (e) {
      _logger.severe('Failed to create file $filePath: $e');
      rethrow;
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
    if (_isDisposed) {
      _logger.warning(
          'Attempted to call initializeQueueWithScript on a disposed Repository.');
      return false;
    }

    // Thread-safe migration operation
    if (_migrationCompleter != null && !_migrationCompleter!.isCompleted) {
      _logger.info(
          'Another migration is already in progress, waiting for completion');
      await _migrationCompleter!.future;
      return false;
    }

    _migrationCompleter = Completer<void>();
    Database? db;

    try {
      final directory = await DatabasePath.getDatabaseDirectory();
      final queuePath = join(directory, queueName);

      // Read the SQL script file
      final file = File(sqlScriptPath);
      if (!await file.exists()) {
        _logger.severe('SQL script file not found: $sqlScriptPath');
        _migrationCompleter!.complete();
        return false;
      }

      final script = await file.readAsString();

      // Split the script into individual statements
      final statements = script
          .split(';')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      final dbFactory = PlatformHelpers.getDatabaseFactory();
      db = await dbFactory.openDatabase(queuePath);

      // Execute each statement
      for (final statement in statements) {
        await db.execute(statement);
      }

      _logger.info('Queue database initialization with script successful');
      _migrationCompleter!.complete();
      return true;
    } catch (e) {
      _logger.severe('Error initializing queue database with script: $e');
      _migrationCompleter!.complete();
      return false;
    } finally {
      // Properly close the database connection
      try {
        await db?.close();
      } catch (e) {
        _logger
            .warning('Error closing database during script initialization: $e');
      }
    }
  }
}
