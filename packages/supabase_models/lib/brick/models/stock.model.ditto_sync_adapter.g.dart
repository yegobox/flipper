// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

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
// Sync Direction: sendOnly
// This adapter sends data to Ditto but does NOT receive remote updates.
// **************************************************************************

class StockDittoAdapter extends DittoSyncAdapter<Stock> {
  StockDittoAdapter._internal();

  static final StockDittoAdapter instance = StockDittoAdapter._internal();

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

  String get collectionName => "stocks";

  @override
  bool get supportsBackupPull => true;

  @override
  Future<DittoSyncQuery?> buildBackupPullQuery() async {
    final branchId =
        _branchIdProviderOverride?.call() ?? ProxyService.box.getBranchId();
    if (branchId == null) {
      return const DittoSyncQuery(query: "SELECT * FROM stocks");
    }
    return DittoSyncQuery(
      query: "SELECT * FROM stocks WHERE branchId = :branchId",
      arguments: {"branchId": branchId},
    );
  }

  @override
  List<DittoBackupLinkConfig> get backupLinks => const [];

  @override
  Future<DittoSyncQuery?> buildObserverQuery() async {
    // Send-only mode: no remote observation
    return null;
  }

  @override
  Future<String?> documentIdForModel(Stock model) async => model.id;

  @override
  Future<Map<String, dynamic>> toDittoDocument(Stock model) async {
    return {
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
