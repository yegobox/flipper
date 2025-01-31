import 'package:flipper_models/secrets.dart';
import 'package:supabase_models/brick/brick.g.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_sqlite/memory_cache_provider.dart';
import 'package:brick_supabase/brick_supabase.dart' hide Supabase;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_models/brick/db/schema.g.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:supabase/supabase.dart';
import 'package:brick_supabase/testing.dart';
import 'package:injectfy/injectfy.dart';

class TestRepository extends OfflineFirstWithSupabaseRepository {
  TestRepository._({
    required super.supabaseProvider,
    required super.sqliteProvider,
    required super.offlineRequestQueue,
    super.memoryCacheProvider,
  }) : super(
          migrations: migrations,
        );

  factory TestRepository.configure(SupabaseMockServer mock) {
    final (client, queue) = OfflineFirstWithSupabaseRepository.clientQueue(
      databaseFactory: databaseFactoryFfi,
      reattemptForStatusCodes: [],
    );

    final provider = SupabaseProvider(
      SupabaseClient(mock.serverUrl, mock.apiKey, httpClient: client),
      modelDictionary: supabaseModelDictionary,
    );

    return TestRepository._(
      offlineRequestQueue: queue,
      memoryCacheProvider: MemoryCacheProvider(),
      supabaseProvider: provider,
      sqliteProvider: SqliteProvider(
        ':memory:', // Use in-memory database for testing
        databaseFactory: databaseFactoryFfi,
        modelDictionary: sqliteModelDictionary,
      ),
    );
  }
}

bool isTestEnvironment() {
  return bool.fromEnvironment('FLUTTER_TEST_ENV') == true;
}

Future<void> loadSupabase() async {
  final injectfy = Injectfy.instance;
  if (isTestEnvironment()) {
    print("IN TEST MODE");
    // Initialize the FFI loader for sqflite
    sqfliteFfiInit();
    final mock = SupabaseMockServer(modelDictionary: supabaseModelDictionary);

    final repository = TestRepository.configure(mock);
    await repository.initialize();

    // Register the test repository with the DI framework
    injectfy.registerSingleton<OfflineFirstWithSupabaseRepository>(
        () => repository);
  } else {
    print("IN PROD MODE");
    // Production initialization
    await Repository.initializeSupabaseAndConfigure(
      supabaseUrl: AppSecrets.superbaseurl,
      supabaseAnonKey: AppSecrets.supabaseAnonKey,
    );

    final repository = Repository();
    await repository.initialize();

    // Register the production repository with the DI framework
    injectfy.registerSingleton<OfflineFirstWithSupabaseRepository>(
        () => repository);
  }
}
