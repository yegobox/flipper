import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_dashboard/providers/locale_provider.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:stacked_services/stacked_services.dart';

/// Standalone language picker reached from Flipper Settings.
///
/// Shares [appLocaleProvider] with Admin Control's [LanguageSettingsCard] so
/// both entry points read and write the same persisted choice.
class LanguagesScreen extends ConsumerWidget {
  const LanguagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
    final routerService = locator<RouterService>();
    final chosenLocale = ref.watch(appLocaleProvider);
    final effectiveCode = ref.watch(effectiveLanguageCodeProvider);

    return Scaffold(
      appBar: CustomAppBar(
        onPop: routerService.pop,
        title: l10n.languagesTitle,
        showActionButton: false,
        onActionButtonClicked: () async => routerService.pop(),
        icon: Icons.close,
        multi: 3,
        bottomSpacer: 55,
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            tiles: [
              for (final language in kSelectableLanguages)
                SettingsTile(
                  // Endonym first so speakers can find their language even
                  // while the app is still showing another one.
                  title: Text(language.nativeName),
                  description: Text(languageDisplayName(l10n, language.code)),
                  trailing: _trailingWidget(
                    chosenLocale?.languageCode == language.code,
                  ),
                  onPressed: (_) => ref
                      .read(appLocaleProvider.notifier)
                      .setLanguage(language.code),
                ),
              SettingsTile(
                title: Text(l10n.useDeviceLanguage),
                description: Text(languageDisplayName(l10n, effectiveCode)),
                trailing: _trailingWidget(chosenLocale == null),
                onPressed: (_) =>
                    ref.read(appLocaleProvider.notifier).useDeviceLanguage(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _trailingWidget(bool checked) => checked
      ? const Icon(Icons.check, color: Colors.blue)
      : const SizedBox.shrink();
}
