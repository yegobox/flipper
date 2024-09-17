import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flipper_models/secrets.dart';

loadSupabase() async {
  await Supabase.initialize(
    url: AppSecrets.superbaseurl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
}