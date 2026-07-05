import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:supabase_models/brick/databasePath.dart';
// ignore: depend_on_referenced_packages
export 'package:brick_core/query.dart'
    show And, Or, Query, QueryAction, Where, WherePhrase, Compare, OrderBy;

/// Web implementation — in-memory sqflite only; no Turso or dart:io.
class PlatformHelpers {
  static bool get usesTursoMainDatabase => false;

  static bool get usesTursoCloudSync => false;

  static void registerMainDatabasePath(String path) {}

  static void clearMainDatabaseFactoryCache() {}

  static void assertFactoryAllowedForPath(
    String path,
    DatabaseFactory factory,
  ) {}

  static bool isWebPlatform() => true;

  static bool isTestEnvironment() => DatabasePath.isTestEnvironment();

  static void initializePlatform() {}

  static DatabaseFactory getQueueDatabaseFactory() => databaseFactoryFfiWeb;

  static DatabaseFactory getMainDatabaseFactory(String localPath) =>
      getQueueDatabaseFactory();

  static DatabaseFactory getDatabaseFactory() => getQueueDatabaseFactory();

  static String getInMemoryDatabasePath() => inMemoryDatabasePath;

  static int getRecommendedMaxConcurrentOps() => 3;
}
