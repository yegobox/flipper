import 'package:flipper_models/providers/ebm_provider.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_models/db_model_export.dart';

import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'dart:async';
import 'package:flipper_web/core/utils/ditto_singleton.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.dialogs.dart';
// import 'package:flipper_nfc/flipper_nfc.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_dashboard/mfa_setup_view.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flipper_models/providers/device_provider.dart';
import 'package:supabase_models/sync/ditto_sync_coordinator.dart';
import 'package:supabase_models/brick/repository/local_storage.dart';
import 'package:flipper_dashboard/BranchSelectionMixin.dart';
import 'package:flipper_auth/auth_scanner_actions.dart';
import 'package:flipper_scanner/scanner_view.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_dashboard/widgets/dashboard_quick_access_svgs.dart';

class MyDrawer extends ConsumerStatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  ConsumerState<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends ConsumerState<MyDrawer> with BranchSelectionMixin {
  String? _switchingBranchId;
  bool userLoggingEnabled = false;
  bool backgroundSyncEnabled = false;
  @override
  void initState() {
    super.initState();
    userLoggingEnabled = ProxyService.box.getUserLoggingEnabled() ?? false;
    backgroundSyncEnabled =
        ProxyService.box.readBool(key: 'background_sync_enabled') ?? false;

    // Initialize Ditto if background sync is enabled
    if (backgroundSyncEnabled) {
      _initializeDittoIfEnabled();
    }
  }

  /// Initialize Ditto if background sync is enabled
  Future<void> _initializeDittoIfEnabled() async {
    final appID = kDebugMode ? AppSecrets.appIdDebug : AppSecrets.appId;

    final userId = ProxyService.box.getUserId();
    if (userId != null && appID.isNotEmpty) {
      await DittoSingleton.instance.initialize(appId: appID, userId: userId);
      DittoSyncCoordinator.instance.setDitto(
        DittoSingleton.instance.ditto,
        skipInitialFetch:
            true, // Skip initial fetch to prevent upserting all models on startup
      );
      final prefsBox = ProxyService.box;
      if (prefsBox is SharedPreferenceStorage) {
        await prefsBox.attachDittoPersistence();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF5F6F8),
      child: Column(
        children: [
          _buildModernHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom:
                    MediaQuery.of(context).padding.bottom +
                    80, // Account for bottom section
              ),
              child: Column(
                children: [
                  _buildQuickActions(context),
                  const SizedBox(height: 18),
                  _buildBusinessSection(context),
                  const SizedBox(height: 18),
                  _buildNavigationSection(context),
                ],
              ),
            ),
          ),
          _buildBottomSection(context),
        ],
      ),
    );
  }

  Widget _buildModernHeader(BuildContext context) {
    return FutureBuilder<Tenant?>(
      future: _getTenantFuture(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 110,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF3B82F6), Color(0xFF2563EB)], 
              ),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
          );
        }

        final tenant = snapshot.data;
        final topInset = MediaQuery.of(context).padding.top;
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, topInset + 10, 16, 10),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: DashboardQuickAccessSvgs.icon(
                      DashboardQuickAccessSvgs.drawerHeaderGridIconWhite(),
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            tenant?.name ?? "My Business",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              height: 1.05,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 14,
                                color: Colors.white.withValues(alpha: 0.85),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Admin · ${tenant?.name ?? "Demo Shop"}',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  height: 1.05,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(999),
                      child: Center(
                        child: DashboardQuickAccessSvgs.icon(
                          DashboardQuickAccessSvgs.drawerCloseXIcon(),
                          width: 14,
                          height: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'QUICK ACTIONS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: const Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _QuickActionCard(
                  title: 'Scan QR',
                  iconSvg: DashboardQuickAccessSvgs.drawerScanQrIcon(),
                  titleColor: const Color(0xFF2563EB),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScannView(
                          intent: LOGIN,
                          scannerActions: AuthScannerActions(context, ref),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickActionCard(
                  title: 'Dashboard',
                  iconSvg: DashboardQuickAccessSvgs.drawerDashboardIconGreen(),
                  titleColor: const Color(0xFF16A34A),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessSection(BuildContext context) {
    final userId = ProxyService.box.getUserId();
    if (userId == null) {
      return _buildEmptyState(
        icon: Icons.error_outline_rounded,
        title: 'No User',
        subtitle: 'Please log in to continue',
      );
    }

    return FutureBuilder<List<Business>>(
      future: () async {
        final userAccess = await ProxyService.ditto.getUserAccess(userId);
        if (userAccess != null && userAccess.containsKey('businesses')) {
          final List<dynamic> businessesJson = userAccess['businesses'];
          return businessesJson
              .map((json) => Business.fromMap(Map<String, dynamic>.from(json)))
              .toList();
        }
        return <Business>[];
      }(),
      builder: (context, businessSnapshot) {
        if (businessSnapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState('Loading businesses...');
        }

        if (businessSnapshot.hasError) {
          return _buildErrorState(
            'Error loading businesses',
            businessSnapshot.error.toString(),
            () => (context as Element).markNeedsBuild(),
          );
        }

        final List<Business> businesses = businessSnapshot.data ?? [];
        if (businesses.isEmpty) {
          return _buildEmptyState(
            icon: Icons.business_outlined,
            title: 'No Businesses',
            subtitle: 'Create your first business to get started',
          );
        }

        return _buildBusinessList(context, businesses);
      },
    );
  }

  Widget _buildBusinessList(BuildContext context, List<Business> businesses) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'YOUR BUSINESSES',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: const Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 12),
          ...businesses.map(
            (business) => _ModernBusinessCard(
              business: business,
              switchingBranchId: _switchingBranchId,
              onBranchSelected: (branch) {
                _handleBranchSelection(context, business, branch);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MANAGEMENT',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: const Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 12),
          const ModernShiftTile(),
          const SizedBox(height: 12),
          Text(
            'SETTINGS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: const Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 12),
          _ModernMenuRow(
            iconSvg: DashboardQuickAccessSvgs.drawerAuthShieldIcon(),
            title: 'Auth',
            subtitle: 'Authentication settings',
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MfaSetupView()),
              );
            },
          ),
          const SizedBox(height: 12),
          _ModernMenuRow(
            iconSvg: DashboardQuickAccessSvgs.drawerOnlinePrintSyncIcon(),
            title: 'Online Print',
            subtitle: 'Manage print settings',
            onTap: () {
              Navigator.pop(context); // Close the drawer
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => DraggableScrollableSheet(
                  initialChildSize: 0.75,
                  minChildSize: 0.5,
                  maxChildSize: 0.9,
                  builder: (context, scrollController) => Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Handle bar
                        Container(
                          margin: const EdgeInsets.only(top: 12, bottom: 8),
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        // Header
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(37, 99, 235, 0.10),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Center(
                                  child: DashboardQuickAccessSvgs.icon(
                                    DashboardQuickAccessSvgs
                                        .drawerOnlinePrintSyncIcon(),
                                    width: 22,
                                    height: 22,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'Transaction Delegation',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xFFE5E7EB),
                                  ),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => Navigator.pop(context),
                                    borderRadius: BorderRadius.circular(999),
                                    child: Center(
                                      child: DashboardQuickAccessSvgs.icon(
                                        DashboardQuickAccessSvgs.drawerCloseXIcon(),
                                        width: 14,
                                        height: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        // Content
                        Expanded(
                          child: SingleChildScrollView(
                            controller: scrollController,
                            padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                            child: const _MobileTransactionDelegationSettings(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _ModernSwitchRow(
            iconSvg: DashboardQuickAccessSvgs.drawerUserLoggingFileIcon(),
            title: 'User Logging',
            subtitle: 'Enable extensive logging',
            value: userLoggingEnabled,
            onChanged: (value) async {
              await ProxyService.box.setUserLoggingEnabled(value);
              setState(() {
                userLoggingEnabled = value;
              });
            },
          ),
          const SizedBox(height: 12),
          _ModernSwitchRow(
            iconSvg: DashboardQuickAccessSvgs.drawerBackgroundSyncGridPlusIcon(),
            title: 'Background Sync',
            subtitle: 'Sync data in background',
            value: backgroundSyncEnabled,
            onChanged: (value) async {
              await ProxyService.box.writeBool(
                key: 'background_sync_enabled',
                value: value,
              );
              setState(() {
                backgroundSyncEnabled = value;
              });
              if (value) {
                final appID = kDebugMode
                    ? AppSecrets.appIdDebug
                    : AppSecrets.appId;

                final userId = ProxyService.box.getUserId();
                if (userId != null && appID.isNotEmpty) {
                  await DittoSingleton.instance.initialize(
                    appId: appID,
                    userId: userId,
                  );
                  DittoSyncCoordinator.instance.setDitto(
                    DittoSingleton.instance.ditto,
                    skipInitialFetch:
                        true, // Skip initial fetch to prevent upserting all models on startup
                  );
                  final prefsBox = ProxyService.box;
                  if (prefsBox is SharedPreferenceStorage) {
                    await prefsBox.attachDittoPersistence();
                  }
                  await ProxyService.notification.sendLocalNotification(
                    body:
                        "Background Sync Enabled, to disable it, go to settings and disable it",
                  );
                }
              } else {
                // Stop Ditto sync and cleanup when disabling
                await DittoSyncCoordinator.instance.setDitto(null);
                await DittoSingleton.instance.dispose();
                await ProxyService.notification.sendLocalNotification(
                  body: "Background Sync Disabled",
                );
              }
            },
          ),
          const SizedBox(height: 12),
          // EBM Status Indicator
          Consumer(
            builder: (context, ref, child) {
              final ebmStatus = ref.watch(ebmVatEnabledProvider);
              return ebmStatus.when(
                data: (isVatEnabled) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isVatEnabled
                          ? Colors.green.shade50
                          : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isVatEnabled
                            ? Colors.green.shade300
                            : Colors.red.shade300,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isVatEnabled ? Icons.check_circle : Icons.cancel,
                          color: isVatEnabled ? Colors.green : Colors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isVatEnabled ? 'EBM On' : 'EBM Off',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: isVatEnabled
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                loading: () => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Checking EBM status...',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                error: (error, stack) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade300, width: 1),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'EBM Status Error',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F8),
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: SafeArea(
        top: false,
        child: _ModernBaseRow(
          iconSvg: DashboardQuickAccessSvgs.drawerSignOutIcon(),
          title: 'Sign Out',
          titleColor: const Color(0xFFDC2626),
          subtitle: null,
          trailing: const SizedBox(width: 14, height: 14),
          onTap: () {
            locator<DialogService>().showCustomDialog(
              variant: DialogType.logOut,
              title: 'Sign Out',
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState(String message) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 12),
          Text(message, style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(icon, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 13, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String title, String error, VoidCallback onRetry) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(Icons.error_outline_rounded, size: 48, color: Colors.red[400]),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            error,
            style: TextStyle(fontSize: 13, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }

  Future<Tenant?> _getTenantFuture() async {
    final userId = ProxyService.box.getUserId();
    if (userId == null) return null;
    return ProxyService.strategy.getTenant(userId: userId);
  }

  Future<void> _handleBranchSelection(
    BuildContext context,
    Business business,
    Branch branch,
  ) async {
    // Use the mixin's standardized branch selection logic
    handleBranchSelection(
      branch,
      context,
      setLoadingState: (String? id) {
        if (mounted) {
          setState(() {
            _switchingBranchId = id;
          });
        }
      },
      setDefaultBranch: _setDefaultBranch,
      onComplete: () {
        if (mounted) {
          setState(() {
            _switchingBranchId = null;
          });
          // Close the drawer after successful switch
          Navigator.pop(context);
        }
      },
      setIsLoading: (bool value) {
        // We can use this if we need a general loading state,
        // but _switchingBranchId effectively handles it for specific items
      },
    );
  }

  Future<void> _setDefaultBranch(Branch branch) async {
    // This matches the logic from ribbon.dart's usage of the mixin
    // The mixin handles database updates, this just needs to refresh providers
    // if there's any specific extra work needed.
    // But BranchSelectionMixin.handleBranchSelection calls _syncBranchWithDatabase
    // and _updateBranchActive internally.

    // We can add any specific post-switch logic here if needed,
    // but for now just returning is fine as the mixin does the heavy lifting.
    return Future.value();
  }
}

class ModernShiftTile extends StatefulWidget {
  const ModernShiftTile({Key? key}) : super(key: key);

  @override
  _ModernShiftTileState createState() => _ModernShiftTileState();
}

class _ModernShiftTileState extends State<ModernShiftTile> {
  Future<Shift?>? _shiftFuture;

  @override
  void initState() {
    super.initState();
    _loadShiftStatus();
  }

  void _loadShiftStatus() {
    final userId = ProxyService.box.getUserId();
    if (userId != null) {
      setState(() {
        _shiftFuture = ProxyService.strategy.getCurrentShift(userId: userId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Shift?>(
      future: _shiftFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 12),
                Text(
                  'Checking shift status...',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        final shift = snapshot.data;
        final isShiftOpen = shift != null;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _handleShiftAction(isShiftOpen, shift),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isShiftOpen
                            ? const Color.fromRGBO(220, 38, 38, 0.10)
                            : const Color.fromRGBO(22, 163, 74, 0.10),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: isShiftOpen
                            ? DashboardQuickAccessSvgs.icon(
                                DashboardQuickAccessSvgs
                                    .drawerCloseShiftLockIcon(),
                                width: 24,
                                height: 24,
                              )
                            : const Icon(
                                Icons.lock_open_rounded,
                                size: 20,
                                color: Color(0xFF16A34A),
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isShiftOpen ? 'Close Shift' : 'Open Shift',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isShiftOpen
                                ? 'End current shift'
                                : 'Start new shift',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isShiftOpen)
                      Container(
                        width: 22,
                        height: 22,
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(220, 38, 38, 0.10),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: DashboardQuickAccessSvgs.icon(
                            DashboardQuickAccessSvgs
                                .drawerShiftWarningBadgeIcon(),
                            width: 10,
                            height: 10,
                          ),
                        ),
                      ),
                    const SizedBox(width: 10),
                    DashboardQuickAccessSvgs.icon(
                      DashboardQuickAccessSvgs.drawerChevronRightIcon(),
                      width: 14,
                      height: 14,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleShiftAction(bool isShiftOpen, Shift? shift) async {
    final dialogService = locator<DialogService>();

    if (isShiftOpen && shift != null) {
      final dialogResponse = await dialogService.showCustomDialog(
        variant: DialogType.closeShift,
        title: 'Close Shift',
        data: {
          'openingBalance': shift.openingBalance,
          'cashSales': shift.cashSales,
          'expectedCash': shift.expectedCash,
        },
      );

      if (dialogResponse?.confirmed == true && dialogResponse?.data != null) {
        final dynamic rawBalance =
            (dialogResponse?.data as Map<dynamic, dynamic>)['closingBalance'];
        double closingBalance = 0.0;
        if (rawBalance is num) {
          closingBalance = rawBalance.toDouble();
        } else if (rawBalance is String) {
          closingBalance = double.tryParse(rawBalance) ?? 0.0;
        }
        final notes =
            (dialogResponse?.data as Map<dynamic, dynamic>)['notes'] as String?;
        await ProxyService.strategy.endShift(
          shiftId: shift.id,
          closingBalance: closingBalance,
          note: notes,
        );
        locator<RouterService>().replaceWith(const LoginRoute());
      }
    } else {
      final userId = ProxyService.box.getUserId();
      if (userId == null) return;

      final response = await dialogService.showCustomDialog(
        variant: DialogType.startShift,
        title: 'Start New Shift',
      );
      if (response != null && response.confirmed) {
        final openingBalance =
            response.data['openingBalance'] as double? ?? 0.0;
        final notes = response.data['notes'] as String?;
        await ProxyService.strategy.startShift(
          userId: userId,
          openingBalance: openingBalance,
          note: notes,
        );
        _loadShiftStatus();
      }
    }
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final String iconSvg;
  final Color titleColor;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.iconSvg,
    required this.titleColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              DashboardQuickAccessSvgs.icon(iconSvg, width: 28, height: 28),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModernBusinessCard extends StatefulWidget {
  final Business business;
  final Function(Branch) onBranchSelected;
  final String? switchingBranchId;

  const _ModernBusinessCard({
    required this.business,
    required this.onBranchSelected,
    this.switchingBranchId,
  });

  @override
  State<_ModernBusinessCard> createState() => _ModernBusinessCardState();
}

class _ModernBusinessCardState extends State<_ModernBusinessCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    // The branches are now expected to be populated via getUserAccess
    // which modifies the Business object before it reaches here.
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: _buildBusinessCard(context, widget.business.branches ?? []),
    );
  }

  Widget _buildBusinessCard(BuildContext context, List<Branch> branches) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: ExpansionTile(
        onExpansionChanged: (value) => setState(() => _expanded = value),
        trailing: AnimatedRotation(
          duration: const Duration(milliseconds: 150),
          turns: _expanded ? 0.5 : 0.0,
          child: DashboardQuickAccessSvgs.icon(
            DashboardQuickAccessSvgs.drawerChevronDownIcon(),
            width: 16,
            height: 16,
          ),
        ),
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.only(bottom: 8),
        collapsedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(37, 99, 235, 0.10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: DashboardQuickAccessSvgs.icon(
              DashboardQuickAccessSvgs.drawerBusinessIconBlue(),
              width: 22,
              height: 22,
            ),
          ),
        ),
        title: Text(
          widget.business.name ?? 'Unnamed Business',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        subtitle: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(37, 99, 235, 0.10),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '${branches.length} ${branches.length == 1 ? 'branch' : 'branches'}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2563EB),
              ),
            ),
          ),
        ),
        children: branches.isEmpty
            ? [
                _BranchItem(
                  branch: Branch(
                    id: 'main',
                    name: 'Main Branch',
                    businessId: widget.business.id,
                  ),
                  switchingBranchId: widget.switchingBranchId,
                  onTap: () => widget.onBranchSelected(
                    Branch(
                      id: 'main',
                      name: 'Main Branch',
                      businessId: widget.business.id,
                    ),
                  ),
                ),
              ]
            : branches
                  .map(
                    (branch) => _BranchItem(
                      branch: branch,
                      switchingBranchId: widget.switchingBranchId,
                      onTap: () => widget.onBranchSelected(branch),
                    ),
                  )
                  .toList(),
      ),
    );
  }
}

class _BranchItem extends StatelessWidget {
  final Branch branch;
  final VoidCallback onTap;
  final String? switchingBranchId;

  const _BranchItem({
    required this.branch,
    required this.onTap,
    this.switchingBranchId,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = ProxyService.box.getBranchId() == branch.id;
    final bool isLoading = switchingBranchId == branch.id.toString();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const SizedBox(width: 52),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF0078D4).withValues(alpha: 0.1)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.store_rounded,
                  size: 14,
                  color: isActive ? const Color(0xFF0078D4) : Colors.grey[600],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  branch.name ?? 'Unnamed Branch',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    color: isActive ? const Color(0xFF0078D4) : null,
                  ),
                ),
              ),
              if (isLoading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else if (isActive)
                const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF0078D4),
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModernSwitchRow extends StatelessWidget {
  final String iconSvg;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ModernSwitchRow({
    required this.iconSvg,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _ModernBaseRow(
      iconSvg: iconSvg,
      title: title,
      subtitle: subtitle,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: const Color(0xFF2563EB),
      ),
    );
  }
}

class _ModernMenuRow extends StatelessWidget {
  final String iconSvg;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _ModernMenuRow({
    required this.iconSvg,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _ModernBaseRow(
      iconSvg: iconSvg,
      title: title,
      subtitle: subtitle,
      trailing: DashboardQuickAccessSvgs.icon(
        DashboardQuickAccessSvgs.drawerChevronRightIcon(),
        width: 14,
        height: 14,
      ),
      onTap: onTap,
    );
  }
}

class _ModernBaseRow extends StatelessWidget {
  final String iconSvg;
  final String title;
  final String? subtitle;
  final Color? titleColor;
  final Widget trailing;
  final VoidCallback? onTap;

  const _ModernBaseRow({
    required this.iconSvg,
    required this.title,
    required this.trailing,
    this.subtitle,
    this.titleColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child:
                  DashboardQuickAccessSvgs.icon(iconSvg, width: 22, height: 22),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: titleColor ?? const Color(0xFF111827),
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF9CA3AF),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          trailing,
        ],
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: content,
        ),
      ),
    );
  }
}

/// Mobile-optimized Transaction Delegation Settings
class _MobileTransactionDelegationSettings extends ConsumerStatefulWidget {
  const _MobileTransactionDelegationSettings();

  @override
  ConsumerState<_MobileTransactionDelegationSettings> createState() =>
      _MobileTransactionDelegationSettingsState();
}

class _MobileTransactionDelegationSettingsState
    extends ConsumerState<_MobileTransactionDelegationSettings> {
  bool _isEnabled = false;
  bool _isLoading = true;
  String? _selectedDeviceId;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final enabled = ProxyService.box.readBool(
      key: 'enableTransactionDelegation',
    );

    final selectedDeviceId = ProxyService.box.readString(
      key: 'selectedDelegationDeviceId',
    );

    setState(() {
      _isEnabled = enabled ?? false;
      _selectedDeviceId = selectedDeviceId;
      _isLoading = false;
    });
  }

  Future<void> _toggleDelegation(bool value) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await ProxyService.box.writeBool(
        key: 'enableTransactionDelegation',
        value: value,
      );

      setState(() {
        _isEnabled = value;
        _isLoading = false;
      });

      if (mounted) {
        showCustomSnackBarUtil(
          context,
          value
              ? 'Transaction delegation enabled'
              : 'Transaction delegation disabled',
          type: value ? NotificationType.success : NotificationType.info,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        showCustomSnackBarUtil(
          context,
          'Error: ${e.toString()}',
          type: NotificationType.error,
        );
      }
    }
  }

  Future<void> _selectDevice(String deviceId) async {
    try {
      await ProxyService.box.writeString(
        key: 'selectedDelegationDeviceId',
        value: deviceId,
      );

      setState(() {
        _selectedDeviceId = deviceId;
      });

      if (mounted) {
        showCustomSnackBarUtil(
          context,
          'Delegation device selected',
          type: NotificationType.success,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      if (mounted) {
        showCustomSnackBarUtil(
          context,
          'Error selecting device: ${e.toString()}',
          type: NotificationType.error,
        );
      }
    }
  }

  Widget _buildDeviceSelectionSection(BuildContext context) {
    final branchId = ProxyService.box.getBranchId();

    if (branchId == null) {
      return const SizedBox.shrink();
    }

    final devicesAsync = ref.watch(
      devicesForBranchProvider(branchId: branchId),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.devices_rounded,
                  color: Color(0xFF0078D4),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Select Device',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),
          devicesAsync.when(
            data: (devices) {
              if (devices.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'No devices available in this branch',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                );
              }

              return RadioGroup<String>(
                groupValue: _selectedDeviceId,
                onChanged: (value) {
                  if (value != null) {
                    _selectDevice(value);
                  }
                },
                child: Column(
                  children: devices.map((device) {
                    return RadioListTile<String>(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        device.deviceName ?? 'Unknown Device',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: device.phone != null
                          ? Text('Phone: ${device.phone}')
                          : null,
                      value: device.id,
                      activeColor: const Color(0xFF0078D4),
                    );
                  }).toList(),
                ),
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stack) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Error loading devices: ${error.toString()}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F7FB),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(37, 99, 235, 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: DashboardQuickAccessSvgs.icon(
                    DashboardQuickAccessSvgs.drawerOnlinePrintSyncIcon(),
                    width: 22,
                    height: 22,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Delegate',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        height: 1.05,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'Receipt printing to desktop when EBM server is unavailable',
                      style: TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF9CA3AF),
                        height: 1.25,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _isEnabled
                                ? const Color(0xFF22C55E)
                                : const Color(0xFFD1D5DB),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isEnabled ? 'Enabled' : 'Disabled',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Transform.translate(
                offset: const Offset(6, -4),
                child: Switch(
                  value: _isEnabled,
                  onChanged: _toggleDelegation,
                  activeThumbColor: const Color(0xFF2563EB),
                ),
              ),
            ],
          ),
        ),

        if (_isEnabled) ...[
          const SizedBox(height: 16),
          _buildDeviceSelectionSection(context),
        ],

        const SizedBox(height: 24),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFDBEAFE), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Color(0xFF2563EB),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'How it works',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _HowItWorksStep(
                number: 1,
                icon: Icons.phone_android_rounded,
                text:
                    'Mobile completes the transaction but\ndelegates receipt generation',
              ),
              const SizedBox(height: 10),
              _HowItWorksStep(
                number: 2,
                icon: Icons.desktop_windows_rounded,
                text: 'Desktop picks up the transaction via sync',
              ),
              const SizedBox(height: 10),
              _HowItWorksStep(
                number: 3,
                icon: Icons.description_outlined,
                text:
                    'Desktop generates the receipt and\ncommunicates with EBM server',
              ),
              const SizedBox(height: 10),
              _HowItWorksStep(
                number: 4,
                icon: Icons.notifications_none_rounded,
                text: 'Mobile is notified when processing is\ncomplete',
                showConnector: false,
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Requirements section
        if (_isEnabled)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFB74D), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.lightbulb_outline,
                      color: Color(0xFFE65100),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Requirements',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange[900],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildRequirement(
                  '• Desktop app must be running with delegation enabled',
                ),
                const SizedBox(height: 6),
                _buildRequirement(
                  '• Both devices must be syncing via flipper sync',
                ),
                const SizedBox(height: 6),
                _buildRequirement(
                  '• Desktop processes delegated transactions every 10 seconds',
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildRequirement(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 13, color: Colors.orange[900], height: 1.4),
    );
  }
}

class _HowItWorksStep extends StatelessWidget {
  final int number;
  final IconData icon;
  final String text;
  final bool showConnector;

  const _HowItWorksStep({
    required this.number,
    required this.icon,
    required this.text,
    this.showConnector = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (showConnector)
          Positioned(
            left: 15,
            top: 38,
            bottom: -10,
            child: Container(
              width: 2,
              decoration: BoxDecoration(
                color: const Color(0xFFDBEAFE),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.65),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFDBEAFE)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Center(
                  child: Text(
                    '$number',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(icon, size: 18, color: const Color(0xFF2563EB)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.25,
                    color: Color(0xFF2563EB),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
