import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/models/user_profile.dart';
import 'package:flipper_web/repositories/user_repository.dart';
import 'package:go_router/go_router.dart';

/// Shows a dialog for selecting a branch
///
/// Displays a list of branches for the selected business and allows the user
/// to switch between them. Also includes a logout option.
Future<void> showBranchSelectionDialog(
  BuildContext context,
  WidgetRef ref,
) async {
  // Get the selected business
  final selectedBusiness = ref.read(selectedBusinessProvider);
  if (selectedBusiness == null) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('No business selected')));
    return;
  }

  // Get the user repository
  final userRepository = ref.read(userRepositoryProvider);

  // String to track which branch is being updated
  String? loadingItemId;

  // Show dialog with branch selection
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: 400,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              padding: const EdgeInsets.all(20),
              child: FutureBuilder<List<Branch>>(
                future: userRepository.getBranchesForBusiness(
                  selectedBusiness.serverId.toString(),
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error loading branches: ${snapshot.error}'),
                    );
                  }

                  final branches = snapshot.data ?? [];

                  if (branches.isEmpty) {
                    return const Center(child: Text('No branches available'));
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Switch Branch',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const Divider(),
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: branches.length,
                          itemBuilder: (context, index) {
                            final branch = branches[index];
                            final selectedBranch = ref.watch(
                              selectedBranchProvider,
                            );
                            final isSelected = selectedBranch?.id == branch.id;
                            final isLoading = loadingItemId == branch.id;

                            return Material(
                              color: Colors.transparent,
                              child: ListTile(
                                leading: isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Icon(
                                        Icons.store,
                                        color: isSelected
                                            ? Colors.blue
                                            : Colors.grey,
                                      ),
                                title: Text(
                                  branch.name,
                                  style: TextStyle(
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                                subtitle: Text(branch.description),
                                trailing: isSelected
                                    ? const Icon(
                                        Icons.check_circle,
                                        color: Colors.blue,
                                      )
                                    : null,
                                selected: isSelected,
                                onTap: isLoading
                                    ? null
                                    : () async {
                                        // Set loading state
                                        setState(() {
                                          loadingItemId = branch.id;
                                        });

                                        try {
                                          // Update all branches to inactive first
                                          for (final br in branches) {
                                            final updatedBranch = Branch(
                                              id: br.id,
                                              description: br.description,
                                              name: br.name,
                                              longitude: br.longitude,
                                              latitude: br.latitude,
                                              businessId: br.businessId,
                                              serverId: br.serverId,
                                              active: false,
                                              isDefault: false,
                                            );
                                            await userRepository.updateBranch(
                                              updatedBranch,
                                            );
                                          }

                                          // Update the selected branch to active and default
                                          final selectedBranch = Branch(
                                            id: branch.id,
                                            description: branch.description,
                                            name: branch.name,
                                            longitude: branch.longitude,
                                            latitude: branch.latitude,
                                            businessId: branch.businessId,
                                            serverId: branch.serverId,
                                            active: true,
                                            isDefault: true,
                                          );
                                          await userRepository.updateBranch(
                                            selectedBranch,
                                          );

                                          // Set the selected branch in the provider
                                          ref
                                                  .read(
                                                    selectedBranchProvider
                                                        .notifier,
                                                  )
                                                  .state =
                                              selectedBranch;

                                          // Clear loading state and close dialog
                                          if (context.mounted) {
                                            setState(() {
                                              loadingItemId = null;
                                            });
                                            Navigator.pop(context);

                                            // Show a confirmation message
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Switched to branch: ${branch.name}',
                                                ),
                                              ),
                                            );
                                          }
                                        } catch (e) {
                                          // Clear loading state on error
                                          setState(() {
                                            loadingItemId = null;
                                          });
                                          // Show error message
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Error switching branch: $e',
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                      },
                              ),
                            );
                          },
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: const Text(
                          'Sign out',
                          style: TextStyle(color: Colors.red),
                        ),
                        onTap: () {
                          // Handle logout
                          Navigator.pop(context);
                          // Navigate to login screen
                          context.goNamed(AppRoute.login.name);
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      );
    },
  );
}
