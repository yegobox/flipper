// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'stock.model.dart';

// **************************************************************************
// DittoSyncAdapterGenerator
// **************************************************************************

// **************************************************************************
// DittoSyncAdapterGenerator
// **************************************************************************
//
// REQUIRED IMPORTS in parent file (stock.model.dart):
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

class StockDittoAdapter extends DittoSyncAdapter<Stock> {
  StockDittoAdapter._internal();

  static final StockDittoAdapter instance = StockDittoAdapter._internal();

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
  String get collectionName => "stocks";

  @override
  SyncDirection get syncDirection => SyncDirection.bidirectional;

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
      debugPrint("Ditto hydration for Stock timed out waiting for branchId");
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
              "Ditto hydration for Stock skipped because branch context is unavailable");
        }
        return null;
      }
      if (kDebugMode) {
        debugPrint(
            "Ditto observation for Stock deferred until branch context is available");
      }
      return const DittoSyncQuery(
        query: "SELECT * FROM stocks WHERE 1 = 0",
      );
    }

    final whereClause = whereParts.join(" OR ");
    return DittoSyncQuery(
      query: "SELECT * FROM stocks WHERE $whereClause",
      arguments: arguments,
    );
  }

  @override
  Future<DittoSyncQuery?> buildHydrationQuery() async {
    return _buildQuery(waitForBranchId: true);
  }

  @override
  Future<String?> documentIdForModel(Stock model) async => model.id;

  @override
  Future<Map<String, dynamic>> toDittoDocument(Stock model) async {
    return {
      "_id": model.id,
      "id": model.id,
      "tin": model.tin,
      "bhfId": model.bhfId,
      "branchId": model.branchId,
      "currentStock": model.currentStock,
      "lowStock": model.lowStock,
      "canTrackingStock": model.canTrackingStock,
      "showLowStockAlert": model.showLowStockAlert,
      "active": model.active,
      "value": model.value,
      "rsdQty": model.rsdQty,
      "lastTouched": model.lastTouched?.toIso8601String(),
      "ebmSynced": model.ebmSynced,
      "initialStock": model.initialStock,
    };
  }

  @override
  Future<Stock?> fromDittoDocument(Map<String, dynamic> document) async {
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

    return Stock(
      id: id,
      tin: document["tin"],
      bhfId: document["bhfId"],
      branchId: document["branchId"],
      currentStock: document["currentStock"],
      lowStock: document["lowStock"],
      canTrackingStock: document["canTrackingStock"],
      showLowStockAlert: document["showLowStockAlert"],
      active: document["active"],
      value: document["value"],
      rsdQty: document["rsdQty"],
      lastTouched: DateTime.tryParse(document["lastTouched"]?.toString() ?? ""),
      ebmSynced: document["ebmSynced"],
      initialStock: document["initialStock"],
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
        debugPrint('Ditto seeding skipped for Stock (already seeded)');
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

      final models = await Repository().get<Stock>(
        query: query,
        policy: OfflineFirstGetPolicy.alwaysHydrate,
      );
      var seededCount = 0;
      for (final model in models) {
        await coordinator.notifyLocalUpsert<Stock>(model);
        seededCount++;
      }
      if (kDebugMode) {
        debugPrint('Ditto seeded ' +
            seededCount.toString() +
            ' Stock record' +
            (seededCount == 1 ? '' : 's'));
      }
    } catch (error, stack) {
      if (kDebugMode) {
        debugPrint('Ditto seeding failed for Stock: $error\n$stack');
      }
    }

    _seeded = true;
  }

  static final int _$StockDittoAdapterRegistryToken =
      DittoSyncGeneratedRegistry.register(
          (coordinator) async {
            await coordinator
                .registerAdapter<Stock>(StockDittoAdapter.instance);
          },
          modelType: Stock,
          seed: (coordinator) async {
            await _seed(coordinator);
          },
          reset: _resetSeedFlag);

  /// Public accessor to ensure static initializer runs
  static int get registryToken => _$StockDittoAdapterRegistryToken;
}
