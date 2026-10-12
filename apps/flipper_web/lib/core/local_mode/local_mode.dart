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

  /// Whether this device runs in local mode. Synchronous: [load] runs at boot
  /// (and before Ditto opens), so it is only `false` before then.
  static bool get isOn => _on;

  /// Notifies the UI when the mode flips (signup, opt-in).
  static final ValueNotifier<bool> changes = ValueNotifier<bool>(false);

  /// Reads the marker once. Safe to call repeatedly.
  static Future<bool> load() async {
    if (_loaded) return _on;
    _loaded = true;
    if (kIsWeb) return _on;
    try {
      _set(await readLocalModeMarker() != null);
    } catch (e) {
      debugPrint('LocalMode: marker read failed, assuming full sync: $e');
    }
    return _on;
  }

  /// Turns local mode on for this device. Call at signup, before Ditto opens
  /// for the new user.
  static Future<void> enable({String? businessId}) async {
    if (kIsWeb) return;
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

  /// The business that chose local mode at signup, if any.
  static Future<String?> businessId() async {
    if (kIsWeb) return null;
    return (await readLocalModeMarker())?['businessId'] as String?;
  }

  static void _set(bool on) {
    _on = on;
    changes.value = on;
  }

  @visibleForTesting
  static void debugSet(bool on) {
    _loaded = true;
    _set(on);
  }
}
