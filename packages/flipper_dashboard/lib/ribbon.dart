// ignore_for_file: unused_result, unused_field

import 'dart:async';

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
import 'package:flipper_dashboard/tax_configuration.dart';
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
      spacing: 4,
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
          offset: const Offset(0, 40),
          padding: EdgeInsets.zero,
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
            const PopupMenuItem(
              value: 'locations',
              child: Row(
                children: [
                  Icon(Icons.maps_home_work_outlined),
                  SizedBox(width: 12),
                  Text('Locations'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'items',
              child: Row(
                children: [
                  Icon(Icons.inventory_2_outlined),
                  SizedBox(width: 12),
                  Text('Items'),
                ],
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
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                  maxWidth: double.infinity,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 800,
                      child: BranchPerformance(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ];
      },
      modalTypeBuilder: (context) {
        return WoltModalType.dialog();
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
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) => Dialog(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: SizedBox(
                    width: double.infinity,
                    child: BranchPerformance(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTaxDialog(BuildContext context) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
            minWidth: 400,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SystemConfig(showheader: false),
            ),
          ),
        ),
      ),
    );
  }
}
