// igimport 'package:flipper_models/providers/branch_business_provider.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
// Import for payment plan route is already available from app.router.dart
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/posthog_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_personal/flipper_personal.dart';
// removed unused import
import 'dart:async';
import 'dart:io';
import 'package:flipper_models/ebm_helper.dart';
import 'package:flipper_services/Miscellaneous.dart';
import 'package:flipper_dashboard/BranchSelectionMixin.dart';
import 'package:flipper_dashboard/utils/error_handler.dart';
import 'package:flipper_models/providers/branch_business_provider.dart';
import 'package:flipper_routing/app.dialogs.dart';
import 'package:supabase_models/sync/ditto_sync_coordinator.dart';
// Import for payment plan route is already available from app.router.dart
// ignore: unnecessary_import

final selectedBusinessIdProvider = StateProvider<int?>((ref) => null);

class LoginChoices extends StatefulHookConsumerWidget {
  const LoginChoices({Key? key}) : super(key: key);

  @override
  _LoginChoicesState createState() => _LoginChoicesState();
}

class _LoginChoicesState extends ConsumerState<LoginChoices>
    with BranchSelectionMixin {
  bool _isSelectingBranch = false;
  bool _isLoading = false;
  String? _loadingItemId;
  Timer? _navigationTimer;

  final _routerService = locator<RouterService>();

  @override
  void initState() {
    super.initState();
    // Validate that userId is set before allowing access to this page
    _validateUserId();
  }

  /// Validates that userId is set in ProxyService.box before proceeding
  void _validateUserId() {
    final userId = ProxyService.box.getUserId();
    if (userId == null) {
      talker.error(
        'Accessing LoginChoices without userId set. Redirecting to login.',
      );
      // Navigate back to login screen if userId is not set
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _routerService.clearStackAndShow(LoginRoute());
        }
      });
    }
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Re-validate userId exists during build to prevent errors if it gets cleared
    final userId = ProxyService.box.getUserId();
    if (userId == null || userId <= 0) {
      talker.error(
        'UserId is not set or invalid in LoginChoices build. Redirecting to login.',
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _routerService.clearStackAndShow(LoginRoute());
      });
      // Show a loading indicator while redirecting
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Validating session...',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return ViewModelBuilder.nonReactive(
      viewModelBuilder: () => CoreViewModel(),
      builder: (context, viewModel, child) {
        final businesses = ref.watch(businessesProvider);
        final selectedBusinessId = ref.watch(selectedBusinessIdProvider);
        final branches = ref.watch(
          branchesProvider(businessId: selectedBusinessId),
        );

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 40.0,
              ),
              child: !_isLoading
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isSelectingBranch
                              ? 'Choose a Branch'
                              : 'Choose a Profile',
                          style: const TextStyle(
                            fontSize: 32.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          _isSelectingBranch
                              ? 'Select the branch you want to access'
                              : 'Select a profile you want to log into',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 32.0),
                        Expanded(
                          child: _isSelectingBranch
                              ? buildBranchList(
                                  // Use the mixin's method
                                  branches: branches.value ?? [],
                                  loadingItemId: _loadingItemId,
                                  onBranchSelected: (branch, context) =>
                                      _handleBranchSelection(branch, context),
                                )
                              : _buildBusinessList(
                                  businesses: businesses.value,
                                  selectedBusinessId: selectedBusinessId,
                                ),
                        ),
                      ],
                    )
                  : Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.black,
                          ),
                          strokeWidth: 3,
                          backgroundColor: Colors.grey.shade300,
                        ),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBusinessList({
    List<Business>? businesses,
    int? selectedBusinessId,
  }) {
    if (businesses == null) return const SizedBox();
    return ListView.separated(
      itemCount: businesses.length,
      separatorBuilder: (_, __) => const SizedBox(height: 24.0),
      itemBuilder: (context, index) {
        final business = businesses[index];
        return _buildSelectionTile(
          title: business.name!,
          isSelected: business.serverId == selectedBusinessId,
          onTap: () => _handleBusinessSelection(business),
          icon: Icons.business,
          isLoading: _loadingItemId == (business.serverId.toString()),
        );
      },
    );
  }

  Widget _buildSelectionTile({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    required IconData icon,
    required bool isLoading,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.blue.withValues(alpha: 0.1)
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
              isLoading
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

  Future<void> _handleBusinessSelection(Business business) async {
    // remove any branchId selected before
    await ProxyService.box.remove(key: 'branchId');
    setState(() {
      _loadingItemId = business.serverId.toString();
    });

    // Check if this is an individual business (businessTypeId == 2)
    if (business.businessTypeId == 2) {
      // Navigate to personal app screen
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const PersonalHomeScreen()),
        );
      }
      setState(() {
        _loadingItemId = null;
      });
      return;
    }

    ref.read(selectedBusinessIdProvider.notifier).state = business.serverId;
    try {
      // Save business ID to local storage
      await ProxyService.box.writeInt(
        key: 'businessId',
        value: business.serverId,
      );
      await _setDefaultBusiness(business);
      // Get the latest payment plan online.
      await ProxyService.strategy.getPaymentPlan(
        businessId: business.id,
        fetchOnline: true,
      );
      final branches = await ProxyService.strategy.branches(
        businessId: business.serverId,
        active: false,
      );

      if (branches.length == 1) {
        // If there's only one branch, set it as default and complete login
        await _setDefaultBranch(branches.first);
        _completeAuthenticationFlow();
      } else {
        // If multiple branches, show branch selection
        setState(() {
          _isSelectingBranch = true;
        });
      }
    } catch (e) {
      talker.error('Error handling business selection: $e');
      if (mounted) {
        ErrorHandler.showErrorSnackBar(context, e);
      }
    } finally {
      if (mounted) {
        setState(() {
          _loadingItemId = null;
        });
      }
    }
  }

  Future<void> _handleBranchSelection(
    Branch branch,
    BuildContext context,
  ) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final platform = Theme.of(context).platform;
    final isMobile =
        platform == TargetPlatform.android || platform == TargetPlatform.iOS;
    setState(() {
      _loadingItemId = branch.serverId?.toString();
      _isLoading = true;
    });

    await ProxyService.box.writeBool(
      key: 'branch_navigation_in_progress',
      value: true,
    );

    try {
      await _setDefaultBranch(branch);

      // Save device being logged in
      await _saveDeviceRecord();

      // Ensure counters are hydrated now that the branch context is known.
      await DittoSyncCoordinator.instance.hydrate<Counter>();

      // Observers are now registered in _setDefaultBranch
      // They will automatically pull data and listen for changes
      // No need for manual pull, diagnostics, or delays here!

      if (!isMobile) {
        // Choose default app if not set
        String? defaultApp = ProxyService.box.getDefaultApp();
        if (defaultApp == null) {
          final dialogService = locator<DialogService>();
          final response = await dialogService.showCustomDialog(
            variant: DialogType.appChoice,
            title: 'Choose Your Default App',
          );

          if (response?.confirmed == true && response?.data != null) {
            defaultApp = response!.data['defaultApp'];
          } else {
            // User cancelled app choice, maybe default to POS or stay here
            setState(() => _isLoading = false);
            return; // Stop if no app is chosen
          }
        }

        // Handle POS shift logic
        if (defaultApp == 'POS') {
          final userId = ProxyService.box.getUserId();
          if (userId != null) {
            final currentShift = await ProxyService.strategy.getCurrentShift(
              userId: userId,
            );
            if (currentShift == null) {
              final dialogService = locator<DialogService>();
              final response = await dialogService.showCustomDialog(
                variant: DialogType.startShift,
                title: 'Start New Shift',
              );
              if (response?.confirmed == true) {
                final openingBalance =
                    response?.data['openingBalance'] as double? ?? 0.0;
                final notes = response?.data['notes'] as String?;
                await ProxyService.strategy.startShift(
                  userId: userId,
                  openingBalance: openingBalance,
                  note: notes,
                );
                _completeAuthenticationFlow();
              } else {
                if (!mounted) return;
                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Shift not started. Please start a shift to proceed.',
                    ),
                    backgroundColor: Colors.orange,
                  ),
                );
                setState(() => _isLoading = false);
                return;
              }
            } else {
              _completeAuthenticationFlow();
            }
          } else {
            _completeAuthenticationFlow();
          }
        } else {
          // For other apps, complete flow directly
          _completeAuthenticationFlow();
        }
      } else {
        _completeAuthenticationFlow();
      }
    } catch (e) {
      talker.error('Error handling branch selection: $e');
      if (!mounted) return;
      ErrorHandler.showErrorSnackBar(context, e);
    } finally {
      if (mounted) {
        setState(() {
          _loadingItemId = null;
          // Do not set _isLoading to false here if a navigation is happening
        });
      }
    }
  }

  Future<void> _setDefaultBusiness(Business business) async {
    ref.read(businessSelectionProvider.notifier).setLoading(true);

    try {
      // First make all businesses inactive
      await _updateAllBusinessesInactive();
      // Then set the selected business as active and default
      await _updateBusinessActive(business);
      // Update preferences
      await _updateBusinessPreferences(business);
      // Refresh providers to reflect changes
      _refreshBusinessAndBranchProviders();
    } catch (e) {
      talker.error('Error setting default business: $e');
      if (mounted) {
        ErrorHandler.showErrorSnackBar(context, e);
        rethrow;
      }
    } finally {
      if (mounted) {
        ref.read(businessSelectionProvider.notifier).setLoading(false);
      }
    }
  }

  Future<void> _setDefaultBranch(Branch branch) async {
    ref.read(branchSelectionProvider.notifier).setLoading(true);

    try {
      // First make all branches inactive
      await _updateAllBranchesInactive();
      // Then set the selected branch as active and default
      await _updateBranchActive(branch);
      // Update branch ID in storage
      await ProxyService.box.writeInt(key: 'branchId', value: branch.serverId!);
      await ProxyService.box.writeString(
        key: 'branchIdString',
        value: branch.id,
      );
      // Set switched flag for other components to detect
      await ProxyService.box.writeBool(key: 'branch_switched', value: true);
      await ProxyService.box.writeInt(
        key: 'last_branch_switch_timestamp',
        value: DateTime.now().millisecondsSinceEpoch,
      );
      await ProxyService.box.writeInt(
        key: 'active_branch_id',
        value: branch.serverId!,
      );

      // Refresh providers to reflect changes
      _refreshBusinessAndBranchProviders();
    } catch (e) {
      talker.error('Error setting default branch: $e');
    } finally {
      ref.read(branchSelectionProvider.notifier).setLoading(false);
    }
  }

  Future<void> _updateAllBusinessesInactive() async {
    final businesses = await ProxyService.strategy.businesses(
      userId: ProxyService.box.getUserId()!,
    );
    for (final business in businesses) {
      await ProxyService.strategy.updateBusiness(
        businessId: business.serverId,
        active: false,
        isDefault: false,
      );
    }
  }

  Future<void> _updateBusinessActive(Business business) async {
    await ProxyService.strategy.updateBusiness(
      businessId: business.serverId,
      active: true,
      isDefault: true,
    );
  }

  Future<void> _updateBusinessPreferences(Business business) async {
    // Get existing tin value if available
    final existingTin = ProxyService.box.readInt(key: 'tin');

    // Collect all storage write futures
    final futures = <Future>[];

    futures.add(
      ProxyService.box.writeInt(key: 'businessId', value: business.serverId),
    );
    futures.add(
      ProxyService.box.writeString(
        key: 'bhfId',
        value: (await ProxyService.box.bhfId()) ?? "00",
      ),
    );

    // Resolve effective TIN (prefer Ebm for active branch) and update box if needed
    final resolvedTin = await effectiveTin(business: business);
    if (resolvedTin != null || existingTin == null) {
      futures.add(
        ProxyService.box.writeInt(
          key: 'tin',
          value: resolvedTin ?? existingTin ?? 0,
        ),
      );
      talker.debug(
        'Setting tin to ${resolvedTin ?? existingTin ?? 0} (from ${resolvedTin != null ? 'ebm/business' : 'existing value'})',
      );
    } else {
      talker.debug('Preserving existing tin value: $existingTin');
    }

    futures.add(
      ProxyService.box.writeString(
        key: 'encryptionKey',
        value: business.encryptionKey ?? "",
      ),
    );

    // Wait for all storage operations to complete
    await Future.wait(futures);
  }

  Future<void> _updateAllBranchesInactive() async {
    final businessId = ref.read(selectedBusinessIdProvider);
    if (businessId == null) return;
    final branches = await ProxyService.strategy.branches(
      businessId: businessId,
      active: true,
    );
    for (final branch in branches) {
      await ProxyService.strategy.updateBranch(
        branchId: branch.serverId!,
        active: false,
        isDefault: false,
      );
    }
  }

  Future<void> _updateBranchActive(Branch branch) async {
    await ProxyService.strategy.updateBranch(
      branchId: branch.serverId!,
      active: true,
      isDefault: true,
    );
  }

  void _completeAuthenticationFlow() {
    final selectedBusinessId = ref.read(selectedBusinessIdProvider);
    PosthogService.instance.capture(
      'login_success',
      properties: {
        'source': 'login_choices',
        if (selectedBusinessId != null) 'business_id': selectedBusinessId,
      },
    );

    _routerService.navigateTo(FlipperAppRoute());

    // Clear the navigation flag after a delay
    _navigationTimer?.cancel();
    _navigationTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        ProxyService.box.writeBool(
          key: 'branch_navigation_in_progress',
          value: false,
        );
      }
    });
  }

  void _refreshBusinessAndBranchProviders() {
    // Refresh providers to reflect changes
    ref.invalidate(businessesProvider);
    final businessId = ref.read(selectedBusinessIdProvider);
    if (businessId != null) {
      ref.invalidate(branchesProvider(businessId: businessId));
    }
  }

  bool get isMobileDevice {
    return Platform.isAndroid || Platform.isIOS;
  }

  Future<void> _saveDeviceRecord() async {
    try {
      final userId = ProxyService.box.getUserId();
      final businessId = ProxyService.box.getBusinessId();
      final branchId = ProxyService.box.getBranchId();
      final phone = ProxyService.box.getUserPhone();
      final defaultApp = ProxyService.box.getDefaultApp();

      if (userId == null || businessId == null || branchId == null) {
        talker.warning('Cannot save device: missing required user data');
        return;
      }

      // Get device info
      final deviceName = Platform.operatingSystem;
      final deviceVersion = await CoreMiscellaneous.getDeviceVersionStatic();

      // Check if device already exists
      if (!isMobileDevice) {
        await ProxyService.strategy.create(
          data: Device(
            pubNubPublished: false,
            branchId: branchId,
            businessId: businessId,
            defaultApp: defaultApp ?? 'POS',
            phone: phone ?? '',
            userId: userId,
            deviceName: deviceName,
            deviceVersion: deviceVersion,
          ),
        );
      }

      talker.debug('Device record created successfully');
    } catch (e) {
      talker.error('Error saving device record: $e');
      // Don't throw - device creation failure shouldn't block login
    }
  }
}
