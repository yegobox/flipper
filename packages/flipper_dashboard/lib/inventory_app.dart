import 'package:flipper_dashboard/SearchFieldWidget.dart';
import 'package:flipper_dashboard/product_view.dart';
import 'package:flipper_models/providers/scan_mode_provider.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_models/helperModels/extensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Import the provider from layout.dart
import 'layout.dart' show selectedMenuItemProvider;

class InventoryApp extends HookConsumerWidget {
  final TextEditingController searchController;
  final Widget Function(bool) buildMainContent;

  const InventoryApp({
    Key? key,
    required this.searchController,
    required this.buildMainContent,
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

  Widget buildRow(bool isScanningMode, WidgetRef ref, BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildMainContent(isScanningMode),
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
