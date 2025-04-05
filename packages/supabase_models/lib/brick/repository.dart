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
    // Create a variable to hold the database paths
    String dbPath;
    String queuePath;

    // Create variables to hold the appropriate database factory
    final databaseFactoryToUse = kIsWeb
        ? databaseFactory
        : (Platform.isWindows || DatabasePath.isTestEnvironment()
            ? databaseFactoryFfi
            : databaseFactory);

    if (kIsWeb) {
      // For web, use in-memory database or a web-specific approach
      dbPath = inMemoryDatabasePath;
      queuePath = inMemoryDatabasePath;

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
    }

    final (client, queue) = OfflineFirstWithSupabaseRepository.clientQueue(
      databaseFactory: databaseFactoryToUse,
      databasePath: queuePath,
      onReattempt: (http.Request re, o) {},
      onRequestException: (request, object) {
        if (_singleton != null) {
          _singleton!.deleteUnprocessedRequests();
        }
        // Deal with failed requests see https://github.com/GetDutchie/brick/issues/527
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

    _singleton = Repository._(
      supabaseProvider: provider,
      sqliteProvider: SqliteProvider(
        DatabasePath.isTestEnvironment() || kIsWeb
            ? inMemoryDatabasePath
            : dbPath,
        databaseFactory: databaseFactoryToUse,
        modelDictionary: sqliteModelDictionary,
      ),
      migrations: migrations,
      offlineRequestQueue: queue,
      memoryCacheProvider: MemoryCacheProvider(),
    );
  }

  Future<int> availableQueue() async {
    // On web, silently return 0 without trying to access the queue
    if (kIsWeb) {
      return 0;
    }

    final requests = await offlineRequestQueue.requestManager
        .unprocessedRequests(onlyLocked: true);
    return requests.length;
  }

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

      print("All unprocessed requests have been deleted.");
    } catch (e) {
      print("An error occurred while deleting unprocessed requests: $e");
    }
  }
}
