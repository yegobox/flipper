import 'package:flipper_dashboard/setting_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/flipper_localizations.dart'; // Add this line.

class AppViewModel extends SettingViewModel {
  void setLocale(Locale locale) {
    if (!AppLocalizations.supportedLocales.contains(locale)) return;
    klocale = locale;
    notifyListeners();
  }
}
