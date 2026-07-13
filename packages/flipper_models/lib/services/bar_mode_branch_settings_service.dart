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

  /// Pull branch settings from Ditto into the local cache.
  ///
  /// Retries until [timeout] because a fresh device may navigate before Ditto
  /// has finished authenticating or replicating `bar_branch_settings`.
  static Future<void> hydrateForActiveBranch({
    Duration timeout = const Duration(seconds: 12),
  }) async {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) return;

    final deadline = DateTime.now().add(timeout);
    await _waitForDittoReady(deadline);

    while (DateTime.now().isBefore(deadline)) {
      try {
        final remote = await _sync.barBranchSettings(branchId: branchId);
        if (remote != null) {
          _applyToLocalCache(remote);
          talker.info(
            'Bar branch settings hydrated for $branchId (enabled=${remote.enabled})',
          );
          return;
        }
      } catch (e, s) {
        talker.warning('Bar branch settings hydrate attempt failed: $e\n$s');
      }

      final remaining = deadline.difference(DateTime.now());
      if (remaining <= Duration.zero) break;
      final wait = remaining < const Duration(milliseconds: 400)
          ? remaining
          : const Duration(milliseconds: 400);
      await Future.delayed(wait);
    }

    // One-time migration: device had bar mode on before branch sync existed.
    if (_readLocalEnabled()) {
      try {
        await persistCurrentBranch();
      } catch (e, s) {
        talker.warning('Bar branch settings migration persist failed: $e\n$s');
      }
      return;
    }

    talker.info(
      'No bar_branch_settings for branch $branchId after ${timeout.inSeconds}s',
    );
  }

  /// Persist the current local cache to Ditto for the active branch.
  ///
  /// Snapshots the values immediately, then waits for Ditto and retries:
  /// callers fire-and-forget from settings toggles, and a save that throws
  /// while Ditto is still initializing would silently lose the change.
  static Future<void> persistCurrentBranch({
    Duration timeout = const Duration(seconds: 20),
  }) async {
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

    final deadline = DateTime.now().add(timeout);
    await _waitForDittoReady(deadline);

    Object? lastError;
    while (true) {
      try {
        await _sync.saveBarBranchSettings(settings);
        talker.info(
          'Bar branch settings persisted for $branchId '
          '(enabled=${settings.enabled})',
        );
        return;
      } catch (e, s) {
        lastError = e;
        talker.warning('Bar branch settings persist attempt failed: $e\n$s');
      }
      if (!DateTime.now().isBefore(deadline)) break;
      await Future.delayed(const Duration(milliseconds: 500));
    }

    talker.error(
      'Bar branch settings persist gave up for $branchId '
      '(enabled=${settings.enabled}): $lastError',
    );
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

  static Future<void> _waitForDittoReady(DateTime deadline) async {
    while (DateTime.now().isBefore(deadline)) {
      try {
        if (ProxyService.ditto.isReady()) return;
      } catch (_) {}
      await Future.delayed(const Duration(milliseconds: 200));
    }
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
