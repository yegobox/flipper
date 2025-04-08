import 'dart:io';
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_sqlite/memory_cache_provider.dart';
import 'package:brick_supabase/brick_supabase.dart' hide Supabase;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http show Request;
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:supabase_models/brick/db/schema.g.dart';

import '../brick.g.dart';
import '../databasePath.dart';
import 'backup_manager.dart';
import 'database_manager.dart';
import 'queue_manager.dart';
import 'platform_helpers.dart';

/// Implementation of the Repository class
/// Handles database operations, backup, and offline request queue
class RepositoryImpl extends OfflineFirstWithSupabaseRepository {
  static final _logger = Logger('RepositoryImpl');
  final BackupManager _backupManager;
  final DatabaseManager _databaseManager;
  final QueueManager _queueManager;
  final String _dbPath;

  RepositoryImpl._({
    required super.supabaseProvider,
    required super.sqliteProvider,
    required super.migrations,
    required super.offlineRequestQueue,
    required BackupManager backupManager,
    required DatabaseManager databaseManager,
    required String dbPath,
    super.memoryCacheProvider,
  })  : _backupManager = backupManager,
        _databaseManager = databaseManager,
        _queueManager = QueueManager(offlineRequestQueue),
        _dbPath = dbPath;

  /// Creates a dummy repository for web platforms
  static RepositoryImpl createDummyRepository(
      {required String dbFileName, required String queueName}) {
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

    final backupManager = BackupManager();
    final databaseManager = DatabaseManager(dbFileName: dbFileName);

    return RepositoryImpl._(
      supabaseProvider: dummySupabaseProvider,
      sqliteProvider: dummySqliteProvider,
      migrations: migrations,
      offlineRequestQueue: dummyQueue,
      memoryCacheProvider: MemoryCacheProvider(),
      backupManager: backupManager,
      databaseManager: databaseManager,
      dbPath: PlatformHelpers.getInMemoryDatabasePath(),
    );
  }

  /// Configure the database for better crash resilience
  Future<void> configureDatabase() async {
    if (kIsWeb || PlatformHelpers.isTestEnvironment()) {
      return;
    }

    try {
      await _databaseManager.configureDatabaseSettings(
          _dbPath, PlatformHelpers.getDatabaseFactory());
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
      await _backupManager.createVersionedBackup(_dbPath);
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
      final directory = dirname(_dbPath);
      return await _databaseManager.restoreIfCorrupted(
          directory, _dbPath, PlatformHelpers.getDatabaseFactory());
    } catch (e) {
      _logger.severe('Error during database restore process: $e');
      return false;
    }
  }

  /// Get the number of requests in the queue
  Future<int> availableQueue() async {
    if (kIsWeb) {
      return 0;
    }
    return await _queueManager.availableQueue();
  }

  /// Clear any locked requests in the queue
  Future<void> deleteUnprocessedRequests() async {
    if (kIsWeb) {
      return;
    }
    await _queueManager.deleteUnprocessedRequests();
  }
}
