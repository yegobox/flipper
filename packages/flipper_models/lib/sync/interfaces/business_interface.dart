import 'dart:async';

import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/helperModels/business_type.dart';
import 'package:flipper_models/db_model_export.dart' hide BusinessType;

abstract class BusinessInterface {
  Future<Business?> activeBusiness({int? userId});
  Future<Category?> activeCategory({required String branchId});
  FutureOr<Business?> getBusinessById(
      {required String businessId, bool fetchOnline = false});
  Future<List<Business>> businesses(
      {String? userId, bool fetchOnline = false, bool active = false});
  Future<List<BusinessType>> businessTypes();
  FutureOr<Business?> getBusiness({String? businessId});
  Future<Business?> getBusinessFromOnlineGivenId(
      {required int id, required HttpClientInterface flipperHttpClient});
  Future<void> addBusiness(
      {required String id,
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
      String? businessTypeId,
      DateTime? lastTouched,
      required String phoneNumber,
      DateTime? deletedAt,
      required String encryptionKey});
  Future<void> updateBusiness(
      {required String businessId,
      String? name,
      bool? active,
      bool? isDefault,
      String? backupFileId});
  Future<Business?> defaultBusiness();
}
