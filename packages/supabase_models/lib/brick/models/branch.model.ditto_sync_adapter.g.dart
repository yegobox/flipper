// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'branch.model.dart';

// **************************************************************************
// DittoSyncAdapterGenerator
// **************************************************************************

// **************************************************************************
// DittoSyncAdapterGenerator
// **************************************************************************
//
// REQUIRED IMPORTS in parent file (branch.model.dart):
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

class BranchDittoAdapter extends DittoSyncAdapter<Branch> {
  BranchDittoAdapter._internal();

  static final BranchDittoAdapter instance = BranchDittoAdapter._internal();

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
  String get collectionName => "branches";

  @override
  SyncDirection get syncDirection => SyncDirection.bidirectional;

  @override
  bool get shouldHydrateOnStartup => false;

  @override
  bool get supportsBackupPull => false;

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
    return const DittoSyncQuery(query: "SELECT * FROM branches");
  }

  @override
  Future<DittoSyncQuery?> buildHydrationQuery() async {
    return _buildQuery(waitForBranchId: true);
  }

  @override
  Future<String?> documentIdForModel(Branch model) async => model.id;

  @override
  Future<Map<String, dynamic>> toDittoDocument(Branch model) async {
    return {
      "_id": model.id,
      "id": model.id,
      "name": model.name,
      "serverId": model.serverId,
      "location": model.location,
      "description": model.description,
      "active": model.active,
      "businessId": model.businessId,
      "latitude": model.latitude,
      "longitude": model.longitude,
      "isDefault": model.isDefault,
      "isOnline": model.isOnline,
      "deletedAt": model.deletedAt?.toIso8601String(),
      "updatedAt": model.updatedAt?.toIso8601String(),
    };
  }

  @override
  Future<Branch?> fromDittoDocument(Map<String, dynamic> document) async {
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

    return Branch(
      id: id,
      name: document["name"],
      serverId: document["serverId"],
      location: document["location"],
      description: document["description"],
      active: document["active"],
      businessId: document["businessId"],
      latitude: document["latitude"],
      longitude: document["longitude"],
      isDefault: document["isDefault"],
      isOnline: document["isOnline"],
      deletedAt: DateTime.tryParse(document["deletedAt"]?.toString() ?? ""),
      updatedAt: DateTime.tryParse(document["updatedAt"]?.toString() ?? ""),
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
        debugPrint('Ditto seeding skipped for Branch (already seeded)');
      }
      return;
    }

    try {
      Query? query;

      final models = await Repository().get<Branch>(
        query: query,
        policy: OfflineFirstGetPolicy.alwaysHydrate,
      );
      var seededCount = 0;
      for (final model in models) {
        await coordinator.notifyLocalUpsert<Branch>(model);
        seededCount++;
      }
      if (kDebugMode) {
        debugPrint('Ditto seeded ' +
            seededCount.toString() +
            ' Branch record' +
            (seededCount == 1 ? '' : 's'));
      }
    } catch (error, stack) {
      if (kDebugMode) {
        debugPrint('Ditto seeding failed for Branch: $error\n$stack');
      }
    }

    _seeded = true;
  }

  static final int _$BranchDittoAdapterRegistryToken =
      DittoSyncGeneratedRegistry.register(
          (coordinator) async {
            await coordinator
                .registerAdapter<Branch>(BranchDittoAdapter.instance);
          },
          modelType: Branch,
          seed: (coordinator) async {
            await _seed(coordinator);
          },
          reset: _resetSeedFlag);

  /// Public accessor to ensure static initializer runs
  static int get registryToken => _$BranchDittoAdapterRegistryToken;
}
