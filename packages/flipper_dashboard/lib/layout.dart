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
import 'package:flipper_dashboard/widgets/unified_top_bar.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';

enum DashboardPage {
  inventory,
  ai,
  reports,
  kitchen,
  orders,
  stockRecount,
  delegations,
  incomingOrders,
  shiftHistory,
  productionOutput,
}

final selectedPageProvider = StateProvider<DashboardPage>(
  (ref) => DashboardPage.inventory,
);

class DashboardLayout extends HookConsumerWidget {
  const DashboardLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();

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
              if (constraints.maxWidth < 600) {
                return MobileView(
                  isBigScreen: false,
                  controller: searchController,
                  model: model,
                );
              }
              // Desktop layout with unified top bar
              return Column(
                children: [
                  // SAP-style top bar with search, ribbon, and user info
                  UnifiedTopBar(searchController: searchController),
                  // Main content area
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (ProxyService.remoteConfig.isMultiUserEnabled())
                          const EnhancedSideMenu(),
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
