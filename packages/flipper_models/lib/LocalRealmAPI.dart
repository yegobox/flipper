import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:cbl/cbl.dart'
    if (dart.library.html) 'package:flipper_services/DatabaseProvider.dart';
import 'package:supabase_models/brick/models/all_models.dart' as models;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipper_models/CoreSync.dart';
import 'package:flipper_models/DownloadQueue.dart';
import 'package:flipper_models/CoreDataInterface.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/realmExtension.dart';
import 'package:flipper_models/power_sync/schema.dart';
import 'package:flipper_models/Booting.dart';
import 'package:flipper_models/DATA.dart' as defaultData;
import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/helperModels/branch.dart';
import 'package:flipper_models/helperModels/business.dart';
import 'package:flipper_models/helperModels/iuser.dart';
import 'package:flipper_models/helperModels/permission.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/helperModels/tenant.dart';
import 'package:flipper_models/helper_models.dart' as ext;
import 'package:flipper_models/AppInitializer.dart';
import 'package:flipper_services/Miscellaneous.dart';
import 'package:flipper_services/abstractions/storage.dart';
import 'package:path/path.dart' as p;
import 'package:flipper_models/realmModels.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_services/proxy.dart';
import 'package:realm/realm.dart';
import 'package:rxdart/rxdart.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:supabase_models/brick/repository.dart' as brick;
// ignore: unused_import
import 'package:talker_flutter/talker_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' as foundation;
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:supabase_flutter/supabase_flutter.dart' as superUser;

import 'package:flipper_models/RealmInterface.dart';
// ignore: unused_import
import 'dart:async';
import 'dart:typed_data';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flipper_models/helperModels/paystack_customer.dart';
import 'package:flipper_models/helper_models.dart' as extensions;
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/helperModels/business_type.dart';
import 'package:flipper_models/helperModels/pin.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/helperModels/social_token.dart';
import 'package:flipper_models/mixins/TaxController.dart';
import 'package:flipper_mocks/mocks.dart';
import 'package:flipper_services/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:amplify_flutter/amplify_flutter.dart' as amplify;
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart' as cognito;
import 'SessionManager.dart';
import 'package:path/path.dart' as path;
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:flipper_services/database_provider.dart'
    if (dart.library.html) 'package:flipper_services/DatabaseProvider.dart';
import 'package:supabase_models/brick/models/all_models.dart' as brick;

//
class LocalRealmApi
    with Booting, CoreMiscellaneous, defaultData.Data
    implements RealmInterface {
  bool offlineLogin = false;
  @override
  Realm? realm;
  late String apihub;
  late String commApi;
  void _setApiEndpoints() {
    if (foundation.kDebugMode) {
      apihub = AppSecrets.coreApi;
      commApi = AppSecrets.commApi;
    } else {
      apihub = AppSecrets.apihubProd;
      commApi = AppSecrets.commApi;
    }
  }

  @override
  Future<models.Ebm?> ebm({required int branchId}) async {
    final repository = Repository();
    final query =
        brick.Query(where: [brick.Where('branchId').isExactly(branchId)]);
    final result = await repository.get<models.Ebm>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return result.firstOrNull;
  }

  @override
  Future<void> saveEbm(
      {required int branchId,
      required String severUrl,
      required String bhFId}) async {
    Business business = getBusiness();
    final repository = Repository();
    final query =
        brick.Query(where: [brick.Where('branchId').isExactly(branchId)]);
    final ebm = await repository.get<models.Ebm>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    if (ebm.firstOrNull == null) {
      final ebm = models.Ebm(
        id: randomNumber(),
        bhfId: bhFId,
        tinNumber: business.tinNumber!,
        dvcSrlNo: business.dvcSrlNo ?? "vsdcyegoboxltd",
        userId: ProxyService.box.getUserId()!,
        taxServerUrl: severUrl,
        businessId: business.serverId!,
        branchId: branchId,
      );
      repository.upsert(ebm);
    } else {
      final ebms = ebm.firstOrNull;
      ebms!.taxServerUrl = severUrl;
      repository.upsert(ebms);
    }
  }

  @override
  Future<String> dbPath({required String path, int? folder}) async {
    const isTest =
        const bool.fromEnvironment('FLUTTER_TEST_ENV', defaultValue: false);

    if (!isTest) {
      try {
        // Get the app's documents directory
        Directory appDocumentsDirectory =
            await getApplicationDocumentsDirectory();

        // Construct the '_db' directory path with the folder sub-directory (if any)
        final realmDirectory =
            p.join(appDocumentsDirectory.path, '_db', '${folder ?? ""}');

        // Ensure the '_db' directory and any sub-directories are created
        final sourceDirectory = Directory(realmDirectory);
        if (!await sourceDirectory.exists()) {
          await sourceDirectory.create(
              recursive: true); // Creates all necessary directories
        }

        // Construct the final file path with .realm extension
        final String fileName = '$path.realm';
        String finalPath = p.join(realmDirectory, fileName);

        // Log or print the final path (for debugging)
        print("DataPath: $finalPath");

        return finalPath;
      } catch (e) {
        print('Error creating db path: $e');
        rethrow;
      }
    } else {
      // Return an empty string if in test environment
      return "";
    }
  }

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
    realm = Realm(config);
    talker.info("Opened in-memory realm.");
  }

  /// login and send uid to server to get custom token to use for firebase login
  /// on other devices, the login is supposed to start from the phone or mobile
  @override
  Future<http.Response> sendLoginRequest(
      String phoneNumber, HttpClientInterface flipperHttpClient, String apihub,
      {String? uid}) async {
    uid = uid ?? firebase.FirebaseAuth.instance.currentUser?.uid;
    return await flipperHttpClient.post(
      Uri.parse(apihub + '/v2/api/user'),
      body:
          jsonEncode(<String, String?>{'phoneNumber': phoneNumber, 'uid': uid}),
    );
  }

  Future<http.Response> _patchPin(
      int pin, HttpClientInterface flipperHttpClient, String apihub,
      {required String ownerName}) async {
    return await flipperHttpClient.patch(
      Uri.parse(apihub + '/v2/api/pin/${pin}'),
      body: jsonEncode(<String, String?>{
        'ownerName': ownerName,
        'tokenUid': firebase.FirebaseAuth.instance.currentUser?.uid
      }),
    );
  }

  @override
  Future<RealmInterface> configureLocal(
      {required bool useInMemory, required LocalStorage box}) async {
    _setApiEndpoints();

    const isTest =
        const bool.fromEnvironment('FLUTTER_TEST_ENV', defaultValue: false);

    // Set API keys based on the environment
    if (foundation.kDebugMode) {
      apihub = AppSecrets.coreApi;
      commApi = AppSecrets.commApi;
    } else {
      apihub = AppSecrets.apihubProd;
      commApi = AppSecrets.commApi;
    }
    Configuration config;

    // Close any existing local realm instance
    realm?.close();

    try {
      if (useInMemory ||
          box.encryptionKey().isEmpty ||
          isTest ||
          box.getBusinessId() == null) {
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
          schemaVersion: schemaVersion,
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
        realm = await Realm.open(config);
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
    return realm?.isClosed ?? true;
  }

  Future<void> _suserbaseAuth() async {
    try {
      // Check if the user already exists
      final email = '${ProxyService.box.getBranchId()}@flipper.rw';
      final superUser.User? existingUser =
          superUser.Supabase.instance.client.auth.currentUser;

      if (existingUser == null) {
        // User does not exist, proceed to sign up
        await superUser.Supabase.instance.client.auth.signUp(
          email: email,
          password: email,
        );
        // Handle sign-up response if needed
      } else {
        // User exists, log them in
        await superUser.Supabase.instance.client.auth.signInWithPassword(
          email: email,
          password: email,
        );
      }
    } catch (e) {}
  }

  @override
  Future<IUser> login(
      {required String userPhone,
      required Pin pin,
      required bool skipDefaultAppSetup,
      bool stopAfterConfigure = false,
      required HttpClientInterface flipperHttpClient}) async {
    await _initializeRealms();

    final String phoneNumber = _formatPhoneNumber(userPhone);
    final IUser user =
        await _authenticateUser(phoneNumber, pin, flipperHttpClient);

    await configureSystem(userPhone, user, offlineLogin: offlineLogin);
    await ProxyService.box.writeBool(key: 'authComplete', value: true);

    if (stopAfterConfigure) return user;

    if (!skipDefaultAppSetup) {
      await setDefaultApp(user);
    }
    ProxyService.box.writeBool(key: 'pinLogin', value: false);

    /// check user subs
    try {
      _hasActiveSubscription();
    } catch (e) {
      rethrow;
    }
    return user;
  }

  Future<void> _hasActiveSubscription() async {
    await hasActiveSubscription(
        businessId: ProxyService.box.getBusinessId()!,
        flipperHttpClient: ProxyService.http);
  }

  String _formatPhoneNumber(String userPhone) {
    if (!isEmail(userPhone) && !userPhone.startsWith('+')) {
      return '+$userPhone';
    }
    return userPhone;
  }

  Future<IUser> _authenticateUser(String phoneNumber, Pin pin,
      HttpClientInterface flipperHttpClient) async {
    List<Business> businessesE = businesses();
    List<Branch> branchesE = await branches(businessId: pin.businessId!);

    if (businessesE.isNotEmpty && branchesE.isNotEmpty) {
      offlineLogin = true;

      return _createOfflineUser(phoneNumber, pin, businessesE, branchesE);
    }

    final http.Response response =
        await sendLoginRequest(phoneNumber, flipperHttpClient, apihub);

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      /// path the user pin, with
      final IUser user = IUser.fromJson(json.decode(response.body));
      await _patchPin(user.id!, flipperHttpClient, apihub,
          ownerName: user.tenants.first.name);
      ProxyService.box.writeInt(key: 'userId', value: user.id!);
      await ProxyService.backUp.firebaseLogin(token: user.uid);
      return user;
    } else {
      await _handleLoginError(response);
      throw Exception("Error during login");
    }
  }

  IUser _createOfflineUser(String phoneNumber, Pin pin,
      List<Business> businesses, List<Branch> branches) {
    return IUser(
      token: pin.tokenUid!,
      uid: pin.tokenUid,
      channels: [],
      phoneNumber: pin.phoneNumber!,
      id: pin.userId!,
      tenants: [
        ITenant(
            id: randomNumber(),
            name: pin.ownerName == null ? "DEFAULT" : pin.ownerName!,
            phoneNumber: phoneNumber,
            permissions: [],
            branches: _convertBranches(branches),
            businesses: _convertBusinesses(businesses),
            businessId: 0,
            nfcEnabled: false,
            userId: pin.userId!,
            isDefault: false)
      ],
    );
  }

  List<IBranch> _convertBranches(List<Branch> branches) {
    return branches
        .map((e) => IBranch(
            id: e.id,
            name: e.name,
            businessId: e.businessId,
            longitude: e.longitude,
            latitude: e.latitude,
            location: e.location,
            active: e.active,
            isDefault: e.isDefault))
        .toList();
  }

  List<IBusiness> _convertBusinesses(List<Business> businesses) {
    return businesses
        .map((e) => IBusiness(
              id: e.serverId,
              encryptionKey: e.encryptionKey!,
              name: e.name,
              currency: e.currency,
              categoryId: e.categoryId,
              latitude: e.latitude,
              longitude: e.longitude,
              userId: e.userId,
              timeZone: e.timeZone,
              country: e.country,
              businessUrl: e.businessUrl,
              hexColor: e.hexColor,
              imageUrl: e.imageUrl,
              type: e.type,
              active: e.active,
              metadata: e.metadata,
              lastSeen: e.lastSeen,
              firstName: e.firstName,
              lastName: e.lastName,
              deviceToken: e.deviceToken,
              chatUid: e.chatUid,
              backUpEnabled: e.backUpEnabled,
              subscriptionPlan: e.subscriptionPlan,
              nextBillingDate: e.nextBillingDate,
              previousBillingDate: e.previousBillingDate,
              isLastSubscriptionPaymentSucceeded:
                  e.isLastSubscriptionPaymentSucceeded,
              backupFileId: e.backupFileId,
              email: e.email,
              lastDbBackup: e.lastDbBackup,
              fullName: e.fullName,
              role: e.role,
              tinNumber: e.tinNumber,
              bhfId: e.bhfId,
              dvcSrlNo: e.dvcSrlNo,
              adrs: e.adrs,
              taxEnabled: e.taxEnabled,
              taxServerUrl: e.taxServerUrl,
              isDefault: e.isDefault,
              businessTypeId: e.businessTypeId,
              deletedAt: e.deletedAt,
            ))
        .toList();
  }

  @override
  Future<void> configureSystem(String userPhone, IUser user,
      {required bool offlineLogin}) async {
    await configureTheBox(userPhone, user);
    await configureLocal(useInMemory: false, box: ProxyService.box);
    await updateLocalRealm(user, localRealm: realm);

    AppInitializer.initialize();
    if (!offlineLogin) {
      await _suserbaseAuth();
    }
  }

  Future<void> _initializeRealms() async {
    if (realm == null) {
      await configureLocal(useInMemory: false, box: ProxyService.box);
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
    if (realm == null) return [];
    return realm!.all<Business>().toList();
  }

  List<Branch> _getBranches(int businessId, bool active) {
    try {
      return realm!.query<Branch>(
          r'businessId == $0 && active == $1 || active == $2',
          [businessId, active, false]).toList();
    } catch (e, s) {
      talker.error(e);
      talker.error(s);
      rethrow;
    }
  }

  @override
  Future<List<Branch>> branches(
      {required int businessId, bool? includeSelf = false}) async {
    return _getBranches(businessId, includeSelf!);
  }

  @override
  Future<List<ITenant>> signup(
      {required Map business,
      required HttpClientInterface flipperHttpClient}) async {
    final http.Response response = await flipperHttpClient
        .post(Uri.parse("$apihub/v2/api/business"), body: jsonEncode(business));
    if (response.statusCode == 200) {
      /// because we want to close the inMemory realm db
      /// as soon as possible so I can be able to save real data into realm
      /// then I call login in here after signup as login handle configuring
      IPin? pin = await ProxyService.local.getPin(
          pinString: ProxyService.box.getUserId().toString(),
          flipperHttpClient: ProxyService.http);

      ///save or update the pin, we might get the pin from remote then we need to update the local or create new one
      Pin? savedPin = await savePin(
          pin: Pin(ObjectId(),
              userId: int.parse(pin!.userId),
              id: int.parse(pin.userId),
              branchId: pin.branchId,
              businessId: pin.businessId,
              ownerName: pin.ownerName,
              tokenUid: pin.tokenUid,
              phoneNumber: pin.phoneNumber));
      await login(
          pin: savedPin!,
          userPhone: business['phoneNumber'],
          skipDefaultAppSetup: true,
          flipperHttpClient: flipperHttpClient);

      await configureLocal(useInMemory: false, box: ProxyService.box);

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
              deletedAt: business.deletedAt,
              encryptionKey: business.encryptionKey);
          businessToAdd.add(biz);
        }
        realm!.write(() {
          realm!.addAll<Business>(businessToAdd);
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
              deletedAt: brannch.deletedAt);
          branchToAdd.add(branch);
        }
        realm!.write(() {
          realm!.addAll<Branch>(branchToAdd);
        });

        for (IPermission permission in jTenant.permissions) {
          realm!.add<LPermission>(LPermission(ObjectId(),
              id: permission.id, name: permission.name));
        }

        realm!.add(iTenant);
      }
      realm!.write(() {
        realm!.addAll<Tenant>(tenantToAdd);
      });
      return ITenant.fromJsonList(response.body);
    } else {
      talker.error(response.body.toString());
      throw InternalServerError(term: response.body.toString());
    }
  }

  @override
  Business? getBusinessById({required int businessId}) {
    return realm!.query<Business>(r'serverId == $0', [businessId]).firstOrNull;
  }

  @override
  Business getBusiness({int? businessId}) {
    Business? business = businessId != null
        ? realm!.query<Business>(r'serverId == $0', [businessId]).firstOrNull
        : realm!.query<Business>(r'isDefault == $0', [true]).firstOrNull;

    /// because when a user logging in have one business and one branch
    /// he is not taken to business choices flow to set default business hence why we need bellow line to choose a business that is not set
    /// as default because we know it is onlyone that exist since the user has one.
    return business ??
        realm!.query<Business>(r'isDefault == $0', [false]).first;
  }

  @override
  Future<Business> getBusinessFuture({int? businessId}) async {
    if (businessId != null) {
      return realm!.query<Business>(r'serverId == $0', [businessId]).first;
    } else {
      ///FIXME: what will happen if a user has multiple business associated to him
      ///the code bellow suggest that the first in row will be returned which can be wrong.
      int? userId = ProxyService.box.getUserId();
      return realm!.query<Business>(r'userId == $0', [userId]).first;
    }
  }

  @override
  Future<Business?> defaultBusiness() async {
    return realm!.query<Business>(r'isDefault == $0 ', [true]).firstOrNull;
  }

  @override
  Branch? defaultBranch() {
    return realm!.query<Branch>(r'isDefault == $0 ', [true]).firstOrNull;
  }

  @override
  Future<Branch> activeBranch() async {
    return realm!.query<Branch>(r'isDefault == $0', [true]).first;
  }

  @override
  Future<Business?> activeBusinesses({required int userId}) async {
    // AND (active == $1 OR active == $2)
    return realm!.query<Business>(r'userId == $0 ', [userId]).firstOrNull;
  }

  @override
  Future<List<ITenant>> tenantsFromOnline(
      {required int businessId,
      required HttpClientInterface flipperHttpClient}) async {
    final http.Response response = await flipperHttpClient
        .get(Uri.parse("$apihub/v2/api/tenant/$businessId"));
    if (response.statusCode == 200) {
      if (realm == null) {
        await configureLocal(useInMemory: false, box: ProxyService.box);
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
              deletedAt: business.deletedAt,
              encryptionKey: business.encryptionKey);
          Business? exist = realm!
              .query<Business>(r'serverId == $0', [business.id]).firstOrNull;
          if (exist == null) {
            realm!.add<Business>(biz);
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
              deletedAt: brannch.deletedAt);
          Branch? exist =
              realm!.query<Branch>(r'serverId == $0', [brannch.id]).firstOrNull;
          if (exist == null) {
            realm!.write(() => realm!.add<Branch>(branch));
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

        realm!.write(() {
          realm!.addAll<LPermission>(permissionToAdd);
        });
        Tenant? tenanti =
            realm!.query<Tenant>(r'userId==$0', [iTenant.userId]).firstOrNull;

        if (tenanti == null) {
          tenantToAdd.add(iTenant);
        }
      }

      if (tenantToAdd.isNotEmpty) {
        realm!.write(() {
          realm!.addAll<Tenant>(tenantToAdd);
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
        realm!.query<Business>(r'serverId == $0', [id]).firstOrNull;

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
      realm!.write(() {
        realm!.add<Business>(business);
      });
      return business;
    }
    return null;
  }

  @override
  Future<List<Business>> getContacts() async {
    return realm!.query<Business>(
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
    talker.info(jsonEncode(branch.toEJson().toFlipperJson()));

    final data = jsonEncode({
      "phoneNumber": phoneNumber,
      "name": name,
      "businessId": business.serverId,
      "permissions": [
        {"name": userType.toLowerCase()}
      ],
      "businesses": [business.toEJson().toFlipperJson()],
      "branches": [branch.toEJson().toFlipperJson()]
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
          Business? existingBusiness = realm!
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
                active: branch.active,
                lastTouched: branch.lastTouched,
                latitude: branch.latitude,
                longitude: branch.longitude);
            branchToAdd.add(br);
          }
        }

        for (var permission in jTenant.permissions) {
          LPermission? existingPermission = realm!
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
        Tenant? tenant =
            realm!.query<Tenant>(r'userId==$0', [iTenant.userId]).firstOrNull;
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
          realm!.write(() {
            realm!.add<Tenant>(tenantToAdd!);
          });
        }

        realm!.write(() {
          realm!.addAll<Business>(businessToAdd);
          realm!.addAll<Branch>(branchToAdd);
          realm!.write(() {
            realm!.addAll<LPermission>(permissionToAdd);
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
    List<UnversalProduct> items =
        realm!.query<UnversalProduct>(r'branchId == $0', [branchId]).toList();

    return items;
  }

  @override
  Stream<List<AppNotification>> notificationStream(
      {required int identifier}) async* {
    final subject = ReplaySubject<List<AppNotification>>();

    final query = realm!.query<AppNotification>(
        r'identifier == $0 AND completed == $1', [identifier, false]);

    query.changes.listen((results) {
      subject.add(results.results.toList());
    });

    yield* subject.stream;
  }

  @override
  void notify({required AppNotification notification}) {
    realm!.write(() {
      realm!.add<AppNotification>(notification);
    });
  }

  @override
  AppNotification notification({required int id}) {
    return realm!.query<AppNotification>(r'id == $0', [id]).first;
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
      realm!.write(() {
        realm!.add<Branch>(
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
      return realm!.query<Branch>(r'serverId == $0', [branchLocal.id]).first;
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
          realm!.query<Branch>(r'serverId == $0', [branchId]).firstOrNull;
      realm!.write(() {
        realm!.delete(branch!);
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

  @override
  bool isDrawerOpen({required int cashierId, required int branchId}) {
    final drawer = realm?.query<Drawers>(
        r'cashierId == $0 AND open == $1 && branchId == $2',
        [cashierId, true, branchId]).firstOrNull;

    if (drawer == null) {
      return false;
    }
    return true;
  }

  @override
  Future<Drawers?> getDrawer({required int cashierId}) async {
    return realm!.query<Drawers>(
        r'open == true AND cashierId == $0', [cashierId]).firstOrNull;
  }

  @override
  Drawers? openDrawer({required Drawers drawer}) {
    realm!.write(() {
      realm!.add<Drawers>(drawer);
    });
    return realm!.query<Drawers>(r'id == $0 ', [drawer.id]).firstOrNull;
  }

  @override
  void clearData({required ClearData data}) {
    try {
      if (data == ClearData.Branch) {
        realm?.write(() {
          realm?.deleteAll<Branch>();
        });
      }
      if (data == ClearData.Business) {
        realm?.write(() {
          realm?.deleteAll<Business>();
        });
      }
    } catch (e, s) {
      talker.error(e);
      talker.error(s);
    }
  }

  @override
  Drawers? closeDrawer({required Drawers drawer, required double eod}) {
    realm!.write(() {
      drawer.open = false;
      drawer.cashierId = ProxyService.box.getUserId()!;
      // drawer.closingBalance = double.parse(_controller.text);
      drawer.closingBalance = eod;
      drawer.closingDateTime = DateTime.now().toIso8601String();
    });
    return drawer;
  }

  //// from online->local

  @override
  Future<int> addVariant(
      {required List<Variant> variations, required int branchId}) async {
    try {
      for (final variation in variations) {
        await _processVariant(branchId, variation);
      }
      return 200;
    } catch (e) {
      print('Failed to add variants: $e');
      rethrow;
    }
  }

  Future<void> _processVariant(int branchId, Variant variation) async {
    try {
      int stockId = randomNumber();
      Variant? variant = realm!.query<Variant>(
          r'id == $0 && branchId == $1 && deletedAt == nil',
          [variation.id, branchId]).firstOrNull;

      if (variant != null) {
        Stock? stock = realm!.query<Stock>(
            r'id == $0 && branchId == $1 && deletedAt == nil',
            [stockId, branchId]).firstOrNull;

        if (stock == null) {
          final newStock = Stock(ObjectId(),
              id: stockId,
              lastTouched: DateTime.now(),
              branchId: branchId,
              variantId: variation.id!,
              currentStock: stock?.rsdQty ?? 0,
              rsdQty: stock?.rsdQty ?? 0,
              value: (variation.stock?.rsdQty ?? 0 * (variation.retailPrice))
                  .toDouble(),
              productId: variation.productId,
              active: false);
          realm!.put<Stock>(newStock, tableName: 'stocks');
        }

        stock!.currentStock =
            stock.currentStock + (variation.stock?.rsdQty ?? 0);
        stock.rsdQty = stock.currentStock + (stock.rsdQty);
        stock.lastTouched = DateTime.now().toLocal();
        stock.value =
            (variation.stock?.rsdQty ?? 0 * (variation.retailPrice)).toDouble();
        realm!.put<Stock>(stock, tableName: 'stocks');

        variant.stock?.rsdQty = variation.stock?.rsdQty ?? 0;
        variant.retailPrice = variation.retailPrice;
        variant.supplyPrice = variation.supplyPrice;
        variant.lastTouched = DateTime.now().toLocal();
        realm!.put<Variant>(variant, tableName: 'variants');
      } else {
        int stockId = randomNumber();

        talker.info("Saving variant when scanning..... [1]");

        realm!.put<Variant>(variation, tableName: 'variants');

        final newStock = Stock(ObjectId(),
            id: stockId,
            lastTouched: DateTime.now(),
            branchId: branchId,
            variantId: variation.id,
            currentStock: variation.stock?.rsdQty ?? 0,
            value: (variation.stock?.rsdQty ?? 0 * (variation.retailPrice))
                .toDouble(),
            productId: variation.productId)
          ..active = true;

        realm!.put<Stock>(newStock, tableName: 'stocks');
      }
    } catch (e, s) {
      talker.error(s);
    }
  }

  @override
  void createVariant(
      {required String barCode,
      required String sku,
      required int productId,
      required double retailPrice,
      required double supplierPrice,
      required String color,
      required double qty,
      required int branchId,
      required int itemSeq,
      required int tinNumber,
      required String name}) {
    Variant variant = _createRegularVariant(branchId, tinNumber,
        qty: qty,
        supplierPrice: supplierPrice,
        retailPrice: retailPrice,
        itemSeq: itemSeq,
        name: name,
        sku: sku,
        ebmSynced: false,
        productId: productId);
    realm!.write(() {
      realm!.add<Variant>(variant);
    });
  }

  Variant _createRegularVariant(int branchId, int? tinNumber,
      {required double qty,
      required double supplierPrice,
      required double retailPrice,
      required int itemSeq,
      String? bhFId,
      required bool ebmSynced,
      Product? product,
      required int productId,
      required String name,
      required String sku}) {
    final int variantId = randomNumber();
    final number = randomNumber().toString().substring(0, 5);
    String itemPrefix = "FLIPPER-";
    String clip = itemPrefix +
        DateTime.now().microsecondsSinceEpoch.toString().substring(0, 5);
    return Variant(ObjectId(),
        lastTouched: DateTime.now(),
        name: product?.name ?? name,
        sku: sku,
        productId: product?.id ?? productId,
        color: product?.color,
        unit: 'Per Item',
        productName: product?.name ?? name,
        branchId: branchId,
        supplyPrice: supplierPrice,
        retailPrice: retailPrice,
        id: variantId,
        isTaxExempted: false,
        bhfId: bhFId ?? '00',
        itemStdNm: "Regular",
        addInfo: "A",
        pkg: "1",
        splyAmt: supplierPrice,
        itemClsCd: "5020230602",
        itemCd: clip,
        modrNm: number,
        modrId: number,
        pkgUnitCd: "BJ",
        regrId: randomNumber().toString().substring(0, 5),
        itemTyCd: "2", // this is a finished product
        /// available type for itemTyCd are 1 for raw material and 3 for service
        /// is insurance applicable default is not applicable
        isrcAplcbYn: "N",
        useYn: "N",
        itemSeq: itemSeq,
        itemNm: product?.name ?? name,
        taxPercentage: 18.0,
        tin: tinNumber,
        bcd: product?.name ?? name,

        /// country of origin for this item we default until we support something different
        /// and this will happen when we do import.
        orgnNatCd: "RW",

        /// registration name
        regrNm: product?.name ?? name,

        /// taxation type code
        taxTyCd: "B", // available types A(A-EX),B(B-18.00%),C,D
        // default unit price
        dftPrc: retailPrice,
        prc: retailPrice,

        // NOTE: I believe bellow item are required when saving purchase
        ///but I wonder how to get them when saving an item.
        spplrItemCd: "",
        spplrItemClsCd: "",
        spplrItemNm: product?.name ?? name,

        /// Packaging Unit
        qtyUnitCd: "U", // see 4.6 in doc
        ebmSynced: ebmSynced);
  }

  _findProductByBusinessId({required String name, required int businessId}) {
    return realm!.query<Product>(
        r'businessId == $0 AND name == $1', [businessId, name]).firstOrNull;
  }

  Future<Variant?> _addMissingVariant(
      Variant? variant, Product? product, int branchId, int tinNumber) async {
    final number = randomNumber().toString().substring(0, 5);

    try {
      if (variant == null) {
        int variantId = randomNumber();

        variant = Variant(ObjectId(),
            id: variantId,
            lastTouched: DateTime.now(),
            name: product!.name,
            color: product.color,
            sku: 'sku',
            productId: product.id!,
            unit: 'Per Item',
            productName: product.name,
            branchId: branchId,
            supplyPrice: 0.0,
            retailPrice: 0.0,
            itemNm: product.name,
            bhfId: (await ProxyService.box.bhfId()) ?? '00',
            isTaxExempted: false,
            // this is fixed but we can get the code to use on item we are saving under selectItemsClass endpoint
            itemClsCd: "5020230602",
            itemCd: randomNumber().toString().substring(0, 5),
            modrNm: number,
            modrId: number,
            pkgUnitCd: "BJ",
            regrId: randomNumber().toString().substring(0, 5),
            itemTyCd: "2", // this is a finished product
            /// available type for itemTyCd are 1 for raw material and 3 for service
            /// is insurance applicable default is not applicable
            isrcAplcbYn: "N",
            useYn: "N",
            itemSeq: 1,
            itemStdNm: product.name,
            taxPercentage: 18.0,
            tin: tinNumber,
            bcd: CUSTOM_PRODUCT,

            /// country of origin for this item we default until we support something different
            /// and this will happen when we do import.
            orgnNatCd: "RW",

            /// registration name
            regrNm: CUSTOM_PRODUCT,

            /// taxation type code
            taxTyCd: "B", // available types A(A-EX),B(B-18.00%),C,D
            // default unit price
            dftPrc: 0,

            // NOTE: I believe bellow item are required when saving purchase
            ///but I wonder how to get them when saving an item.
            spplrItemCd: randomNumber().toString().substring(0, 5),
            spplrItemClsCd: randomNumber().toString().substring(0, 5),
            spplrItemNm: CUSTOM_PRODUCT,
            qtyUnitCd: "U");

        Stock stock = Stock(ObjectId(),
            lastTouched: DateTime.now(),
            id: randomNumber(),
            branchId: branchId,
            variantId: variantId,
            currentStock: 0.0,
            productId: product.id!)
          ..canTrackingStock = false
          ..showLowStockAlert = false
          ..currentStock = 0.0
          ..branchId = branchId
          ..variantId = variantId
          ..lowStock = 10.0 // default static
          ..canTrackingStock = true
          ..showLowStockAlert = true
          ..active = false
          ..productId = product.id!
          ..rsdQty = 0.0;

        realm!.put<Variant>(variant, tableName: 'variants');

        realm!.put<Stock>(stock, tableName: 'stocks');

        return realm!.query<Variant>(r'id == $0 ', [variantId]).firstOrNull;
      }
    } catch (e, s) {
      // Handle error during write operation
      talker.error(e);
      talker.error(s);
      throw Exception(e);
    }
    return variant;
  }

  @override
  Future<SocialToken?> loginOnSocial(
      {String? phoneNumberOrEmail, String? password}) {
    // TODO: implement loginOnSocial
    throw UnimplementedError();
  }

  @override
  Future<LPermission?> permission({required int userId}) async {
    return realm!.query<LPermission>(r'userId == $0 ', [userId]).firstOrNull;
  }

  bool isEmail(String input) {
    // Implement your logic to check if input is an email
    // You can use regular expressions or any other email validation mechanism
    // For simplicity, this example checks if the input contains '@'
    return input.contains('@');
  }

  @override
  Future<List<BusinessType>> businessTypes() async {
    final responseJson = [
      {"id": "1", "typeName": "Flipper Retailer"}
      // {"id": "2", "typeName": "Flipper Connecta"},`
    ];
    Future.delayed(Duration(seconds: 5));
    final response = http.Response(jsonEncode(responseJson), 200);
    if (response.statusCode == 200) {
      return BusinessType.fromJsonList(jsonEncode(responseJson));
    }
    return BusinessType.fromJsonList(jsonEncode(responseJson));
  }

  @override
  Pin? getPinLocal({required int userId}) {
    return realm!.query<Pin>(r'userId == $0', [userId.toString()]).firstOrNull;
  }

  @override
  Future<IPin?> getPin(
      {required String pinString,
      required HttpClientInterface flipperHttpClient}) async {
    try {
      await configureLocal(useInMemory: false, box: ProxyService.box);
      final Uri uri = Uri.parse("$apihub/v2/api/pin/$pinString");
      final localPin =
          realm!.query<Pin>(r'userId == $0', [pinString]).firstOrNull;
      if (localPin != null) {
        /// check if there is business for this user
        Business? business = getBusinessById(businessId: localPin.businessId!);
        Branch? branchE = branch(serverId: localPin.branchId!);
        if (branchE != null || business != null) {
          return IPin(
              id: localPin.id,
              pin: localPin.pin ?? int.parse(pinString),
              userId: localPin.userId!.toString(),
              phoneNumber: localPin.phoneNumber!,
              branchId: localPin.branchId!,
              businessId: localPin.businessId!,
              ownerName: localPin.ownerName!,
              tokenUid: localPin.tokenUid!);
        } else {
          clearData(data: ClearData.Branch);
          clearData(data: ClearData.Business);
        }
      } else {
        /// clear the branch as it is definetly new user logging in, to avoid accidental login to uninted busisness/branch
        clearData(data: ClearData.Branch);
        clearData(data: ClearData.Business);
      }

      final response = await flipperHttpClient.get(uri);

      if (response.statusCode == 200) {
        return IPin.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw PinError(
            term:
                "The PIN entered could not be found. Please check if the PIN is correct and try again.");
      } else {
        throw InternalServerException(
            term:
                "An internal server error occurred. Please try again later. If the issue persists, contact support.");
      }
    } catch (error, s) {
      talker.warning(error, s);

      rethrow;
    }
  }

  @override
  Stream<double> initialStock({required branchId}) async* {
    // Get the list of Stock objects for the given branchId where there is available stock
    final List<Stock> stocks = realm!.query<Stock>(
        r'currentStock > $0 AND branchId == $1', [0, branchId]).toList();

    // Get the list of TransactionItem objects for the given branchId

    double totalSoldValue = 0;

    for (var stock in stocks) {
      // Find corresponding transactions for this stock
      // get variant
      Variant? variant = await getVariantById(id: stock.variantId!);
      // Assuming retailPrice is the price for each unit sold, and sold stock is based on the difference
      double stockSoldValue =
          (stock.initialStock!) * (variant?.retailPrice ?? 0);

      // Add to the total sold value
      totalSoldValue += stockSoldValue;
    }

    // Yield the total sold stock value
    yield totalSoldValue;
  }

  @override
  Stream<double> soldStockValue({required branchId}) async* {
    // Get the list of Stock objects for the given branchId where there is available stock
    final List<Stock> stocks = realm!.query<Stock>(
        r'currentStock > $0 AND branchId == $1', [0, branchId]).toList();

    // Get the list of TransactionItem objects for the given branchId

    double totalSoldValue = 0;

    for (var stock in stocks) {
      // Find corresponding transactions for this stock
      Variant? variant = await getVariantById(id: stock.variantId!);
      // Assuming retailPrice is the price for each unit sold, and sold stock is based on the difference
      double stockSoldValue = (stock.initialStock! - stock.currentStock) *
          (variant?.retailPrice ?? 0);

      // Add to the total sold value
      totalSoldValue += stockSoldValue;
    }

    // Yield the total sold stock value
    yield totalSoldValue;
  }

  Stream<double> stockValue({required branchId}) async* {
    final List<Stock> stocks = realm!.query<Stock>(
        r'currentStock > $0 AND branchId == $1', [0, branchId]).toList();

    // Calculate the total stock value
    double totalStockValue =
        stocks.fold(0, (sum, stock) => sum + (stock.value));

    // Yield the total stock value
    yield totalStockValue;
  }

  @override
  Future<void> markModelForEbmUpdate<T>(
      {required T model, bool updated = true}) async {
    try {
      if (model is Variant) {
        realm!.write(() {
          model.ebmSynced = updated;
        });
      }
      if (model is Stock) {
        realm!.write(() {
          model.ebmSynced = updated;
        });
      }
    } catch (e) {}
  }

  @override
  Stream<List<Category>> categoryStream() async* {
    final controller = StreamController<List<Category>>.broadcast();
    final branchId = ProxyService.box.getBranchId()!;

    final query = realm!.query<Category>(r'branchId == $0 ', [branchId]);

    StreamSubscription<RealmResultsChanges<Category>>? subscription;

    controller.onListen = () {
      subscription = query.changes.listen((event) {
        final changedTransactions =
            event.results.whereType<Category>().toList();
        if (changedTransactions.isNotEmpty) {
          controller.add(query.toList());
        }
      });
    };

    controller.onCancel = () {
      subscription?.cancel();
      controller.close();
    };

    yield* controller.stream;
  }

  @override
  Configurations getByTaxType({required String taxtype}) {
    Configurations result;
    double taxPercentage;

    Configurations? config =
        realm!.query<Configurations>(r'taxType == $0', [taxtype]).firstOrNull;

    if (config != null) return config;

    if (taxtype == "B") {
      taxPercentage = 18.0;
    } else {
      taxPercentage = 0.0;
    }

    result = Configurations(
      ObjectId(),
      taxPercentage: taxPercentage,
      taxType: taxtype,
      id: randomNumber(),
      branchId: ProxyService.box.getBranchId(),
      businessId: ProxyService.box.getBusinessId(),
    );
    realm!.write(() => realm!.add(result));
    return result;
  }

  @override
  Future<RwApiResponse> selectImportItems(
      {required int tin,
      required String bhfId,
      required String lastReqDt}) async {
    return ProxyService.tax.selectImportItems(
      tin: tin,
      bhfId: bhfId,
      lastReqDt: lastReqDt,
      URI: await ProxyService.box.getServerUrl() ?? "",
    );
  }

  @override
  Future<void> syncUserWithAwsIncognito({required String identifier}) async {
    try {
      final result = await amplify.Amplify.Auth.fetchAuthSession();
      if (!result.isSignedIn) {
        final signInResult = await amplify.Amplify.Auth.signIn(
          username: identifier,
          password: identifier,
        );
        if (signInResult.isSignedIn) {
          talker.warning('User logged in successfully');
        } else {
          talker.warning('Login not complete. Additional steps required.');
        }
      }

      /// TODO: once I enable for a user to auth using his creds maybe I will enable this
      /// but we have one user we keep using for auth uploads
      // final Map<cognito.AuthUserAttributeKey, String> userAttributes = {
      //   if (identifier.contains('@'))
      //     cognito.AuthUserAttributeKey.email: identifier,
      //   if (!identifier.contains('@')) ...{
      //     cognito.AuthUserAttributeKey.phoneNumber: identifier,
      //     // Provide a default email to satisfy the schema requirement
      //     cognito.AuthUserAttributeKey.email: 'yegobox@gmail.com',
      //   }
      // };

      // final signUpResult = await amplify.Amplify.Auth.signUp(
      //   username: identifier,
      //   password:
      //       identifier, // Using the identifier as the password for simplicity
      //   options: cognito.SignUpOptions(
      //     userAttributes: userAttributes,
      //   ),
      // );

      // if (signUpResult.isSignUpComplete) {
      //   talker.warning('User signed up successfully!');
      // } else {
      //   talker.warning('Sign up not complete. Additional steps required.');
      // }
    } on cognito.AuthException catch (e) {
      talker.error('Unexpected error: $e');
      // rethrow;
    } catch (e) {
      talker.error('Unexpected error: $e');
      // rethrow;
    }
  }

  @override
  Future<Stream<double>> downloadAssetSave({
    String? assetName,
    String? subPath = "branch",
  }) async {
    try {
      if (realm == null) {
        return Stream.value(0.0);
      }

      talker.info("About to call downloadAssetSave");
      int branchId = ProxyService.box.getBranchId()!;

      if (assetName != null) {
        return downloadAsset(
            branchId: branchId, assetName: assetName, subPath: subPath!);
      }

      List<Assets> assets =
          realm!.query<Assets>(r'branchId == $0', [branchId]).toList();

      StreamController<double> progressController = StreamController<double>();

      for (Assets asset in assets) {
        if (asset.assetName != null) {
          // Get the download stream
          Stream<double> downloadStream = await downloadAsset(
              branchId: branchId,
              assetName: asset.assetName!,
              subPath: subPath!);

          // Listen to the download stream and add its events to the main controller
          downloadStream.listen((progress) {
            print('Download progress for ${asset.assetName}: $progress');
            progressController.add(progress);
          }, onError: (error) {
            // Handle errors in the download stream
            talker.error(
                'Error in download stream for ${asset.assetName}: $error');
            progressController.addError(error);
          });
        } else {
          talker.warning('Asset name is null for asset: ${asset.id}');
        }
      }

      // Close the stream controller when all downloads are finished
      Future.wait(assets.map((asset) => asset.assetName != null
          ? downloadAsset(
              branchId: branchId,
              assetName: asset.assetName!,
              subPath: subPath!)
          : Future.value(Stream.empty()))).then((_) {
        progressController.close();
      }).catchError((error) {
        talker.error('Error in downloading assets: $error');
        progressController.close();
      });

      return progressController.stream;
    } catch (e, s) {
      talker.error('Error in downloading assets: $e');
      talker.error('Error in downloading assets: $s');
      rethrow;
    }
  }

  final sessionManager = SessionManager();

  @override
  Future<Stream<double>> downloadAsset(
      {required int branchId,
      required String assetName,
      required String subPath}) async {
    Directory directoryPath = await getSupportDir();

    final filePath = path.join(directoryPath.path, assetName);

    final file = File(filePath);
    if (await file.exists()) {
      talker.warning('File Exist: ${file.path}');
      return Stream.value(100.0); // Return a stream indicating 100% completion
    }
    talker.warning("file to Download:$filePath");
    if (!await sessionManager.isAuthenticated()) {
      await sessionManager.signIn("yegobox@gmail.com");
      if (!await sessionManager.isAuthenticated()) {
        throw Exception('Failed to authenticate');
      }
    }
    final storagePath = amplify.StoragePath.fromString(
        'public/${subPath}-$branchId/$assetName');
    try {
      // Create a stream controller to manage the progress
      final progressController = StreamController<double>();
      // Start the download process
      final operation = amplify.Amplify.Storage.downloadFile(
        path: storagePath,
        localFile: amplify.AWSFile.fromPath(filePath),
        onProgress: (progress) {
          // Calculate the progress percentage
          final percentageCompleted =
              (progress.fractionCompleted * 100).toInt();
          // Add the progress to the stream
          progressController.sink.add(percentageCompleted.toDouble());
        },
      );
      // Listen for the download completion
      operation.result.then((_) {
        progressController.close();
        talker.warning("Downloaded file at path ${storagePath}");
      }).catchError((error) async {
        progressController.addError(error);
        progressController.close();
      });
      return progressController.stream;
    } catch (e) {
      talker.error('Error downloading file: $e');
      rethrow;
    }
  }

  @override
  Future<bool> removeS3File({required String fileName}) async {
    await syncUserWithAwsIncognito(identifier: "yegobox@gmail.com");
    int branchId = ProxyService.box.getBranchId()!;
    try {
      final result = await amplify.Amplify.Storage
          .remove(
            path: amplify.StoragePath.fromString(
                'public/branch-$branchId/$fileName'),
          )
          .result;
      talker.warning('Removed file: ${result.removedItem.path}');
      return true; // Return true if the file is successfully removed
    } on amplify.StorageException catch (e) {
      talker.warning(e.message);
      return false; // Return false if an exception occurs during the removal process
    }
  }

  @override
  Assets? getAsset({String? assetName, int? productId}) {
    if (assetName != null) {
      return realm!.query<Assets>(r'assetName == $0', [assetName]).firstOrNull;
    } else if (productId != null) {
      return realm!.query<Assets>(r'productId == $0', [productId]).firstOrNull;
    }
    throw Exception("no asset");
  }

  @override
  Future<void> amplifyLogout() async {
    try {
      amplify.Amplify.Auth.signOut();
    } catch (e) {}
  }

  @override
  List<Product> getProducts({String? key}) {
    final product = realm!.query<Product>(r'name CONTAINS $0', [key]).toList();
    return product;
  }

  @override
  List<Variant> getVariants({String? key}) {
    final variant =
        realm!.query<Variant>(r'productName CONTAINS $0', [key]).toList();
    return variant;
  }

  @override
  void saveComposite({required Composite composite}) {
    realm!.write(() {
      realm!.add<Composite>(composite);
    });
  }

  int _getNextSku(int branchId) {
    List<SKU> skus = realm!.query<SKU>(
        r'consumed == $0 && branchId == $1', [false, branchId]).toList();

    // Find the highest SKU value in the database
    int highestSku = skus.isEmpty
        ? 0
        : skus
            .map((sku) => sku.sku!)
            .reduce((max, sku) => max > sku ? max : sku);

    // Log the next SKU to be generated
    talker.info('Generated next SKU: ${highestSku + 1}');

    // Return the next SKU value
    return highestSku + 1;
  }

  SKU _createNewSku({required int branchId, required int businessId}) {
    SKU newSku = SKU(
      ObjectId(),
      id: randomNumber(),
      sku: _getNextSku(branchId),
      branchId: branchId,
      businessId: businessId,
      consumed: false,
    );
    realm!.write(() {
      realm!.add<SKU>(newSku);
    });
    // Log the new SKU creation
    talker.info('Created new SKU: ${newSku.sku} for branch $branchId');

    return newSku;
  }

  SKU _getSku({required int branchId, required int businessId}) {
    return _createNewSku(branchId: branchId, businessId: businessId);
  }

  @override
  Stream<SKU?> sku({required int branchId, required int businessId}) async* {
    if (realm == null) {
      throw Exception('Realm is null!');
    }

    // Check for existing non-consumed SKU
    SKU? existingSku = realm!.query<SKU>(
        r'branchId == $0 AND consumed == false', [branchId]).firstOrNull;

    try {
      if (existingSku == null) {
        realm!.write(() {
          existingSku =
              _createNewSku(branchId: branchId, businessId: businessId);
          realm!.add<SKU>(existingSku!);
        });

        // Log the SKU creation
        talker.info('Added new SKU: ${existingSku!.sku} for branch $branchId');
      }
    } catch (e) {
      talker.error(e);
    }

    // Use RealmResults to continuously observe changes
    final results =
        realm!.query<SKU>(r'branchId == $0 AND consumed == false', [branchId]);

    await for (var event in results.changes) {
      if (event.results.isEmpty) {
        late SKU newSku;
        realm!.write(() {
          newSku = _createNewSku(branchId: branchId, businessId: businessId);
          realm!.add<SKU>(newSku);
        });
        // Log the SKU creation
        talker.info('Created new SKU: ${newSku.sku} for branch $branchId');
        yield newSku;
      } else {
        final sku = event.results.first;
        realm!.write(() {
          sku.consumed = true; // Mark as consumed
          realm!.add<SKU>(sku); // Update the SKU
        });
        // Log the SKU consumption
        talker.info('Marked SKU: ${sku.sku} as consumed for branch $branchId');
        yield sku;
      }
    }
  }

  // TODO: micreate product to realm.writeN

  @override
  Future<Product?> createProduct(
      {required Product product,
      required int businessId,
      required int branchId,
      required int tinNumber,
      required String bhFId,
      bool skipRegularVariant = false,
      double qty = 1,
      double supplyPrice = 0,
      double retailPrice = 0,
      int itemSeq = 1,
      bool ebmSynced = false}) async {
    // Check if the product created (custom or temp) already exists and return it
    final String productName = product.name!;
    if (productName == CUSTOM_PRODUCT || productName == TEMP_PRODUCT) {
      final Product? existingProduct = await _findProductByBusinessId(
          name: productName, businessId: businessId);
      if (existingProduct != null) {
        return existingProduct;
      }
    }
    SKU sku = _getSku(branchId: branchId, businessId: businessId);

    /// update it to consumed
    realm!.write(() {
      sku.consumed = true;
    });

    realm!.put<Product>(product, tableName: 'products');

    if (!skipRegularVariant) {
      Product kProduct =
          realm!.query<Product>(r'id == $0 ', [product.id]).first;

      // Create a Regular Variant
      Variant newVariant = _createRegularVariant(branchId, tinNumber,
          qty: qty,
          product: product,
          bhFId: bhFId,
          supplierPrice: supplyPrice,
          retailPrice: retailPrice,
          name: product.name!,
          sku: sku.sku.toString(),
          productId: product.id!,
          itemSeq: itemSeq,
          ebmSynced: ebmSynced);
      realm!.put<Variant>(newVariant, tableName: 'variants');

      // Create a Stock for the Regular Variant
      final Stock stock = Stock(ObjectId(),
          lastTouched: DateTime.now(),
          id: randomNumber(),
          branchId: branchId,
          variantId: newVariant.id!,
          currentStock: qty,
          productId: kProduct.id!);

      realm!.write(() {
        realm!.add<Stock>(stock);
      });

      /// add stock back to variant
      realm!.write(() {
        newVariant.stock = stock;
      });
    }

    return realm!.query<Product>(r'id == $0 ', [product.id]).firstOrNull;
  }

  @override
  List<Composite> composites({required int productId}) {
    final queryBuilder =
        realm!.query<Composite>(r'productId == $0', [productId]);

    return queryBuilder.toList();
  }

  @override
  Composite? composite({required int variantId}) {
    final queryBuilder =
        realm!.query<Composite>(r'variantId == $0', [variantId]);
    return queryBuilder.firstOrNull;
  }

  @override
  Future<String> uploadPdfToS3(Uint8List pdfData, String fileName) async {
    try {
      int branchId = ProxyService.box.getBranchId()!;
      final filePath = 'public/invoices-${branchId}/$fileName.pdf';

      final result = await amplify.Amplify.Storage
          .uploadFile(
            localFile: amplify.AWSFile.fromStream(
              Stream.value(pdfData),
              size: pdfData.length,
            ),
            path: amplify.StoragePath.fromString(filePath),
            onProgress: (progress) {
              talker
                  .warning('Fraction completed: ${progress.fractionCompleted}');
            },
          )
          .result;
      return result.uploadedItem.path;
    } catch (e) {
      talker.error("Error uploading file to S3: $e");
      rethrow;
    }
  }

  @override
  List<Composite> compositesByVariantId({required int variantId}) {
    final queryBuilder =
        realm!.query<Composite>(r'variantId == $0', [variantId]);

    return queryBuilder.toList();
  }

  @override
  Tenant? tenant({int? businessId, int? userId}) {
    Tenant? tenant;

    if (businessId != null) {
      tenant =
          realm!.query<Tenant>(r'businessId == $0', [businessId]).firstOrNull;
    } else {
      tenant = realm!.query<Tenant>(r'userId == $0', [userId]).firstOrNull;
    }

    return tenant;
  }

  @override
  Stream<List<Report>> reports({required int branchId}) async* {
    final controller = StreamController<List<Report>>.broadcast();

    final query = realm!.query<Report>(r'branchId == $0', [branchId]);

    StreamSubscription<RealmResultsChanges<Report>>? subscription;

    controller.onListen = () {
      subscription = query.changes.listen((event) {
        final changedReports = event.results.whereType<Report>().toList();
        if (changedReports.isNotEmpty) {
          controller.add(query.toList());
        }
      });
    };

    controller.onCancel = () {
      subscription?.cancel();
      controller.close();
    };

    // Emit initial data
    controller.add(query.toList());

    yield* controller.stream;
  }

  @override
  Report report({required int id}) {
    return realm!.query<Report>(r'id == $0', [id]).first;
  }

  @override
  Future<({double grossProfit, double netProfit})> getReportData() async {
    // Query the Realm database for all stock items for the current branch
    final query = realm!
        .query<Stock>(r'branchId == $0', [ProxyService.box.getBranchId()]);

    // Check if there are any results
    if (query.isEmpty) {
      // Return default values if no data is found
      return (grossProfit: 0.0, netProfit: 0.0);
    }

    // Initialize variables to accumulate gross and net profit
    double totalGrossProfit = 0.0;
    double totalNetProfit = 0.0;

    // Iterate over all stock items and calculate gross and net profit
    for (var stock in query) {
      final grossProfit =
          (((await getVariantById(id: stock.variantId!))?.retailPrice ?? 0) -
                  ((await getVariantById(id: stock.variantId!))?.supplyPrice ??
                      0)) *
              stock.currentStock;
      totalGrossProfit += grossProfit;

      // If net profit needs other expenses deducted, adjust accordingly
      // For now, we'll keep it equal to gross profit
      totalNetProfit +=
          grossProfit; //TODO: You can add other deductions here if necessary
    }

    // Return the accumulated data
    return (grossProfit: totalGrossProfit, netProfit: totalNetProfit);
  }

  @override
  bool isAdmin({required int userId, required String appFeature}) {
    try {
      final Access? permission = realm?.query<Access>(
          r'userId == $0 && featureName == $1',
          [userId, appFeature]).firstOrNull;
      talker.warning(permission?.accessLevel?.toLowerCase());
      return permission?.accessLevel?.toLowerCase() == "admin";
    } catch (e) {
      rethrow;
    }
  }

  @override
  List<Access> access({required int userId}) {
    return realm!.query<Access>(r'userId == $0 ', [userId]).toList();
  }

  @override
  List<LPermission> permissions({required int userId}) {
    return realm!.query<LPermission>(r'userId == $0 ', [userId]).toList();
  }

  @override
  Stream<List<StockRequest>> requestsStream(
      {required int branchId, required String filter}) {
    if (realm == null) {
      return Stream.value([]);
    }

    if (filter == RequestStatus.approved) {
      final query = realm!.query<StockRequest>(
          r'mainBranchId == $0 && status == $1',
          [branchId, RequestStatus.approved]);

      return query.changes
          .map((changes) => changes.results.toList())
          .startWith(query.toList())
          .debounceTime(Duration(milliseconds: 100));
    } else {
      final query = realm!.query<StockRequest>(
          r'mainBranchId == $0 && status == $1 || status == $2',
          [branchId, RequestStatus.pending, RequestStatus.partiallyApproved]);

      return query.changes
          .map((changes) => changes.results.toList())
          .startWith(query.toList())
          .debounceTime(Duration(milliseconds: 100));
    }
  }

  @override
  Tenant getTenant({required int userId}) {
    try {
      return realm!.query<Tenant>(r'userId == $0', [userId]).first;
    } catch (e, s) {
      talker.error(e);
      talker.error(s);
      rethrow;
    }
  }

  @override
  List<StockRequest> requests({required int branchId}) {
    return realm!.query<StockRequest>(
        r'mainBranchId == $0 && status == $1 || status == $2', [
      branchId,
      RequestStatus.pending,
      RequestStatus.partiallyApproved
    ]).toList();
  }

  String getDueDate() {
    final now = DateTime.now();
    final dueDate = now.add(Duration(days: 30));
    return dueDate.toIso8601String().split('T')[0];
  }

  @override
  Future<({String url, int userId, String customerCode})> subscribe(
      {required int businessId,
      required int agentCode,
      required Business business,
      required HttpClientInterface flipperHttpClient,
      required int amount}) async {
    String? renderableLink;
    int? userId;
    String? customerCode;

    // Get the user identifier (assumed to be the phone number)
    String userIdentifier = ProxyService.box.getUserPhone()!;

    try {
      // Attempt to retrieve an existing PayStack customer
      PayStackCustomer customer = await ProxyService.payStack
          .getPayStackCustomer(
              business: business,
              userIdentifier.toFlipperEmail(),
              flipperHttpClient);
      // Customer found, proceed to initiate a payment request
      renderableLink = await _initiatePayment(
          flipperHttpClient, customer.data.customerCode,
          amount: amount);
      userId = customer.data.id;
      customerCode = customer.data.customerCode;
    } on CustomerNotFoundException {
      // Customer not found, create a new customer
      Business business = getBusiness();
      PayStackCustomer newCustomer = await ProxyService.payStack.createCustomer(
        flipperHttpClient: flipperHttpClient,
        email: userIdentifier.toFlipperEmail(),
        firstName: business.name!,
        lastName: business.name!,
        phone: userIdentifier.replaceAll("+", ""),
      );
      // New customer created, initiate a payment request
      renderableLink = await _initiatePayment(
          flipperHttpClient, newCustomer.data.customerCode,
          amount: amount);
      userId = newCustomer.data.id;
      customerCode = newCustomer.data.customerCode;
    } catch (e) {
      print('Error: $e');
      // Handle any other errors
    }

    return (
      url: "https://paystack.com/pay/${renderableLink}",
      userId: userId!,
      customerCode: customerCode!
    );
  }

  Future<String> _initiatePayment(
      HttpClientInterface flipperHttpClient, String customerCode,
      {required int amount}) async {
    String dueDate = getDueDate();
    try {
      String paymentRequestResult =
          await ProxyService.payStack.sendPaymentRequest(
        flipperHttpClient: flipperHttpClient,
        customerCode: customerCode,
        amount: amount * 100,
        dueDate: dueDate,
      );
      talker.warning("Renderable $paymentRequestResult");
      return paymentRequestResult;
    } catch (e) {
      print('Payment Error: $e');
      throw e; // Re-throw to be caught in the parent function
    }
  }

  @override
  Future<bool> hasActiveSubscription(
      {required int businessId,
      required HttpClientInterface flipperHttpClient}) async {
    models.Plan? plan = await getPaymentPlan(businessId: businessId);

    if (plan == null) {
      throw NoPaymentPlanFound(
          "No payment plan found for businessId: $businessId");
    }

    // If paymentCompletedByUser is false, sync again and check
    if (!(plan.paymentCompletedByUser ?? false)) {
      final isPaymentComplete = await ProxyService.realmHttp.isPaymentComplete(
          flipperHttpClient: flipperHttpClient, businessId: businessId);

      if (!isPaymentComplete) {
        throw FailedPaymentException(PAYMENT_REACTIVATION_REQUIRED);
      }
    }

    return true;
  }

  @override
  Future<PaymentPlan> saveOrUpdatePaymentPlan(
      {required int businessId,
      required String selectedPlan,
      required int additionalDevices,
      required bool isYearlyPlan,
      required double totalPrice,
      String? customerCode,
      required String paymentMethod,
      required int payStackUserId,
      required HttpClientInterface flipperHttpClient}) async {
    try {
      // Find the existing PaymentPlan or create a new one
      PaymentPlan paymentPlan = realm!.query<PaymentPlan>(
              r'businessId == $0', [businessId]).firstOrNull ??
          PaymentPlan(
            ObjectId(),
            businessId: businessId,
            selectedPlan: selectedPlan,
            paymentMethod: paymentMethod,
            additionalDevices: additionalDevices,
            isYearlyPlan: isYearlyPlan,
            customerCode: customerCode,
            totalPrice: totalPrice,
            createdAt: DateTime.now(),
            id: randomNumber(),
          );

      // If the paymentPlan already exists, update its fields with the new values
      realm!.write(() {
        paymentPlan.customerCode = customerCode ?? paymentPlan.customerCode;
        paymentPlan.selectedPlan = selectedPlan;
        paymentPlan.additionalDevices = additionalDevices;
        paymentPlan.isYearlyPlan = isYearlyPlan;
        paymentPlan.rule = isYearlyPlan ? 'yearly' : 'monthly';
        paymentPlan.totalPrice = totalPrice;
        paymentPlan.paymentMethod = paymentMethod;
        paymentPlan.paymentCompletedByUser = false;

        paymentPlan.payStackCustomerId = payStackUserId;

        // Save or update the payment plan in the Realm database
        realm!.add<PaymentPlan>(paymentPlan, update: true);
      });

      // For debugging or confirmation
      print('Saved PaymentPlan: $selectedPlan');
      print('Additional Devices: $additionalDevices');
      print('Is Yearly Plan: $isYearlyPlan');
      print('Total Price: $totalPrice RWF');

      // Return the PaymentPlan
      return realm!.query<PaymentPlan>(r'businessId == $0', [businessId]).first;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<models.Plan?> getPaymentPlan({required int businessId}) async {
    final result =
        await ProxyService.backUp.getPaymentPlan(businessId: businessId);
    return result;
  }

  @override
  FlipperSaleCompaign? getLatestCompaign() {
    try {
      return realm!
          .query<FlipperSaleCompaign>('TRUEPREDICATE SORT(createdAt DESC)')
          .firstOrNull;
    } catch (e, s) {
      talker.warning(e);
      talker.error(s);
      rethrow;
    }
  }

  @override
  Stream<PaymentPlan?> paymentPlanStream({required int businessId}) {
    try {
      if (realm == null) {
        return Stream.value(null);
      }

      final query = realm!.query<PaymentPlan>(
          r'businessId == $0 && paymentCompletedByUser == $1',
          [businessId, true]);

      return query.changes
          .map((event) => event.results.isNotEmpty ? event.results.first : null)
          .distinct()
          .asBroadcastStream();
    } catch (e, s) {
      talker.warning(e);
      talker.warning(s);
      rethrow;
    }
  }

  @override
  Variant? getVariantByProductId({required int productId}) {
    return realm!.query<Variant>(r'productId == $0', [productId]).firstOrNull;
  }

  @override
  Stream<List<Variant>> geVariantStreamByProductId({required int productId}) {
    final variants = realm!.query<Variant>(r'productId == $0', [productId]);
    return variants.changes
        .map((event) => event.results.toList())
        .distinct()
        .asBroadcastStream();
  }

  /// when item.active == true
  /// then this means item is on cart
  @override
  List<TransactionItem> transactionItems(
      {int? transactionId,
      bool? doneWithTransaction,
      required int branchId,
      bool? active}) {
    String queryString = "";

    if (transactionId == null) {
      queryString = r'branchId == $0';
      final items =
          realm!.query<TransactionItem>(queryString, [branchId]).toList();
      return items;
    } else if (doneWithTransaction == null || active == null) {
      queryString = r'transactionId == $0  && branchId ==$1';
      final items = realm!.query<TransactionItem>(
          queryString, [transactionId, branchId]).toList();
      return items;
    } else {
      queryString =
          r'transactionId == $0  && doneWithTransaction == $1  && branchId ==$2 && active == $3';
      final items = realm!.query<TransactionItem>(queryString,
          [transactionId, doneWithTransaction, branchId, active]).toList();
      return items;
    }
  }

  @override
  Stream<List<TransactionItem>> transactionItemsStreams(
      {required int transactionId,
      required int branchId,
      required bool doneWithTransaction,
      required bool active}) {
    try {
      final query = realm!.query<TransactionItem>(
          r'transactionId == $0  && doneWithTransaction == $1  && branchId ==$2 && active == $3',
          [transactionId, doneWithTransaction, branchId, active]);

      // final a = realm!.query<TransactionItem>(
      //     r'transactionId == $0  && doneWithTransaction == $1  && branchId ==$2 && active == $3',
      //     [transactionId, doneWithTransaction, branchId, active]).toList();
      // talker.warning('transactionItemsStreams: ${a.length}');

      return query.changes
          .map((event) => event.results.toList())
          .distinct()
          .asBroadcastStream();
    } catch (e, s) {
      talker.info(e);
      talker.error(s);
      rethrow;
    }
  }

  @override
  Stream<double> getStockStream(
      {int? productId, int? variantId, required int branchId}) {
    if (realm == null) {
      return Stream.value(0.0);
    }

    String queryString;
    List<int> queryParams;

    if (productId != null) {
      queryString = r'productId == $0 && branchId == $1';
      queryParams = [productId, branchId];
    } else if (variantId != null) {
      queryString = r'variantId == $0 && branchId == $1';
      queryParams = [variantId, branchId];
    } else {
      return Stream.value(0.0);
    }

    return realm!.query<Stock>(queryString, queryParams).changes.map((change) =>
        change.results.isEmpty ? 0.0 : change.results.first.currentStock);
  }

  @override
  void deleteItemFromCart(
      {required TransactionItem transactionItemId, int? transactionId}) {
    // get transactionItem where match transactionItemId
    TransactionItem item = realm!
        .query<TransactionItem>(r'id == $0', [transactionItemId.id]).first;
    realm!.write(() {
      realm!.deleteN(
          tableName: transactionItemsTable, deleteCallback: () => item);
    });
  }

  @override
  void createNewStock(
      {required Variant variant,
      required TransactionItem item,
      required int subBranchId}) {
    realm!.write(() {
      final newStock = Stock(
        ObjectId(),
        id: randomNumber(),
        lastTouched: DateTime.now(),
        branchId: subBranchId,
        variantId: variant.id!,
        currentStock: item.quantityRequested!.toDouble(),
        rsdQty: item.quantityRequested!.toDouble(),
        value: (item.quantityRequested! * variant.retailPrice).toDouble(),
        productId: variant.productId,
        active: false,
      );
      realm!.add(newStock);
    });
  }

  @override
  void createOrUpdateBranchOnCloud(
      {required Branch branch, required bool isOnline}) {
    Branch? branchSaved =
        realm!.query<Branch>(r'id == $0', [branch.id]).firstOrNull;
    if (branchSaved == null) {
      realm!.write(() {
        realm!.add<Branch>(branch);
      });
    } else {
      realm!.write(() {
        branchSaved.isOnline = isOnline;
      });
    }
  }

  @override
  Future<List<Activity>> activities({required int userId}) async {
    // Get the current date
    DateTime now = DateTime.now();

    // Calculate the start and end of the current day
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    DateTime endOfDay = startOfDay.add(Duration(days: 1));

    return realm!.query<Activity>(
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
    List<Activity> userActivities = await activities(userId: userId);

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
      } catch (error, s) {
        talker.error('Error fetching tenant: $s');
        talker.error('Error fetching tenant: $error');
      }
      await Future.delayed(Duration(minutes: refreshRate!));
    }
  }

  @override
  int createStockRequest(List<TransactionItem> items,
      {required String deliveryNote,
      DateTime? deliveryDate,
      required int mainBranchId}) {
    int orderId = randomNumber();
    for (TransactionItem item in items) {
      realm!.writeN(
        tableName: transactionItemsTable,
        writeCallback: () {
          return item;
        },
        onAdd: (data) {
          // ProxyService.backUp.replicateData(transactionItemsTable, data);
        },
      );
    }

    realm!.writeN(
      tableName: stockRequestsTable,
      writeCallback: () {
        final stockRequest = StockRequest(
          ObjectId(),
          id: orderId,
          deliveryDate: deliveryDate,
          deliveryNote: deliveryNote,
          mainBranchId: mainBranchId,
          subBranchId: ProxyService.box.getBranchId(),
          status: RequestStatus.pending,
          items: items,
          updatedAt: DateTime.now().toUtc().toLocal(),
          createdAt: DateTime.now().toUtc().toLocal(),
        );
        return stockRequest;
      },
      onAdd: (data) {
        // ProxyService.backUp.replicateData(stockRequestsTable, data);
      },
    );
    return orderId;
  }

  @override
  List<Stock> stocks({required int branchId}) {
    // Variant on stock to not be null, this will have to be considered moving on to sql
    return realm!.query<Stock>(
        r'branchId == $0 AND variant.productName != $1 AND variant != null',
        [branchId, TEMP_PRODUCT]).toList();
  }

  @override
  void updateStock({required int stockId, required double qty}) {
    Stock? stock = realm!.query<Stock>(r'id == $0', [stockId]).firstOrNull;
    if (stock != null) {
      realm!.writeN(
        tableName: stocksTable,
        writeCallback: () {
          stock.currentStock = qty;
          stock.initialStock = qty;
          return stock;
        },
        onAdd: (data) {
          // ProxyService.backUp.replicateData(stocksTable, data);
        },
      );
    }
  }

  @override
  void updateTransactionItemQty(
      {required qty, required int transactionItemId}) {
    TransactionItem? item = realm!
        .query<TransactionItem>(r'id == $0', [transactionItemId]).firstOrNull;
    if (item != null) {
      realm!.write(() {
        item.qty = qty;
      });
    }
  }

  @override
  Future<({double expense, double income})> getTransactionsAmountsSum(
      {required String period}) async {
    DateTime oldDate;
    DateTime temporaryDate;

    if (period == 'Today') {
      DateTime tempToday = DateTime.now();
      oldDate = DateTime(tempToday.year, tempToday.month, tempToday.day);
    } else if (period == 'This Week') {
      oldDate = DateTime.now().subtract(Duration(days: 7));
    } else if (period == 'This Month') {
      oldDate = DateTime.now().subtract(Duration(days: 30));
    } else {
      oldDate = DateTime.now().subtract(Duration(days: 365));
    }

    List<ITransaction> transactionsList = transactions();

    List<ITransaction> filteredTransactions = [];
    for (final transaction in transactionsList) {
      temporaryDate = DateTime.parse(transaction.createdAt!);
      if (temporaryDate.isAfter(oldDate)) {
        filteredTransactions.add(transaction);
      }
    }

    double sum_cash_in = 0;
    double sum_cash_out = 0;
    for (final transaction in filteredTransactions) {
      if (transaction.transactionType == 'Cash Out') {
        sum_cash_out = transaction.subTotal + sum_cash_out;
      } else {
        sum_cash_in = transaction.subTotal + sum_cash_in;
      }
    }

    return (income: sum_cash_in, expense: sum_cash_out);
  }

  @override
  Future<
      ({
        List<Device> devices,
        List<Favorite> favorites,
        List<Product> products,
        List<Stock> stocks,
        List<TransactionItem> transactionItems,
        List<ITransaction> transactions,
        List<Variant> variants
      })> getUnSyncedData() {
    // TODO: implement getUnSyncedData
    throw UnimplementedError();
  }

  @override
  Category? activeCategory({required int branchId}) {
    return realm!.query<Category>(
        r'focused == $0 && active == $1 && branchId == $2',
        [true, true, branchId]).firstOrNull;
  }

  @override
  Future<Customer?> addCustomer(
      {required Customer customer, required int transactionId}) async {
    try {
      // Open a write transaction

      // Add the customer to the Realm
      realm!.put(customer, tableName: 'customers');

      // Get the transaction from Realm
      final transaction =
          realm!.all<ITransaction>().firstWhere((t) => t.id == transactionId);

      realm!.write(() {
        // Update the transaction with the customer ID
        transaction.customerId = customer.id;
      });
      return realm!.query<Customer>(r'id == $0', [customer.id]).first;
    } catch (e) {
      print('Failed to add customer: $e');
      rethrow;
    }
  }

  @override
  Future<int> addFavorite({required Favorite data}) async {
    try {
      final fav = realm!.query<Favorite>(
          r'favIndex == $0 && deletedAt == nil', [data.favIndex!]).firstOrNull;

      if (fav == null) {
        data.id = randomNumber();

        realm!.put<Favorite>(data, tableName: 'favorites');

        return 200;
      } else {
        await realm!.write(() {
          fav.productId = data.productId;
        });
        return 200;
      }
    } catch (e) {
      print('Error adding favorite: $e');
      rethrow;
    }
  }

  @override
  Future<Stock?> addStockToVariant({required Variant variant}) async {
    Stock stock = Stock(ObjectId(),
        id: randomNumber(),
        productId: variant.productId,
        variantId: variant.id,
        branchId: variant.branchId);
    try {
      realm!.put<Stock>(stock, tableName: 'stocks');

      return stock;
    } catch (e) {
      print('Error adding stock to variant: $e');
      rethrow;
    }
  }

  @override
  void addTransactionItem(
      {required ITransaction transaction,
      required TransactionItem item,
      required bool partOfComposite}) {
    // Add the new item to the database
    realm!.write(() {
      realm!.add<TransactionItem>(item);
    });

    /// update this item to know if it is involved in the composition
    /// so it will be treated differently on cart.

    // Fetch all items
    var allItems = realm!.query<TransactionItem>(
        r'transactionId ==$0', [transaction.id]).toList();

    // Sort the items if necessary
    // Assuming there's a property 'createdAt' to sort items chronologically
    allItems.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));

    // Update the itemSeq for each item
    realm!.write(() {
      for (var i = 0; i < allItems.length; i++) {
        allItems[i].itemSeq = i + 1; // itemSeq should start from 1
      }
    });

    // Save the updated items back to the database
    realm!.write(() {
      for (var updatedItem in allItems) {
        realm!.add<TransactionItem>(updatedItem);
      }
    });

    /// update transaction's subTotal
  }

  @override
  Future<int> addUnits<T>({required List<Map<String, dynamic>> units}) async {
    final branchId = ProxyService.box.getBranchId()!;

    try {
      final unitsToAdd = <IUnit>[];
      // Open a write transaction
      for (Map map in units) {
        final unit = IUnit(ObjectId(),
            active: map['active'],
            branchId: branchId,
            id: randomNumber(),
            name: map['name'],
            lastTouched: DateTime.now(),
            value: map['value']);

        // Add the unit to Realm
        unitsToAdd.add(unit);
      }
      realm!.write(() {
        realm!.addAll<IUnit>(unitsToAdd);
      });

      return 200; // Return a success code
    } catch (e) {
      print('Failed to add units: $e');
      rethrow;
    }
  }

  @override
  void assignCustomerToTransaction(
      {required int customerId, int? transactionId}) async {
    try {
      // Open a single write transaction
      realm!.write(() {
        // Get the transaction object
        final transaction = realm!
            .query<ITransaction>(r'id == $0', [transactionId]).firstOrNull;

        // Update the transaction's customerId if it exists
        if (transaction != null) {
          transaction.customerId = customerId;
        } else {
          throw Exception('Transaction with ID $transactionId not found');
        }

        // Get the customer object
        final customer =
            realm!.query<Customer>(r'id == $0', [customerId]).firstOrNull;

        // Update the customer's updatedAt if it exists
        if (customer != null) {
          customer.updatedAt = DateTime.now();
        } else {
          throw Exception('Customer with ID $customerId not found');
        }
      });
    } catch (e) {
      print('Failed to assign customer to transaction: $e');
      rethrow;
    }
  }

  @override
  Stream<Tenant?> authState({required int branchId}) async* {
    final userId = ProxyService.box.getUserId();

    if (userId == null) {
      // Handle the case where userId == null, perhaps throw an exception or return an error Stream
      throw Exception('User ID == nil');
    }

    if (realm == null) {
      // Handle the case where realm == null, perhaps throw an exception or return an error Stream
      throw Exception('Realm == nil');
    }

    final controller = StreamController<Tenant?>();

    realm!.query<Tenant>(r'userId == $0 ', [userId]).changes.listen((tenants) {
          controller
              .add(tenants.results.isEmpty ? null : tenants.results.first);
        });

    await for (var tenant in controller.stream) {
      yield tenant;
    }

    // Close the StreamController after the stream is finishe
    controller.close();
  }

  @override
  Future<bool> bindProduct(
      {required int productId, required int tenantId}) async {
    try {
      final product =
          realm!.query<Product>(r'id == $0 ', [productId]).firstOrNull;

      if (product == null) {
        // Product not found
        return false;
      }

      product.nfcEnabled = true;
      product.bindedToTenantId = tenantId;

      // realm!.write(() {
      //   realm!.put<Product>(product);
      // });

      return true;
    } catch (error) {
      // Handle error during binding process
      return false;
    }
  }

  @override
  Future<List<Category>> categories({required int branchId}) async {
    //  return  realm!categorys.filter().branchIdEqualTo(branchId).findAll();
    return realm!.query<Category>(r'branchId == $0 ', [branchId]).toList();
  }

  @override
  Future<bool> checkIn({required String? checkInCode}) {
    // TODO: implement checkIn
    throw UnimplementedError();
  }

  @override
  void clear() {
    // TODO: implement clear
  }

  /// an experimental to call the mongo db api directly via api
  /// to get changes as subscribing to the change is not getting
  /// data to the device in time we think!

  @override
  void close() {
    if (realm == null) return null;
    realm!.close();
    realm = null;
  }

  @override
  Stream<List<ITransaction>> transactionList({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    if (startDate == null || endDate == null) return Stream.value([]);

    final query = realm!.query<ITransaction>(
      isSameDay(startDate, endDate)
          ? r'lastTouched >= $0  && status == $1 && subTotal > 0'
          : r'lastTouched >= $0 && lastTouched <= $1 && status == $2 && subTotal > 0',
      isSameDay(startDate, endDate)
          ? [startDate.toUtc(), COMPLETE]
          : [startDate.toUtc(), endDate.toUtc(), COMPLETE],
    );

    // Directly return the stream
    return query.changes.map((event) {
      final changedTransactions =
          event.results.whereType<ITransaction>().toList();
      return changedTransactions.isNotEmpty ? changedTransactions : [];
    });
  }

  @override
  Future<ITransaction> collectPayment(
      {required double cashReceived,
      required ITransaction transaction,
      required String paymentType,
      required bool isIncome,
      required String bhfId,
      required double discount,
      String? categoryId,
      required int branchId,
      required bool isProformaMode,
      required bool isTrainingMode,
      required String transactionType,
      bool directlyHandleReceipt = true}) async {
    try {
      List<TransactionItem> items =
          transactionItems(branchId: branchId, transactionId: transaction.id!);

      realm!.writeN(
        tableName: transactionTable,
        writeCallback: () {
          transaction.status = COMPLETE;
          transaction.isIncome = isIncome;
          transaction.isExpense = !isIncome;
          double subTotal = items.fold(0, (num a, b) => a + (b.price * b.qty));

          /// if we are dealing with expenses then subTotal equal to the amount received
          final subTotalFinalied = !isIncome ? cashReceived : subTotal;
          transaction.customerChangeDue = (cashReceived - subTotalFinalied);
          transaction.paymentType = paymentType;
          transaction.cashReceived = cashReceived;

          transaction.subTotal = subTotalFinalied;

          /// for now receipt type to be printed is in box shared preference
          /// this ofcause has limitation that if more than two users are using device
          /// one user will use configuration set by probably a different user, this need to change soon.
          String receiptType = TransactionReceptType.NS;
          if (isProformaMode) {
            receiptType = TransactionReceptType.PS;
          }
          if (isTrainingMode) {
            receiptType = TransactionReceptType.TS;
          }
          transaction.receiptType = receiptType;

          /// refresh created as well to reflect when this transaction was created and completed

          transaction.updatedAt =
              DateTime.now().toUtc().toLocal().toIso8601String();
          transaction.createdAt =
              DateTime.now().toUtc().toLocal().toIso8601String();
          transaction.transactionType = transactionType;
          transaction.categoryId = categoryId ?? "0";
          transaction.lastTouched = DateTime.now().toUtc().toLocal();
          return transaction;
        },
        onAdd: (data) {
          talker.warning(data.toEJson().toFlipperJson());
          // ProxyService.backUp.now(transactionTable, data);
        },
      );

      try {
        for (TransactionItem item in items) {
          /// because there might case where we have non-active transactionItem in the list of
          /// TransactionItem, then we remove it first before completing the transaction
          if (!item.active!) {
            realm!.deleteN(
                tableName: transactionItemsTable, deleteCallback: () => item);
          }
          talker.warning("VariantSoldId for debug: ${item.variantId!}");
          Stock? stock =
              stockByVariantId(variantId: item.variantId!, branchId: branchId);
          final finalStock = (stock!.currentStock - item.qty);
          final bhfId = await ProxyService.box.bhfId();
          try {
            final s = finalStock *
                ((await getVariantById(id: stock.variantId!))?.retailPrice ??
                    0);
            realm!.writeN(
              tableName: stocksTable,
              writeCallback: () {
                stock.rsdQty = finalStock;
                stock.currentStock = finalStock;
                // stock value after item deduct
                stock.value = s;
                stock.ebmSynced = false;
                stock.bhfId = stock.bhfId ?? bhfId;
                stock.tin = stock.tin ?? ProxyService.box.tin();
                return stock;
              },
              onAdd: (data) {
                // ProxyService.backUp.replicateData(stocksTable, data);
              },
            );
          } catch (e, s) {
            talker.warning(e);
            talker.warning(s);
          }
          realm!.writeN(
            tableName: transactionItemsTable,
            writeCallback: () {
              item.doneWithTransaction = true;
              item.updatedAt =
                  DateTime.now().toUtc().toLocal().toIso8601String();
              return item;
            },
            onAdd: (data) {
              // ProxyService.backUp.replicateData(transactionItemsTable, data);
            },
          );

          /// search the related product and touch them to make them as most used
          /// hence why we are adding time to it
          Variant? variant = await getVariantById(id: item.variantId!);
          Product? product = getProduct(id: variant!.productId!);
          if (product != null) {
            realm!.writeN(
              tableName: variantTable,
              writeCallback: () {
                return variant;
              },
              onAdd: (data) {
                // ProxyService.backUp.replicateData(variantTable, data);
              },
            );
          }
        }
      } catch (e, s) {
        talker.error(s);
      }

      //NOTE: trigger EBM, now
      if (directlyHandleReceipt) {
        TaxController(object: transaction)
            .handleReceipt(filterType: FilterType.NS);
      }
      return transaction;
    } catch (e, s) {
      talker.info(e);
      talker.error(s);
      rethrow;
    }
  }

  @override
  Future<List<PColor>> colors({required int branchId}) async {
    return realm!.query<PColor>(r'branchId == $0 ', [branchId]).toList();
  }

  @override
  Future<List<ITransaction>> completedTransactions(
      {required int branchId, String? status = COMPLETE}) async {
    return realm!.query<ITransaction>(
        r'status == $0 && branchId == $1', [COMPLETE, branchId]).toList();
  }

  @override
  void consumePoints({required int userId, required int points}) {
    // TODO: implement consumePoints
  }

  @override
  Future<Voucher?> consumeVoucher({required int voucherCode}) {
    // TODO: implement consumeVoucher
    throw UnimplementedError();
  }

  @override
  Stream<List<Conversation>> conversations({String? conversationId}) {
    // TODO: implement conversations
    throw UnimplementedError();
  }

  @override
  T? create<T>({required T data}) {
    /// update user activity model

    if (data is Counter) {
      Counter counter = data;

      realm!.put<Counter>(counter, tableName: 'counters');
      // Return the created conversation
      // Cast the result to type T
      return data;
    }

    /// end with updating user activity
    if (data is Conversation) {
      Conversation conversation = data;

      realm!.put<Conversation>(conversation, tableName: 'conversations');
      // Return the created conversation
      // Cast the result to type T
      return data;
    }

    if (data is PColor) {
      final colorsToAdd = <PColor>[];
      PColor color = data;
      for (String colorName in data.colors) {
        colorsToAdd.add(PColor(ObjectId(),
            id: randomNumber(),
            lastTouched: DateTime.now(),
            name: colorName,
            active: color.active,
            branchId: color.branchId));
      }
      realm!.write(() => realm!.addAll(colorsToAdd));
    }
    if (data is Device) {
      Device device = data;
      realm!.write(() {
        realm!.add<Device>(device);
      });
      return null;
    }
    if (data is Conversation) {
      Conversation conversation = data;
      realm!.put<Conversation>(conversation, tableName: 'conversations');
      return null;
    }
    if (data is Category) {
      Category category = data;
      realm!.put<Category>(category, tableName: 'categories');
      return null;
    }
    if (data is Product) {
      realm!.put<Product>(data, tableName: 'products');
    }
    if (data is Variant) {
      realm!.put<Variant>(data, tableName: 'variants');
      return null;
    }
    if (data is Favorite) {
      realm!.put<Favorite>(data, tableName: 'favorites');
      return null;
    }
    if (data is Stock) {
      realm!.put<Stock>(data, tableName: 'stocks');
      return null;
    }

    if (data is Token) {
      realm!.put<Token>(data, tableName: 'tokens');
      return null;
    }
    if (data is Setting) {
      realm!.write(() {
        realm!.put<Setting>(data, tableName: 'settings');
      });
      return null;
    }
    if (data is EBM) {
      realm!.put<EBM>(data, tableName: 'ebms');
      return null;
    }
    if (data is ITransaction) {
      realm!.put<ITransaction>(data, tableName: 'transactions');
      return null;
    }
    if (data is TransactionItem) {
      realm!.put<TransactionItem>(data, tableName: 'transactionItems');
      return null;
    }
    return null;
  }

  @override
  Future<Receipt?> createReceipt(
      {required RwApiResponse signature,
      required ITransaction transaction,
      required String qrCode,
      required int invoiceNumber,
      required DateTime whenCreated,
      required String receiptType,
      required brick.Counter counter}) async {
    int branchId = ProxyService.box.getBranchId()!;

    Receipt receipt = Receipt(ObjectId(),
        id: randomNumber(),
        branchId: branchId,
        resultCd: signature.resultCd,
        resultMsg: signature.resultMsg,
        rcptNo: signature.data?.rcptNo ?? 0,
        intrlData: signature.data?.intrlData ?? "",
        rcptSign: signature.data?.rcptSign ?? "",
        qrCode: qrCode,
        receiptType: receiptType,
        invoiceNumber: invoiceNumber,
        vsdcRcptPbctDate: signature.data?.vsdcRcptPbctDate ?? "",
        sdcId: signature.data?.sdcId ?? "",
        totRcptNo: signature.data?.totRcptNo ?? 0,
        mrcNo: signature.data?.mrcNo ?? "",
        transactionId: transaction.id!,
        invcNo: counter.invcNo,
        whenCreated: whenCreated,
        resultDt: signature.resultDt ?? "");

    try {
      realm!.writeN(
        tableName: receiptsTable,
        writeCallback: () {
          // Check if a receipt with the same transaction.id exists
          Receipt? existingReceipt = realm!.query<Receipt>(
              r"transactionId == $0", [transaction.id]).firstOrNull;

          if (existingReceipt != null) {
            // Update existing receipt
            existingReceipt
              ..resultCd = receipt.resultCd
              ..resultMsg = receipt.resultMsg
              ..rcptNo = receipt.rcptNo
              ..intrlData = receipt.intrlData
              ..rcptSign = receipt.rcptSign
              ..qrCode = receipt.qrCode
              ..receiptType = receipt.receiptType
              ..invoiceNumber = receipt.invoiceNumber
              ..vsdcRcptPbctDate = receipt.vsdcRcptPbctDate
              ..sdcId = receipt.sdcId
              ..totRcptNo = receipt.totRcptNo
              ..mrcNo = receipt.mrcNo
              ..invcNo = receipt.invcNo
              ..whenCreated = receipt.whenCreated
              ..resultDt = receipt.resultDt;

            return existingReceipt;
          } else {
            // Add new receipt
            return realm!.add<Receipt>(receipt);
          }
        },
        onAdd: (data) {
          // ProxyService.backUp.replicateData(receiptsTable, data);
        },
      );

      return receipt;
    } catch (error) {
      rethrow;
    }
  }

  @override
  List<Customer> customers({required int branchId}) {
    return realm!.query<Customer>(r'branchId == $0 ', [branchId]).toList();
  }

  @override
  Future<bool> delete(
      {required int id,
      String? endPoint,
      required HttpClientInterface flipperHttpClient}) async {
    switch (endPoint) {
      case 'color':
        PColor color = realm!.query<PColor>(r'id == $0 ', [id]).first;

        realm!.write(() {
          realm!.deleteN(tableName: colorsTable, deleteCallback: () => color);
        });
        break;
      case 'device':
        realm!.write(() {
          Device device = realm!.query<Device>(r'id == $0 ', [id]).first;
          realm!.write(() {
            realm!
                .deleteN(tableName: devicesTable, deleteCallback: () => device);
          });
          return false;
        });
        break;
      case 'category':
        Category category = realm!.query<Category>(r'id == $0 ', [id]).first;
        realm!.write(() {
          realm!.deleteN(
              tableName: categoriesTable, deleteCallback: () => category);
        });
        break;
      case 'product':
        Product? product =
            realm!.query<Product>(r'id == $0 ', [id]).firstOrNull;
        realm!.write(() {
          if (product != null) {
            realm!.deleteN(
                tableName: productsTable, deleteCallback: () => product);
          }
        });
        break;
      case 'variant':
        Variant variant = realm!.query<Variant>(r'id == $0 ', [id]).first;
        realm!.write(() {
          realm!
              .deleteN(tableName: variantTable, deleteCallback: () => variant);
        });
        break;
      case 'stock':
        Stock? stock = realm!.query<Stock>(r'id == $0 ', [id]).first;
        realm!.write(() {
          realm!.deleteN(tableName: stocksTable, deleteCallback: () => stock);
        });
        break;
      case 'setting':
        Setting setting = realm!.query<Setting>(r'id == $0 ', [id]).first;
        realm!.write(() {
          realm!
              .deleteN(tableName: settingsTable, deleteCallback: () => setting);
        });
        break;
      case 'pin':
        Pin? pin = realm!.query<Pin>(r'id == $0 ', [id]).first;

        realm!.write(() {
          realm!.deleteN(tableName: pinsTable, deleteCallback: () => pin);
        });
        break;
      case 'business':
        final business = realm!.query<Business>(r'id == $0 ', [id]).firstOrNull;
        realm!.write(() {
          realm!.deleteN(
              tableName: businessesTable, deleteCallback: () => business!);
        });
        break;

      case 'voucher':
        final business = realm!.query<Voucher>(r'id == $0 ', [id]).firstOrNull;
        realm!.write(() {
          realm!.deleteN(
              tableName: vouchersTable, deleteCallback: () => business!);
        });
        break;
      case 'transactionItem':
        TransactionItem? transactionItem =
            realm!.query<TransactionItem>(r'id == $0 ', [id]).first;

        realm!.write(() {
          realm!.deleteN(
              tableName: transactionItemsTable,
              deleteCallback: () => transactionItem);
        });
        break;
      case 'customer':
        Customer? customer = realm!.query<Customer>(r'id == $0 ', [id]).first;
        realm!.write(() {
          realm!.deleteN(
              tableName: customersTable, deleteCallback: () => customer);
        });
        break;
      case 'tenant':
        final response = await flipperHttpClient
            .delete(Uri.parse("$apihub/v2/api/tenant/${id}"));
        if (response.statusCode == 200) {
          Tenant? tenant = realm!.query<Tenant>(r'id == $0 ', [id]).firstOrNull;
          realm!.write(() {
            realm!.deleteN(
                tableName: tenantsTable, deleteCallback: () => tenant!);
          });
        }
        break;
      case 'assets':
        Assets? asset = realm!.query<Assets>(r'id == $0 ', [id]).first;
        realm!.write(() {
          realm!.deleteN(tableName: assetsTable, deleteCallback: () => asset);
        });
        break;
      case 'permission':
        LPermission? permission =
            realm!.query<LPermission>(r'id == $0 ', [id]).first;
        realm!.write(() {
          realm!.deleteN(
              tableName: lPermissionsTable, deleteCallback: () => permission);
        });
        break;
      case 'access':
        Access? access = realm!.query<Access>(r'id == $0 ', [id]).first;
        realm!.write(() {
          realm!
              .deleteN(tableName: accessesTable, deleteCallback: () => access);
        });
        break;
      default:
        return Future.value(false);
    }
    return Future.value(false);
  }

  @override
  Future<void> deleteAllProducts() async {
    List<Product> products =
        await productsFuture(branchId: ProxyService.box.getBranchId()!);
    List<int> productIds = products.map((product) => product.id!).toList();
    realm!.write(() {
      realm!.deleteMany(productIds
          .map((id) => realm!.query<Product>(r'id == $0', [id]).first));
    });
  }

  @override
  Future<int> deleteFavoriteByIndex({required int favIndex}) async {
    final favorite = realm!.query<Favorite>(
        r'favIndex == $0 && deletedAt == null ', [favIndex]).first;
    realm!.write(() {
      realm!.delete<Favorite>(favorite);
    });
    return Future.value(200);
  }

  @override
  Future<int> deleteTransactionByIndex({required int transactionIndex}) async {
    final transaction = realm!.query<ITransaction>(
        r'id == $0 && deletedAt == null ', [transactionIndex]).first;
    realm!.write(() {
      realm!.delete<ITransaction>(transaction);
    });
    return Future.value(200);
  }

  @override
  void emptySentMessageQueue() {
    // TODO: implement emptySentMessageQueue
  }

  @override
  Future<bool> enableAttendance(
      {required int businessId, required String email}) {
    // TODO: implement enableAttendance
    throw UnimplementedError();
  }

  @override
  Future<Product?> findProductByTenantId({required int tenantId}) async {
    return realm!
        .query<Product>(r'bindedToTenantId == $0', [tenantId]).firstOrNull;
  }

  @override
  Future<PColor?> getColor({required int id}) async {
    return realm!.query<PColor>(r'id == $0', [id]).firstOrNull;
  }

  @override
  Future<Conversation?> getConversation({required String messageId}) {
    // TODO: implement getConversation
    throw UnimplementedError();
  }

  @override
  Future<Counter?> getCounter(
      {required int branchId, required String receiptType}) async {
    return realm!.query<Counter>(r'branchId == $0 AND receiptType == $1',
        [branchId, receiptType.toUpperCase()]).firstOrNull;
  }

  @override
  Future<Variant?> getCustomVariant({
    required int businessId,
    required int branchId,
    required int tinNumber,
    required String bhFId,
  }) async {
    /// Find product with name CUSTOM_PRODUCT
    Product? product = realm!.query<Product>(
        r'name == $0 AND branchId== $1 AND deletedAt == nil',
        [CUSTOM_PRODUCT, branchId]).firstOrNull;

    if (product == null) {
      // Create a new custom product if it doesn't exist
      product = await createProduct(
          tinNumber: tinNumber,
          bhFId: bhFId,
          branchId: branchId,
          businessId: businessId,
          product: Product(ObjectId(),
              id: randomNumber(),
              lastTouched: DateTime.now(),
              name: CUSTOM_PRODUCT,
              businessId: businessId,
              color: "#e74c3c",
              createdAt: DateTime.now().toIso8601String(),
              branchId: branchId));
    }

    /// for whatever reason if a product exist and there is no related variant please add it before we proceed.
    Variant? variant =
        realm!.query<Variant>(r'productId == $0 ', [product!.id]).firstOrNull;

    if (variant == null) {
      /// If the variant doesn't exist, add it
      variant = await _addMissingVariant(variant, product, branchId, tinNumber);
    }

    return variant;
  }

  @override
  List<Customer> getCustomers({String? key, int? id}) {
    if (key != null && id != null) {
      throw ArgumentError(
          'Cannot provide both a key and an id at the same time');
    }
    if (id != null) {
      return realm!.query<Customer>(r'id == $0', [id]).toList();
    } else if (key != null) {
      final customer = realm!.query<Customer>(
          r'custNm LIKE[c] $0 OR email LIKE[c] $0 OR telNo LIKE[c] $0',
          ['*$key*']).toList();
      return customer;
    } else {
      return [];
    }
  }

  @override
  Customer? getCustomer({String? key, int? id}) {
    if (key != null && id != null) {
      throw ArgumentError(
          'Cannot provide both a key and an id at the same time');
    }
    if (id != null) {
      return realm!.query<Customer>(r'id == $0', [id]).firstOrNull;
    } else if (key != null) {
      final customer = realm!.query<Customer>(
          r'(custNm CONTAINS $0 OR email CONTAINS $0 OR telNo CONTAINS $0) AND deletedAt == nil',
          [key]).firstOrNull;
      return customer;
    } else {
      return null;
    }
  }

  @override
  Future<Customer?> getCustomerFuture({String? key, int? id}) async {
    if (key != null && id != null) {
      throw ArgumentError(
          'Cannot provide both a key and an id at the same time');
    }
    if (id != null) {
      return realm!.query<Customer>(r'id == $0', [id]).firstOrNull;
    } else if (key != null) {
      final customer = realm!.query<Customer>(
          r'(custNm CONTAINS $0 OR email CONTAINS $0 OR telNo CONTAINS $0) AND deletedAt == nil',
          [key]).firstOrNull;
      return customer;
    } else {
      return null;
    }
  }

  @override
  Stream<Tenant?> getDefaultTenant({required int businessId}) async* {
    realm!
        .query<Tenant>(r'businessId == $0 AND deletedAt == nil', [businessId])
        .changes
        .listen((_) async* {
          yield realm!.query<Tenant>(r'businessId == $0 AND deletedAt == nil',
              [businessId]).firstOrNull;
        });
  }

  @override
  Future<Device?> getDevice(
      {required String phone, required String linkingCode}) async {
    // get device from realm with linking code and return it
    return realm!.query<Device>(
        r'phone == $0 AND linkingCode == $1 AND deletedAt == nil',
        [phone, linkingCode]).firstOrNull;
  }

  @override
  Future<Device?> getDeviceById({required int id}) async {
    // get device from realm with id and return it
    return realm!.query<Device>(r'id == $0', [id]).firstOrNull;
  }

  @override
  Future<List<Device>> getDevices({required int businessId}) async {
    // get device from realm with linking code and return it
    return realm!.query<Device>(
        r'businessId == $0 AND deletedAt == nil', [businessId]).toList();
  }

  @override
  Future<List<Discount>> getDiscounts({required int branchId}) async {
    return realm!.query<Discount>(r'branchId == $0', [branchId]).toList();
  }

  @override
  Future<Favorite?> getFavoriteById({required int favId}) async {
    // Get a favorite
    return realm!
        .query<Favorite>(r'id == $0 AND deletedAt == nil', [favId]).firstOrNull;
  }

  @override
  Future<Favorite?> getFavoriteByIndex({required int favIndex}) async {
    return realm!.query<Favorite>(
        r'favIndex == $0 AND deletedAt == nil', [favIndex]).firstOrNull;
  }

  @override
  Stream<Favorite?> getFavoriteByIndexStream({required int favIndex}) async* {
    try {
      realm!
          .query<Favorite>(r'favIndex == $0 AND deletedAt == nil', [favIndex])
          .changes
          .listen((_) async* {
            yield realm!.query<Favorite>(
                r'favIndex == $0 AND deletedAt == nil', [favIndex]).firstOrNull;
          });
    } catch (error) {
      // Handle error during query execution
      // You can emit an error signal or log the issue
      throw Exception("error streaming favorites");
    }
  }

  @override
  Future<Favorite?> getFavoriteByProdId({required int prodId}) async {
    return realm!.query<Favorite>(
        r'productId == $0 AND deletedAt == nil', [prodId]).firstOrNull;
  }

  @override
  Future<List<Favorite>> getFavorites() async {
    return realm!.query<Favorite>(r'deletedAt == nil').toList();
  }

  @override
  Product? getProduct({required int id}) {
    return realm!.query<Product>(r'id == $0', [id]).firstOrNull;
  }

  @override
  Future<Product?> getProductByBarCode({
    required String barCode,
    required int branchId,
  }) async {
    return realm!.query<Product>(
        r'barCode == $0 AND deletedAt == null AND branchId ==$1',
        [barCode, branchId]).firstOrNull;
  }

  /// This is dealing with search when searching the product!.
  @override
  Future<List<Product?>> getProductByName(
      {required String name, required int branchId}) async {
    return realm!.query<Product>(
        r'name BEGINSWITH[c] $0 OR name CONTAINS[c] $0 OR name ENDSWITH[c] $0  AND branchId == $1',
        [name, branchId]).toList();
  }

  @override
  Future<List<Product>> getProductList(
      {int? prodIndex, required int branchId}) async {
    // No need for completer as Realm provides built-in async support
    final queryBuilder = realm!.query<Product>(
        r'branchId == $0  AND id =  $1 AND deletedAt == nil',
        [branchId, prodIndex]);

    return queryBuilder.toList();
  }

  @override
  Future<Receipt?> getReceipt({required int transactionId}) async {
    return realm!
        .query<Receipt>(r'transactionId == $0', [transactionId]).firstOrNull;
  }

  @override
  Future<List<Conversation>> getScheduleMessages() {
    // TODO: implement getScheduleMessages
    throw UnimplementedError();
  }

  @override
  Future<Setting?> getSetting({required int businessId}) {
    // TODO: implement getSetting
    throw UnimplementedError();
  }

  @override
  Future<Setting?> getSocialSetting() {
    // TODO: implement getSocialSetting
    throw UnimplementedError();
  }

  @override
  Future<Stock?> getStock(
      {required int branchId, required int variantId}) async {
    return realm!.query<Stock>(
        r'variantId == $0 AND branchId == $1 AND deletedAt == nil',
        [variantId, branchId]).firstOrNull;
  }

  @override
  Stock? getStockById({required int id}) {
    return realm!.query<Stock>(r'id == $0', [id]).firstOrNull;
  }

  @override
  Stream<double> getStockValue({required int branchId}) {
    if (realm == null) {
      return Stream.value(0.0);
    }

    return realm!
        .query<Stock>(r'branchId == $0', [branchId])
        .changes
        .map((change) {
          return change.results.fold(0.0, (sum, stock) => sum + stock.value);
        });
  }

  @override
  Future<Tenant?> getTenantBYPin({required int pin}) async {
    return realm!
        .query<Tenant>(r'pin == $0 AND isDefault $1', [pin, true]).firstOrNull;
  }

  @override
  Future<Tenant?> getTenantBYUserId({required int userId}) async {
    return realm!.query<Tenant>(r'userId == $0', [userId]).firstOrNull;
  }

  @override
  Stream<List<Conversation>> getTop5RecentConversations() {
    // TODO: implement getTop5RecentConversations
    throw UnimplementedError();
  }

  @override
  ITransaction? getTransactionById({required int id}) {
    return realm!.query<ITransaction>(r'id == $0', [id]).firstOrNull;
  }

  @override
  Future<TransactionItem?> getTransactionItemById({required int id}) async {
    return realm!.query<TransactionItem>(r'id == $0', [id]).firstOrNull;
  }

  @override
  TransactionItem? getTransactionItemByVariantId(
      {required int variantId, int? transactionId}) {
    // Build the query string based on whether transactionId is null
    String queryString;
    List<int> parameters = [variantId]; // Initialize with variantId
    if (transactionId == null) {
      queryString = r'variantId == $0';
    } else {
      queryString = r'variantId == $0 AND transactionId == $1';
      parameters.add(transactionId); // Add transactionId only if not null
    }

    // Execute the query
    return realm!.query<TransactionItem>(queryString, parameters).firstOrNull;
  }

  @override
  Future<List<TransactionItem>> getTransactionItemsByTransactionId(
      {required int? transactionId}) async {
    return realm!.query<TransactionItem>(
        r'transactionId == $0', [transactionId]).toList();
  }

  @override
  Stream<List<ITransaction>> transactionStreamById(
      {required int id, required FilterType filterType}) async* {
    final controller = StreamController<List<ITransaction>>.broadcast();

    String queryString = "";
    if (filterType == FilterType.CUSTOMER) {
      queryString = r'customerId == $0';
    } else if (filterType == FilterType.TRANSACTION) {
      queryString = r'id == $0';
    }

    final query = realm!.query<ITransaction>(queryString, [id]);

    StreamSubscription<RealmResultsChanges<ITransaction>>? subscription;

    controller.onListen = () {
      subscription = query.changes.listen((event) {
        final changedTransactions =
            event.results.whereType<ITransaction>().toList();
        if (changedTransactions.isNotEmpty) {
          controller.add(query.toList());
        }
      });
    };

    controller.onCancel = () {
      subscription?.cancel();
      controller.close();
    };

    yield* controller.stream;
  }

  @override
  Future<Variant?> getVariantById({required int id}) async {
    return realm!.query<Variant>(r'id == $0', [id]).firstOrNull;
  }

  @override
  Stream<List<Variant>> getVariantByProductIdStream({int? productId}) {
    final controller = StreamController<List<Variant>>.broadcast();

    final query = realm!.query<Variant>(r'productId == $0', [productId]);

    StreamSubscription<RealmResultsChanges<Variant>>? subscription;

    controller.onListen = () {
      subscription = query.changes.listen((event) {
        final changedVariants = event.results.whereType<Variant>().toList();
        if (changedVariants.isNotEmpty) {
          controller.add(query.toList());
        }
      });
    };

    controller.onCancel = () {
      subscription?.cancel();
      controller.close();
    };

    return controller.stream;
  }

  @override
  bool isSubscribed({required String feature, required int businessId}) {
    // TODO: implement isSubscribed
    throw UnimplementedError();
  }

  @override
  bool isTaxEnabled({required int businessId}) {
    return getBusiness().tinNumber != null;
  }

  @override
  Future<bool> isTokenValid(
      {required String tokenType, required int businessId}) {
    // TODO: implement isTokenValid
    throw UnimplementedError();
  }

  @override
  int lifeTimeCustomersForbranch({required String branchId}) {
    // TODO: implement lifeTimeCustomersForbranch
    throw UnimplementedError();
  }

  @override
  Future<void> loadConversations(
      {required int businessId, int? pageSize = 10, String? pk, String? sk}) {
    // TODO: implement loadConversations
    throw UnimplementedError();
  }

  @override
  Future<ITransaction> manageCashInOutTransaction(
      {required String transactionType,
      required bool isExpense,
      required int branchId}) async {
    ITransaction? existTransaction = await _pendingTransaction(
      branchId: branchId,
      isExpense: isExpense,
      transactionType: transactionType,
    );

    int businessId = ProxyService.box.getBusinessId()!;
    if (existTransaction == null) {
      int id = randomNumber();
      final transaction = ITransaction(ObjectId(),
          lastTouched: DateTime.now(),
          id: id,
          supplierId: businessId,
          reference: randomNumber().toString(),
          transactionNumber: randomNumber().toString(),
          status: PENDING,
          transactionType: transactionType,
          subTotal: 0,
          cashReceived: 0,
          updatedAt: DateTime.now().toIso8601String(),
          customerChangeDue: 0.0,
          paymentType: ProxyService.box.paymentType() ?? "Cash",
          branchId: branchId,
          createdAt: DateTime.now().toIso8601String());

      // save transaction to isar
      realm!.write(() {
        realm!.put<ITransaction>(transaction, tableName: 'transactions');
      });
      return transaction;
    } else {
      return existTransaction;
    }
  }

  @override
  Stream<ITransaction> manageTransactionStream(
      {required String transactionType,
      required bool isExpense,
      required int branchId,
      bool? includeSubTotalCheck = false}) async* {
    // Use async/await to handle asynchronous operations
    final ITransaction? existTransaction = await _pendingTransaction(
        branchId: branchId,
        isExpense: isExpense,
        transactionType: transactionType,
        includeSubTotalCheck: includeSubTotalCheck!);

    if (existTransaction == null) {
      final int id = randomNumber();
      final transaction = ITransaction(
        ObjectId(),
        lastTouched: DateTime.now(),
        id: id,
        reference: randomNumber().toString(),
        transactionNumber: randomNumber().toString(),
        status: PENDING,
        isExpense: isExpense,
        isIncome: !isExpense,
        transactionType: transactionType,
        subTotal: 0,
        cashReceived: 0,
        updatedAt: DateTime.now().toIso8601String(),
        customerChangeDue: 0.0,
        paymentType: ProxyService.box.paymentType() ?? "Cash",
        branchId: branchId,
        createdAt: DateTime.now().toIso8601String(),
      );

      realm!.write(() {
        // Save transaction to Realm
        realm!.add<ITransaction>(transaction);
      });

      yield transaction;
    } else {
      yield existTransaction;
    }
  }

  @override
  ITransaction manageTransaction(
      {required String transactionType,
      required bool isExpense,
      required int branchId,
      bool? includeSubTotalCheck = false}) {
    /// check if realm is not closed
    if (realm == null) {
      throw Exception("realm is empty");
    }
    ITransaction? existTransaction = _pendingTransaction(
        branchId: branchId,
        isExpense: isExpense,
        transactionType: transactionType,
        includeSubTotalCheck: includeSubTotalCheck!);
    if (existTransaction == null) {
      final int id = randomNumber();
      final transaction = ITransaction(ObjectId(),
          lastTouched: DateTime.now(),
          id: id,
          reference: randomNumber().toString(),
          transactionNumber: randomNumber().toString(),
          status: PENDING,
          isExpense: isExpense,
          isIncome: !isExpense,
          transactionType: transactionType,
          subTotal: 0,
          cashReceived: 0,
          updatedAt: DateTime.now().toIso8601String(),
          customerChangeDue: 0.0,
          paymentType: ProxyService.box.paymentType() ?? "Cash",
          branchId: branchId,
          createdAt: DateTime.now().toIso8601String());

      // save transaction to isar
      realm!.put<ITransaction>(transaction, tableName: 'transactions');

      return transaction;
    } else {
      return existTransaction;
    }
  }

  @override
  Stream<List<ITransaction>> orders({required int branchId}) {
    final controller = StreamController<List<ITransaction>>.broadcast();

    final query = realm!.query<ITransaction>(
        r'status == $0 AND  supplierId == $1 AND deletedAt == nil',
        [PENDING, branchId]);

    StreamSubscription<RealmResultsChanges<ITransaction>>? subscription;

    controller.onListen = () {
      subscription = query.changes.listen((event) {
        final changedTransactions =
            event.results.whereType<ITransaction>().toList();
        if (changedTransactions.isNotEmpty) {
          controller.add(query.toList());
        }
      });
    };

    controller.onCancel = () {
      subscription?.cancel();
      controller.close();
    };

    return controller.stream;
  }

  @override
  Future<void> patchSocialSetting({required Setting setting}) async {
    // TODO: implement patchSocialSetting
    throw UnimplementedError();
  }

  /// because we want to deal with transaction that has item
  /// we just return any transaction that has TransactionItem attached
  /// this is to avoid having to deal with multiple transaction that are not complete
  /// we should first return any transaction that has item first.
  ITransaction? _pendingTransaction({
    required int branchId,
    required String transactionType,
    required bool isExpense,
    bool includeSubTotalCheck = true,
  }) {
    String query =
        r'branchId == $0 AND isExpense == $1 AND status == $2 AND transactionType == $3 SORT(createdAt DESC)';
    List<dynamic> parameters = [branchId, isExpense, PENDING, transactionType];

    if (includeSubTotalCheck) {
      query += ' AND subTotal > 0';
    }

    List<ITransaction> transactions =
        realm!.query<ITransaction>(query, parameters).toList();

    for (ITransaction transaction in transactions) {
      List<TransactionItem> items = transactionItems(
        branchId: branchId,
        transactionId: transaction.id!,
        doneWithTransaction: false,
        active: true,
      );

      if (items.isNotEmpty) {
        return transaction;
      }
    }

    // If no transaction with items found, return the first transaction (if any)
    return transactions.isNotEmpty ? transactions.first : null;
  }

  @override
  Stream<List<Product>> productStreams({int? prodIndex}) {
    final controller = StreamController<List<Product>>.broadcast();
    int branchId = ProxyService.box.getBranchId()!;
    RealmResults<Product> query;
    if (prodIndex == null) {
      query = realm!
          .query<Product>(r'branchId == $0  AND deletedAt == nil', [branchId]);
    } else {
      query = realm!.query<Product>(
          r'branchId == $0 AND id == $1 AND deletedAt == nil',
          [branchId, prodIndex]);
    }
    StreamSubscription<RealmResultsChanges<RealmObject>>? subscription;

    controller.onListen = () {
      subscription = query.changes.listen((event) {
        final changedVariants = event.results.whereType<Product>().toList();
        if (changedVariants.isNotEmpty) {
          controller.add(query.toList());
        }
      });
    };

    controller.onCancel = () {
      subscription?.cancel();
      controller.close();
    };

    return controller.stream;
  }

  @override
  Future<List<Product>> products({required int branchId}) async {
    return realm!.query<Product>(
        r'branchId == $0  AND deletedAt == nil', [branchId]).toList();
  }

  @override
  Future<void> recordUserActivity(
      {required int userId, required String activity}) async {
    try {
      final userActivity = Activity(
        ObjectId(),
        activity,
        id: randomNumber(),
        details: RealmValue.from({
          'platform': foundation.kIsWeb ? 'Web' : await _getPlatformInfo(),
          'meta': [
            {'userId': userId},
            {'appVersion': await _getAppVersion()},
          ],
        }),
        timestamp: DateTime.now(),
      );
      realm!.write(() {
        realm!.add<Activity>(userActivity);
      });
    } catch (e, s) {
      talker.error(e);
      talker.error(s);
    }
  }

  Future<String> _getPlatformInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (foundation.kIsWeb) {
      return 'Web'; // No need for device info on web
    } else if (foundation.defaultTargetPlatform ==
        foundation.TargetPlatform.android) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return 'Android (${androidInfo.model})';
    } else if (foundation.defaultTargetPlatform ==
        foundation.TargetPlatform.iOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return 'iOS (${iosInfo.model})';
    } else if (foundation.defaultTargetPlatform ==
        foundation.TargetPlatform.windows) {
      WindowsDeviceInfo iosInfo = await deviceInfo.windowsInfo;
      return 'Mindows-os-version (${iosInfo.majorVersion})';
    } else if (foundation.defaultTargetPlatform ==
        foundation.TargetPlatform.macOS) {
      MacOsDeviceInfo iosInfo = await deviceInfo.macOsInfo;
      return 'Mac-os-version (${iosInfo.majorVersion})';
    } else {
      return 'Unknown';
    }
  }

  Future<String> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  @override
  Future<void> refund({required int itemId}) {
    // TODO: implement refund
    throw UnimplementedError();
  }

  @override
  Future<int> registerOnSocial({String? phoneNumberOrEmail, String? password}) {
    // TODO: implement registerOnSocial
    throw UnimplementedError();
  }

  @override
  void removeCustomerFromTransaction({required ITransaction transaction}) {
    realm!.write(() {
      transaction.customerId = null;
    });
  }

  @override
  Future<void> saveDiscount(
      {required int branchId, required name, double? amount}) {
    // TODO: implement saveDiscount
    throw UnimplementedError();
  }

  @override
  Future<Conversation> sendMessage(
      {required String message, required Conversation latestConversation}) {
    // TODO: implement sendMessage
    throw UnimplementedError();
  }

  @override
  Future<int> sendReport({required List<TransactionItem> transactionItems}) {
    // TODO: implement sendReport
    throw UnimplementedError();
  }

  @override
  Future<void> sendScheduleMessages() {
    // TODO: implement sendScheduleMessages
    throw UnimplementedError();
  }

  @override
  Future<int> size<T>({required T object}) {
    // TODO: implement size
    throw UnimplementedError();
  }

  @override
  Stock? stockByVariantId(
      {required int variantId,
      required int branchId,
      bool nonZeroValue = false}) {
    Stock? stock;
    if (nonZeroValue) {
      stock = realm!.query<Stock>(
          r'variantId ==$0 && branchId == $1 && retailPrice > 0',
          [variantId, branchId]).firstOrNull;
    } else {
      stock = realm!.query<Stock>(r'variantId ==$0 && branchId == $1',
          [variantId, branchId]).firstOrNull;
    }
    return stock;
  }

  @override
  Future<Stock?> stockByVariantIdFuture(
      {required int variantId, bool nonZeroValue = false}) async {
    int branchId = ProxyService.box.getBranchId()!;
    Stock? stock;
    if (nonZeroValue) {
      stock = realm!.query<Stock>(
          r'variantId ==$0 && branchId == $1 && retailPrice > 0 && deletedAt ==nil',
          [variantId, branchId]).firstOrNull;
    } else {
      stock = realm!.query<Stock>(
          r'variantId ==$0 && branchId == $1  && deletedAt ==nil',
          [variantId, branchId]).firstOrNull;
    }
    return stock;
  }

  @override
  Future<double> totalStock({int? productId, int? variantId}) async {
    double totalStock = 0.0;
    if (productId != null) {
      List<Stock> stocks =
          realm!.query<Stock>(r'productId == $0', [productId]).toList();
      totalStock = stocks.fold(0.0, (sum, stock) => sum + (stock.currentStock));
    } else if (variantId != null) {
      List<Stock> stocks =
          realm!.query<Stock>(r'variantId == $0', [variantId]).toList();
      totalStock = stocks.fold(0.0, (sum, stock) => sum + (stock.currentStock));
      totalStock = stocks.fold(0.0, (sum, stock) => sum + (stock.currentStock));
    }
    return totalStock;
  }

  @override
  Future<List<Tenant>> tenants({int? businessId, int? excludeUserId}) async {
    if (businessId != null) {
      if (excludeUserId != null) {
        return realm!.query<Tenant>(r'businessId == $0 && userId != $1',
            [businessId, excludeUserId]).toList();
      } else {
        return realm!.query<Tenant>(r'businessId == $0', [businessId]).toList();
      }
    }
    throw Exception('BusinessId is required');
  }

  @override
  Future<List<ITransaction>> tickets() async {
    return realm!.query<ITransaction>(
        r'status == $0 && branchId == $1 && deletedAt == nil',
        [PARKED, ProxyService.box.getBranchId()!]).toList();
  }

  @override
  Stream<List<ITransaction>> ticketsStreams() {
    int? branchId = ProxyService.box.getBranchId();

    final subject = ReplaySubject<List<ITransaction>>();

    final query = realm?.query<ITransaction>(
        r'status == $0 AND branchId == $1', [PARKED, branchId]);

    query?.changes.listen((results) {
      subject.add(results.results.toList());
    });

    return subject.stream;
  }

  @override
  List<TransactionItem> transactionItemsFuture(
      {required int transactionId,
      required bool doneWithTransaction,
      required bool active}) {
    int branchId = ProxyService.box.getBranchId()!;
    String queryString = "";

    queryString =
        r'transactionId == $0  && doneWithTransaction == $1  && branchId ==$2 && active == $3 && deletedAt = nil';

    return realm!.query<TransactionItem>(queryString,
        [transactionId, doneWithTransaction, branchId, active]).toList();
  }

  @override
  List<ITransaction> transactions({
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    String? transactionType,
    int? branchId,
    bool isExpense = false,
    bool includePending = false,
  }) {
    // Initialize query string
    String queryString = r'''
  status == $0
  && branchId == $1
  ''';

    // Initialize parameters
    List<dynamic> parameters = [
      status ?? COMPLETE,
      branchId ?? 0
    ]; // Ensure branchId is not null

    // Add expense/income condition
    if (isExpense) {
      queryString += ' && isExpense == true && subTotal > 0 ';
    } else {
      queryString += ' && isIncome == true ';
    }

    // Handle date range safely
    if (startDate != null && endDate != null && startDate != endDate) {
      queryString += r' && lastTouched >= $2 && lastTouched <= $3 ';
      parameters.addAll([startDate.toUtc(), endDate.toUtc()]);
    } else if (startDate != null) {
      queryString += r' && lastTouched >= $2 ';
      parameters.add(startDate.toUtc());
    } else if (endDate != null) {
      queryString += r' && lastTouched <= $2 ';
      parameters.add(endDate.toUtc());
    }

    // Handle includePending flag
    if (!includePending) {
      queryString += ' && status != "PENDING" ';
    }

    // If no dates are provided, remove date conditions from the query string
    if (startDate == null && endDate == null) {
      queryString = r'''
  status == $0
  && branchId == $1
  ''';
      parameters = [status ?? COMPLETE, branchId ?? 0];
    }

    // Ensure realm is not null
    if (realm == null) {
      throw Exception("Realm instance is not initialized.");
    }

    // Execute the query
    var results = realm!.query<ITransaction>(queryString, parameters).toList();
    // results.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    return results;
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  Stream<List<TransactionItem>> transactionItemList(
      {DateTime? startDate, DateTime? endDate, bool? isPluReport}) {
    final controller = StreamController<List<TransactionItem>>.broadcast();
    RealmResults<TransactionItem> query;

    query = realm!.query<TransactionItem>(
        startDate == endDate
            ? r'lastTouched >= $0'
            : r'lastTouched >= $0 && lastTouched <= $1',
        startDate == endDate
            ? [startDate?.toUtc()]
            : [startDate?.toUtc(), endDate?.toUtc()]);

    StreamSubscription<RealmResultsChanges<TransactionItem>>? subscription;

    controller.onListen = () {
      subscription = query.changes.listen((event) {
        final changedVariants =
            event.results.whereType<TransactionItem>().toList();
        if (changedVariants.isNotEmpty) {
          controller.add(query.toList());
        }
      });
    };

    controller.onCancel = () {
      subscription?.cancel();
      controller.close();
    };

    return controller.stream;
  }

  @override
  Stream<List<ITransaction>> transactionsStream(
      {String? status,
      String? transactionType,
      int? branchId,
      bool isCashOut = false,
      bool includePending = false}) {
    String queryString = "";
    if (isCashOut) {
      queryString = r'''status == $0
            && isExpense == true && subTotal > 0 && branchId == $1 
            SORT(createdAt DESC)
            ''';
    } else {
      queryString = r'''status == $0 && subTotal > 0  && branchId == $1
             SORT(createdAt DESC)
            ''';
    }
    final query =
        realm!.query<ITransaction>(queryString, [status ?? COMPLETE, branchId]);
    StreamController<List<ITransaction>>? controller;
    controller = StreamController<List<ITransaction>>.broadcast(onListen: () {
      final initialResults = query.toList();
      controller!.sink.add(initialResults.toList());

      query.changes.listen((results) {
        controller!.sink.add(results.results.toList());
      });
    }, onCancel: () {
      controller!.close();
    });

    return controller.stream;
  }

  @override
  Future<List<IUnit>> units({required int branchId}) async {
    final existingUnits =
        realm!.query<IUnit>(r'branchId == $0', [branchId]).toList();
    if (existingUnits.isNotEmpty) {
      return existingUnits;
    }
    await addUnits(units: mockUnits);
    return realm!.query<IUnit>(
        r'branchId ==$0 AND deletedAt == nil', [branchId]).toList();
  }

  @override
  Future<List<Device>> unpublishedDevices({required int businessId}) {
    // TODO: implement unpublishedDevices
    throw UnimplementedError();
  }

  /// Please do not place any realm update here since realm require that when we modify the property
  /// of a model to do it within write transaction so the change take imediate effect and it was natural for our case
  /// that we modify the object and pass in the final object to be updated here later and that will not work with realm
  /// therefore we do the update within write function where the actual update is taking place to avoid crazy error or illusion
  @override
  Future<int> updateNonRealm<T>(
      {required T data, required HttpClientInterface flipperHttpClient}) async {
    /// update user activity
    int userId = ProxyService.box.getUserId() ?? 0;
    if (userId == 0) return 0;
    if (data is Business) {
      final business = data;
      final response = await flipperHttpClient.patch(
          Uri.parse("$apihub/v2/api/business/${business.id}"),
          body: jsonEncode(business.toEJson()));
      if (response.statusCode != 200) {
        throw InternalServerError(term: "error patching the business");
      }
    } else if (data is Branch) {
      final branch = data;
      final response = await flipperHttpClient.patch(
          Uri.parse("$apihub/v2/api/branch/${branch.id}"),
          body: jsonEncode(branch.toEJson()));
      if (response.statusCode != 200) {
        throw InternalServerError(term: "error patching the branch");
      }
    } else if (data is IUser) {
      final response = await flipperHttpClient.patch(
          Uri.parse("$apihub/v2/api/user"),
          body: jsonEncode(data.toEJson()));
      return response.statusCode;
    } else if (data is Tenant) {
      final response = await flipperHttpClient.patch(
          Uri.parse("$apihub/v2/api/tenant/${data.id}"),
          body: jsonEncode(data.toEJson()));
      if (response.statusCode == 200) {
        realm!.write(() {
          realm!.add<Tenant>(data);
        });
      }
      return response.statusCode;
    }

    return 0;
  }

  @override
  Future<bool> updateContact(
      {required Map<String, dynamic> contact, required int businessId}) {
    // TODO: implement updateContact
    throw UnimplementedError();
  }

  @override
  Future<int> userNameAvailable(
      {required String name,
      required HttpClientInterface flipperHttpClient}) async {
    final response =
        await flipperHttpClient.get(Uri.parse("$apihub/search?name=$name"));
    return response.statusCode;
  }

  @override
  Variant? variant({int? variantId, String? name}) {
    if (variantId != null) {
      return realm!.query<Variant>(r'id == $0', [variantId]).firstOrNull;
    }
    if (name != null) {
      return realm!
          .query<Variant>(r'name == $0 || bcd == $0', [name]).firstOrNull;
    }
    return null;
  }

  @override
  Future<List<Product>> productsFuture({required int branchId}) async {
    // Define the date for recent products filtering
    final date = DateTime.now().subtract(const Duration(days: 7));

    // Fetch recent products based on branch ID and additional criteria
    List<Product> recentProducts = realm!.query<Product>(
        r'branchId == $0 && lastTouched > $1 && name != "temp" && productName != $2',
        [branchId, date, CUSTOM_PRODUCT]).toList();

    // If no recent products are found, fetch all products for the branch
    if (recentProducts.isEmpty) {
      recentProducts = realm!.query<Product>(
          r'branchId == $0 && name != "temp" && productName != $1',
          [branchId, CUSTOM_PRODUCT]).toList();
    }

    // Filter out TEMP_PRODUCT and CUSTOM_PRODUCT and sort by lastTouched descending
    List<Product> filteredProducts = recentProducts
        .where((product) =>
            product.name != TEMP_PRODUCT && product.name != CUSTOM_PRODUCT)
        .toList()
      ..sort((a, b) => b.lastTouched!.compareTo(a.lastTouched!));

    // Limit to the last 20 items, if available
    if (filteredProducts.length > 20) {
      filteredProducts = filteredProducts.take(20).toList();
    }

    // Return the filtered and sorted list of products
    return filteredProducts;
  }

  @override
  List<Variant> variants({
    required int branchId,
    int? productId,
    int? page,
    int? itemsPerPage,
  }) {
    List<Variant> variants = [];

    if (productId != null) {
      variants = realm!.query<Variant>(
        r'productId == $0 && branchId == $1 && productName != "temp" && productName != $2',
        [productId, branchId, CUSTOM_PRODUCT],
      ).toList();
    } else {
      variants = realm!.query<Variant>(
        r'branchId == $0 && productName != "temp" && productName != $1',
        [branchId, CUSTOM_PRODUCT],
      ).toList();
    }

    // Check for branchId not owning the product and search in branchIds list
    if (variants.isEmpty) {
      variants = realm!.query<Variant>(
        r'ANY branchIds == $0 && retailPrice > 0',
        [branchId],
      ).toList();
    }

    // Apply pagination only if both page and itemsPerPage are provided
    if (page != null && itemsPerPage != null) {
      final offset = page * itemsPerPage;
      return variants.skip(offset).take(itemsPerPage).toList();
    }

    return variants;
  }

  @override
  RealmInterface instance() {
    // TODO: implement instance
    throw UnimplementedError();
  }

  @override
  void saveStock({required Variant variant, required double rsdQty}) {
    realm!.write(() {
      final stock = Stock(
        ObjectId(),
        id: randomNumber(),
        lastTouched: DateTime.now(),
        branchId: variant.branchId,
        variantId: variant.id!,
        currentStock: variant.stock?.rsdQty ?? 0,
        rsdQty: rsdQty,
        value: (variant.stock?.rsdQty ?? 0 * variant.retailPrice).toDouble(),
        productId: variant.productId,
      );
      realm!.add<Stock>(stock);
    });
  }

  @override
  void updateTransactionStatus(ITransaction transaction, String receiptType) {
    realm!.write(() {
      transaction.ebmSynced = true;
      transaction.isRefunded = receiptType == "R";
    });
  }

  @override
  void savePaymentType({required TransactionPaymentRecord paymentRecord}) {
    realm!.write(() {
      realm!.add<TransactionPaymentRecord>(paymentRecord);
    });
  }

  @override
  List<TransactionPaymentRecord> getPaymentType({required int transactionId}) {
    return realm!.query<TransactionPaymentRecord>(
        r'transactionId == $0', [transactionId]).toList();
  }

  @override
  void updateCounters({
    required List<Counter> counters,
    required RwApiResponse receiptSignature,
  }) {
    realm!.writeN(
      tableName: countersTable,
      writeCallback: () {
        for (Counter counter in counters) {
          talker.warning("Touched Counter ${counter.id}");
          counter.totRcptNo = receiptSignature.data?.totRcptNo;
          counter.curRcptNo = receiptSignature.data?.rcptNo;
          counter.invcNo = (counter.invcNo != null) ? counter.invcNo! + 1 : 1;
        }
        return counters;
      },
      onAdd: (data) {},
    );
  }

  @override
  Future<Pin?> savePin({required Pin pin}) async {
    /// delay to avoid race condition on instantiating local realm
    try {
      await Future.delayed(Duration(seconds: 4));
      Pin? savedPin;
      realm!.writeN(
        tableName: pinsTable,
        writeCallback: () {
          savedPin =
              realm!.query<Pin>(r'userId == $0', [pin.userId]).firstOrNull;
          if (savedPin == null) {
            pin.uid = FirebaseAuth.instance.currentUser!.uid;
            savedPin = realm!.add<Pin>(pin);
          } else {
            savedPin!.userId = pin.userId;
            if (FirebaseAuth.instance.currentUser != null) {
              savedPin!.uid = FirebaseAuth.instance.currentUser?.uid;
            }

            savedPin!.ownerName = pin.ownerName;
            savedPin!.tokenUid = pin.tokenUid;
            savedPin!.phoneNumber = pin.phoneNumber;
            savedPin!.tokenUid = pin.tokenUid;
          }
          return savedPin!;
        },
        onAdd: (data) {
          // ProxyService.backUp.replicateData(pinsTable, data);
        },
      );
      return savedPin!;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> getIdToken() async {
    return await FirebaseAuth.instance.currentUser?.getIdToken() ?? "NONE";
  }

  @override
  Future<String?> getPlatformDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (foundation.defaultTargetPlatform == foundation.TargetPlatform.android) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.serialNumber;
    } else if (foundation.defaultTargetPlatform ==
        foundation.TargetPlatform.iOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.systemVersion;
    } else if (foundation.defaultTargetPlatform ==
        foundation.TargetPlatform.macOS) {
      MacOsDeviceInfo macOsInfo = await deviceInfo.macOsInfo;
      return macOsInfo.systemGUID;
    } else if (foundation.defaultTargetPlatform ==
        foundation.TargetPlatform.windows) {
      WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
      return windowsInfo.deviceId;
    }
    return null;
  }

  @override
  void upSert() {
    talker.warning("Force UPSERT");

    try {
      clearVariants();
      final firestore = FirebaseFirestore.instance;
      CoreSync(firestore, realm: realm!)
          .deleteDuplicate(tableName: productsTable);
      CoreSync(firestore, realm: realm!)
          .deleteDuplicate(tableName: variantTable);
      CoreSync(firestore, realm: realm!)
          .deleteDuplicate(tableName: stocksTable);
      CoreSync(firestore, realm: realm!)
          .deleteDuplicate(tableName: transactionItemsTable);
      CoreSync(firestore, realm: realm!)
          .deleteDuplicate(tableName: stockRequestsTable);
      CoreSync(firestore, realm: realm!)
          .deleteDuplicate(tableName: accessesTable);
      CoreSync(firestore, realm: realm!)
          .deleteDuplicate(tableName: transactionItemsTable);
      CoreSync(firestore, realm: realm!)
          .deleteDuplicate(tableName: assetsTable);
      CoreSync(firestore, realm: realm!)
          .deleteDuplicate(tableName: categoriesTable);

      /// get all Products
      List<Product> products = realm!.all<Product>().toList();
      for (Product product in products) {
        if (product.id == null) {
          realm!.write(() {
            realm!.delete(product);
          });
          continue;
        }

        ProxyService.backUp.updateRecord(
          tableName: productsTable,
          idField: "${productsTable.singularize()}_id",
          map: product.toEJson().toFlipperJson(),
          id: product.id!,
          syncProviders: [SyncProvider.FIRESTORE, SyncProvider.SUPABASE],
        );
      }
      List<Assets> assets = realm!.all<Assets>().toList();
      for (Assets asset in assets) {
        if (asset.id == null) {
          realm!.write(() {
            realm!.delete(asset);
          });
          continue;
        }
        ProxyService.backUp.updateRecord(
          tableName: assetsTable,
          idField: "${assetsTable.singularize()}_id",
          map: asset.toEJson().toFlipperJson(),
          id: asset.id!,
          syncProviders: [SyncProvider.FIRESTORE, SyncProvider.SUPABASE],
        );
      }

      List<Variant> variants = realm!.all<Variant>().toList();
      for (Variant variant in variants) {
        if (variant.id == null) {
          realm!.write(() {
            realm!.delete(variant);
          });
          continue;
        }
        ;
        ProxyService.backUp.updateRecord(
          tableName: variantTable,
          idField: "${variantTable.singularize()}_id",
          map: variant.toEJson().toFlipperJson(),
          id: variant.id!,
          syncProviders: [SyncProvider.FIRESTORE, SyncProvider.SUPABASE],
        );
      }

      List<Stock> stocks = realm!.all<Stock>().toList();
      for (Stock stock in stocks) {
        if (stock.id == null) {
          realm!.write(() {
            realm!.delete(stock);
          });
          continue;
        }

        ProxyService.backUp.updateRecord(
          tableName: stocksTable,
          idField: "${stocksTable.singularize()}_id",
          map: stock.toEJson().toFlipperJson(),
          id: stock.id!,
          syncProviders: [SyncProvider.FIRESTORE, SyncProvider.SUPABASE],
        );
      }

      List<TransactionItem> items = realm!.all<TransactionItem>().toList();
      for (TransactionItem item in items) {
        if (item.id == null) {
          realm!.write(() {
            realm!.delete(item);
          });
          continue;
        }

        ProxyService.backUp.updateRecord(
          tableName: transactionItemsTable,
          idField: "${transactionItemsTable.singularize()}_id",
          map: item.toEJson().toFlipperJson(),
          id: item.id!,
          syncProviders: [SyncProvider.FIRESTORE, SyncProvider.SUPABASE],
        );
      }

      List<Access> accesses = realm!.all<Access>().toList();
      for (Access access in accesses) {
        if (access.id == null) {
          realm!.write(() {
            realm!.delete(access);
          });
          continue;
        }
        ProxyService.backUp.updateRecord(
          tableName: accessesTable,
          idField: "${accessesTable.singularize()}_id",
          map: access.toEJson().toFlipperJson(),
          id: access.id!,
          syncProviders: [SyncProvider.FIRESTORE, SyncProvider.SUPABASE],
        );
      }
      List<StockRequest> requests = realm!.all<StockRequest>().toList();
      for (StockRequest request in requests) {
        if (request.id == null) {
          realm!.write(() {
            realm!.delete(request);
          });
          continue;
        }
        ProxyService.backUp.updateRecord(
          tableName: stockRequestsTable,
          idField: "${stockRequestsTable.singularize()}_id",
          map: request.toEJson().toFlipperJson(),
          id: request.id!,
          syncProviders: [SyncProvider.FIRESTORE, SyncProvider.SUPABASE],
        );
      }

      /// done upserting
      ProxyService.box.writeBool(key: 'forceUPSERT', value: false);
    } catch (e, s) {
      talker.warning(e);
      talker.error(s);
    }
  }

  @override
  ReceivePort? receivePort;

  @override
  SendPort? sendPort;

  @override
  Future<void> sendMessageToIsolate() async {
    if (ProxyService.box.stopTaxService()!) return;
    Business business = realm!.query<Business>(
        r'serverId == $0', [ProxyService.box.getBusinessId()!]).first;

    sendPort!.send({
      'task': 'sync',
      'branchId': ProxyService.box.getBranchId()!,
      "URI": await ProxyService.box.getServerUrl(),
      "userId": ProxyService.box.getUserId()!,
      "businessId": ProxyService.box.getBusinessId()!,
      'encryptionKey': ProxyService.box.encryptionKey(),
      'dbPath': await ProxyService.local.dbPath(
        path: 'local',
        folder: ProxyService.box.getBusinessId(),
      ),
    });
    sendPort!.send({
      'task': 'taxService',
      'branchId': ProxyService.box.getBranchId()!,
      "URI": await ProxyService.box.getServerUrl(),
      "bhfId": await ProxyService.box.bhfId(),
      'tinNumber': business.tinNumber,
      'encryptionKey': ProxyService.box.encryptionKey(),
      'dbPath': await ProxyService.local.dbPath(
        path: 'local',
        folder: ProxyService.box.getBusinessId(),
      ),
    });
  }

  @override
  Future<void> spawnIsolate(dynamic isolateHandler) async {
    try {
      if (realm == null) return;

      if (isTaxEnabled(businessId: ProxyService.box.getBusinessId()!)) {
        // 1. Create the ReceivePort to receive messages from the isolate
        receivePort = ReceivePort();

        // 2. Spawn the isolate and pass the receivePort.sendPort to it
        // await Isolate.spawn(isolateHandler, receivePort!.sendPort);
        final rootIsolateToken = RootIsolateToken.instance!;

        await Isolate.spawn(
          isolateHandler,
          [receivePort!.sendPort, rootIsolateToken, CouchbaseLite.context],
          debugName: 'backgroundIsolate',
        );

        // 3. Retrieve the SendPort sent back by the isolate (used to send messages to the isolate)
        // sendPort = await receivePort!.first;

        receivePort!.listen(
          (message) async {
            if (message is SendPort) {
              // Store the sendPort for communication with isolate
              sendPort = message;
              print('SendPort received');
            }
            String identifier = message as String;
            List<String> separator = identifier.split(":");

            if (separator.first == "notification") {
              if (separator.length == 2) {
                /// this is error message
                ProxyService.notification
                    .sendLocalNotification(body: separator[1]);
              }
              if (separator.length < 3) return;
              if (separator[2] == "variant") {
                final variantId = int.tryParse(separator[3]);
                Variant? variant =
                    ProxyService.local.variant(variantId: variantId);
                if (variant != null) {
                  ProxyService.local.realm!.writeN(
                    tableName: variantTable,
                    writeCallback: () {
                      variant.ebmSynced = true;
                      return variant;
                    },
                    onAdd: (data) {
                      // ProxyService.backUp.replicateData(variantTable, data);
                    },
                  );
                }
                ProxyService.notification
                    .sendLocalNotification(body: "Item Saving " + separator[1]);
              }
              if (separator[2] == "stock") {
                final stockId = int.tryParse(separator[3]);
                Stock? stock = getStockById(id: stockId!);
                if (stock != null) {
                  ProxyService.local.realm!.writeN(
                    tableName: stocksTable,
                    writeCallback: () {
                      stock.ebmSynced = true;
                      return stock;
                    },
                    onAdd: (data) {
                      // ProxyService.backUp.replicateData(stocksTable, data);
                    },
                  );
                }
                ProxyService.notification.sendLocalNotification(
                    body: "Stock Saving " + separator[1]);
              }
              if (separator[2] == "customer") {
                final customerId = int.tryParse(separator[3]);
                Customer? customer = getCustomer(id: customerId);
                if (customer != null) {
                  ProxyService.local.realm!.writeN(
                    tableName: customersTable,
                    writeCallback: () {
                      customer.ebmSynced = true;
                      return customer;
                    },
                    onAdd: (data) {
                      // ProxyService.backUp.replicateData(customersTable, data);
                    },
                  );
                }
                ProxyService.notification.sendLocalNotification(
                    body: "Customer Saving " + separator[1]);
              }
              if (separator[2] == "transaction") {
                final transactionId = int.tryParse(separator[3]);
                ITransaction? transaction =
                    getTransactionById(id: transactionId!);
                if (transaction != null) {
                  ProxyService.local.realm!.writeN(
                    tableName: transactionTable,
                    writeCallback: () {
                      transaction.ebmSynced = true;
                      return transaction;
                    },
                    onAdd: (data) {
                      // ProxyService.backUp.replicateData(transactionTable, data);
                    },
                  );
                }
                ProxyService.notification.sendLocalNotification(
                    body: "Transaction Saving " + separator[1]);
              }
            }
          },
        );
      }
    } catch (error, s) {
      talker.warning('Error managing isolates: $error');
      talker.warning('Error managing isolates: $s');
    }
  }

  @override
  void reDownloadAsset() {
    try {
      final downloadQueue = DownloadQueue(3);

      int? branchId = ProxyService.box.getBranchId();
      if (ProxyService.local.realm == null || branchId == null) {
        talker.warning("realm is null");
        return;
      }

      List<Assets> assets = ProxyService.local.realm!
          .query<Assets>(r'branchId == $0', [branchId]).toList();

      for (Assets asset in assets) {
        if (asset.assetName != null) {
          downloadQueue.addToQueue(
            DownloadParams(
              branchId: branchId,
              assetName: asset.assetName!,
              subPath: "branch",
            ),
          );
        }
      }
    } catch (e, s) {
      talker.warning(e);
      talker.error(s);
    } finally {
      ProxyService.box.writeBool(key: 'doneDownloadingAsset', value: true);
    }
  }

  /// this is expensive operation call it only when we are sure that we need to do it

  @override
  void clearVariants() {
    List<Variant> variants = realm!.all<Variant>().toList();
    for (Variant variant in variants) {
      // finc stocks for the variant
      List<Stock> stocks = ProxyService.local.realm!
          .query<Stock>(r'variantId == $0', [variant.id]).toList();

      /// if variant have more than one stock delete them remain with the first one
      /// If a variant has more than one stock, it keeps the first stock and deletes all others
      if (stocks.length > 1) {
        for (int i = 1; i < stocks.length; i++) {
          realm!.write(() {
            realm!.deleteN(
                tableName: stocksTable, deleteCallback: () => stocks[i]);
          });
        }
      }
    }
  }

  @override
  Future<RealmInterface> configureCapella(
      {required bool useInMemory, required LocalStorage box}) {
    // TODO: implement configureCapella
    talker.warning("This should not be called");
    throw UnimplementedError();
  }

  @override
  Future<void> initCollections() {
    // TODO: implement initCollections
    throw UnimplementedError();
  }

  @override
  AsyncCollection? accessCollection;

  @override
  AsyncCollection? branchCollection;

  @override
  AsyncCollection? businessCollection;

  @override
  DatabaseProvider? capella;

  @override
  AsyncCollection? permissionCollection;

  @override
  Future<void> startReplicator() {
    // TODO: implement startReplicator
    throw UnimplementedError();
  }

  @override
  void updateTransactionType(
      {required ITransaction transaction,
      required bool isProformaMode,
      required bool isTrainingMode}) {
    realm!.writeN(
        tableName: transactionTable,
        writeCallback: () {
          String receiptType = TransactionReceptType.NS;
          if (isProformaMode) {
            receiptType = TransactionReceptType.PS;
          }
          if (isTrainingMode) {
            receiptType = TransactionReceptType.TS;
          }
          transaction.receiptType = receiptType;
          return transaction;
        },
        onAdd: (data) {
          // ProxyService.backUp.replicateData(transactionTable, data);
        });
  }

  @override
  Future<List<Configurations>> taxes({required int branchId}) async {
    return realm!.query<Configurations>(r'branchId == $0', [branchId]).toList();
  }

  @override
  Future<Configurations> saveTax(
      {required int configId, required double taxPercentage}) async {
    Configurations tax =
        realm!.query<Configurations>(r'id == $0', [configId]).first;
    realm!.write(() {
      tax.taxPercentage = taxPercentage;
    });
    return tax;
  }

  @override
  Future<void> updateVariant({
    required List<Variant> updatables,
    String? color,
    double? newRetailPrice,
    double? retailPrice,
    double? supplyPrice,
    Map<int, String>? dates,
    Map<int, String>? rates,
    String? selectedProductType,
  }) async {
    // loop through all variants and update all with retailPrice and supplyPrice

    for (var i = 0; i < updatables.length; i++) {
      Product? product = getProduct(id: updatables[i].productId!);
      if (updatables[i].stock == null) {
        await addStockToVariant(variant: updatables[i]);
      }
      realm!.write(() {
        product?.name = updatables[i].name;
        double rate = rates?[updatables[i].id] == null
            ? 0
            : double.parse(rates![updatables[i].id]!);
        if (color != null) {
          updatables[i].color = color;
        }

        updatables[i].itemNm = updatables[i].name;
        updatables[i].ebmSynced = false;
        updatables[i].retailPrice =
            newRetailPrice == null ? updatables[i].retailPrice : newRetailPrice;
        updatables[i].itemTyCd = selectedProductType;
        updatables[i].dcRt = rate;
        updatables[i].expirationDate = dates?[updatables[i].id] == null
            ? null
            : DateTime.tryParse(dates![updatables[i].id]!);

        if (retailPrice != 0 && retailPrice != null) {
          updatables[i].retailPrice = retailPrice;
        }
        if (supplyPrice != 0 && supplyPrice != null) {
          updatables[i].supplyPrice = supplyPrice;
        }

        updatables[i].stock?.rsdQty = (updatables[i].stock?.rsdQty ?? 0);
        updatables[i].stock?.currentStock = (updatables[i].stock?.rsdQty ?? 0);
        updatables[i].stock?.variant = updatables[i];
        updatables[i].lastTouched = DateTime.now().toLocal();
        realm!.add<Variant>(updatables[i]);
      });
    }
  }

  @override
  Future<void> processItem({
    required brick.Item item,
    required Map<String, String> quantitis,
    required Map<String, String> taxTypes,
    required Map<String, String> itemClasses,
    required Map<String, String> itemTypes,
  }) async {
    try {
      ///
      if (item.bcdU.isNotEmpty) {
        // if a user has given us the barcode updated i.e bcdU
        // then this means a user want to update exisiting data with new data given
        //1. search variant where variant.modrId == item.barCode
        // 2. update the variant set variant.bcd= item.bcdU
        //3. update the variant set variant.name= item.name
        Variant? variant =
            realm!.query<Variant>(r'modrId == $0', [item.barCode]).firstOrNull;
        if (variant != null) {
          realm!.write(() {
            variant.bcd = item.bcdU;
            variant.name = item.name;
            print('variant updated successfully');
          });
        } else {
          print('no variant found with modrId:${item.barCode}');
        }
      } else {
        final branchId = await ProxyService.box.getBranchId()!;
        final businessId = await ProxyService.box.getBusinessId()!;
        // TODO: fix this when sql is fixed.
        // final bhfId = await ProxyService.box.bhfId();
        final bhfId = "00";
        final int variantId = randomNumber();
        // Create a new product
        Product product = Product(
          ObjectId(),
          id: randomNumber(),
          name: item.name,
          barCode: item.barCode,
          branchId: branchId,
          businessId: businessId,
        );

        // Get tax type configuration
        brick.Configurations? taxType = await ProxyService.strategy
            .getByTaxType(taxtype: taxTypes[product.barCode] ?? "B");

        talker.warning(
            "ItemClass${itemClasses[product.barCode] ?? "5020230602"}");

        // Add the product to the Realm
        realm!.write(() {
          realm!.add<Product>(product);
        });

        // Create stock for the variant
        Stock stock = _createStock(
            product: product,
            branchId: branchId,
            bhfId: bhfId,
            itemQuantity: item.quantity,
            quantitis: quantitis);

        // Create variant for the product
        Variant variant = await _createVariant(
            item: item,
            product: product,
            stock: stock,
            taxType: taxType,
            branchId: branchId,
            variantId: variantId,
            taxTypes: taxTypes,
            itemClasses: itemClasses,
            itemTypes: itemTypes);

        // Add the variant to the Realm
        realm!.write(() {
          realm!.add<Variant>(variant);
        });
        // Add the stock to the Realm
        realm!.write(() {
          realm!.add<Stock>(stock);
        });
        // Update variant with stock
        realm!.write(() {
          variant.stock = stock;
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  Stock _createStock({
    required Product product,
    required int branchId,
    required String? bhfId,
    required String itemQuantity,
    required Map<String, String> quantitis,
  }) {
    final itemQuantityIsNonZero = double.tryParse(itemQuantity);
    return Stock(
      ObjectId(),
      id: randomNumber(),
      variantId: randomNumber(),
      currentStock: double.parse(quantitis[product.barCode] ?? "1"),
      lowStock: 0,
      canTrackingStock: false,
      showLowStockAlert: true,
      productId: product.id!,
      bhfId: bhfId,
      active: true,
      value: itemQuantityIsNonZero ??
          double.parse(quantitis[product.barCode] ?? "1"),
      rsdQty: itemQuantityIsNonZero ??
          double.parse(quantitis[product.barCode] ?? "1"),
      lastTouched: DateTime.now(),
      branchId: branchId,
      ebmSynced: false,
    );
  }

  Future<Variant> _createVariant({
    required brick.Item item,
    required Product product,
    required Stock stock,
    required brick.Configurations? taxType,
    required int branchId,
    required int variantId,
    required Map<String, String> taxTypes,
    required Map<String, String> itemClasses,
    required Map<String, String> itemTypes,
  }) async {
    return Variant(
      ObjectId(),
      id: variantId,
      branchIds: [branchId],
      productId: product.id!,
      sku: product.barCode,
      name: item.name,
      productName: product.name,
      stock: stock,
      retailPrice: double.parse(item.price),
      supplyPrice: double.parse(item.price),
      color: randomizeColor(),
      itemSeq: 1,
      pkg: "1",
      taxTyCd: taxTypes[product.barCode] ?? "B",
      itemClsCd: itemClasses[product.barCode] ?? "5020230602",
      spplrItemCd: "",
      spplrItemClsCd: "",
      bcd: item.barCode,
      qtyUnitCd: "U",
      regrNm: item.name,
      tin: ProxyService.box.tin(),
      bhfId: "00",
      // bhfId: (await ProxyService.box.bhfId()) ?? "00",
      isTaxExempted: false,
      itemNm: product.name,
      ebmSynced: false,
      itemStdNm: product.name,
      orgnNatCd: "RW",
      prc: double.parse(item.price),
      splyAmt: double.parse(item.price),
      itemCd: DateTime.now().generateFlipperClip(),
      modrNm: product.name,
      modrId: product.barCode,
      pkgUnitCd: "BJ",
      regrId: product.barCode,
      useYn: "N",
      itemTyCd: itemTypes[product.barCode] ?? "1",
      lastTouched: DateTime.now(),
      branchId: branchId,
      taxPercentage: taxType?.taxPercentage ?? 18,
    );
  }

  String randomizeColor() {
    return '#${(Random().nextInt(0x1000000) | 0x800000).toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }
}
