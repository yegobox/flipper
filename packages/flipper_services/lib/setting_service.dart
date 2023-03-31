import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SettingsService with ListenableServiceMixin {
  //  bool sendDailReport = false;
  final _enablePrinter = ReactiveValue<bool>(false);

  final ReactiveValue<ThemeMode> themeMode =
      ReactiveValue<ThemeMode>(ThemeMode.system);
  bool get enablePrinter => _enablePrinter.value;

  void setThemeMode(ThemeMode mode) {
    themeMode.value = mode;
    notifyListeners();
  }

  final _sendDailReport = ReactiveValue<bool>(false);

  bool get sendDailReport => _sendDailReport.value;

  final _isAttendanceEnabled = ReactiveValue<bool>(false);

  bool get isAttendanceEnabled => _isAttendanceEnabled.value;

  Future<bool> updateSettings({required Map map}) async {
    //todo: when no setting for this user create one with given detail
    //if the setting exist then update the given detail.
    String userId = ProxyService.box.read(key: 'userId');
    Setting? setting =
        await ProxyService.isarApi.getSetting(userId: int.parse(userId));
    if (setting != null) {
      Map<String, dynamic> settingsMap = setting.toJson();
      //replace a key in settings_map if the key match with the key from map
      settingsMap.forEach((key, value) {
        if (map.containsKey(key)) {
          settingsMap[key] = map[key];
        }
      });

      ProxyService.isarApi.update(data: settingsMap);
      return true;
    } else {
      Map kMap = map;
      map.forEach((key, value) {
        kMap[key] = value;
      });
      Setting setting = Setting(
        email: kMap['email'] ?? '',
        userId: int.parse(userId),
        hasPin: kMap['hasPin'] ?? '',
        googleSheetDocCreated: kMap['googleSheetDocCreated'] ?? false,
        attendnaceDocCreated: kMap['attendnaceDocCreated'] ?? false,
        sendDailyReport: kMap['sendDailyReport'] ?? false,
        openReceiptFileOSaleComplete:
            kMap['openReceiptFileOSaleComplete'] ?? false,
        autoPrint: kMap['autoPrint'] ?? false,
        isAttendanceEnabled: kMap['isAttendanceEnabled'] ?? false,
      );
      await ProxyService.isarApi.createSetting(setting: setting);
      return true;
    }
  }

  Future<Setting?> settings() async {
    return ProxyService.isarApi.getSetting(
        userId: int.parse(ProxyService.box.read(key: 'userId') ?? '0'));
  }

  Future<bool> isDailyReportEnabled() async {
    Setting? setting = await settings();
    if (setting != null) {
      return Future.value(setting.sendDailyReport == true);
    } else {
      return Future.value(false);
    }
  }

  Future<bool> enabledPrint() async {
    Setting? setting = await settings();
    if (setting != null) {
      return Future.value(setting.autoPrint == true);
    } else {
      return Future.value(false);
    }
  }

  void enablePrint({required bool bool}) async {
    await updateSettings(map: {'autoPrint': bool});
  }

  void getEnableReportToggleState() async {
    Setting? setting = await settings();
    if (setting != null) {
      _sendDailReport.value =
          setting.sendDailyReport == null ? false : setting.sendDailyReport!;
    }
  }

  void getEnableAttendanceToggleState() async {
    Setting? setting = await settings();
    if (setting != null) {
      _isAttendanceEnabled.value = setting.isAttendanceEnabled == null
          ? false
          : setting.isAttendanceEnabled!;
    }
  }

  void toggleAttendanceSetting() async {
    Setting? setting = await settings();
    if (setting != null) {
      if (setting.isAttendanceEnabled == null) {
        _isAttendanceEnabled.value = false;
      } else {
        _isAttendanceEnabled.value = !setting.isAttendanceEnabled!;
      }

      Setting(
        id: setting.id,
        email: setting.email,
        userId: setting.userId,
        hasPin: setting.hasPin,
        googleSheetDocCreated: setting.googleSheetDocCreated,
        attendnaceDocCreated: setting.attendnaceDocCreated,
        sendDailyReport: setting.sendDailyReport!,
        openReceiptFileOSaleComplete: setting.openReceiptFileOSaleComplete,
        autoPrint: setting.autoPrint,
        isAttendanceEnabled: _isAttendanceEnabled.value,
      );
      updateSettings(map: setting.toJson());
      notifyListeners();
    }
  }

  void toggleDailyReportSetting() async {
    Setting? setting = await settings();
    if (setting != null) {
      if (setting.sendDailyReport == null) {
        _sendDailReport.value = false;
      } else {
        _sendDailReport.value = !setting.sendDailyReport!;
      }
      Setting(
        id: setting.id,
        email: setting.email,
        userId: setting.userId,
        hasPin: setting.hasPin,
        googleSheetDocCreated: setting.googleSheetDocCreated,
        attendnaceDocCreated: setting.attendnaceDocCreated,
        sendDailyReport: _sendDailReport.value,
        openReceiptFileOSaleComplete: setting.openReceiptFileOSaleComplete,
        autoPrint: setting.autoPrint,
      );
      updateSettings(map: setting.toJson());
      notifyListeners();
    }
  }

  Future<Function?> enableAttendance(
      {required bool bool, required Function callback}) async {
    Setting? setting = await settings();
    if (setting != null) {
      int businessId = ProxyService.box.read(key: 'businessId');
      await ProxyService.isarApi
          .enableAttendance(businessId: businessId, email: setting.email);
      return callback(true);
    } else {
      return callback(false);
    }
  }

  SettingsService() {
    listenToReactiveValues([_sendDailReport, _enablePrinter, themeMode]);
  }
}
