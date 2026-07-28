import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_services/language_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

/// Storage key holding the language the user explicitly picked in Admin Control.
/// Kept identical to the key [SettingViewModel] has always used so existing
/// installs keep their choice.
const String kDefaultLanguageKey = 'defaultLanguage';

/// Languages offered in the picker, in display order.
///
/// [FlipperAppLocalizations.supportedLocales] also carries `fr` (translated but
/// not advertised), so the app still resolves French if the device asks for it.
const List<AppLanguage> kSelectableLanguages = [
  AppLanguage(code: 'en', englishName: 'English', nativeName: 'English'),
  AppLanguage(code: 'rw', englishName: 'Kinyarwanda', nativeName: 'Ikinyarwanda'),
  AppLanguage(code: 'sw', englishName: 'Swahili', nativeName: 'Kiswahili'),
];

/// A language the user can select, with its own endonym for the picker.
class AppLanguage {
  const AppLanguage({
    required this.code,
    required this.englishName,
    required this.nativeName,
  });

  final String code;
  final String englishName;
  final String nativeName;

  Locale get locale => Locale(code);
}

/// Holds the locale the user explicitly chose, or `null` when they have not
/// chosen one and the app should follow the device.
///
/// Watched by `MaterialApp.locale` in `apps/flipper/lib/main.dart`; writing to
/// it re-renders the whole app in the new language.
class AppLocaleNotifier extends StateNotifier<Locale?> {
  AppLocaleNotifier() : super(_readPersistedLocale()) {
    // Keep the Stacked-era [LanguageService] aligned so `SettingViewModel` and
    // anything else reading `ProxyService.locale` agree with MaterialApp.
    final persisted = state;
    if (persisted != null) {
      _syncLanguageService(persisted.languageCode);
    }
  }

  static Locale? _readPersistedLocale() {
    final code = ProxyService.box.readString(key: kDefaultLanguageKey);
    if (code == null || code.isEmpty) return null;
    if (!isSupportedLanguageCode(code)) return null;
    return Locale(code);
  }

  /// Persists [languageCode] and switches the app to it immediately.
  Future<void> setLanguage(String languageCode) async {
    if (!isSupportedLanguageCode(languageCode)) return;
    state = Locale(languageCode);
    _syncLanguageService(languageCode);
    await ProxyService.box.writeString(
      key: kDefaultLanguageKey,
      value: languageCode,
    );
  }

  /// Clears the explicit choice so the app follows the device language again.
  Future<void> useDeviceLanguage() async {
    state = null;
    ProxyService.box.remove(key: kDefaultLanguageKey);
  }

  void _syncLanguageService(String languageCode) {
    // The service is optional in tests / non-mobile hosts, so never let a
    // missing registration break language switching.
    if (!getIt.isRegistered<Language>()) return;
    getIt<Language>().setLocale(lang: languageCode);
  }
}

final appLocaleProvider = StateNotifierProvider<AppLocaleNotifier, Locale?>(
  (ref) => AppLocaleNotifier(),
);

/// The language code currently in effect — the explicit choice when there is
/// one, otherwise the best match for the device language.
final effectiveLanguageCodeProvider = Provider<String>((ref) {
  final chosen = ref.watch(appLocaleProvider);
  return chosen?.languageCode ?? resolveDeviceLanguageCode();
});

/// Language names are always rendered in the currently active language, so a
/// picker reads naturally whichever language the app is in.
String languageDisplayName(FlipperAppLocalizations l10n, String code) {
  switch (code) {
    case 'rw':
      return l10n.kinyarwanda;
    case 'sw':
      return l10n.swahili;
    case 'fr':
      return l10n.french;
    case 'en':
    default:
      return l10n.english;
  }
}

bool isSupportedLanguageCode(String code) =>
    FlipperAppLocalizations.supportedLocales.any(
      (locale) => locale.languageCode == code,
    );

/// Picks the first device language Flipper can render, falling back to English.
///
/// East African devices frequently report a locale we have no bundle for
/// (e.g. `lg`, `so`), so country is used as a second signal before defaulting.
String resolveDeviceLanguageCode() {
  final deviceLocales = WidgetsBinding.instance.platformDispatcher.locales;
  for (final deviceLocale in deviceLocales) {
    if (isSupportedLanguageCode(deviceLocale.languageCode)) {
      return deviceLocale.languageCode;
    }
  }
  for (final deviceLocale in deviceLocales) {
    switch (deviceLocale.countryCode) {
      case 'RW':
        return 'rw';
      case 'KE':
      case 'TZ':
      case 'UG':
      case 'BI':
      case 'CD':
        return 'sw';
    }
  }
  return 'en';
}
