import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_dashboard/profile.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked/stacked.dart';

class Security extends StatelessWidget {
  Security({Key? key}) : super(key: key);
  final _routerService = locator<RouterService>();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingViewModel>.reactive(
      viewModelBuilder: () => SettingViewModel(),
      onViewModelReady: (model) async => await model.createPin(),
      builder: (context, model, child) {
        return SafeArea(
          child: Scaffold(
            appBar: CustomAppBar(
              onPop: () async {
                _routerService.pop();
              },
              title: 'Settings',
              disableButton: false,
              showActionButton: false,
            ),
            backgroundColor: Theme.of(context).canvasColor,
            body: ViewModelBuilder<HomeViewModel>.reactive(
                viewModelBuilder: () => HomeViewModel(),
                builder: (a, model, c) {
                  return SafeArea(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ProfileWidget(
                              tenant: model.tenant!, sessionActive: true),
                        ),
                        SizedBox(height: 10),
                        Flexible(
                          child: StreamBuilder<ITenant?>(
                              stream: ProxyService.isar.getDefaultTenant(
                                  businessId:
                                      ProxyService.box.getBusinessId()!),
                              builder: (context, snapshot) {
                                return SettingsList(
                                  backgroundColor:
                                      Theme.of(context).canvasColor,
                                  sections: [
                                    SettingsSection(
                                      tiles: [
                                        SettingsTile.switchTile(
                                          enabled: snapshot.data != null &&
                                              snapshot.data!.pin != null &&
                                              snapshot.data!.pin != 0,
                                          title: 'Enable Passcode',
                                          leading: Icon(Icons.pin),
                                          switchValue: true,
                                          onToggle: (bool value) {
                                            ///check to see if on the existing
                                            if (value) {
                                              /// show the passcord to set it for the first time.!
                                              screenLockCreate(
                                                context: context,
                                                onValidate: (value) async {
                                                  if (value.length != 4) {
                                                    return false;
                                                  }
                                                  return true;
                                                },
                                                onConfirmed: (value) async {
                                                  final response = await model
                                                      .updateUserWithPinCode(
                                                          pin: value);
                                                  if (response == 200) {
                                                    Navigator.of(context)
                                                        .maybePop();
                                                  }
                                                },
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }),
                        ),
                      ],
                    ),
                  );
                }),
          ),
        );
      },
    );
  }
}
