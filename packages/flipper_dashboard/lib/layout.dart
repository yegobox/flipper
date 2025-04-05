import 'package:flipper_dashboard/Ai.dart';
import 'package:flipper_dashboard/EnhancedSideMenu.dart';
import 'package:flipper_dashboard/inventory_app.dart';
import 'package:flipper_dashboard/features/inventory_dashboard/inventory_dashboard_app.dart';
import 'package:flipper_dashboard/kitchen_display.dart';
import 'package:flipper_dashboard/mobile_view.dart';
import 'package:flipper_dashboard/providers/navigation_providers.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';

class AppLayoutDrawer extends StatefulHookConsumerWidget {
  const AppLayoutDrawer({
    Key? key,
    required this.controller,
    required this.tabSelected,
    required this.focusNode,
  }) : super(key: key);

  final TextEditingController controller;
  final int tabSelected;
  final FocusNode focusNode;

  @override
  AppLayoutDrawerState createState() => AppLayoutDrawerState();
}

class AppLayoutDrawerState extends ConsumerState<AppLayoutDrawer> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set default selected menu item
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(selectedMenuItemProvider.notifier).state = 0;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Widget buildApps(CoreViewModel model) {
    return MobileView(
      isBigScreen: false,
      controller: widget.controller,
      model: model,
    );
  }

  Widget buildSideMenu() {
    if (!ProxyService.remoteConfig.isMultiUserEnabled()) {
      return const SizedBox.shrink();
    }

    return Container(
      child: EnhancedSideMenu(),
    );
  }

  Widget _buildSelectedApp() {
    final selectedIndex = ref.watch(selectedMenuItemProvider);
    switch (selectedIndex) {
      case 0:
        return InventoryApp(
          searchController: searchController,
        );
      case 1:
        return const Ai();
      case 2:
        return const InventoryDashboardApp();
      case 3:
        return const KitchenDisplay();
      default:
        return InventoryApp(
          searchController: searchController,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CoreViewModel>.nonReactive(
      viewModelBuilder: () => CoreViewModel(),
      onViewModelReady: (model) {
        ref.read(previewingCart.notifier).state = false;
      },
      builder: (context, model, child) {
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxWidth < 600) {
              return buildApps(model);
            } else {
              return Scaffold(
                body: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildSideMenu(),
                    Expanded(child: _buildSelectedApp()),
                  ],
                ),
              );
            }
          },
        );
      },
    );
  }
}
