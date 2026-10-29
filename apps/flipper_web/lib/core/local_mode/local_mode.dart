import 'dart:async';

import 'package:flutter/foundation.dart';

import 'local_mode_marker.dart';

/// Local mode: this device keeps its data in Ditto only. Nothing syncs to the
/// cloud, there is no paywall, and EBM and Flo are unavailable.
///
/// It is a property of the device's Ditto store, not of a user or business:
/// every login on the device shares that store (staff PIN logins included), so
/// a per-user flag would let one login reopen the store with cloud sync and
/// upload everything. The flag is a marker file inside the store directory, so
/// it survives logout and `box.clear()`, and disappears with the store.
///
/// Chosen only at signup ([enable]); opting back in to sync is one-way
/// ([disable]). Native only — Ditto on the web is cloud-only.
class LocalMode {
  LocalMode._();

  static bool _on = false;
  static bool _loaded = false;
  static Future<bool>? _loading;

  /// Whether this device runs in local mode. Synchronous: [load] runs at boot
  /// (and before Ditto opens), so it is only `false` before then.
  static bool get isOn => _on;

  /// Notifies the UI when the mode flips (signup, opt-in).
  static final ValueNotifier<bool> changes = ValueNotifier<bool>(false);

  /// Reads the marker once. Safe to call repeatedly: concurrent callers share
  /// the one read, so none of them sees `false` while it is still running.
  static Future<bool> load() {
    if (_loaded) return Future.value(_on);
    if (kIsWeb) {
      _loaded = true;
      return Future.value(_on);
    }
    return _loading ??= _readMarker();
  }

  static Future<bool> _readMarker() async {
    try {
      // An existing but unreadable marker reads as local mode (see
      // [readLocalModeMarker]). Only a store directory that can't be resolved
      // lands here, and Ditto can't open that directory either.
      _set(await readLocalModeMarker() != null);
      _loaded = true;
    } catch (e) {
      debugPrint('LocalMode: marker read failed, will retry: $e');
    } finally {
      _loading = null;
    }
    return _on;
  }

  /// Turns local mode on for this device. Call at signup, before Ditto opens
  /// for the new user.
  ///
  /// Throws [LocalModeDeviceHeldException] when the store already belongs to
  /// another business: overwriting the marker would hand that business's data
  /// to the new one.
  static Future<void> enable({String? businessId}) async {
    if (kIsWeb) return;
    final heldBy = (await readLocalModeMarker())?['businessId'];
    if (heldBy != null && heldBy != businessId) {
      throw const LocalModeDeviceHeldException();
    }
    await writeLocalModeMarker({
      if (businessId != null) 'businessId': businessId,
      'enabledAt': DateTime.now().toUtc().toIso8601String(),
    });
    _loaded = true;
    _set(true);
  }

  /// Opts this device back in to full sync. Re-open Ditto afterwards.
  static Future<void> disable() async {
    if (kIsWeb) return;
    await deleteLocalModeMarker();
    _loaded = true;
    _set(false);
  }

  /// The marker's contents (`businessId`, `enabledAt`, `serverChangedAt`),
  /// or null when this device is not in local mode.
  static Future<Map<String, dynamic>?> marker() async {
    if (kIsWeb) return null;
    return readLocalModeMarker();
  }

  /// Records which business owns this device's data and, once the server has
  /// confirmed the business is local, when it did. A device that saw the server
  /// confirm local mode and later finds it full knows sync was turned on from
  /// another device.
  static Future<void> recordServerState({
    required String businessId,
    DateTime? serverChangedAt,
  }) async {
    if (kIsWeb || !_on) return;
    final current = await readLocalModeMarker() ?? const {};
    await writeLocalModeMarker({
      ...current,
      'businessId': businessId,
      if (serverChangedAt != null)
        'serverChangedAt': serverChangedAt.toUtc().toIso8601String(),
    });
  }

  static const _cloudAllowedKey = #flipperLocalModeCloudAllowed;

  /// Runs [body] with permission to reach the server while local mode is on.
  /// Only for the calls that record the mode itself (`businesses.sync_mode`);
  /// every other Supabase write is held on the device.
  static Future<T> allowCloud<T>(Future<T> Function() body) =>
      runZoned(body, zoneValues: {_cloudAllowedKey: true});

  /// Whether the current call runs inside [allowCloud].
  static bool get cloudAllowedHere => Zone.current[_cloudAllowedKey] == true;

  static void _set(bool on) {
    _on = on;
    changes.value = on;
  }

  @visibleForTesting
  static void debugSet(bool on) {
    _loaded = true;
    _set(on);
  }

  /// Forgets the loaded state, so the next [load] reads the marker again.
  @visibleForTesting
  static void debugReset() {
    _loaded = false;
    _loading = null;
    _set(false);
  }
}

/// This device's store already keeps another business's data offline, so it
/// can't take a new business until that one turns on cloud sync.
class LocalModeDeviceHeldException implements Exception {
  const LocalModeDeviceHeldException();

  @override
  String toString() => 'LocalModeDeviceHeldException';
}
