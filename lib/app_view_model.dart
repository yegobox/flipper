import 'package:flipper_dashboard/setting_view_model.dart';
import 'package:flutter/material.dart';

class AppViewModel extends SettingViewModel {
  void setLocale(Locale locale) {
    klocale = locale;
    notifyListeners();
  }
}
