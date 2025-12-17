import 'package:flipper_auth/core/services/auth_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flipper_auth/core/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_notifier.g.dart';

// Auth State
class AuthState extends Equatable {
  static const Object _unset = Object();
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;
  final bool isNavigatingToHome;

  const AuthState({
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
    this.isNavigatingToHome = false,
  });

  AuthState copyWith({
    bool? isLoading,
    Object? error = _unset,
    bool? isAuthenticated,
    bool? isNavigatingToHome,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error == _unset ? this.error : error as String?,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isNavigatingToHome: isNavigatingToHome ?? this.isNavigatingToHome,
    );
  }

  @override
  List<Object?> get props =>
      [isLoading, error, isAuthenticated, isNavigatingToHome];
}

// Auth Notifier
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    return const AuthState();
  }

  AuthService get _authService => ref.read(authServiceProvider);

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authService.signIn(email: email, password: password);
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        isNavigatingToHome: true,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authService.signUp(email: email, password: password);
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        isNavigatingToHome: true,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    try {
      await _authService.signOut();
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void resetNavigation() {
    state = state.copyWith(isNavigatingToHome: false);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final authNotifierProvider = authProvider;
