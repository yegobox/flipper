import 'dart:async';

import 'package:flipper_models/services/hotel_mode_branch_settings_service.dart';
import 'package:flipper_services/proxy.dart';

/// Hotel Mode settings — branch-synced via Ditto with a local cache
/// ([ProxyService.box]), mirroring [BarModeSettings].
abstract final class HotelModeSettings {
  static const enabledKey = HotelModeBranchSettingsService.enabledKey;
  static const launchOnStartKey =
      HotelModeBranchSettingsService.launchOnStartKey;
  static const autoPostRoomChargeKey =
      HotelModeBranchSettingsService.autoPostRoomChargeKey;
  static const managerCheckoutKey =
      HotelModeBranchSettingsService.managerCheckoutKey;
  static const requirePinKey = HotelModeBranchSettingsService.requirePinKey;
  static const autoLogoutKey = HotelModeBranchSettingsService.autoLogoutKey;
  static const checkOutHourKey = HotelModeBranchSettingsService.checkOutHourKey;
  static const roomChargeVariantKey =
      HotelModeBranchSettingsService.roomChargeVariantKey;

  static bool get enabled => ProxyService.box.readBool(key: enabledKey) ?? false;

  /// When true, post-login opens the front desk instead of POS.
  static bool get launchOnStart =>
      ProxyService.box.readBool(key: launchOnStartKey) ?? false;

  static bool get autoPostRoomCharge =>
      ProxyService.box.readBool(key: autoPostRoomChargeKey) ?? true;

  static bool get managerCheckout =>
      ProxyService.box.readBool(key: managerCheckoutKey) ?? true;

  /// Lock the desk behind a staff PIN so one terminal can be shared.
  static bool get requirePin =>
      ProxyService.box.readBool(key: requirePinKey) ?? true;

  /// Return to the PIN lock once a checkout completes.
  static bool get autoLogout =>
      ProxyService.box.readBool(key: autoLogoutKey) ?? false;

  static int get checkOutHour =>
      ProxyService.box.readInt(key: checkOutHourKey) ?? 11;

  static String? get roomChargeVariantId {
    final value = ProxyService.box.readString(key: roomChargeVariantKey);
    return (value == null || value.isEmpty) ? null : value;
  }

  static Future<void> hydrateForActiveBranch() =>
      HotelModeBranchSettingsService.hydrateForActiveBranch();

  static void startWatchingActiveBranch() =>
      HotelModeBranchSettingsService.startWatchingActiveBranch();

  static void setEnabled(bool value) {
    ProxyService.box.writeBool(key: enabledKey, value: value);
    ProxyService.box.writeBool(key: launchOnStartKey, value: value);
    unawaited(HotelModeBranchSettingsService.persistCurrentBranch());
  }

  static void setLaunchOnStart(bool value) {
    ProxyService.box.writeBool(key: launchOnStartKey, value: value);
    unawaited(HotelModeBranchSettingsService.persistCurrentBranch());
  }

  static void setAutoPostRoomCharge(bool value) {
    ProxyService.box.writeBool(key: autoPostRoomChargeKey, value: value);
    unawaited(HotelModeBranchSettingsService.persistCurrentBranch());
  }

  static void setManagerCheckout(bool value) {
    ProxyService.box.writeBool(key: managerCheckoutKey, value: value);
    unawaited(HotelModeBranchSettingsService.persistCurrentBranch());
  }

  static void setRequirePin(bool value) {
    ProxyService.box.writeBool(key: requirePinKey, value: value);
    unawaited(HotelModeBranchSettingsService.persistCurrentBranch());
  }

  static void setAutoLogout(bool value) {
    ProxyService.box.writeBool(key: autoLogoutKey, value: value);
    unawaited(HotelModeBranchSettingsService.persistCurrentBranch());
  }

  static void setCheckOutHour(int value) {
    ProxyService.box.writeInt(key: checkOutHourKey, value: value.clamp(0, 23));
    unawaited(HotelModeBranchSettingsService.persistCurrentBranch());
  }

  static void setRoomChargeVariantId(String? value) {
    ProxyService.box.writeString(
      key: roomChargeVariantKey,
      value: value ?? '',
    );
    unawaited(HotelModeBranchSettingsService.persistCurrentBranch());
  }
}
