import 'package:flipper_dashboard/setting_view_model.dart';
import 'package:flipper_models/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:google_ui/google_ui.dart';
import 'package:stacked/stacked.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key, this.business}) : super(key: key);
  final Business? business;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingViewModel>.reactive(
      viewModelBuilder: () => SettingViewModel(),
      onModelReady: (model) async => await model.createPin(),
      builder: (context, model, child) {
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: Column(
                children: [
                  const GText(
                    "Settings",
                    variant: GTextVariant.headline4,
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
                              leading: const CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.computer,
                                  color: Colors.green,
                                ),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: Theme.of(context).primaryColor,
                              ),
                              onPressed: (BuildContext context) {
                                GoRouter.of(context).push(
                                    "/devices/" + model.pin!.pin.toString());
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
          ),
        );
      },
    );
  }
}
