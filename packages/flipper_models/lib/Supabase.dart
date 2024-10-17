import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SupabaseInterface {
  SupabaseClient? client;
  Future<SupabaseClient> init();
}

class SupabaseImpl implements SupabaseInterface {
  SupabaseClient? client;

  @override
  Future<SupabaseClient> init() async {
    client = Supabase.instance.client;
    return client!;
  }
}
