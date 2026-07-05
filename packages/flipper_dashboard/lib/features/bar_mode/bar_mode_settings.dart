import 'package:flipper_services/proxy.dart';

/// Device-local Bar Mode settings (ProxyService.box).
abstract final class BarModeSettings {
  static const enabledKey = 'barModeEnabled';
  static const launchOnStartKey = 'barModeLaunchOnStart';
  static const requirePinKey = 'barRequirePin';
  static const floorFirstKey = 'barFloorFirst';
  static const managerSettleKey = 'barManagerSettle';
  static const autoLogoutKey = 'barAutoLogout';

  static bool get enabled => ProxyService.box.readBool(key: enabledKey) ?? false;

  /// When true, post-login / payment verification opens [BarModeHost] instead of POS.
  static bool get launchOnStart =>
      ProxyService.box.readBool(key: launchOnStartKey) ?? false;

  static bool get requirePin =>
      ProxyService.box.readBool(key: requirePinKey) ?? true;

  static bool get floorFirst =>
      ProxyService.box.readBool(key: floorFirstKey) ?? true;

  static bool get managerSettle =>
      ProxyService.box.readBool(key: managerSettleKey) ?? true;

  static bool get autoLogout =>
      ProxyService.box.readBool(key: autoLogoutKey) ?? false;

  static void setEnabled(bool value) {
    ProxyService.box.writeBool(key: enabledKey, value: value);
    if (!value) {
      ProxyService.box.writeBool(key: launchOnStartKey, value: false);
    }
  }

  static void setLaunchOnStart(bool value) =>
      ProxyService.box.writeBool(key: launchOnStartKey, value: value);

  static void setRequirePin(bool value) =>
      ProxyService.box.writeBool(key: requirePinKey, value: value);

  static void setFloorFirst(bool value) =>
      ProxyService.box.writeBool(key: floorFirstKey, value: value);

  static void setManagerSettle(bool value) =>
      ProxyService.box.writeBool(key: managerSettleKey, value: value);

  static void setAutoLogout(bool value) =>
      ProxyService.box.writeBool(key: autoLogoutKey, value: value);
}
