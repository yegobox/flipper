import 'package:flipper_web/features/business_selection/business_selection_providers.dart';
import 'package:flipper_web/features/business_selection/selected_business_restore.dart';
import 'package:flipper_web/features/login/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Entry point at `/`: sends the session to login, business selection or HR.
///
/// Mirrors flipper_web's `AuthWrapper` but lands on HR instead of Books. The
/// profile + business/branch restore providers are the same ones Books uses, so
/// a page reload keeps the branch that was picked at login.
class HrAuthGate extends ConsumerWidget {
  const HrAuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      loading: () => const _HrGateLoading(),
      error: (error, _) => _HrGateMessage(
        message: 'Could not check your session: $error',
        onRetry: () => ref.invalidate(authStateProvider),
      ),
      data: (state) {
        if (state == AuthState.unauthenticated) {
          _goOnce(context, '/login');
          return const _HrGateLoading();
        }

        // Restores the persisted business/branch before HR reads them.
        ref.watch(selectedBusinessRestoreProvider);
        final hasSelection = ref.watch(hasSelectedBusinessAndBranchProvider);

        return hasSelection.when(
          loading: () => const _HrGateLoading(),
          error: (error, _) => _HrGateMessage(
            message: 'Could not load your businesses: $error',
            onRetry: () => ref.invalidate(hasSelectedBusinessAndBranchProvider),
          ),
          data: (selected) {
            _goOnce(context, selected ? '/people' : '/business-selection');
            return const _HrGateLoading();
          },
        );
      },
    );
  }

  void _goOnce(BuildContext context, String location) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      if (GoRouterState.of(context).uri.path != location) {
        context.go(location);
      }
    });
  }
}

class _HrGateLoading extends StatelessWidget {
  const _HrGateLoading();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class _HrGateMessage extends StatelessWidget {
  const _HrGateMessage({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 40,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  message.replaceFirst('Exception: ', ''),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () => context.go('/login'),
                      child: const Text('Back to sign in'),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: onRetry,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
