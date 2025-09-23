import 'package:flipper_web/features/dashboard/dashboard_screen.dart';
import 'package:flipper_web/features/home/home_screen.dart';
import 'package:flipper_web/features/login/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (state) {
        switch (state) {
          case AuthState.authenticated:
            // Ensure the URL reflects the dashboard route for web
            // Use GoRouter to navigate if we're not already on /dashboard
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final current = Uri.base.path;
              if (current != '/dashboard') {
                context.go('/dashboard');
              }
            });
            // Return the DashboardScreen as the current content while navigation happens
            return const DashboardScreen();
          case AuthState.unauthenticated:
            // If unauthenticated, ensure we land on the home screen
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final current = Uri.base.path;
              if (current != '/') {
                context.go('/');
              }
            });
            return const HomeScreen();
        }
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) =>
          Scaffold(body: Center(child: Text('Error: $error'))),
    );
  }
}
