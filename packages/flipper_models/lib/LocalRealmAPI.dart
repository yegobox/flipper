import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flipper_models/LocalRealm.dart';
import 'package:flipper_models/exceptions.dart';
import 'package:flipper_models/helperModels/branch.dart';
import 'package:flipper_models/helperModels/business.dart';
import 'package:flipper_models/helperModels/iuser.dart';
import 'package:flipper_models/helperModels/permission.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/helperModels/tenant.dart';
import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_models/RealmApi.dart';
import 'package:flipper_models/realmInterface.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_services/proxy.dart';
import 'package:path_provider/path_provider.dart';
import 'package:realm/realm.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/foundation.dart' as foundation;

class LocalRealmApi extends RealmAPI implements LocalRealmInterface {
  final talker = TalkerFlutter.init();
  @override
  Realm? localRealm;

  @override
  Future<LocalRealmInterface> configureLocal(
      {required bool useInMemory}) async {
    talker.warning("Opening local realm alongside the synced one!");

    // Set API keys based on the environment
    if (foundation.kDebugMode) {
      apihub = AppSecrets.apihubUat;
      commApi = AppSecrets.commApi;
    } else {
      apihub = AppSecrets.apihubProd;
      commApi = AppSecrets.commApi;
    }

    String path = await dbPath();
    Configuration config;

    // Close any existing local realm instance
    localRealm?.close();

    try {
      if (ProxyService.box.encryptionKey().isEmpty) {
        throw Exception("null encryption");
      }
      config = Configuration.local(
        [UserActivity.schema, Business.schema, Branch.schema],
        path: path,
        encryptionKey: ProxyService.box.encryptionKey().toIntList(),
      );
      localRealm = Realm(config);
    } catch (e) {
      talker.warning(e);
      localRealm?.close();
      config = Configuration.inMemory(
        [UserActivity.schema],
        path: path,
      );
      localRealm = Realm(config);
    }

    return this;
  }

  @override
  bool isRealmClosed() {
    return localRealm?.isClosed ?? true;
  }

  @override
  Future<List<UserActivity>> activities({required int userId}) async {
    // Get the current date
    DateTime now = DateTime.now();

    // Calculate the start and end of the current day
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    DateTime endOfDay = startOfDay.add(Duration(days: 1));

    return localRealm!.query<UserActivity>(
        r'lastTouched BETWEEN {$0,$1} ', [startOfDay, endOfDay]).toList();
  }

  Future<bool> hasNoActivityInLast5Minutes(
      {required int userId, int? refreshRate = 5}) async {
    // Get the current time
    DateTime currentTime = DateTime.now();

    // Calculate the time [timer] minutes ago
    DateTime fiveMinutesAgo =
        currentTime.subtract(Duration(minutes: refreshRate!));

    // Retrieve the user activities
    List<UserActivity> userActivities = await activities(userId: userId);

    // Assume no activity in the last 5 minutes by default
    bool returnValue = true;

    for (var activity in userActivities) {
      if (activity.lastTouched!.isAfter(fiveMinutesAgo)) {
        // The user has done an activity within the last 5 minutes
        returnValue = false;
        break; // No need to continue checking, we found an activity
      }
    }
    return returnValue;
  }

  @override
  Future<void> refreshSession(
      {required int branchId, int? refreshRate = 5}) async {
    while (true) {
      try {
        int userId = ProxyService.box.getUserId()!;
        bool noActivity = await hasNoActivityInLast5Minutes(
            userId: userId, refreshRate: refreshRate);
        talker.warning(noActivity.toString());

        if (noActivity) {
          Tenant? tenant =
              await getTenantBYUserId(userId: ProxyService.box.getUserId()!);
          ProxyService.realm.realm!
              .writeAsync(() => tenant!.sessionActive = false);
        }
      } catch (error) {
        print('Error fetching tenant: $error');
      }
      await Future.delayed(Duration(minutes: refreshRate!));
    }
  }

  @override
  Future<String> dbPath() async {
    String fileName = "db_";
    final appDocsDirectory = await getApplicationDocumentsDirectory();
    final int businessId = ProxyService.box.getBusinessId() ?? 0;
    final int branchId = ProxyService.box.getBranchId() ?? 0;
    final realmDirectory = '${appDocsDirectory.path}/flipper-v4-local-' +
        branchId.toString() +
        "_" +
        businessId.toString();

    // Create the new directory
    await Directory(realmDirectory).create(recursive: true);

    return "$realmDirectory/$fileName";
  }

  Future<void> _configureTheBox(String userPhone, IUser user) async {
    await ProxyService.box.writeString(key: 'userPhone', value: userPhone);
    await ProxyService.box.writeString(key: 'bearerToken', value: user.token);

    /// the token from firebase that link this user with firebase
    /// so it can be used to login to other devices
    await ProxyService.box.writeString(key: 'uid', value: user.uid);
    await ProxyService.box.writeInt(key: 'userId', value: user.id!);

    if (user.tenants.isEmpty) {
      throw BusinessNotFoundException(
          term:
              "No tenant added to the user, if a business is added it should have one tenant");
    }
    if (user.tenants.first.businesses.isEmpty ||
        user.tenants.first.branches.isEmpty) {
      throw BusinessNotFoundException(
          term:
              "No tenant added to the user, if a business is added it should have one tenant");
    }
    await ProxyService.box.writeInt(
        key: 'branchId',
        value:
            user.tenants.isEmpty ? 0 : user.tenants.first.branches.first.id!);

    talker.info("UserId:" + user.id.toString());
    await ProxyService.box.writeInt(
        key: 'businessId',
        value:
            user.tenants.isEmpty ? 0 : user.tenants.first.businesses.first.id!);
    await ProxyService.box.writeString(
        key: 'encryptionKey',
        value: user.tenants.first.businesses.first.encryptionKey);
  }

  @override
  Future<IUser> login(
      {required String userPhone,
      required bool skipDefaultAppSetup,
      bool stopAfterConfigure = false}) async {
    talker.info(userPhone);
    String phoneNumber = userPhone;

    if (!isEmail(userPhone) && !phoneNumber.startsWith('+')) {
      phoneNumber = '+' + phoneNumber;
    }
    http.Response response;
    String? uid = firebase.FirebaseAuth.instance.currentUser?.uid ?? null;

    response = await flipperHttpClient.post(Uri.parse(apihub + '/v2/api/user'),
        body: jsonEncode(
            <String, String?>{'phoneNumber': phoneNumber, 'uid': uid}));

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      // Parse the JSON response
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      // Create an IUser object using the fromJson constructor
      IUser user = IUser.fromJson(jsonResponse);
      await _configureTheBox(userPhone, user);

      /// after we login this is the best time to open the synced database to start persisting the data
      /// this will close whatever inMemory db we opened temporarly to have the app running
      await configureLocal(useInMemory: false);
      await ProxyService.realm.configure(useInMemoryDb: false);
      if (stopAfterConfigure) return user;
      if (skipDefaultAppSetup == false) {
        await ProxyService.box.writeString(
            key: 'defaultApp',

            /// because we don update default app from server
            /// because we want the ability of switching apps to be entirely offline
            /// then if we have a default app in the box we use it if it only different from "1"
            value: user.tenants.isEmpty
                ? 'null'
                : ProxyService.box.getDefaultApp() != "1"
                    ? ProxyService.box.getDefaultApp()
                    : user.tenants.first.businesses.first.businessTypeId
                        .toString());
      }

      for (ITenant tenant in user.tenants) {
        Tenant iTenant = Tenant(ObjectId(),
            isDefault: tenant.isDefault,
            id: tenant.id,
            name: tenant.name,
            businessId: tenant.businessId,
            nfcEnabled: tenant.nfcEnabled,
            email: tenant.email,
            userId: user.id!,
            phoneNumber: tenant.phoneNumber,
            pin: tenant.pin);
        final businessesToAdd = <Business>[];
        final branchToAdd = <Branch>[];

        for (IBusiness business in tenant.businesses) {
          Business biz = Business(ObjectId(),
              userId: business.userId,
              serverId: business.id,
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
              active: business.active,
              chatUid: business.chatUid,
              metadata: business.metadata,
              role: business.role,
              lastSeen: business.lastSeen,
              firstName: business.firstName,
              lastName: business.lastName,
              createdAt: business.createdAt,
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
              taxServerUrl: business.taxServerUrl,
              isDefault: business.isDefault,
              businessTypeId: business.businessTypeId,
              lastTouched: business.lastTouched,
              action: business.action,
              deletedAt: business.deletedAt,
              encryptionKey: business.encryptionKey);
          Business? exist = localRealm!
              .query<Business>(r'serverId == $0', [business.id]).firstOrNull;
          if (exist == null) {
            businessesToAdd.add(biz);
          }
        }
        localRealm!.writeAsync(() {
          localRealm!.addAll<Business>(businessesToAdd);
        });
        for (IBranch brannch in tenant.branches) {
          Branch branch = Branch(ObjectId(),
              active: brannch.active,
              serverId: brannch.id,
              description: brannch.description,
              name: brannch.name,
              businessId: brannch.businessId,
              longitude: brannch.longitude,
              latitude: brannch.latitude,
              isDefault: brannch.isDefault,
              lastTouched: brannch.lastTouched,
              action: brannch.action,
              deletedAt: brannch.deletedAt);
          Branch? exist = localRealm!
              .query<Branch>(r'serverId == $0', [branch.serverId]).firstOrNull;
          if (exist == null) {
            branchToAdd.add(branch);
          }
        }

        localRealm!.write(() {
          localRealm!.addAll<Branch>(branchToAdd);
        });
        final permissionToAdd = <LPermission>[];
        for (IPermission permission in tenant.permissions) {
          LPermission? exist = ProxyService.realm.realm!
              .query<LPermission>(r'id == $0', [permission.id]).firstOrNull;
          if (exist == null) {
            final perm = LPermission(ObjectId(),
                id: permission.id, name: permission.name);
            permissionToAdd.add(perm);
          }
        }
        localRealm!.write(() {
          localRealm!.addAll<LPermission>(permissionToAdd);
        });

        Tenant? exist = ProxyService.realm.realm!
            .query<Tenant>(r'id == $0', [iTenant.id]).firstOrNull;
        if (exist == null) {
          if (user.id == iTenant.userId) {
            iTenant.sessionActive = true;
            localRealm!.add<Tenant>(iTenant);
          } else {
            localRealm!.add<Tenant>(iTenant);
          }
        }
      }
      // ProxyService.box.writeInt(key: 'businessId', value: user.tenants.first.businessId);

      return user;
    } else if (response.statusCode == 401) {
      throw SessionException(term: "session expired");
    } else if (response.statusCode == 500) {
      throw ErrorReadingFromYBServer(term: "Not found");
    } else {
      log(response.body.toString(), name: "login error");
      throw Exception(response.body.toString());
    }
  }

  @override
  Future<List<Business>> businesses({int? userId}) async {
    List<Business> businesses = [];
    if (userId != null) {
      businesses =
          localRealm!.query<Business>(r'userId == $0 ', [userId]).toList();
    } else {
      throw Exception("userId is required");
    }

    return businesses;
  }

  @override
  Future<List<Branch>> branches({int? businessId}) async {
    if (businessId != null) {
      return localRealm!
          .query<Branch>(r'businessId == $0 ', [businessId]).toList();
    } else {
      throw Exception("BusinessId is required");
    }
  }

  @override
  Future<Business> getOnlineBusiness({required int userId}) async {
    final response = await flipperHttpClient
        .get(Uri.parse("$apihub/v2/api/businessUserId/$userId"));

    if (response.statusCode == 401) {
      throw SessionException(term: "session expired");
    }
    if (response.statusCode == 404) {
      throw BusinessNotFoundException(term: "IBusiness not found");
    }

    Business? business = localRealm!.query<Business>(r'serverId == $0',
        [IBusiness.fromJson(json.decode(response.body)).id!]).firstOrNull;

    if (business == null) {
      localRealm!.write(() {
        localRealm!.add<Business>(Business(ObjectId(),
            serverId: IBusiness.fromJson(json.decode(response.body)).id,
            userId: IBusiness.fromJson(json.decode(response.body)).userId,
            name: IBusiness.fromJson(json.decode(response.body)).name,
            currency: IBusiness.fromJson(json.decode(response.body)).currency,
            categoryId:
                IBusiness.fromJson(json.decode(response.body)).categoryId,
            latitude: IBusiness.fromJson(json.decode(response.body)).latitude,
            longitude: IBusiness.fromJson(json.decode(response.body)).longitude,
            timeZone: IBusiness.fromJson(json.decode(response.body)).timeZone,
            country: IBusiness.fromJson(json.decode(response.body)).country,
            businessUrl:
                IBusiness.fromJson(json.decode(response.body)).businessUrl,
            hexColor: IBusiness.fromJson(json.decode(response.body)).hexColor,
            imageUrl: IBusiness.fromJson(json.decode(response.body)).imageUrl,
            type: IBusiness.fromJson(json.decode(response.body)).type,
            active: IBusiness.fromJson(json.decode(response.body)).active,
            chatUid: IBusiness.fromJson(json.decode(response.body)).chatUid,
            metadata: IBusiness.fromJson(json.decode(response.body)).metadata,
            role: IBusiness.fromJson(json.decode(response.body)).role,
            lastSeen: IBusiness.fromJson(json.decode(response.body)).lastSeen,
            firstName: IBusiness.fromJson(json.decode(response.body)).firstName,
            lastName: IBusiness.fromJson(json.decode(response.body)).lastName,
            createdAt: IBusiness.fromJson(json.decode(response.body)).createdAt,
            deviceToken:
                IBusiness.fromJson(json.decode(response.body)).deviceToken,
            backUpEnabled:
                IBusiness.fromJson(json.decode(response.body)).backUpEnabled,
            subscriptionPlan:
                IBusiness.fromJson(json.decode(response.body)).subscriptionPlan,
            nextBillingDate:
                IBusiness.fromJson(json.decode(response.body)).nextBillingDate,
            previousBillingDate: IBusiness.fromJson(json.decode(response.body))
                .previousBillingDate,
            isLastSubscriptionPaymentSucceeded:
                IBusiness.fromJson(json.decode(response.body))
                    .isLastSubscriptionPaymentSucceeded,
            backupFileId:
                IBusiness.fromJson(json.decode(response.body)).backupFileId,
            email: IBusiness.fromJson(json.decode(response.body)).email,
            lastDbBackup:
                IBusiness.fromJson(json.decode(response.body)).lastDbBackup,
            fullName: IBusiness.fromJson(json.decode(response.body)).fullName,
            tinNumber: IBusiness.fromJson(json.decode(response.body)).tinNumber,
            bhfId: IBusiness.fromJson(json.decode(response.body)).bhfId,
            dvcSrlNo: IBusiness.fromJson(json.decode(response.body)).dvcSrlNo,
            adrs: IBusiness.fromJson(json.decode(response.body)).adrs,
            taxEnabled:
                IBusiness.fromJson(json.decode(response.body)).taxEnabled,
            taxServerUrl:
                IBusiness.fromJson(json.decode(response.body)).taxServerUrl,
            isDefault: IBusiness.fromJson(json.decode(response.body)).isDefault,
            businessTypeId:
                IBusiness.fromJson(json.decode(response.body)).businessTypeId,
            lastTouched:
                IBusiness.fromJson(json.decode(response.body)).lastTouched,
            action: IBusiness.fromJson(json.decode(response.body)).action,
            deletedAt: IBusiness.fromJson(json.decode(response.body)).deletedAt,
            encryptionKey:
                IBusiness.fromJson(json.decode(response.body)).encryptionKey));
      });
    }
    business =
        localRealm!.query<Business>(r'userId == $0', [userId]).firstOrNull;
    ProxyService.box.writeInt(key: 'businessId', value: business!.serverId!);

    return business;
  }

  @override
  Future<List<ITenant>> signup({required Map business}) async {
    talker.info(business.toString());
    final http.Response response = await flipperHttpClient
        .post(Uri.parse("$apihub/v2/api/business"), body: jsonEncode(business));
    if (response.statusCode == 200) {
      /// because we want to close the inMemory realm db
      /// as soon as possible so I can be able to save real data into realm
      /// then I call login in here after signup as login handle configuring
      await login(
          userPhone: business['phoneNumber'], skipDefaultAppSetup: true);
      final tenantToAdd = <Tenant>[];
      for (ITenant tenant in ITenant.fromJsonList(response.body)) {
        ITenant jTenant = tenant;

        Tenant iTenant = Tenant(ObjectId(),
            isDefault: jTenant.isDefault,
            id: jTenant.id,
            name: jTenant.name,
            userId: jTenant.userId,
            businessId: jTenant.businessId,
            nfcEnabled: jTenant.nfcEnabled,
            email: jTenant.email,
            phoneNumber: jTenant.phoneNumber);

        final businessToAdd = <Business>[];
        for (IBusiness business in jTenant.businesses) {
          Business biz = Business(ObjectId(),
              serverId: business.id,
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
              active: business.active,
              chatUid: business.chatUid,
              metadata: business.metadata,
              role: business.role,
              lastSeen: business.lastSeen,
              firstName: business.firstName,
              lastName: business.lastName,
              createdAt: business.createdAt,
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
              taxServerUrl: business.taxServerUrl,
              isDefault: business.isDefault,
              businessTypeId: business.businessTypeId,
              lastTouched: business.lastTouched,
              action: business.action,
              deletedAt: business.deletedAt,
              encryptionKey: business.encryptionKey);
          businessToAdd.add(biz);
        }
        localRealm!.write(() {
          localRealm!.addAll<Business>(businessToAdd);
        });
        final branchToAdd = <Branch>[];
        for (IBranch brannch in jTenant.branches) {
          Branch branch = Branch(ObjectId(),
              serverId: brannch.id,
              active: brannch.active,
              description: brannch.description,
              name: brannch.name,
              businessId: brannch.businessId,
              longitude: brannch.longitude,
              latitude: brannch.latitude,
              isDefault: brannch.isDefault,
              lastTouched: brannch.lastTouched,
              action: brannch.action,
              deletedAt: brannch.deletedAt);
          branchToAdd.add(branch);
        }
        localRealm!.write(() {
          localRealm!.addAll<Branch>(branchToAdd);
        });

        for (IPermission permission in jTenant.permissions) {
          ProxyService.realm.realm!.add<LPermission>(LPermission(ObjectId(),
              id: permission.id, name: permission.name));
        }

        ProxyService.realm.realm!.add(iTenant);
      }
      ProxyService.realm.realm!.write(() {
        ProxyService.realm.realm!.addAll<Tenant>(tenantToAdd);
      });
      return ITenant.fromJsonList(response.body);
    } else {
      throw InternalServerError(term: response.body.toString());
    }
  }

  @override
  Business getBusiness({int? businessId}) {
    if (businessId != null) {
      return localRealm!.query<Business>(r'serverId == $0', [businessId]).first;
    } else {
      ///FIXME: what will happen if a user has multiple business associated to him
      ///the code bellow suggest that the first in row will be returned which can be wrong.
      int? userId = ProxyService.box.getUserId();
      return localRealm!.query<Business>(r'userId == $0', [userId]).first;
    }
  }

  @override
  Future<Business> getBusinessFuture({int? businessId}) async {
    if (businessId != null) {
      return localRealm!.query<Business>(r'serverId == $0', [businessId]).first;
    } else {
      ///FIXME: what will happen if a user has multiple business associated to him
      ///the code bellow suggest that the first in row will be returned which can be wrong.
      int? userId = ProxyService.box.getUserId();
      return localRealm!.query<Business>(r'userId == $0', [userId]).first;
    }
  }

  @override
  Future<Business?> defaultBusiness() async {
    return localRealm!.query<Business>(r'isDefault == $0 ', [true]).firstOrNull;
  }

  @override
  Future<Branch?> defaultBranch() async {
    return localRealm!.query<Branch>(r'isDefault == $0 ', [true]).firstOrNull;
  }

  @override
  Future<Branch> activeBranch() async {
    return localRealm!.query<Branch>(r'isDefault == $0', [true]).first;
  }

  @override
  Future<Business?> activeBusinesses({required int userId}) async {
    return localRealm!.query<Business>(
        r'userId == $0 AND (active == $1 OR active == $2)',
        [userId, null, true]).firstOrNull;
  }

  @override
  Future<List<ITenant>> tenantsFromOnline({required int businessId}) async {
    final http.Response response = await flipperHttpClient
        .get(Uri.parse("$apihub/v2/api/tenant/$businessId"));
    if (response.statusCode == 200) {
      final tenantToAdd = <Tenant>[];
      for (ITenant tenant in ITenant.fromJsonList(response.body)) {
        ITenant jTenant = tenant;
        Tenant iTenant = Tenant(ObjectId(),
            isDefault: jTenant.isDefault,
            id: jTenant.id,
            name: jTenant.name,
            userId: jTenant.userId,
            businessId: jTenant.businessId,
            nfcEnabled: jTenant.nfcEnabled,
            email: jTenant.email,
            phoneNumber: jTenant.phoneNumber);

        for (IBusiness business in jTenant.businesses) {
          Business biz = Business(ObjectId(),
              serverId: business.id,
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
              active: business.active,
              chatUid: business.chatUid,
              metadata: business.metadata,
              role: business.role,
              lastSeen: business.lastSeen,
              firstName: business.firstName,
              lastName: business.lastName,
              createdAt: business.createdAt,
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
              taxServerUrl: business.taxServerUrl,
              isDefault: business.isDefault,
              businessTypeId: business.businessTypeId,
              lastTouched: business.lastTouched,
              action: business.action,
              deletedAt: business.deletedAt,
              encryptionKey: business.encryptionKey);
          Business? exist = localRealm!
              .query<Business>(r'serverId == $0', [business.id]).firstOrNull;
          if (exist == null) {
            localRealm!.add<Business>(biz);
          }
        }

        for (IBranch brannch in jTenant.branches) {
          Branch branch = Branch(ObjectId(),
              serverId: brannch.id,
              active: brannch.active,
              description: brannch.description,
              name: brannch.name,
              businessId: brannch.businessId,
              longitude: brannch.longitude,
              latitude: brannch.latitude,
              isDefault: brannch.isDefault,
              lastTouched: brannch.lastTouched,
              action: brannch.action,
              deletedAt: brannch.deletedAt);
          Branch? exist = localRealm!
              .query<Branch>(r'serverId == $0', [branch.id]).firstOrNull;
          if (exist == null) {
            localRealm!.add<Branch>(branch);
          }
        }

        final permissionToAdd = <LPermission>[];
        for (IPermission permission in jTenant.permissions) {
          LPermission? exist = realm!
              .query<LPermission>(r'id == $0', [permission.id]).firstOrNull;
          if (exist == null) {
            final perm = LPermission(ObjectId(),
                id: permission.id, name: permission.name);
            permissionToAdd.add(perm);
          }
        }

        ProxyService.realm.realm!.write(() {
          ProxyService.realm.realm!.addAll<LPermission>(permissionToAdd);
        });

        tenantToAdd.add(iTenant);
      }
      ProxyService.realm.realm!.write(() {
        ProxyService.realm.realm!.addAll<Tenant>(tenantToAdd);
      });
      return ITenant.fromJsonList(response.body);
    }
    throw InternalServerException(term: "we got unexpected response");
  }

  @override
  Future<Business?> getBusinessFromOnlineGivenId({required int id}) async {
    Business? business = realm!.query<Business>(r'id == $0', [id]).firstOrNull;

    if (business != null) return business;
    final http.Response response =
        await flipperHttpClient.get(Uri.parse("$apihub/v2/api/business/$id"));
    if (response.statusCode == 200) {
      int id = randomNumber();
      IBusiness iBusiness = IBusiness.fromJson(json.decode(response.body));
      Business business = Business(ObjectId(),
          serverId: iBusiness.id,
          name: iBusiness.name,
          userId: iBusiness.userId,
          createdAt: DateTime.now().toIso8601String());

      business.serverId = id;
      localRealm!.write(() {
        localRealm!.add<Business>(business);
      });
      return business;
    }
    return null;
  }

  @override
  Future<List<Business>> getContacts() async {
    return localRealm!.query<Business>(
        r'userId == $0', [ProxyService.box.getUserId()]).toList();
  }

  @override
  Future<Tenant> saveTenant(String phoneNumber, String name,
      {required Business business,
      required Branch branch,
      required String userType}) async {
    final http.Response response =
        await flipperHttpClient.post(Uri.parse("$apihub/v2/api/tenant"),
            body: jsonEncode({
              "phoneNumber": phoneNumber,
              "name": name,
              "businessId": business.id,
              "permissions": [
                {"name": userType.toLowerCase()}
              ],
              "businesses": [business.toEJson()],
              "branches": [branch.toEJson()]
            }));
    if (response.statusCode == 200) {
      ITenant jTenant = ITenant.fromRawJson(response.body);
      ITenant iTenant = ITenant(
          businesses: jTenant.businesses,
          branches: jTenant.branches,
          isDefault: jTenant.isDefault,
          id: randomNumber(),
          permissions: jTenant.permissions,
          name: jTenant.name,
          businessId: jTenant.businessId,
          email: jTenant.email,
          userId: jTenant.userId,
          nfcEnabled: jTenant.nfcEnabled,
          phoneNumber: jTenant.phoneNumber);
      final branchToAdd = <Branch>[];
      final permissionToAdd = <LPermission>[];
      final businessToAdd = <Business>[];

      for (var business in jTenant.businesses) {
        Business? existingBusiness = localRealm!
            .query<Business>(r'serverId == $0', [business.id]).firstOrNull;
        if (existingBusiness == null) {
          businessToAdd.add(Business(ObjectId(),
              serverId: business.id,
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
              active: business.active,
              chatUid: business.chatUid,
              metadata: business.metadata,
              role: business.role,
              lastSeen: business.lastSeen,
              firstName: business.firstName,
              lastName: business.lastName,
              createdAt: business.createdAt,
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
              taxServerUrl: business.taxServerUrl,
              isDefault: business.isDefault,
              businessTypeId: business.businessTypeId,
              lastTouched: business.lastTouched,
              action: business.action,
              deletedAt: business.deletedAt,
              encryptionKey: business.encryptionKey));
        }
      }

      for (var branch in jTenant.branches) {
        // Check if the branch with the same ID already exists
        // var existingBranch =
        //     await isar.iBranchs.filter().idEqualTo(branch.id).findFirst();
        final existingBranch =
            realm!.query<Branch>(r'serverId==$0', [branch.id]).firstOrNull;
        if (existingBranch == null) {
          Branch br = Branch(ObjectId(),
              serverId: branch.id,
              name: branch.name,
              businessId: branch.businessId,
              action: branch.action,
              active: branch.active,
              lastTouched: branch.lastTouched,
              latitude: branch.latitude,
              longitude: branch.longitude);
          branchToAdd.add(br);
        }
      }

      for (var permission in jTenant.permissions) {
        LPermission? existingPermission = ProxyService.realm.realm!
            .query<LPermission>(r'id == $0', [permission.id]).firstOrNull;
        if (existingPermission == null) {
          // Permission doesn't exist, add it
          permissionToAdd.add(LPermission(ObjectId(),
              name: permission.name,
              id: permission.id,
              userId: permission.userId));
        }
      }

      Tenant? tenantToAdd;
      Tenant? tenant = ProxyService.realm.realm!
          .query<Tenant>(r'id==$0', [iTenant.id]).firstOrNull;
      if (tenant == null) {
        tenantToAdd = Tenant(ObjectId(),
            name: jTenant.name,
            phoneNumber: jTenant.phoneNumber,
            email: jTenant.email,
            nfcEnabled: jTenant.nfcEnabled,
            businessId: jTenant.businessId,
            userId: jTenant.userId,
            isDefault: jTenant.isDefault,
            pin: jTenant.pin);
        ProxyService.realm.realm!.add<Tenant>(tenantToAdd);
      }

      localRealm!.write(() {
        localRealm!.addAll<Business>(businessToAdd);
        localRealm!.addAll<Branch>(branchToAdd);
        ProxyService.realm.realm!.addAll<LPermission>(permissionToAdd);
      });

      return tenantToAdd!;
    } else {
      throw InternalServerError(term: "internal server error");
    }
  }
}
