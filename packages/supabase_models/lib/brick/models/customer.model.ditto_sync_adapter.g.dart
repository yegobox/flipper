// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'customer.model.dart';

// **************************************************************************
// DittoSyncAdapterGenerator
// **************************************************************************

// **************************************************************************
// DittoSyncAdapterGenerator
// **************************************************************************
//
// REQUIRED IMPORTS in parent file (customer.model.dart):
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

class CustomerDittoAdapter extends DittoSyncAdapter<Customer> {
  CustomerDittoAdapter._internal();

  static final CustomerDittoAdapter instance = CustomerDittoAdapter._internal();

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
  String get collectionName => "customers";

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
      debugPrint("Ditto hydration for Customer timed out waiting for branchId");
    }
    return branchId;
  }

  @override
  Future<DittoSyncQuery?> buildObserverQuery() async {
    // Send-only mode: no remote observation
    return null;
  }

  @override
  Future<String?> documentIdForModel(Customer model) async => model.id;

  @override
  Future<Map<String, dynamic>> toDittoDocument(Customer model) async {
    return {
      "_id": model.id,
      "id": model.id,
      "custNm": model.custNm,
      "email": model.email,
      "telNo": model.telNo,
      "adrs": model.adrs,
      "branchId": model.branchId,
      "updatedAt": model.updatedAt?.toIso8601String(),
      "custNo": model.custNo,
      "custTin": model.custTin,
      "regrNm": model.regrNm,
      "regrId": model.regrId,
      "modrNm": model.modrNm,
      "modrId": model.modrId,
      "ebmSynced": model.ebmSynced,
      "bhfId": model.bhfId,
      "useYn": model.useYn,
      "customerType": model.customerType,
    };
  }

  @override
  Future<Customer?> fromDittoDocument(Map<String, dynamic> document) async {
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

    return Customer(
      id: id,
      custNm: document["custNm"],
      email: document["email"],
      telNo: document["telNo"],
      adrs: document["adrs"],
      branchId: document["branchId"],
      updatedAt: DateTime.tryParse(document["updatedAt"]?.toString() ?? ""),
      custNo: document["custNo"],
      custTin: document["custTin"],
      regrNm: document["regrNm"],
      regrId: document["regrId"],
      modrNm: document["modrNm"],
      modrId: document["modrId"],
      ebmSynced: document["ebmSynced"],
      bhfId: document["bhfId"],
      useYn: document["useYn"],
      customerType: document["customerType"],
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
        debugPrint('Ditto seeding skipped for Customer (already seeded)');
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

      final models = await Repository().get<Customer>(
        query: query,
        policy: OfflineFirstGetPolicy.alwaysHydrate,
      );
      var seededCount = 0;
      for (final model in models) {
        await coordinator.notifyLocalUpsert<Customer>(model);
        seededCount++;
      }
      if (kDebugMode) {
        debugPrint('Ditto seeded ' +
            seededCount.toString() +
            ' Customer record' +
            (seededCount == 1 ? '' : 's'));
      }
    } catch (error, stack) {
      if (kDebugMode) {
        debugPrint('Ditto seeding failed for Customer: $error\n$stack');
      }
    }

    _seeded = true;
  }

  static final int _$CustomerDittoAdapterRegistryToken =
      DittoSyncGeneratedRegistry.register(
          (coordinator) async {
            await coordinator
                .registerAdapter<Customer>(CustomerDittoAdapter.instance);
          },
          modelType: Customer,
          seed: (coordinator) async {
            await _seed(coordinator);
          },
          reset: _resetSeedFlag);

  /// Public accessor to ensure static initializer runs
  static int get registryToken => _$CustomerDittoAdapterRegistryToken;
}
