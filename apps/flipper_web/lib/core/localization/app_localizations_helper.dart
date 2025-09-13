import 'package:flutter/material.dart';
import 'package:flipper_web/l10n/app_localizations.dart';
/// Helper extension to easily access localizations
extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}