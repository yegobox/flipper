import 'dart:async';

import 'package:flipper_models/services/bar_mode_branch_settings_service.dart';
import 'package:flipper_services/proxy.dart';

/// Bar Mode settings — branch-synced via Ditto with a local cache ([ProxyService.box]).
abstract final class BarModeSettings {
  static const enabledKey = BarModeBranchSettingsService.enabledKey;
  static const launchOnStartKey = BarModeBranchSettingsService.launchOnStartKey;
  static const requirePinKey = BarModeBranchSettingsService.requirePinKey;
  static const floorFirstKey = BarModeBranchSettingsService.floorFirstKey;
  static const managerSettleKey = BarModeBranchSettingsService.managerSettleKey;
  static const autoLogoutKey = BarModeBranchSettingsService.autoLogoutKey;

  static bool get enabled => ProxyService.box.readBool(key: enabledKey) ?? false;

  /// When true, post-login opens [BarModeHost]. Kept in sync with [enabled] for the branch.
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

  static Future<void> hydrateForActiveBranch() =>
      BarModeBranchSettingsService.hydrateForActiveBranch();

  static void startWatchingActiveBranch() =>
      BarModeBranchSettingsService.startWatchingActiveBranch();

  static void setEnabled(bool value) {
    ProxyService.box.writeBool(key: enabledKey, value: value);
    ProxyService.box.writeBool(key: launchOnStartKey, value: value);
    unawaited(BarModeBranchSettingsService.persistCurrentBranch());
  }

  static void setLaunchOnStart(bool value) {
    ProxyService.box.writeBool(key: launchOnStartKey, value: value);
    unawaited(BarModeBranchSettingsService.persistCurrentBranch());
  }

  static void setRequirePin(bool value) {
    ProxyService.box.writeBool(key: requirePinKey, value: value);
    unawaited(BarModeBranchSettingsService.persistCurrentBranch());
  }

  static void setFloorFirst(bool value) {
    ProxyService.box.writeBool(key: floorFirstKey, value: value);
    unawaited(BarModeBranchSettingsService.persistCurrentBranch());
  }

  static void setManagerSettle(bool value) {
    ProxyService.box.writeBool(key: managerSettleKey, value: value);
    unawaited(BarModeBranchSettingsService.persistCurrentBranch());
  }

  static void setAutoLogout(bool value) {
    ProxyService.box.writeBool(key: autoLogoutKey, value: value);
    unawaited(BarModeBranchSettingsService.persistCurrentBranch());
  }
}
