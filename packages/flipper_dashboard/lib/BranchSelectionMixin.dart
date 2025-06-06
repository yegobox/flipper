// ignore_for_file: unused_result

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_models/providers/scan_mode_provider.dart';
import 'package:flipper_services/Miscellaneous.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_dashboard/utils/snack_bar_utils.dart';

import 'package:flipper_services/proxy.dart';
import 'package:flipper_routing/app.locator.dart' show locator;
import 'dart:async'; // Add missing import for Timer

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

  Future<void> handleBranchSelection(
    Branch branch,
    BuildContext context, {
    required void Function(String?) setLoadingState,
    required Future<void> Function(Branch) setDefaultBranch,
    required VoidCallback onComplete,
    required void Function(bool) setIsLoading,
  }) async {
    setLoadingState(branch.serverId?.toString());
    setIsLoading(true); // Set isLoading to true

    try {
      // Store the current branch ID before making changes
      final currentBranchId = ProxyService.box.readInt(key: 'branchId');

      // Only update if we're actually changing branches
      if (currentBranchId != branch.serverId) {
        // First update the database to maintain consistency
        await _syncBranchWithDatabase(branch);

        // Then update branch status in the database
        await _updateAllBranchesInactive();
        await _updateBranchActive(branch);

        // Call setDefaultBranch but wrap it in try/catch to prevent app reload
        try {
          // We're manually setting a flag to prevent app reload during branch switch
          await ProxyService.box
              .writeBool(key: 'branch_switching', value: true);
          await setDefaultBranch(branch);
          await ProxyService.box
              .writeBool(key: 'branch_switching', value: false);
        } catch (e) {
          await ProxyService.box
              .writeBool(key: 'branch_switching', value: false);
          print('Error in setDefaultBranch: $e');
          // Continue even if setDefaultBranch fails
        }

        // Force refresh of all branch-dependent data
        // This is critical to ensure variants are refreshed
        await _forceRefreshAfterBranchSwitch(branch.serverId!);
      }

      onComplete();
    } catch (e) {
      // Log the error but don't rethrow to prevent app from crashing
      print('Error switching branch: $e');
      await ProxyService.box.writeBool(key: 'branch_switching', value: false);
    } finally {
      setLoadingState(null);
      setIsLoading(false); // Set isLoading to false
    }
  }

  // New method to force refresh after branch switch
  Future<void> _forceRefreshAfterBranchSwitch(int branchId) async {
    try {
      // Set flags to trigger refresh in other components
      await ProxyService.box.writeBool(key: 'branch_switched', value: true);
      await ProxyService.box.writeInt(
          key: 'last_branch_switch_timestamp',
          value: DateTime.now().millisecondsSinceEpoch);
      await ProxyService.box.writeInt(key: 'active_branch_id', value: branchId);

      // Force refresh of branch providers
      ref.invalidate(branchesProvider((includeSelf: false)));

      // Trigger a search refresh to force variant reload
      // First emit "search" to trigger the refresh
      ref.read(searchStringProvider.notifier).emitString(value: "search");
      // Then clear it to reset the search state
      ref.read(searchStringProvider.notifier).emitString(value: "");

      // Directly call refreshAfterBranchSwitch to ensure UI updates
      refreshAfterBranchSwitch();

      // Show a snackbar to indicate the branch switch
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        showCustomSnackBarUtil(
          context,
          'Branch switched. Refreshing data...',
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      print('Error in _forceRefreshAfterBranchSwitch: $e');
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
    List<Branch>? branches,
    String? loadingItemId,
    required Future<void> Function(Branch branch) setDefaultBranch,
    required Future<void> Function(
      Branch branch,
      BuildContext context, {
      required void Function(String? id) setLoadingState,
      required Future<void> Function(Branch branch) setDefaultBranch,
      required VoidCallback onComplete,
      required void Function(bool) setIsLoading,
    }) handleBranchSelection,
    required VoidCallback onLogout,
    required void Function(String? id) setLoadingState,
  }) async {
    // Show dialog immediately without waiting for branches
    await showDialog(
      context: context,
      builder: (context) {
        return _BranchSwitchDialog(
          branches: branches,
          loadingItemId: loadingItemId,
          setDefaultBranch: setDefaultBranch,
          handleBranchSelection: handleBranchSelection,
          onLogout: onLogout,
          setLoadingState: setLoadingState,
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
        serverId: ProxyService.box.getBusinessId()!, includeSelf: false);
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
    // Update the branch ID in storage
    await ProxyService.box.writeInt(key: 'branchId', value: branch.serverId!);
    await ProxyService.box.writeString(key: 'branchIdString', value: branch.id);
    // No need to reload the app, we'll handle UI updates separately
  }

  // Helper method to get the current branch ID
  int? getCurrentBranchId() {
    return ProxyService.box.readInt(key: 'branchId');
  }

  // Helper method to refresh data after branch switch without app reload
  void refreshAfterBranchSwitch() {
    // This method refreshes data after branch switch without requiring a full app reload
    try {
      // Force a refresh of branch providers
      ref.invalidate(branchesProvider((includeSelf: false)));

      // Set a flag in storage to indicate a branch switch occurred
      // This can be used by other widgets to detect when they should refresh
      ProxyService.box.writeBool(key: 'branch_switched', value: true);
      ProxyService.box.writeInt(
          key: 'last_branch_switch_timestamp',
          value: DateTime.now().millisecondsSinceEpoch);

      // Show a snackbar to indicate the branch switch
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        showCustomSnackBarUtil(
          context,
          'Branch switched. Refreshing data...',
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      print('Error refreshing after branch switch: $e');
    }

    // Trigger a rebuild of the widget
    if (mounted) {
      setState(() {
        // Trigger a rebuild of the widget
      });
    }
  }
}

// Move _BranchSwitchDialog and its State outside the mixin
class _BranchSwitchDialog extends StatefulWidget {
  final List<Branch>? branches;
  final String? loadingItemId;
  final Future<void> Function(Branch branch) setDefaultBranch;
  final Future<void> Function(
    Branch branch,
    BuildContext context, {
    required void Function(String? id) setLoadingState,
    required Future<void> Function(Branch branch) setDefaultBranch,
    required VoidCallback onComplete,
    required void Function(bool) setIsLoading,
  }) handleBranchSelection;
  final VoidCallback onLogout;
  final void Function(String? id) setLoadingState;

  const _BranchSwitchDialog({
    Key? key,
    this.branches,
    this.loadingItemId,
    required this.setDefaultBranch,
    required this.handleBranchSelection,
    required this.onLogout,
    required this.setLoadingState,
  }) : super(key: key);

  @override
  State<_BranchSwitchDialog> createState() => _BranchSwitchDialogState();
}

class _BranchSwitchDialogState extends State<_BranchSwitchDialog> {
  bool _isLoading = false;
  List<Branch>? _branches;

  @override
  void initState() {
    super.initState();
    _branches = widget.branches;

    // If branches weren't provided, fetch them immediately
    if (_branches == null) {
      _isLoading = true;
      _fetchBranches();
    }
  }

  Future<void> _fetchBranches() async {
    try {
      final branches = await ProxyService.strategy.branches(
        serverId: ProxyService.box.getBusinessId()!,
        includeSelf: false,
      );

      if (mounted) {
        setState(() {
          _branches = branches;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      // Show error if needed
    }
  }

  @override
  Widget build(BuildContext context) {
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
        child: _isLoading && _branches == null
            ? _buildLoadingContent()
            : _buildDialogContent(),
      ),
    );
  }

  Widget _buildLoadingContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
              ],
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  widget.onLogout();
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
        const SizedBox(height: 40),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Loading branches...',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDialogContent() {
    if (_branches == null || _branches!.isEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
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
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                ],
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    widget.onLogout();
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
          const SizedBox(height: 40),
          Center(
            child: Text(
              'No branches available',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
        ],
      );
    }

    return _buildDialog(_branches!);
  }

  Widget _buildDialog(List<Branch> branches) {
    // Add state management for search
    final searchController = TextEditingController();
    final searchNotifier = ValueNotifier<String>('');
    // Get the current branch ID for comparison
    final currentBranchId = ProxyService.box.readInt(key: 'branchId');

    Timer? _debounce;

    void _onSearchChanged(String value) {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 200), () {
        searchNotifier.value = value;
      });
    }

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
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                    ),
                  ],
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      widget.onLogout();
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
                onChanged: _onSearchChanged,
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
                  final int currentBusinessId =
                      ProxyService.box.getBusinessId() ?? 0;
                  final searchLower = searchValue.toLowerCase();
                  final filteredBranches = branches.where((branch) {
                    if (branch.businessId != currentBusinessId) return false;
                    final name = branch.name?.toLowerCase() ?? '';
                    return name.contains(searchLower);
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
                  // Use ListView.builder for efficiency
                  return ListView.builder(
                    itemCount: filteredBranches.length,
                    itemBuilder: (context, index) {
                      final branch = filteredBranches[index];
                      // Check if this is the current active branch
                      final isActive = branch.serverId == currentBranchId;
                      final isLoading =
                          widget.loadingItemId == branch.serverId?.toString();

                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            // Prevent multiple taps while processing
                            if (widget.loadingItemId != null) return;
                            showCustomSnackBarUtil(
                              context,
                              'Switching to ${branch.name}...',
                              duration: const Duration(seconds: 2),
                            );

                            widget.handleBranchSelection(
                              branch,
                              context,
                              setLoadingState: widget.setLoadingState,
                              setDefaultBranch: (branch) async {
                                // Wrap the setDefaultBranch call to prevent app reload
                                try {
                                  // We'll do a minimal update that won't trigger a full app reload
                                  return Future.value();
                                } catch (e) {
                                  print(
                                      'Error in modified setDefaultBranch: $e');
                                  return Future.value();
                                }
                              },
                              onComplete: () {
                                Navigator.of(context).pop();
                                // Don't reload the entire app, just refresh the current view
                                // This prevents getting stuck in the startup view
                                if (mounted) {
                                  showCustomSnackBarUtil(
                                    context,
                                    'Switched to ${branch.name}',
                                    duration: const Duration(seconds: 2),
                                  );
                                }
                              },
                              setIsLoading: (_) {},
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on_rounded,
                                  color: isActive
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context)
                                          .iconTheme
                                          .color
                                          ?.withOpacity(0.7),
                                  size: 24,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        branch.name ?? '',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: isActive
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.color,
                                        ),
                                      ),
                                      if (isActive) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          'Active Branch',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color:
                                                Theme.of(context).primaryColor,
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
                                else if (isActive)
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
