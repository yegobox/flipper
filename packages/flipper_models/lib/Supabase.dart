import 'package:flipper_models/secrets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SupabaseInterface {
  SupabaseClient? client;
  Future<void> init();
}

class SupabaseImpl implements SupabaseInterface {
  @override
  SupabaseClient? client;
  SupabaseImpl({SupabaseClient? client}) : client = client;

  @override
  Future<void> init() async {
    await Supabase.initialize(
      url: AppSecrets.superbaseurl,
      anonKey: AppSecrets.supabaseAnonKey,
    );
  }
}
