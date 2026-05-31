import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flipper_models/providers/branch_business_provider.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_design_system/flipper_design_system.dart';
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
import 'dart:async';
import 'dart:io';
import 'package:flipper_services/Miscellaneous.dart';
import 'package:flipper_dashboard/BranchSelectionMixin.dart';
import 'package:flipper_dashboard/utils/error_handler.dart';
import 'package:flipper_models/helpers/agent_session_helper.dart';
import 'package:flipper_routing/app.dialogs.dart';
import 'package:supabase_models/sync/ditto_sync_coordinator.dart';
import 'package:flipper_services/app_service.dart';
import 'package:permission_handler/permission_handler.dart';

final selectedBusinessIdProvider = StateProvider<String?>((ref) => null);

/// Tokens from `design_handoff_onboarding_flow/onboarding/styles.css` (.sel-*).
abstract final class _SelTokens {
  static const Color app = Color(0xFFF5F8FD);
  static const Color app2 = Color(0xFFEDF2FB);
  static const Color ink1 = Color(0xFF0B1220);
  static const Color ink2 = Color(0xFF4A5567);
  static const Color ink3 = Color(0xFF7E8AA0);
  static const Color ink4 = Color(0xFFAEB8CA);
  static const Color line = Color(0xFFE6ECF5);
  static const Color lineStrong = Color(0xFFD6DEEA);
  static const Color blue = Color(0xFF2563EB);
  static const Color blueTint = Color(0xFFEAF1FE);
  static const Color violet = Color(0xFF7C3AED);
  static const Color violetTint = Color(0xFFF3EEFB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surface2 = Color(0xFFF7F9FE);
  static const Color signOut = Color(0xFFEF4444);
  static const double desktopContentWidth = 480;
  static const double cardGap = 10;
}

enum _ChoiceIconTone { blue, violet }

String _titleCaseRole(String role) {
  final trimmed = role.trim();
  if (trimmed.isEmpty) return 'Member';
  if (trimmed.length <= 3) return trimmed.toUpperCase();
  return '${trimmed[0].toUpperCase()}${trimmed.substring(1).toLowerCase()}';
}

String _businessRoleLabel(Business business) {
  final role = business.role?.trim();
  if (role != null && role.isNotEmpty) return _titleCaseRole(role);
  final userId = ProxyService.box.getUserId();
  if (userId != null && business.userId == userId) return 'Owner';
  return 'Member';
}

String _businessChoiceSubtitle(Business business) {
  final count = business.branches?.length ?? 0;
  final branchWord = count == 1 ? 'branch' : 'branches';
  return '${_businessRoleLabel(business)} · $count $branchWord';
}

_ChoiceIconTone _iconToneForIndex(int index) {
  return index.isEven ? _ChoiceIconTone.blue : _ChoiceIconTone.violet;
}

/// First letter for avatar chips; skips "+" and non-letters (e.g. E.164 phones).
String _userProfileInitial(String? label) {
  final stored = ProxyService.box.getUserName()?.trim();
  for (final source in [stored, label]) {
    if (source == null || source.isEmpty) continue;
    for (var i = 0; i < source.length; i++) {
      final c = source[i];
      if (RegExp(r'[A-Za-z]').hasMatch(c)) return c.toUpperCase();
    }
  }
  return 'U';
}

String _displayUserName(List<Business>? businesses) {
  final storedName = ProxyService.box.getUserName()?.trim();
  if (storedName != null && storedName.isNotEmpty) return storedName;
  for (final business in businesses ?? <Business>[]) {
    final fullName = business.fullName?.trim();
    if (fullName != null && fullName.isNotEmpty) return fullName;
    final first = business.firstName?.toString().trim();
    final last = business.lastName?.toString().trim();
    if (first != null && first.isNotEmpty) {
      return [first, if (last != null && last.isNotEmpty) last].join(' ');
    }
  }
  final phone = ProxyService.box.getUserPhone()?.trim();
  if (phone != null && phone.isNotEmpty) return phone;
  return 'User';
}

String _displayUserContact(List<Business>? businesses) {
  for (final business in businesses ?? <Business>[]) {
    final email = business.email?.toString().trim();
    if (email != null && email.isNotEmpty) return email;
  }
  final phone = ProxyService.box.getUserPhone()?.trim();
  if (phone != null && phone.isNotEmpty) return phone;
  return '';
}

class LoginChoices extends StatefulHookConsumerWidget {
  const LoginChoices({Key? key}) : super(key: key);

  @override
  _LoginChoicesState createState() => _LoginChoicesState();
}

class _LoginChoicesState extends ConsumerState<LoginChoices>
    with BranchSelectionMixin {
  bool _isSelectingBranch = false;
  bool _isLoading = false;
  bool _isSigningOut = false;
  String? _loadingItemId;
  String? _selectedBranchId;
  Timer? _navigationTimer;

  final _routerService = locator<RouterService>();

  @override
  void initState() {
    super.initState();
    // Validate that userId is set before allowing access to this page
    _validateUserId();
    // Request Ditto sync permissions on Android
    _requestDittoPermissions();
    // Invalidate providers to ensure fresh data is loaded for the current user
    // This is especially important when logging in with a different user
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.invalidate(businessesProvider);
        // Reset selected business to ensure no stale selection from previous user
        ref.read(selectedBusinessIdProvider.notifier).state = null;
      }
    });
    unawaited(_hydrateStoredUserName());
  }

  /// Backfill `userName` from Ditto when prefs only have phone (older sessions).
  Future<void> _hydrateStoredUserName() async {
    final existing = ProxyService.box.getUserName()?.trim();
    if (existing != null && existing.isNotEmpty) return;

    final userId = ProxyService.box.getUserId()?.trim();
    if (userId == null || userId.isEmpty) return;

    try {
      final access = await ProxyService.ditto.getUserAccess(userId);
      final name = access?['name']?.toString().trim();
      if (name == null || name.isEmpty) return;
      await ProxyService.box.writeString(key: 'userName', value: name);
      if (mounted) setState(() {});
    } catch (e) {
      talker.debug('Could not hydrate userName from Ditto: $e');
    }
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

        // If the provider has resolved (not loading, no error) but returned zero
        // businesses, this userId has no associated business — log out immediately.
        if (businesses.hasValue &&
            !businesses.isLoading &&
            (businesses.value?.isEmpty ?? false)) {
          // One-shot guard: bail out if logout is already scheduled.
          if (_isSigningOut) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      'No businesses found. Signing out...',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            );
          }

          talker.warning(
            'LoginChoices: no businesses found for current user. Logging out.',
          );
          _isSigningOut = true;
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (mounted) {
              await ProxyService.strategy.logOut();
              _routerService.clearStackAndShow(LoginRoute());
            }
          });
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'No businesses found. Signing out...',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          );
        }

        final size = MediaQuery.sizeOf(context);
        final isDesktopLayout = size.width >= 900;
        final layout = _LoginChoicesLayout(
          isDesktop: isDesktopLayout,
          maxWidth: isDesktopLayout ? _SelTokens.desktopContentWidth : 430.0,
          horizontalPadding: isDesktopLayout ? 0 : 22,
          topPadding: isDesktopLayout ? 0 : 24,
          bottomPadding: isDesktopLayout ? 0 : 28,
          titleGap: isDesktopLayout ? 28 : 42,
          listGap: isDesktopLayout ? 24 : 36,
        );
        final content = !_isLoading
            ? _isSelectingBranch
                  ? _buildBranchSelectionScreen(
                      branches: branches.value ?? [],
                      layout: layout,
                    )
                  : _buildBusinessSelectionScreen(
                      businesses: businesses.value,
                      layout: layout,
                    )
            : Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    strokeWidth: 3,
                    backgroundColor: Colors.grey.shade300,
                  ),
                ),
              );

        return Stack(
          fit: StackFit.expand,
          children: [
            Scaffold(
              backgroundColor: _SelTokens.app,
              body: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(0, -0.85),
                    radius: 1.35,
                    colors: [
                      _SelTokens.surface,
                      _SelTokens.app,
                      _SelTokens.app2,
                    ],
                    stops: [0, 0.46, 1],
                  ),
                ),
                child: SafeArea(
                  child: isDesktopLayout
                      ? _DesktopLoginChoicesScaffold(
                          layout: layout,
                          userInitial: _initialFor(
                            _displayUserName(businesses.value),
                          ),
                          userName: _displayUserName(businesses.value),
                          userContact: _displayUserContact(businesses.value),
                          isSigningOut: _isSigningOut,
                          onSignOut: _handleSignOut,
                          child: content,
                        )
                      : Align(
                          alignment: Alignment.topCenter,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: layout.maxWidth),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                layout.horizontalPadding,
                                layout.topPadding,
                                layout.horizontalPadding,
                                layout.bottomPadding,
                              ),
                              child: content,
                            ),
                          ),
                        ),
                ),
              ),
            ),
            if (_isSigningOut) const _SigningOutOverlay(),
          ],
        );
      },
    );
  }

  Widget _buildBusinessSelectionScreen({
    List<Business>? businesses,
    required _LoginChoicesLayout layout,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!layout.isDesktop) ...[
          Row(
            children: [
              const _ChoicesBrand(),
              const Spacer(),
              _UserPill(initial: _currentUserInitial),
            ],
          ),
          SizedBox(height: layout.titleGap),
        ],
        Text(
          'Choose a business',
          style: TextStyle(
            color: _SelTokens.ink1,
            fontWeight: FontWeight.w700,
            height: 1.05,
            fontSize: layout.isDesktop ? 27 : 27,
            letterSpacing: layout.isDesktop ? -0.68 : -0.5,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          layout.isDesktop
              ? 'Select the business you want to manage.'
              : 'Select the business you want to manage',
          style: const TextStyle(
            color: _SelTokens.ink2,
            height: 1.35,
            fontWeight: FontWeight.w400,
            fontSize: 15,
          ),
        ),
        SizedBox(height: layout.listGap),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              if (businesses != null)
                for (var i = 0; i < businesses.length; i++) ...[
                  _BusinessChoiceTile(
                    name: businesses[i].name ?? 'Business',
                    subtitle: _businessChoiceSubtitle(businesses[i]),
                    iconTone: _iconToneForIndex(i),
                    isLoading: _loadingItemId == businesses[i].id.toString(),
                    onTap: () => _handleBusinessSelection(businesses[i]),
                  ),
                  if (i < businesses.length - 1)
                    const SizedBox(height: _SelTokens.cardGap),
                ],
              if (businesses != null && businesses.isNotEmpty)
                const SizedBox(height: _SelTokens.cardGap),
              _AddBusinessTile(onTap: () {}),
              if (layout.isDesktop) ...[
                const SizedBox(height: 22),
                _DesktopBusinessHelpText(onAddBusiness: () {}),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBranchSelectionScreen({
    required List<Branch> branches,
    required _LoginChoicesLayout layout,
  }) {
    final selectedBranchId =
        _selectedBranchId ?? (branches.isEmpty ? null : branches.first.id);
    final selectedBusinessId = ref.watch(selectedBusinessIdProvider);
    Business? selectedBusiness;
    for (final business
        in ref.watch(businessesProvider).value ?? <Business>[]) {
      if (business.id == selectedBusinessId) {
        selectedBusiness = business;
        break;
      }
    }
    Branch? selectedBranch;
    for (final branch in branches) {
      if (branch.id == selectedBranchId) {
        selectedBranch = branch;
        break;
      }
    }
    final branchToContinue = selectedBranch;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _RoundBackButton(
              onPressed: () {
                setState(() {
                  _isSelectingBranch = false;
                  _loadingItemId = null;
                  _selectedBranchId = null;
                });
              },
            ),
            const Spacer(),
            _BusinessPill(name: selectedBusiness?.name ?? 'Demo Shop'),
            const Spacer(),
            const SizedBox(width: 54),
          ],
        ),
        SizedBox(height: layout.titleGap),
        Text(
          'Choose a branch',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: const Color(0xFF0B1220),
            fontWeight: FontWeight.w900,
            height: 1.05,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Select the branch you want to access',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: const Color(0xFF4A5567),
            height: 1.35,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: layout.listGap),
        Expanded(
          child: ListView.separated(
            itemCount: branches.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final branch = branches[index];
              final isSelected =
                  selectedBranchId == branch.id ||
                  (selectedBranchId == null && index == 0);
              return _BranchChoiceTile(
                name: branch.name ?? 'Branch',
                subtitle: branch.location ?? '',
                isDefault: index == 0,
                isSelected: isSelected,
                isLoading: _loadingItemId == branch.id.toString(),
                onTap: () {
                  setState(() {
                    _selectedBranchId = branch.id;
                  });
                },
              );
            },
          ),
        ),
        FlipperGradientButton(
          text: 'Continue to ${selectedBranch?.name ?? 'branch'}',
          icon: Icons.arrow_outward_rounded,
          isLoading: _isLoading,
          onPressed: branchToContinue == null
              ? null
              : () => _handleBranchSelection(branchToContinue, context),
        ),
      ],
    );
  }

  Future<void> _handleBusinessSelection(Business business) async {
    // Do not clear branchId here: it widens a race with Ditto-backed prefs merge
    // (attachDittoPersistence) and leaves getBranchId() null while business loads.
    // setDefaultBranch / setDefaultBusiness overwrites when the user picks a branch.
    setState(() {
      _loadingItemId = business.id.toString();
      _selectedBranchId = null;
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
      // Save business ID to local storage (Hive - fast)
      await ProxyService.box.writeString(key: 'businessId', value: business.id);

      // Set default business (Hive write + deferred SQLite)
      await locator<AppService>().setDefaultBusiness(business);

      // Small delay to prevent SQLite lock from previous operation
      await Future.delayed(const Duration(milliseconds: 100));

      // Get the latest payment plan online (non-blocking, doesn't block UI)
      unawaited(
        ProxyService.strategy.getPaymentPlan(
          businessId: business.id,
          fetchOnline: true,
        ),
      );

      final userId = ProxyService.box.getUserId();
      final List<Map<String, dynamic>> branchesJson = await ProxyService.ditto
          .getBranches(userId!, business.id);

      final branches = branchesJson.map((j) => Branch.fromMap(j)).toList();

      if (branches.length == 1) {
        // If there's only one branch, set it as default and complete login
        await locator<AppService>().setDefaultBranch(branches.first);
        // Small delay to allow Hive writes to complete
        await Future.delayed(const Duration(milliseconds: 100));
        await _completeAuthenticationFlow();
        _invalidateProviders();
      } else {
        // Multiple branches: stay on this screen until the user picks one.
        // _completeAuthenticationFlow runs from _handleBranchSelection only.
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
      final userId = ProxyService.box.getUserId();

      // Step 1: Set default branch (Hive writes are synchronous, SQLite is deferred)
      await locator<AppService>().setDefaultBranch(branch);

      // Small delay to allow Hive writes to complete
      await Future.delayed(const Duration(milliseconds: 100));

      ref.invalidate(activeBranchProvider);

      // Step 2: Save device record (deferred to avoid blocking)
      unawaited(_saveDeviceRecord());

      // Small delay to prevent SQLite lock
      await Future.delayed(const Duration(milliseconds: 100));

      // Step 3: Hydrate counters after branch context is set
      await DittoSyncCoordinator.instance.hydrate<Counter>();

      // Small delay to allow DB to settle
      await Future.delayed(const Duration(milliseconds: 100));

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
        // Step 4: Check and start shift (deferred to avoid blocking)
        unawaited(ProxyService.app.checkAndStartShift(userId: userId));
      }

      // Final delay before navigation
      await Future.delayed(const Duration(milliseconds: 100));

      await _completeAuthenticationFlow();
    } catch (e) {
      talker.error('Error handling branch selection: $e');
      if (!mounted) return;
      // Reset loading state so user can try again
      setState(() {
        _isLoading = false;
      });
      ErrorHandler.showErrorSnackBar(context, e);
    } finally {
      if (mounted) {
        setState(() {
          _loadingItemId = null;
        });
      }
    }
  }

  // Consolidating logic into AppService

  Future<void> _completeAuthenticationFlow() async {
    final selectedBusinessId = ref.read(selectedBusinessIdProvider);
    final commissionOnly = await refreshCommissionOnlySession(
      businessId: selectedBusinessId,
    );

    PosthogService.instance.capture(
      'login_success',
      properties: {
        'source': 'login_choices',
        if (selectedBusinessId != null) 'business_id': selectedBusinessId,
        'commission_only': commissionOnly,
      },
    );

    if (commissionOnly) {
      _routerService.navigateTo(const AgentCommissionRoute());
    } else {
      _routerService.navigateTo(FlipperAppRoute());
    }

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
    ref.invalidate(activeBranchProvider);
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

  String get _currentUserInitial =>
      _userProfileInitial(ProxyService.box.getUserPhone());

  String _initialFor(String name) => _userProfileInitial(name);

  Future<void> _handleSignOut() async {
    if (_isSigningOut) return;
    setState(() {
      _isSigningOut = true;
      _loadingItemId = null;
    });
    try {
      await ProxyService.strategy.logOut();
      if (!mounted) return;
      _routerService.clearStackAndShow(LoginRoute());
    } catch (e) {
      talker.error('Sign out failed: $e');
      if (!mounted) return;
      setState(() => _isSigningOut = false);
      ErrorHandler.showErrorSnackBar(context, e);
    }
  }
}

class _LoginChoicesLayout {
  final bool isDesktop;
  final double maxWidth;
  final double horizontalPadding;
  final double topPadding;
  final double bottomPadding;
  final double titleGap;
  final double listGap;

  const _LoginChoicesLayout({
    required this.isDesktop,
    required this.maxWidth,
    required this.horizontalPadding,
    required this.topPadding,
    required this.bottomPadding,
    required this.titleGap,
    required this.listGap,
  });
}

class _SigningOutOverlay extends StatelessWidget {
  const _SigningOutOverlay();

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      child: ColoredBox(
        color: _SelTokens.app.withValues(alpha: 0.88),
        child: Center(
          child: Container(
            width: 280,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
            decoration: BoxDecoration(
              color: _SelTokens.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _SelTokens.line),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF102040).withValues(alpha: .14),
                  blurRadius: 32,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: _SelTokens.blue,
                  ),
                ),
                SizedBox(height: 18),
                Text(
                  'Signing out…',
                  style: TextStyle(
                    color: _SelTokens.ink1,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Please wait a moment',
                  style: TextStyle(
                    color: _SelTokens.ink3,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DesktopLoginChoicesScaffold extends StatefulWidget {
  final _LoginChoicesLayout layout;
  final String userInitial;
  final String userName;
  final String userContact;
  final bool isSigningOut;
  final Future<void> Function() onSignOut;
  final Widget child;

  const _DesktopLoginChoicesScaffold({
    required this.layout,
    required this.userInitial,
    required this.userName,
    required this.userContact,
    required this.isSigningOut,
    required this.onSignOut,
    required this.child,
  });

  @override
  State<_DesktopLoginChoicesScaffold> createState() =>
      _DesktopLoginChoicesScaffoldState();
}

class _DesktopLoginChoicesScaffoldState
    extends State<_DesktopLoginChoicesScaffold> {
  bool _isMenuOpen = false;

  void _toggleMenu() {
    if (widget.isSigningOut) return;
    setState(() => _isMenuOpen = !_isMenuOpen);
  }

  void _closeMenu() {
    if (widget.isSigningOut) return;
    if (_isMenuOpen) setState(() => _isMenuOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    final pillName = widget.userName.trim().split(RegExp(r'\s+')).first;

    // Dropdown must be a top-layer overlay. When it was nested in the header
    // Stack, the Expanded scroll body still won hit tests for the painted
    // overflow region, so Sign out never fired.
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(48, 20, 48, 0),
              child: Row(
                children: [
                  const _ChoicesBrand(),
                  const Spacer(),
                  _DesktopUserPill(
                    initial: widget.userInitial,
                    name: pillName,
                    contact: widget.userContact,
                    isOpen: _isMenuOpen,
                    onTap: widget.isSigningOut ? null : _toggleMenu,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: widget.layout.maxWidth,
                      maxHeight: 560,
                    ),
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (_isMenuOpen) ...[
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _closeMenu,
            ),
          ),
          Positioned(
            top: 68,
            right: 48,
            child: Material(
              color: Colors.transparent,
              child: _DesktopAccountMenu(
                initial: widget.userInitial,
                name: widget.userName,
                contact: widget.userContact,
                isSigningOut: widget.isSigningOut,
                onSignOut: widget.onSignOut,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _ChoicesBrand extends StatelessWidget {
  final double logoSize;

  const _ChoicesBrand({this.logoSize = 30});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: logoSize,
          height: logoSize,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFF006AFE), Color(0xFF14B8A6)],
            ),
          ),
          alignment: Alignment.center,
          child: Container(
            width: logoSize * 0.82,
            height: logoSize * 0.82,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            padding: EdgeInsets.all(logoSize * 0.1),
            child: ClipOval(
              child: Image.asset(
                'assets/logo.png',
                package: 'flipper_dashboard',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'Flipper',
          style: TextStyle(
            color: _SelTokens.ink1,
            fontWeight: FontWeight.w700,
            fontSize: 18,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}

class _DesktopUserPill extends StatelessWidget {
  final String initial;
  final String name;
  final String contact;
  final bool isOpen;
  final VoidCallback? onTap;

  const _DesktopUserPill({
    required this.initial,
    required this.name,
    required this.contact,
    required this.isOpen,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 320),
          padding: const EdgeInsets.fromLTRB(4, 4, 12, 4),
          decoration: BoxDecoration(
            color: _SelTokens.surface,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: _SelTokens.line),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D102040),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
              BoxShadow(
                color: Color(0x0A102040),
                blurRadius: 1,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _DesktopAvatar(initial: initial, radius: 16),
              const SizedBox(width: 10),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _SelTokens.ink1,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                      ),
                    ),
                    if (contact.isNotEmpty) ...[
                      const SizedBox(height: 1),
                      Text(
                        contact,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _SelTokens.ink3,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                isOpen
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: _SelTokens.ink3,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DesktopAccountMenu extends StatelessWidget {
  final String initial;
  final String name;
  final String contact;
  final bool isSigningOut;
  final Future<void> Function() onSignOut;

  const _DesktopAccountMenu({
    required this.initial,
    required this.name,
    required this.contact,
    required this.isSigningOut,
    required this.onSignOut,
  });

  void _signOut() {
    if (isSigningOut) return;
    unawaited(onSignOut());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 12),
      decoration: BoxDecoration(
        color: _SelTokens.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _SelTokens.line),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF102040).withValues(alpha: .14),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _DesktopAvatar(initial: initial, radius: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _SelTokens.ink1,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                      ),
                    ),
                    if (contact.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        contact,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _SelTokens.ink3,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: _SelTokens.line),
          const _DesktopAccountMenuRow(
            icon: Icons.person_outline_rounded,
            label: 'Account settings',
          ),
          const _DesktopAccountMenuRow(
            icon: Icons.group_outlined,
            label: 'Switch account',
          ),
          const Divider(height: 1, color: _SelTokens.line),
          _DesktopAccountMenuRow(
            icon: Icons.logout_rounded,
            label: isSigningOut ? 'Signing out…' : 'Sign out',
            color: _SelTokens.signOut,
            isLoading: isSigningOut,
            onTap: isSigningOut ? null : _signOut,
          ),
        ],
      ),
    );
  }
}

class _DesktopAccountMenuRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isLoading;
  final VoidCallback? onTap;

  const _DesktopAccountMenuRow({
    required this.icon,
    required this.label,
    this.color = const Color(0xFF0B1220),
    this.isLoading = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              if (isLoading)
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: color.withValues(alpha: .78),
                  ),
                )
              else
                Icon(icon, color: color.withValues(alpha: .78), size: 20),
              const SizedBox(width: 14),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DesktopAvatar extends StatelessWidget {
  final String initial;
  final double radius;

  const _DesktopAvatar({required this.initial, required this.radius});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: _SelTokens.blue,
      child: Text(
        initial.isEmpty ? 'U' : initial[0].toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontSize: radius * .9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _UserPill extends StatelessWidget {
  final String initial;

  const _UserPill({required this.initial});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 14, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE6ECF5)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF102040).withValues(alpha: .10),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFF4F46E5),
            child: Text(
              initial,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF7E8AA0),
          ),
        ],
      ),
    );
  }
}

class _BusinessChoiceTile extends StatelessWidget {
  final String name;
  final String subtitle;
  final _ChoiceIconTone iconTone;
  final bool isLoading;
  final VoidCallback onTap;

  const _BusinessChoiceTile({
    required this.name,
    required this.subtitle,
    required this.iconTone,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _ChoiceCard(
      onTap: onTap,
      selected: false,
      child: Row(
        children: [
          _ChoiceIcon(icon: Icons.storefront_outlined, tone: iconTone),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: _SelTokens.ink1,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: _SelTokens.ink3,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            const Icon(
              Icons.chevron_right_rounded,
              color: _SelTokens.ink4,
              size: 20,
            ),
        ],
      ),
    );
  }
}

class _AddBusinessTile extends StatefulWidget {
  final VoidCallback onTap;

  const _AddBusinessTile({required this.onTap});

  @override
  State<_AddBusinessTile> createState() => _AddBusinessTileState();
}

class _AddBusinessTileState extends State<_AddBusinessTile> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isActive = _isHovered || _isPressed;
    final foreground = isActive ? _SelTokens.blue : _SelTokens.ink2;
    final borderColor = isActive ? _SelTokens.blue : _SelTokens.lineStrong;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() {
        _isHovered = false;
        _isPressed = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapCancel: () => setState(() => _isPressed = false),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isPressed ? .99 : 1,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              color: isActive ? _SelTokens.blueTint : _SelTokens.surface2,
              borderRadius: BorderRadius.circular(14),
            ),
            child: CustomPaint(
              painter: _DashedBorderPainter(
                color: borderColor,
                borderRadius: 14,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_rounded, color: foreground, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Add a business',
                      style: TextStyle(
                        color: foreground,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double borderRadius;

  const _DashedBorderPainter({required this.color, required this.borderRadius});

  @override
  void paint(Canvas canvas, Size size) {
    const dash = 6.0;
    const gap = 4.0;
    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(borderRadius),
    ).deflate(.75);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final path = Path()..addRRect(rect);

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = (distance + dash).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.borderRadius != borderRadius;
  }
}

class _DesktopBusinessHelpText extends StatelessWidget {
  final VoidCallback onAddBusiness;

  const _DesktopBusinessHelpText({required this.onAddBusiness});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(
            color: _SelTokens.ink3,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
          children: [
            const TextSpan(
              text:
                  'Not seeing your business? Ask the owner to invite you, or ',
            ),
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: GestureDetector(
                onTap: onAddBusiness,
                child: const Text(
                  'add a business.',
                  style: TextStyle(
                    color: _SelTokens.blue,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                    decorationColor: _SelTokens.blue,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BusinessPill extends StatelessWidget {
  final String name;

  const _BusinessPill({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE6ECF5)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF102040).withValues(alpha: .08),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.storefront_outlined,
            color: Color(0xFF4F46E5),
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            name,
            style: const TextStyle(
              color: Color(0xFF0B1220),
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _BranchChoiceTile extends StatelessWidget {
  final String name;
  final String subtitle;
  final bool isDefault;
  final bool isSelected;
  final bool isLoading;
  final VoidCallback onTap;

  const _BranchChoiceTile({
    required this.name,
    required this.subtitle,
    required this.isDefault,
    required this.isSelected,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _ChoiceCard(
      onTap: onTap,
      selected: isSelected,
      child: Row(
        children: [
          _ChoiceIcon(icon: Icons.location_on_outlined, selected: isSelected),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Color(0xFF0B1220),
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    if (isDefault)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE7E5FF),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          'DEFAULT',
                          style: TextStyle(
                            color: Color(0xFF4F46E5),
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF7E8AA0),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else if (isSelected)
            const CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xFF4F46E5),
              child: Icon(Icons.check_rounded, color: Colors.white),
            )
          else
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFD6DEEA), width: 2),
              ),
            ),
        ],
      ),
    );
  }
}

class _ChoiceCard extends StatefulWidget {
  final Widget child;
  final bool selected;
  final VoidCallback onTap;

  const _ChoiceCard({
    required this.child,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_ChoiceCard> createState() => _ChoiceCardState();
}

class _ChoiceCardState extends State<_ChoiceCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final selected = widget.selected;
    final hovered = _isHovered && !selected;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: 1,
          duration: const Duration(milliseconds: 120),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            decoration: BoxDecoration(
              color: selected ? _SelTokens.blueTint : _SelTokens.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected
                    ? _SelTokens.blue
                    : hovered
                    ? _SelTokens.lineStrong
                    : _SelTokens.line,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(
                    0xFF102040,
                  ).withValues(alpha: hovered || selected ? .14 : .05),
                  blurRadius: hovered || selected ? 18 : 2,
                  offset: Offset(0, hovered || selected ? 6 : 1),
                ),
                if (!hovered && !selected)
                  const BoxShadow(
                    color: Color(0x0A102040),
                    blurRadius: 1,
                    offset: Offset(0, 1),
                  ),
              ],
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class _ChoiceIcon extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final _ChoiceIconTone? tone;

  const _ChoiceIcon({required this.icon, this.selected = false, this.tone});

  @override
  Widget build(BuildContext context) {
    Color background;
    Color foreground;
    if (selected) {
      background = _SelTokens.blue;
      foreground = Colors.white;
    } else if (tone == _ChoiceIconTone.violet) {
      background = _SelTokens.violetTint;
      foreground = _SelTokens.violet;
    } else if (tone == _ChoiceIconTone.blue) {
      background = _SelTokens.blueTint;
      foreground = _SelTokens.blue;
    } else {
      background = _SelTokens.surface2;
      foreground = _SelTokens.ink3;
    }

    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(13),
        border: selected
            ? null
            : tone == null
            ? Border.all(color: _SelTokens.line)
            : null,
      ),
      child: Icon(icon, color: foreground, size: 22),
    );
  }
}

class _RoundBackButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _RoundBackButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onPressed,
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE6ECF5)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF102040).withValues(alpha: .08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(
          Icons.chevron_left_rounded,
          color: Color(0xFF4A5567),
          size: 28,
        ),
      ),
    );
  }
}
