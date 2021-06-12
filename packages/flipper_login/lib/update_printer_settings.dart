library flipper_login;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flipper_dashboard/setting_view_model.dart';
import 'package:settings_ui/settings_ui.dart';

final isWindows = UniversalPlatform.isWindows;

class UpdatePrinterSetting extends StatefulWidget {
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
      onModelReady: (model) {
        model.loadUserSettings();
      },
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
                  switchValue: model.setting == null
                      ? false
                      : model.setting!.autoPrint == null
                          ? false
                          : model.setting!.autoPrint,
                  onToggle: (bool value) {
                    model.updateSettings(map: {'autoPrint': true});
                    model.loadUserSettings();
                  },
                ),
                SettingsTile.switchTile(
                  title: 'Open Receipt File instead of printing',
                  enabled: notificationsEnabled,
                  leading: Icon(Icons.notifications_active),
                  switchValue: model.setting == null
                      ? false
                      : model.setting!.openReceiptFileOSaleComplete == null
                          ? false
                          : model.setting!.openReceiptFileOSaleComplete,
                  onToggle: (value) {
                    model.updateSettings(
                        map: {'openReceiptFileOSaleComplete': true});
                    model.loadUserSettings();
                  },
                ),
              ],
            )
          ]),
        );
      },
    );
  }
}
