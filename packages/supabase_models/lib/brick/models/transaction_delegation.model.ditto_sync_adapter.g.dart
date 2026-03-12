// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'transaction_delegation.model.dart';

// **************************************************************************
// DittoSyncAdapterGenerator
// **************************************************************************

// **************************************************************************
// DittoSyncAdapterGenerator
// **************************************************************************
//
// REQUIRED IMPORTS in parent file (transactiondelegation.model.dart):
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

class TransactionDelegationDittoAdapter
    extends DittoSyncAdapter<TransactionDelegation> {
  TransactionDelegationDittoAdapter._internal();

  static final TransactionDelegationDittoAdapter instance =
      TransactionDelegationDittoAdapter._internal();

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
  String get collectionName => "transaction_delegations";

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
          "Ditto hydration for TransactionDelegation timed out waiting for branchId");
    }
    return branchId;
  }

  @override
  Future<DittoSyncQuery?> buildObserverQuery() async {
    // Send-only mode: no remote observation
    return null;
  }

  @override
  Future<String?> documentIdForModel(TransactionDelegation model) async =>
      model.id;

  @override
  Future<Map<String, dynamic>> toDittoDocument(
      TransactionDelegation model) async {
    return {
      "_id": model.id,
      "id": model.id,
      "transactionId": model.transactionId,
      "branchId": model.branchId,
      "status": model.status,
      "receiptType": model.receiptType,
      "paymentType": model.paymentType,
      "subTotal": model.subTotal,
      "customerName": model.customerName,
      "customerTin": model.customerTin,
      "customerBhfId": model.customerBhfId,
      "isAutoPrint": model.isAutoPrint,
      "delegatedFromDevice": model.delegatedFromDevice,
      "delegatedAt": model.delegatedAt.toIso8601String(),
      "updatedAt": model.updatedAt.toIso8601String(),
      "additionalData": model.additionalData,
      "selectedDelegationDeviceId": model.selectedDelegationDeviceId,
    };
  }

  @override
  Future<TransactionDelegation?> fromDittoDocument(
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

    return TransactionDelegation(
      id: id,
      transactionId: document["transactionId"],
      branchId: document["branchId"],
      status: document["status"],
      receiptType: document["receiptType"],
      paymentType: document["paymentType"],
      subTotal: document["subTotal"],
      customerName: document["customerName"],
      customerTin: document["customerTin"],
      customerBhfId: document["customerBhfId"],
      isAutoPrint: document["isAutoPrint"],
      delegatedFromDevice: document["delegatedFromDevice"],
      delegatedAt:
          DateTime.tryParse(document["delegatedAt"]?.toString() ?? "") ??
              DateTime.now().toUtc(),
      updatedAt: DateTime.tryParse(document["updatedAt"]?.toString() ?? "") ??
          DateTime.now().toUtc(),
      additionalData: document["additionalData"],
      selectedDelegationDeviceId: document["selectedDelegationDeviceId"],
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
            'Ditto seeding skipped for TransactionDelegation (already seeded)');
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

      final models = await Repository().get<TransactionDelegation>(
        query: query,
        policy: OfflineFirstGetPolicy.alwaysHydrate,
      );
      var seededCount = 0;
      for (final model in models) {
        await coordinator.notifyLocalUpsert<TransactionDelegation>(model);
        seededCount++;
      }
      if (kDebugMode) {
        debugPrint('Ditto seeded ' +
            seededCount.toString() +
            ' TransactionDelegation record' +
            (seededCount == 1 ? '' : 's'));
      }
    } catch (error, stack) {
      if (kDebugMode) {
        debugPrint(
            'Ditto seeding failed for TransactionDelegation: $error\n$stack');
      }
    }

    _seeded = true;
  }

  static final int _$TransactionDelegationDittoAdapterRegistryToken =
      DittoSyncGeneratedRegistry.register(
          (coordinator) async {
            await coordinator.registerAdapter<TransactionDelegation>(
                TransactionDelegationDittoAdapter.instance);
          },
          modelType: TransactionDelegation,
          seed: (coordinator) async {
            await _seed(coordinator);
          },
          reset: _resetSeedFlag);

  /// Public accessor to ensure static initializer runs
  static int get registryToken =>
      _$TransactionDelegationDittoAdapterRegistryToken;
}
