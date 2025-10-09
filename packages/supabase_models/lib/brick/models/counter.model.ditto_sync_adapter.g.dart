// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter.model.dart';

// **************************************************************************
// DittoSyncAdapterGenerator
// **************************************************************************

// **************************************************************************
// DittoSyncAdapterGenerator
// **************************************************************************
//
// REQUIRED IMPORTS in parent file (counter.model.dart):
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

  @override
  String get collectionName => "counters";

  @override
  bool get shouldHydrateOnStartup => false;

  @override
  bool get supportsBackupPull => false;

  Future<int?> _resolveBranchId({bool waitForValue = false}) async {
    int? branchId =
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
      debugPrint("Ditto hydration for Counter timed out waiting for branchId");
    }
    return branchId;
  }

  @override
  Future<DittoSyncQuery?> buildObserverQuery() async {
    return _buildQuery(waitForBranchId: false);
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
              "Ditto hydration for Counter skipped because branch context is unavailable");
        }
        return null;
      }
      if (kDebugMode) {
        debugPrint(
            "Ditto observation for Counter deferred until branch context is available");
      }
      return const DittoSyncQuery(
        query: "SELECT * FROM counters WHERE 1 = 0",
      );
    }

    final whereClause = whereParts.join(" OR ");
    return DittoSyncQuery(
      query: "SELECT * FROM counters WHERE $whereClause",
      arguments: arguments,
    );
  }

  @override
  Future<DittoSyncQuery?> buildHydrationQuery() async {
    return _buildQuery(waitForBranchId: true);
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
      lastTouched: DateTime.tryParse(document["lastTouched"]?.toString() ?? ""),
      createdAt: DateTime.tryParse(document["createdAt"]?.toString() ?? ""),
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

  static void _resetSeedFlag() {
    _seeded = false;
  }

  static Future<void> _seed(DittoSyncCoordinator coordinator) async {
    if (_seeded) {
      if (kDebugMode) {
        debugPrint('Ditto seeding skipped for Counter (already seeded)');
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

      final models = await Repository().get<Counter>(
        query: query,
        policy: OfflineFirstGetPolicy.alwaysHydrate,
      );
      var seededCount = 0;
      for (final model in models) {
        await coordinator.notifyLocalUpsert<Counter>(model);
        seededCount++;
      }
      if (kDebugMode) {
        debugPrint('Ditto seeded ' +
            seededCount.toString() +
            ' Counter record' +
            (seededCount == 1 ? '' : 's'));
      }
    } catch (error, stack) {
      if (kDebugMode) {
        debugPrint('Ditto seeding failed for Counter: $error\n$stack');
      }
    }

    _seeded = true;
  }

  static final int _$CounterDittoAdapterRegistryToken =
      DittoSyncGeneratedRegistry.register(
          (coordinator) async {
            await coordinator
                .registerAdapter<Counter>(CounterDittoAdapter.instance);
          },
          modelType: Counter,
          seed: (coordinator) async {
            await _seed(coordinator);
          },
          reset: _resetSeedFlag);

  /// Public accessor to ensure static initializer runs
  static int get registryToken => _$CounterDittoAdapterRegistryToken;
}
