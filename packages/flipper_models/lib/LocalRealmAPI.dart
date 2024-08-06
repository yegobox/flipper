import 'dart:convert';

import 'package:flipper_models/LocalRealm.dart';
import 'package:flipper_models/exceptions.dart';
import 'package:flipper_models/helperModels/branch.dart';
import 'package:flipper_models/helperModels/business.dart';
import 'package:flipper_models/helperModels/iuser.dart';
import 'package:flipper_models/helperModels/permission.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/helperModels/tenant.dart';
import 'package:flipper_models/helper_models.dart' as ext;
import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_models/RealmApi.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_services/proxy.dart';
import 'package:realm/realm.dart';
import 'package:rxdart/rxdart.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/foundation.dart' as foundation;

final localModels = [
  UserActivity.schema,
  Business.schema,
  Branch.schema,
  UnversalProduct.schema,
  AppNotification.schema
];

class LocalRealmApi extends RealmAPI implements LocalRealmInterface {
  final talker = TalkerFlutter.init();
  @override
  Realm? localRealm;

  void dataCb(Realm realm) {
    List<Map<String, dynamic>> itemClsList = [
      {
        "itemClsCd": "5020230601",
        "itemClsNm": "Fanta",
        "itemClsLvl": 5,
        "taxTyCd": "B",
        "mjrTgYn": "Y",
        "useYn": "Y"
      },
      {
        "itemClsCd": "5020230602",
        "itemClsNm": "water",
        "itemClsLvl": 5,
        "taxTyCd": "B",
        "mjrTgYn": "Y",
        "useYn": "Y"
      },
      {
        "itemClsCd": "5020230102",
        "itemClsNm": "Inyange",
        "itemClsLvl": 5,
        "taxTyCd": "B",
        "mjrTgYn": "Y",
        "useYn": "Y"
      },
      {
        "itemClsCd": "1112200101",
        "itemClsNm": "Gypsum boad",
        "itemClsLvl": 5,
        "taxTyCd": "B",
        "mjrTgYn": "Y",
        "useYn": "Y"
      },
      {
        "itemClsCd": "3011170102",
        "itemClsNm": "Gypsum board 1",
        "itemClsLvl": 5,
        "taxTyCd": "B",
        "mjrTgYn": "Y",
        "useYn": "Y"
      },
      {
        "itemClsCd": "10122101",
        "itemClsNm": "Miscellaneous animal food",
        "itemClsLvl": 4,
        "taxTyCd": null,
        "mjrTgYn": null,
        "useYn": "Y"
      },
      {
        "itemClsCd": "50202203",
        "itemClsNm": "Wine",
        "itemClsLvl": 4,
        "taxTyCd": null,
        "mjrTgYn": null,
        "useYn": "Y"
      },
      {
        "itemClsCd": "26111612",
        "itemClsNm": "Solar equipment systems",
        "itemClsLvl": 4,
        "taxTyCd": null,
        "mjrTgYn": null,
        "useYn": "Y"
      },
      {
        "itemClsCd": "31211905",
        "itemClsNm": "Paint mixers",
        "itemClsLvl": 4,
        "taxTyCd": null,
        "mjrTgYn": null,
        "useYn": "Y"
      },
      {
        "itemClsCd": "10171702",
        "itemClsNm": "Fungicides",
        "itemClsLvl": 4,
        "taxTyCd": null,
        "mjrTgYn": null,
        "useYn": "Y"
      },
      {
        "itemClsCd": "22101539",
        "itemClsNm": "Earthmoving machinery parts and accessories",
        "itemClsLvl": 4,
        "taxTyCd": null,
        "mjrTgYn": null,
        "useYn": "Y"
      },
      {
        "itemClsCd": "25132100",
        "itemClsNm": "Unmanned aerial vehicle",
        "itemClsLvl": 3,
        "taxTyCd": null,
        "mjrTgYn": null,
        "useYn": "Y"
      },
    ];

    for (final item in itemClsList) {
      // Check if an item with the same 'itemClsCd' already exists
      final existingItem = realm.query<UnversalProduct>(
        r'itemClsCd == $0',
        [item['itemClsCd']],
      ).firstOrNull;

      // If it doesn't exist, add it
      if (existingItem == null) {
        realm.add(UnversalProduct(
          ObjectId(),
          id: 1,
          itemClsCd: item['itemClsCd'],
          itemClsNm: item['itemClsNm'],
          itemClsLvl: item['itemClsLvl'],
          taxTyCd: item['taxTyCd'],
          mjrTgYn: item['mjrTgYn'],
          useYn: item['useYn'],
        ));
      }
    }
  }

  void _configureInMemory() {
    Configuration config = Configuration.inMemory(localModels);
    realm = Realm(config);
    talker.info("Opened in-memory realm.");
  }

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

    ///gross profit (sales zose ukuyemo ikiranguzo) ,
    /// cost of good sold
    /// sales
    /// net profit
    Configuration config;

    // Close any existing local realm instance
    localRealm?.close();

    try {
      if (useInMemory || ProxyService.box.encryptionKey().isEmpty) {
        talker.error("Using in Memory db");
        localRealm?.close();
        _configureInMemory();
        return this;
      }
      localRealm?.close();
      String path =
          await dbPath(path: 'local', folder: ProxyService.box.getBusinessId());
      config = Configuration.local(
        localModels,
        initialDataCallback: dataCb,
        path: path,
        encryptionKey: ProxyService.box.encryptionKey().isEmpty == true
            ? []
            : ProxyService.box.encryptionKey().toIntList(),
        schemaVersion: 2,
        migrationCallback: (migration, oldSchemaVersion) {
          if (oldSchemaVersion < 2) {
            // This means we are migrating from version 1 to version 2
            migration.deleteType('Drawers');
          }
        },
      );
      localRealm = Realm(config);
      return this;
    } catch (e) {
      rethrow;
    }
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

  ///TODO: work on this function to be efficient
  @override
  Future<void> refreshSession(
      {required int branchId, int? refreshRate = 5}) async {
    while (true) {
      try {
        int? userId = ProxyService.box.getUserId();
        if (userId == null) return;
        bool noActivity = await hasNoActivityInLast5Minutes(
            userId: userId, refreshRate: refreshRate);
        talker.warning(noActivity.toString());

        // if (noActivity) {
        //   Tenant? tenant = await getTenantBYUserId(userId: userId);
        //   if (tenant != null) {
        //     ProxyService.realm.realm!
        //         .writeAsync(() => tenant.sessionActive = false);
        //   }
        // }
      } catch (error, s) {
        talker.error('Error fetching tenant: $s');
        talker.error('Error fetching tenant: $error');
      }
      await Future.delayed(Duration(minutes: refreshRate!));
    }
  }

  Future<void> _configureTheBox(String userPhone, IUser user) async {
    await ProxyService.box.writeString(key: 'userPhone', value: userPhone);
    await ProxyService.box.writeString(key: 'bearerToken', value: user.token);

    /// FIXME: should set branchId and businessId by looking into what is set to be default
    /// when we enable for a user to login on multiple

    talker.warning("Upon login: UserId ${user.id}: UserPhone: ${userPhone}");

    /// the token from firebase that link this user with firebase
    /// so it can be used to login to other devices
    await ProxyService.box.writeString(key: 'uid', value: user.uid ?? "");
    await ProxyService.box.writeInt(key: 'userId', value: user.id!);

    if (user.tenants.isEmpty) {
      talker.error("User created does not have tenants");
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

    await ProxyService.box.writeInt(
        key: 'businessId',
        value:
            user.tenants.isEmpty ? 0 : user.tenants.first.businesses.first.id!);
    await ProxyService.box.writeString(
        key: 'encryptionKey',
        value: user.tenants.first.businesses.first.encryptionKey);
  }

  @override
  Future<IUser> login({
    required String userPhone,
    required bool skipDefaultAppSetup,
    bool stopAfterConfigure = false,
  }) async {
    String phoneNumber = userPhone;

    await _initializeRealms();

    if (!isEmail(userPhone) && !phoneNumber.startsWith('+')) {
      phoneNumber = '+' + phoneNumber;
    }

    final http.Response response = await _sendLoginRequest(phoneNumber);

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final IUser user = IUser.fromJson(json.decode(response.body));

      await _configureApp(userPhone, user);

      if (stopAfterConfigure) return user;

      if (!skipDefaultAppSetup) {
        await _setDefaultApp(user);
      }

      await _updateLocalRealm(user);

      return user;
    } else {
      await _handleLoginError(response);
    }
    throw Exception("Error");
  }

  Future<void> _initializeRealms() async {
    if (ProxyService.realm.realm == null) {
      await ProxyService.realm.configure(
        useInMemoryDb: false,
        useFallBack: false,
        businessId: ProxyService.box.getBusinessId(),
        encryptionKey: ProxyService.box.encryptionKey(),
        branchId: ProxyService.box.getBranchId(),
        userId: ProxyService.box.getUserId(),
      );
    }
    if (ProxyService.local.localRealm == null) {
      await ProxyService.local.configureLocal(useInMemory: false);
    }
  }

  Future<http.Response> _sendLoginRequest(String phoneNumber) async {
    final String? uid = firebase.FirebaseAuth.instance.currentUser?.uid;
    return await flipperHttpClient.post(
      Uri.parse(apihub + '/v2/api/user'),
      body:
          jsonEncode(<String, String?>{'phoneNumber': phoneNumber, 'uid': uid}),
    );
  }

  Future<void> _configureApp(String userPhone, IUser user) async {
    await _configureTheBox(userPhone, user);
    await configureLocal(useInMemory: false);
    await ProxyService.realm.configure(
      useInMemoryDb: false,
      useFallBack: false,
      businessId: ProxyService.box.getBusinessId(),
      encryptionKey: ProxyService.box.encryptionKey(),
      branchId: ProxyService.box.getBranchId(),
      userId: ProxyService.box.getUserId(),
    );

    await ProxyService.realm.downloadAssetSave();
  }

  Future<void> _setDefaultApp(IUser user) async {
    final String defaultAppValue = user.tenants.isEmpty
        ? 'null'
        : ProxyService.box.getDefaultApp() != "1"
            ? ProxyService.box.getDefaultApp()
            : user.tenants.first.businesses.first.businessTypeId.toString();

    await ProxyService.box
        .writeString(key: 'defaultApp', value: defaultAppValue);
  }

  Future<void> _updateLocalRealm(IUser user) async {
    for (ITenant tenant in user.tenants) {
      await _addOrUpdateTenant(tenant, user.id.toString());
    }
  }

  Future<void> _addOrUpdateTenant(ITenant tenant, String userId) async {
    final Tenant iTenant = Tenant(
      ObjectId(),
      isDefault: tenant.isDefault,
      id: tenant.id,
      name: tenant.name,
      businessId: tenant.businessId,
      nfcEnabled: tenant.nfcEnabled,
      email: tenant.email,
      userId: int.tryParse(userId),
      phoneNumber: tenant.phoneNumber,
      pin: tenant.pin,
    );

    await _addOrUpdateBusinesses(tenant.businesses, userId);
    await _addOrUpdateBranches(tenant.branches);
    await _addOrUpdatePermissions(tenant.permissions);
    await _addOrUpdateTenantInRealm(iTenant, userId);
  }

  Future<void> _addOrUpdateBusinesses(
      List<IBusiness> businesses, String userId) async {
    final List<Business> businessesToAdd = [];

    for (IBusiness business in businesses) {
      Business biz = Business(
        ObjectId(),
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
        bhfId: ProxyService.box.bhfId() ?? "00",
        dvcSrlNo: business.dvcSrlNo,
        adrs: business.adrs,
        taxEnabled: business.taxEnabled,
        taxServerUrl: business.taxServerUrl,
        isDefault: business.isDefault,
        businessTypeId: business.businessTypeId,
        lastTouched: business.lastTouched,
        action: business.action,
        deletedAt: business.deletedAt,
        encryptionKey: business.encryptionKey,
      );

      Business? exist = localRealm!
          .query<Business>(r'serverId == $0', [business.id]).firstOrNull;
      if (exist == null) {
        businessesToAdd.add(biz);
      }
    }

    localRealm!.writeAsync(() {
      localRealm!.addAll<Business>(businessesToAdd);
    });
  }

  Future<void> _addOrUpdateBranches(List<IBranch> branches) async {
    final List<Branch> branchToAdd = [];

    for (IBranch brannch in branches) {
      Branch branch = Branch(
        ObjectId(),
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
        deletedAt: brannch.deletedAt,
      );

      Branch? exist = localRealm!
          .query<Branch>(r'serverId == $0', [branch.serverId]).firstOrNull;
      if (exist == null) {
        branchToAdd.add(branch);
      }
    }

    localRealm!.write(() {
      localRealm!.addAll<Branch>(branchToAdd);
    });
  }

  Future<void> _addOrUpdatePermissions(List<IPermission> permissions) async {
    final List<LPermission> permissionToAdd = [];
    final List<String> features = ['Sales', 'Inventory', 'Reports', 'Settings'];

    for (IPermission permission in permissions) {
      LPermission? exist = ProxyService.realm.realm!
          .query<LPermission>(r'userId == $0', [permission.userId]).firstOrNull;

      if (exist == null) {
        final perm = LPermission(
          ObjectId(),
          id: randomNumber(),
          name: permission.name,
          userId: permission.userId,
        );
        permissionToAdd.add(perm);

        // Check if the permission is "admin" and handle access creation
        if (permission.name.toLowerCase() == 'admin') {
          for (String featureName in features) {
            final Access? existingAccess = ProxyService.realm.realm!
                .query<Access>(r'userId == $0 AND featureName == $1',
                    [permission.userId, featureName]).firstOrNull;

            if (existingAccess == null) {
              final Access access = Access(
                ObjectId(),
                id: randomNumber(),
                createdAt: DateTime.now(),
                branchId: ProxyService.box.getBranchId(),
                businessId: ProxyService.box.getBusinessId(),
                userType: "Admin",
                accessLevel: 'Admin'.toLowerCase(),
                status: 'active',
                userId: permission.userId,
                featureName: featureName,
              );
              ProxyService.realm.realm!.write(() {
                ProxyService.realm.realm!.add<Access>(access);
              });
            }
          }
        }
      }
    }

    ProxyService.realm.realm!.write(() {
      ProxyService.realm.realm!.addAll<LPermission>(permissionToAdd);
    });
  }

  Future<void> _addOrUpdateTenantInRealm(Tenant iTenant, String userId) async {
    Tenant? exist = ProxyService.realm.realm!
        .query<Tenant>(r'id == $0', [iTenant.id]).firstOrNull;
    if (exist == null) {
      ProxyService.realm.realm!.write(() {
        iTenant.sessionActive = (userId == iTenant.userId);
        ProxyService.realm.realm!.add<Tenant>(iTenant);
      });
    }
  }

  Future<void> _handleLoginError(http.Response response) async {
    if (response.statusCode == 401) {
      throw SessionException(term: "session expired");
    } else if (response.statusCode == 500) {
      throw PinError(term: "Not found");
    } else {
      throw UnknownError(term: response.statusCode.toString());
    }
  }

  @override
  List<Business> businesses({int? userId}) {
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
  List<Branch> branches({int? businessId}) {
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

      await configureLocal(useInMemory: false);
      await ProxyService.realm.configure(
        useInMemoryDb: false,
        businessId: ProxyService.box.getBusinessId(),
        encryptionKey: ProxyService.box.encryptionKey(),
        branchId: ProxyService.box.getBranchId(),
        userId: ProxyService.box.getUserId(),
      );
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
      talker.error(response.body.toString());
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
  Branch? defaultBranch() {
    return localRealm!.query<Branch>(r'isDefault == $0 ', [true]).firstOrNull;
  }

  @override
  Future<Branch> activeBranch() async {
    return localRealm!.query<Branch>(r'isDefault == $0', [true]).first;
  }

  @override
  Future<Business?> activeBusinesses({required int userId}) async {
    // AND (active == $1 OR active == $2)
    return localRealm!.query<Business>(r'userId == $0 ', [userId]).firstOrNull;
  }

  @override
  Future<List<ITenant>> tenantsFromOnline({required int businessId}) async {
    final http.Response response = await flipperHttpClient
        .get(Uri.parse("$apihub/v2/api/tenant/$businessId"));
    if (response.statusCode == 200) {
      if (ProxyService.realm.realm == null) {
        await ProxyService.realm.configure(
          useInMemoryDb: false,
          useFallBack: false,
          businessId: ProxyService.box.getBusinessId(),
          branchId: ProxyService.box.getBranchId(),
          userId: ProxyService.box.getUserId(),
          encryptionKey: ProxyService.box.encryptionKey(),
        );
      }
      if (ProxyService.local.localRealm == null) {
        await ProxyService.local.configureLocal(useInMemory: false);
      }
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
              .query<Branch>(r'serverId == $0', [brannch.id]).firstOrNull;
          if (exist == null) {
            localRealm!.write(() => localRealm!.add<Branch>(branch));
          }
        }

        final permissionToAdd = <LPermission>[];
        for (IPermission permission in jTenant.permissions) {
          LPermission? exist = ProxyService.realm.realm!
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
        Tenant? tenanti = ProxyService.realm.realm!
            .query<Tenant>(r'userId==$0', [iTenant.userId]).firstOrNull;

        if (tenanti == null) {
          tenantToAdd.add(iTenant);
        }
      }

      if (tenantToAdd.isNotEmpty) {
        ProxyService.realm.realm!.write(() {
          ProxyService.realm.realm!.addAll<Tenant>(tenantToAdd);
        });
      }

      return ITenant.fromJsonList(response.body);
    }
    throw InternalServerException(term: "we got unexpected response");
  }

  @override
  Future<Business?> getBusinessFromOnlineGivenId({required int id}) async {
    Business? business =
        localRealm!.query<Business>(r'serverId == $0', [id]).firstOrNull;

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
  Future<Tenant?> saveTenant(String phoneNumber, String name,
      {required Business business,
      required Branch branch,
      required String userType}) async {
    talker.info(jsonEncode(branch.toEJson().convertRealmValues()));

    final data = jsonEncode({
      "phoneNumber": phoneNumber,
      "name": name,
      "businessId": business.serverId,
      "permissions": [
        {"name": userType.toLowerCase()}
      ],
      "businesses": [business.toEJson().convertRealmValues()],
      "branches": [branch.toEJson().convertRealmValues()]
    });

    final http.Response response = await flipperHttpClient
        .post(Uri.parse("$apihub/v2/api/tenant"), body: data);

    if (response.statusCode == 200) {
      try {
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
          final existingBranch = localRealm!
              .query<Branch>(r'serverId==$0', [branch.id]).firstOrNull;
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
            .query<Tenant>(r'userId==$0', [iTenant.userId]).firstOrNull;
        if (tenant == null) {
          tenantToAdd = Tenant(ObjectId(),
              name: jTenant.name,
              phoneNumber: jTenant.phoneNumber,
              email: jTenant.email,
              nfcEnabled: jTenant.nfcEnabled,
              businessId: jTenant.businessId,
              userId: jTenant.userId,
              id: randomNumber(),
              isDefault: jTenant.isDefault,
              pin: jTenant.pin);
          ProxyService.realm.realm!.write(() {
            ProxyService.realm.realm!.add<Tenant>(tenantToAdd!);
          });
        }

        localRealm!.write(() {
          localRealm!.addAll<Business>(businessToAdd);
          localRealm!.addAll<Branch>(branchToAdd);
          ProxyService.realm.realm!.write(() {
            ProxyService.realm.realm!.addAll<LPermission>(permissionToAdd);
          });
        });

        return tenantToAdd;
      } catch (e) {
        talker.error(e);
        rethrow;
      }
    } else {
      throw InternalServerError(term: "internal server error");
    }
  }

  @override
  Future<List<UnversalProduct>> universalProductNames(
      {required int branchId}) async {
    /// attempt to re-add new universal item names but do not wait for the future
    /// this means I can face side effect but that is okay
    print("this is invoked");
    List<UnversalProduct> items = localRealm!
        .query<UnversalProduct>(r'branchId == $0', [branchId]).toList();

    return items;
  }

  @override
  Stream<List<AppNotification>> notificationStream(
      {required int identifier}) async* {
    final subject = ReplaySubject<List<AppNotification>>();

    final query = localRealm!.query<AppNotification>(
        r'identifier == $0 AND completed == $1', [identifier, false]);

    query.changes.listen((results) {
      subject.add(results.results.toList());
    });

    yield* subject.stream;
  }

  @override
  void notify({required AppNotification notification}) {
    localRealm!.write(() {
      localRealm!.add<AppNotification>(notification);
    });
  }

  @override
  AppNotification notification({required int id}) {
    return localRealm!.query<AppNotification>(r'id == $0', [id]).first;
  }

  @override
  Future<Branch> addBranch(
      {required String name,
      required int businessId,
      required String location,
      required String userOwnerPhoneNumber}) async {
    final response = await flipperHttpClient.post(
      Uri.parse(apihub + '/v2/api/branch/${userOwnerPhoneNumber}'),
      body: jsonEncode(<String, dynamic>{
        "name": name,
        "businessId": businessId,
        "location": location
      }),
    );
    if (response.statusCode == 201) {
      IBranch branchLocal = IBranch.fromJson(json.decode(response.body));
      localRealm!.write(() {
        localRealm!.add<Branch>(
          Branch(
            ObjectId(),
            location: branchLocal.location,
            lastTouched: DateTime.now(),
            latitude: branchLocal.latitude,
            name: branchLocal.name,
            longitude: branchLocal.longitude,
            businessId: branchLocal.businessId,
            isDefault: branchLocal.isDefault,
            active: branchLocal.active,
            serverId: branchLocal.id,
          ),
        );
      });
      return localRealm!
          .query<Branch>(r'serverId == $0', [branchLocal.id]).first;
    }
    throw UnknownError(term: "unknown error happened");
  }

  @override
  Future<void> deleteBranch({required int branchId}) async {
    try {
      await flipperHttpClient
          .delete(Uri.parse(apihub + '/v2/api/branch/${branchId}'));
      Branch? branch =
          localRealm!.query<Branch>(r'serverId == $0', [branchId]).firstOrNull;
      localRealm!.write(() {
        localRealm!.delete(branch!);
      });
    } catch (e, s) {
      talker.error(e);
      talker.error(s);
      rethrow;
    }
  }

  @override
  Branch? branch({required int serverId}) {
    return realm!.query<Branch>(r'serverId == $0', [serverId]).firstOrNull;
  }
}
