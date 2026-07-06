import 'dart:async';

import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/models/bar_branch_settings.dart';
import 'package:flipper_services/proxy.dart';

/// Syncs Bar Mode settings per branch via Ditto (`bar_branch_settings`).
///
/// Local [ProxyService.box] keys remain the read cache for synchronous UI;
/// this service hydrates them from the branch document and persists changes back.
abstract final class BarModeBranchSettingsService {
  static const enabledKey = 'barModeEnabled';
  static const launchOnStartKey = 'barModeLaunchOnStart';
  static const requirePinKey = 'barRequirePin';
  static const floorFirstKey = 'barFloorFirst';
  static const managerSettleKey = 'barManagerSettle';
  static const autoLogoutKey = 'barAutoLogout';

  static StreamSubscription<BarBranchSettings?>? _watchSub;

  static dynamic get _sync => ProxyService.getStrategy(Strategy.capella);

  /// Pull branch settings from Ditto into the local cache (call after login / branch switch).
  static Future<void> hydrateForActiveBranch() async {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) return;

    try {
      final remote = await _sync.barBranchSettings(branchId: branchId);
      if (remote != null) {
        _applyToLocalCache(remote);
        return;
      }

      // One-time migration: device had bar mode on before branch sync existed.
      if (_readLocalEnabled()) {
        await persistCurrentBranch();
      }
    } catch (e, s) {
      talker.warning('Bar branch settings hydrate failed: $e\n$s');
    }
  }

  /// Persist the current local cache to Ditto for the active branch.
  static Future<void> persistCurrentBranch() async {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) return;

    final settings = BarBranchSettings(
      branchId: branchId,
      enabled: _readLocalEnabled(),
      requirePin: ProxyService.box.readBool(key: requirePinKey) ?? true,
      floorFirst: ProxyService.box.readBool(key: floorFirstKey) ?? true,
      managerSettle: ProxyService.box.readBool(key: managerSettleKey) ?? true,
      autoLogout: ProxyService.box.readBool(key: autoLogoutKey) ?? false,
    );

    try {
      await _sync.saveBarBranchSettings(settings);
    } catch (e, s) {
      talker.error('Bar branch settings persist failed: $e\n$s');
      rethrow;
    }
  }

  /// Live-sync remote changes into the local cache while the app runs.
  static void startWatchingActiveBranch() {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) return;

    unawaited(_watchSub?.cancel());
    _watchSub = _sync
        .barBranchSettingsStream(branchId: branchId)
        .listen((settings) {
      if (settings != null) {
        _applyToLocalCache(settings);
      }
    }, onError: (Object e, StackTrace s) {
      talker.warning('Bar branch settings watch error: $e\n$s');
    });
  }

  static Future<void> stopWatching() async {
    await _watchSub?.cancel();
    _watchSub = null;
  }

  static bool _readLocalEnabled() =>
      ProxyService.box.readBool(key: enabledKey) ?? false;

  static void _applyToLocalCache(BarBranchSettings settings) {
    final box = ProxyService.box;
    box.writeBool(key: enabledKey, value: settings.enabled);
    box.writeBool(
      key: launchOnStartKey,
      value: settings.enabled,
    );
    box.writeBool(key: requirePinKey, value: settings.requirePin);
    box.writeBool(key: floorFirstKey, value: settings.floorFirst);
    box.writeBool(key: managerSettleKey, value: settings.managerSettle);
    box.writeBool(key: autoLogoutKey, value: settings.autoLogout);
  }
}
