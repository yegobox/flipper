import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/realm_model_export.dart';
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
    int userId = ProxyService.box.getUserId()!;
    int businessId = ProxyService.box.getBusinessId()!;

    Setting? setting =
        await ProxyService.strategy.getSetting(businessId: businessId);
    if (setting != null) {
      Map<String, dynamic> settingsMap = setting as Map<String, dynamic>;
      //replace a key in settings_map if the key match with the key from map

      settingsMap.forEach((key, value) {
        if (map.containsKey(key)) {
          settingsMap[key] = map[key];
        }
      });

      return true;
    } else {
      Map kMap = map;
      map.forEach((key, value) {
        kMap[key] = value;
      });
      Setting setting = Setting(
        id: randomNumber(),
        email: kMap['email'] ?? '',
        userId: userId,
        hasPin: kMap['hasPin'] ?? false,
        type: kMap['type'] ?? '',
        businessId: ProxyService.box.getBusinessId(),
        attendnaceDocCreated: kMap['attendnaceDocCreated'] ?? false,
        sendDailyReport: kMap['sendDailyReport'] ?? false,
        openReceiptFileOSaleComplete:
            kMap['openReceiptFileOSaleComplete'] ?? false,
        autoPrint: kMap['autoPrint'] ?? false,
        isAttendanceEnabled: kMap['isAttendanceEnabled'] ?? false,
      );

      return true;
    }
  }

  Future<Setting?> settings() async {
    return ProxyService.strategy
        .getSetting(businessId: ProxyService.box.getBusinessId() ?? 0);
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
        userId: setting.userId,
        id: setting.id,
        email: setting.email,
        businessId: setting.businessId,
        hasPin: setting.hasPin,
        type: setting.type,
        attendnaceDocCreated: setting.attendnaceDocCreated,
        sendDailyReport: setting.sendDailyReport!,
        openReceiptFileOSaleComplete: setting.openReceiptFileOSaleComplete,
        autoPrint: setting.autoPrint,
        isAttendanceEnabled: _isAttendanceEnabled.value,
      );
      updateSettings(map: setting as Map<String, dynamic>);
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
        userId: setting.userId,
        email: setting.email,
        businessId: setting.businessId,
        hasPin: setting.hasPin,
        type: setting.type,
        attendnaceDocCreated: setting.attendnaceDocCreated,
        sendDailyReport: _sendDailReport.value,
        openReceiptFileOSaleComplete: setting.openReceiptFileOSaleComplete,
        autoPrint: setting.autoPrint,
      );
      updateSettings(map: setting as Map<String, dynamic>);
      notifyListeners();
    }
  }

  Future<Function?> enableAttendance(
      {required bool bool, required Function callback}) async {
    Setting? setting = await settings();
    if (setting != null) {
      // int businessId = ProxyService.box.getBusinessId()!;
      // await ProxyService.strategy
      //     .enableAttendance(businessId: businessId, email: setting.email!);
      return callback(true);
    } else {
      return callback(false);
    }
  }

  SettingsService() {
    listenToReactiveValues([_sendDailReport, _enablePrinter, themeMode]);
  }
}
