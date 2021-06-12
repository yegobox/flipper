library flipper_login;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flipper_models/setting.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flipper_dashboard/setting_view_model.dart';
import 'package:settings_ui/settings_ui.dart';

final isWindows = UniversalPlatform.isWindows;

class UpdatePrinterSetting extends StatefulWidget {
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  _UpdatePrinterSettingState createState() => _UpdatePrinterSettingState();
}

class _UpdatePrinterSettingState extends State<UpdatePrinterSetting> {
  TextEditingController emailController = TextEditingController();
  bool lockInBackground = true;
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingViewModel>.reactive(
      viewModelBuilder: () => SettingViewModel(),
      builder: (context, model, child) {
        return Container(
          height: 150,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: SettingsList(sections: [
            SettingsSection(
              tiles: [
                SettingsTile.switchTile(
                  title: 'Auto print',
                  leading: Icon(Icons.lock),
                  switchValue: true,
                  onToggle: (bool value) {},
                ),
                SettingsTile.switchTile(
                  title: 'Open Receipt File',
                  enabled: notificationsEnabled,
                  leading: Icon(Icons.notifications_active),
                  switchValue: true,
                  onToggle: (value) {},
                ),
              ],
            )
          ]),
        );
      },
    );
  }
}
