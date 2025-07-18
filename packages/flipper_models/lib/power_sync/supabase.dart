import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/secrets.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:flutter/foundation.dart';

bool isTestEnvironment() {
  return const bool.fromEnvironment('FLUTTER_TEST_ENV') == true;
}

Future<void> loadSupabase() async {
  try {
    debugPrint('Initializing Supabase with:');
    debugPrint('  URL: ${AppSecrets.superbaseurl}');
    debugPrint('  Anon Key: ${AppSecrets.supabaseAnonKey}');

    if (isTestEnvironment()) {
      await Repository.initializeSupabaseAndConfigure(
        supabaseUrl: AppSecrets.superbaseurl,
        supabaseAnonKey: AppSecrets.supabaseAnonKey,
      );
    } else {
      await Repository.initializeSupabaseAndConfigure(
        supabaseUrl: AppSecrets.superbaseurl,
        supabaseAnonKey: AppSecrets.supabaseAnonKey,
      );
    }

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
