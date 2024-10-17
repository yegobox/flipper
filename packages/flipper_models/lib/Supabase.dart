import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SupabaseInterface {
  late SupabaseClient client;
}

class SupabaseImpl implements SupabaseInterface {
  @override
  late SupabaseClient client;
  SupabaseImpl({required SupabaseClient client}) : client = client;
}
