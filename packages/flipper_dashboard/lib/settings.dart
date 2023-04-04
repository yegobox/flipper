import 'package:flipper_models/view_models/setting_view_model.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/isar_models.dart' as isar;
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

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
                  SizedBox(height: 10),
                  Text("Settings",
                      style: GoogleFonts.poppins(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      )),
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
                                  FluentIcons.person_24_regular,
                                ),
                              ),
                              trailing: Icon(
                                FluentIcons.chevron_right_24_regular,
                              ),
                              onPressed: (BuildContext context) {},
                            ),
                            SettingsTile(
                              title: "Linked Devices",
                              leading: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(
                                  FluentIcons.desktop_24_regular,
                                ),
                              ),
                              trailing: Icon(
                                FluentIcons.chevron_right_24_regular,
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
                                  FluentIcons.print_24_regular,
                                ),
                              ),
                              trailing: Icon(
                                FluentIcons.chevron_right_24_regular,
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
                                  FluentIcons.arrow_upload_20_regular,
                                ),
                              ),
                              trailing: Icon(
                                FluentIcons.chevron_right_24_regular,
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
                                  FluentIcons.calculator_24_regular,
                                ),
                              ),
                              trailing: Icon(
                                FluentIcons.chevron_right_24_regular,
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
                                  FluentIcons.people_add_24_regular,
                                ),
                              ),
                              trailing: Icon(
                                FluentIcons.chevron_right_24_regular,
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
                                  FluentIcons.paint_brush_24_regular,
                                ),
                              ),
                              trailing: Icon(
                                FluentIcons.chevron_right_24_regular,
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
                            ),
                            SettingsTile(
                              title: "Switch to Customer Support",
                              leading: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(
                                  FluentIcons.comment_24_regular,
                                ),
                              ),
                              trailing: Icon(
                                FluentIcons.chevron_right_24_regular,
                              ),
                              onPressed: (BuildContext context) async {
                                // get active drawer
                                ProxyService.box
                                    .write(key: 'defaultApp', value: 1);
                                // navigate
                                _routerService
                                    .navigateTo(SocialHomeViewRoute());
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
