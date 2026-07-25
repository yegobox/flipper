// ignore_for_file: unused_result

import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/services/bar_mode_branch_settings_service.dart';
import 'package:flipper_models/providers/branch_business_provider.dart';
import 'package:flipper_models/providers/scan_mode_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_services/Miscellaneous.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flipper_services/locator.dart' as loc;
import 'package:flipper_services/proxy.dart';
import 'package:flipper_routing/app.locator.dart' show locator;
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
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
                      blurRadius: 8.0,
                    ),
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
                  : Icon(
                      icon,
                      color: isSelected ? Colors.blue : Colors.grey[600],
                    ),
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
    // Prevent multiple branch switches at once
    if (ProxyService.box.readBool(key: 'branch_switching') ?? false) {
      print('Branch switch already in progress, ignoring request');
      return;
    }
    setLoadingState(branch.id.toString());
    setIsLoading(true);
    final appService = loc.getIt<AppService>();

    try {
      // Store the current branch ID before making changes
      final currentBranchId = ProxyService.box.getBranchId();

      // Only update if we're actually changing branches
      if (currentBranchId != branch.id) {
        // First update the database to maintain consistency
        await _syncBranchWithDatabase(branch);

        // Then update branch status in the database
        await appService.updateAllBranchesInactive();
        await _updateBranchActive(branch);

        // Register (idempotent, sequenced) Ditto cloud subscriptions for the
        // newly active branch. In-app switching never called this before, so
        // a branch with no subscription yet would only get one reactively —
        // from the first variants query the destination screen fires — right
        // as that screen mounts, piling the whole-catalog pull on top of the
        // render. Kicking it off now, during this loading state, spreads that
        // out instead. Fire-and-forget: does not block the switch.
        appService.ensureBranchDittoSubscriptionsForCurrentBranch();

        // Call setDefaultBranch but wrap it in try/catch to prevent app reload
        try {
          // We're manually setting a flag to prevent app reload during branch switch
          await ProxyService.box.writeBool(
            key: 'branch_switching',
            value: true,
          );
          await setDefaultBranch(branch);
          await ProxyService.box.writeBool(
            key: 'branch_switching',
            value: false,
          );
        } catch (e) {
          await ProxyService.box.writeBool(
            key: 'branch_switching',
            value: false,
          );
          print('Error in setDefaultBranch: $e');
          // Continue even if setDefaultBranch fails
        }

        // Force refresh of all branch-dependent data
        // This is critical to ensure variants are refreshed
        await _forceRefreshAfterBranchSwitch(branch.id);
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

  // Method to force refresh after branch switch without causing navigation loops
  Future<void> _forceRefreshAfterBranchSwitch(String branchId) async {
    try {
      // Set flags to trigger refresh in other components
      await ProxyService.box.writeBool(key: 'branch_switched', value: true);
      await ProxyService.box.writeInt(
        key: 'last_branch_switch_timestamp',
        value: DateTime.now().millisecondsSinceEpoch,
      );
      await ProxyService.box.writeString(
        key: 'active_branch_id',
        value: branchId,
      );

      // Force refresh of branch providers
      ref.invalidate(
        branchesProvider(businessId: ProxyService.box.getBusinessId()),
      );
      ref.invalidate(activeBranchProvider);
      ref.invalidate(customersProvider);

      await BarModeBranchSettingsService.hydrateForActiveBranch();

      // Add a small delay to ensure branch ID is fully set before invalidating transaction providers
      await Future.delayed(Duration(milliseconds: 100));

      // Invalidate transaction providers to refresh for new branch
      ref.invalidate(pendingTransactionStreamProvider);
      ref.invalidate(transactionItemsStreamProvider);

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
    showLogoutLoadingDialog(context, useRootNavigator: true);
    try {
      await onLogout();
    } finally {
      final rootNav = Navigator.of(context, rootNavigator: true);
      if (rootNav.mounted && rootNav.canPop()) {
        rootNav.pop();
      }
    }
    routerService.clearStackAndShow(const LoginRoute());
  }

  Future<bool> showLogoutConfirmationDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(context.flipperL10n.confirmLogout),
          content: Text(context.flipperL10n.confirmLogoutMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(context.flipperL10n.cancel),
            ),
            TextButton(
              onPressed: () async {
                showLogoutLoadingDialog(context);
                await CoreMiscellaneous.logoutStatic();
                Navigator.of(context).pop(); // Dismiss the loading dialog
                locator<RouterService>().navigateTo(LoginRoute());
              },
              child: Text(context.flipperL10n.logOut),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
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
    required Future<void> Function(Branch branch) setDefaultBranch,
    required Future<void> Function(
      Branch branch,
      BuildContext context, {
      required void Function(String? id) setLoadingState,
      required Future<void> Function(Branch branch) setDefaultBranch,
      required VoidCallback onComplete,
      required void Function(bool) setIsLoading,
    })
    handleBranchSelection,
    required Future<void> Function() onLogout,
  }) async {
    // Check if we're already in the middle of branch navigation
    // This prevents the branch selection dialog from showing up again during navigation
    if (ProxyService.box.readBool(key: 'branch_navigation_in_progress') ??
        false) {
      print(
        'Branch navigation already in progress, skipping branch selection dialog',
      );
      return;
    }
    // Show dialog immediately without waiting for branches
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return _BranchSwitchDialog(
          branches: branches,
          setDefaultBranch: setDefaultBranch,
          handleBranchSelection: handleBranchSelection,
          onLogout: onLogout,
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
                        : Theme.of(
                            context,
                          ).iconTheme.color?.withValues(alpha: .7),
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

  void showLogoutLoadingDialog(
    BuildContext context, {
    bool useRootNavigator = false,
  }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      useRootNavigator: useRootNavigator,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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

  Future<void> _updateBranchActive(Branch branch) async {
    await ProxyService.strategy.updateBranch(
      branchId: branch.id,
      active: true,
      isDefault: true,
    );
  }

  Future<void> _syncBranchWithDatabase(Branch branch) async {
    // Update the branch ID in storage with explicit flush
    await ProxyService.box.writeString(key: 'branchId', value: branch.id);
    await ProxyService.box.writeString(key: 'branchIdString', value: branch.id);

    // Force flush to ensure data is written to storage immediately

    // Verify the branch ID was set correctly
    final verifyBranchId = ProxyService.box.getBranchId();
    if (verifyBranchId != branch.id) {
      throw StateError(
        'Failed to set branch ID properly: expected ${branch.id}, got $verifyBranchId',
      );
    }
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
      ref.invalidate(
        branchesProvider(businessId: ProxyService.box.getBusinessId()),
      );

      // Invalidate transaction providers to refresh for new branch
      ref.invalidate(pendingTransactionStreamProvider);
      ref.invalidate(transactionItemsStreamProvider);

      // Set a flag in storage to indicate a branch switch occurred
      // This can be used by other widgets to detect when they should refresh
      ProxyService.box.writeBool(key: 'branch_switched', value: true);
      ProxyService.box.writeInt(
        key: 'last_branch_switch_timestamp',
        value: DateTime.now().millisecondsSinceEpoch,
      );

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
  final Future<void> Function(Branch branch) setDefaultBranch;
  final Future<void> Function(
    Branch branch,
    BuildContext context, {
    required void Function(String? id) setLoadingState,
    required Future<void> Function(Branch branch) setDefaultBranch,
    required VoidCallback onComplete,
    required void Function(bool) setIsLoading,
  })
  handleBranchSelection;
  final Future<void> Function() onLogout;

  const _BranchSwitchDialog({
    Key? key,
    this.branches,
    required this.setDefaultBranch,
    required this.handleBranchSelection,
    required this.onLogout,
  }) : super(key: key);

  @override
  State<_BranchSwitchDialog> createState() => _BranchSwitchDialogState();
}

class _BranchSwitchDialogState extends State<_BranchSwitchDialog> {
  bool _isFetchingBranches = false;
  bool _isSwitching = false;
  String? _loadingBranchId;
  String? _switchStatusMessage;
  List<Branch>? _branches;

  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<String> _searchQuery = ValueNotifier('');
  Timer? _searchDebounce;

  Future<void> _handleLogoutTap() async {
    if (_isSwitching) return;
    Navigator.of(context).pop();
    await widget.onLogout();
  }

  @override
  void initState() {
    super.initState();
    _branches = widget.branches;

    if (_branches == null) {
      _isFetchingBranches = true;
      _fetchBranches();
    }
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    _searchQuery.dispose();
    super.dispose();
  }

  Future<void> _fetchBranches() async {
    try {
      final userId = ProxyService.box.getUserId();
      final businessId = ProxyService.box.getBusinessId();

      if (userId == null || businessId == null) {
        if (mounted) setState(() => _isFetchingBranches = false);
        return;
      }

      final List<Map<String, dynamic>> branchesJson = await ProxyService.ditto
          .getBranches(userId, businessId);

      final branches = branchesJson.map((j) => Branch.fromMap(j)).toList();

      if (mounted) {
        setState(() {
          _branches = branches;
          _isFetchingBranches = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isFetchingBranches = false);
      }
    }
  }

  void _onSearchChanged(String value) {
    if (_searchDebounce?.isActive ?? false) _searchDebounce!.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 200), () {
      _searchQuery.value = value;
    });
  }

  Future<void> _selectBranch(Branch branch) async {
    if (_isSwitching) return;

    final currentBranchId = ProxyService.box.getBranchId();
    if (branch.id == currentBranchId) {
      Navigator.of(context).pop();
      return;
    }

    final branchName = branch.name ?? 'branch';
    setState(() {
      _isSwitching = true;
      _loadingBranchId = branch.id.toString();
      _switchStatusMessage = 'Switching to $branchName…';
    });

    await widget.handleBranchSelection(
      branch,
      context,
      setLoadingState: (id) {
        if (mounted) setState(() => _loadingBranchId = id);
      },
      setDefaultBranch: widget.setDefaultBranch,
      onComplete: () {
        if (!mounted) return;

        ProxyService.box.writeBool(
          key: 'branch_navigation_in_progress',
          value: true,
        );

        locator<RouterService>().replaceWith(FlipperAppRoute());
        Navigator.of(context).pop();

        showCustomSnackBarUtil(
          context,
          'Switched to $branchName',
          duration: const Duration(seconds: 2),
        );

        Future.delayed(const Duration(seconds: 2), () {
          ProxyService.box.writeBool(
            key: 'branch_navigation_in_progress',
            value: false,
          );
        });
      },
      setIsLoading: (loading) {
        if (!mounted) return;
        setState(() {
          _isSwitching = loading;
          if (!loading) {
            _loadingBranchId = null;
            _switchStatusMessage = null;
          }
        });
      },
    );
  }

  TextStyle get _titleStyle => TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
    color: Theme.of(context).textTheme.titleLarge?.color,
  );

  Widget _buildHeader({bool showLogout = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.location_on_rounded,
              color: Theme.of(context).primaryColor,
              size: 26,
            ),
            const SizedBox(width: 10),
            Text('Switch Branch', style: _titleStyle),
          ],
        ),
        if (showLogout)
          TextButton.icon(
            onPressed: _isSwitching ? null : _handleLogoutTap,
            icon: Icon(
              Icons.logout_rounded,
              size: 18,
              color: Theme.of(context).colorScheme.error,
            ),
            label: Text(
              'Logout',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSwitchStatusBar() {
    if (!_isSwitching || _switchStatusMessage == null) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _switchStatusMessage!,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBranchRow({
    required Branch branch,
    required bool isActive,
    required bool isLoading,
  }) {
    final theme = Theme.of(context);
    final canTap = !_isSwitching && !isActive;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: canTap ? () => _selectBranch(branch) : null,
        child: MouseRegion(
          cursor: canTap ? SystemMouseCursors.click : SystemMouseCursors.basic,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isActive
                  ? theme.primaryColor.withValues(alpha: 0.08)
                  : null,
              borderRadius: BorderRadius.circular(12),
              border: isActive
                  ? Border.all(
                      color: theme.primaryColor.withValues(alpha: 0.25),
                    )
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on_rounded,
                  color: isActive
                      ? theme.primaryColor
                      : theme.iconTheme.color?.withValues(alpha: 0.7),
                  size: 22,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        branch.name ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isActive
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: isActive
                              ? theme.primaryColor
                              : theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                      if (isActive) ...[
                        const SizedBox(height: 2),
                        Text(
                          'Active branch',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (isLoading)
                  SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.primaryColor,
                      ),
                    ),
                  )
                else if (isActive)
                  Icon(
                    Icons.check_circle_rounded,
                    color: theme.primaryColor,
                    size: 22,
                  )
                else
                  Icon(
                    Icons.chevron_right_rounded,
                    color: theme.iconTheme.color?.withValues(alpha: 0.45),
                    size: 22,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
        constraints: const BoxConstraints(maxHeight: 480, minWidth: 420),
        decoration: BoxDecoration(
          color: DialogTheme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: _isFetchingBranches && _branches == null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(showLogout: false),
                  const SizedBox(height: 36),
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Loading branches…',
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ],
              )
            : _buildBranchListContent(),
      ),
    );
  }

  Widget _buildBranchListContent() {
    final branches = _branches;
    if (branches == null || branches.isEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          const SizedBox(height: 36),
          Text(
            'No branches available',
            style: TextStyle(
              fontSize: 15,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ],
      );
    }

    final currentBranchId = ProxyService.box.getBranchId();
    final currentBusinessId = ProxyService.box.getBusinessId() ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: .5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            enabled: !_isSwitching,
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search branches…',
              border: InputBorder.none,
              icon: Icon(Icons.search, color: Theme.of(context).hintColor),
              suffixIcon: ValueListenableBuilder<String>(
                valueListenable: _searchQuery,
                builder: (context, searchValue, _) {
                  return searchValue.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: _isSwitching
                              ? null
                              : () {
                                  _searchController.clear();
                                  _searchQuery.value = '';
                                },
                        )
                      : const SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ValueListenableBuilder<String>(
            valueListenable: _searchQuery,
            builder: (context, searchValue, _) {
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
                        size: 44,
                        color: Theme.of(context).hintColor,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No branches found',
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                itemCount: filteredBranches.length,
                separatorBuilder: (_, __) => const SizedBox(height: 4),
                itemBuilder: (context, index) {
                  final branch = filteredBranches[index];
                  final isActive = branch.id == currentBranchId;
                  final isLoading = _loadingBranchId == branch.id.toString();

                  return _buildBranchRow(
                    branch: branch,
                    isActive: isActive,
                    isLoading: isLoading,
                  );
                },
              );
            },
          ),
        ),
        _buildSwitchStatusBar(),
      ],
    );
  }
}
