import 'dart:io' show Platform;

import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/services/local_mode_access.dart';
import 'package:flipper_models/services/local_mode_server.dart';
import 'package:flipper_services/internet_probe.dart';
import 'package:flipper_web/core/local_mode/local_mode.dart';
import 'package:flipper_web/core/local_mode/local_mode_marker_keys.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:supabase_models/brick/repository.dart';

export 'package:flipper_web/core/local_mode/local_mode.dart'
    show LocalModeDeviceHeldException;

/// How [LocalModeController.optInToSync] ended.
enum CloudSyncOptIn {
  /// Local mode is off; the caller signs the user out to finish.
  done,

  /// No internet, or the server could not record the change. Nothing changed.
  offline,

  /// The store's owner is unknown and the server does not place the signed-in
  /// business on this device. Nothing changed.
  notOwner,
}

/// Moves this device in and out of [LocalMode], keeping the other cloud
/// writers and the server's record (`businesses.sync_mode`) in step.
class LocalModeController {
  LocalModeController._();

  /// Set only when [enterForSignup] turned local mode on, so [abortSignup]
  /// never removes a marker some earlier business owns.
  static bool _enteredForSignup = false;

  /// Signup chose local mode. Runs before `strategy.signup`, so the login it
  /// performs opens Ditto local-only. The Supabase queue already started at
  /// boot, so it is stopped here.
  ///
  /// Throws [LocalModeDeviceHeldException], changing nothing, when this
  /// device's store already belongs to another business.
  static Future<void> enterForSignup() async {
    await LocalMode.enable();
    _enteredForSignup = true;
    Repository.pauseCloudSync();
    talker.info('Local mode: on (signup)');
  }

  /// Signup knows the business: bind this device to it and tell the server,
  /// so logins on other devices know the data lives here.
  static Future<void> recordBusiness(String businessId) async {
    if (!LocalMode.isOn) {
      _enteredForSignup = false;
      return;
    }
    await LocalMode.recordServerState(businessId: businessId);
    // Only now does the marker name its owner; until then a failed signup
    // must still be able to roll local mode back.
    _enteredForSignup = false;
    await registerOnServer(businessId);
  }

  /// The marker was unreadable and the server confirmed [businessId] keeps
  /// its data on this device: write the owner back.
  static Future<void> recoverOwner(
    BusinessSyncState server,
    String businessId,
  ) => LocalMode.recordServerState(
    businessId: businessId,
    serverChangedAt: server.changedAt ?? DateTime.now(),
  );

  /// This device's name as `businesses.local_device_name` records it.
  static String? deviceName() => _deviceName();

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

  /// A failed signup must not leave the device local. Undoes only what
  /// [enterForSignup] did: a store held by another business stays local.
  static Future<void> abortSignup() async {
    if (!_enteredForSignup) return;
    _enteredForSignup = false;
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
  ///
  /// [sessionBusinessId] is the business this session signed in to. It is
  /// needed only when the marker is unreadable: the store then goes to the
  /// cloud only once the server places that business on this device, as at
  /// login ([LocalModeAccess.recoverOwner]).
  static Future<CloudSyncOptIn> optInToSync({String? sessionBusinessId}) async {
    if (!LocalMode.isOn) return CloudSyncOptIn.done;
    final marker = await LocalMode.marker();
    final ownerUnknown = marker?[kLocalModeMarkerUnreadable] == true;
    if (ownerUnknown && sessionBusinessId == null) {
      return CloudSyncOptIn.notOwner;
    }
    if (!await InternetProbe.isOnline()) return CloudSyncOptIn.offline;
    var businessId = marker?['businessId'] as String?;
    if (ownerUnknown) {
      final server = await LocalModeServer.fetch(sessionBusinessId!);
      if (server == null) return CloudSyncOptIn.offline;
      final access = decideLocalModeAccess(
        businessId: sessionBusinessId,
        server: server,
        marker: marker,
        thisDeviceName: _deviceName(),
      );
      if (access != LocalModeAccess.recoverOwner) {
        return CloudSyncOptIn.notOwner;
      }
      await recoverOwner(server, sessionBusinessId);
      businessId = sessionBusinessId;
    }
    if (businessId != null) {
      final (result, _) = await LocalModeServer.setMode(
        businessId,
        local: false,
      );
      if (result == SyncModeWrite.failed) return CloudSyncOptIn.offline;
    }
    await _leaveLocalMode('opted in to sync');
    return CloudSyncOptIn.done;
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
