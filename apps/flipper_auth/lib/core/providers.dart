// lib/core/providers.dart
import 'package:flipper_auth/features/auth/repositories/account_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:flipper_auth/core/services/auth_service.dart';
import 'package:flipper_auth/core/services/totp_service.dart';

// Supabase Client Provider
final supabaseProvider = Provider<supabase.SupabaseClient>((ref) {
  return supabase.Supabase.instance.client;
});

// Service Providers
final authServiceProvider = Provider<AuthService>((ref) {
  final supabase = ref.read(supabaseProvider);
  return AuthService(supabase);
});

final totpServiceProvider = Provider<TOTPService>((ref) {
  return TOTPService();
});

// Repository Providers
final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  final supabaseClient = ref.watch(supabaseProvider);
  return AccountRepository(supabaseClient);
});

// Auth State Provider
final authStateProvider = StreamProvider<supabase.AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

// Current User Provider
final currentUserProvider = Provider<supabase.User?>((ref) {
  final authState = ref.watch(authStateProvider);
  final supabaseClient = ref.watch(supabaseProvider);
  return authState.when(
    data: (state) => supabaseClient.auth.currentUser,
    loading: () => null,
    error: (_, __) => null,
  );
});
