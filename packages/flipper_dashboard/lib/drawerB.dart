import 'package:flipper_models/providers/branch_business_provider.dart';
import 'package:flipper_models/providers/scan_mode_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_routing/app.dialogs.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_services/app_service.dart';

class MyDrawer extends ConsumerStatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  ConsumerState<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends ConsumerState<MyDrawer> {
  String? _switchingBranchId;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF8F9FA),
      child: Column(
        children: [
          _buildModernHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom +
                    80, // Account for bottom section
              ),
              child: Column(
                children: [
                  _buildQuickActions(context),
                  const SizedBox(height: 24),
                  _buildBusinessSection(context),
                  const SizedBox(height: 24),
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
            height: 140,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0078D4), Color(0xFF106EBE)],
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
        return Container(
          height: 140,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0078D4), Color(0xFF106EBE)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  // Business icon
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.business_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Business info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          tenant?.name ?? "My Business",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
            'Quick Actions',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _QuickActionCard(
                  icon: Icons.qr_code_scanner_rounded,
                  title: 'Scan QR',
                  color: const Color(0xFF0078D4),
                  onTap: () {
                    Navigator.pop(context);
                    locator<RouterService>()
                        .navigateTo(ScannViewRoute(intent: 'login'));
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickActionCard(
                  icon: Icons.dashboard_rounded,
                  title: 'Dashboard',
                  color: const Color(0xFF107C10),
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
      future: ProxyService.strategy.businesses(userId: userId),
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
            'Your Businesses',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          ...businesses.map((business) => _ModernBusinessCard(
                business: business,
                switchingBranchId: _switchingBranchId,
                onBranchSelected: (branch) {
                  _handleBranchSelection(context, business, branch);
                },
              )),
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
            'Management',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          const ModernShiftTile(),
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
        color: const Color(0xFFF8F9FA),
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: SafeArea(
        top: false,
        child: _ModernMenuItem(
          icon: Icons.logout_rounded,
          title: 'Sign Out',
          color: const Color(0xFFD13438),
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
          Text(
            message,
            style: TextStyle(color: Colors.grey[600]),
          ),
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
          Icon(
            icon,
            size: 48,
            color: Colors.grey[400],
          ),
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
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[500],
            ),
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
          Icon(
            Icons.error_outline_rounded,
            size: 48,
            color: Colors.red[400],
          ),
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
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
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
      BuildContext context, Business business, Branch branch) async {
    if (ProxyService.box.readBool(key: 'branch_switching') ?? false) {
      return;
    }

    setState(() {
      _switchingBranchId = branch.serverId.toString();
    });

    final appService = locator<AppService>();

    try {
      await ProxyService.box.writeBool(key: 'branch_switching', value: true);

      final currentBranchId = ProxyService.box.readInt(key: 'branchId');

      if (currentBranchId != branch.serverId) {
        await ProxyService.box
            .writeInt(key: 'branchId', value: branch.serverId!);
        await ProxyService.box
            .writeString(key: 'branchIdString', value: branch.id);
        await ProxyService.box
            .writeInt(key: 'currentBusinessId', value: business.serverId);
        await ProxyService.box
            .writeInt(key: 'currentBranchId', value: branch.serverId!);

        await appService.updateAllBranchesInactive();
        await ProxyService.strategy.updateBranch(
          branchId: branch.serverId!,
          active: true,
          isDefault: true,
        );

        ref.invalidate(branchesProvider(businessId: business.serverId));
        ref.read(searchStringProvider.notifier).emitString(value: "search");
        ref.read(searchStringProvider.notifier).emitString(value: "");
      }

      Navigator.pop(context);
      // locator<RouterService>().navigateTo(DashboardViewRoute());
    } finally {
      setState(() {
        _switchingBranchId = null;
      });
      await ProxyService.box.writeBool(key: 'branch_switching', value: false);
    }
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
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
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
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
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
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isShiftOpen
                            ? const Color(0xFFD13438).withValues(alpha: 0.1)
                            : const Color(0xFF107C10).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        isShiftOpen
                            ? Icons.lock_clock_rounded
                            : Icons.lock_open_rounded,
                        size: 20,
                        color: isShiftOpen
                            ? const Color(0xFFD13438)
                            : const Color(0xFF107C10),
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
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isShiftOpen
                            ? const Color(0xFFD13438).withValues(alpha: 0.1)
                            : const Color(0xFF107C10).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isShiftOpen
                            ? Icons.stop_rounded
                            : Icons.play_arrow_rounded,
                        size: 14,
                        color: isShiftOpen
                            ? const Color(0xFFD13438)
                            : const Color(0xFF107C10),
                      ),
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
        final closingBalance = (dialogResponse?.data
                as Map<dynamic, dynamic>)['closingBalance'] as double? ??
            0.0;
        final notes =
            (dialogResponse?.data as Map<dynamic, dynamic>)['notes'] as String?;
        await ProxyService.strategy.endShift(
            shiftId: shift.id, closingBalance: closingBalance, note: notes);
        locator<RouterService>().replaceWith(const LoginRoute());
      }
    } else {
      final userId = ProxyService.box.getUserId();
      if (userId == null) return;

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
        _loadShiftStatus();
      }
    }
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModernBusinessCard extends StatelessWidget {
  final Business business;
  final Function(Branch) onBranchSelected;
  final String? switchingBranchId;

  const _ModernBusinessCard({
    required this.business,
    required this.onBranchSelected,
    this.switchingBranchId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: FutureBuilder<List<Branch>>(
        future: ProxyService.strategy.branches(businessId: business.serverId),
        builder: (context, branchSnapshot) {
          if (branchSnapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingCard();
          }

          if (branchSnapshot.hasError) {
            return _buildErrorCard();
          }

          final List<Branch> branches = branchSnapshot.data ?? [];
          return _buildBusinessCard(context, branches);
        },
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.business_rounded, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  business.name ?? 'Loading...',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Loading branches...',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.error_outline_rounded,
              size: 20,
              color: Colors.red.shade400,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  business.name ?? 'Error',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Failed to load branches',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.red[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessCard(BuildContext context, List<Branch> branches) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      childrenPadding: const EdgeInsets.only(bottom: 8),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF0078D4).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.business_rounded,
          size: 20,
          color: Color(0xFF0078D4),
        ),
      ),
      title: Text(
        business.name ?? 'Unnamed Business',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        '${branches.length} ${branches.length == 1 ? 'branch' : 'branches'}',
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey[600],
        ),
      ),
      children: branches.isEmpty
          ? [
              _BranchItem(
                branch: Branch(
                  id: 'main',
                  name: 'Main Branch',
                  businessId: business.serverId,
                ),
                switchingBranchId: switchingBranchId,
                onTap: () => onBranchSelected(Branch(
                  id: 'main',
                  name: 'Main Branch',
                  businessId: business.serverId,
                )),
              ),
            ]
          : branches
              .map((branch) => _BranchItem(
                    branch: branch,
                    switchingBranchId: switchingBranchId,
                    onTap: () => onBranchSelected(branch),
                  ))
              .toList(),
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
    final bool isActive = ProxyService.box.getBranchId() == branch.serverId;
    final bool isLoading = switchingBranchId == branch.serverId.toString();

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

class _ModernMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _ModernMenuItem({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
