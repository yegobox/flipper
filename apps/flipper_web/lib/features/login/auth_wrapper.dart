import 'package:flipper_web/features/business_selection/business_selection_providers.dart';
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
            // Use the hasSelectedBusinessAndBranch provider to check if business and branch are selected
            final hasSelectedBusinessAndBranchAsync = ref.watch(
              hasSelectedBusinessAndBranchProvider,
            );

            return hasSelectedBusinessAndBranchAsync.when(
              data: (hasSelected) {
                // Ensure the URL reflects the appropriate route for web
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final current = Uri.base.path;
                  if (hasSelected && current != '/dashboard') {
                    context.go('/dashboard');
                  } else if (!hasSelected && current != '/business-selection') {
                    context.go('/business-selection');
                  }
                });

                // Return a loading screen as the current content while navigation happens
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              },
              loading: () => const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => Scaffold(
                body: Center(child: Text('Error checking preferences: $error')),
              ),
            );
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
