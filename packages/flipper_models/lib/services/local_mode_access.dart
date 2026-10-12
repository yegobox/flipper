import 'package:flipper_models/services/local_mode_server.dart';

/// What a login may do, given where a business keeps its data.
enum LocalModeAccess {
  /// Carry on as usual.
  allowed,

  /// The business is offline-only and its data is on another device.
  offlineElsewhere,

  /// This device holds another business's offline-only data.
  deviceHeldByOtherBusiness,

  /// This device was the business's offline device, but sync has since been
  /// turned on from another one: this device should follow.
  syncTurnedOnElsewhere,

  /// This device is offline-only but the server never confirmed it (signup
  /// lost the connection): record it again and carry on.
  registerLocal,
}

/// Decides [LocalModeAccess] for [businessId] from the server's record
/// ([server], null when it could not be read) and this device's local-mode
/// marker ([marker], null when the device is not in local mode).
///
/// An unreadable server never blocks: an offline login can only open data
/// that is already on this device.
LocalModeAccess decideLocalModeAccess({
  required String businessId,
  required BusinessSyncState? server,
  required Map<String, dynamic>? marker,
}) {
  if (marker != null) {
    final owner = marker['businessId'] as String?;
    if (owner != null && owner != businessId) {
      return LocalModeAccess.deviceHeldByOtherBusiness;
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
