// ignore_for_file: unused_result, unused_field

import 'dart:async';
import 'dart:math' as math;

import 'package:badges/badges.dart' as badges;
import 'package:flipper_dashboard/BranchPerformance.dart';
import 'package:flipper_dashboard/dashboard_shell.dart';
import 'package:flipper_dashboard/umusada_helper.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/widgets/pos_handoff_icon.dart';
import 'package:flipper_dashboard/widgets/pos_top_bar_widgets.dart';
import 'package:flipper_dashboard/providers/app_mode_provider.dart';
import 'package:flipper_dashboard/features/stock_value/stock_value_report_desktop_screen.dart';
import 'package:flipper_models/providers/orders_provider.dart';
import 'package:flipper_models/providers/scan_mode_provider.dart';
import 'package:flipper_models/providers/stock_value_report_provider.dart';
import 'package:flipper_dashboard/features/config/widgets/system_config_modal.dart';
import 'package:flipper_dashboard/features/transaction_reports/transaction_reports_desktop_screen.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart'
    show buttonIndexProvider, selectedBranchProvider;
import 'package:flipper_routing/app.locator.dart' show locator;
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.dialogs.dart';
import 'package:flipper_services/DeviceType.dart';
import 'package:flipper_services/Miscellaneous.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/dialogs/AdminPinDialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class IconRow extends StatefulHookConsumerWidget {
  const IconRow({super.key});

  @override
  ConsumerState<IconRow> createState() => IconRowState();
}

class IconRowState extends ConsumerState<IconRow> with CoreMiscellaneous {
  /// Selection for main ribbon tabs: Home, Transactions, Analytics.
  final List<bool> _selectedMain = [true, false, false];

  String _getDeviceType(BuildContext context) {
    return DeviceType.getDeviceType(context);
  }

  int _legacyButtonIndexForUi(int uiIndex) {
    if (uiIndex < 0 || uiIndex > 2) return 0;
    // Analytics was legacy index 3 before EOD was removed from the ribbon.
    return uiIndex == 2 ? 3 : uiIndex;
  }

  void _onMainTabPressed(int uiIndex) {
    unawaited(_handleMainTabPressed(uiIndex));
  }

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

  Future<void> _handleMainTabPressed(int uiIndex) async {
    if (uiIndex != 0) {
      final ok = await _verifyAdminPinIfRequired(context);
      if (!ok || !mounted) return;
    }
    ref
        .read(buttonIndexProvider.notifier)
        .setIndex(_legacyButtonIndexForUi(uiIndex));
    setState(() {
      for (var i = 0; i < 3; i++) {
        _selectedMain[i] = i == uiIndex;
      }
    });
    _runNavigationForUi(uiIndex);
  }

  void _openSalesUmusada() {
    UmusadaHelper.handleOrderingFlow(context, () {
      try {
        ProxyService.box.writeBool(key: 'isOrdering', value: true);
        locator<RouterService>().navigateTo(OrdersRoute());
      } catch (e) {
        debugPrint('$e');
      }
    });
  }

  Widget _buildSalesUmusadaButton() {
    final stringValue = ref.watch(searchStringProvider);
    final orders = ref.watch(
      stockRequestsProvider(
        status: RequestStatus.pending,
        search: stringValue.isNotEmpty ? stringValue : null,
      ),
    );

    Widget tool({required int count}) {
      final button = PosTopToolButton(
        key: const Key('ribbon_umusada_sales'),
        iconName: 'cart',
        tooltip: 'Sales — Join Umusada',
        onPressed: _openSalesUmusada,
      );
      if (count <= 0) return button;
      return badges.Badge(
        showBadge: true,
        position: badges.BadgePosition.topEnd(top: 4, end: 4),
        badgeContent: Text(
          count.toString(),
          style: const TextStyle(color: Colors.white, fontSize: 9),
        ),
        child: button,
      );
    }

    return orders.when(
      data: (list) => tool(count: list.length),
      loading: () => tool(count: 0),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  void _runNavigationForUi(int uiIndex) {
    switch (uiIndex) {
      case 0:
        break;
      case 1:
        _showReport(context);
        break;
      case 2:
        ref.invalidate(stockValueReportProvider);
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const StockValueReportDesktopScreen(),
            fullscreenDialog: true,
          ),
        );
        break;
    }
  }

  Widget _buildMainTab(
    BuildContext context, {
    required String iconName,
    required String label,
    required int uiIndex,
    required Key key,
    VoidCallback? onDoubleTap,
  }) {
    return KeyedSubtree(
      key: key,
      child: PosTopNavItem(
        iconName: iconName,
        label: label,
        isSelected: _selectedMain[uiIndex],
        onTap: () => _onMainTabPressed(uiIndex),
        onDoubleTap: onDoubleTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceType = _getDeviceType(context);
    final appMode = ref.watch(appModeProvider);
    final showImportPurchase =
        deviceType != 'Phone' && deviceType != 'Phablet' && appMode;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 2,
      children: [
        _buildMainTab(
          context,
          iconName: 'home',
          label: 'Home',
          uiIndex: 0,
          key: const Key('home_desktop'),
          onDoubleTap: () => _showTaxDialog(context),
        ),
        _buildMainTab(
          context,
          iconName: 'refresh',
          label: 'Transactions',
          uiIndex: 1,
          key: const Key('transactions_desktop'),
        ),
        _buildMainTab(
          context,
          iconName: 'chart',
          label: 'Analytics',
          uiIndex: 2,
          key: const Key('analytics_desktop'),
        ),
        _buildSalesUmusadaButton(),
        if (showImportPurchase)
          Tooltip(
            message: 'Import & Purchase',
            child: PosTopToolButton(
              key: const Key('import_purchase_ribbon'),
              iconName: 'arrow-up-right',
              iconSize: 18,
              tooltip: 'Import & Purchase',
              onPressed: () => unawaited(_handleImportPurchaseTap(context)),
            ),
          ),
        PopupMenuButton<String>(
          tooltip: 'More',
          offset: const Offset(0, 44),
          elevation: 10,
          shadowColor: const Color(0x33103240),
          color: PosTokens.surface,
          surfaceTintColor: Colors.transparent,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: PosTokens.line),
          ),
          constraints: const BoxConstraints(minWidth: 220, maxWidth: 280),
          child: SizedBox(
            width: 38,
            height: 38,
            child: Center(
              child: PosHandoffIcons.svg(
                'more',
                size: 18,
                color: PosTokens.ink2,
              ),
            ),
          ),
          onSelected: (value) {
            unawaited(_handleMoreMenuSelection(context, value));
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'locations',
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: _MoreMenuRow(
                icon: Icons.storefront_outlined,
                label: 'Locations',
                caption: 'Inventory by branch',
              ),
            ),
            PopupMenuItem(
              value: 'items',
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: _MoreMenuRow(
                icon: Icons.inventory_2_outlined,
                label: 'Items',
                caption: 'Browse and manage catalog',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _handleImportPurchaseTap(BuildContext context) async {
    final ok = await _verifyAdminPinIfRequired(context);
    if (!ok || !mounted) return;
    ref.read(selectedPageProvider.notifier).state = DashboardPage.purchases;
  }

  Future<void> _handleMoreMenuSelection(
    BuildContext context,
    String value,
  ) async {
    final ok = await _verifyAdminPinIfRequired(context);
    if (!ok || !mounted) return;
    if (value == 'locations') {
      _onMoreMenuLocations(context);
    } else if (value == 'items') {
      _onMoreMenuItems();
    }
  }

  void _onMoreMenuLocations(BuildContext context) {
    ref.read(buttonIndexProvider.notifier).setIndex(4);
    final deviceType = _getDeviceType(context);
    if (deviceType == 'Phone' || deviceType == 'Phablet') {
      ref.read(selectedBranchProvider.notifier).state = null;
      _showBranchPerformanceMobile(context);
    } else {
      _showBranchPerformance(context);
    }
  }

  void _onMoreMenuItems() {
    ref.read(buttonIndexProvider.notifier).setIndex(5);
    final dialogService = locator<DialogService>();
    dialogService.showCustomDialog(variant: DialogType.items);
  }

  void _showBranchPerformanceMobile(BuildContext context) {
    WoltModalSheet.show<void>(
      context: context,
      pageListBuilder: (BuildContext _) {
        return [
          WoltModalSheetPage(
            hasSabGradient: false,
            resizeToAvoidBottomInset: true,
            enableDrag: true,
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.9,
              child: const BranchPerformance(),
            ),
          ),
        ];
      },
      modalTypeBuilder: (context) {
        return WoltModalType.bottomSheet();
      },
      onModalDismissedWithBarrierTap: () {
        Navigator.of(context).pop();
      },
      barrierDismissible: true,
    );
  }

  void _showReport(BuildContext context) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => const TransactionReportsDesktopScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  void _showBranchPerformance(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final width = math.min(1180.0, size.width - 64);
    final height = math.min(820.0, size.height - 48);
    showDialog(
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        // Tight size so BranchPerformance's Expanded + scroll layout never
        // sees an unbounded height (which broke the KPI grid / MouseTracker).
        child: SizedBox(
          width: width,
          height: height,
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            clipBehavior: Clip.antiAlias,
            child: const BranchPerformance(),
          ),
        ),
      ),
    );
  }

  void _showTaxDialog(BuildContext context) {
    showSystemConfigModal(context);
  }
}

class _MoreMenuRow extends StatelessWidget {
  const _MoreMenuRow({
    required this.icon,
    required this.label,
    required this.caption,
  });

  final IconData icon;
  final String label;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: PosTokens.blueTint,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, size: 18, color: PosTokens.blue),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: PosTokens.ink1,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                caption,
                style: GoogleFonts.outfit(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: PosTokens.ink3,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
