// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'itemCode.model.dart';

// **************************************************************************
// DittoSyncAdapterGenerator
// **************************************************************************

// **************************************************************************
// DittoSyncAdapterGenerator
// **************************************************************************

class ItemCodeDittoAdapter extends DittoSyncAdapter<ItemCode> {
  ItemCodeDittoAdapter._internal();

  static final ItemCodeDittoAdapter instance = ItemCodeDittoAdapter._internal();

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

  String get collectionName => "codes";

  @override
  Future<DittoSyncQuery?> buildObserverQuery() async {
    final branchId =
        _branchIdProviderOverride?.call() ?? ProxyService.box.getBranchId();
    if (branchId == null) {
      return const DittoSyncQuery(query: "SELECT * FROM codes");
    }
    return DittoSyncQuery(
      query: "SELECT * FROM codes WHERE branchId = :branchId",
      arguments: {"branchId": branchId},
    );
  }

  @override
  Future<String?> documentIdForModel(ItemCode model) async => model.id;

  @override
  Future<Map<String, dynamic>> toDittoDocument(ItemCode model) async {
    return {
      "id": model.id,
      "code": model.code,
      "createdAt": model.createdAt.toIso8601String(),
      "branchId": model.branchId,
    };
  }

  @override
  Future<ItemCode?> fromDittoDocument(Map<String, dynamic> document) async {
    final id = document["_id"] ?? document["id"];
    if (id == null) return null;

    // Branch filtering
    final currentBranch =
        _branchIdProviderOverride?.call() ?? ProxyService.box.getBranchId();
    final docBranch = document["branchId"];
    if (currentBranch != null && docBranch != currentBranch) {
      return null;
    }

    return ItemCode(
      id: id,
      code: document["code"],
      createdAt: DateTime.tryParse(document["createdAt"]?.toString() ?? "") ??
          DateTime.now().toUtc(),
      branchId: document["branchId"],
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
        debugPrint('Ditto seeding skipped for ItemCode (already seeded)');
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

      final models = await Repository().get<ItemCode>(
        query: query,
        policy: OfflineFirstGetPolicy.alwaysHydrate,
      );
      var seededCount = 0;
      for (final model in models) {
        await coordinator.notifyLocalUpsert<ItemCode>(model);
        seededCount++;
      }
      if (kDebugMode) {
        debugPrint('Ditto seeded ' +
            seededCount.toString() +
            ' ItemCode record' +
            (seededCount == 1 ? '' : 's'));
      }
    } catch (error, stack) {
      if (kDebugMode) {
        debugPrint('Ditto seeding failed for ItemCode: $error\n$stack');
      }
    }

    _seeded = true;
  }

  static final int _$ItemCodeDittoAdapterRegistryToken =
      DittoSyncGeneratedRegistry.register((coordinator) async {
    await coordinator.registerAdapter<ItemCode>(ItemCodeDittoAdapter.instance);
  }, seed: (coordinator) async {
    await _seed(coordinator);
  }, reset: _resetSeedFlag);

  /// Public accessor to ensure static initializer runs
  static int get registryToken => _$ItemCodeDittoAdapterRegistryToken;
}
