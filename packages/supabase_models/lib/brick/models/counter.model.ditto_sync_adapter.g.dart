// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter.model.dart';

// **************************************************************************
// DittoSyncAdapterGenerator
// **************************************************************************

// **************************************************************************
// DittoSyncAdapterGenerator
// **************************************************************************

class CounterDittoAdapter extends DittoSyncAdapter<Counter> {
  CounterDittoAdapter._internal();

  static final CounterDittoAdapter instance = CounterDittoAdapter._internal();

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

  String get collectionName => "counters";

  @override
  Future<DittoSyncQuery?> buildObserverQuery() async {
    final branchId =
        _branchIdProviderOverride?.call() ?? ProxyService.box.getBranchId();
    if (branchId == null) {
      return const DittoSyncQuery(query: "SELECT * FROM counters");
    }
    return DittoSyncQuery(
      query: "SELECT * FROM counters WHERE branchId = :branchId",
      arguments: {"branchId": branchId},
    );
  }

  @override
  Future<String?> documentIdForModel(Counter model) async => model.id;

  @override
  Future<Map<String, dynamic>> toDittoDocument(Counter model) async {
    return {
      "id": model.id,
      "businessId": model.businessId,
      "branchId": model.branchId,
      "receiptType": model.receiptType,
      "totRcptNo": model.totRcptNo,
      "curRcptNo": model.curRcptNo,
      "invcNo": model.invcNo,
      "lastTouched": model.lastTouched?.toIso8601String(),
      "createdAt": model.createdAt?.toIso8601String(),
      "bhfId": model.bhfId,
    };
  }

  @override
  Future<Counter?> fromDittoDocument(Map<String, dynamic> document) async {
    final id = document["_id"] ?? document["id"];
    if (id == null) return null;

    // Branch filtering
    final currentBranch =
        _branchIdProviderOverride?.call() ?? ProxyService.box.getBranchId();
    final docBranch = document["branchId"];
    if (currentBranch != null && docBranch != currentBranch) {
      return null;
    }

    return Counter(
      id: id,
      businessId: document["businessId"],
      branchId: document["branchId"],
      receiptType: document["receiptType"],
      totRcptNo: document["totRcptNo"],
      curRcptNo: document["curRcptNo"],
      invcNo: document["invcNo"],
      lastTouched: document["lastTouched"] != null
          ? DateTime.tryParse(document["lastTouched"])
          : null,
      createdAt: document["createdAt"] != null
          ? DateTime.tryParse(document["createdAt"])
          : null,
      bhfId: document["bhfId"],
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

  static Future<void> _seed(DittoSyncCoordinator coordinator) async {
    if (_seeded) {
      return;
    }

    try {
      Query? query;
      final branchId =
          _branchIdProviderOverride?.call() ?? ProxyService.box.getBranchId();
      if (branchId != null) {
        query = Query(where: [Where('branchId').isExactly(branchId)]);
      }

      final models = await Repository().get<Counter>(
        query: query,
        policy: OfflineFirstGetPolicy.alwaysHydrate,
      );
      for (final model in models) {
        await coordinator.notifyLocalUpsert<Counter>(model);
      }
    } catch (error, stack) {
      if (kDebugMode) {
        debugPrint('Ditto seeding failed for Counter: $error\n$stack');
      }
    }

    _seeded = true;
  }

  static final int _$CounterDittoAdapterRegistryToken =
      DittoSyncGeneratedRegistry.register((coordinator) async {
    await coordinator.registerAdapter<Counter>(CounterDittoAdapter.instance);
  }, seed: (coordinator) async {
    await _seed(coordinator);
  });
}
