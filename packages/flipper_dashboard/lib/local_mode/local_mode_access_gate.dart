import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/services/local_mode_access.dart';
import 'package:flipper_models/services/local_mode_controller.dart';
import 'package:flipper_models/services/local_mode_server.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/Miscellaneous.dart';
import 'package:flipper_web/core/local_mode/local_mode.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:stacked_services/stacked_services.dart';

/// Stops a login from opening a business whose data is not on this device
/// (local mode), before the paywall or the home screen.
///
/// Registered as `PaymentVerificationNavigator.entryGate`. Returns true when
/// it took over navigation (the user was signed out).
class LocalModeAccessGate {
  LocalModeAccessGate._();

  /// Checked once per business per session: the answer only changes when
  /// someone switches a device's mode, which ends the session anyway.
  static String? _passedFor;

  static Future<bool> blocksEntry(String? businessId) async {
    if (kIsWeb || businessId == null || businessId.isEmpty) return false;
    if (_passedFor == businessId) return false;

    final marker = await LocalMode.marker();
    final server = await LocalModeServer.fetch(businessId);
    final access = decideLocalModeAccess(
      businessId: businessId,
      server: server,
      marker: marker,
      thisDeviceName: LocalModeController.deviceName(),
    );
    talker.info('Local mode access for $businessId: $access');

    switch (access) {
      case LocalModeAccess.allowed:
        _passedFor = businessId;
        return false;
      case LocalModeAccess.registerLocal:
        _passedFor = businessId;
        await LocalModeController.registerOnServer(businessId);
        return false;
      case LocalModeAccess.recoverOwner:
        _passedFor = businessId;
        await LocalModeController.recoverOwner(server!, businessId);
        return false;
      case LocalModeAccess.offlineElsewhere:
        return _offlineElsewhere(businessId, server!);
      case LocalModeAccess.deviceHeldByOtherBusiness:
        final l10n = FlipperL10n.current;
        await _dialog(
          title: l10n.localModeDeviceHeldTitle,
          description: l10n.localModeDeviceHeldBody,
          button: l10n.signOut,
        );
        await _signOut();
        return true;
      case LocalModeAccess.syncTurnedOnElsewhere:
        final l10n = FlipperL10n.current;
        await LocalModeController.adoptSyncFromElsewhere();
        await _dialog(
          title: l10n.localModeSyncOnElsewhereTitle,
          description: l10n.localModeSyncOnElsewhereBody,
          button: l10n.ok,
        );
        // Ditto opened local-only this session; the next login opens it with
        // the cloud connect and uploads this device's data.
        await _signOut();
        return true;
    }
  }

  /// The business keeps its data on another device. The user can sign out,
  /// or give that device up (lost, reset) and turn on sync from here, which
  /// then shows the plan picker like any new business.
  static Future<bool> _offlineElsewhere(
    String businessId,
    BusinessSyncState server,
  ) async {
    final l10n = FlipperL10n.current;
    final device = (server.deviceName?.trim().isNotEmpty ?? false)
        ? server.deviceName!.trim()
        : l10n.localModeElsewhereUnknownDevice;
    final response = await _dialog(
      title: l10n.localModeElsewhereTitle,
      description: l10n.localModeElsewhereBody(device),
      button: l10n.localModeElsewhereUseHere,
      cancel: l10n.signOut,
    );
    if (response?.confirmed == true) {
      final (result, _) = await LocalModeServer.setMode(
        businessId,
        local: false,
      );
      if (result != SyncModeWrite.failed) {
        _passedFor = businessId;
        return false;
      }
      talker.warning('Could not turn on sync for $businessId from here');
    }
    await _signOut();
    return true;
  }

  static Future<DialogResponse?> _dialog({
    required String title,
    required String description,
    required String button,
    String? cancel,
  }) => locator<DialogService>().showDialog(
    title: title,
    description: description,
    buttonTitle: button,
    cancelTitle: cancel,
    barrierDismissible: false,
  );

  /// Same core as `completeDashboardSignOut`, without the shift prompt: a
  /// device refused entry never opened a shift in this business.
  static Future<void> _signOut() async {
    _passedFor = null;
    try {
      await CoreMiscellaneous.logoutStatic().timeout(
        const Duration(seconds: 20),
      );
    } catch (_) {
      // Still go to login — local session keys are cleared best-effort.
    }
    locator<RouterService>().clearStackAndShow(LoginRoute());
  }
}
