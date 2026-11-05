import 'package:flipper_dashboard/ActiveBranch.dart';
import 'package:flipper_dashboard/BranchSelectionMixin.dart';
import 'package:flipper_dashboard/app_choice_dialog.dart';
import 'package:flipper_dashboard/features/service_mode_access_gate.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_models/providers/branch_business_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart'
    show branchSelectionProvider, businessesProvider, buttonIndexProvider;
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
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/mfa_setup_view.dart';
import 'package:flipper_dashboard/widgets/dashboard_quick_access_svgs.dart';
import 'package:flipper_dashboard/widgets/admin_dashboard_svgs.dart';
import 'package:flipper_dashboard/widgets/pos_side_rail.dart';
import 'package:flipper_dashboard/features/stock_value/stock_value_report_desktop_screen.dart';
import 'package:flipper_dashboard/features/transaction_reports/transaction_reports_desktop_screen.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/providers/stock_value_report_provider.dart';

class EnhancedSideMenu extends ConsumerStatefulWidget {
  const EnhancedSideMenu({super.key});

  @override
  ConsumerState<EnhancedSideMenu> createState() => _EnhancedSideMenuState();
}

class _EnhancedSideMenuState extends ConsumerState<EnhancedSideMenu>
    with BranchSelectionMixin {
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

    final branchName = ref
        .read(activeBranchProvider)
        .maybeWhen(data: (b) => b.name, orElse: () => null);
    final action = await EndOfShiftDialog.show(context, branchName: branchName);
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
      setDefaultBranch: _setDefaultBranch,
      handleBranchSelection: handleBranchSelection,
      onLogout: _signOutCurrentAgent,
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

    // Groups render with a hairline divider between non-empty groups:
    //   sell · operations · reports · (bottom) end shift.
    final sellGroup = <Widget>[
      PosRailItem(
        iconBuilder: (c) => posRailSvg(PosRailSvgs.appGrid, c),
        isSelected: selectedItem == 0,
        onTap: () {
          ref.read(selectedMenuItemProvider.notifier).state = 0;
          // Overview inherits the retired Home tab's other job: resetting the
          // legacy ribbon index. Nothing else sets it back to 0, and
          // [SearchFieldWidget] keeps its date picker open while it reads 1.
          ref.read(buttonIndexProvider.notifier).setIndex(0);
          ref.read(selectedPageProvider.notifier).state =
              DashboardPage.inventory;
        },
        tooltip: context.flipperL10n.sideMenuOverview,
      ),
      if (!ref.watch(isLocalModeProvider) &&
          signedInUserMayOpen(ref, AppFeature.Flo))
        PosRailItem(
          iconBuilder: (c) => posRailSvg(PosRailSvgs.aiChat, c),
          isSelected: selectedItem == 1,
          onTap: () {
            ref.read(selectedMenuItemProvider.notifier).state = 1;
            ref.read(selectedPageProvider.notifier).state = DashboardPage.ai;
          },
          tooltip: context.flipperL10n.menuChat,
        ),
    ];

    final operationsGroup = <Widget>[
      if (showLeads)
        PosRailItem(
          iconBuilder: (c) => SvgPicture.string(
            AdminDashboardSvgs.leadsUsersMultiple,
            width: PosTokens.iconMd,
            height: PosTokens.iconMd,
            colorFilter: ColorFilter.mode(c, BlendMode.srcIn),
          ),
          isSelected: selectedItem == 10,
          onTap: () {
            ref.read(selectedMenuItemProvider.notifier).state = 10;
            ref.read(selectedPageProvider.notifier).state = DashboardPage.leads;
          },
          tooltip: context.flipperL10n.leads,
        ),
      if (isDesktop)
        PosRailItem(
          iconBuilder: (c) =>
              posRailSvg(DashboardQuickAccessSvgs.drawerAuthShieldIcon(), c),
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
          tooltip: context.flipperL10n.sideMenuAuthenticator,
        ),
      if (showItems)
        PosRailItem(
          iconBuilder: (c) => posRailSvg(PosRailSvgs.inventory, c),
          isSelected: selectedItem == 2,
          onTap: () {
            ref.read(selectedMenuItemProvider.notifier).state = 2;
            ref.read(selectedPageProvider.notifier).state =
                DashboardPage.reports;
          },
          tooltip: context.flipperL10n.items,
        ),
      if (showKds)
        PosRailItem(
          iconBuilder: (c) => Icon(Icons.restaurant_menu, color: c),
          isSelected: selectedItem == 3,
          onTap: () {
            ref.read(selectedMenuItemProvider.notifier).state = 3;
            ref.read(selectedPageProvider.notifier).state =
                DashboardPage.kitchen;
          },
          tooltip: context.flipperL10n.sideMenuKitchenDisplay,
        ),
      if (showStockRecount)
        PosRailItem(
          iconBuilder: (c) => posRailSvg(PosRailSvgs.stockRecount, c),
          isSelected: selectedItem == 6,
          onTap: () {
            ref.read(selectedMenuItemProvider.notifier).state = 6;
            ref.read(selectedPageProvider.notifier).state =
                DashboardPage.stockRecount;
          },
          tooltip: context.flipperL10n.sideMenuStockRecount,
        ),
      if (showDelegations)
        PosRailItem(
          iconBuilder: (c) => Icon(Icons.print_outlined, color: c),
          isSelected: selectedItem == 7,
          onTap: () {
            ref.read(selectedMenuItemProvider.notifier).state = 7;
            ref.read(selectedPageProvider.notifier).state =
                DashboardPage.delegations;
          },
          tooltip: context.flipperL10n.sideMenuDelegations,
        ),
      if (showIncomingOrders)
        PosRailItem(
          iconBuilder: (c) => posRailSvg(PosRailSvgs.inboxImport, c),
          isSelected: selectedItem == 8,
          onTap: () {
            ref.read(selectedMenuItemProvider.notifier).state = 8;
            ref.read(selectedPageProvider.notifier).state =
                DashboardPage.incomingOrders;
          },
          tooltip: context.flipperL10n.sideMenuIncomingOrders,
        ),
      if (showIncomingOrders)
        PosRailItem(
          iconBuilder: (c) => Icon(Icons.swap_horiz, color: c),
          isSelected: selectedItem == 14,
          onTap: () {
            ref.read(selectedMenuItemProvider.notifier).state = 14;
            ref.read(selectedPageProvider.notifier).state =
                DashboardPage.transfersReport;
          },
          tooltip: context.flipperL10n.sideMenuTransfersReport,
        ),
      if (showProduction)
        PosRailItem(
          iconBuilder: (c) => posRailSvg(PosRailSvgs.production, c),
          isSelected: selectedItem == 9,
          onTap: () {
            ref.read(selectedMenuItemProvider.notifier).state = 9;
            ref.read(selectedPageProvider.notifier).state =
                DashboardPage.productionOutput;
          },
          tooltip: context.flipperL10n.sideMenuProductionOutput,
        ),
    ];

    final reportsGroup = <Widget>[
      if (showDailyReportFiles)
        PosRailItem(
          iconBuilder: (c) => DashboardQuickAccessSvgs.assetIcon(
            DashboardQuickAccessSvgs.chart,
            size: PosTokens.iconMd,
            color: c,
          ),
          isSelected: selectedItem == 11,
          onTap: () {
            ref.read(selectedMenuItemProvider.notifier).state = 11;
            ref.read(selectedPageProvider.notifier).state =
                DashboardPage.dailyReportFiles;
          },
          tooltip: context.flipperL10n.dailyReports,
        ),
      PosRailItem(
        key: const Key('transactions_desktop'),
        iconBuilder: (c) => Icon(Icons.receipt_long_outlined, color: c),
        isSelected: false,
        onTap: () => _openTransactionsReport(),
        tooltip: context.flipperL10n.sideMenuTransactions,
      ),
      PosRailItem(
        key: const Key('analytics_desktop'),
        iconBuilder: (c) => Icon(Icons.insights_outlined, color: c),
        isSelected: false,
        onTap: () => _openAnalyticsReport(),
        tooltip: context.flipperL10n.sideMenuAnalytics,
      ),
      if (showShiftHistory)
        PosRailItem(
          iconBuilder: (c) => posRailSvg(PosRailSvgs.history, c),
          isSelected: selectedItem == 5,
          onTap: () {
            ref.read(selectedMenuItemProvider.notifier).state = 5;
            ref.read(selectedPageProvider.notifier).state =
                DashboardPage.shiftHistory;
          },
          tooltip: context.flipperL10n.sideMenuShiftHistory,
        ),
      if (showAgentCommission)
        PosRailItem(
          iconBuilder: (c) => Icon(Icons.support_agent, color: c),
          isSelected: selectedItem == 12,
          onTap: () {
            ref.read(selectedMenuItemProvider.notifier).state = 12;
            ref.read(selectedPageProvider.notifier).state =
                DashboardPage.agentCommission;
          },
          tooltip: context.flipperL10n.sideMenuAgentCommission,
        ),
    ];

    final endShiftItem = PosRailItem(
      key: const Key('eod_desktop'),
      iconBuilder: (c) => posRailSvg(PosRailSvgs.logout, c),
      isSelected: selectedItem == 4,
      onTap: () => _openEndOfShiftMenu(),
      tooltip: context.flipperL10n.sideMenuEndShift,
      isLogout: true,
    );

    // Width, border, and header logo live in [DashboardLayout] so the logo shares
    // one row with [UnifiedTopBar] / FLIPPER.
    return PosRailColumn(
      groups: [sellGroup, operationsGroup, reportsGroup],
      bottom: [
        endShiftItem,
        PosRailItem(
          iconBuilder: (c) => posRailSvg(PosRailSvgs.appGrid, c),
          isSelected: false,
          onTap: () {
            showAppChoiceDialog(
              dialogService: _dialogService,
              variant: DialogType.appChoice,
              title: context.flipperL10n.chooseYourDefaultApp,
            );
          },
          tooltip: context.flipperL10n.chooseDefaultApp,
        ),
      ],
      footer: const Padding(
        padding: EdgeInsets.fromLTRB(0, 6, 0, 12),
        child: ActiveBranch(),
      ),
    );
  }

  /// Transactions report — moved here from the top-bar ribbon; same admin PIN
  /// gate, same legacy ribbon index (1) and the same full-screen route.
  Future<void> _openTransactionsReport() async {
    final ok = await _verifyAdminPinIfRequired(context);
    if (!ok || !mounted) return;
    ref.read(buttonIndexProvider.notifier).setIndex(1);
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => const TransactionReportsDesktopScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  /// Stock-value analytics — moved here from the top-bar ribbon; legacy
  /// ribbon index 3.
  Future<void> _openAnalyticsReport() async {
    final ok = await _verifyAdminPinIfRequired(context);
    if (!ok || !mounted) return;
    ref.read(buttonIndexProvider.notifier).setIndex(3);
    ref.invalidate(stockValueReportProvider);
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => const StockValueReportDesktopScreen(),
        fullscreenDialog: true,
      ),
    );
  }
}
