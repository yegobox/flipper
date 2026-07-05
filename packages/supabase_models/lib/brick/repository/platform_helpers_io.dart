import 'dart:io';
import 'package:brick_sqlite/turso.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// ignore: depend_on_referenced_packages
import 'package:logging/logging.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:supabase_models/brick/databasePath.dart';
// ignore: depend_on_referenced_packages
export 'package:brick_core/query.dart'
    show And, Or, Query, QueryAction, Where, WherePhrase, Compare, OrderBy;

/// Provides platform-specific functionality for the repository
class PlatformHelpers {
  static final _logger = Logger('PlatformHelpers');
  static DatabaseFactory? _cachedMainDatabaseFactory;
  static String? _cachedMainDatabaseFactoryPath;
  static String? _registeredMainDatabasePath;

  /// Native Flipper (including tests) uses Turso for the main Brick database.
  /// Web stays on in-memory sqflite.
  static bool get usesTursoMainDatabase => !kIsWeb;

  /// True when the main Brick DB syncs with Turso Cloud (embedded replica).
  static bool get usesTursoCloudSync =>
      usesTursoMainDatabase && AppSecrets.tursoCloudSyncEnabled;

  /// Records the main Brick database path so [assertFactoryAllowedForPath] can
  /// reject sqflite/sqlite3 opens on that file from in-app code.
  static void registerMainDatabasePath(String path) {
    _registeredMainDatabasePath = path;
  }

  /// Clears the cached Turso factory (e.g. after [Repository.dispose]).
  static void clearMainDatabaseFactoryCache() {
    _cachedMainDatabaseFactory = null;
    _cachedMainDatabaseFactoryPath = null;
    _registeredMainDatabasePath = null;
  }

  /// Rejects opening the main Brick path with sqflite when Turso is active.
  ///
  /// External tools (`sqlite3`, DB Browser) are not blocked here — Turso holds
  /// an exclusive lock while Flipper runs; quit the app before inspecting locally.
  static void assertFactoryAllowedForPath(
    String path,
    DatabaseFactory factory,
  ) {
    if (!usesTursoMainDatabase) {
      return;
    }
    final mainPath = _registeredMainDatabasePath;
    if (mainPath == null || path != mainPath) {
      return;
    }
    if (factory is! TursoDatabaseFactory) {
      throw StateError(
        'Cannot open the main Brick database with sqflite/sqlite3 ($path). '
        'Use PlatformHelpers.getMainDatabaseFactory() — Turso owns this file. '
        'To inspect data locally, fully quit Flipper first; while it is running '
        'use Turso Cloud shell or in-app queries instead of sqlite3 on this path.',
      );
    }
  }

  /// Determines if the current platform is web
  static bool isWebPlatform() {
    return kIsWeb;
  }

  /// Determines if the current platform is in test environment
  static bool isTestEnvironment() {
    return DatabasePath.isTestEnvironment();
  }

  /// Initializes platform-specific database requirements
  static void initializePlatform() {
    if (!kIsWeb &&
        (Platform.isWindows ||
            Platform.isLinux ||
            DatabasePath.isTestEnvironment())) {
      sqfliteFfiInit();
      _logger.info('Initialized SQLite FFI for ${Platform.operatingSystem}');
    }
  }

  /// sqflite factory for the offline HTTP queue only — not for the main Brick DB.
  static DatabaseFactory getQueueDatabaseFactory() {
    if (kIsWeb) {
      return databaseFactoryFfiWeb;
    } else if (Platform.isWindows ||
        Platform.isLinux ||
        DatabasePath.isTestEnvironment()) {
      return databaseFactoryFfi;
    } else {
      return databaseFactory;
    }
  }

  /// Main Brick model database factory. Turso on all native platforms (including tests).
  /// When [AppSecrets.tursoCloudSyncEnabled], syncs [localPath] with Turso Cloud;
  /// otherwise local-only Turso. Web uses in-memory sqflite.
  ///
  /// The factory is cached per [localPath] so Turso sync opens one replica only.
  static DatabaseFactory getMainDatabaseFactory(String localPath) {
    if (kIsWeb) {
      return getQueueDatabaseFactory();
    }

    if (_cachedMainDatabaseFactory != null &&
        _cachedMainDatabaseFactoryPath == localPath) {
      return _cachedMainDatabaseFactory!;
    }

    final DatabaseFactory factory;
    if (AppSecrets.tursoCloudSyncEnabled) {
      final localFile = File(localPath);
      if (TursoReplicaPaths.hasOrphanedSyncMetadata(localPath)) {
        _logger.warning(
          'Removing orphaned Turso sync metadata for $localPath '
          '(main database file missing). Will bootstrap from cloud if empty.',
        );
        TursoReplicaPaths.removeOrphanedSyncMetadata(localPath);
      }
      final localIsEmpty =
          !localFile.existsSync() || localFile.lengthSync() == 0;
      // Do not block startup on Turso Cloud bootstrap (new installs and
      // upgrades with a missing flipper.sqlite). Repository.initialize()
      // runs a non-fatal pull() after connect; Supabase/Ditto hydrate the rest.
      const bootstrapIfEmpty = false;
      _logger.info(
        'Using Turso Cloud sync for main Brick database at $localPath '
        '(localIsEmpty: $localIsEmpty, bootstrapIfEmpty: $bootstrapIfEmpty)',
      );
      _logger.warning(
        'While Flipper is running, do not open $localPath with sqlite3 or '
        'DB Browser — Turso holds an exclusive lock on the replica file.',
      );
      factory = tursoSyncDatabaseFactory(
        TursoSyncConfig(
          localPath: localPath,
          remoteUrl: AppSecrets.tursoDatabaseUrl.trim(),
          authToken: AppSecrets.tursoDatabaseAuthToken.trim(),
          bootstrapIfEmpty: bootstrapIfEmpty,
        ),
      );
    } else {
      _logger.info('Using local Turso for main Brick database');
      factory = tursoDatabaseFactory();
    }

    _cachedMainDatabaseFactory = factory;
    _cachedMainDatabaseFactoryPath = localPath;
    return factory;
  }

  /// Queue/offline-request database factory. Main Brick models use [getMainDatabaseFactory].
  static DatabaseFactory getDatabaseFactory() => getQueueDatabaseFactory();

  /// Gets the in-memory database path for web or test environments
  static String getInMemoryDatabasePath() {
    return inMemoryDatabasePath;
  }

  /// Gets the recommended max concurrent DB operations for this platform
  static int getRecommendedMaxConcurrentOps() {
    if (Platform.isWindows) return 1;
    return 3;
  }
}
