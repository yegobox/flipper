// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_recount_item.model.dart';

// **************************************************************************
// DittoSyncAdapterGenerator
// **************************************************************************

// **************************************************************************
// DittoSyncAdapterGenerator
// **************************************************************************
//
// REQUIRED IMPORTS in parent file (stockrecountitem.model.dart):
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

class StockRecountItemDittoAdapter extends DittoSyncAdapter<StockRecountItem> {
  StockRecountItemDittoAdapter._internal();

  static final StockRecountItemDittoAdapter instance =
      StockRecountItemDittoAdapter._internal();

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

  String get collectionName => "stock_recount_items";

  @override
  Future<DittoSyncQuery?> buildObserverQuery() async {
    final branchId =
        _branchIdProviderOverride?.call() ?? ProxyService.box.getBranchId();
    if (branchId == null) {
      return const DittoSyncQuery(query: "SELECT * FROM stock_recount_items");
    }
    return DittoSyncQuery(
      query: "SELECT * FROM stock_recount_items WHERE branchId = :branchId",
      arguments: {"branchId": branchId},
    );
  }

  @override
  Future<String?> documentIdForModel(StockRecountItem model) async => model.id;

  @override
  Future<Map<String, dynamic>> toDittoDocument(StockRecountItem model) async {
    return {
      "id": model.id,
      "recountId": model.recountId,
      "variantId": model.variantId,
      "stockId": model.stockId,
      "productName": model.productName,
      "previousQuantity": model.previousQuantity,
      "countedQuantity": model.countedQuantity,
      "difference": model.difference,
      "notes": model.notes,
      "createdAt": model.createdAt.toIso8601String(),
    };
  }

  @override
  Future<StockRecountItem?> fromDittoDocument(
      Map<String, dynamic> document) async {
    final id = document["_id"] ?? document["id"];
    if (id == null) return null;

    // Branch filtering
    final currentBranch =
        _branchIdProviderOverride?.call() ?? ProxyService.box.getBranchId();
    final docBranch = document["branchId"];
    if (currentBranch != null && docBranch != currentBranch) {
      return null;
    }

    return StockRecountItem(
      id: id,
      recountId: document["recountId"],
      variantId: document["variantId"],
      stockId: document["stockId"],
      productName: document["productName"],
      previousQuantity: document["previousQuantity"],
      countedQuantity: document["countedQuantity"],
      difference: document["difference"],
      notes: document["notes"],
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
        debugPrint(
            'Ditto seeding skipped for StockRecountItem (already seeded)');
      }
      return;
    }

    try {
      Query? query;

      final models = await Repository().get<StockRecountItem>(
        query: query,
        policy: OfflineFirstGetPolicy.alwaysHydrate,
      );
      var seededCount = 0;
      for (final model in models) {
        await coordinator.notifyLocalUpsert<StockRecountItem>(model);
        seededCount++;
      }
      if (kDebugMode) {
        debugPrint('Ditto seeded ' +
            seededCount.toString() +
            ' StockRecountItem record' +
            (seededCount == 1 ? '' : 's'));
      }
    } catch (error, stack) {
      if (kDebugMode) {
        debugPrint('Ditto seeding failed for StockRecountItem: $error\n$stack');
      }
    }

    _seeded = true;
  }

  static final int _$StockRecountItemDittoAdapterRegistryToken =
      DittoSyncGeneratedRegistry.register((coordinator) async {
    await coordinator.registerAdapter<StockRecountItem>(
        StockRecountItemDittoAdapter.instance);
  }, seed: (coordinator) async {
    await _seed(coordinator);
  }, reset: _resetSeedFlag);

  /// Public accessor to ensure static initializer runs
  static int get registryToken => _$StockRecountItemDittoAdapterRegistryToken;
}
