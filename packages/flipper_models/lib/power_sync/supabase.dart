import 'package:flipper_models/secrets.dart';
import 'package:supabase_models/brick/repository.dart';


bool isTestEnvironment() {
  return const bool.fromEnvironment('FLUTTER_TEST_ENV') == true;
}

Future<void> loadSupabase() async {
    if (isTestEnvironment()) {
      // Test environment initialization
      await Repository.initializeSupabaseAndConfigure(
        supabaseUrl: 'http://localhost:54321',  // Local Supabase URL
        supabaseAnonKey: 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwiaWF0IjoxNjQxNzY5MjAwLCJleHAiOjE3OTk1MzkyMDAsImF1ZCI6IiIsInN1YiI6IiIsInJvbGUiOiJhbm9uIn0.ZDdTqvl4ZxU4IQpHhaxp5RJ1o5m1PwEQAyKEiorY_Ms',  // Local anon key
      );
    } else {
      // Production initialization
      await Repository.initializeSupabaseAndConfigure(
        supabaseUrl: AppSecrets.superbaseurl,
        supabaseAnonKey: AppSecrets.supabaseAnonKey,
      );
    }

    await Repository().initialize();
}