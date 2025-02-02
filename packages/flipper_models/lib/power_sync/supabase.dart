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

<<<<<<< HEAD
    final repository = await Repository().initialize();

    // Register the production repository with the DI framework
    // injectfy.registerSingleton<Repository>(() => repository);
  }
=======
    await Repository().initialize();
>>>>>>> c8b32df24 (improvement in repository creation aware of test env)
}
