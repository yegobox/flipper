import 'package:flipper_dashboard/SearchFieldWidget.dart';
import 'package:flipper_dashboard/product_view.dart';
import 'package:flipper_dashboard/checkout.dart';
import 'package:flipper_dashboard/Ai.dart';
import 'package:flipper_dashboard/TransactionWidget.dart';
import 'package:flipper_dashboard/bottom_sheets/preview_sale_bottom_sheet.dart';
import 'package:flipper_dashboard/providers/navigation_providers.dart';
import 'package:flipper_models/providers/scan_mode_provider.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_models/helperModels/extensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Import the provider from layout.dart

class InventoryApp extends HookConsumerWidget {
  final TextEditingController searchController;

  const InventoryApp({
    Key? key,
    required this.searchController,
  }) : super(key: key);

  Widget buildProductSection(WidgetRef ref) {
    return Flexible(
      child: Column(
        children: [
          // Search field stays fixed at the top
          SearchFieldWidget(controller: searchController),
          // ProductView takes remaining space and scrolls independently
          Expanded(
            child: ProductView.normalMode(),
          ),
        ],
      ),
    ).shouldSeeTheApp(ref, AppFeature.Sales);
  }

  Widget buildMainContent(bool isScanningMode, WidgetRef ref) {
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

  Widget buildRow(bool isScanningMode, WidgetRef ref, BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildMainContent(isScanningMode, ref),
          if (ref.read(selectedMenuItemProvider.notifier).state != 1)
            buildProductSection(ref),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isScanningMode = ref.watch(scanningModeProvider);
    return buildRow(isScanningMode, ref, context);
  }
}
