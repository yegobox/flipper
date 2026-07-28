import 'package:flutter/cupertino.dart' show CupertinoLocalizations;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flipper_localize/src/l10n/flipper_app_localizations.dart';

export 'src/l10n/flipper_app_localizations.dart';

extension FlipperLocalizationContext on BuildContext {
  FlipperAppLocalizations get flipperL10n => FlipperAppLocalizations.of(this);
}

class FlipperLocalizationsDelegate
    extends LocalizationsDelegate<FlipperAppLocalizations> {
  const FlipperLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      FlipperAppLocalizations.delegate.isSupported(locale);

  @override
  Future<FlipperAppLocalizations> load(Locale locale) {
    return FlipperAppLocalizations.delegate.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate old) => false;
}

/// Locale Flutter's own bundles fall back to when they cannot serve a locale
/// Flipper supports.
const Locale _kFrameworkFallbackLocale = Locale('en');

/// Supplies framework [MaterialLocalizations] for locales `flutter_localizations`
/// has no bundle for — notably Kinyarwanda (`rw`).
///
/// Without this, `Localizations.of<MaterialLocalizations>` returns null under
/// `rw` and every widget that calls `debugCheckHasMaterialLocalizations`
/// ([Drawer], [PopupMenuButton], date pickers, …) throws on build.
///
/// [Localizations] uses the first delegate that reports `isSupported` for a
/// given type, so this must be registered *after*
/// [GlobalMaterialLocalizations.delegate] — real translations win wherever they
/// exist and this only fills the gaps.
class FallbackMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const FallbackMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<MaterialLocalizations> load(Locale locale) =>
      GlobalMaterialLocalizations.delegate.load(_kFrameworkFallbackLocale);

  @override
  bool shouldReload(LocalizationsDelegate old) => false;
}

/// Cupertino counterpart of [FallbackMaterialLocalizationsDelegate].
class FallbackCupertinoLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      GlobalCupertinoLocalizations.delegate.load(_kFrameworkFallbackLocale);

  @override
  bool shouldReload(LocalizationsDelegate old) => false;
}

/// Widgets counterpart of [FallbackMaterialLocalizationsDelegate].
class FallbackWidgetsLocalizationsDelegate
    extends LocalizationsDelegate<WidgetsLocalizations> {
  const FallbackWidgetsLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<WidgetsLocalizations> load(Locale locale) =>
      GlobalWidgetsLocalizations.delegate.load(_kFrameworkFallbackLocale);

  @override
  bool shouldReload(LocalizationsDelegate old) => false;
}

class FlipperLocalizationDelegates {
  const FlipperLocalizationDelegates._();

  /// Order matters: framework bundles first, then the gap-filling fallbacks.
  static const List<LocalizationsDelegate<dynamic>> delegates = [
    FlipperLocalizationsDelegate(),
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    FallbackMaterialLocalizationsDelegate(),
    FallbackCupertinoLocalizationsDelegate(),
    FallbackWidgetsLocalizationsDelegate(),
  ];

  static const List<Locale> supportedLocales =
      FlipperAppLocalizations.supportedLocales;
}
