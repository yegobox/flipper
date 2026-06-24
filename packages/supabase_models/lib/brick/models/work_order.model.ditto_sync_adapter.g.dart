// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'work_order.model.dart';

// **************************************************************************
// DittoSyncAdapterGenerator
// **************************************************************************

// **************************************************************************
// DittoSyncAdapterGenerator
// **************************************************************************
//
// REQUIRED IMPORTS in parent file (workorder.model.dart):
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

class WorkOrderDittoAdapter extends DittoSyncAdapter<WorkOrder> {
  WorkOrderDittoAdapter._internal();

  static final WorkOrderDittoAdapter instance =
      WorkOrderDittoAdapter._internal();

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
  String get collectionName => "work_orders";

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
      debugPrint(
          "Ditto hydration for WorkOrder timed out waiting for branchId");
    }
    return branchId;
  }

  @override
  Future<DittoSyncQuery?> buildObserverQuery() async {
    // Send-only mode: no remote observation
    return null;
  }

  @override
  Future<String?> documentIdForModel(WorkOrder model) async => model.id;

  @override
  Future<Map<String, dynamic>> toDittoDocument(WorkOrder model) async {
    return {
      "_id": model.id,
      "id": model.id,
      "branchId": model.branchId,
      "businessId": model.businessId,
      "variantId": model.variantId,
      "variantName": model.variantName,
      "plannedQuantity": model.plannedQuantity,
      "actualQuantity": model.actualQuantity,
      "targetDate": model.targetDate.toIso8601String(),
      "shiftId": model.shiftId,
      "status": model.status,
      "unitOfMeasure": model.unitOfMeasure,
      "notes": model.notes,
      "createdBy": model.createdBy,
      "createdAt": model.createdAt?.toIso8601String(),
      "startedAt": model.startedAt?.toIso8601String(),
      "completedAt": model.completedAt?.toIso8601String(),
      "lastTouched": model.lastTouched?.toIso8601String(),
    };
  }

  @override
  Future<WorkOrder?> fromDittoDocument(Map<String, dynamic> document) async {
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

    return WorkOrder(
      id: id,
      branchId: document["branchId"],
      businessId: document["businessId"],
      variantId: document["variantId"],
      variantName: document["variantName"],
      plannedQuantity: document["plannedQuantity"],
      actualQuantity: document["actualQuantity"],
      targetDate: DateTime.tryParse(document["targetDate"]?.toString() ?? "") ??
          DateTime.now().toUtc(),
      shiftId: document["shiftId"],
      status: document["status"],
      unitOfMeasure: document["unitOfMeasure"],
      notes: document["notes"],
      createdBy: document["createdBy"],
      createdAt: DateTime.tryParse(document["createdAt"]?.toString() ?? ""),
      startedAt: DateTime.tryParse(document["startedAt"]?.toString() ?? ""),
      completedAt: DateTime.tryParse(document["completedAt"]?.toString() ?? ""),
      lastTouched: DateTime.tryParse(document["lastTouched"]?.toString() ?? ""),
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
        debugPrint('Ditto seeding skipped for WorkOrder (already seeded)');
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

      final models = await Repository().get<WorkOrder>(
        query: query,
        policy: OfflineFirstGetPolicy.alwaysHydrate,
      );
      var seededCount = 0;
      for (final model in models) {
        await coordinator.notifyLocalUpsert<WorkOrder>(model);
        seededCount++;
      }
      if (kDebugMode) {
        debugPrint('Ditto seeded ' +
            seededCount.toString() +
            ' WorkOrder record' +
            (seededCount == 1 ? '' : 's'));
      }
    } catch (error, stack) {
      if (kDebugMode) {
        debugPrint('Ditto seeding failed for WorkOrder: $error\n$stack');
      }
    }

    _seeded = true;
  }

  static final int _$WorkOrderDittoAdapterRegistryToken =
      DittoSyncGeneratedRegistry.register(
          (coordinator) async {
            await coordinator
                .registerAdapter<WorkOrder>(WorkOrderDittoAdapter.instance);
          },
          modelType: WorkOrder,
          seed: (coordinator) async {
            await _seed(coordinator);
          },
          reset: _resetSeedFlag);

  /// Public accessor to ensure static initializer runs
  static int get registryToken => _$WorkOrderDittoAdapterRegistryToken;
}
