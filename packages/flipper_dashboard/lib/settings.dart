import 'package:flipper_models/view_models/setting_view_model.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/isar_models.dart' as isar;

class SettingPage extends StatelessWidget {
  SettingPage({Key? key, this.business}) : super(key: key);
  final isar.Business? business;
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
            child: Center(
              child: Column(
                children: [
                  const Text(
                    "Settings",
                  ),
                  Flexible(
                    child: SettingsList(
                      backgroundColor: Theme.of(context).canvasColor,
                      sections: [
                        SettingsSection(
                          tiles: [
                            SettingsTile(
                              title: business?.name,
                              leading: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.person,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: Theme.of(context).primaryColor,
                              ),
                              onPressed: (BuildContext context) {},
                            ),
                            SettingsTile(
                              title: "Linked Devices",
                              leading: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.computer,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: Theme.of(context).primaryColor,
                              ),
                              onPressed: (BuildContext context) {
                                _routerService.replaceWith(
                                    DevicesRoute(pin: model.pin!.pin));
                              },
                            ),
                            SettingsTile(
                              title: "Printing configuration",
                              leading: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.print,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: Theme.of(context).primaryColor,
                              ),
                              onPressed: (BuildContext context) {
                                _routerService.replaceWith(PrintingRoute());
                              },
                            ),
                            SettingsTile(
                              title: "BackUp configuration",
                              leading: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.backup,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: Theme.of(context).primaryColor,
                              ),
                              onPressed: (BuildContext context) {
                                _routerService.replaceWith(BackUpRoute());
                              },
                            ),
                            SettingsTile(
                              title: "Tax Configuration",
                              leading: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.calculate,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: Theme.of(context).primaryColor,
                              ),
                              onPressed: (BuildContext context) {
                                _routerService
                                    .replaceWith(TaxConfigurationRoute());
                              },
                            ),
                            SettingsTile(
                              title: "Add users",
                              leading: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.group_add,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: Theme.of(context).primaryColor,
                              ),
                              onPressed: (BuildContext context) async {
                                _routerService.replaceWith(TenantAddRoute());
                              },
                            ),
                            SettingsTile(
                              title: "Close a day",
                              leading: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.draw_rounded,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: Theme.of(context).primaryColor,
                              ),
                              onPressed: (BuildContext context) async {
                                // get active drawer
                                isar.Drawers? drawer =
                                    await ProxyService.isarApi.isDrawerOpen(
                                        cashierId:
                                            ProxyService.box.getBusinessId()!);
                                _routerService.replaceWith(DrawerScreenRoute(
                                    open: "close", drawer: drawer));
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
