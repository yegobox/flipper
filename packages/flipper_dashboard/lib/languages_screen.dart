import 'package:flipper_dashboard/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_dashboard/setting_view_model.dart';

class LanguagesScreen extends StatefulWidget {
  @override
  _LanguagesScreenState createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  int languageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingViewModel>.reactive(
        viewModelBuilder: () => SettingViewModel(),
        builder: (context, model, child) {
          return Scaffold(
            // appBar: AppBar(title: Text('Languages')),
            appBar: CustomAppBar(
              onPop: () {
                ProxyService.nav.back();
              },
              title: 'Languages',
              showActionButton: false,
              onPressedCallback: () async {
                ProxyService.nav.back();
              },
              // rightActionButtonName: 'Save',
              icon: Icons.close,
              multi: 3,
              bottomSpacer: 55,
            ),
            body: SettingsList(
              sections: [
                SettingsSection(tiles: [
                  SettingsTile(
                    title: "English",
                    trailing: trailingWidget(0),
                    onPressed: (BuildContext context) {
                      changeLanguage(0, model);
                    },
                  ),
                  SettingsTile(
                    title: "Ikinyarwanda",
                    trailing: trailingWidget(1),
                    onPressed: (BuildContext context) {
                      changeLanguage(1, model);
                    },
                  ),
                  SettingsTile(
                    title: "Swahili",
                    trailing: trailingWidget(3),
                    onPressed: (BuildContext context) {
                      changeLanguage(3, model);
                    },
                  ),
                ]),
              ],
            ),
          );
        });
  }

  Widget trailingWidget(int index) {
    return (languageIndex == index)
        ? Icon(Icons.check, color: Colors.blue)
        : Icon(null);
  }

  void changeLanguage(int index, SettingViewModel model) {
    setState(() {
      languageIndex = index;
      switch (index) {
        case 0:
          // this is english save it as we know it!
          model.setLanguage('en');
          model.updateSettings(map: {'defaultLanguage': 'en'});
          break;
        case 1:
          // this is english save it as we know it!
          model.setLanguage('be');
          model.updateSettings(
              map: {'defaultLanguage': 'be'}); // for kinyarwanda
          break;
        case 3:
          // this is english save it as we know it!
          model.setLanguage('sw');
          model.updateSettings(map: {'defaultLanguage': 'sw'});
      }
    });
  }
}
