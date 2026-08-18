import 'package:flipper_hr/features/people/people_page.dart';
import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/features/business_selection/business_selection_providers.dart';
import 'package:flipper_web/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Signed-in HR shell. Resolves the shared session to a business + branch and
/// hosts the HR module for it — today the people directory.
///
/// The scope is read here and passed to [PeoplePage] as plain ids, so HR
/// features never import flipper_web's selection providers themselves.
class HrHomeShell extends ConsumerStatefulWidget {
  const HrHomeShell({super.key});

  @override
  ConsumerState<HrHomeShell> createState() => _HrHomeShellState();
}

class _HrHomeShellState extends ConsumerState<HrHomeShell> {
  bool _isSigningOut = false;

  Future<void> _signOut() async {
    if (_isSigningOut) return;
    setState(() => _isSigningOut = true);
    try {
      await ref.read(authServiceProvider).signOut();
    } catch (e) {
      debugPrint('[flipper_hr] sign out failed: $e');
    } finally {
      if (mounted) {
        setState(() => _isSigningOut = false);
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(currentUserProfileProvider).value;
    final business = ref.watch(selectedBusinessProvider);
    final branch = ref.watch(selectedBranchProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flipper HR'),
        actions: [
          if (business != null)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Center(
                child: Text(
                  [business.name, branch?.name]
                      .where((v) => v != null && v.isNotEmpty)
                      .join(' · '),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          PopupMenuButton<String>(
            key: const Key('hr-account-menu'),
            tooltip: 'Account',
            icon: const Icon(Icons.account_circle_outlined),
            onSelected: (value) {
              switch (value) {
                case 'switch':
                  context.go('/business-selection');
                case 'signOut':
                  _signOut();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                enabled: false,
                child: Text(profile?.phoneNumber ?? 'Signed in'),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'switch',
                child: Text('Switch business or branch'),
              ),
              PopupMenuItem(
                value: 'signOut',
                child: Text(_isSigningOut ? 'Signing out…' : 'Sign out'),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: branch == null || business == null
          ? _NoBranchSelected(
              onPick: () => context.go('/business-selection'),
            )
          : PeoplePage(
              businessId: business.id,
              branchId: branch.id,
              branchName: branch.name,
            ),
    );
  }
}

/// Reachable on a hard reload where the persisted selection did not restore.
class _NoBranchSelected extends StatelessWidget {
  const _NoBranchSelected({required this.onPick});

  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.store_outlined,
              size: 44,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text('Pick a branch to continue',
                style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'HR records belong to a branch, so choose the one you are '
              'working on.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onPick,
              icon: const Icon(Icons.swap_horiz),
              label: const Text('Choose business or branch'),
            ),
          ],
        ),
      ),
    );
  }
}
