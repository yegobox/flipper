import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:brick_supabase/testing.dart';
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_sqlite/memory_cache_provider.dart';
import 'package:brick_supabase/brick_supabase.dart' hide Supabase;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http show Request;
import 'package:supabase_models/brick/brick.g.dart';
import 'package:supabase_models/brick/databasePath.dart';
import 'package:path/path.dart';
import 'package:logging/logging.dart';
// ignore: depend_on_referenced_packages
export 'package:brick_core/query.dart'
    show And, Or, Query, QueryAction, Where, WherePhrase, Compare, OrderBy;

/// Provides platform-specific functionality for the repository
class PlatformHelpers {
  static final _logger = Logger('PlatformHelpers');

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
    if (!kIsWeb && Platform.isWindows) {
      sqfliteFfiInit();
      _logger.info('Initialized SQLite FFI for Windows');
    }
  }

  /// Gets the appropriate database factory for the current platform
  static DatabaseFactory getDatabaseFactory() {
    if (kIsWeb) {
      return databaseFactory;
    } else if (Platform.isWindows || DatabasePath.isTestEnvironment()) {
      return databaseFactoryFfi;
    } else {
      return databaseFactory;
    }
  }

  /// Gets the in-memory database path for web or test environments
  static String getInMemoryDatabasePath() {
    return inMemoryDatabasePath;
  }
}
