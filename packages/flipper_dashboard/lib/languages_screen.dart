import 'package:flipper_dashboard/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/view_models/setting_view_model.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

class LanguagesScreen extends StatefulWidget {
  const LanguagesScreen({Key? key}) : super(key: key);

  @override
  _LanguagesScreenState createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  int languageIndex = 0;
  final _routerService = locator<RouterService>();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingViewModel>.reactive(
        viewModelBuilder: () => SettingViewModel(),
        onViewModelReady: (model) {
          model.getSetting();
        },
        builder: (context, model, child) {
          return Scaffold(
            appBar: CustomAppBar(
              onPop: () {
                _routerService.pop();
              },
              title: 'Languages',
              showActionButton: false,
              onActionButtonClicked: () async {
                _routerService.pop();
              },
              icon: Icons.close,
              multi: 3,
              bottomSpacer: 55,
            ),
            body: SettingsList(
              sections: [
                SettingsSection(tiles: [
                  SettingsTile(
                    title: "English",
                    trailing: trailingWidget(model.defaultLanguage == 'en'),
                    onPressed: (BuildContext context) {
                      model.setLanguage('en');
                      model.updateSettings(map: {'defaultLanguage': 'en'});
                    },
                  ),
                  SettingsTile(
                    title: "Ikinyarwanda",
                    trailing: trailingWidget(model.defaultLanguage == 'fr'),
                    onPressed: (BuildContext context) {
                      model.setLanguage('fr');
                      model.updateSettings(map: {'defaultLanguage': 'fr'});
                    },
                  ),
                  SettingsTile(
                    title: "Swahili",
                    trailing: trailingWidget(model.defaultLanguage == 'sw'),
                    onPressed: (BuildContext context) {
                      model.setLanguage('sw');
                      model.updateSettings(map: {'defaultLanguage': 'sw'});
                    },
                  ),
                ]),
              ],
            ),
          );
        });
  }

  Widget trailingWidget(bool checked) {
    return (checked)
        ? const Icon(Icons.check, color: Colors.blue)
        : const Icon(null);
  }
}
