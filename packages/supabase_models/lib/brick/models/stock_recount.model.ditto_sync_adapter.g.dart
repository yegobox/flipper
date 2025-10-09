// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_recount.model.dart';

// **************************************************************************
// DittoSyncAdapterGenerator
// **************************************************************************

// **************************************************************************
// DittoSyncAdapterGenerator
// **************************************************************************
//
// REQUIRED IMPORTS in parent file (stockrecount.model.dart):
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

class StockRecountDittoAdapter extends DittoSyncAdapter<StockRecount> {
  StockRecountDittoAdapter._internal();

  static final StockRecountDittoAdapter instance =
      StockRecountDittoAdapter._internal();

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

  String get collectionName => "stock_recounts";

  @override
  bool get supportsBackupPull => false;

  @override
  Future<DittoSyncQuery?> buildObserverQuery() async {
    final branchId =
        _branchIdProviderOverride?.call() ?? ProxyService.box.getBranchId();
    if (branchId == null) {
      return const DittoSyncQuery(query: "SELECT * FROM stock_recounts");
    }
    return DittoSyncQuery(
      query: "SELECT * FROM stock_recounts WHERE branchId = :branchId",
      arguments: {"branchId": branchId},
    );
  }

  @override
  Future<String?> documentIdForModel(StockRecount model) async => model.id;

  @override
  Future<Map<String, dynamic>> toDittoDocument(StockRecount model) async {
    return {
      "id": model.id,
      "branchId": model.branchId,
      "status": model.status,
      "userId": model.userId,
      "deviceId": model.deviceId,
      "deviceName": model.deviceName,
      "createdAt": model.createdAt.toIso8601String(),
      "submittedAt": model.submittedAt?.toIso8601String(),
      "syncedAt": model.syncedAt?.toIso8601String(),
      "notes": model.notes,
      "totalItemsCounted": model.totalItemsCounted,
    };
  }

  @override
  Future<StockRecount?> fromDittoDocument(Map<String, dynamic> document) async {
    final id = document["_id"] ?? document["id"];
    if (id == null) return null;

    // Branch filtering
    final currentBranch =
        _branchIdProviderOverride?.call() ?? ProxyService.box.getBranchId();
    final docBranch = document["branchId"];
    if (currentBranch != null && docBranch != currentBranch) {
      return null;
    }

    return StockRecount(
      id: id,
      branchId: document["branchId"],
      status: document["status"],
      userId: document["userId"],
      deviceId: document["deviceId"],
      deviceName: document["deviceName"],
      createdAt: DateTime.tryParse(document["createdAt"]?.toString() ?? "") ??
          DateTime.now().toUtc(),
      submittedAt: DateTime.tryParse(document["submittedAt"]?.toString() ?? ""),
      syncedAt: DateTime.tryParse(document["syncedAt"]?.toString() ?? ""),
      notes: document["notes"],
      totalItemsCounted: document["totalItemsCounted"],
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
        debugPrint('Ditto seeding skipped for StockRecount (already seeded)');
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

      final models = await Repository().get<StockRecount>(
        query: query,
        policy: OfflineFirstGetPolicy.alwaysHydrate,
      );
      var seededCount = 0;
      for (final model in models) {
        await coordinator.notifyLocalUpsert<StockRecount>(model);
        seededCount++;
      }
      if (kDebugMode) {
        debugPrint('Ditto seeded ' +
            seededCount.toString() +
            ' StockRecount record' +
            (seededCount == 1 ? '' : 's'));
      }
    } catch (error, stack) {
      if (kDebugMode) {
        debugPrint('Ditto seeding failed for StockRecount: $error\n$stack');
      }
    }

    _seeded = true;
  }

  static final int _$StockRecountDittoAdapterRegistryToken =
      DittoSyncGeneratedRegistry.register(
          (coordinator) async {
            await coordinator.registerAdapter<StockRecount>(
                StockRecountDittoAdapter.instance);
          },
          modelType: StockRecount,
          seed: (coordinator) async {
            await _seed(coordinator);
          },
          reset: _resetSeedFlag);

  /// Public accessor to ensure static initializer runs
  static int get registryToken => _$StockRecountDittoAdapterRegistryToken;
}
