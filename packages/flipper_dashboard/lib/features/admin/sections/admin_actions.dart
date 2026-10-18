import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:flipper_ui/dialogs/AdminPinDialog.dart';
import 'package:flutter/material.dart';
import 'package:supabase_models/brick/repository/storage.dart';
import 'package:supabase_models/sync/ditto_sync_coordinator.dart';

/// What Admin Control's toggles do, shared by the desktop screen and the phone
/// settings hub so the two can never drift apart.
abstract final class AdminActions {
  static SettingsService get _settings => locator<SettingsService>();
  static LocalStorage get _box => ProxyService.box;

  /// POS and Orders are alternative home apps: turning one on turns the other
  /// off.
  static ({bool pos, bool orders}) defaultApps() => (
    pos: _box.readBool(key: 'isPosDefault') ?? false,
    orders: _box.readBool(key: 'isOrdersDefault') ?? true,
  );

  static void setPosDefault(bool value) {
    if (value) _box.writeBool(key: 'isOrdersDefault', value: false);
    _box.writeBool(key: 'isPosDefault', value: value);
  }

  static void setOrdersDefault(bool value) {
    if (value) _box.writeBool(key: 'isPosDefault', value: false);
    _box.writeBool(key: 'isOrdersDefault', value: value);
  }

  static bool autoAddSearch() =>
      _box.readBool(key: 'enableAutoAddSearch') ?? false;

  static Future<void> setAutoAddSearch(bool value) async {
    await DittoSyncCoordinator.instance.hydrate<Stock>();
    await _box.writeBool(key: 'enableAutoAddSearch', value: value);
  }

  static Future<void> setPriceQuantityAdjustment(bool value) =>
      _settings.togglePriceQuantityAdjustment(
        enabled: value,
        businessId: _box.getBusinessId()!,
      );

  static Future<void> setCurrencyDecimal(bool value) => _settings
      .toggleCurrencyDecimal(enabled: value, businessId: _box.getBusinessId()!);

  static Future<void> setTicketReviewWorkflow(bool value) =>
      _settings.toggleTicketReviewWorkflow(
        enabled: value,
        businessId: _box.getBusinessId()!,
      );

  static Future<void> setSaleExchange(bool value) => _settings
      .toggleSaleExchange(enabled: value, businessId: _box.getBusinessId()!);

  /// Turning the PIN on sets one first if there is none; turning it off asks
  /// for the current one.
  static Future<void> setAdminPinEnabled(
    BuildContext context,
    bool value,
  ) async {
    final settings = _settings;
    final businessId = _box.getBusinessId()!;
    final setting = await settings.settings();
    if (!context.mounted) return;
    if (value) {
      if (setting?.adminPin == null) {
        await showAdminPinDialog(context: context, mode: AdminPinMode.set);
      } else {
        await settings.toggleAdminPin(enabled: true, businessId: businessId);
      }
      return;
    }
    if (setting?.adminPin != null) {
      final confirmed = await showAdminPinDialog(
        context: context,
        mode: AdminPinMode.verify,
        expectedPin: setting!.adminPin,
      );
      if (confirmed != true) return;
    }
    await settings.toggleAdminPin(enabled: false, businessId: businessId);
  }

  /// Asks for the current PIN, then for a new one.
  static Future<void> resetAdminPin(BuildContext context) async {
    final setting = await _settings.settings();
    if (!context.mounted) return;
    final confirmed = await showAdminPinDialog(
      context: context,
      mode: AdminPinMode.verify,
      expectedPin: setting?.adminPin,
    );
    if (confirmed == true && context.mounted) {
      await showAdminPinDialog(context: context, mode: AdminPinMode.set);
    }
  }

  /// True when no admin PIN is set, or the user entered it correctly.
  static Future<bool> verifyAdminPinIfEnabled(BuildContext context) async {
    final settings = _settings;
    final setting = await settings.settings();
    final pin = setting?.adminPin;
    if (!settings.isAdminPinEnabled || pin == null) return true;
    if (!context.mounted) return false;
    final ok = await showAdminPinDialog(
      context: context,
      mode: AdminPinMode.verify,
      expectedPin: pin,
    );
    return ok == true;
  }
}
