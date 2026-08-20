import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/repository/auth_refreshing_client.dart';

void main() {
  // Deliberately never calls Supabase.initialize in this file — each test
  // file runs in its own isolate, so `Supabase.instance` here is genuinely
  // unestablished, exercising the LateInitializationError caught by `_auth`.
  test('currentUserId and current() are null before Supabase.initialize runs',
      () async {
    final source = SupabaseAccessTokenSource();

    expect(source.currentUserId, isNull);
    expect(await source.current(), isNull);
  });
}
