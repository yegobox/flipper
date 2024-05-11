library flipper_login;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:universal_platform/universal_platform.dart';

import 'package:flipper_models/realm_model_export.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';

final isWindows = UniversalPlatform.isWindows;

class UpdatePrinterSetting extends StatefulWidget {
  const UpdatePrinterSetting({Key? key}) : super(key: key);

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
      onViewModelReady: (model) {
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
                  title: Text('Auto print'),
                  leading: Icon(Icons.lock),
                  initialValue: model.setting == null
                      ? false
                      : model.setting!.autoPrint == null
                          ? false
                          : model.setting!.autoPrint,
                  onToggle: (bool value) {
                    if (model.setting != null &&
                        model.setting!.autoPrint != null) {
                      model.updateSettings(
                          map: {'autoPrint': !model.setting!.autoPrint!});
                      model.loadUserSettings();
                    } else {
                      model.updateSettings(map: {'autoPrint': true});
                      model.loadUserSettings();
                    }
                  },
                ),
                SettingsTile.switchTile(
                  title: Text('Open Receipt File instead of printing'),
                  enabled: notificationsEnabled,
                  leading: Icon(Icons.notifications_active),
                  initialValue: model.setting == null
                      ? false
                      : model.setting!.openReceiptFileOSaleComplete == null
                          ? false
                          : model.setting!.openReceiptFileOSaleComplete,
                  onToggle: (value) {
                    if (model.setting != null &&
                        model.setting!.openReceiptFileOSaleComplete != null) {
                      model.updateSettings(map: {
                        'openReceiptFileOSaleComplete':
                            !model.setting!.openReceiptFileOSaleComplete!
                      });
                      model.loadUserSettings();
                    } else {
                      model.updateSettings(
                          map: {'openReceiptFileOSaleComplete': true});
                      model.loadUserSettings();
                    }
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
