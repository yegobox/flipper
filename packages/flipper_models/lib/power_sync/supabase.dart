import 'package:flipper_models/secrets.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:flutter/foundation.dart';


bool isTestEnvironment() {
  return const bool.fromEnvironment('FLUTTER_TEST_ENV') == true;
}

Future<void> loadSupabase() async {
    try {
      // if (isTestEnvironment()) {
        // In test environment, we'll use a mock configuration
        // This avoids the need for a local Supabase instance
        // await Repository.initializeSupabaseAndConfigure(
        //   supabaseUrl: 'mock://supabase',
        //   supabaseAnonKey: 'test-key',
        // );
      // } else {
      //   // Production initialization
        await Repository.initializeSupabaseAndConfigure(
          supabaseUrl: AppSecrets.superbaseurl,
          supabaseAnonKey: AppSecrets.supabaseAnonKey,
        );
      // }

      await Repository().initialize();
    } catch (e) {
      debugPrint('Error initializing Supabase: $e');
      // In test environment, we'll continue even if Supabase fails
      if (!isTestEnvironment()) {
        rethrow;
      }
    }
}