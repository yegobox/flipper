import 'dart:async';
import 'dart:convert';
import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/helperModels/business.dart';
import 'package:flipper_models/helperModels/business_type.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_models/sync/interfaces/business_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:http/http.dart' as http;
import 'package:flipper_models/services/sqlite_service.dart';
import 'package:supabase_models/brick/databasePath.dart';
import 'package:path/path.dart' as path;
import 'package:flipper_models/helperModels/talker.dart';

mixin BusinessMixin implements BusinessInterface {
  Repository get repository;

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
  Future<List<Business>> businesses(
      {int? userId, bool fetchOnline = false}) async {
    return await repository.get<Business>(
        policy: fetchOnline
            ? OfflineFirstGetPolicy.alwaysHydrate
            : OfflineFirstGetPolicy.localOnly,
        query: Query(
            where: [if (userId != null) Where('userId').isExactly(userId)]));
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
        query: query, policy: OfflineFirstGetPolicy.alwaysHydrate);
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
        query: query, policy: OfflineFirstGetPolicy.alwaysHydrate);
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
          serverId: iBusiness.serverId,
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
    Business? exist = await getBusiness(businessId: serverId);

    if (exist != null) {
      // Only update tinNumber if the new value is not null
      if (tinNumber != null) {
        exist.tinNumber = tinNumber;
      }

      repository.upsert<Business>(exist);
    } else {
      repository.upsert<Business>(Business(
        id: id,
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
    try {
      // Get the database directory and construct the path using Repository.dbFileName
      final dbDir = await DatabasePath.getDatabaseDirectory();
      final dbPath = path.join(dbDir, Repository.dbFileName);

      // First, check if we need special handling for isDefault flag
      bool updateIsDefault = false;
      bool isDefaultValue = false;

      if (isDefault != null) {
        // Only set isDefault to true when explicitly requested
        if (isDefault == true) {
          updateIsDefault = true;
          isDefaultValue = true;
        }
        // If we're in login_choices.dart and explicitly setting isDefault to false, allow it
        else if (StackTrace.current.toString().contains('login_choices.dart')) {
          updateIsDefault = true;
          isDefaultValue = false;
        }
        // Otherwise preserve the existing isDefault value (don't change it during auto-logout)
      }

      // Build the SQL update statement with only the fields that are provided
      final List<String> updateParts = [];
      final List<Object?> params = [];

      if (active != null) {
        updateParts.add('active = ?');
        params.add(active ? 1 : 0); // SQLite uses 1 for true, 0 for false
      }

      if (updateIsDefault) {
        updateParts.add('is_default = ?');
        params.add(isDefaultValue ? 1 : 0);
      }

      if (name != null) {
        updateParts.add('name = ?');
        params.add(name);
      }

      if (backupFileId != null) {
        updateParts.add('backup_file_id = ?');
        params.add(backupFileId);
      }

      // Only proceed if we have fields to update
      if (updateParts.isNotEmpty) {
        // Add the business ID to the params list
        params.add(businessId);

        final sql =
            'UPDATE business SET ${updateParts.join(', ')} WHERE server_id = ?';

        // Execute the raw SQL update
        final rowsAffected = SqliteService.execute(dbPath, sql, params);

        talker
            .debug('Updated business $businessId: $rowsAffected rows affected');
      }
    } catch (e, stack) {
      talker.error('Error in updateBusiness: $e');
      talker.error('Stack trace: $stack');
      rethrow;
    }
  }

  @override
  Future<Business?> defaultBusiness() async {
    return (await repository.get<Business>(
            query: Query(where: [Where('isDefault').isExactly(true)])))
        .firstOrNull;
  }
}
