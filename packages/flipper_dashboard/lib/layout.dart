import 'package:flipper_dashboard/Ai.dart';
import 'package:flipper_dashboard/EnhancedSideMenu.dart';
import 'package:flipper_dashboard/inventory_app.dart';
import 'package:flipper_dashboard/features/inventory_dashboard/inventory_dashboard_app.dart';
import 'package:flipper_dashboard/kitchen_display.dart';
import 'package:flipper_dashboard/orders_app.dart';
import 'package:flipper_dashboard/mobile_view.dart';
import 'package:flipper_dashboard/stock_recount_list_screen.dart';
import 'package:flipper_dashboard/delegation_list_screen.dart';
import 'package:flipper_dashboard/features/incoming_orders/screens/incoming_orders_screen.dart';
import 'package:flipper_dashboard/features/production_output/production_output_app.dart';
import 'package:flipper_dashboard/shift_history_content.dart';
import 'package:flipper_dashboard/dashboard_shell.dart';
import 'package:flipper_dashboard/hooks/use_access_permissions_realtime.dart';
import 'package:flipper_dashboard/pos_layout_breakpoints.dart';
import 'package:flipper_dashboard/widgets/unified_top_bar.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';

class DashboardLayout extends HookConsumerWidget {
  const DashboardLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    useAccessPermissionsRealtimeSync(ref);

    return ViewModelBuilder<CoreViewModel>.nonReactive(
      viewModelBuilder: () => CoreViewModel(),
      onViewModelReady: (model) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(previewingCart.notifier).state = false;
          final defaultApp = ProxyService.box.getDefaultApp();
          if (defaultApp != null) {
            DashboardPage page;
            switch (defaultApp) {
              case 'POS':
              case 'Inventory':
                page = DashboardPage.inventory;
                break;
              case 'Reports':
                page = DashboardPage.reports;
                break;
              case 'Orders':
                page = DashboardPage.orders;
                break;
              default:
                page = DashboardPage.inventory;
                break;
            }
            ref.read(selectedPageProvider.notifier).state = page;
          }
        });
      },
      builder: (context, model, child) {
        final selectedPageWidget = _buildSelectedApp(ref, searchController);

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            // Silently prevent back navigation.
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Handle the case when constraints are not yet available
              if (constraints.maxWidth == 0 || constraints.maxHeight == 0) {
                return const SizedBox.shrink();
              }
              if (constraints.maxWidth <
                  PosLayoutBreakpoints.mobileLayoutMaxWidth) {
                return MobileView(
                  isBigScreen: false,
                  controller: searchController,
                  model: model,
                );
              }
              // Desktop: header row spans logo column + top bar so the logo aligns
              // with FLIPPER; body row is sidebar + content.
              return Column(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          offset: const Offset(0, 2),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: SizedBox(
                      height: PosLayoutBreakpoints.desktopTopBarHeight,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: PosLayoutBreakpoints.sideMenuWidth,
                            child: Center(
                              child: Image.asset(
                                'assets/logo.png',
                                package: 'flipper_dashboard',
                                width: 32,
                                height: 32,
                              ),
                            ),
                          ),
                          Expanded(
                            child: UnifiedTopBar(
                              searchController: searchController,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          width: PosLayoutBreakpoints.sideMenuWidth,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                right: BorderSide(
                                  color: Color(0xFFE5E7EB),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: const EnhancedSideMenu(),
                          ),
                        ),
                        Expanded(child: selectedPageWidget),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSelectedApp(
    WidgetRef ref,
    TextEditingController searchController,
  ) {
    final selectedPage = ref.watch(selectedPageProvider);
    switch (selectedPage) {
      case DashboardPage.inventory:
        return InventoryApp(searchController: searchController);
      case DashboardPage.ai:
        return const Ai();
      case DashboardPage.reports:
        return const InventoryDashboardApp();
      case DashboardPage.kitchen:
        return const KitchenDisplay();
      case DashboardPage.orders:
        return const OrdersApp();
      case DashboardPage.stockRecount:
        return const StockRecountListScreen();
      case DashboardPage.delegations:
        return const DelegationListScreen();
      case DashboardPage.incomingOrders:
        return const IncomingOrdersScreen();
      case DashboardPage.shiftHistory:
        return const ShiftHistoryContent();
      case DashboardPage.productionOutput:
        return const ProductionOutputApp();
    }
  }
}
