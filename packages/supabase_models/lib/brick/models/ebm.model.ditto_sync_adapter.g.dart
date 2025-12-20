// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ebm.model.dart';

// **************************************************************************
// DittoSyncAdapterGenerator
// **************************************************************************

// **************************************************************************
// DittoSyncAdapterGenerator
// **************************************************************************
//
// REQUIRED IMPORTS in parent file (ebm.model.dart):
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
// Sync Direction: bidirectional
// This adapter supports full bidirectional sync (send and receive).
// **************************************************************************

class EbmDittoAdapter extends DittoSyncAdapter<Ebm> {
  EbmDittoAdapter._internal();

  static final EbmDittoAdapter instance = EbmDittoAdapter._internal();

  // Observer management to prevent live query buildup
  dynamic _activeObserver;
  dynamic _activeSubscription;

  static int? Function()? _branchIdProviderOverride;
  static int? Function()? _businessIdProviderOverride;

  /// Allows tests to override how the current branch ID is resolved.
  void overrideBranchIdProvider(int? Function()? provider) {
    _branchIdProviderOverride = provider;
  }

  /// Allows tests to override how the current business ID is resolved.
  void overrideBusinessIdProvider(int? Function()? provider) {
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
  String get collectionName => "ebms";

  @override
  SyncDirection get syncDirection => SyncDirection.bidirectional;

  @override
  bool get shouldHydrateOnStartup => false;

  @override
  bool get supportsBackupPull => false;

  Future<int?> _resolveBranchId({bool waitForValue = false}) async {
    int? branchId =
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
      debugPrint("Ditto hydration for Ebm timed out waiting for branchId");
    }
    return branchId;
  }

  @override
  Future<DittoSyncQuery?> buildObserverQuery() async {
    // Cleanup any existing observer before creating new one
    await _cleanupActiveObserver();
    return _buildQuery(waitForBranchId: false);
  }

  /// Cleanup active observer to prevent live query buildup
  Future<void> _cleanupActiveObserver() async {
    if (_activeObserver != null) {
      await _activeObserver?.cancel();
      _activeObserver = null;
    }
    if (_activeSubscription != null) {
      await _activeSubscription?.cancel();
      _activeSubscription = null;
    }
  }

  Future<DittoSyncQuery?> _buildQuery({required bool waitForBranchId}) async {
    final branchId = await _resolveBranchId(waitForValue: waitForBranchId);
    final branchIdString = ProxyService.box.branchIdString();
    final bhfId = await ProxyService.box.bhfId();
    final arguments = <String, dynamic>{};
    final whereParts = <String>[];

    if (branchId != null) {
      whereParts.add('branchId = :branchId');
      arguments["branchId"] = branchId;
    }

    if (branchIdString != null && branchIdString.isNotEmpty) {
      whereParts.add(
          '(branchId = :branchIdString OR branchIdString = :branchIdString)');
      arguments["branchIdString"] = branchIdString;
    }

    if (bhfId != null && bhfId.isNotEmpty) {
      whereParts.add('bhfId = :bhfId');
      arguments["bhfId"] = bhfId;
    }

    if (whereParts.isEmpty) {
      if (waitForBranchId) {
        if (kDebugMode) {
          debugPrint(
              "Ditto hydration for Ebm skipped because branch context is unavailable");
        }
        return null;
      }
      if (kDebugMode) {
        debugPrint(
            "Ditto observation for Ebm deferred until branch context is available");
      }
      return const DittoSyncQuery(
        query: "SELECT * FROM ebms WHERE 1 = 0",
      );
    }

    final whereClause = whereParts.join(" OR ");
    return DittoSyncQuery(
      query: "SELECT * FROM ebms WHERE $whereClause",
      arguments: arguments,
    );
  }

  @override
  Future<DittoSyncQuery?> buildHydrationQuery() async {
    return _buildQuery(waitForBranchId: true);
  }

  @override
  Future<String?> documentIdForModel(Ebm model) async => model.id;

  @override
  Future<Map<String, dynamic>> toDittoDocument(Ebm model) async {
    return {
      "_id": model.id,
      "id": model.id,
      "bhfId": model.bhfId,
      "tinNumber": model.tinNumber,
      "dvcSrlNo": model.dvcSrlNo,
      "userId": model.userId,
      "taxServerUrl": model.taxServerUrl,
      "businessId": model.businessId,
      "branchId": model.branchId,
      "vatEnabled": model.vatEnabled,
      "mrc": model.mrc,
    };
  }

  @override
  Future<Ebm?> fromDittoDocument(Map<String, dynamic> document) async {
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

    return Ebm(
      id: id,
      bhfId: document["bhfId"],
      tinNumber: document["tinNumber"],
      dvcSrlNo: document["dvcSrlNo"],
      userId: document["userId"],
      taxServerUrl: document["taxServerUrl"],
      businessId: document["businessId"],
      branchId: document["branchId"],
      vatEnabled: document["vatEnabled"],
      mrc: document["mrc"],
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
        debugPrint('Ditto seeding skipped for Ebm (already seeded)');
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

      final models = await Repository().get<Ebm>(
        query: query,
        policy: OfflineFirstGetPolicy.alwaysHydrate,
      );
      var seededCount = 0;
      for (final model in models) {
        await coordinator.notifyLocalUpsert<Ebm>(model);
        seededCount++;
      }
      if (kDebugMode) {
        debugPrint('Ditto seeded ' +
            seededCount.toString() +
            ' Ebm record' +
            (seededCount == 1 ? '' : 's'));
      }
    } catch (error, stack) {
      if (kDebugMode) {
        debugPrint('Ditto seeding failed for Ebm: $error\n$stack');
      }
    }

    _seeded = true;
  }

  static final int _$EbmDittoAdapterRegistryToken =
      DittoSyncGeneratedRegistry.register(
          (coordinator) async {
            await coordinator.registerAdapter<Ebm>(EbmDittoAdapter.instance);
          },
          modelType: Ebm,
          seed: (coordinator) async {
            await _seed(coordinator);
          },
          reset: _resetSeedFlag);

  /// Public accessor to ensure static initializer runs
  static int get registryToken => _$EbmDittoAdapterRegistryToken;
}
