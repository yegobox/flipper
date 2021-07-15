import 'package:flipper_routing/routes.locator.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/setting.dart';
import 'package:flutter/material.dart';

class SettingViewModel extends ReactiveViewModel {
  final settingService = locator<SettingsService>();
  bool _updateStarted = false;
  Setting? _setting = null;
  Setting? get setting => _setting;
  bool get updateStart => _updateStarted;
  final log = getLogger('SettingViewModel');
  //
  Locale? klocale = null;

  Locale? get locale => klocale;

  Future<String?> getSetting() async {
    return await ProxyService.box.read(key: 'defaultLanguage');
  }

  void setLanguage(String lang) {
    klocale = Locale(lang);
    ProxyService.box.write(key: 'defaultLanguage', value: lang);
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

  @override
  List<ReactiveServiceMixin> get reactiveServices => [];
}
