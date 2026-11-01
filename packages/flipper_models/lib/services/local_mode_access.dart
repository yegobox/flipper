import 'package:flipper_models/services/local_mode_server.dart';
import 'package:flipper_web/core/local_mode/local_mode_marker_keys.dart';

/// What a login may do, given where a business keeps its data.
enum LocalModeAccess {
  /// Carry on as usual.
  allowed,

  /// The business is offline-only and its data is on another device.
  offlineElsewhere,

  /// This device holds another business's offline-only data.
  deviceHeldByOtherBusiness,

  /// This device's marker names another business, but the server does not
  /// keep that business's data here (it is in the cloud, gone, or on another
  /// device): the marker is stale, so this device leaves local mode.
  releaseStaleHold,

  /// This device was the business's offline device, but sync has since been
  /// turned on from another one: this device should follow.
  syncTurnedOnElsewhere,

  /// This device is offline-only but the server never confirmed it (signup
  /// lost the connection): record it again and carry on.
  registerLocal,

  /// This device's marker was unreadable, and the server says this business
  /// is offline on this very device: write the owner back and carry on.
  recoverOwner,
}

/// Decides [LocalModeAccess] for [businessId] from the server's record
/// ([server], null when it could not be read) and this device's local-mode
/// marker ([marker], null when the device is not in local mode).
///
/// An unreadable server never blocks: an offline login can only open data
/// that is already on this device.
///
/// [thisDeviceId] is this device's store id ([BusinessSyncState.deviceId]);
/// it identifies the owner of a store whose marker could not be read.
///
/// [ownerServer] is the server's record of the business the marker names,
/// when that is not [businessId] (null when it could not be read). Only a
/// record placing that business on this store keeps the device held.
LocalModeAccess decideLocalModeAccess({
  required String businessId,
  required BusinessSyncState? server,
  required Map<String, dynamic>? marker,
  String? thisDeviceId,
  BusinessSyncState? ownerServer,
}) {
  if (marker != null && marker[kLocalModeMarkerUnreadable] == true) {
    // The owner is unknown, not absent: only the server can name it.
    if (server == null) return LocalModeAccess.allowed;
    final ownsThisDevice =
        server.isLocal &&
        server.deviceId != null &&
        server.deviceId == thisDeviceId;
    return ownsThisDevice
        ? LocalModeAccess.recoverOwner
        : LocalModeAccess.deviceHeldByOtherBusiness;
  }
  if (marker != null) {
    final owner = marker['businessId'] as String?;
    if (owner != null && owner != businessId) {
      // Unverifiable, so the owner's data may be here only: stay held.
      if (ownerServer == null) return LocalModeAccess.deviceHeldByOtherBusiness;
      // Only a store id on both sides can prove the data is elsewhere; a
      // record naming no store (older devices) may mean this one.
      final heldHere =
          ownerServer.isLocal &&
          (ownerServer.deviceId == null ||
              thisDeviceId == null ||
              ownerServer.deviceId == thisDeviceId);
      return heldHere
          ? LocalModeAccess.deviceHeldByOtherBusiness
          : LocalModeAccess.releaseStaleHold;
    }
    if (server == null || server.isLocal) return LocalModeAccess.allowed;
    // Signup never recorded its business (it died first): don't claim this
    // one for local mode on that evidence.
    if (owner == null) return LocalModeAccess.allowed;
    // The server says full. If it once confirmed local, something turned sync
    // on since; if it never did, our registration was lost.
    return marker['serverChangedAt'] == null
        ? LocalModeAccess.registerLocal
        : LocalModeAccess.syncTurnedOnElsewhere;
  }
  if (server != null && server.isLocal) return LocalModeAccess.offlineElsewhere;
  return LocalModeAccess.allowed;
}
