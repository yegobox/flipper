import 'package:flipper/localization.dart';
import 'package:flipper_dashboard/setting_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flipper_models/flipper_models.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flipper_login/update_email.dart';
import 'package:flipper_routing/routes.router.dart';

Widget header({required String title}) {
  return Material(
    child: Container(
      child: ListTile(
        leading: Icon(Icons.arrow_back_ios),
        title: Text(title),
        onTap: () {
          //navigation back
          ProxyService.nav.back();
        },
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18.0),
          topRight: Radius.circular(18.0),
        ),
      ),
    ),
  );
}

Widget trailingWidget(bool checked) {
  return (checked) ? Icon(Icons.check, color: Colors.blue) : Icon(null);
}

void preferences(
    {required BuildContext context, required BusinessHomeViewModel model}) {
  bottomSheetBuilder(
    header: header(title: 'Preferences'),
    context: context,
    body: Column(children: [
      if (ProxyService.remoteConfig.isAccessiblityFeatureAvailable())
        ListTile(
          leading: Icon(Ionicons.search),
          title: Text('Accessibility'),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
      ListTile(
        leading: Icon(Ionicons.language),
        title: Text('Language'),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          bottomSheetBuilder(
            context: context,
            header: header(title: 'Language'),
            body: ViewModelBuilder<SettingViewModel>.reactive(
              viewModelBuilder: () => SettingViewModel(),
              onModelReady: (model) {
                model.getSetting();
                // log.i(model.getSetting());
              },
              builder: (context, model, child) {
                return Column(
                  children: [
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
                    )
                  ],
                );
              },
            ),
          );
        },
      ),
      ListTile(
        leading: Icon(Ionicons.keypad),
        title: Text('Reports'),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          bottomSheetBuilder(
            header: header(title: 'Reports'),
            context: context,
            body: ViewModelBuilder<SettingViewModel>.reactive(
              viewModelBuilder: () => SettingViewModel(),
              onModelReady: (model) {
                model.getSetting();
                // log.i(model.getSetting());
              },
              builder: (context, model, child) {
                return Column(
                  children: [
                    SettingsTile.switchTile(
                      title: 'Enable Report',
                      switchValue: model.settingService.sendDailReport,
                      onToggle: (bool value) {
                        model.enableDailyReport((message) {
                          if (message == 1) {
                            showSimpleNotification(
                              Text('Added email is not gmail'),
                              background: Colors.red,
                              position: NotificationPosition.bottom,
                            );
                          }
                          if (message == 2) {
                            // You need to add email first
                            bottomSheetBuilder(
                              context: context,
                              body: UpdateEmailSetting(),
                              header: header(title: 'Add Email'),
                            );
                          }
                        });
                      },
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
      if (ProxyService.remoteConfig.isBackupAvailable())
        ListTile(
          leading: Icon(Ionicons.sync),
          title: Text('BackUps'),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            bottomSheetBuilder(
              context: context,
              header: header(title: 'Add Backup'),
              body: Column(
                children: [
                  ListTile(
                    leading: Icon(Ionicons.cloud_download),
                    title: Text('Download Backup'),
                    trailing: Icon(Ionicons.happy),
                    onTap: () {
                      model.downloadBackup();
                    },
                  ),
                  ListTile(
                    leading: Icon(Ionicons.cloud_upload),
                    title: Text('Backup now'),
                    trailing: Icon(Ionicons.file_tray),
                    onTap: () {
                      model.uploadBackup();
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ListTile(
        leading: Icon(Ionicons.analytics),
        title: Text('Analytics'),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          ProxyService.nav.navigateTo(Routes.analytics);
        },
      )
    ]),
  );
}

void addWorkSpace({required BuildContext context}) {
  bottomSheetBuilder(
    header: header(title: Localization.of(context)!.addWorkSpace),
    context: context,
    body: ViewModelBuilder<SettingViewModel>.reactive(
        viewModelBuilder: () => SettingViewModel(),
        builder: (context, model, child) {
          return Column(children: [
            if (ProxyService.remoteConfig.isAccessiblityFeatureAvailable())
              ListTile(
                leading: Icon(Ionicons.search),
                title: Text('Accessibility'),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ListTile(
              leading: Icon(Ionicons.language),
              title: Text('Language'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Ionicons.keypad),
              title: Text('Enable report'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                print('here');
              },
            ),
          ]);
        }),
  );
}
