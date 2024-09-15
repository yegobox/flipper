import 'dart:convert';
import 'dart:io';

import 'package:flipper_models/Booting.dart';
import 'package:flipper_models/DATA.dart';
import 'package:flipper_models/LocalRealm.dart';
import 'package:flipper_models/exceptions.dart';
import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/helperModels/branch.dart';
import 'package:flipper_models/helperModels/business.dart';
import 'package:flipper_models/helperModels/iuser.dart';
import 'package:flipper_models/helperModels/permission.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/helperModels/tenant.dart';
import 'package:flipper_models/helper_models.dart' as ext;
import 'package:flipper_models/AppInitializer.dart';
import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_models/RealmApi.dart';
import 'package:flipper_models/realmModels.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_services/proxy.dart';
import 'package:realm/realm.dart';
import 'package:rxdart/rxdart.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' as foundation;
import 'package:firebase_auth/firebase_auth.dart' as firebase;

class LocalRealmApi extends RealmAPI
    with Booting, Data
    implements LocalRealmInterface {
  final talker = TalkerFlutter.init();
  @override
  Realm? localRealm;

  void dataCb(Realm realm) {
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
    localRealm = Realm(config);
    talker.info("Opened in-memory realm.");
  }

  @override
  Future<http.Response> sendLoginRequest(String phoneNumber,
      HttpClientInterface flipperHttpClient, String apihub) async {
    final String? uid = firebase.FirebaseAuth.instance.currentUser?.uid;
    return await flipperHttpClient.post(
      Uri.parse(apihub + '/v2/api/user'),
      body:
          jsonEncode(<String, String?>{'phoneNumber': phoneNumber, 'uid': uid}),
    );
  }

  @override
  Future<LocalRealmInterface> configureLocal(
      {required bool useInMemory}) async {
    talker.warning("Opening local realm alongside the synced one!");
    const isTest =
        const bool.fromEnvironment('FLUTTER_TEST_ENV', defaultValue: false);

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
    // talker.warning("EncriptionKey${ProxyService.box.encryptionKey()}");
    try {
      if (useInMemory ||
          ProxyService.box.encryptionKey().isEmpty ||
          isTest ||
          ProxyService.box.getBusinessId() == null) {
        talker.error("Using in Memory db");
        _configureInMemory();
      } else {
        String path = await dbPath(
            path: 'local', folder: ProxyService.box.getBusinessId());
        config = Configuration.local(
          localModels,
          initialDataCallback: dataCb,
          path: path,
          encryptionKey: ProxyService.box.encryptionKey().toIntList(),
          schemaVersion: 7,
          migrationCallback: (migration, oldSchemaVersion) {
            if (oldSchemaVersion < 2) {
              // This means we are migrating from version 1 to version 2
              migration.deleteType('Drawers');
            }
            if (oldSchemaVersion < 7) {
              // This means we are migrating from version 1 to version 2
              migration.deleteType('Log');
            }
          },
        );
        localRealm = Realm(config);
      }
    } catch (e) {
      /// delete this db path
      rethrow;
    }
    return this;
  }

  /// Delete this db path
  Future<void> deleteDbPath(String dbPath) async {
    try {
      final directory = Directory(dbPath);
      if (await directory.exists()) {
        await directory.delete(recursive: true);
        print('Database path deleted successfully: $dbPath');
      } else {
        print('Database path does not exist: $dbPath');
      }
    } catch (e) {
      print('Error deleting database path: $e');
      rethrow;
    }
  }

  @override
  bool isRealmClosed() {
    return localRealm?.isClosed ?? true;
  }

  @override
  Future<void> configureRemoteRealm(String userPhone, IUser user,
      {Realm? localRealm}) async {
    await ProxyService.realm.configure(
      useInMemoryDb: false,
      useFallBack: false,
      localRealm: localRealm,
      businessId: ProxyService.box.getBusinessId(),
      encryptionKey: ProxyService.box.encryptionKey(),
      branchId: ProxyService.box.getBranchId(),
      userId: ProxyService.box.getUserId(),
    );
  }

  @override
  Future<IUser> login(
      {required String userPhone,
      required bool skipDefaultAppSetup,
      bool stopAfterConfigure = false,
      required HttpClientInterface flipperHttpClient}) async {
    String phoneNumber = userPhone;

    await _initializeRealms();

    if (!isEmail(userPhone) && !phoneNumber.startsWith('+')) {
      phoneNumber = '+' + phoneNumber;
    }

    final http.Response response =
        await sendLoginRequest(phoneNumber, flipperHttpClient, apihub);

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final IUser user = IUser.fromJson(json.decode(response.body));

      await configureTheBox(userPhone, user);
      await configureLocal(useInMemory: false);

      /// clear any business/branches that was logged in this is to unintentionaly log to the branch
      /// that I am not supposed to

      clearData(data: ClearData.Branch);
      clearData(data: ClearData.Business);
      await configureRemoteRealm(userPhone, user, localRealm: localRealm);

      /// before updating local make sure there is realm subscription registered for Access
      try {
        if (ProxyService.realm.realm != null) {
          List<String> subscriptions =
              ProxyService.realm.activeRealmSubscriptions();
          if (!subscriptions
              .contains('access-${ProxyService.box.getBusinessId()}')) {
            // If not, register the 'Access' subscription
            await ProxyService.realm.forceSubs(
              localRealm: localRealm,
              userId: ProxyService.box.getUserId(),
              branchId: ProxyService.box.getBranchId(),
              businessId: ProxyService.box.getBusinessId(),
            );
          }
        }
      } catch (e, s) {
        talker.info(e);
        talker.error(s);
      }

      /// wait for subscription before we go to downloadAssetSave line

      await updateLocalRealm(user, localRealm: ProxyService.local.localRealm);
      talker.info("Waiting before calling downloadAssetSave");
      await Future.delayed(Duration(seconds: 2));
      talker.info("About to call downloadAssetSave");

      talker.info("Finished calling downloadAssetSave");
      AppInitializer.initialize();
      if (stopAfterConfigure) return user;

      if (!skipDefaultAppSetup) {
        await setDefaultApp(user);
      }

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
        localRealm: ProxyService.local.localRealm,
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

  Future<void> _handleLoginError(http.Response response) async {
    if (response.statusCode == 401) {
      throw SessionException(term: "session expired");
    } else if (response.statusCode == 500) {
      throw PinError(term: "Not found");
    } else {
      throw UnknownError(term: response.statusCode.toString());
    }
  }

  /// since when we log in we get all business in login response object
  /// it is assumed that this business/branches are for user access

  @override
  List<Business> businesses() {
    return localRealm!.all<Business>().toList();
  }

  List<Branch> _getBranches(int businessId, bool active) {
    try {
      return localRealm!.query<Branch>(
          r'businessId == $0 && active == $1 || active == $2',
          [businessId, active, false]).toList();
    } catch (e, s) {
      talker.error(e);
      talker.error(s);
      rethrow;
    }
  }

  @override
  List<Branch> branches({int? businessId, bool? includeSelf = false}) {
    if (businessId == null) {
      throw Exception("BusinessId is required");
    }
    return _getBranches(businessId, includeSelf!);
  }

  @override
  Future<List<ITenant>> signup(
      {required Map business,
      required HttpClientInterface flipperHttpClient}) async {
    talker.info(business.toString());
    final http.Response response = await flipperHttpClient
        .post(Uri.parse("$apihub/v2/api/business"), body: jsonEncode(business));
    if (response.statusCode == 200) {
      /// because we want to close the inMemory realm db
      /// as soon as possible so I can be able to save real data into realm
      /// then I call login in here after signup as login handle configuring
      await login(
          userPhone: business['phoneNumber'],
          skipDefaultAppSetup: true,
          flipperHttpClient: flipperHttpClient);

      await configureLocal(useInMemory: false);
      await ProxyService.realm.configure(
        useInMemoryDb: false,
        localRealm: ProxyService.local.localRealm,
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
    Business? business = businessId != null
        ? localRealm!
            .query<Business>(r'serverId == $0', [businessId]).firstOrNull
        : localRealm!.query<Business>(r'isDefault == $0', [true]).firstOrNull;

    /// because when a user logging in have one business and one branch
    /// he is not taken to business choices flow to set default business hence why we need bellow line to choose a business that is not set
    /// as default because we know it is onlyone that exist since the user has one.
    return business ??
        localRealm!.query<Business>(r'isDefault == $0', [false]).first;
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
  Future<List<ITenant>> tenantsFromOnline(
      {required int businessId,
      required HttpClientInterface flipperHttpClient}) async {
    final http.Response response = await flipperHttpClient
        .get(Uri.parse("$apihub/v2/api/tenant/$businessId"));
    if (response.statusCode == 200) {
      if (ProxyService.realm.realm == null) {
        await ProxyService.realm.configure(
          useInMemoryDb: false,
          useFallBack: false,
          localRealm: ProxyService.local.localRealm,
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
  Future<Business?> getBusinessFromOnlineGivenId(
      {required int id, required HttpClientInterface flipperHttpClient}) async {
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

  _createPin(
      {required String phoneNumber,
      required int pin,
      required int branchId,
      required int businessId,
      required HttpClientInterface flipperHttpClient,
      required int defaultApp}) async {
    final data = jsonEncode({
      "userId": pin.toString(),
      "phoneNumber": phoneNumber,
      "pin": pin,
      "branchId": branchId,
      "businessId": businessId,
      "defaultApp": defaultApp
    });
    await flipperHttpClient.post(Uri.parse("$apihub/v2/api/pin"), body: data);
  }

  @override
  Future<Tenant?> saveTenant(String phoneNumber, String name,
      {required Business business,
      required Branch branch,
      required HttpClientInterface flipperHttpClient,
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
      /// add the userId into Pins

      try {
        ITenant jTenant = ITenant.fromRawJson(response.body);
        await _createPin(
          flipperHttpClient: flipperHttpClient,
          phoneNumber: phoneNumber,
          pin: jTenant.userId,
          branchId: business.serverId!,
          businessId: branch.serverId!,
          defaultApp: 1,
        );
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
      required HttpClientInterface flipperHttpClient,
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
  Future<void> deleteBranch(
      {required int branchId,
      required HttpClientInterface flipperHttpClient}) async {
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
    return localRealm!.query<Branch>(r'serverId == $0', [serverId]).firstOrNull;
  }

  @override
  bool isDrawerOpen({required int cashierId, required int branchId}) {
    final drawer = localRealm?.query<Drawers>(
        r'cashierId == $0 AND open == $1 && branchId == $2',
        [cashierId, true, branchId]).firstOrNull;

    if (drawer == null) {
      return false;
    }
    return true;
  }

  @override
  Future<Drawers?> getDrawer({required int cashierId}) async {
    return localRealm!.query<Drawers>(
        r'open == true AND cashierId == $0', [cashierId]).firstOrNull;
  }

  @override
  Drawers? openDrawer({required Drawers drawer}) {
    localRealm!.write(() {
      localRealm!.add<Drawers>(drawer);
    });
    return localRealm!.query<Drawers>(r'id == $0 ', [drawer.id]).firstOrNull;
  }

  @override
  void clearData({required ClearData data}) {
    try {
      if (data == ClearData.Branch) {
        localRealm!.write(() {
          localRealm!.deleteAll<Branch>();
        });
      }
      if (data == ClearData.Business) {
        localRealm!.write(() {
          localRealm!.deleteAll<Business>();
        });
      }
    } catch (e, s) {
      talker.error(e);
      talker.error(s);
    }
  }

  @override
  Drawers? closeDrawer({required Drawers drawer, required double eod}) {
    ProxyService.local.localRealm!.write(() {
      drawer.open = false;
      drawer.cashierId = ProxyService.box.getUserId()!;
      // drawer.closingBalance = double.parse(_controller.text);
      drawer.closingBalance = eod;
      drawer.closingDateTime = DateTime.now().toIso8601String();
    });
    return drawer;
  }
}
