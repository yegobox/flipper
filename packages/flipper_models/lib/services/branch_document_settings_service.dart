import 'dart:async';

import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/models/branch_document_settings.dart';
import 'package:flipper_services/proxy.dart';

/// Syncs document branding per branch via Ditto (`branch_document_settings`).
///
/// Same contract as [HotelModeBranchSettingsService]: the Ditto document is the
/// source of truth, [ProxyService.box] is a synchronous read cache so a PDF
/// builder never has to await, and every setter writes the cache then persists
/// in the background.
///
/// Lives outside the hotel namespace on purpose — the leads proforma reads it
/// on branches that never turn Hotel Mode on.
abstract final class BranchDocumentSettingsService {
  static const stampEnabledKey = 'docStampEnabled';
  static const stampImageKey = 'docStampImageBase64';
  static const stampPlacementKey = 'docStampPlacement';
  static const stampWidthKey = 'docStampWidthMm';
  static const stampAspectRatioKey = 'docStampAspectRatio';

  /// Which branch the cached stamp above belongs to.
  ///
  /// The cache is a flat set of preference keys, so without this a branch
  /// switch leaves the previous property's stamp in place until hydrate
  /// lands — and any document built in that window carries the wrong
  /// company's mark. Read is cheap and synchronous; the check is not.
  static const stampBranchKey = 'docStampBranchId';

  static StreamSubscription<BranchDocumentSettings?>? _watchSub;

  static dynamic get _sync => ProxyService.getStrategy(Strategy.capella);

  /// The branch's branding as this device currently knows it. Synchronous by
  /// design: called from inside PDF builders.
  static BranchDocumentSettings current() {
    final box = ProxyService.box;
    final branchId = box.getBranchId() ?? '';

    // Belongs to a different branch (or to none yet): answer with defaults
    // rather than the last property's stamp. Hydrate will fill it in.
    final cachedBranch = box.readString(key: stampBranchKey);
    if (cachedBranch == null ||
        cachedBranch.isEmpty ||
        cachedBranch != branchId) {
      return BranchDocumentSettings(branchId: branchId);
    }

    final image = box.readString(key: stampImageKey);
    return BranchDocumentSettings(
      branchId: branchId,
      stampEnabled: box.readBool(key: stampEnabledKey) ?? false,
      stampImageBase64: (image == null || image.isEmpty) ? null : image,
      stampPlacement: documentStampPlacementFromString(
        box.readString(key: stampPlacementKey),
      ),
      stampWidthMm: _readDouble(stampWidthKey, fallback: 38).clamp(
        BranchDocumentSettings.minStampWidthMm,
        BranchDocumentSettings.maxStampWidthMm,
      ),
      stampAspectRatio: _readDouble(stampAspectRatioKey, fallback: 1),
    );
  }

  /// Stored as a string: [LocalStorage] has no double accessor, and rounding a
  /// stamp's aspect ratio to an int would visibly distort it.
  static double _readDouble(String key, {required double fallback}) {
    final raw = ProxyService.box.readString(key: key);
    if (raw == null || raw.isEmpty) return fallback;
    final parsed = double.tryParse(raw);
    if (parsed == null || parsed.isNaN || parsed <= 0) return fallback;
    return parsed;
  }

  /// Pull branch branding from Ditto into the local cache.
  static Future<void> hydrateForActiveBranch({
    Duration timeout = const Duration(seconds: 12),
  }) async {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) return;

    final deadline = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(deadline)) {
      try {
        final remote = await _sync.branchDocumentSettings(branchId: branchId);
        if (remote != null) {
          applyToLocalCache(remote);
          talker.info(
            'Branch document settings hydrated for $branchId '
            '(stamp=${remote.hasStamp})',
          );
          return;
        }
      } catch (e, s) {
        talker.warning('Branch document settings hydrate failed: $e\n$s');
      }

      final remaining = deadline.difference(DateTime.now());
      if (remaining <= Duration.zero) break;
      await Future.delayed(
        remaining < const Duration(milliseconds: 400)
            ? remaining
            : const Duration(milliseconds: 400),
      );
    }

    // No document yet is the normal case for a branch that has never uploaded
    // a stamp. Claim the cache for this branch anyway, so a switch away from a
    // branded property does not leave its stamp behind.
    applyToLocalCache(BranchDocumentSettings(branchId: branchId));
    talker.info('No branch_document_settings for branch $branchId');
  }

  /// Write [settings] to Ditto. Returns false rather than throwing, so a caller
  /// updating a switch never has to guard the call.
  static Future<bool> persist(
    BranchDocumentSettings settings, {
    Duration timeout = const Duration(seconds: 12),
  }) async {
    applyToLocalCache(settings);
    try {
      await (_sync.saveBranchDocumentSettings(settings) as Future).timeout(
        timeout,
      );
      talker.info(
        'Branch document settings persisted for ${settings.branchId} '
        '(stamp=${settings.hasStamp})',
      );
      return true;
    } catch (e, s) {
      talker.error(
        'Branch document settings persist failed for ${settings.branchId}',
        e,
        s,
      );
      return false;
    }
  }

  /// Persist a change expressed against whatever this device currently holds.
  static Future<bool> update(
    BranchDocumentSettings Function(BranchDocumentSettings current) change,
  ) {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) return Future.value(false);
    final next = change(current()).copyWith(
      branchId: branchId,
      updatedAt: DateTime.now().toUtc(),
    );
    return persist(next);
  }

  /// Live-sync remote changes into the local cache while the app runs.
  static void startWatchingActiveBranch() {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) return;

    unawaited(_watchSub?.cancel());
    _watchSub = _sync
        .branchDocumentSettingsStream(branchId: branchId)
        .listen(
          (settings) {
            if (settings != null) applyToLocalCache(settings);
          },
          onError: (Object e, StackTrace s) {
            talker.warning('Branch document settings watch error: $e\n$s');
          },
        );
  }

  static void stopWatching() {
    unawaited(_watchSub?.cancel());
    _watchSub = null;
  }

  /// Visible for the service itself and for tests.
  ///
  /// Every key is written, including a cleared stamp as `''` — leaving the old
  /// value in the cache is how a removed stamp keeps printing on the device
  /// that did not remove it.
  static void applyToLocalCache(BranchDocumentSettings settings) {
    final box = ProxyService.box;
    // Stamped first: a cache that cannot say whose it is must read as absent.
    box.writeString(key: stampBranchKey, value: settings.branchId);
    box.writeBool(key: stampEnabledKey, value: settings.stampEnabled);
    box.writeString(
      key: stampImageKey,
      value: settings.stampImageBase64 ?? '',
    );
    box.writeString(
      key: stampPlacementKey,
      value: settings.stampPlacement.name,
    );
    box.writeString(
      key: stampWidthKey,
      value: settings.stampWidthMm.toString(),
    );
    box.writeString(
      key: stampAspectRatioKey,
      value: settings.stampAspectRatio.toString(),
    );
  }
}
