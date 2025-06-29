import 'package:flipper_dashboard/Ai.dart';
import 'package:flipper_dashboard/EnhancedSideMenu.dart';
import 'package:flipper_dashboard/inventory_app.dart';
import 'package:flipper_dashboard/features/inventory_dashboard/inventory_dashboard_app.dart';
import 'package:flipper_dashboard/kitchen_display.dart';
import 'package:flipper_dashboard/mobile_view.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';

enum DashboardPage {
  inventory,
  ai,
  reports,
  kitchen,
}

final selectedPageProvider =
    StateProvider<DashboardPage>((ref) => DashboardPage.inventory);

class DashboardLayout extends HookConsumerWidget {
  const DashboardLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();

    return ViewModelBuilder<CoreViewModel>.nonReactive(
      viewModelBuilder: () => CoreViewModel(),
      onViewModelReady: (model) {
        ref.read(previewingCart.notifier).state = false;
      },
      builder: (context, model, child) {
        final selectedPageWidget = _buildSelectedApp(ref, searchController);

        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return MobileView(
                isBigScreen: false,
                controller: searchController,
                model: model,
              );
            }
            return Scaffold(
              body: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (ProxyService.remoteConfig.isMultiUserEnabled())
                    const EnhancedSideMenu(),
                  Expanded(child: selectedPageWidget),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSelectedApp(
      WidgetRef ref, TextEditingController searchController) {
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
    }
  }
}
