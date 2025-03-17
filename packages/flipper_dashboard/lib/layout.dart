import 'package:flipper_dashboard/Ai.dart';
import 'package:flipper_dashboard/EnhancedSideMenu.dart';
import 'package:flipper_dashboard/TransactionWidget.dart';
import 'package:flipper_dashboard/mobile_view.dart';
import 'package:flipper_dashboard/inventory_app.dart';
import 'package:flipper_models/providers/scan_mode_provider.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_dashboard/bottom_sheets/preview_sale_bottom_sheet.dart';
import 'package:flipper_dashboard/checkout.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';

// State provider for the selected menu item
final selectedMenuItemProvider = StateProvider<int>((ref) => 0);

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
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isScanningMode = ref.watch(scanningModeProvider);

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
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildSideMenu(),
                      const SizedBox(width: 20),
                      InventoryApp(
                        searchController: searchController,
                        buildMainContent: (isScanningMode) =>
                            buildMainContent(isScanningMode),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }

  Widget buildApps(CoreViewModel model) {
    return MobileView(
      isBigScreen: false,
      controller: widget.controller,
      model: model,
    );
  }

  Widget buildReceiptUI() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 400,
        child: PreviewSaleBottomSheet(
          reverse: false,
        ),
      ),
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

  Widget buildMainContent(bool isScanningMode) {
    final selectedMenuItem = ref.watch(selectedMenuItemProvider);

    switch (selectedMenuItem) {
      case 0: // Sales
        return Expanded(
          child: isScanningMode
              ? buildReceiptUI().shouldSeeTheApp(ref, AppFeature.Sales)
              : CheckOut(isBigScreen: true)
                  .shouldSeeTheApp(ref, AppFeature.Sales),
        ).shouldSeeTheApp(ref, AppFeature.Inventory);
      case 1: // Inventory
        return Expanded(
          child: Center(
            child: Ai(),
          ),
        );
      case 2: // Tickets
        return const TransactionWidget();

      default:
        return Expanded(
          child: Center(
            child: Text('Default Content'),
          ),
        );
    }
  }
}
