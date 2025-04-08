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
export 'package:brick_core/query.dart'
    show And, Or, Query, QueryAction, Where, WherePhrase, Compare, OrderBy;

const dbFileName = "flipper_v17.sqlite";
const queueName = "brick_offline_queue_v17.sqlite";

class Repository extends OfflineFirstWithSupabaseRepository {
  static Repository? _singleton;

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
    String backupDbPath;

    if (kIsWeb) {
      // For web, use in-memory database or a web-specific approach
      dbPath = inMemoryDatabasePath;
      queuePath = inMemoryDatabasePath;
      backupDbPath = inMemoryDatabasePath;

      // Initialize FFI is not needed for web
    } else {
      // Initialize FFI for Windows platforms
      if (Platform.isWindows) {
        sqfliteFfiInit();
      }

      // Get the appropriate directory path for native platforms
      final directory = await DatabasePath.getDatabaseDirectory();

      // Ensure the directory exists
      if (!await Directory(directory).exists()) {
        await Directory(directory).create(recursive: true);
      }

      // Construct the full database path
      dbPath = join(directory, dbFileName);
      queuePath = join(directory, queueName);
      backupDbPath = join(directory, "${dbFileName}_backup");

      // Check if the database exists and verify its integrity
      if (File(dbPath).existsSync()) {
        try {
          // Try to open the database to check if it's valid
          final db = await databaseFactoryToUse.openDatabase(
            dbPath,
            options: OpenDatabaseOptions(readOnly: true),
          );
          await db.close();
        } catch (e) {
          // Database is corrupted, try to restore from backup
          if (File(backupDbPath).existsSync()) {
            try {
              // Copy backup to main database file
              await File(backupDbPath).copy(dbPath);
            } catch (backupError) {
              // If restore fails, delete corrupted database to start fresh
              await File(dbPath).delete();
            }
          } else {
            // No backup available, delete corrupted database
            await File(dbPath).delete();
          }
        }
      }
    }

    final (client, queue) = OfflineFirstWithSupabaseRepository.clientQueue(
      databaseFactory: databaseFactoryToUse,
      databasePath: queuePath,
      onReattempt: (http.Request re, o) {},
      onRequestException: (request, object) {
        // Handle failed requests by clearing the queue
        try {
          // Silently ignore errors during queue handling
        } catch (e) {
          // Silently ignore errors
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
        if (File(dbPath).existsSync()) {
          await File(dbPath).copy(backupDbPath);
        }

        // Configure the database with WAL mode and other settings
        if (File(dbPath).existsSync()) {
          final db = await databaseFactoryToUse.openDatabase(dbPath);

          // Enable Write-Ahead Logging for better crash recovery
          await db.execute('PRAGMA journal_mode = WAL');
          // Ensure data is immediately written to disk
          await db.execute('PRAGMA synchronous = FULL');
          // Run integrity check
          await db.execute('PRAGMA integrity_check');

          // Close the database after configuration
          await db.close();
        }
      } catch (e) {
        // Silently ignore configuration errors
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
      print("Error checking queue: $e");
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

      print("All locked requests have been cleared.");
    } catch (e) {
      print("An error occurred while clearing locked requests: $e");
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

      if (File(dbPath).existsSync()) {
        final db = await databaseFactory.openDatabase(dbPath);

        // Enable Write-Ahead Logging for better crash recovery
        await db.execute('PRAGMA journal_mode = WAL');
        // Ensure data is immediately written to disk
        await db.execute('PRAGMA synchronous = FULL');
        // Run integrity check
        await db.execute('PRAGMA integrity_check');

        // Close the database after configuration
        await db.close();
      }
    } catch (e) {
      // Silently ignore configuration errors
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
      final backupPath = join(directory, "${dbFileName}_backup");

      // Create backup only if the database exists
      if (File(dbPath).existsSync()) {
        await File(dbPath).copy(backupPath);
      }
    } catch (e) {
      // Silently ignore backup errors
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
      final backupPath = join(directory, "${dbFileName}_backup");

      // Check if the database exists but might be corrupted
      if (File(dbPath).existsSync()) {
        try {
          // Try to open the database to check if it's valid
          final db = await databaseFactory.openDatabase(dbPath);
          await db.query('sqlite_master', limit: 1);
          await db.close();

          // If we get here, the database is likely valid
          // Create a backup for safety
          if (File(dbPath).existsSync()) {
            await File(dbPath).copy(backupPath);
          }
          return false;
        } catch (e) {
          // Database is corrupted, try to restore from backup
          if (File(backupPath).existsSync()) {
            try {
              // Delete corrupted database
              await File(dbPath).delete();

              // Copy backup to main database file
              await File(backupPath).copy(dbPath);
              return true;
            } catch (backupError) {
              // If restore fails, we'll create a new database on next access
              if (File(dbPath).existsSync()) {
                await File(dbPath).delete();
              }
              return false;
            }
          }
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
