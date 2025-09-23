import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flipper_web/features/login/auth_providers.dart' as login_auth;
import 'package:flipper_web/features/login/auth_wrapper.dart';
import 'package:flipper_web/features/dashboard/dashboard_screen.dart';
import 'package:flipper_web/features/login/pin_screen.dart';
import 'package:flipper_web/features/login/signup_view.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authRefresh = ValueNotifier<int>(0);

  // Listen to auth state and trigger refreshes
  ref.listen<AsyncValue<login_auth.AuthState>>(
    login_auth.authStateProvider,
    (_, __) => authRefresh.value++,
  );

  ref.onDispose(() {
    authRefresh.dispose();
  });

  final authState = ref.watch(login_auth.authStateProvider);

  return GoRouter(
    refreshListenable: authRefresh,
    routes: [
      // Root shows AuthWrapper which will choose appropriate screen
      GoRoute(path: '/', builder: (context, state) => const AuthWrapper()),
      // Public routes
      GoRoute(path: '/login', builder: (context, state) => const PinScreen()),
      GoRoute(path: '/signup', builder: (context, state) => const SignupView()),
      // Protected dashboard route - when user is authenticated navigate here
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
    ],
    redirect: (context, state) {
      if (authState is AsyncLoading) return null;

      final isAuthenticated = authState.maybeWhen(
        data: (s) => s == login_auth.AuthState.authenticated,
        orElse: () => false,
      );

      final goingToLogin = state.uri.path == '/login';
      final goingToDashboard =
          state.uri.path == '/dashboard' || state.uri.path == '/';

      // If authenticated and trying to access login, send to /dashboard
      if (isAuthenticated && goingToLogin) {
        return '/dashboard';
      }

      // If unauthenticated and trying to access dashboard (or root which maps to dashboard for auth), send to /login
      if (!isAuthenticated &&
          goingToDashboard &&
          state.uri.path == '/dashboard') {
        return '/login';
      }

      // No-op otherwise
      return null;
    },
  );
});
