// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'purchase.model.dart';

// **************************************************************************
// DittoSyncAdapterGenerator
// **************************************************************************

// **************************************************************************
// DittoSyncAdapterGenerator
// **************************************************************************
//
// REQUIRED IMPORTS in parent file (purchase.model.dart):
// - import 'package:brick_core/query.dart';
// - import 'package:brick_offline_first/brick_offline_first.dart';
// - import 'package:flipper_services/proxy.dart';
// - import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;
// - import 'package:supabase_models/sync/ditto_sync_adapter.dart';
// - import 'package:supabase_models/sync/ditto_sync_coordinator.dart';
// - import 'package:supabase_models/sync/ditto_sync_generated.dart';
// - import 'package:supabase_models/brick/repository.dart';
// **************************************************************************
//
// Sync Direction: sendOnly
// This adapter sends data to Ditto but does NOT receive remote updates.
// **************************************************************************

class PurchaseDittoAdapter extends DittoSyncAdapter<Purchase> {
  PurchaseDittoAdapter._internal();

  static final PurchaseDittoAdapter instance = PurchaseDittoAdapter._internal();

  // Observer management to prevent live query buildup
  dynamic _activeObserver;
  dynamic _activeSubscription;

  static String? Function()? _branchIdProviderOverride;
  static String? Function()? _businessIdProviderOverride;

  /// Allows tests to override how the current branch ID is resolved.
  void overrideBranchIdProvider(String? Function()? provider) {
    _branchIdProviderOverride = provider;
  }

  /// Allows tests to override how the current business ID is resolved.
  void overrideBusinessIdProvider(String? Function()? provider) {
    _businessIdProviderOverride = provider;
  }

  /// Clears any provider overrides (intended for tests).
  void resetOverrides() {
    _branchIdProviderOverride = null;
    _businessIdProviderOverride = null;
  }

  /// Cleanup active observers to prevent live query buildup
  Future<void> dispose() async {
    await _activeObserver?.cancel();
    await _activeSubscription?.cancel();
    _activeObserver = null;
    _activeSubscription = null;
  }

  @override
  String get collectionName => "purchases";

  @override
  SyncDirection get syncDirection => SyncDirection.sendOnly;

  @override
  bool get shouldHydrateOnStartup => false;

  @override
  bool get supportsBackupPull => false;

  Future<String?> _resolveBranchId({bool waitForValue = false}) async {
    String? branchId =
        _branchIdProviderOverride?.call() ?? ProxyService.box.getBranchId();
    if (!waitForValue || branchId != null) {
      return branchId;
    }
    final stopwatch = Stopwatch()..start();
    const timeout = Duration(seconds: 30);
    while (branchId == null && stopwatch.elapsed < timeout) {
      await Future.delayed(const Duration(milliseconds: 200));
      branchId =
          _branchIdProviderOverride?.call() ?? ProxyService.box.getBranchId();
    }
    if (branchId == null && kDebugMode) {
      debugPrint("Ditto hydration for Purchase timed out waiting for branchId");
    }
    return branchId;
  }

  @override
  Future<DittoSyncQuery?> buildObserverQuery() async {
    // Send-only mode: no remote observation
    return null;
  }

  @override
  Future<String?> documentIdForModel(Purchase model) async => model.id;

  @override
  Future<Map<String, dynamic>> toDittoDocument(Purchase model) async {
    return {
      "_id": model.id,
      "id": model.id,
      "spplrTin": model.spplrTin,
      "spplrNm": model.spplrNm,
      "spplrBhfId": model.spplrBhfId,
      "spplrInvcNo": model.spplrInvcNo,
      "rcptTyCd": model.rcptTyCd,
      "pmtTyCd": model.pmtTyCd,
      "cfmDt": model.cfmDt,
      "salesDt": model.salesDt,
      "stockRlsDt": model.stockRlsDt,
      "totItemCnt": model.totItemCnt,
      "taxblAmtA": model.taxblAmtA,
      "taxblAmtB": model.taxblAmtB,
      "taxblAmtC": model.taxblAmtC,
      "taxblAmtD": model.taxblAmtD,
      "taxRtA": model.taxRtA,
      "taxRtB": model.taxRtB,
      "taxRtC": model.taxRtC,
      "taxRtD": model.taxRtD,
      "taxAmtA": model.taxAmtA,
      "taxAmtB": model.taxAmtB,
      "taxAmtC": model.taxAmtC,
      "taxAmtD": model.taxAmtD,
      "totTaxblAmt": model.totTaxblAmt,
      "totTaxAmt": model.totTaxAmt,
      "totAmt": model.totAmt,
      "branchId": model.branchId,
      "remark": model.remark,
      "hasUnApprovedVariant": model.hasUnApprovedVariant,
      "approved": model.approved,
      "rejected": model.rejected,
      "pending": model.pending,
      "regTyCd": model.regTyCd,
      "createdAt": model.createdAt.toIso8601String(),
    };
  }

  @override
  Future<Purchase?> fromDittoDocument(Map<String, dynamic> document) async {
    final id = document["_id"] ?? document["id"];
    if (id == null) return null;

    // Branch filtering
    final currentBranch =
        _branchIdProviderOverride?.call() ?? ProxyService.box.getBranchId();
    final docBranch = document["branchId"];
    if (currentBranch != null && docBranch != currentBranch) {
      return null;
    }

    // Helper method to fetch relationships
    Future<T?> fetchRelationship<T extends OfflineFirstWithSupabaseModel>(
        dynamic id) async {
      if (id == null) return null;
      try {
        final results = await Repository().get<T>(
          query: Query(where: [Where('id').isExactly(id)]),
          policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
        );
        return results.isNotEmpty ? results.first : null;
      } catch (e) {
        return null;
      }
    }

    return Purchase(
      id: id,
      variants: null, // Excluded from Ditto sync
      spplrTin: document["spplrTin"],
      spplrNm: document["spplrNm"],
      spplrBhfId: document["spplrBhfId"],
      spplrInvcNo: document["spplrInvcNo"],
      rcptTyCd: document["rcptTyCd"],
      pmtTyCd: document["pmtTyCd"],
      cfmDt: document["cfmDt"],
      salesDt: document["salesDt"],
      stockRlsDt: document["stockRlsDt"],
      totItemCnt: document["totItemCnt"],
      taxblAmtA: document["taxblAmtA"],
      taxblAmtB: document["taxblAmtB"],
      taxblAmtC: document["taxblAmtC"],
      taxblAmtD: document["taxblAmtD"],
      taxRtA: document["taxRtA"],
      taxRtB: document["taxRtB"],
      taxRtC: document["taxRtC"],
      taxRtD: document["taxRtD"],
      taxAmtA: document["taxAmtA"],
      taxAmtB: document["taxAmtB"],
      taxAmtC: document["taxAmtC"],
      taxAmtD: document["taxAmtD"],
      totTaxblAmt: document["totTaxblAmt"],
      totTaxAmt: document["totTaxAmt"],
      totAmt: document["totAmt"],
      branchId: document["branchId"],
      remark: document["remark"],
      hasUnApprovedVariant: document["hasUnApprovedVariant"],
      approved: document["approved"],
      rejected: document["rejected"],
      pending: document["pending"],
      regTyCd: document["regTyCd"],
      createdAt: DateTime.tryParse(document["createdAt"]?.toString() ?? "") ??
          DateTime.now().toUtc(),
    );
  }

  @override
  Future<bool> shouldApplyRemote(Map<String, dynamic> document) async {
    final currentBranch =
        _branchIdProviderOverride?.call() ?? ProxyService.box.getBranchId();
    if (currentBranch == null) return true;
    final docBranch = document["branchId"];
    return docBranch == currentBranch;
  }

  static bool _seeded = false;

  static void _resetSeedFlag() {
    _seeded = false;
  }

  static Future<void> _seed(DittoSyncCoordinator coordinator) async {
    if (_seeded) {
      if (kDebugMode) {
        debugPrint('Ditto seeding skipped for Purchase (already seeded)');
      }
      return;
    }

    try {
      Query? query;
      final branchId =
          _branchIdProviderOverride?.call() ?? ProxyService.box.getBranchId();
      if (branchId != null) {
        query = Query(where: [Where('branchId').isExactly(branchId)]);
      }

      final models = await Repository().get<Purchase>(
        query: query,
        policy: OfflineFirstGetPolicy.alwaysHydrate,
      );
      var seededCount = 0;
      for (final model in models) {
        await coordinator.notifyLocalUpsert<Purchase>(model);
        seededCount++;
      }
      if (kDebugMode) {
        debugPrint('Ditto seeded ' +
            seededCount.toString() +
            ' Purchase record' +
            (seededCount == 1 ? '' : 's'));
      }
    } catch (error, stack) {
      if (kDebugMode) {
        debugPrint('Ditto seeding failed for Purchase: $error\n$stack');
      }
    }

    _seeded = true;
  }

  static final int _$PurchaseDittoAdapterRegistryToken =
      DittoSyncGeneratedRegistry.register(
          (coordinator) async {
            await coordinator
                .registerAdapter<Purchase>(PurchaseDittoAdapter.instance);
          },
          modelType: Purchase,
          seed: (coordinator) async {
            await _seed(coordinator);
          },
          reset: _resetSeedFlag);

  /// Public accessor to ensure static initializer runs
  static int get registryToken => _$PurchaseDittoAdapterRegistryToken;
}
