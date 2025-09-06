import 'package:flipper_models/secrets.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:flutter/foundation.dart';

bool isTestEnvironment() {
  return const bool.fromEnvironment('FLUTTER_TEST_ENV') == true;
}

Future<void> loadSupabase() async {
  try {
    String supabaseUrl;
    String supabaseAnonKey;

    if (kDebugMode && !isTestEnvironment()) {
      supabaseUrl = AppSecrets.localSuperbaseUrl;
      supabaseAnonKey = AppSecrets.localSupabaseAnonKey;
    } else {
      supabaseUrl = AppSecrets.superbaseurl;
      supabaseAnonKey = AppSecrets.supabaseAnonKey;
    }

    debugPrint('Initializing Supabase with:');
    debugPrint('  URL: $supabaseUrl');
    debugPrint('  Anon Key: $supabaseAnonKey');

    await Repository.initializeSupabaseAndConfigure(
      supabaseUrl: supabaseUrl,
      supabaseAnonKey: supabaseAnonKey,
    );

    await Repository().initialize();
  } catch (e, s) {
    debugPrint('Error initializing Supabase: $e');
    debugPrint('Error initializing Supabase: $s');

    // In test environment, we'll continue even if Supabase fails
    if (!isTestEnvironment()) {
      rethrow;
    }
  }
}
