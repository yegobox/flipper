import 'package:flipper_routing/routes.locator.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:flipper_services/language_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/setting.dart';
import 'package:flutter/material.dart';

class SettingViewModel extends ReactiveViewModel {
  final settingService = locator<SettingsService>();
  final languageService = locator<LanguageService>();
  bool _updateStarted = false;
  Setting? _setting = null;
  Setting? get setting => _setting;
  bool get updateStart => _updateStarted;
  final log = getLogger('SettingViewModel');
  String? defaultLanguage = null;

  Locale? klocale = null;

  Locale? get locale => klocale;

  String? getSetting() {
    klocale = Locale(ProxyService.box.read(key: 'defaultLanguage') ?? 'en');
    setLanguage(ProxyService.box.read(key: 'defaultLanguage') ?? 'en');
    return ProxyService.box.read(key: 'defaultLanguage');
  }

  void setLanguage(String lang) {
    defaultLanguage = null;
    klocale = Locale(lang);
    ProxyService.box.write(key: 'defaultLanguage', value: lang);
    defaultLanguage = lang;
    log.i(defaultLanguage);
    languageService.setLocale(lang: defaultLanguage!);
    notifyListeners();
  }

  Future<bool> updateSettings({required Map map}) async {
    _updateStarted = true;
    return await settingService.updateSettings(map: map);
  }

  loadUserSettings() async {
    String userId = ProxyService.box.read(key: 'userId');
    _setting = await ProxyService.api.getSetting(userId: int.parse(userId));
    notifyListeners();
  }

  void toggleSettings() {
    log.i('toggleSettings');
    settingService.toggleSettings();
  }

  Map<String, dynamic> settings() {
    return settingService.settings();
  }

  void enablePrint() {
    settingService.enablePrint(bool: !settingService.enablePrinter);
    toggleSettings();
  }

  void enableDailyReport(Function callback) {
    if (settings()['email'] != null && settings()['email'].length > 0) {
      settingService.enableDailyReport(bool: !settingService.sendDailReport);
      if (settings()['googleSheetDocCreated'] == null ||
          settings()['googleSheetDocCreated'] == false) {
        settingService.createGoogleSheetDoc();
        ProxyService.api.createGoogleSheetDoc();
      }
      toggleSettings();
    } else {
      callback();
    }
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [languageService];
}
