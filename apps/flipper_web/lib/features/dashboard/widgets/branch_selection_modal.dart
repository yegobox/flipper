import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/features/business_selection/business_selection_providers.dart';
import 'package:flipper_web/services/auth_service.dart';
import 'package:go_router/go_router.dart';

class BranchSelectionModal extends ConsumerWidget {
  const BranchSelectionModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(currentUserProfileProvider);
    final selectedBranch = ref.watch(selectedBranchProvider);

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Account Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            
            // Current branch info
            if (selectedBranch != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.store, color: Colors.grey),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Branch',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            selectedBranch.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Switch branch button
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.goNamed(AppRoute.businessSelection.name);
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  alignment: Alignment.centerLeft,
                ),
                child: const Row(
                  children: [
                    Icon(Icons.swap_horiz, size: 20),
                    SizedBox(width: 12),
                    Text('Switch Branch'),
                  ],
                ),
              ),
            ),

            const Divider(),

            // Logout button
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => _logout(context, ref),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  alignment: Alignment.centerLeft,
                  foregroundColor: Colors.red,
                ),
                child: const Row(
                  children: [
                    Icon(Icons.logout, size: 20),
                    SizedBox(width: 12),
                    Text('Logout'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logout(BuildContext context, WidgetRef ref) async {
    Navigator.of(context).pop();
    try {
      final authService = ref.read(authServiceProvider);
      await authService.signOut();
      if (context.mounted) {
        context.goNamed(AppRoute.login.name);
      }
    } catch (e) {
      if (context.mounted) {
        context.goNamed(AppRoute.login.name);
      }
    }
  }
}