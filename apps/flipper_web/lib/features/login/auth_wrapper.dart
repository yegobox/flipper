
import 'package:flipper_web/features/dashboard/dashboard_screen.dart';
import 'package:flipper_web/features/login/auth_providers.dart';
import 'package:flipper_web/features/login/pin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (state) {
        switch (state) {
          case AuthState.authenticated:
            return const DashboardScreen();
          case AuthState.unauthenticated:
            return const PinScreen();
        }
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
