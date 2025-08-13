// lib/core/providers.dart
import 'package:flipper_auth/features/auth/repositories/account_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flipper_auth/core/services/auth_service.dart';
import 'package:flipper_auth/core/services/totp_service.dart';

// Supabase Client Provider
final supabaseProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
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
  final supabase = ref.watch(supabaseProvider);
  return AccountRepository(supabase);
});

// Auth State Provider
final authStateProvider = StreamProvider<AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

// Current User Provider
final currentUserProvider = Provider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.currentUser;
});
