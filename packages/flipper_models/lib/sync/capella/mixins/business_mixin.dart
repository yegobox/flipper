import 'dart:async';

import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/sync/interfaces/business_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

mixin CapellaBusinessMixin implements BusinessInterface {
  Repository get repository;
  Talker get talker;

  @override
  Future<Branch> activeBranch() async {
    throw UnimplementedError(
        'activeBranch needs to be implemented for Capella');
  }

  @override
  Future<Business?> activeBusiness({int? userId}) async {
    throw UnimplementedError(
        'activeBusiness needs to be implemented for Capella');
  }

  @override
  Future<Category?> activeCategory({required int branchId}) async {
    throw UnimplementedError(
        'activeCategory needs to be implemented for Capella');
  }

  @override
  FutureOr<Business?> getBusinessById({required int businessId}) async {
    throw UnimplementedError(
        'getBusinessById needs to be implemented for Capella');
  }

  @override
  Future<List<Business>> businesses(
      {int? userId, bool fetchOnline = false, bool active = false}) async {
    throw UnimplementedError('businesses needs to be implemented for Capella');
  }

  @override
  FutureOr<Business?> getBusiness({int? businessId}) async {
    throw UnimplementedError('getBusiness needs to be implemented for Capella');
  }

  @override
  Future<Business?> getBusinessFromOnlineGivenId(
      {required int id, required HttpClientInterface flipperHttpClient}) async {
    throw UnimplementedError(
        'getBusinessFromOnlineGivenId needs to be implemented for Capella');
  }

  @override
  Future<void> addBusiness(
      {required String id,
      required int userId,
      required int serverId,
      String? name,
      String? currency,
      String? categoryId,
      String? latitude,
      String? longitude,
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
      DateTime? deletedAt,
      required String encryptionKey}) async {
    throw UnimplementedError('addBusiness needs to be implemented for Capella');
  }

  @override
  Future<void> updateBusiness(
      {required int businessId,
      String? name,
      bool? active,
      bool? isDefault,
      String? backupFileId}) async {
    throw UnimplementedError(
        'updateBusiness needs to be implemented for Capella');
  }

  @override
  Future<Business?> defaultBusiness() async {
    throw UnimplementedError(
        'defaultBusiness needs to be implemented for Capella');
  }
}
