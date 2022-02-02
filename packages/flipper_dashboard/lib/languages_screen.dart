import 'package:flipper_dashboard/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_dashboard/setting_view_model.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:go_router/go_router.dart';

class LanguagesScreen extends StatefulWidget {
  @override
  _LanguagesScreenState createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  int languageIndex = 0;
  final log = getLogger('LanguagesScreen');

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingViewModel>.reactive(
        viewModelBuilder: () => SettingViewModel(),
        onModelReady: (model) {
          model.getSetting();
          log.i(model.getSetting());
        },
        builder: (context, model, child) {
          return Scaffold(
            appBar: CustomAppBar(
              onPop: () {
                GoRouter.of(context).pop();
              },
              title: 'Languages',
              showActionButton: false,
              onPressedCallback: () async {
                GoRouter.of(context).pop();
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
    return (checked) ? Icon(Icons.check, color: Colors.blue) : Icon(null);
  }
}
