import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_dashboard/providers/locale_provider.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:flipper_login/update_email.dart';
import 'languages_screen.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_models/db_model_export.dart';

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
            title: context.flipperL10n.flipperSettingsTitle,
            showActionButton: false,
            onActionButtonClicked: () async {
              _routerService.pop();
            },
            icon: Icons.close,
            multi: 3,
            bottomSpacer: 50,
          ),
          body: buildSettingsList(context: context, model: model),
        );
      },
      viewModelBuilder: () => SettingViewModel(),
    );
  }

  Widget buildSettingsList({
    required BuildContext context,
    required SettingViewModel model,
  }) {
    final l10n = context.flipperL10n;
    return SettingsList(
      sections: [
        SettingsSection(
          title: Text(l10n.common),
          tiles: [
            SettingsTile(
              title: Text(l10n.language),
              // Reflects the language actually in effect rather than a fixed
              // label, so this row never contradicts Admin Control.
              description: Consumer(
                builder: (context, ref, _) => Text(
                  languageDisplayName(
                    l10n,
                    ref.watch(effectiveLanguageCodeProvider),
                  ),
                ),
              ),
              leading: const Icon(Icons.language),
              onPressed: (context) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const LanguagesScreen(),
                ));
              },
            ),
            SettingsTile(
              title: Text(l10n.environment),
              description: Text(l10n.local),
              leading: const Icon(Icons.cloud_queue),
            ),
          ],
        ),
        SettingsSection(
          title: Text(l10n.account),
          tiles: [
            SettingsTile(
              title: Text(l10n.email),
              leading: const Icon(Icons.email),
              onPressed: (context) {
                showEmailModal();
              },
            ),
          ],
        ),
        SettingsSection(
          title: Text(l10n.security),
          tiles: [
            SettingsTile.switchTile(
              title: Text(l10n.sendDailyReport),
              leading: const Icon(Icons.analytics),
              initialValue: model.kSetting.sendDailReport,
              onToggle: (bool value) {
                // model.enableDailyReport((message) {
                //   showSimpleNotification(
                //     Text(message),
                //     background: Colors.red,
                //     position: NotificationPosition.bottom,
                //   );
                // });
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
            child: const Text("settings"),
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
