import 'package:flipper_services/proxy.dart';
import 'dart:async';

import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/sync/interfaces/business_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flipper_models/sync/capella/category_ditto_mapper.dart';

mixin CapellaBusinessMixin implements BusinessInterface {
  Repository get repository;
  Talker get talker;
  DittoService get dittoService => DittoService.instance;

  // TODO(ditto-migration): port `activeBusiness` to Ditto.
  @override
  Future<Business?> activeBusiness({int? userId}) async {
    return ProxyService.legacyStrategy.activeBusiness();
  }

  @override
  Future<Category?> activeCategory({required String branchId}) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      talker.error('Ditto not initialized for activeCategory');
      return null;
    }
    try {
      final result = await ditto.store.execute(
        'SELECT * FROM categories WHERE branchId = :branchId '
        'AND focused = :focused AND active = :active LIMIT 1',
        arguments: {'branchId': branchId, 'focused': true, 'active': true},
      );
      if (result.items.isEmpty) return null;
      final data = Map<String, dynamic>.from(result.items.first.value);
      return categoryFromDittoMap(data);
    } catch (e, s) {
      talker.error('Error in Capella activeCategory: $e', s);
      return null;
    }
  }

  @override
  FutureOr<Business?> getBusinessById({
    required String businessId,
    bool fetchOnline = false,
  }) async {
    final query = Query(where: [Where('id').isExactly(businessId)]);
    final result = await repository.get<Business>(
      query: query,
      policy: fetchOnline
          ? OfflineFirstGetPolicy.awaitRemoteWhenNoneExist
          : OfflineFirstGetPolicy.localOnly,
    );
    return result.firstOrNull;
  }

  // TODO(ditto-migration): port `businesses` to Ditto.
  @override
  Future<List<Business>> businesses({
    String? userId,
    bool fetchOnline = false,
    bool active = false,
  }) async {
    return ProxyService.legacyStrategy.businesses(userId: userId, fetchOnline: fetchOnline, active: active);
  }

  @override
  Future<Business?> getBusiness({String? businessId}) async {
    final query = Query(
      where: businessId != null
          ? [Where('id').isExactly(businessId)]
          : [Where('isDefault').isExactly(true)],
    );
    final result = await repository.get<Business>(
      query: query,
      policy: OfflineFirstGetPolicy.localOnly,
    );
    return result.firstOrNull;
  }

  // TODO(ditto-migration): port `getBusinessFromOnlineGivenId` to Ditto.
  @override
  Future<Business?> getBusinessFromOnlineGivenId({
    required int id,
    required HttpClientInterface flipperHttpClient,
  }) async {
    return ProxyService.legacyStrategy.getBusinessFromOnlineGivenId(id: id, flipperHttpClient: flipperHttpClient);
  }

  // TODO(ditto-migration): port `addBusiness` to Ditto.
  @override
  Future<void> addBusiness({
    required String id,
    required String userId,
    required int serverId,
    required String businessId,
    String? name,
    String? currency,
    String? categoryId,
    num? latitude,
    num? longitude,
    String? timeZone,
    String? country,
    String? businessUrl,
    String? hexColor,
    String? imageUrl,
    String? type,
    bool? active,
    String? chatUid,
    String? metadata,
    String? role,
    int? lastSeen,
    String? firstName,
    String? lastName,
    String? createdAt,
    String? deviceToken,
    bool? backUpEnabled,
    String? subscriptionPlan,
    String? nextBillingDate,
    String? previousBillingDate,
    bool? isLastSubscriptionPaymentSucceeded,
    String? backupFileId,
    String? email,
    String? lastDbBackup,
    String? fullName,
    int? tinNumber,
    required String bhfId,
    String? dvcSrlNo,
    String? adrs,
    bool? taxEnabled,
    String? taxServerUrl,
    bool? isDefault,
    int? businessTypeId,
    DateTime? lastTouched,
    required String phoneNumber,
    DateTime? deletedAt,
    required String encryptionKey,
  }) async {
    return ProxyService.legacyStrategy.addBusiness(id: id, userId: userId, serverId: serverId, businessId: businessId, name: name, currency: currency, categoryId: categoryId, latitude: latitude, longitude: longitude, timeZone: timeZone, country: country, businessUrl: businessUrl, hexColor: hexColor, imageUrl: imageUrl, type: type, active: active, chatUid: chatUid, metadata: metadata, role: role, lastSeen: lastSeen, firstName: firstName, lastName: lastName, createdAt: createdAt, deviceToken: deviceToken, backUpEnabled: backUpEnabled, subscriptionPlan: subscriptionPlan, nextBillingDate: nextBillingDate, previousBillingDate: previousBillingDate, isLastSubscriptionPaymentSucceeded: isLastSubscriptionPaymentSucceeded, backupFileId: backupFileId, email: email, lastDbBackup: lastDbBackup, fullName: fullName, tinNumber: tinNumber, bhfId: bhfId, dvcSrlNo: dvcSrlNo, adrs: adrs, taxEnabled: taxEnabled, taxServerUrl: taxServerUrl, isDefault: isDefault, businessTypeId: businessTypeId, lastTouched: lastTouched, phoneNumber: phoneNumber, deletedAt: deletedAt, encryptionKey: encryptionKey);
  }

  // TODO(ditto-migration): port `updateBusiness` to Ditto.
  @override
  Future<void> updateBusiness({
    required String businessId,
    String? name,
    bool? active,
    bool? isDefault,
    String? backupFileId,
  }) async {
    return ProxyService.legacyStrategy.updateBusiness(businessId: businessId, name: name, active: active, isDefault: isDefault, backupFileId: backupFileId);
  }

  // TODO(ditto-migration): port `defaultBusiness` to Ditto.
  @override
  Future<Business?> defaultBusiness() async {
    return ProxyService.legacyStrategy.defaultBusiness();
  }
}
