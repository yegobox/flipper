import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Resolves the shared business/branch selection and hands it to [builder] as
/// plain ids.
///
/// Branch-scoped modules (the roster, the approvals queue) go through here so HR
/// features never import flipper_web's selection providers themselves, and so the
/// "no branch picked" state is written once. Self-service leave deliberately does
/// NOT use this: an invited employee has no branch selection, and their own record
/// already says which branch they are on.
class HrBranchScope extends ConsumerWidget {
  const HrBranchScope({super.key, required this.builder});

  final Widget Function(
    BuildContext context, {
    required String businessId,
    required String branchId,
    required String? branchName,
  })
  builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final business = ref.watch(selectedBusinessProvider);
    final branch = ref.watch(selectedBranchProvider);

    if (business == null || branch == null) {
      return _NoBranchSelected(onPick: () => context.go('/business-selection'));
    }
    return builder(
      context,
      businessId: business.id,
      branchId: branch.id,
      branchName: branch.name,
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
            Text(
              'Pick a branch to continue',
              style: theme.textTheme.titleMedium,
            ),
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
