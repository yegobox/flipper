import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_sqlite/memory_cache_provider.dart';
import 'package:brick_supabase/brick_supabase.dart' hide Supabase;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_models/brick/brick.g.dart';
import 'db/schema.g.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
// ignore: depend_on_referenced_packages
export 'package:brick_core/query.dart'
    show And, Or, Query, QueryAction, Where, WherePhrase, Compare;

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
    if (Platform.isWindows) {
      sqfliteFfiInit();
    }

    // Get the appropriate directory path
    final directory = await _getDatabaseDirectory();

    // Ensure the directory exists
    await Directory(directory).create(recursive: true);

    // Construct the full database path
    final dbPath = join(directory, "flipper_v2.sqlite");
    final queuePath = join(directory, "brick_offline_queue.sqlite");

    // Verify database file permissions and existence
    try {
      // Test if we can open/create the database
      final db =
          await (Platform.isWindows ? databaseFactoryFfi : databaseFactory)
              .openDatabase(
        dbPath,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, version) async {
            // Initial database setup if needed
          },
        ),
      );
      await db.close();
    } catch (e) {
      // log.info(e);
      rethrow;
    }

    final (client, queue) = OfflineFirstWithSupabaseRepository.clientQueue(
      databaseFactory:
          Platform.isWindows ? databaseFactoryFfi : databaseFactory,
      databasePath: queuePath,
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

  // Helper method to get the appropriate database directory
  static Future<String> _getDatabaseDirectory() async {
    if (Platform.isWindows) {
      final appDir = await getApplicationDocumentsDirectory();
      return join(appDir.path, '_db');
    } else if (Platform.isAndroid) {
      return await getDatabasesPath();
    } else if (Platform.isIOS || Platform.isMacOS) {
      final documents = await getApplicationDocumentsDirectory();
      return documents.path;
    } else {
      // For other platforms, use application documents directory
      final appDir = await getApplicationDocumentsDirectory();
      return join(appDir.path, '_db');
    }
  }
}
