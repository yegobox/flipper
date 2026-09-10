import 'dart:async';

import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/models/hotel_branch_settings.dart';
import 'package:flipper_services/proxy.dart';

/// Syncs Hotel Mode settings per branch via Ditto (`hotel_branch_settings`).
///
/// Local [ProxyService.box] keys remain the read cache for synchronous UI;
/// this service hydrates them from the branch document and persists changes
/// back. Same contract as [BarModeBranchSettingsService].
abstract final class HotelModeBranchSettingsService {
  static const enabledKey = 'hotelModeEnabled';
  static const launchOnStartKey = 'hotelModeLaunchOnStart';
  static const autoPostRoomChargeKey = 'hotelAutoPostRoomCharge';
  static const managerCheckoutKey = 'hotelManagerCheckout';
  static const requirePinKey = 'hotelRequirePin';
  static const autoLogoutKey = 'hotelAutoLogout';
  static const checkOutHourKey = 'hotelCheckOutHour';
  static const roomChargeVariantKey = 'hotelRoomChargeVariantId';

  static StreamSubscription<HotelBranchSettings?>? _watchSub;

  static dynamic get _sync => ProxyService.getStrategy(Strategy.capella);

  /// Pull branch settings from Ditto into the local cache.
  ///
  /// Retries until [timeout] because a fresh device may navigate before Ditto
  /// has finished authenticating or replicating `hotel_branch_settings`.
  static Future<void> hydrateForActiveBranch({
    Duration timeout = const Duration(seconds: 12),
  }) async {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) return;

    final deadline = DateTime.now().add(timeout);
    await _waitForDittoReady(deadline);

    while (DateTime.now().isBefore(deadline)) {
      try {
        final remote = await _sync.hotelBranchSettings(branchId: branchId);
        if (remote != null) {
          _applyToLocalCache(remote);
          talker.info(
            'Hotel branch settings hydrated for $branchId '
            '(enabled=${remote.enabled})',
          );
          return;
        }
      } catch (e, s) {
        talker.warning('Hotel branch settings hydrate attempt failed: $e\n$s');
      }

      final remaining = deadline.difference(DateTime.now());
      if (remaining <= Duration.zero) break;
      final wait = remaining < const Duration(milliseconds: 400)
          ? remaining
          : const Duration(milliseconds: 400);
      await Future.delayed(wait);
    }

    // One-time migration: device had hotel mode on before branch sync existed.
    if (_readLocalEnabled()) {
      try {
        await persistCurrentBranch();
      } catch (e, s) {
        talker.warning('Hotel branch settings migration persist failed: $e\n$s');
      }
      return;
    }

    talker.info(
      'No hotel_branch_settings for branch $branchId after '
      '${timeout.inSeconds}s',
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

    final variantId = ProxyService.box.readString(key: roomChargeVariantKey);
    final settings = HotelBranchSettings(
      branchId: branchId,
      enabled: _readLocalEnabled(),
      launchOnStart:
          ProxyService.box.readBool(key: launchOnStartKey) ?? _readLocalEnabled(),
      autoPostRoomCharge:
          ProxyService.box.readBool(key: autoPostRoomChargeKey) ?? true,
      managerCheckout:
          ProxyService.box.readBool(key: managerCheckoutKey) ?? true,
      requirePin: ProxyService.box.readBool(key: requirePinKey) ?? true,
      autoLogout: ProxyService.box.readBool(key: autoLogoutKey) ?? false,
      checkOutHour: ProxyService.box.readInt(key: checkOutHourKey) ?? 11,
      roomChargeVariantId: (variantId == null || variantId.isEmpty)
          ? null
          : variantId,
    );

    final deadline = DateTime.now().add(timeout);
    await _waitForDittoReady(deadline);

    Object? lastError;
    while (true) {
      try {
        await _sync.saveHotelBranchSettings(settings);
        talker.info(
          'Hotel branch settings persisted for $branchId '
          '(enabled=${settings.enabled})',
        );
        return;
      } catch (e, s) {
        lastError = e;
        talker.warning('Hotel branch settings persist attempt failed: $e\n$s');
      }
      if (!DateTime.now().isBefore(deadline)) break;
      await Future.delayed(const Duration(milliseconds: 500));
    }

    talker.error(
      'Hotel branch settings persist gave up for $branchId '
      '(enabled=${settings.enabled}): $lastError',
    );
  }

  /// Live-sync remote changes into the local cache while the app runs.
  static void startWatchingActiveBranch() {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) return;

    unawaited(_watchSub?.cancel());
    _watchSub = _sync
        .hotelBranchSettingsStream(branchId: branchId)
        .listen(
          (settings) {
            if (settings != null) _applyToLocalCache(settings);
          },
          onError: (Object e, StackTrace s) {
            talker.warning('Hotel branch settings watch error: $e\n$s');
          },
        );
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

  static void _applyToLocalCache(HotelBranchSettings settings) {
    final box = ProxyService.box;
    box.writeBool(key: enabledKey, value: settings.enabled);
    box.writeBool(key: launchOnStartKey, value: settings.launchOnStart);
    box.writeBool(
      key: autoPostRoomChargeKey,
      value: settings.autoPostRoomCharge,
    );
    box.writeBool(key: managerCheckoutKey, value: settings.managerCheckout);
    box.writeBool(key: requirePinKey, value: settings.requirePin);
    box.writeBool(key: autoLogoutKey, value: settings.autoLogout);
    box.writeInt(key: checkOutHourKey, value: settings.checkOutHour);
    box.writeString(
      key: roomChargeVariantKey,
      value: settings.roomChargeVariantId ?? '',
    );
  }
}
