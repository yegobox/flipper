import 'package:flipper_models/secrets.dart';
import 'package:supabase_models/brick/repository.dart';

loadSupabase() async {
  await Repository.initializeSupabaseAndConfigure(
    supabaseUrl: AppSecrets.superbaseurl,
    supabaseAnonKey: AppSecrets.supabaseAnonKey,
  );
  await Repository().initialize();
}
