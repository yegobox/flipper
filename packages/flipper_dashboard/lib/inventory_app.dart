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
          SearchFieldWidget(controller: searchController),
          Expanded(
            child: ProductView.normalMode(),
          ),
        ],
      ),
    ).shouldSeeTheApp(ref, featureName: AppFeature.Sales);
  }

  Widget buildMainContent(bool isScanningMode, WidgetRef ref) {
    final selectedMenuItem = ref.watch(selectedMenuItemProvider);

    switch (selectedMenuItem) {
      case 0: // Sales
        return isScanningMode
            ? buildReceiptUI()
                .shouldSeeTheApp(ref, featureName: AppFeature.Sales)
            : CheckOut(isBigScreen: true)
                .shouldSeeTheApp(ref, featureName: AppFeature.Sales)
                .shouldSeeTheApp(ref, featureName: AppFeature.Inventory);
      case 1: // Inventory
        return Center(
          child: Ai(),
        );
      case 2: // Tickets
        return const TransactionWidget();
      default:
        return isScanningMode
            ? buildReceiptUI()
                .shouldSeeTheApp(ref, featureName: AppFeature.Sales)
            : CheckOut(isBigScreen: true)
                .shouldSeeTheApp(ref, featureName: AppFeature.Sales)
                .shouldSeeTheApp(ref, featureName: AppFeature.Inventory);
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isScanningMode = ref.watch(scanningModeProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: buildMainContent(isScanningMode, ref),
        ),
        if (ref.read(selectedMenuItemProvider.notifier).state != 1)
          buildProductSection(ref),
      ],
    );
  }
}
