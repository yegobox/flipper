// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'business.model.dart';

// **************************************************************************
// DittoSyncAdapterGenerator
// **************************************************************************

// **************************************************************************
// DittoSyncAdapterGenerator
// **************************************************************************
//
// REQUIRED IMPORTS in parent file (business.model.dart):
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

class BusinessDittoAdapter extends DittoSyncAdapter<Business> {
  BusinessDittoAdapter._internal();

  static final BusinessDittoAdapter instance = BusinessDittoAdapter._internal();

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
  String get collectionName => "businesses";

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
    return const DittoSyncQuery(query: "SELECT * FROM businesses");
  }

  @override
  Future<DittoSyncQuery?> buildHydrationQuery() async {
    return _buildQuery(waitForBranchId: true);
  }

  @override
  Future<String?> documentIdForModel(Business model) async => model.id;

  @override
  Future<Map<String, dynamic>> toDittoDocument(Business model) async {
    return {
      "_id": model.id,
      "id": model.id,
      "serverId": model.serverId,
      "name": model.name,
      "currency": model.currency,
      "categoryId": model.categoryId,
      "latitude": model.latitude,
      "longitude": model.longitude,
      "userId": model.userId,
      "timeZone": model.timeZone,
      "country": model.country,
      "businessUrl": model.businessUrl,
      "hexColor": model.hexColor,
      "imageUrl": model.imageUrl,
      "type": model.type,
      "active": model.active,
      "chatUid": model.chatUid,
      "metadata": model.metadata,
      "role": model.role,
      "lastSeen": model.lastSeen,
      "firstName": model.firstName,
      "lastName": model.lastName,
      "createdAt": model.createdAt?.toIso8601String(),
      "deviceToken": model.deviceToken,
      "backUpEnabled": model.backUpEnabled,
      "subscriptionPlan": model.subscriptionPlan,
      "nextBillingDate": model.nextBillingDate,
      "previousBillingDate": model.previousBillingDate,
      "isLastSubscriptionPaymentSucceeded":
          model.isLastSubscriptionPaymentSucceeded,
      "backupFileId": model.backupFileId,
      "email": model.email,
      "lastDbBackup": model.lastDbBackup,
      "fullName": model.fullName,
      "tinNumber": model.tinNumber,
      "bhfId": model.bhfId,
      "dvcSrlNo": model.dvcSrlNo,
      "adrs": model.adrs,
      "taxEnabled": model.taxEnabled,
      "taxServerUrl": model.taxServerUrl,
      "isDefault": model.isDefault,
      "businessTypeId": model.businessTypeId,
      "referredBy": model.referredBy,
      "encryptionKey": model.encryptionKey,
      "phoneNumber": model.phoneNumber,
      "messagingChannels": model.messagingChannels,
    };
  }

  @override
  Future<Business?> fromDittoDocument(Map<String, dynamic> document) async {
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

    return Business(
      id: id,
      serverId: document["serverId"],
      name: document["name"],
      currency: document["currency"],
      categoryId: document["categoryId"],
      latitude: document["latitude"],
      longitude: document["longitude"],
      userId: document["userId"],
      timeZone: document["timeZone"],
      country: document["country"],
      businessUrl: document["businessUrl"],
      hexColor: document["hexColor"],
      imageUrl: document["imageUrl"],
      type: document["type"],
      active: document["active"],
      chatUid: document["chatUid"],
      metadata: document["metadata"],
      role: document["role"],
      lastSeen: document["lastSeen"],
      firstName: document["firstName"],
      lastName: document["lastName"],
      createdAt: DateTime.tryParse(document["createdAt"]?.toString() ?? ""),
      deviceToken: document["deviceToken"],
      backUpEnabled: document["backUpEnabled"],
      subscriptionPlan: document["subscriptionPlan"],
      nextBillingDate: document["nextBillingDate"],
      previousBillingDate: document["previousBillingDate"],
      isLastSubscriptionPaymentSucceeded:
          document["isLastSubscriptionPaymentSucceeded"],
      backupFileId: document["backupFileId"],
      email: document["email"],
      lastDbBackup: document["lastDbBackup"],
      fullName: document["fullName"],
      tinNumber: document["tinNumber"],
      bhfId: document["bhfId"],
      dvcSrlNo: document["dvcSrlNo"],
      adrs: document["adrs"],
      taxEnabled: document["taxEnabled"],
      taxServerUrl: document["taxServerUrl"],
      isDefault: document["isDefault"],
      businessTypeId: document["businessTypeId"],
      referredBy: document["referredBy"],
      encryptionKey: document["encryptionKey"],
      phoneNumber: document["phoneNumber"],
      messagingChannels: document["messagingChannels"],
      branches: null, // Excluded from Ditto sync
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
        debugPrint('Ditto seeding skipped for Business (already seeded)');
      }
      return;
    }

    try {
      Query? query;

      final models = await Repository().get<Business>(
        query: query,
        policy: OfflineFirstGetPolicy.alwaysHydrate,
      );
      var seededCount = 0;
      for (final model in models) {
        await coordinator.notifyLocalUpsert<Business>(model);
        seededCount++;
      }
      if (kDebugMode) {
        debugPrint('Ditto seeded ' +
            seededCount.toString() +
            ' Business record' +
            (seededCount == 1 ? '' : 's'));
      }
    } catch (error, stack) {
      if (kDebugMode) {
        debugPrint('Ditto seeding failed for Business: $error\n$stack');
      }
    }

    _seeded = true;
  }

  static final int _$BusinessDittoAdapterRegistryToken =
      DittoSyncGeneratedRegistry.register(
          (coordinator) async {
            await coordinator
                .registerAdapter<Business>(BusinessDittoAdapter.instance);
          },
          modelType: Business,
          seed: (coordinator) async {
            await _seed(coordinator);
          },
          reset: _resetSeedFlag);

  /// Public accessor to ensure static initializer runs
  static int get registryToken => _$BusinessDittoAdapterRegistryToken;
}
