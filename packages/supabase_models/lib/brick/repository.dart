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
import 'package:flipper_services/supabase_session_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http show Client, Request;
import 'package:supabase_models/brick/brick.g.dart';
import 'package:supabase_models/brick/databasePath.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:sqflite_common/sqlite_api.dart';
import 'package:supabase_models/supabase_models.dart';
import 'db/schema.g.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationSupportDirectory;
// ignore: depend_on_referenced_packages
import 'package:logging/logging.dart';
// ignore: depend_on_referenced_packages
export 'package:brick_core/query.dart'
    show And, Or, Query, QueryAction, Where, WherePhrase, Compare, OrderBy;

import 'repository/auth_refreshing_client.dart';
import 'repository/database_manager.dart';
import 'repository/legacy_database_migration.dart';
import 'repository/main_db_opener.dart';
import 'repository/queue_manager.dart';
import 'package:brick_sqlite/turso.dart' show TursoReplicaPaths;
import 'repository/platform_helpers.dart';
import 'repository/local_storage.dart';
import 'package:supabase_models/brick/models/counter.model.dart';
import 'package:supabase_models/brick/models/log.model.dart';
import 'package:supabase_models/brick/models/pending_analytics_event.model.dart';
import 'package:supabase_models/sync/ditto_sync_coordinator.dart';

/// Main repository class that serves as an entry point to the database operations
/// This class maintains backward compatibility with the original implementation
class Repository extends OfflineFirstWithSupabaseRepository {
  static Repository? _singleton;
  static final _logger = Logger('Repository');

  static SharedPreferenceStorage? _sharedPreferenceStorage;
  // Flag to track if the singleton has been explicitly disposed and its resources released.
  static bool _isDisposed = false;
  static final Completer<void> _readyCompleter = Completer<void>();
  // The in-flight initialization attempt, if any. Concurrent callers await it
  // rather than returning early: a caller that returns while initialization is
  // still running goes on to touch `Repository()` and hits
  // "Repository not initialized", which reads as a hard startup failure even
  // though the real attempt was merely still in progress.
  static Future<void>? _initializationInFlight;

  // Set once the published singleton's main DB has opened and migrated, so
  // initialize() does not migrate a second time.
  static bool _migrated = false;

  static String? _mainDbTier;
  static List<LocalDbTierFailure> _mainDbFallbacks = const [];
  static String? _queueDbTier;

  /// Which way the main Brick DB was opened (`sqflite`, `turso`, `memory`, …).
  static String? get mainDbTier => _mainDbTier;

  /// Why earlier tiers were skipped past. Empty on a healthy device.
  static List<LocalDbTierFailure> get mainDbFallbacks => _mainDbFallbacks;

  /// Which way the offline request queue DB was opened.
  static String? get queueDbTier => _queueDbTier;

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
  static Completer<void>? _migrationCompleter;

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
    // Phones keep Brick in the OS's SQLite; a separate name keeps it from ever
    // opening a file that Turso wrote (different WAL and sync sidecars).
    if (!kIsWeb && !PlatformHelpers.usesTursoMainDatabase) {
      return '${_dbFileBaseName}_mobile.sqlite';
    }
    return '$_dbFileBaseName.sqlite';
  }

  /// The Turso-era main DB that phones no longer open.
  static const _retiredTursoDbFileName = '$_dbFileBaseName.sqlite';

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

  static bool get isReady => _singleton != null && !_isDisposed;

  static Future<void> waitUntilReady(
      {Duration timeout = const Duration(seconds: 15)}) async {
    if (isReady) {
      if (!_readyCompleter.isCompleted) {
        _readyCompleter.complete();
      }
      return;
    }

    _logger.info(
        'Waiting for Repository to be ready (timeout: ${timeout.inSeconds}s)...');

    try {
      await _readyCompleter.future.timeout(
        timeout,
        onTimeout: () {
          _logger.warning(
              'Repository.waitUntilReady() timed out after ${timeout.inSeconds}s');
          throw TimeoutException(
            'Repository initialization timed out',
            timeout,
          );
        },
      );
      _logger.info('Repository is ready');
    } catch (e) {
      _logger.severe('Error waiting for Repository: $e');
      rethrow;
    }
  }

  static void _markReady() {
    if (!_readyCompleter.isCompleted) {
      _readyCompleter.complete();
    }
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
  }) async {
    print('🚀 [Repository] Getting SharedPreferenceStorage...');
    final storage = await getSharedPreferenceStorage();
    if (storage == null) {
      // The database does not read preferences; losing them must not stop
      // the till from opening.
      _logger.warning(
          'SharedPreferenceStorage unavailable; continuing without it');
    } else {
      print('✅ [Repository] SharedPreferenceStorage acquired');
    }

    final inMemoryPath = PlatformHelpers.getInMemoryDatabasePath();
    String? directory;
    String dbPath;
    String queuePath;

    if (kIsWeb) {
      // For web, use in-memory database or a web-specific approach
      dbPath = inMemoryPath;
      queuePath = inMemoryPath;
    } else {
      print('🚀 [Repository] Initializing platform...');
      PlatformHelpers.initializePlatform();
      print('✅ [Repository] Platform initialized');

      print('🚀 [Repository] Getting database directory...');
      directory = await _resolveDatabaseDirectory();

      if (directory == null) {
        // Nowhere to write: boot on in-memory databases rather than not at all.
        dbPath = inMemoryPath;
        queuePath = inMemoryPath;
      } else {
        final dbFileName = _generatedDefaultDbFileName;
        final databaseManager = DatabaseManager(dbFileName: dbFileName);

        // The v4x files predate the move to Turso; phones start a fresh
        // sqflite cache instead of seeding it from a stale copy.
        if (PlatformHelpers.usesTursoMainDatabase) {
          try {
            await migrateLegacyMainDatabaseIfNeeded(
              directory: directory,
              targetFileName: dbFileName,
            );
          } catch (e) {
            _logger.warning('Legacy main DB migration skipped: $e');
          }
        }

        dbPath = databaseManager.getDatabasePath(directory);
        queuePath = join(directory, _generatedDefaultQueueFileName);
        print('✅ [Repository] Paths constructed: $dbPath, $queuePath');
        PlatformHelpers.registerMainDatabasePath(dbPath);
      }

      queuePath = await _initializeQueueDatabaseWithFallback(queuePath);
      print('✅ [Repository] Queue database initialized ($_queueDbTier)');
    }

    // Create the client and queue for OfflineFirst
    final (client, queue) = OfflineFirstWithSupabaseRepository.clientQueue(
      databaseFactory: PlatformHelpers.getQueueDatabaseFactory(),
      databasePath: queuePath, // This is the path for the queue database
      // Stamps a live access token onto every request, including queue
      // replays, which would otherwise carry the JWT frozen at enqueue time.
      innerClient: AuthRefreshingClient(
        http.Client(),
        anonKey: supabaseAnonKey,
        // Lets the transport itself sign back in (not just refresh) when a
        // request finds no active session — see auth_refreshing_client.dart.
        tokenSource: SupabaseAccessTokenSource(
          ensureAccessToken: SupabaseSessionService.ensureAccessToken,
        ),
      ),
      // Only transport, throttling and server-side failures are worth
      // replaying. Brick's default list contains 401/403 (and 404), which means
      // a rejection the server will never change its mind about is retried
      // forever; because the queue is serial and ordered by created_at, one
      // such job sits at the head and blocks every other pending write. The
      // same argument rules out 400/405 — a malformed request or a wrong verb
      // is terminal. AuthRefreshingClient already holds requests back with a
      // synthetic 503 while there is no session, so a 401/403 that still
      // reaches us is genuine and the job should be dropped.
      reattemptForStatusCodes: const [408, 429, 500, 502, 503, 504],
      onReattempt: (http.Request request, dynamic object) async {
        _logger.info('Reattempting offline request: ${request.url}');
      },
      onRequestException: (request, object) async {
        try {
          _logger.warning('Offline request failed: ${request.url}');
        } catch (e) {
          _logger.severe('Error handling offline request exception: $e');
        }
      },
    );

    // Tags each write with the signed-in uid. This has to wrap the queue
    // rather than sit inside it: the queue serializes headers into SQLite
    // before AuthRefreshingClient runs, so a stamp applied further down would
    // never be persisted alongside the job.
    final stampingClient = EnqueuedUserStampClient(client);

    final SupabaseClient supabaseClient;
    final mock = SupabaseMockServer(modelDictionary: supabaseModelDictionary);

    if (DatabasePath.isTestEnvironment()) {
      debugPrint('Using mocked Supabase client in test environment');
      // Use the mocked client in a test environment
      await mock.setUp();
      supabaseClient = SupabaseClient(mock.serverUrl, mock.apiKey,
          httpClient: stampingClient);
    } else {
      debugPrint('Using real Supabase client in non-test environment');
      // Initialize the real Supabase client in a non-test environment
      supabaseClient = (await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
        httpClient: stampingClient,
      ))
          .client;
    }

    final provider = SupabaseProvider(
      supabaseClient,
      modelDictionary: supabaseModelDictionary,
    );

    // Open and migrate the main DB before publishing the singleton. Publishing
    // first meant a failed open stayed cached (SqliteProvider memoizes its
    // open future) while the next attempt saw "already initialized" and
    // skipped setup, so "Try again" could never recover.
    final opened = await openFirstWorkingTier<Repository>(
      tiers: _mainDbTiers(
        dbPath: dbPath,
        directory: directory,
        inMemoryPath: inMemoryPath,
      ),
      attempt: (tier) => _openMainDbCandidate(
        tier,
        (sqliteProvider) => Repository._(
          supabaseProvider: provider,
          sqliteProvider: sqliteProvider,
          migrations: migrations,
          offlineRequestQueue: queue,
          memoryCacheProvider: MemoryCacheProvider(),
          dbPath: tier.path,
        ),
      ),
      discardLate: (orphan) => orphan._closeMainDbQuietly(),
    );
    _singleton = opened.value;
    _migrated = true;
    _mainDbTier = opened.tier.name;
    _mainDbFallbacks = opened.failures;
    print('✅ [Repository] Main DB ready (${opened.tier.name})');

    if (!kIsWeb &&
        !PlatformHelpers.usesTursoMainDatabase &&
        directory != null) {
      // Reclaim the space held by the Turso-era file phones no longer open.
      final retired = join(directory, _retiredTursoDbFileName);
      unawaited(deleteDatabaseFilesQuietly(
        retired,
        sidecars: TursoReplicaPaths.syncSidecarPaths(retired),
      ));
    }

    // Clear jobs that have already exhausted their reattempts. Queues in the
    // field can hold requests that looped on a 401 for as long as the app has
    // been installed, blocking every write behind them.
    final purged = await _singleton!.purgeExhaustedQueue();
    if (purged > 0) {
      _logger.warning('Purged $purged exhausted offline queue request(s)');
    }

    _markReady();
    print('✅ [Repository] Repository marked as ready');
  }

  /// Main DB tiers, best first. Every list ends in an in-memory database so a
  /// device that can install Flipper can always boot it.
  static List<LocalDbTier> _mainDbTiers({
    required String dbPath,
    required String? directory,
    required String inMemoryPath,
  }) {
    final memory = LocalDbTier(
      name: 'memory',
      path: inMemoryPath,
      factory: PlatformHelpers.getQueueDatabaseFactory,
    );
    if (kIsWeb) {
      return [memory];
    }
    if (directory == null) {
      return [memory];
    }

    final engine = PlatformHelpers.usesTursoMainDatabase ? 'turso' : 'sqflite';
    final tiers = <LocalDbTier>[
      LocalDbTier(
        name: engine,
        path: dbPath,
        factory: () => PlatformHelpers.getMainDatabaseFactory(dbPath),
        // Turso's own cloud connect can take 20s before it falls back to the
        // local replica.
        timeout: const Duration(seconds: 30),
      ),
      LocalDbTier(
        name: '$engine-fresh',
        path: dbPath,
        factory: () => PlatformHelpers.getMainDatabaseFactory(dbPath),
        prepare: freshFileAfterCorruption(
          dbPath,
          extraSidecars: PlatformHelpers.usesTursoMainDatabase
              ? TursoReplicaPaths.syncSidecarPaths(dbPath)
              : const [],
          beforeMove: () {
            // A new Turso factory, so the failed one's state is not reused.
            PlatformHelpers.clearMainDatabaseFactoryCache();
            PlatformHelpers.registerMainDatabasePath(dbPath);
          },
        ),
      ),
    ];
    if (PlatformHelpers.usesTursoMainDatabase) {
      // Desktop only: the OS/FFI SQLite on a separate file when Turso itself
      // cannot run.
      tiers.add(LocalDbTier(
        name: 'sqflite-fallback',
        path: join(directory, '${_dbFileBaseName}_fallback.sqlite'),
        factory: PlatformHelpers.getQueueDatabaseFactory,
      ));
    }
    tiers.add(memory);
    return tiers;
  }

  /// Builds a Repository on [tier] and proves the DB works by creating the
  /// analytics table and running migrations. Closes it again on failure.
  static Future<Repository> _openMainDbCandidate(
    LocalDbTier tier,
    Repository Function(SqliteProvider sqliteProvider) build,
  ) async {
    final candidate = build(SqliteProvider(
      tier.path,
      databaseFactory: tier.factory(),
      modelDictionary: sqliteModelDictionary,
    ));
    try {
      await candidate._ensurePendingAnalyticsEventTable();
      await candidate._migrateMainDb();
      return candidate;
    } catch (_) {
      await candidate._closeMainDbQuietly();
      rethrow;
    }
  }

  /// [migrate] minus the queue: a broken queue DB must not disqualify a
  /// working main DB (the queue has its own fallback).
  Future<void> _migrateMainDb() async {
    final lastVersion = await sqliteProvider.lastMigrationVersion();
    await sqliteProvider
        .migrate(migrationManager.migrationsSince(lastVersion));
  }

  /// Closes the connection only. Not [SqliteProvider.resetDb], which deletes
  /// the database file and reopens it.
  Future<void> _closeMainDbQuietly() async {
    try {
      // ignore: invalid_use_of_protected_member
      await (await sqliteProvider.getDb()).close();
    } catch (e) {
      _logger.fine('Closing unused main DB candidate: $e');
    }
  }

  /// The platform database directory, or null when none can be had — the
  /// caller then runs on in-memory databases.
  static Future<String?> _resolveDatabaseDirectory() async {
    try {
      final directory = await DatabasePath.getDatabaseDirectory()
          .timeout(const Duration(seconds: 10));
      await _ensureDirectoryExists(directory);
      return directory;
    } catch (e) {
      _logger.severe('Database directory unavailable: $e');
    }
    try {
      final support = await getApplicationSupportDirectory()
          .timeout(const Duration(seconds: 10));
      final directory = join(support.path, 'db');
      await _ensureDirectoryExists(directory);
      return directory;
    } catch (e) {
      _logger.severe('Application support directory unavailable: $e');
      return null;
    }
  }

  /// Sets up the offline queue DB and returns the path the queue should use.
  /// A queue that cannot open is moved aside (its pending jobs stay on disk
  /// for recovery) and recreated; failing that, the queue runs in memory for
  /// this session so Supabase still initializes.
  static Future<String> _initializeQueueDatabaseWithFallback(
      String queuePath) async {
    final inMemoryPath = PlatformHelpers.getInMemoryDatabasePath();
    if (queuePath == inMemoryPath) {
      _queueDbTier = 'memory';
      return inMemoryPath;
    }
    Object? lastError;
    for (final fresh in [false, true]) {
      try {
        if (fresh) {
          if (lastError != null && isLocalDbLockError(lastError)) {
            break;
          }
          await quarantineDatabaseFiles(queuePath);
        }
        await _ensureQueueDatabaseInitialized(queuePath)
            .timeout(const Duration(seconds: 15));
        _queueDbTier = fresh ? 'sqflite-fresh' : 'sqflite';
        return queuePath;
      } catch (e) {
        lastError = e;
        _logger.severe('Queue database unavailable at $queuePath: $e');
      }
    }
    _queueDbTier = 'memory';
    return inMemoryPath;
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

  /// Disposes of the repository and its resources.
  /// This closes all database connections and resets the singleton instance.
  static Future<void> dispose() async {
    if (_singleton == null) return;

    _logger.info('Disposing Repository and closing connections...');
    try {
      // 1. Stop the offline request queue
      _singleton!.offlineRequestQueue.stop();

      // 2. Close all database connections
      await _singleton!._databaseManager.closeAllConnections();

      _logger.info('Repository disposed successfully');
    } catch (e) {
      _logger.warning('Error during Repository disposal: $e');
    } finally {
      // 3. Reset the singleton and mark as disposed
      _singleton = null;
      _isDisposed = true;
      _migrated = false;
      PlatformHelpers.clearMainDatabaseFactoryCache();
    }
  }

  /// Initializes the Supabase client and configures the Repository.
  /// This method should be called once at the start of the application.
  /// It prevents concurrent initialization and handles re-initialization after disposal.
  static Future<void> initializeSupabaseAndConfigure({
    required String supabaseUrl,
    required String supabaseAnonKey,
  }) async {
    // Join an attempt that is already running instead of racing it.
    final inFlight = _initializationInFlight;
    if (inFlight != null) {
      _logger.info(
          'Repository initialization already in progress, awaiting it.');
      return inFlight;
    }

    // If already initialized and not disposed, skip re-initialization
    if (_singleton != null && !_isDisposed) {
      _logger.info(
          'Repository already initialized and not disposed. Skipping re-initialization.');
      _markReady();
      return;
    }

    _logger.info(
        'Starting Repository initialization (first time or after disposal).');

    final attempt = _initialize(
      supabaseUrl: supabaseUrl,
      supabaseAnonKey: supabaseAnonKey,
    );
    _initializationInFlight = attempt;
    try {
      await attempt;
    } finally {
      _initializationInFlight = null;
    }
  }

  static Future<void> _initialize({
    required String supabaseUrl,
    required String supabaseAnonKey,
  }) async {
    try {
      print('🚀 [Repository] Starting _configureAndInitializeDatabase...');
      await _configureAndInitializeDatabase(
        supabaseUrl: supabaseUrl,
        supabaseAnonKey: supabaseAnonKey,
      );
      print('✅ [Repository] _configureAndInitializeDatabase completed');
      _logger.info('Repository initialization complete.');
      _markReady();
    } catch (e, s) {
      print('❌ [Repository] Initialization failed: $e');
      print('❌ [Repository] Stack trace: $s');
      rethrow;
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

  /// Drop queued requests that have exhausted their reattempts.
  /// Returns the number of requests deleted.
  Future<int> purgeExhaustedQueue() async {
    if (kIsWeb) {
      return 0;
    }
    if (_isDisposed) {
      _logger.warning(
          'Attempted to call purgeExhaustedQueue on a disposed Repository.');
      return 0;
    }
    try {
      return await _queueManager.purgeExhaustedRequests();
    } catch (e) {
      _logger.warning('Error purging exhausted queue: $e');
      return 0;
    }
  }

  /// No-op: main Brick DB uses Turso (no sqflite PRAGMA pass).
  Future<void> configureDatabase() async {
    if (kIsWeb) {
      return;
    }
    _logger.fine('configureDatabase skipped — main DB uses Turso');
  }

  /// Startup path: run local migrations immediately; Turso Cloud pull/push runs
  /// in the background so network latency cannot block the 60s app init budget.
  @override
  Future<void> initialize() async {
    print('🚀 [Repository] initialize() started');
    if (_migrated) {
      // The main DB migrated while it was being opened; only the queue's
      // schema is left, and a failure there must not block startup.
      try {
        await offlineRequestQueue.client.requestManager.migrate();
      } catch (e) {
        _logger.severe('Offline queue migration failed: $e');
      }
    } else {
      await migrate();
    }
    offlineRequestQueue.start();
    unawaited(_backgroundTursoSync());
    print('✅ [Repository] initialize() completed (Turso sync in background)');
  }

  static const _backgroundTursoSyncTimeout = Duration(seconds: 45);

  Future<void> _backgroundTursoSync() async {
    try {
      _logger.info('Background Turso sync starting');
      await sync().timeout(
        _backgroundTursoSyncTimeout,
        onTimeout: () {
          throw TimeoutException(
            'Background Turso sync timed out after '
            '${_backgroundTursoSyncTimeout.inSeconds}s',
            _backgroundTursoSyncTimeout,
          );
        },
      );
      _logger.info('Background Turso sync completed');
    } catch (e, stackTrace) {
      _logger.warning(
        'Background Turso sync failed; local DB and Supabase hydrate remain available. '
        'Error: $e',
        e,
        stackTrace,
      );
    }
  }

  /// Fixed tax calculation
  static double calculateTotalTax(double tax, Configurations config) {
    final percentage = config.taxPercentage ?? 0;
    // Fixed: Add the calculated tax to the original tax amount
    return tax + (tax * percentage) / 100;
  }

  @override
  Future<bool> delete<TModel extends OfflineFirstWithSupabaseModel>(
    TModel instance, {
    OfflineFirstDeletePolicy policy = OfflineFirstDeletePolicy.optimisticLocal,
    Query? query,
  }) async {
    try {
      final result = await super.delete(
        instance,
        policy: OfflineFirstDeletePolicy.optimisticLocal,
        query: query,
      );
      if (result) {
        unawaited(DittoSyncCoordinator.instance.notifyLocalDelete(instance));
      }
      return result;
    } on PostgrestException catch (e) {
      logger.warning('#delete supabase failure: $e');
      unawaited(DittoSyncCoordinator.instance.notifyLocalDelete(instance));
      //throw OfflineFirstException(e);
      return false;
    } on AuthRetryableFetchException catch (e) {
      logger.warning('#delete supabase failure: $e');
      throw OfflineFirstException(e);
    } catch (e, stackTrace) {
      logger.severe('#delete unexpected failure: $e', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<TModel> upsert<TModel extends OfflineFirstWithSupabaseModel>(
    TModel instance, {
    OfflineFirstUpsertPolicy policy = OfflineFirstUpsertPolicy.optimisticLocal,
    Query? query,
    bool skipDittoSync = false,
  }) async {
    if (_isDisposed) {
      _logger.warning(
          'Attempted to call upsert on a disposed Repository. Operation aborted.');
      throw StateError('Repository is disposed');
    }
    try {
      debugPrint('Upserting: ${instance.toString()}');
      if (instance is ITransaction) {
        instance.items ??= [];
      }
      if (instance is TransactionItem) {
        debugPrint('We got item to save: ${instance.toString()}');
      }
      instance = await super.upsert(instance, policy: policy, query: query);
      // Counters and Stocks are Capella/Ditto-owned at runtime. Never push Brick
      // rows into Ditto — sale deducts skip Brick, and a stale Brick Stock upsert
      // would clobber live on-hand qty via sendOnly sync.
      if (!skipDittoSync && instance is! Counter && instance is! Stock) {
        if (instance is TransactionItem) {
          debugPrint('We got item to save: ${instance.toString()}');
        }
        try {
          unawaited(
            DittoSyncCoordinator.instance.notifyLocalUpsert(instance),
          );
        } catch (e, stackTrace) {
          _logger.warning(
              'Error notifying Ditto of local change: $e', stackTrace);
        }
      }

      return instance;
    } catch (e, stackTrace) {
      _logger.severe('Error during upsert: $e', stackTrace);
      rethrow;
    }
  }

  /// Append-only log insert via the standard offline-first path:
  /// local Turso → offline HTTP queue → Supabase PostgREST.
  Future<Log> insertLog(Log log) async {
    if (_isDisposed) {
      throw StateError('Repository is disposed');
    }

    final entry = Log(
      message: log.message,
      type: log.type,
      businessId: log.businessId,
      createdAt: log.createdAt ?? DateTime.now().toUtc(),
      tags: log.tags,
      extra: log.extra,
    );

    return super.upsert<Log>(
      entry,
      policy: OfflineFirstUpsertPolicy.optimisticLocal,
      query: const Query(
        forProviders: [
          SupabaseProviderQuery(upsertMethod: UpsertMethod.insert),
        ],
      ),
    );
  }

  Future<void> enqueueAnalyticsEvent(PendingAnalyticsEventRecord event) async {
    if (_isDisposed) {
      throw StateError('Repository is disposed');
    }
    await _ensurePendingAnalyticsEventTable();
    final db = await sqliteProvider.getDb();
    await db.insert(
      'PendingAnalyticsEvents',
      {
        'id': event.id,
        'event_name': event.eventName,
        'properties_json': event.propertiesJson,
        'event_type': event.eventType,
        'created_at': event.createdAt.toUtc().toIso8601String(),
        'attempt_count': event.attemptCount,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<PendingAnalyticsEventRecord>> getPendingAnalyticsEvents({
    int limit = 50,
  }) async {
    if (_isDisposed) {
      throw StateError('Repository is disposed');
    }
    await _ensurePendingAnalyticsEventTable();
    final db = await sqliteProvider.getDb();
    final rows = await db.query(
      'PendingAnalyticsEvents',
      orderBy: 'created_at ASC',
      limit: limit,
    );
    return rows
        .map(
          (row) => PendingAnalyticsEventRecord(
            id: row['id'] as String,
            eventName: row['event_name'] as String,
            propertiesJson: row['properties_json'] as String,
            eventType: row['event_type'] as String,
            createdAt: DateTime.parse(row['created_at'] as String).toUtc(),
            attemptCount: (row['attempt_count'] as num?)?.toInt() ?? 0,
          ),
        )
        .toList(growable: false);
  }

  Future<void> deleteAnalyticsEvents(List<String> ids) async {
    if (_isDisposed || ids.isEmpty) {
      return;
    }
    await _ensurePendingAnalyticsEventTable();
    final db = await sqliteProvider.getDb();
    final placeholders = List.filled(ids.length, '?').join(',');
    await db.delete(
      'PendingAnalyticsEvents',
      where: 'id IN ($placeholders)',
      whereArgs: ids,
    );
  }

  Future<void> incrementAnalyticsEventAttempt(String id) async {
    if (_isDisposed) {
      return;
    }
    await _ensurePendingAnalyticsEventTable();
    final db = await sqliteProvider.getDb();
    await db.rawUpdate(
      '''
      UPDATE PendingAnalyticsEvents
      SET attempt_count = attempt_count + 1
      WHERE id = ?
      ''',
      [id],
    );
  }

  Future<void> _ensurePendingAnalyticsEventTable() async {
    final db = await sqliteProvider.getDb();
    await db.execute('''
      CREATE TABLE IF NOT EXISTS PendingAnalyticsEvents (
        id TEXT PRIMARY KEY,
        event_name TEXT NOT NULL,
        properties_json TEXT NOT NULL,
        event_type TEXT NOT NULL,
        created_at TEXT NOT NULL,
        attempt_count INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  /// Upserts a model from Ditto without triggering a Ditto notification loop.
  Future<TModel> upsertFromDitto<TModel extends OfflineFirstWithSupabaseModel>(
    TModel instance, {
    OfflineFirstUpsertPolicy policy = OfflineFirstUpsertPolicy.optimisticLocal,
    Query? query,
  }) async {
    if (_isDisposed) {
      _logger.warning(
          'Attempted to call upsertFromDitto on a disposed Repository. Operation aborted.');
      throw StateError('Repository is disposed');
    }
    try {
      // Call super.upsert to perform the DB write
      instance = await super.upsert(instance, policy: policy, query: query);

      // Do NOT notify Ditto (avoids infinite loop)

      // Fire other events if needed
      if (instance is Customer) {
        EventBus().fire(CustomerUpserted(instance));
      }

      return instance;
    } catch (e) {
      _logger.severe('Error during upsertFromDitto: $e');
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
    final dbFactory = PlatformHelpers.getQueueDatabaseFactory();
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
            _logger.info('Queue database opened and verified.');
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

      final dbFactory = PlatformHelpers.getQueueDatabaseFactory();
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

      final dbFactory = PlatformHelpers.getQueueDatabaseFactory();
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
