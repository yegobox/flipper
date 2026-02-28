import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

class SettingsService with ListenableServiceMixin {
  //  bool sendDailReport = false;
  final _enablePrinter = ReactiveValue<bool>(false);

  final ReactiveValue<ThemeMode> themeMode = ReactiveValue<ThemeMode>(
    ThemeMode.system,
  );
  bool get enablePrinter => _enablePrinter.value;

  void setThemeMode(ThemeMode mode) {
    themeMode.value = mode;
    notifyListeners();
  }

  final _sendDailReport = ReactiveValue<bool>(false);

  bool get sendDailReport => _sendDailReport.value;

  final _isAttendanceEnabled = ReactiveValue<bool>(false);

  bool get isAttendanceEnabled => _isAttendanceEnabled.value;

  final _isAdminPinEnabled = ReactiveValue<bool>(false);
  bool get isAdminPinEnabled => _isAdminPinEnabled.value;

  final _enablePriceQuantityAdjustment = ReactiveValue<bool>(false);
  bool get enablePriceQuantityAdjustment =>
      _enablePriceQuantityAdjustment.value;

  Future<bool> updateSettings({required Map map}) async {
    String? userId = ProxyService.box.getUserId();
    String? businessId = map['businessId'] ?? ProxyService.box.getBusinessId();

    if (userId == null || businessId == null) return false;

    Setting? setting = await ProxyService.getStrategy(
      Strategy.capella,
    ).getSetting(businessId: businessId);
    if (setting != null) {
      if (map.containsKey('email')) setting.email = map['email'];
      if (map.containsKey('hasPin')) setting.hasPin = map['hasPin'];
      if (map.containsKey('adminPin')) setting.adminPin = map['adminPin'];
      if (map.containsKey('isAdminPinEnabled')) {
        setting.isAdminPinEnabled = map['isAdminPinEnabled'];
      }
      if (map.containsKey('type')) setting.type = map['type'];
      if (map.containsKey('attendnaceDocCreated')) {
        setting.attendnaceDocCreated = map['attendnaceDocCreated'];
      }
      if (map.containsKey('sendDailyReport')) {
        setting.sendDailyReport = map['sendDailyReport'];
      }
      if (map.containsKey('openReceiptFileOSaleComplete')) {
        setting.openReceiptFileOSaleComplete =
            map['openReceiptFileOSaleComplete'];
      }
      if (map.containsKey('autoPrint')) setting.autoPrint = map['autoPrint'];
      if (map.containsKey('isAttendanceEnabled')) {
        setting.isAttendanceEnabled = map['isAttendanceEnabled'];
      }
      if (map.containsKey('enablePriceQuantityAdjustment')) {
        setting.enablePriceQuantityAdjustment =
            map['enablePriceQuantityAdjustment'];
        _enablePriceQuantityAdjustment.value =
            map['enablePriceQuantityAdjustment'];
      }

      await ProxyService.strategy.patchSettings(setting: setting);
      return true;
    } else {
      Setting newSetting = Setting(
        email: map['email'] ?? '',
        userId: userId,
        hasPin: map['hasPin'] ?? false,
        adminPin: map['adminPin'],
        isAdminPinEnabled: map['isAdminPinEnabled'] ?? false,
        type: map['type'] ?? '',
        businessId: businessId,
        attendnaceDocCreated: map['attendnaceDocCreated'] ?? false,
        sendDailyReport: map['sendDailyReport'] ?? false,
        openReceiptFileOSaleComplete:
            map['openReceiptFileOSaleComplete'] ?? false,
        autoPrint: map['autoPrint'] ?? false,
        isAttendanceEnabled: map['isAttendanceEnabled'] ?? false,
        enablePriceQuantityAdjustment:
            map['enablePriceQuantityAdjustment'] ?? false,
      );

      await ProxyService.getStrategy(
        Strategy.capella,
      ).patchSettings(setting: newSetting);
      return true;
    }
  }

  Future<Setting?> settings() async {
    return ProxyService.getStrategy(
      Strategy.capella,
    ).getSetting(businessId: ProxyService.box.getBusinessId() ?? "");
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
      _sendDailReport.value = setting.sendDailyReport == null
          ? false
          : setting.sendDailyReport!;
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
      _isAttendanceEnabled.value = !(setting.isAttendanceEnabled ?? false);

      await updateSettings(
        map: {
          'isAttendanceEnabled': _isAttendanceEnabled.value,
          'businessId': setting.businessId,
        },
      );
      notifyListeners();
    }
  }

  void toggleDailyReportSetting() async {
    Setting? setting = await settings();
    if (setting != null) {
      _sendDailReport.value = !(setting.sendDailyReport ?? false);

      await updateSettings(
        map: {
          'sendDailyReport': _sendDailReport.value,
          'businessId': setting.businessId,
        },
      );
      notifyListeners();
    }
  }

  Future<Function?> enableAttendance({
    required bool bool,
    required Function callback,
  }) async {
    Setting? setting = await settings();
    if (setting != null) {
      // String businessId = ProxyService.box.getBusinessId()!;
      // await ProxyService.strategy
      //     .enableAttendance(businessId: businessId, email: setting.email!);
      return callback(true);
    } else {
      return callback(false);
    }
  }

  void getAdminPinToggleState() async {
    Setting? setting = await settings();
    if (setting != null) {
      _isAdminPinEnabled.value = setting.isAdminPinEnabled ?? false;
    }
  }

  void getPriceQuantityAdjustmentToggleState() async {
    Setting? setting = await settings();
    if (setting != null) {
      _enablePriceQuantityAdjustment.value =
          setting.enablePriceQuantityAdjustment ?? false;
    }
  }

  Future<void> togglePriceQuantityAdjustment({
    required bool enabled,
    required String businessId,
  }) async {
    await updateSettings(
      map: {'enablePriceQuantityAdjustment': enabled, 'businessId': businessId},
    );
    _enablePriceQuantityAdjustment.value = enabled;
    notifyListeners();
  }

  Future<void> setAdminPin({
    required String pin,
    required String businessId,
  }) async {
    await updateSettings(
      map: {
        'adminPin': pin,
        'isAdminPinEnabled': true,
        'businessId': businessId,
      },
    );
    _isAdminPinEnabled.value = true;
    notifyListeners();
  }

  Future<void> toggleAdminPin({
    required bool enabled,
    required String businessId,
  }) async {
    await updateSettings(
      map: {'isAdminPinEnabled': enabled, 'businessId': businessId},
    );
    _isAdminPinEnabled.value = enabled;
    notifyListeners();
  }

  SettingsService() {
    listenToReactiveValues([
      _sendDailReport,
      _enablePrinter,
      themeMode,
      _isAdminPinEnabled,
      _enablePriceQuantityAdjustment,
    ]);
  }
}
