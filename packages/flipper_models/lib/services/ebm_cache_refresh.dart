import 'dart:async';

import 'package:flipper_models/helperModels/talker.dart';
import 'package:flutter/foundation.dart';

/// Refreshes this device's cached EBM row from the server, once per branch
/// per app session.
///
/// Pay, receipts and product registration ask `isTaxEnabled`, which reads
/// only the device's Ditto `ebms` copy. Only `ebm()` re-reads Supabase and
/// overwrites that copy, and until now only side screens called it, so an
/// EBM that support enabled on the server never reached a device that had
/// cached the old row. Callers start this without awaiting it: it must never
/// hold up startup.
abstract final class EbmCacheRefresh {
  static final Set<String> _refreshed = <String>{};

  static const defaultTimeout = Duration(seconds: 20);

  /// Runs [fetch] for [branchId] unless this session already did, the device
  /// is in local mode (no EBM there), or no branch is chosen yet. Never
  /// throws; a timeout only stops the wait, and is logged.
  static Future<void> refreshOnce({
    required String? branchId,
    required bool localMode,
    required Future<Object?> Function(String branchId) fetch,
    Duration timeout = defaultTimeout,
  }) async {
    if (localMode || branchId == null || branchId.isEmpty) return;
    if (!_refreshed.add(branchId)) return;
    try {
      await fetch(branchId).timeout(timeout);
    } catch (e) {
      talker.warning('EBM cache refresh for branch $branchId failed: $e');
    }
  }

  @visibleForTesting
  static void debugReset() => _refreshed.clear();
}
