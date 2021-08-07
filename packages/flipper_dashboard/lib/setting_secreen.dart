import 'package:flipper_dashboard/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flipper_login/update_email.dart';
import 'package:flipper_login/update_printer_settings.dart';
import 'languages_screen.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';
import 'package:overlay_support/overlay_support.dart';
import 'setting_view_model.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool lockInBackground = false;
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingViewModel>.reactive(
      onModelReady: (model) {
        model.toggleSettings();
      },
      builder: (context, model, child) {
        return Scaffold(
          appBar: CustomAppBar(
            onPop: () {
              ProxyService.nav.back();
            },
            title: 'Flipper Settings',
            showActionButton: false,
            onPressedCallback: () async {
              ProxyService.nav.back();
            },
            icon: Icons.close,
            multi: 3,
            bottomSpacer: 50,
          ),
          body: buildSettingsList(model: model),
        );
      },
      viewModelBuilder: () => SettingViewModel(),
    );
  }

  Widget buildSettingsList({required SettingViewModel model}) {
    return SettingsList(
      sections: [
        SettingsSection(
          title: 'Common',
          tiles: [
            SettingsTile(
              title: 'Language',
              subtitle: 'English',
              leading: Icon(Icons.language),
              onPressed: (context) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => LanguagesScreen(),
                ));
              },
            ),
            SettingsTile(
              title: 'Environment',
              subtitle: 'Local',
              leading: Icon(Icons.cloud_queue),
            ),
          ],
        ),
        SettingsSection(
          title: 'Account',
          tiles: [
            // SettingsTile(title: 'Phone number', leading: Icon(Icons.phone)),
            SettingsTile(
              title: 'Email',
              leading: Icon(Icons.email),
              onPressed: (context) {
                showEmailModal();
              },
            ),
            // SettingsTile(title: 'Sign out', leading: Icon(Icons.exit_to_app)),
          ],
        ),
        SettingsSection(
          title: 'Security',
          tiles: [
            SettingsTile.switchTile(
              title: 'Enable printer',
              leading: Icon(Icons.print),
              switchValue: model.settingService.enablePrinter,
              onToggle: (bool value) {
                model.enablePrint();
              },
            ),
            SettingsTile.switchTile(
              title: 'Send daily report',
              leading: Icon(Icons.analytics),
              switchValue: model.settingService.sendDailReport,
              onToggle: (bool value) {
                model.enableDailyReport(() {
                  showSimpleNotification(
                    Text('You need to add email first'),
                    background: Colors.red,
                    position: NotificationPosition.bottom,
                  );
                });
              },
            )
          ],
        ),
      ],
    );
  }

  void showPrinterSetupModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            child: UpdatePrinterSetting(),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
          ),
        );
      },
    );
  }

  void showEmailModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            child: UpdateEmailSetting(),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
          ),
        );
      },
    );
  }
}
