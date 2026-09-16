import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/sync/utils/hotel_room_rra.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart';

/// Answers "does this branch file with RRA?" once, not once per call.
///
/// The naive read is expensive in exactly the case where the answer is no. A
/// branch with no EBM row has nothing cached in Ditto, so even
/// `ebm(fetchRemote: false)` finds nothing there and falls through to
/// Supabase — a network round trip, plus a one-off 500ms subscription wait,
/// every single time. The room-charge path asked twice per charge and the
/// Hotel Mode entry sweep asked again, so a property that does not fiscalise
/// at all was paying the most.
///
/// Cached for [ttl] rather than forever: a branch that has EBM configured
/// mid-session should start registering its rooms without a restart.
abstract final class HotelRraCapability {
  /// Long enough to cover a desk session's worth of charges, short enough
  /// that enabling EBM takes effect without a restart.
  static const Duration ttl = Duration(minutes: 5);

  static final Map<String, _Answer> _cache = <String, _Answer>{};

  /// Whether [branchId] files with RRA, from cache when it is still fresh.
  static Future<bool> supports(String branchId) async {
    if (branchId.isEmpty) return false;

    final cached = _cache[branchId];
    if (cached != null && !cached.isStale) return cached.supported;

    final bool supported;
    try {
      final ebm = await ProxyService.getStrategy(
        Strategy.capella,
      ).ebm(branchId: branchId, fetchRemote: false);
      supported = hotelBranchSupportsRra(ebm);
    } catch (e) {
      // Deliberately not cached. A branch really has no EBM row for a long
      // time; Supabase being briefly unreachable is a different thing, and
      // remembering it for five minutes would keep rooms unregistered long
      // after the network came back.
      talker.warning('hotel: could not read EBM for branch $branchId: $e');
      return false;
    }

    _cache[branchId] = _Answer(supported, DateTime.now());
    return supported;
  }

  /// Forgets [branchId], or every branch when omitted.
  ///
  /// Call this after EBM settings change so the next read is honest rather
  /// than waiting out [ttl].
  static void invalidate([String? branchId]) {
    if (branchId == null) {
      _cache.clear();
    } else {
      _cache.remove(branchId);
    }
  }

  @visibleForTesting
  static bool isCached(String branchId) {
    final cached = _cache[branchId];
    return cached != null && !cached.isStale;
  }
}

class _Answer {
  _Answer(this.supported, this.readAt);

  final bool supported;
  final DateTime readAt;

  bool get isStale =>
      DateTime.now().difference(readAt) >= HotelRraCapability.ttl;
}
