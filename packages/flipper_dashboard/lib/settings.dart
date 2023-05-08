import 'dart:math';

import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/abstractions/upload.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/isar_models.dart' as isar;
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

final List<Color> colors = [
  Colors.blue,
  Colors.green,
  Colors.red,
  Colors.yellow,
  Colors.orange,
  Colors.purple,
  Colors.teal,
  Colors.pink,
];

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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Stack(
                    children: [
                      StreamBuilder<Business>(
                          stream: ProxyService.isarApi
                              .businessStream(businessId: business!.id!),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final data = snapshot.data;
                              if (data!.imageUrl == null) {
                                return CircleAvatar(
                                  radius: 100,
                                  backgroundColor: Colors.white,
                                  child: SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: colors[
                                            Random().nextInt(colors.length)],
                                        borderRadius: BorderRadius.circular(25),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade200,
                                            blurRadius: 5,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          business?.name != null &&
                                                  business!.name!.length > 0
                                              ? business!.name!
                                                  .substring(0, 2)
                                                  .toUpperCase()
                                              : '',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return CircleAvatar(
                                  radius: 100,
                                  backgroundColor: Colors.white,
                                  backgroundImage: NetworkImage(data.imageUrl!),
                                );
                              }
                            }
                            return SizedBox.shrink();
                          }),
                      Positioned(
                        bottom: 45,
                        right: 30,
                        child: IconButton(
                          icon: Icon(Icons.camera),
                          color: Colors.white,
                          iconSize: 40,
                          onPressed: () {
                            ProxyService.upload.browsePictureFromGallery(
                                urlType: URLTYPE.BUSINESS,
                                productId: business!.id!,
                                onComplete: (res) {
                                  log(res);
                                });
                          },
                        ),
                      )
                    ],
                  ),
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
                            onPressed: (BuildContext context) {
                              _routerService.navigateTo(
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
                            onPressed: (BuildContext context) {
                              _routerService.navigateTo(PrintingRoute());
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
                            onPressed: (BuildContext context) {
                              _routerService.navigateTo(BackUpRoute());
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
                              // get active drawer
                              isar.Drawers? drawer = await ProxyService.isarApi
                                  .getDrawer(
                                      cashierId:
                                          ProxyService.box.getBusinessId()!);
                              _routerService.navigateTo(DrawerScreenRoute(
                                  open: "close", drawer: drawer));
                            },
                          ),
                          SettingsTile(
                            title: "Switch to flipper Connecta",
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                FluentIcons.comment_24_regular,
                              ),
                            ),
                            onPressed: (BuildContext context) async {
                              // get active drawer
                              ProxyService.box
                                  .write(key: 'defaultApp', value: 2);
                              // navigate
                              _routerService.navigateTo(SocialHomeViewRoute());
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
        );
      },
    );
  }
}
