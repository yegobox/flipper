import 'package:flipper_routing/routes.locator.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:flipper_services/language_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/setting.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/business.dart';

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

  /// enable report on user's email
  /// the email have to be gmail for now, in future release we might add other email providers
  /// if for some reason the report is not shared to user's email but the report google sheet document has been created.
  /// a user can toggle the report on/off from the settings page. the report will be sent to the user's email.
  /// the backend is built in a way to reshare the report to the user's email.
  void enableDailyReport(Function callback) async {
    if (settings()['email'] != null && settings()['email'].length > 0) {
      if (!RegExp(r"^[\w.+\-]+@gmail\.com$").hasMatch(settings()['email'])) {
        callback(1);
      } else {
        await settingService.enableDailyReport(
          bool: true,
        );
        await ProxyService.api.createGoogleSheetDoc(email: settings()['email']);
        await settingService.createGoogleSheetDoc();
        //patch the business with the email.
        Business business = ProxyService.api.getBusiness();
        business.email = settings()['email'];
        await ProxyService.api.updateBusiness(
          id: business.id,
          business: business.toJson(),
        );
        ProxyService.api.update(
          data: business.toJson(),
          endPoint: 'businesses/' + business.id.toString(),
        );
        toggleSettings();
      }
    } else {
      callback(2);
    }
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices =>
      [languageService, settingService];
}
