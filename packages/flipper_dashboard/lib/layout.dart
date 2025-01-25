import 'package:flipper_dashboard/ProductListWidget.dart';
import 'package:flipper_dashboard/SearchFieldWidget.dart';
import 'package:flipper_dashboard/TenantWidget.dart';
import 'package:flipper_dashboard/TransactionWidget.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:flipper_dashboard/bottom_sheets/preview_sale_bottom_sheet.dart';
import 'package:flipper_dashboard/apps.dart';
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
              return buildRow(isScanningMode);
            }
          },
        );
      },
    );
  }

  Widget buildApps(CoreViewModel model) {
    return Apps(
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
      child: SideMenu(
        mode: SideMenuMode.compact,
        builder: (data) {
          return SideMenuData(
            header: SizedBox(
              child: Image.asset(
                'assets/logo.png',
                package: 'flipper_dashboard',
                width: 40,
                height: 40,
              ),
            ),
            items: [
              SideMenuItemDataTile(
                hasSelectedLine: false,
                highlightSelectedColor: Colors.black12,
                borderRadius: BorderRadius.circular(2),
                title: 'Sales',
                isSelected: ref.watch(selectedMenuItemProvider) == 0,
                icon: Icon(
                  Icons.shopping_cart,
                  color: ref.watch(selectedMenuItemProvider) == 2
                      ? Colors.white
                      : Colors.grey,
                ),
                onTap: () {
                  print('Sales menu item tapped');
                  ref.read(selectedMenuItemProvider.notifier).state = 0;
                },
              ),
              SideMenuItemDataTile(
                highlightSelectedColor: Colors.black12,
                borderRadius: BorderRadius.circular(2),
                hasSelectedLine: false,
                title: 'Inventory',
                isSelected: ref.watch(selectedMenuItemProvider) == 1,
                icon: Icon(
                  Icons.inventory,
                  color: ref.watch(selectedMenuItemProvider) == 2
                      ? Colors.white
                      : Colors.grey,
                ),
                onTap: () {
                  print('Inventory menu item tapped');
                  ref.read(selectedMenuItemProvider.notifier).state = 1;
                },
              ),
              SideMenuItemDataTile(
                highlightSelectedColor: Colors.black12,
                hasSelectedLine: false,
                borderRadius: BorderRadius.circular(2),
                title: 'Tickets',
                isSelected: ref.watch(selectedMenuItemProvider) == 2,
                icon: Icon(
                  Icons.receipt,
                  color: ref.watch(selectedMenuItemProvider) == 2
                      ? Colors.white
                      : Colors.grey,
                ),
                onTap: () {
                  print('Tickets menu item tapped');
                  ref.read(selectedMenuItemProvider.notifier).state = 2;
                },
              ),
            ],
            footer: const TenantWidget(),
          );
        },
      ),
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
            child: Text('Inventory Content'),
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

  Widget buildProductSection() {
    return Flexible(
      child: ListView(
        children: [
          SearchFieldWidget(controller: searchController),
          const ProductListWidget(),
        ],
      ),
    ).shouldSeeTheApp(ref, AppFeature.Sales);
  }

  Widget buildRow(bool isScanningMode) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSideMenu(),
            const SizedBox(width: 20),
            buildMainContent(isScanningMode),
            buildProductSection(),
          ],
        ),
      ),
    );
  }
}
