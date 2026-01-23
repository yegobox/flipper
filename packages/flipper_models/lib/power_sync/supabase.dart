import 'package:flipper_models/secrets.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:flutter/foundation.dart' hide Category;

//
Future<void> loadSupabase() async {
  try {
    String supabaseUrl = AppSecrets.supabaseUrl;
    String supabaseAnonKey = AppSecrets.supabaseAnonKey;

    if (kDebugMode) {
      debugPrint('Initializing Supabase with:');
      debugPrint('  URL: $supabaseUrl');
      debugPrint('  Anon Key: $supabaseAnonKey');
    }

    await Repository.initializeSupabaseAndConfigure(
      supabaseUrl: supabaseUrl,
      supabaseAnonKey: supabaseAnonKey,
    );

    await Repository().initialize();
  } catch (e, s) {
    debugPrint('Error initializing Supabase: $e');
    debugPrint('Error initializing Supabase: $s');

    // In test environment, we'll continue even if Supabase fails
    if (!AppSecrets.isTestEnvironment()) {
      rethrow;
    }
  }
}
