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

mixin TenantMixin implements TenantInterface {
  String get apihub;
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
    int? businessId,
    bool? sessionActive,
    int? branchId,
    String? imageUrl,
    int? pin,
    bool? isDefault,
    required HttpClientInterface flipperHttpClient,
    required String userType,
  }) async {
    final data = jsonEncode({
      "phoneNumber": phoneNumber,
      "name": name,
      "businessId": business.serverId,
      "permissions": [
        {"name": userType.toLowerCase()}
      ],
      "businesses": [
        {
          ...business.toJson(),
          'id': business.serverId,
        }
      ],
      "branches": [
        {
          ...branch.toJson(),
          'id': branch.serverId,
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
          pin: jTenant.userId!,
          branchId: business.serverId.toString(),
          businessId: branch.serverId!.toString(),
          defaultApp: 1,
        );

        return Tenant(
          name: name,
          phoneNumber: phoneNumber,
          email: email,
          nfcEnabled: false,
          businessId: business.serverId,
          userId: jTenant.userId,
          isDefault: true,
          pin: jTenant.userId,
        );
      } catch (e) {
        rethrow;
      }
    } else {
      throw InternalServerError(term: "internal server error");
    }
  }

  @override
  Stream<Tenant?> getDefaultTenant({required int businessId}) {
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

      /// TODO: parsing here is not good why not pass them as int?? to be fixed soon
      "branchId": int.parse(branchId),
      "businessId": int.parse(businessId),
      "defaultApp": defaultApp,
    });

    final http.Response response = await flipperHttpClient
        .post(Uri.parse("$apihub/v2/api/pin"), body: data);

    if (response.statusCode != 200) {
      throw InternalServerError(term: "internal server error");
    }
  }

  @override
  FutureOr<Tenant?> tenant({int? businessId, int? userId, String? id}) async {
    if (businessId != null) {
      return (await repository.get<Tenant>(
              query: Query(where: [Where('businessId').isExactly(businessId)])))
          .firstOrNull;
    } else if (userId != null) {
      return (await repository.get<Tenant>(
              query: Query(where: [Where('userId').isExactly(userId)])))
          .firstOrNull;
    } else {
      return (await repository.get<Tenant>(
              query: Query(where: [Where('id').isExactly(id)])))
          .firstOrNull;
    }
  }

  @override
  Future<List<Tenant>> tenants({int? businessId, int? excludeUserId}) {
    return repository.get<Tenant>(
        query: Query(where: [
      Where('businessId').isExactly(businessId),
      if (excludeUserId != null) Where('userId').isNot(excludeUserId),
    ]));
  }

  @override
  Future<List<ITenant>> tenantsFromOnline(
      {required int businessId,
      required HttpClientInterface flipperHttpClient}) async {
    final http.Response response = await flipperHttpClient
        .get(Uri.parse("$apihub/v2/api/tenant/$businessId"));
    if (response.statusCode == 200) {
      final tenantToAdd = <Tenant>[];
      for (ITenant tenant in ITenant.fromJsonList(response.body)) {
        ITenant jTenant = tenant;
        Tenant iTenant = Tenant(
            isDefault: jTenant.isDefault,
            name: jTenant.name,
            userId: jTenant.userId,
            businessId: jTenant.businessId,
            nfcEnabled: jTenant.nfcEnabled ?? false,
            email: jTenant.email,
            phoneNumber: jTenant.phoneNumber);

        for (IBusiness business in jTenant.businesses) {
          Business biz = Business(
              serverId: business.serverId,
              userId: int.parse(business.userId),
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
              tinNumber: business.tinNumber,
              bhfId: business.bhfId,
              dvcSrlNo: business.dvcSrlNo,
              adrs: business.adrs,
              taxEnabled: business.taxEnabled,
              isDefault: business.isDefault,
              businessTypeId: business.businessTypeId,
              lastTouched: business.lastTouched,
              deletedAt: business.deletedAt,
              encryptionKey: business.encryptionKey);
          Business? exist = (await repository.get<Business>(
                  query:
                      Query(where: [Where('serverId').isExactly(business.id)])))
              .firstOrNull;
          if (exist == null) {
            await repository.upsert<Business>(biz);
          }
        }

        for (IBranch brannch in jTenant.branches) {
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
        for (IPermission permission in jTenant.permissions) {
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
      int? userId,
      int? businessId,
      String? type,
      int? id,
      int? pin,
      bool? sessionActive,
      int? branchId}) async {
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
}
