import 'package:flipper_models/providers/branch_business_provider.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
// Import for payment plan route is already available from app.router.dart
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/posthog_service.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_personal/flipper_personal.dart';
// removed unused import
import 'dart:async';
import 'dart:io';
import 'package:flipper_services/Miscellaneous.dart';
import 'package:flipper_dashboard/BranchSelectionMixin.dart';
import 'package:flipper_dashboard/utils/error_handler.dart';
import 'package:flipper_routing/app.dialogs.dart';
import 'package:supabase_models/sync/ditto_sync_coordinator.dart';
import 'package:flipper_services/app_service.dart';
import 'package:permission_handler/permission_handler.dart';

final selectedBusinessIdProvider = StateProvider<String?>((ref) => null);

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
    // Request Ditto sync permissions on Android
    _requestDittoPermissions();
  }

  /// Requests all permissions required for Ditto sync on Android
  /// This ensures permissions are granted upfront before Ditto sync is attempted
  Future<void> _requestDittoPermissions() async {
    // Only request on Android
    if (!Platform.isAndroid) return;

    try {
      // Request all permissions required for Ditto peer-to-peer sync
      final permissions = [
        Permission.bluetoothConnect,
        Permission.bluetoothAdvertise,
        Permission.nearbyWifiDevices,
        Permission.bluetoothScan,
      ];

      final statuses = await permissions.request();

      // Check results and log any denied permissions
      final deniedPermissions = <String>[];
      for (final entry in statuses.entries) {
        if (entry.value != PermissionStatus.granted) {
          deniedPermissions.add(entry.key.toString());
        }
      }

      if (deniedPermissions.isEmpty) {
        talker.info('✅ All Ditto sync permissions granted on Android');
      } else {
        talker.warning(
          '⚠️ Some Ditto sync permissions denied: ${deniedPermissions.join(", ")}',
        );
        talker.warning(
          'Ditto peer-to-peer sync may not work properly without these permissions.',
        );
      }
    } catch (e) {
      talker.error('Error requesting Ditto permissions: $e');
      // Don't block login flow if permission request fails
    }
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
    if (userId == null) {
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
    String? selectedBusinessId,
  }) {
    if (businesses == null) return const SizedBox();
    return ListView.separated(
      itemCount: businesses.length,
      separatorBuilder: (_, __) => const SizedBox(height: 24.0),
      itemBuilder: (context, index) {
        final business = businesses[index];
        return _buildSelectionTile(
          title: business.name!,
          isSelected: business.id == selectedBusinessId,
          onTap: () => _handleBusinessSelection(business),
          icon: Icons.business,
          isLoading: _loadingItemId == (business.id.toString()),
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
    return buildBranchSelectionTile(
      title: title,
      isSelected: isSelected,
      onTap: onTap,
      icon: icon,
      loadingItemId: isLoading ? 'loading' : null,
    );
  }

  Future<void> _handleBusinessSelection(Business business) async {
    // remove any branchId selected before
    await ProxyService.box.remove(key: 'branchId');
    setState(() {
      _loadingItemId = business.id.toString();
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

    ref.read(selectedBusinessIdProvider.notifier).state = business.id;
    try {
      // Save business ID to local storage
      await ProxyService.box.writeString(key: 'businessId', value: business.id);
      await locator<AppService>().setDefaultBusiness(business);
      // Get the latest payment plan online.
      await ProxyService.strategy.getPaymentPlan(
        businessId: business.id,
        fetchOnline: true,
      );
      final userId = ProxyService.box.getUserId();
      final List<Map<String, dynamic>> branchesJson = await ProxyService.ditto
          .getBranches(userId!, business.id);

      final branches = branchesJson.map((j) => Branch.fromMap(j)).toList();

      if (branches.length == 1) {
        // If there's only one branch, set it as default and complete login
        await locator<AppService>().setDefaultBranch(branches.first);
        _invalidateProviders();
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
    final isMobile =
        Theme.of(context).platform == TargetPlatform.android ||
        Theme.of(context).platform == TargetPlatform.iOS;
    setState(() {
      _loadingItemId = branch.id.toString();
      _isLoading = true;
    });

    await ProxyService.box.writeBool(
      key: 'branch_navigation_in_progress',
      value: true,
    );

    try {
      // Initialization is now handled centrally in AppService.appInit
      // which is called when navigating to the main app or starting up.
      // Removed manual setUserId/logout here.
      final userId = ProxyService.box.getUserId();

      await locator<AppService>().setDefaultBranch(branch);

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
      }

      if (userId != null) {
        await ProxyService.app.checkAndStartShift(userId: userId);
      }
      _completeAuthenticationFlow();
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

  // Consolidating logic into AppService

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

  void _invalidateProviders() {
    // Refresh providers to reflect changes
    ref.invalidate(businessesProvider);
    final businessId = ref.read(selectedBusinessIdProvider);
    if (businessId != null) {
      ref.invalidate(branchesProvider(businessId: businessId));
    }
  }

  // Consolidating logic into AppService

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
