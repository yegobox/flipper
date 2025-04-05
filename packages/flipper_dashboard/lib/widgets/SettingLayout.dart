import 'package:flipper_services/DeviceType.dart';
import 'package:flipper_dashboard/profile.dart';
import 'package:flipper_dashboard/tax_configuration.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';

Widget SettingLayout(
    {required SettingViewModel model, required BuildContext context}) {
  final _routerService = locator<RouterService>();

  String _getDeviceType(BuildContext context) {
    return DeviceType.getDeviceType(context);
  }

  final deviceType = _getDeviceType(context);

  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: ProfileWidget(branch: model.branch!, sessionActive: true),
      ),
      SizedBox(height: 10),
      Flexible(
        child: SettingsList(
          sections: [
            SettingsSection(
              tiles: [
                if (deviceType == 'Phone') // Show other settings only on phones
                  ...[
                  SettingsTile(
                    title: Text("Linked Devices"),
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        FluentIcons.desktop_24_regular,
                      ),
                    ),
                    onPressed: (BuildContext context) async {
                      Tenant? tenant = await ProxyService.strategy.getTenant(
                        userId: ProxyService.box.getUserId()!,
                      );
                      _routerService
                          .navigateTo(DevicesRoute(pin: tenant?.userId));
                    },
                  ),
                  SettingsTile(
                    title: Text("Printing configuration"),
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
                    title: Text("Security"),
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
                  SettingsTile(
                    title: Text("Add users"),
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        FluentIcons.people_add_24_regular,
                      ),
                    ),
                    onPressed: (BuildContext context) async {
                      _routerService.navigateTo(TenantManagementRoute());
                    },
                  ),
                  SettingsTile(
                    title: Text("Close a day"),
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        FluentIcons.paint_brush_24_regular,
                      ),
                    ),
                    onPressed: (BuildContext context) async {
                      final data = await ProxyService.strategy
                          .getTransactionsAmountsSum(
                              period: TransactionPeriod.today);
                      Drawers? drawer = await ProxyService.strategy.getDrawer(
                        cashierId: ProxyService.box.getUserId()!,
                      );
                      if (drawer != null) {
                        ProxyService.strategy.updateDrawer(
                            drawerId: drawer.id,
                            closingBalance: data.income,
                            cashierId: ProxyService.box.getUserId()!);
                      }
                      _routerService.navigateTo(
                          DrawerScreenRoute(open: "close", drawer: drawer!));
                    },
                  ),
                ],
                if (deviceType !=
                    'Phone') // Show Tax Configuration only on non-phone platforms
                  SettingsTile(
                    title: Text("Tax Configuration"),
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        FluentIcons.calculator_24_regular,
                      ),
                    ),
                    onPressed: (BuildContext context) {
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
                          return TaxConfiguration(
                            showheader: true,
                          );
                        },
                      );
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
