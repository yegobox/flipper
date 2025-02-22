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
import 'db/schema.g.dart';
import 'package:path/path.dart';
// ignore: depend_on_referenced_packages
export 'package:brick_core/query.dart'
    show And, Or, Query, QueryAction, Where, WherePhrase, Compare, OrderBy;

const dbFileName = "flipper_v9.sqlite";
const queueName = "brick_offline_queue_v9.sqlite";

class Repository extends OfflineFirstWithSupabaseRepository {
  static late Repository? _singleton;

  Repository._({
    required super.supabaseProvider,
    required super.sqliteProvider,
    required super.migrations,
    required super.offlineRequestQueue,
    super.memoryCacheProvider,
  });

  factory Repository() => _singleton!;

  static Future<void> initializeSupabaseAndConfigure({
    required String supabaseUrl,
    required String supabaseAnonKey,
  }) async {
    // Initialize FFI for Windows

    sqfliteFfiInit();

    // Get the appropriate directory path
    final directory = await DatabasePath.getDatabaseDirectory();

    // Ensure the directory exists
    if (!await Directory(directory).exists()) {
      await Directory(directory).create(recursive: true);
    }
    // Construct the full database path
    final dbPath = join(directory, dbFileName);
    final queuePath = join(directory, queueName);

    final (client, queue) = OfflineFirstWithSupabaseRepository.clientQueue(
      databaseFactory: Platform.isWindows || DatabasePath.isTestEnvironment()
          ? databaseFactoryFfi
          : databaseFactory,
      databasePath: queuePath,
      onReattempt: (http.Request re, o) {},
      onRequestException: (request, object) {
        // Deal with failed requests see https://github.com/GetDutchie/brick/issues/527
        print("Offline request exception: $request");
        print(object);
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
        DatabasePath.isTestEnvironment() ? inMemoryDatabasePath : dbPath,
        databaseFactory: Platform.isWindows || DatabasePath.isTestEnvironment()
            ? databaseFactoryFfi
            : databaseFactory,
        modelDictionary: sqliteModelDictionary,
      ),
      migrations: migrations,
      offlineRequestQueue: queue,
      memoryCacheProvider: MemoryCacheProvider(),
    );
  }

  Future<int> availableQueue() async {
    final requests =
        await offlineRequestQueue.requestManager.unprocessedRequests();
    return requests.length;
  }

  Future<void> deleteUnprocessedRequests() async {
    try {
      // Retrieve unprocessed requests
      final requests =
          await offlineRequestQueue.requestManager.unprocessedRequests();

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
