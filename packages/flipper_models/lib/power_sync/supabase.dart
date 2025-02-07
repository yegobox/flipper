import 'package:flipper_models/secrets.dart';
import 'package:supabase_models/brick/repository.dart';


bool isTestEnvironment() {
  return const bool.fromEnvironment('FLUTTER_TEST_ENV') == true;
}

Future<void> loadSupabase() async {
    // Production initialization
    await Repository.initializeSupabaseAndConfigure(
      supabaseUrl: AppSecrets.superbaseurl,
      supabaseAnonKey: AppSecrets.supabaseAnonKey,
    );

    await Repository().initialize();
}