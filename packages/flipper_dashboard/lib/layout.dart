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
  final TextEditingController searchContrroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isScanningMode = ref.watch(scanningModeProvider);
    return ViewModelBuilder<CoreViewModel>.reactive(
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

  Widget buildRow(bool isScanningMode) {
    final transaction = ref.watch(pendingTransactionProvider(
        (mode: TransactionType.sale, isExpense: false)));
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProxyService.remoteConfig.isMultiUserEnabled()
                ? Container(
                    child: SideMenu(
                      mode: SideMenuMode.compact,
                      builder: (data) {
                        return SideMenuData(
                          header: Container(
                            child: Image.asset(
                              'assets/logo.png',
                              package: 'flipper_dashboard',
                              width: 40,
                              height: 40,
                            ),
                          ),
                          items: [],
                          footer: TenantWidget(),
                        );
                      },
                    ),
                  )
                : SizedBox.shrink(),
            const SizedBox(width: 20),

            /// add the ticket UI which will only show if is left alone in tree
            /// when Ticket is visible in row then we make sure the rest of widget is not visible
            /// we can do this by making sure the rest of widget does not show if we ever found the
            /// ticket in permission list
            transaction.when(
                data: (transaction) {
                  return Expanded(
                    child: TicketsList(
                      showAppBar: false,
                      transaction: transaction,
                    ),
                  ).shouldSeeTheApp(ref, AppFeature.Tickets);
                },
                error: (error, s) => SizedBox.shrink(),
                loading: () => SizedBox.shrink()),

            Expanded(
              child: isScanningMode
                  ? buildReceiptUI().shouldSeeTheApp(ref, AppFeature.Sales)
                  : CheckOut(isBigScreen: true)
                      .shouldSeeTheApp(ref, AppFeature.Sales),
            ).shouldSeeTheApp(ref, AppFeature.Inventory),
            Flexible(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SearchField(
                      controller: searchContrroller,
                      showAddButton: true,
                      showDatePicker: ref.watch(buttonIndexProvider) == 1,
                      showIncomingButton: true,
                      showOrderButton: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ProductView.normalMode(),
                  ),
                ],
              ),
            ).shouldSeeTheApp(ref, AppFeature.Sales),
          ],
        ),
      ),
    );
  }

  Widget buildReceiptUI() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 400,
        child: PreviewSaleBottomSheet(
          reverse: false,
        ),
      ),
    );
  }
}
