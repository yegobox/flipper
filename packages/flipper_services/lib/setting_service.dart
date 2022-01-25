import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/models/models.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SettingsService with ReactiveServiceMixin {
  final log = getLogger('SettingsService');
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
        await ProxyService.api.getSetting(userId: int.parse(userId));
    if (setting != null) {
      Map<String, dynamic> settings_map = setting.toJson();
      //replace a key in settings_map if the key match with the key from map
      settings_map.forEach((key, value) {
        if (map.containsKey(key)) {
          settings_map[key] = map[key];
        }
      });
      int id = setting.id;
      // log.d(map['isAttendanceEnabled']);
      ProxyService.api.update(data: settings_map, endPoint: 'settings/$id');
      return true;
    } else {
      Map kMap = map;
      map.forEach((key, value) {
        kMap[key] = value;
      });
      Setting setting = new Setting(
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
      await ProxyService.api.createSetting(setting: setting);
      return true;
    }
  }

  Setting? get settings => ProxyService.api.getSetting(
      userId: int.parse(ProxyService.box.read(key: 'userId') ?? '0'));

  bool isDailyReportEnabled() {
    if (settings != null) {
      return settings!.sendDailyReport == true;
    } else {
      return false;
    }
  }

  bool enabledPrint() {
    if (settings != null) {
      return settings!.autoPrint == true;
    } else {
      return false;
    }
  }

  void enablePrint({required bool bool}) async {
    await updateSettings(map: {'autoPrint': bool});
  }

  void getEnableReportToggleState() {
    if (settings != null) {
      _sendDailReport.value = settings!.sendDailyReport == null
          ? false
          : settings!.sendDailyReport!;
    }
  }

  void getEnableAttendanceToggleState() {
    if (settings != null) {
      _isAttendanceEnabled.value = settings!.isAttendanceEnabled == null
          ? false
          : settings!.isAttendanceEnabled!;
    }
  }

  void toggleAttendanceSetting() {
    if (settings != null) {
      _isAttendanceEnabled.value = settings!.isAttendanceEnabled == null
          ? false
          : !settings!.isAttendanceEnabled!;

      Setting setting = new Setting(
        id: settings!.id,
        email: settings!.email,
        userId: settings!.userId,
        hasPin: settings!.hasPin,
        googleSheetDocCreated: settings!.googleSheetDocCreated,
        attendnaceDocCreated: settings!.attendnaceDocCreated,
        sendDailyReport: settings!.sendDailyReport!,
        openReceiptFileOSaleComplete: settings!.openReceiptFileOSaleComplete,
        autoPrint: settings!.autoPrint,
        isAttendanceEnabled: _isAttendanceEnabled.value,
      );
      updateSettings(map: setting.toJson());
      notifyListeners();
    }
  }

  void toggleDailyReportSetting() {
    if (settings != null) {
      _sendDailReport.value = settings!.sendDailyReport == null
          ? false
          : !settings!.sendDailyReport!;
      Setting setting = new Setting(
        id: settings!.id,
        email: settings!.email,
        userId: settings!.userId,
        hasPin: settings!.hasPin,
        googleSheetDocCreated: settings!.googleSheetDocCreated,
        attendnaceDocCreated: settings!.attendnaceDocCreated,
        sendDailyReport: _sendDailReport.value,
        openReceiptFileOSaleComplete: settings!.openReceiptFileOSaleComplete,
        autoPrint: settings!.autoPrint,
      );
      updateSettings(map: setting.toJson());
      notifyListeners();
    }
  }

  Future<Function?> enableAttendance(
      {required bool bool, required Function callback}) async {
    if (settings != null) {
      int businessId = ProxyService.box.read(key: 'businessId');
      await ProxyService.api
          .enableAttendance(businessId: businessId, email: settings!.email);
      return callback(true);
    } else {
      return callback(false);
    }
  }

  SettingsService() {
    listenToReactiveValues([_sendDailReport, _enablePrinter, themeMode]);
  }
}
