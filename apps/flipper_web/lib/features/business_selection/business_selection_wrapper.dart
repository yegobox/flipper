import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/features/business_selection/business_selection_providers.dart';
import 'package:flipper_web/features/business_selection/login_choices_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BusinessSelectionWrapper extends ConsumerWidget {
  const BusinessSelectionWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(currentUserProfileProvider);

    return userProfileAsync.when(
      loading: () => Scaffold(
        backgroundColor: LoginChoicesTokens.app,
        body: LoginChoicesBackground(
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      error: (error, _) => _ErrorScaffold(
        message: error.toString().replaceFirst('Exception: ', ''),
        onRetry: () => ref.refresh(currentUserProfileProvider),
        onBack: () => context.go('/login'),
      ),
      data: (userProfile) {
        if (userProfile == null) {
          return _ErrorScaffold(
            message:
                'Could not load your profile. This may happen if the network '
                'is unavailable or your session has expired.',
            onRetry: () => ref.refresh(currentUserProfileProvider),
            onBack: () => context.go('/login'),
          );
        }
        return BusinessBranchSelector(userProfile: userProfile);
      },
    );
  }
}

class _ErrorScaffold extends StatelessWidget {
  const _ErrorScaffold({
    required this.message,
    required this.onRetry,
    required this.onBack,
  });

  final String message;
  final VoidCallback onRetry;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LoginChoicesTokens.app,
      body: LoginChoicesBackground(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: LoginChoicesTokens.signOut,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      color: LoginChoicesTokens.ink2,
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: onBack,
                    child: const Text('Back to login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
