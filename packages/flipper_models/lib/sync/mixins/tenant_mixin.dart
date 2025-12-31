import 'dart:async';
import 'dart:convert';

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/branch.dart';
import 'package:flipper_models/helperModels/business.dart';
import 'package:flipper_models/helperModels/permission.dart';
import 'package:flipper_models/helperModels/tenant.dart';
import 'package:flipper_models/sync/interfaces/tenant_interface.dart';
import 'package:flipper_models/flipper_http_client.dart';
import 'package:supabase_models/brick/models/user.model.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:http/http.dart' as http;
import 'package:flipper_models/ebm_helper.dart';

mixin TenantMixin implements TenantInterface {
  String get apihub;
  Repository get repository;

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
  Future<Tenant?> addNewTenant({
    required Business business,
    required Branch branch,
    String? phoneNumber,
    String? name,
    String? id,
    String? email,
    String? businessId,
    bool? sessionActive,
    String? branchId,
    String? imageUrl,
    int? pin,
    bool? isDefault,
    required HttpClientInterface flipperHttpClient,
    required String userType,
  }) async {
    final data = jsonEncode({
      "phoneNumber": phoneNumber,
      "name": name,
      "businessId": business.id,
      "type": userType.toLowerCase(),
      "permissions": [
        {"name": userType.toLowerCase()}
      ],
      "businesses": [
        {
          ...business.toFlipperJson(),
          'id': business.id,
        }
      ],
      "branches": [
        {
          ...branch.toFlipperJson(),
          'id': branch.id,
        }
      ]
    });

    final http.Response response = await flipperHttpClient
        .post(Uri.parse("$apihub/v2/api/tenant"), body: data);

    if (response.statusCode == 200) {
      try {
        ITenant jTenant = ITenant.fromRawJson(response.body);
        await createPin(
          flipperHttpClient: flipperHttpClient,
          phoneNumber: phoneNumber!,
          pin: jTenant.pin!,
          branchId: branch.id.toString(),
          businessId: business.id.toString(),
          defaultApp: 1,
        );

        return Tenant(
          name: name,
          phoneNumber: phoneNumber,
          email: email,
          nfcEnabled: false,
          businessId: business.id,
          userId: jTenant.userId,
          pin: jTenant.pin,
        );
      } catch (e) {
        rethrow;
      }
    } else if (response.statusCode == 422) {
      // Handle duplicate tenant error
      // Determine if the input is an email or phone number
      final bool isEmail = phoneNumber?.contains('@') ?? false;
      final String inputType = isEmail ? 'email' : 'phone number';
      String errorMessage = 'A user with this $inputType already exists';

      try {
        final errorData = jsonDecode(response.body);
        if (errorData is Map && errorData.containsKey('message')) {
          errorMessage = errorData['message'];
        } else if (errorData is Map && errorData.containsKey('error')) {
          errorMessage = errorData['error'];
        }
      } catch (e) {
        // If parsing fails, use the context-aware default message
      }

      throw DuplicateTenantException(errorMessage);
    } else {
      throw InternalServerError(term: "internal server error");
    }
  }

  @override
  Stream<Tenant?> getDefaultTenant({required String businessId}) {
    // Add default tenant retrieval logic here
    throw UnimplementedError();
  }

  @override
  Future<User> saveUser({required User user}) {
    return repository.upsert(user);
  }

  @override
  Future<User?> authUser({required String uuid}) async {
    return (await repository.get<User>(
      policy: OfflineFirstGetPolicy.awaitRemote,
      query: Query(
        where: [Where('uuid').isExactly(uuid)],
      ),
    ))
        .firstOrNull;
  }

  @override
  Future<void> createPin({
    required HttpClientInterface flipperHttpClient,
    required String phoneNumber,
    required int pin,
    required String branchId,
    required String businessId,
    required int defaultApp,
  }) async {
    final data = jsonEncode({
      "phoneNumber": phoneNumber,
      "pin": pin,
      "userId": pin.toString(),
      "branchId": int.parse(branchId),
      "businessId": int.parse(businessId),
      "defaultApp": defaultApp,
    });

    final http.Response response = await flipperHttpClient
        .post(Uri.parse("$apihub/v2/api/pin"), body: data);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw InternalServerError(term: "internal server error");
    }
  }

  @override
  Future<Tenant?> tenant(
      {String? businessId,
      String? userId,
      String? id,
      required bool fetchRemote}) async {
    if (businessId != null) {
      return (await repository.get<Tenant>(
              policy: fetchRemote
                  ? OfflineFirstGetPolicy.awaitRemote
                  : OfflineFirstGetPolicy.localOnly,
              query: Query(where: [Where('businessId').isExactly(businessId)])))
          .firstOrNull;
    } else if (userId != null) {
      return (await repository.get<Tenant>(
              policy: fetchRemote
                  ? OfflineFirstGetPolicy.awaitRemote
                  : OfflineFirstGetPolicy.localOnly,
              query: Query(where: [
                Where('userId').isExactly(userId),
                Where('pin').isExactly(userId),
              ])))
          .firstOrNull;
    } else {
      return (await repository.get<Tenant>(
              policy: fetchRemote
                  ? OfflineFirstGetPolicy.awaitRemote
                  : OfflineFirstGetPolicy.localOnly,
              query: Query(where: [Where('id').isExactly(id)])))
          .firstOrNull;
    }
  }

  @override
  Future<List<Tenant>> tenants({String? businessId, int? excludeUserId}) {
    return repository.get<Tenant>(
        query: Query(where: [
      Where('businessId').isExactly(businessId),
      if (excludeUserId != null) Where('userId').isNot(excludeUserId),
    ]));
  }

  @override
  Future<List<ITenant>> tenantsFromOnline(
      {required String businessId,
      required HttpClientInterface flipperHttpClient}) async {
    final http.Response response = await flipperHttpClient
        .get(Uri.parse("$apihub/v2/api/tenant/$businessId"));
    if (response.statusCode == 200) {
      final tenantToAdd = <Tenant>[];
      for (ITenant tenant in ITenant.fromJsonList(response.body)) {
        ITenant jTenant = tenant;
        Tenant iTenant = Tenant(
            name: jTenant.name,
            userId: jTenant.userId,
            businessId: jTenant.businessId,
            nfcEnabled: jTenant.nfcEnabled ?? false,
            email: jTenant.email,
            phoneNumber: jTenant.phoneNumber);

        for (IBusiness business in jTenant.businesses ?? []) {
          Business biz = Business(
              phoneNumber: business.phoneNumber!,
              serverId: business.serverId!,
              userId: business.userId,
              name: business.name,
              currency: business.currency,
              categoryId: business.categoryId,
              latitude: business.latitude,
              longitude: business.longitude,
              timeZone: business.timeZone,
              country: business.country,
              businessUrl: business.businessUrl,
              hexColor: business.hexColor,
              imageUrl: business.imageUrl,
              type: business.type,
              active: false,
              chatUid: business.chatUid,
              metadata: business.metadata,
              role: business.role,
              lastSeen: business.lastSeen,
              firstName: business.firstName,
              lastName: business.lastName,
              deviceToken: business.deviceToken,
              backUpEnabled: business.backUpEnabled,
              subscriptionPlan: business.subscriptionPlan,
              nextBillingDate: business.nextBillingDate,
              previousBillingDate: business.previousBillingDate,
              isLastSubscriptionPaymentSucceeded:
                  business.isLastSubscriptionPaymentSucceeded,
              backupFileId: business.backupFileId,
              email: business.email,
              lastDbBackup: business.lastDbBackup,
              fullName: business.fullName,
              tinNumber: await effectiveTin(business: business),
              bhfId: business.bhfId,
              dvcSrlNo: business.dvcSrlNo,
              adrs: business.adrs,
              taxEnabled: business.taxEnabled,
              isDefault: false,
              businessTypeId: business.businessTypeId,
              encryptionKey: business.encryptionKey);
          Business? exist = (await repository.get<Business>(
                  query:
                      Query(where: [Where('serverId').isExactly(business.id)])))
              .firstOrNull;
          if (exist == null) {
            await repository.upsert<Business>(biz);
          }
        }

        for (IBranch brannch in jTenant.branches ?? []) {
          Branch branch = Branch(
              serverId: brannch.serverId,
              active: brannch.active,
              description: brannch.description,
              name: brannch.name,
              businessId: brannch.businessId,
              longitude: brannch.longitude,
              latitude: brannch.latitude,
              isDefault: brannch.isDefault);
          Branch? exist = (await repository.get<Branch>(
                  query:
                      Query(where: [Where('serverId').isExactly(brannch.id)])))
              .firstOrNull;
          if (exist == null) {
            await repository.upsert<Branch>(branch);
          }
        }

        final permissionToAdd = <LPermission>[];
        for (IPermission permission in jTenant.permissions ?? []) {
          LPermission? exist = (await repository.get<LPermission>(
                  query: Query(where: [Where('id').isExactly(permission.id)])))
              .firstOrNull;
          if (exist == null) {
            final perm = LPermission(name: permission.name);
            permissionToAdd.add(perm);
          }
        }

        for (LPermission permission in permissionToAdd) {
          await repository.upsert<LPermission>(permission);
        }

        Tenant? tenanti = (await repository.get<Tenant>(
                query:
                    Query(where: [Where('userId').isExactly(iTenant.userId)])))
            .firstOrNull;

        if (tenanti == null) {
          tenantToAdd.add(iTenant);
        }
      }

      if (tenantToAdd.isNotEmpty) {
        for (Tenant tenant in tenantToAdd) {
          await repository.upsert<Tenant>(tenant);
        }
      }

      return ITenant.fromJsonList(response.body);
    }
    throw InternalServerException(term: "we got unexpected response");
  }

  @override
  Future<void> updateTenant(
      {String? tenantId,
      String? name,
      String? phoneNumber,
      String? email,
      String? userId,
      String? businessId,
      String? type,
      String? id,
      int? pin,
      bool? sessionActive,
      String? branchId}) async {
    final tenant = (await repository.get<Tenant>(
            query: Query(where: [
      Where('userId').isExactly(userId),
    ])))
        .firstOrNull;

    repository.upsert<Tenant>(Tenant(
      id: tenant?.id ?? tenantId,
      name: name ?? tenant?.name,
      userId: userId ?? tenant?.userId,
      phoneNumber: phoneNumber ?? tenant?.phoneNumber,
      email: email ?? tenant?.email,
      businessId: businessId ?? tenant?.businessId,
      type: type ?? tenant?.type ?? "Agent",
      pin: pin ?? tenant?.pin,
      sessionActive: sessionActive ?? tenant?.sessionActive,
    ));
  }

  @override
  Future<void> deleteTenantsWithNullPin({String? businessId}) async {
    // Fetch tenants scoped by businessId if provided, otherwise all tenants.
    final query = Query(where: [
      if (businessId != null) Where('businessId').isExactly(businessId),
    ]);

    final tenants = await repository.get<Tenant>(query: query);

    for (final tenant in tenants) {
      try {
        if (tenant.pin == null) {
          await repository.delete<Tenant>(tenant);
        }
      } catch (e) {
        // Swallow errors for now but continue deleting others. Caller can
        // rely on logs or higher-level handling if necessary.
      }
    }
  }
}
