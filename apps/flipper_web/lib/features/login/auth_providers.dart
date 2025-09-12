import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

enum AuthState { unauthenticated, authenticated }

final authStateProvider = StreamProvider<AuthState>((ref) {
  return supabase.Supabase.instance.client.auth.onAuthStateChange.map((
    authState,
  ) {
    if (authState.session != null) {
      return AuthState.authenticated;
    } else {
      return AuthState.unauthenticated;
    }
  });
});
