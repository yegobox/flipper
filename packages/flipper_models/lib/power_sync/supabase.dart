
import 'package:flipper_models/secrets.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:supabase_models/brick/repository.dart';

loadSupabase() async {
  sqfliteFfiInit() ;
  await Repository.initializeSupabaseAndConfigure(
    supabaseUrl: AppSecrets.superbaseurl,
    supabaseAnonKey: AppSecrets.supabaseAnonKey,
  );
  await Repository().initialize();
}
