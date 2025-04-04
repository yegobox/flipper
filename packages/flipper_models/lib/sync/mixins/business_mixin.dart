import 'dart:async';
import 'dart:convert';
import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/helperModels/business.dart';
import 'package:flipper_models/helperModels/business_type.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_models/sync/interfaces/business_interface.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:http/http.dart' as http;

mixin BusinessMixin implements BusinessInterface {
  Repository get repository;

  @override
  Future<Branch> activeBranch() async {
    final branches = await repository.get<Branch>(
      policy: OfflineFirstGetPolicy.localOnly,
    );

    return branches.firstWhere(
      (branch) => branch.isDefault == true || branch.isDefault == 1,
      orElse: () => throw Exception("No default branch found"),
    );
  }

  @override
  Future<List<BusinessType>> businessTypes() async {
    final responseJson = [
      {"id": "1", "typeName": "Flipper Retailer"}
    ];
    await Future.delayed(Duration(seconds: 5));
    final response = http.Response(jsonEncode(responseJson), 200);
    if (response.statusCode == 200) {
      return BusinessType.fromJsonList(jsonEncode(responseJson));
    }
    return BusinessType.fromJsonList(jsonEncode(responseJson));
  }

  @override
  Future<List<Business>> businesses({required int userId}) async {
    return await repository.get<Business>(
        query: Query(where: [Where('userId').isExactly(userId)]));
  }

  @override
  Future<Business?> activeBusiness({int? userId}) async {
    return (await repository.get<Business>(
      policy: OfflineFirstGetPolicy.localOnly,
      query: Query(
        where: [
          if (userId != null) Where('userId').isExactly(userId),
          Where('isDefault').isExactly(true),
        ],
      ),
    ))
        .firstOrNull;
  }

  @override
  Future<Category?> activeCategory({required int branchId}) async {
    return (await repository.get<Category>(
            query: Query(where: [
              Where('focused').isExactly(true),
              Where('active').isExactly(true),
              Where('branchId').isExactly(branchId),
            ], limit: 1),
            policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist))
        .firstOrNull;
  }

  @override
  FutureOr<Business?> getBusinessById({required int businessId}) async {
    final repository = Repository();
    final query = Query(where: [Where('serverId').isExactly(businessId)]);
    final result = await repository.get<Business>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return result.firstOrNull;
  }

  @override
  FutureOr<Business?> getBusiness({int? businessId}) async {
    final repository = Repository();
    final query = Query(
        where: businessId != null
            ? [Where('serverId').isExactly(businessId)]
            : [Where('isDefault').isExactly(true)]);
    final result = await repository.get<Business>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return result.firstOrNull;
  }

  final String apihub = AppSecrets.apihubProd;

  @override
  Future<Business?> getBusinessFromOnlineGivenId(
      {required int id, required HttpClientInterface flipperHttpClient}) async {
    final repository = Repository();
    final query = Query(where: [Where('serverId').isExactly(id)]);
    final result = await repository.get<Business>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    Business? business = result.firstOrNull;

    if (business != null) return business;
    final http.Response response =
        await flipperHttpClient.get(Uri.parse("$apihub/v2/api/business/$id"));
    if (response.statusCode == 200) {
      int id = randomNumber();
      IBusiness iBusiness = IBusiness.fromJson(json.decode(response.body));
      Business business = Business(
          serverId: iBusiness.id,
          name: iBusiness.name,
          userId: int.parse(iBusiness.userId),
          createdAt: DateTime.now());

      business.serverId = id;
      await repository.upsert<Business>(business);
      return business;
    }
    return null;
  }

  @override
  Future<void> addBusiness(
      {required int id,
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
    Business? exist = await getBusiness(businessId: serverId);

    if (exist != null) {
      exist.tinNumber = tinNumber;

      repository.upsert<Business>(exist);
    } else {
      repository.upsert<Business>(Business(
        serverId: serverId,
        name: name,
        currency: currency,
        categoryId: categoryId,
        latitude: latitude,
        longitude: longitude,
        timeZone: timeZone,
        country: country,
        businessUrl: businessUrl,
        hexColor: hexColor,
        imageUrl: imageUrl,
        type: type,
        active: active,
        chatUid: chatUid,
        tinNumber: tinNumber,
        metadata: metadata,
        role: role,
        userId: userId,
        lastSeen: lastSeen,
        firstName: firstName,
        lastName: lastName,
        deviceToken: deviceToken,
        backUpEnabled: backUpEnabled,
        subscriptionPlan: subscriptionPlan,
        nextBillingDate: nextBillingDate,
        previousBillingDate: previousBillingDate,
        isLastSubscriptionPaymentSucceeded: isLastSubscriptionPaymentSucceeded,
        backupFileId: backupFileId,
        email: email,
        lastDbBackup: lastDbBackup,
        fullName: fullName,
        bhfId: bhfId,
        dvcSrlNo: dvcSrlNo,
        adrs: adrs,
        taxEnabled: taxEnabled,
        taxServerUrl: taxServerUrl,
        isDefault: isDefault,
        businessTypeId: businessTypeId,
        lastTouched: lastTouched,
        deletedAt: deletedAt,
        encryptionKey: encryptionKey,
      ));
    }
  }

  @override
  Future<void> updateBusiness(
      {required int businessId,
      String? name,
      bool? active,
      bool? isDefault,
      String? backupFileId}) async {
    final query = Query(where: [Where('serverId').isExactly(businessId)]);
    final business = await repository.get<Business>(query: query);
    if (business.firstOrNull != null) {
      Business businessUpdate = business.first;

      // Special handling for isDefault flag
      // Only update isDefault to true when explicitly set to true
      // Preserve existing isDefault value when set to false during logout
      if (isDefault != null) {
        // Only set isDefault to true when explicitly requested
        // Ignore attempts to set it to false during automatic logouts
        if (isDefault == true) {
          businessUpdate.isDefault = true;
        }
        // If we're in login_choices.dart and explicitly setting isDefault to false, allow it
        // This is needed for proper business switching
        else if (StackTrace.current.toString().contains('login_choices.dart')) {
          businessUpdate.isDefault = false;
        }
        // Otherwise preserve the existing isDefault value (don't change it during auto-logout)
      }

      // Update active status when provided
      if (active != null) {
        businessUpdate.active = active;
      }

      // Update other properties
      if (name != null) {
        businessUpdate.name = name;
      }
      if (backupFileId != null) {
        businessUpdate.backupFileId = backupFileId;
      }

      repository.upsert<Business>(businessUpdate);
    }
  }

  @override
  Future<Business?> defaultBusiness() async {
    return (await repository.get<Business>(
            query: Query(where: [Where('isDefault').isExactly(true)])))
        .firstOrNull;
  }
}
