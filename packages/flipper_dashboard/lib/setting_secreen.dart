import 'package:flipper_dashboard/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:flipper_login/update_email.dart';
import 'package:flipper_login/update_printer_settings.dart';
import 'languages_screen.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_models/isar_models.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool lockInBackground = false;
  bool notificationsEnabled = true;
  final _routerService = locator<RouterService>();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingViewModel>.reactive(
      onViewModelReady: (model) {
        model.kSetting.toggleDailyReportSetting();
      },
      builder: (context, model, child) {
        return Scaffold(
          appBar: CustomAppBar(
            onPop: () {
              _routerService.pop();
            },
            title: 'Flipper Settings',
            showActionButton: false,
            onActionButtonClicked: () async {
              _routerService.pop();
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
              leading: const Icon(Icons.language),
              onPressed: (context) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const LanguagesScreen(),
                ));
              },
            ),
            SettingsTile(
              title: 'Environment',
              subtitle: 'Local',
              leading: const Icon(Icons.cloud_queue),
            ),
          ],
        ),
        SettingsSection(
          title: 'Account',
          tiles: [
            SettingsTile(
              title: 'Email',
              leading: const Icon(Icons.email),
              onPressed: (context) {
                showEmailModal();
              },
            ),
          ],
        ),
        SettingsSection(
          title: 'Security',
          tiles: [
            SettingsTile.switchTile(
              title: 'Send daily report',
              leading: const Icon(Icons.analytics),
              switchValue: model.kSetting.sendDailReport,
              onToggle: (bool value) {
                model.enableDailyReport((message) {
                  showSimpleNotification(
                    Text(message),
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
            child: const UpdatePrinterSetting(),
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
