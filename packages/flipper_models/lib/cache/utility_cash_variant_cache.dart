import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';

/// In-memory cache for Utility "Cash In" / "Cash Out" variants per branch.
///
/// Warming avoids repeated [DatabaseSyncInterface.getUtilityVariant] work
/// (and remote fetches) on the cash book hot path.
final class UtilityCashVariantCache {
  UtilityCashVariantCache._();
  static final UtilityCashVariantCache instance = UtilityCashVariantCache._();

  final Map<String, Variant> _variants = {};

  static String _key(String branchId, String utilityName) =>
      '$branchId|$utilityName';

  void put(String branchId, String utilityName, Variant variant) {
    _variants[_key(branchId, utilityName)] = variant;
  }

  Variant? get(String branchId, String utilityName) {
    return _variants[_key(branchId, utilityName)];
  }

  void clearBranch(String branchId) {
    _variants.removeWhere((k, _) => k.startsWith('$branchId|'));
  }

  /// Prefetch both cash utility variants for [branchId] (best-effort).
  static Future<void> prefetch(
    DatabaseSyncInterface db,
    String branchId,
  ) async {
    for (final name in [TransactionType.cashIn, TransactionType.cashOut]) {
      try {
        final v = await db.getUtilityVariant(name: name, branchId: branchId);
        if (v != null) {
          instance.put(branchId, name, v);
        }
      } catch (_) {
        // Warm-up is best-effort; saves still call getUtilityVariant if missing.
      }
    }
  }

  Future<Variant?> getOrFetch({
    required DatabaseSyncInterface db,
    required String branchId,
    required String utilityName,
  }) async {
    final cached = get(branchId, utilityName);
    if (cached != null) {
      return cached;
    }
    final v = await db.getUtilityVariant(name: utilityName, branchId: branchId);
    if (v != null) {
      put(branchId, utilityName, v);
    }
    return v;
  }
}
