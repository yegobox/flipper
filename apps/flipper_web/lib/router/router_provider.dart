import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flipper_web/features/login/auth_providers.dart' as login_auth;
import 'package:flipper_web/features/login/auth_wrapper.dart';
import 'package:flipper_web/features/dashboard/dashboard_screen.dart';
import 'package:flipper_web/features/login/pin_screen.dart';
import 'package:flipper_web/features/login/signup_view.dart';
import 'package:flipper_web/features/business_selection/business_selection_wrapper.dart';

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
      // Business selection screen after authentication
      GoRoute(
        path: '/business-selection',
        name: 'businessSelection',
        builder: (context, state) => const BusinessSelectionWrapper(),
      ),
      // Protected dashboard route - when user is authenticated navigate here
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
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
      final goingToDashboard = state.uri.path == '/dashboard';
      final goingToBusinessSelection = state.uri.path == '/business-selection';
      final goingToRoot = state.uri.path == '/';

      // If authenticated, handle routing based on business/branch selection
      if (isAuthenticated) {
        if (goingToLogin) {
          // After login, go to business selection first
          // We always show business selection screen after login
          return '/business-selection';
        }

        // For root path, let AuthWrapper handle the redirection
        // It will check if business/branch is selected via Ditto
        if (goingToRoot) {
          return null;
        }
      } else {
        // If not authenticated and trying to access protected routes
        if (goingToBusinessSelection || goingToDashboard) {
          return '/login';
        }
      }

      // No-op otherwise
      return null;
    },
  );
});
