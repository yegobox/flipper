// ignore_for_file: unused_result

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/Miscellaneous.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.router.dart';

import 'package:flipper_services/proxy.dart';
import 'package:flipper_routing/app.locator.dart' show locator;

mixin BranchSelectionMixin<T extends ConsumerStatefulWidget>
    on ConsumerState<T> {
  Widget buildBranchSelectionTile({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    required IconData icon,
    required String? loadingItemId,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.blue.withValues(alpha: .1)
                : Colors.grey[100],
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.transparent,
              width: 2.0,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                        color: Colors.blue.withValues(alpha: 0.3),
                        blurRadius: 8.0)
                  ]
                : null,
          ),
          child: Row(
            children: [
              (loadingItemId != null)
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(icon,
                      color: isSelected ? Colors.blue : Colors.grey[600]),
              const SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.blue : Colors.black,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: isSelected ? Colors.blue : Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> handleBranchSelection({
    required Branch branch,
    required BuildContext context,
    required Function(String?) setLoadingState,
    required Future<void> Function(Branch) setDefaultBranch,
    required VoidCallback onComplete,
    required Function(bool) setIsLoading, // Add this
  }) async {
    setLoadingState(branch.serverId?.toString());
    setIsLoading(true); // Set isLoading to true

    try {
      await _updateAllBranchesInactive();
      await _updateBranchActive(branch);
      await _syncBranchWithDatabase(branch);
      await setDefaultBranch(branch);
      onComplete();
    } finally {
      setLoadingState(null);
      setIsLoading(false); // Set isLoading to false
    }
  }

  Future<void> handleLogout({
    required BuildContext context,
    required Future<void> Function() onLogout,
    required RouterService routerService,
  }) async {
    await showLogoutLoadingDialog(context);
    await onLogout();
    Navigator.of(context).pop(); // Close loading dialog
    routerService.replaceWith(LoginRoute());
  }

  Future<bool> showLogoutConfirmationDialog(
    BuildContext context,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                showLogoutLoadingDialog(context);
                await CoreMiscellaneous.logoutStatic();
                Navigator.of(context).pop(); // Dismiss the loading dialog
                locator<RouterService>().navigateTo(LoginRoute());
              },
              child: const Text('Logout'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  Future<void> showBranchSwitchDialog({
    required BuildContext context,
    required Future<void> Function(Branch) setDefaultBranch,
    required Future<void> Function() onLogout,
    required Function(String?) setLoadingState,
    required String? loadingItemId,
    required List<Branch> branches,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (BuildContext context) {
        // Add state management for search
        final searchController = TextEditingController();
        final searchNotifier = ValueNotifier<String>('');

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            constraints: const BoxConstraints(maxHeight: 450, minWidth: 400),
            decoration: BoxDecoration(
              color: DialogThemeData().backgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          color: Theme.of(context).primaryColor,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Switch Branch',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.5,
                            color:
                                Theme.of(context).textTheme.titleLarge?.color,
                          ),
                        ),
                      ],
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () async {
                          await showLogoutConfirmationDialog(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: Row(
                            children: [
                              Icon(
                                Icons.logout_rounded,
                                color: Theme.of(context).colorScheme.error,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Logout',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Search box with functionality
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest
                        .withValues(alpha: .5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      searchNotifier.value = value.toLowerCase();
                    },
                    decoration: InputDecoration(
                      hintText: 'Search branches...',
                      border: InputBorder.none,
                      icon: Icon(
                        Icons.search,
                        color: Theme.of(context).hintColor,
                      ),
                      suffixIcon: ValueListenableBuilder<String>(
                        valueListenable: searchNotifier,
                        builder: (context, searchValue, _) {
                          return searchValue.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    searchController.clear();
                                    searchNotifier.value = '';
                                  },
                                )
                              : const SizedBox.shrink();
                        },
                      ),
                    ),
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ValueListenableBuilder<String>(
                    valueListenable: searchNotifier,
                    builder: (context, searchValue, _) {
                      final filteredBranches = branches.where((branch) {
                        final name = branch.name?.toLowerCase() ?? '';
                        return name.contains(searchValue);
                      }).toList();

                      if (filteredBranches.isEmpty && searchValue.isNotEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 48,
                                color: Theme.of(context).hintColor,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No branches found',
                                style: TextStyle(
                                  color: Theme.of(context).hintColor,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return buildBranchList(
                        branches: filteredBranches,
                        loadingItemId: loadingItemId,
                        onBranchSelected: (branch, context) =>
                            handleBranchSelection(
                          branch: branch,
                          context: context,
                          setLoadingState: setLoadingState,
                          setDefaultBranch: setDefaultBranch,
                          onComplete: () {
                            ref.refresh(tenantProvider);
                            final combinedNotifier = ref.read(refreshProvider);
                            combinedNotifier.performActions(
                                productName: "", scanMode: true);
                          },
                          setIsLoading: (bool value) {},
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildBranchList({
    required List<Branch> branches,
    required Function(Branch, BuildContext) onBranchSelected,
    required String? loadingItemId,
  }) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: branches.length,
      separatorBuilder: (_, __) => const Divider(height: 1, indent: 56),
      itemBuilder: (BuildContext context, int index) {
        final branch = branches[index];
        final isLoading = loadingItemId == branch.id;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => onBranchSelected(branch, context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    color: branch.isDefault ?? false
                        ? Theme.of(context).primaryColor
                        : Theme.of(context)
                            .iconTheme
                            .color
                            ?.withValues(alpha: .7),
                    size: 24,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          branch.name ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: branch.isDefault ?? false
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        if (branch.isDefault ?? false) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Default Branch',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (isLoading)
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                    )
                  else if (branch.isDefault ?? false)
                    Icon(
                      Icons.check_circle_rounded,
                      color: Theme.of(context).primaryColor,
                      size: 24,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> showLogoutLoadingDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          height: 160,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "We are logging you out...",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateAllBranchesInactive() async {
    final branches = await ProxyService.strategy.branches(
        businessId: ProxyService.box.getBusinessId()!, includeSelf: true);
    for (final branch in branches) {
      ProxyService.strategy.updateBranch(
          branchId: branch.serverId!, active: false, isDefault: false);
    }
  }

  Future<void> _updateBranchActive(Branch branch) async {
    await ProxyService.strategy.updateBranch(
        branchId: branch.serverId!, active: true, isDefault: true);
  }

  Future<void> _syncBranchWithDatabase(Branch branch) async {
    await ProxyService.box.writeInt(key: 'branchId', value: branch.serverId!);
  }
}
