import 'dart:developer';

import 'package:flipper_dashboard/profile.dart';
import 'package:flipper_dashboard/tax_configuration.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:flipper_models/isar_models.dart' as isar;
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';

Widget SettingLayout(
    {required SettingViewModel model, required BuildContext context}) {
  final _routerService = locator<RouterService>();
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: ProfileWidget(branch: model.branch!, sessionActive: true),
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
                    Tenant? tenant = await ProxyService.realm.getTenantBYUserId(
                        userId: ProxyService.box.getUserId()!);
                    _routerService
                        .navigateTo(DevicesRoute(pin: tenant?.userId));
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
                SettingsTile(
                  title: "Security",
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      FluentIcons.lock_closed_32_regular,
                    ),
                  ),
                  onPressed: (BuildContext context) async {
                    _routerService.navigateTo(SecurityRoute());
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
                    // _routerService.navigateTo(TaxConfigurationRoute());
                    showModalBottomSheet(
                      isScrollControlled: false,
                      backgroundColor: Colors.white,
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(10.0)),
                      ),
                      useRootNavigator: true,
                      builder: (BuildContext context) {
                        return TaxConfiguration();
                      },
                    );
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
                    final data = await ProxyService.realm
                        .getTransactionsAmountsSum(
                            period: TransactionPeriod.today);
                    Drawers? drawer = await ProxyService.realm.getDrawer(
                      cashierId: ProxyService.box.getBusinessId()!,
                    );
                    if (drawer != null) {
                      /// update the drawer with closing balance
                      drawer.closingBalance = data.income;
                      log(drawer.closingBalance.toString(),
                          name: 'drawerBalance');
                      ProxyService.realm.update(data: drawer);
                    }
                    _routerService.navigateTo(
                        DrawerScreenRoute(open: "close", drawer: drawer!));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}
