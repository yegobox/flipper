import 'dart:io' show Platform;

import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/services/local_mode_server.dart';
import 'package:flipper_services/internet_probe.dart';
import 'package:flipper_web/core/local_mode/local_mode.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:supabase_models/brick/repository.dart';

/// Moves this device in and out of [LocalMode], keeping the other cloud
/// writers and the server's record (`businesses.sync_mode`) in step.
class LocalModeController {
  LocalModeController._();

  /// Signup chose local mode. Runs before `strategy.signup`, so the login it
  /// performs opens Ditto local-only. The Supabase queue already started at
  /// boot, so it is stopped here.
  static Future<void> enterForSignup() async {
    await LocalMode.enable();
    Repository.pauseCloudSync();
    talker.info('Local mode: on (signup)');
  }

  /// Signup knows the business: bind this device to it and tell the server,
  /// so logins on other devices know the data lives here.
  static Future<void> recordBusiness(String businessId) async {
    if (!LocalMode.isOn) return;
    await LocalMode.recordServerState(businessId: businessId);
    await registerOnServer(businessId);
  }

  /// Records `sync_mode = local` for [businessId]. Retried at every startup
  /// until the server confirms it (signup may have lost the connection).
  static Future<void> registerOnServer(String businessId) async {
    if (!LocalMode.isOn) return;
    final (result, state) = await LocalModeServer.setMode(
      businessId,
      local: true,
      deviceName: _deviceName(),
    );
    if (result != SyncModeWrite.saved) {
      talker.warning('Local mode: server registration $result for $businessId');
      return;
    }
    await LocalMode.recordServerState(
      businessId: businessId,
      serverChangedAt: state?.changedAt ?? DateTime.now(),
    );
  }

  /// A failed signup must not leave the device local.
  static Future<void> abortSignup() async {
    if (!LocalMode.isOn) return;
    await LocalMode.disable();
    Repository.resumeCloudSync();
    talker.info('Local mode: rolled back after failed signup');
  }

  /// Opts this device in to full sync. One-way. Returns false when there is
  /// no internet or the server could not record it: the server must say
  /// `full` before the marker goes, or the next login here would read
  /// "offline on another device".
  ///
  /// The caller then logs the user out: the next login reopens the same Ditto
  /// store with the cloud connect (its documents upload), and startup's
  /// payment check shows the plan picker like any new business.
  static Future<bool> optInToSync() async {
    if (!LocalMode.isOn) return true;
    if (!await InternetProbe.isOnline()) return false;
    final businessId = (await LocalMode.marker())?['businessId'] as String?;
    if (businessId != null) {
      final (result, _) = await LocalModeServer.setMode(
        businessId,
        local: false,
      );
      if (result == SyncModeWrite.failed) return false;
    }
    await _leaveLocalMode('opted in to sync');
    return true;
  }

  /// Sync was turned on for this business from another device (the old one
  /// was lost, say). This device follows: its data uploads on the next login
  /// and merges into the cloud copy.
  static Future<void> adoptSyncFromElsewhere() =>
      _leaveLocalMode('sync turned on from another device');

  static Future<void> _leaveLocalMode(String reason) async {
    await LocalMode.disable();
    Repository.resumeCloudSync();
    talker.info('Local mode: off ($reason)');
  }

  static String? _deviceName() {
    if (kIsWeb) return null;
    try {
      return Platform.localHostname;
    } catch (_) {
      return null;
    }
  }
}
