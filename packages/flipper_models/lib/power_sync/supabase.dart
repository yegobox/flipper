import 'package:flipper_models/secrets.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:flutter/foundation.dart';

bool isTestEnvironment() {
  return const bool.fromEnvironment('FLUTTER_TEST_ENV') == true;
}

Future<void> loadSupabase() async {
  try {
    if (isTestEnvironment()) {
      await Repository.initializeSupabaseAndConfigure(
        // supabaseUrl: 'mock://supabase',
        // supabaseAnonKey: 'test-key',
        supabaseUrl: AppSecrets.superbaseurl,
        supabaseAnonKey: AppSecrets.supabaseAnonKey,
        configureDatabase: true,
      );
    } else {
      //   // Production initialization
      await Repository.initializeSupabaseAndConfigure(
        supabaseUrl: AppSecrets.superbaseurl,
        supabaseAnonKey: AppSecrets.supabaseAnonKey,
        configureDatabase: true,
      );
    }

    await Repository().initialize();
  } catch (e) {
    debugPrint('Error initializing Supabase: $e');
    // In test environment, we'll continue even if Supabase fails
    if (!isTestEnvironment()) {
      rethrow;
    }
  }
}
