import 'package:flipper_dashboard/TenantWidget.dart';
import 'package:flipper_dashboard/tickets.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:flipper_dashboard/bottom_sheets/preview_sale_bottom_sheet.dart';
import 'package:flipper_dashboard/product_view.dart';
import 'package:flipper_dashboard/apps.dart';
import 'package:flipper_dashboard/checkout.dart';
import 'package:flipper_dashboard/search_field.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';

// Separate widget for search field to prevent unnecessary rebuilds
class SearchFieldWidget extends ConsumerWidget {
  const SearchFieldWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showDatePicker = ref.watch(buttonIndexProvider) == 1;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: SearchField(
        controller: controller,
        showAddButton: true,
        showDatePicker: showDatePicker,
        showIncomingButton: true,
        showOrderButton: true,
      ),
    );
  }
}

// Separate widget for product list to prevent unnecessary rebuilds
class ProductListWidget extends StatelessWidget {
  const ProductListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: ProductView.normalMode(),
    );
  }
}

// Separate widget for transaction section
class TransactionWidget extends ConsumerWidget {
  const TransactionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(
      pendingTransactionProvider((mode: TransactionType.sale, isExpense: false))
          .select((value) => value.when(
                data: (transaction) {
                  return Expanded(
                    child: TicketsList(
                      showAppBar: false,
                      transaction: transaction,
                    ),
                  ).shouldSeeTheApp(ref, AppFeature.Tickets);
                },
                error: (_, __) => const SizedBox.shrink(),
                loading: () => const SizedBox.shrink(),
              )),
    );
  }
}

// Main AppLayoutDrawer widget
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

  // Cache the row widget
  Widget? _cachedRow;
  bool? _previousScanningMode;

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
              // Only rebuild row if scanning mode changes
              if (_cachedRow == null ||
                  _previousScanningMode != isScanningMode) {
                _previousScanningMode = isScanningMode;
                _cachedRow = buildRow(isScanningMode);
              }
              return _cachedRow!;
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
            items: const [],
            footer: const TenantWidget(),
          );
        },
      ),
    );
  }

  Widget buildMainContent(bool isScanningMode) {
    return Expanded(
      child: isScanningMode
          ? buildReceiptUI().shouldSeeTheApp(ref, AppFeature.Sales)
          : CheckOut(isBigScreen: true).shouldSeeTheApp(ref, AppFeature.Sales),
    ).shouldSeeTheApp(ref, AppFeature.Inventory);
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
            const TransactionWidget(),
            buildMainContent(isScanningMode),
            buildProductSection(),
          ],
        ),
      ),
    );
  }
}
