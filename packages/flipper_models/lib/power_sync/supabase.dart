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
      // Never log the key itself. Emit only a non-sensitive hint so debug
      // output can confirm a key is present without exposing its value.
      final keyHint = supabaseAnonKey.isEmpty
          ? '<empty>'
          : '${supabaseAnonKey.split('_').take(2).join('_')}_… (len ${supabaseAnonKey.length})';
      debugPrint('  Key: $keyHint');
    }

    debugPrint(
      '🚀 [loadSupabase] Calling Repository.initializeSupabaseAndConfigure...',
    );
    await Repository.initializeSupabaseAndConfigure(
      supabaseUrl: supabaseUrl,
      supabaseAnonKey: supabaseAnonKey,
    );
    debugPrint(
      '✅ [loadSupabase] Repository.initializeSupabaseAndConfigure completed',
    );

    debugPrint('🚀 [loadSupabase] Calling Repository().initialize()...');
    await Repository().initialize();
    debugPrint('✅ [loadSupabase] Repository().initialize() completed');
  } catch (e, s) {
    debugPrint('❌ [loadSupabase] Error initializing Supabase: $e');
    debugPrint('❌ [loadSupabase] Stack trace: $s');

    // In test environment, we'll continue even if Supabase fails
    if (!AppSecrets.isTestEnvironment()) {
      rethrow;
    }
  }
}
