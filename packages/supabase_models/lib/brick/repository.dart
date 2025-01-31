import 'dart:io';
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

const dbFileName = "flipper_v3.sqlite";
const queueName = "brick_offline_queue.sqlite";


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
      databaseFactory:
          Platform.isWindows ? databaseFactoryFfi : databaseFactory,
      databasePath: queuePath,
      onReattempt: (http.Request re, o) {
        // print("Request status: $o");
        print("here");
        // print("Object: ${re.body}");
      },
      onRequestException: (request, object) {
        // Deal with failed requests see https://github.com/GetDutchie/brick/issues/527
        print("Offline request exception: $request");
        print(object);
      },
    );

    final supabase = await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      httpClient: client,
    );

    final provider = SupabaseProvider(
      supabase.client,
      modelDictionary: supabaseModelDictionary,
    );

    _singleton = Repository._(
      supabaseProvider: provider,
      sqliteProvider: SqliteProvider(
        dbPath,
        databaseFactory:
            Platform.isWindows ? databaseFactoryFfi : databaseFactory,
        modelDictionary: sqliteModelDictionary,
      ),
      migrations: migrations,
      offlineRequestQueue: queue,
      memoryCacheProvider: MemoryCacheProvider(),
    );
  }
}
