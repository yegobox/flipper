import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_dashboard/profile.dart';
import 'package:flipper_routing/app.locator.dart';
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
import 'package:flutter/foundation.dart';

extension on Widget {
  Widget? showOrNull(bool isShow) => isShow ? this : null;
}

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
    return Scaffold(
      // Wrap the Row in a Scaffold
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProxyService.remoteConfig.isMultiUserEnabled() && kDebugMode
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
                          footer: FutureBuilder<Branch>(
                            future: ProxyService.local.activeBranch(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.waiting ||
                                  !snapshot.hasData) {
                                return const SizedBox.shrink();
                              }
                              final data = snapshot.data;
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 12.0),
                                    child: SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: ProfileWidget(
                                        branch: data!,
                                        sessionActive: true,
                                        size: 25,
                                        showIcon: false,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ProxyService.realm.isAdmin()
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              right: 12.0),
                                          child: SizedBox(
                                            height: 40,
                                            width: 40,
                                            child: IconButton(
                                              icon: const Icon(Icons.settings),
                                              onPressed: () {
                                                locator<RouterService>()
                                                    .navigateTo(
                                                        AdminControlRoute());
                                              },
                                              style: IconButton.styleFrom(
                                                shape: const CircleBorder(),
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .primaryColor,
                                                foregroundColor: Colors.white,
                                              ),
                                            ),
                                          ),
                                        )
                                      : SizedBox.shrink()
                                ],
                              );
                            },
                          ),
                        );
                      },
                    ),
                  )
                : SizedBox.shrink(),
            const SizedBox(width: 20),
            Expanded(
              child: isScanningMode
                  ? buildReceiptUI()
                  : CheckOut(isBigScreen: true),
            ),
            Flexible(
              child: ListView(
                // Use ListView instead of SingleChildScrollView
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
                  ), // Your ProductView widget
                ],
              ),
            ),
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
