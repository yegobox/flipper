import 'package:flipper_dashboard/ActiveBranch.dart';
import 'package:flipper_dashboard/BranchSelectionMixin.dart';
import 'package:flipper_models/providers/branch_business_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart'
    show
        branchSelectionProvider,
        businessesProvider,
        buttonIndexProvider;
import 'package:flipper_dashboard/logout/dashboard_sign_out.dart';
import 'package:flipper_dashboard/logout/end_of_shift_dialog.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/dialogs/AdminPinDialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_models/brick/models/branch.model.dart';

import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'providers/navigation_providers.dart';
import 'package:flipper_routing/app.dialogs.dart';
import 'package:flipper_dashboard/dashboard_shell.dart';
import 'package:flipper_dashboard/pos_layout_breakpoints.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/mfa_setup_view.dart';
import 'package:flipper_dashboard/widgets/dashboard_quick_access_svgs.dart';
import 'package:flipper_dashboard/widgets/admin_dashboard_svgs.dart';

class EnhancedSideMenu extends ConsumerStatefulWidget {
  const EnhancedSideMenu({super.key});

  @override
  ConsumerState<EnhancedSideMenu> createState() => _EnhancedSideMenuState();
}

class _EnhancedSideMenuState extends ConsumerState<EnhancedSideMenu>
    with BranchSelectionMixin {
  String? _loadingItemId;

  Future<bool> _verifyAdminPinIfRequired(BuildContext context) async {
    final settingsService = ProxyService.settings;
    if (!settingsService.isAdminPinEnabled) return true;
    final setting = await settingsService.settings();
    final confirmed = await showAdminPinDialog(
      context: context,
      mode: AdminPinMode.verify,
      expectedPin: setting?.adminPin,
    );
    return confirmed == true;
  }

  Future<void> _setDefaultBranch(Branch branch) async {
    ref.read(branchSelectionProvider.notifier).setLoading(true);
    _refreshBusinessAndBranchProviders();
  }

  void _refreshBusinessAndBranchProviders() {
    // ignore: unused_result
    ref.refresh(businessesProvider);
    // ignore: unused_result
    ref.refresh(branchesProvider(businessId: ProxyService.box.getBusinessId()));
  }

  Future<void> _openEndOfShiftMenu() async {
    final ok = await _verifyAdminPinIfRequired(context);
    if (!ok || !mounted) return;

    final branchName = ref.read(activeBranchProvider).maybeWhen(
          data: (b) => b.name,
          orElse: () => null,
        );
    final action = await EndOfShiftDialog.show(
      context,
      branchName: branchName,
    );
    if (!mounted || action == null) return;

    switch (action) {
      case EndOfShiftAction.signOut:
        await _signOutCurrentAgent();
      case EndOfShiftAction.switchBranch:
        await _openBranchSwitchDialog();
    }
  }

  Future<void> _signOutCurrentAgent() async {
    final dialogService = locator<DialogService>();
    final routerService = locator<RouterService>();
    await completeDashboardSignOut(
      context: context,
      dialogService: dialogService,
      routerService: routerService,
      loaderUseRootNavigator: true,
    );
  }

  Future<void> _openBranchSwitchDialog() async {
    ref.read(buttonIndexProvider.notifier).setIndex(2);
    await showBranchSwitchDialog(
      context: context,
      branches: null,
      loadingItemId: _loadingItemId,
      setDefaultBranch: (branch) async {
        await handleBranchSelection(
          branch,
          context,
          setLoadingState: (String? id) {
            setState(() {
              _loadingItemId = id;
            });
          },
          setDefaultBranch: _setDefaultBranch,
          onComplete: () {
            Navigator.of(context).pop();
          },
          setIsLoading: (_) {},
        );
      },
      handleBranchSelection: handleBranchSelection,
      onLogout: _signOutCurrentAgent,
      setLoadingState: (String? id) {
        setState(() {
          _loadingItemId = id;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedItem = ref.watch(selectedMenuItemProvider);
    final _dialogService = locator<DialogService>();

    final isDesktop =
        kIsWeb ||
        const {
          TargetPlatform.macOS,
          TargetPlatform.windows,
          TargetPlatform.linux,
        }.contains(defaultTargetPlatform);

    final menu = ref.watch(sideMenuVisibilityProvider);
    final showKds = menu.kds;
    final showItems = menu.items;
    final showDailyReportFiles = menu.dailyReportFiles;
    final showStockRecount = menu.stockRecount;
    final showIncomingOrders = menu.incomingOrders;
    final showProduction = menu.production;
    final showShiftHistory = menu.shiftHistory;
    final showDelegations = menu.delegations;
    final showLeads = menu.leads;
    final showAgentCommission = menu.agentCommission;

    final menuItems = [
      _SideMenuItem(
        iconBuilder: (c) => _coloredSideMenuSvg(_SideMenuSvgs.appGrid, c),
        isSelected: selectedItem == 0,
        onTap: () {
          ref.read(selectedMenuItemProvider.notifier).state = 0;
          ref.read(selectedPageProvider.notifier).state =
              DashboardPage.inventory;
        },
        tooltip: 'Overview',
      ),
      _SideMenuItem(
        iconBuilder: (c) => _coloredSideMenuSvg(_SideMenuSvgs.aiChat, c),
        isSelected: selectedItem == 1,
        onTap: () {
          ref.read(selectedMenuItemProvider.notifier).state = 1;
          ref.read(selectedPageProvider.notifier).state = DashboardPage.ai;
        },
        tooltip: 'Chat',
      ),
      if (showLeads)
        _SideMenuItem(
          iconBuilder: (c) => SvgPicture.string(
            AdminDashboardSvgs.leadsUsersMultiple,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(c, BlendMode.srcIn),
          ),
          isSelected: selectedItem == 10,
          onTap: () {
            ref.read(selectedMenuItemProvider.notifier).state = 10;
            ref.read(selectedPageProvider.notifier).state = DashboardPage.leads;
          },
          tooltip: 'Leads',
        ),
      if (isDesktop)
        _SideMenuItem(
          iconBuilder: (c) => _coloredSideMenuSvg(
            DashboardQuickAccessSvgs.drawerAuthShieldIcon(),
            c,
          ),
          isSelected: false,
          onTap: () {
            showDialog<void>(
              context: context,
              barrierDismissible: true,
              builder: (context) {
                return Dialog(
                  insetPadding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 28,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 620,
                      maxHeight: 860,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: const MfaSetupView(),
                    ),
                  ),
                );
              },
            );
          },
          tooltip: 'Authenticator',
        ),
      if (showItems)
        _SideMenuItem(
          iconBuilder: (c) => _coloredSideMenuSvg(_SideMenuSvgs.inventory, c),
          isSelected: selectedItem == 2,
          onTap: () {
            ref.read(selectedMenuItemProvider.notifier).state = 2;
            ref.read(selectedPageProvider.notifier).state =
                DashboardPage.reports;
          },
          tooltip: 'Items',
        ),
      if (showDailyReportFiles)
        _SideMenuItem(
          iconBuilder: (c) => DashboardQuickAccessSvgs.assetIcon(
            DashboardQuickAccessSvgs.chart,
            size: 24,
            color: c,
          ),
          isSelected: selectedItem == 11,
          onTap: () {
            ref.read(selectedMenuItemProvider.notifier).state = 11;
            ref.read(selectedPageProvider.notifier).state =
                DashboardPage.dailyReportFiles;
          },
          tooltip: 'Daily Reports',
        ),
      if (showKds)
        _SideMenuItem(
          iconBuilder: (c) => Icon(Icons.restaurant_menu, color: c, size: 24),
          isSelected: selectedItem == 3,
          onTap: () {
            ref.read(selectedMenuItemProvider.notifier).state = 3;
            ref.read(selectedPageProvider.notifier).state =
                DashboardPage.kitchen;
          },
          tooltip: 'Kitchen Display',
        ),
      if (showStockRecount)
        _SideMenuItem(
          iconBuilder: (c) =>
              _coloredSideMenuSvg(_SideMenuSvgs.stockRecount, c),
          isSelected: selectedItem == 6,
          onTap: () {
            ref.read(selectedMenuItemProvider.notifier).state = 6;
            ref.read(selectedPageProvider.notifier).state =
                DashboardPage.stockRecount;
          },
          tooltip: 'Stock Recount',
        ),
      if (showDelegations)
        _SideMenuItem(
          iconBuilder: (c) => Icon(Icons.print_outlined, color: c, size: 24),
          isSelected: selectedItem == 7,
          onTap: () {
            ref.read(selectedMenuItemProvider.notifier).state = 7;
            ref.read(selectedPageProvider.notifier).state =
                DashboardPage.delegations;
          },
          tooltip: 'Delegations',
        ),
      if (showIncomingOrders)
        _SideMenuItem(
          iconBuilder: (c) =>
              _coloredSideMenuSvg(_SideMenuSvgs.inboxImport, c),
          isSelected: selectedItem == 8,
          onTap: () {
            ref.read(selectedMenuItemProvider.notifier).state = 8;
            ref.read(selectedPageProvider.notifier).state =
                DashboardPage.incomingOrders;
          },
          tooltip: 'Incoming Orders',
        ),
      if (showIncomingOrders)
        _SideMenuItem(
          iconBuilder: (c) => Icon(Icons.swap_horiz, color: c, size: 24),
          isSelected: selectedItem == 14,
          onTap: () {
            ref.read(selectedMenuItemProvider.notifier).state = 14;
            ref.read(selectedPageProvider.notifier).state =
                DashboardPage.transfersReport;
          },
          tooltip: 'Transfers Report',
        ),
      if (showProduction)
        _SideMenuItem(
          iconBuilder: (c) => _coloredSideMenuSvg(_SideMenuSvgs.production, c),
          isSelected: selectedItem == 9,
          onTap: () {
            ref.read(selectedMenuItemProvider.notifier).state = 9;
            ref.read(selectedPageProvider.notifier).state =
                DashboardPage.productionOutput;
          },
          tooltip: 'Production Output',
        ),
      if (showShiftHistory)
        _SideMenuItem(
          iconBuilder: (c) => _coloredSideMenuSvg(_SideMenuSvgs.history, c),
          isSelected: selectedItem == 5,
          onTap: () {
            ref.read(selectedMenuItemProvider.notifier).state = 5;
            ref.read(selectedPageProvider.notifier).state =
                DashboardPage.shiftHistory;
          },
          tooltip: 'Shift History',
        ),
      if (showAgentCommission)
        _SideMenuItem(
          iconBuilder: (c) => Icon(Icons.support_agent, color: c, size: 24),
          isSelected: selectedItem == 12,
          onTap: () {
            ref.read(selectedMenuItemProvider.notifier).state = 12;
            ref.read(selectedPageProvider.notifier).state =
                DashboardPage.agentCommission;
          },
          tooltip: 'Agent commission',
        ),
      _SideMenuItem(
        key: const Key('eod_desktop'),
        iconBuilder: (c) => _coloredSideMenuSvg(_SideMenuSvgs.logout, c),
        isSelected: selectedItem == 4,
        onTap: () => _openEndOfShiftMenu(),
        tooltip: 'End shift',
        isLogout: true,
      ),
    ];

    // Width, border, and header logo live in [DashboardLayout] so the logo shares
    // one row with [UnifiedTopBar] / FLIPPER.
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: menuItems
                  .map((item) => SizedBox(height: 56, child: item))
                  .toList(),
            ),
          ),
        ),
        Column(
          children: [
            IconButton(
              icon: _coloredSideMenuSvg(
                _SideMenuSvgs.appGrid,
                PosTokens.ink3,
              ),
              onPressed: () {
                _dialogService.showCustomDialog(
                  variant: DialogType.appChoice,
                  title: 'Choose Your Default App',
                );
              },
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: const ActiveBranch(),
            ),
          ],
        ),
      ],
    );
  }
}

class _SideMenuSvgs {
  _SideMenuSvgs._();

  static const inventory =
      '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M12 2L2 7l10 5 10-5-10-5z" stroke="currentColor" stroke-width="1.7" stroke-linejoin="round" stroke-linecap="round"/>
  <path d="M2 17l10 5 10-5" stroke="currentColor" stroke-width="1.7" stroke-linejoin="round" stroke-linecap="round"/>
  <path d="M2 12l10 5 10-5" stroke="currentColor" stroke-width="1.7" stroke-linejoin="round" stroke-linecap="round"/>
</svg>''';

  static const stockRecount =
      '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
  <rect x="9" y="3" width="6" height="4" rx="1" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M9 12h1M12 12h1M15 12h1" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/>
  <path d="M9 15.5h1M12 15.5h1" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/>
  <path d="M14.5 14.5l1.5 1.5-1.5 1.5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  static const inboxImport =
      '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <rect x="2" y="4" width="20" height="16" rx="2" stroke="currentColor" stroke-width="1.7"/>
  <path d="M2 9h20" stroke="currentColor" stroke-width="1.7" stroke-linecap="round"/>
  <path d="M12 13v4M10 15l2 2 2-2" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  static const history =
      '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M20.5 12A8.5 8.5 0 1112 3.5" stroke="currentColor" stroke-width="1.7" stroke-linecap="round"/>
  <path d="M12 3.5V7M9 5h6" stroke="currentColor" stroke-width="1.7" stroke-linecap="round"/>
  <path d="M12 8v4l3 2" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  static const logout =
      '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M9 4H5a1 1 0 00-1 1v14a1 1 0 001 1h4" stroke="currentColor" stroke-width="1.7" stroke-linecap="round"/>
  <path d="M15 16l4-4-4-4" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M9 12h10" stroke="currentColor" stroke-width="1.7" stroke-linecap="round"/>
</svg>''';

  static const appGrid =
      '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <circle cx="5" cy="5" r="1.5" fill="currentColor"/>
  <circle cx="12" cy="5" r="1.5" fill="currentColor"/>
  <circle cx="19" cy="5" r="1.5" fill="currentColor"/>
  <circle cx="5" cy="12" r="1.5" fill="currentColor"/>
  <circle cx="12" cy="12" r="1.5" fill="currentColor"/>
  <circle cx="19" cy="12" r="1.5" fill="currentColor"/>
  <circle cx="5" cy="19" r="1.5" fill="currentColor"/>
  <circle cx="12" cy="19" r="1.5" fill="currentColor"/>
  <circle cx="19" cy="19" r="1.5" fill="currentColor"/>
</svg>''';

  static const aiChat =
      '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M21 15a2 2 0 01-2 2H7l-4 4V5a2 2 0 012-2h14a2 2 0 012 2z" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
  <circle cx="8.5" cy="11" r="1" fill="currentColor"/>
  <circle cx="12" cy="11" r="1" fill="currentColor"/>
  <circle cx="15.5" cy="11" r="1" fill="currentColor"/>
</svg>''';

  static const production =
      '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <rect x="2" y="7" width="20" height="13" rx="2" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M2 10h20" stroke="currentColor" stroke-width="1.6" stroke-linecap="round"/>
  <path d="M6 4h12" stroke="currentColor" stroke-width="1.6" stroke-linecap="round"/>
  <rect x="5" y="14" width="3" height="2" rx="0.5" fill="currentColor"/>
  <rect x="10" y="14" width="3" height="2" rx="0.5" fill="currentColor"/>
  <rect x="15" y="14" width="4" height="2" rx="0.5" fill="currentColor"/>
</svg>''';
}

Widget _coloredSideMenuSvg(String svg, Color color) {
  return SvgPicture.string(
    svg,
    width: 24,
    height: 24,
    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
  );
}

class _SideMenuItem extends StatelessWidget {
  final Widget Function(Color iconColor) iconBuilder;
  final bool isSelected;
  final VoidCallback onTap;
  final String tooltip;
  final bool isLogout;

  const _SideMenuItem({
    super.key,
    required this.iconBuilder,
    required this.isSelected,
    required this.onTap,
    required this.tooltip,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    final accent = PosLayoutBreakpoints.posAccentBlue;
    final color = isLogout
        ? PosTokens.loss
        : (isSelected ? accent : PosTokens.ink3);

    final content = Center(
      child: AnimatedContainer(
        duration: PosTokens.hoverTransition,
        curve: Curves.ease,
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isSelected
              ? (isLogout ? PosTokens.lossTint : PosTokens.blueTint)
              : null,
          borderRadius: BorderRadius.circular(PosTokens.radiusSm),
        ),
        child: Center(child: iconBuilder(color)),
      ),
    );

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(PosTokens.radiusSm),
        hoverColor: isLogout
            ? PosTokens.lossTint
            : PosTokens.surface2,
        child: isSelected
            ? Row(
                children: [
                  Container(
                    width: 4,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isLogout ? Colors.red : accent,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(4),
                        bottomRight: Radius.circular(4),
                      ),
                    ),
                  ),
                  Expanded(child: content),
                ],
              )
            : content,
      ),
    );
  }
}
