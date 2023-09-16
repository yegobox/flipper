import 'dart:developer';

import 'package:flipper_dashboard/profile.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/isar_models.dart' as isar;
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class SettingPage extends StatelessWidget {
  SettingPage({Key? key}) : super(key: key);
  final _routerService = locator<RouterService>();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingViewModel>.reactive(
      viewModelBuilder: () => SettingViewModel(),
      onViewModelReady: (model) async => await model.createPin(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).canvasColor,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child:
                      ProfileWidget(tenant: model.tenant!, sessionActive: true),
                ),
                SizedBox(height: 10),
                Flexible(
                  child: SettingsList(
                    backgroundColor: Theme.of(context).canvasColor,
                    sections: [
                      SettingsSection(
                        tiles: [
                          SettingsTile(
                            title: "Linked Devices",
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                FluentIcons.desktop_24_regular,
                              ),
                            ),
                            onPressed: (BuildContext context) async {
                              ITenant? tenant = await ProxyService.isar
                                  .getTenantBYUserId(
                                      userId: ProxyService.box.getUserId()!);
                              _routerService.navigateTo(
                                  DevicesRoute(pin: tenant?.userId));
                            },
                          ),
                          SettingsTile(
                            title: "Printing configuration",
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                FluentIcons.print_24_regular,
                              ),
                            ),
                            onPressed: (BuildContext context) {
                              _routerService.navigateTo(PrintingRoute());
                            },
                          ),
                          // TODO: resume backup configuration once we know it works 100%
                          // SettingsTile(
                          //   title: "BackUp configuration",
                          //   leading: CircleAvatar(
                          //     backgroundColor: Colors.white,
                          //     child: Icon(
                          //       FluentIcons.arrow_upload_20_regular,
                          //     ),
                          //   ),
                          //   onPressed: (BuildContext context) {
                          //     _routerService.navigateTo(BackUpRoute());
                          //   },
                          // ),
                          SettingsTile(
                            title: "Tax Configuration",
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                FluentIcons.calculator_24_regular,
                              ),
                            ),
                            onPressed: (BuildContext context) {
                              _routerService
                                  .navigateTo(TaxConfigurationRoute());
                            },
                          ),
                          SettingsTile(
                            title: "Add users",
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                FluentIcons.people_add_24_regular,
                              ),
                            ),
                            onPressed: (BuildContext context) async {
                              _routerService.navigateTo(TenantAddRoute());
                            },
                          ),
                          SettingsTile(
                            title: "Close a day",
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                FluentIcons.paint_brush_24_regular,
                              ),
                            ),
                            onPressed: (BuildContext context) async {
                              log('here');
                              // get active drawer
                              List<double> sumDailyTrans = await ProxyService
                                  .isar
                                  .getTransactionsAmountsSum(
                                      period: TransactionPeriod.today);
                              isar.Drawers? drawer =
                                  await ProxyService.isar.getDrawer(
                                cashierId: ProxyService.box.getBusinessId()!,
                              );
                              if (drawer != null) {
                                /// update the drawer with closing balance
                                drawer.closingBalance = sumDailyTrans[0];
                                log(drawer.closingBalance.toString(),
                                    name: 'drawerBalance');
                                ProxyService.isar.update(data: drawer);
                              }
                              _routerService.navigateTo(DrawerScreenRoute(
                                  open: "close", drawer: drawer!));
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
