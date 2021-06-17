import 'package:flipper/routes.locator.dart';
import 'package:flipper/routes.logger.dart';
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

  Future<Setting?> getSetting() async {
    await Future.delayed(Duration(microseconds: 2000));
    String userId = ProxyService.box.read(key: 'userId');
    return await ProxyService.api.getSetting(userId: int.parse(userId));
  }

  void setLanguage(String lang) {
    klocale = Locale(lang);
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
