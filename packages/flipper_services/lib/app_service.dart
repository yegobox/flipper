import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_services/constants.dart';
import 'package:realm/realm.dart';
import 'package:stacked/stacked.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'proxy.dart';
import 'package:flipper_nfc/flipper_nfc.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

const socialApp = "socials";

class AppService with ListenableServiceMixin {
  // required constants
  int? get userid => ProxyService.box.getUserId();
  int? get businessId => ProxyService.box.getBusinessId();
  int? get branchId => ProxyService.box.getBranchId();

  // TODO: make _business nullable when starting

  final _business = ReactiveValue<Business>(Business(
    ObjectId(),
    serverId: randomNumber(),
    isDefault: false,
    encryptionKey: "11",
    action: AppActions.created,
  ));
  Business get business => _business.value;
  setBusiness({required Business business}) {
    _business.value = business;
  }

  final _branch = ReactiveValue<Branch?>(null);
  Branch? get branch => _branch.value;

  setActiveBranch({required Branch branch}) {
    _branch.value = branch;
  }

  final _categories =
      ReactiveValue<List<Category>>(List<Category>.empty(growable: true));
  List<Category> get categories => _categories.value;

  void loadCategories() async {
    int? branchId = ProxyService.box.getBranchId();

    final List<Category> result =
        await ProxyService.realm.categories(branchId: branchId ?? 0);

    _categories.value = result;
    notifyListeners();
  }

  /// we fist log in to the business portal
  /// before we log to other apps as the business portal
  /// is the mother of all apps
  ///
  Future<bool> isLoggedIn() async {
    firebase.User? user = firebase.FirebaseAuth.instance.currentUser;
    int? businessId = ProxyService.box.getBusinessId();

    if (ProxyService.box.getUserId() == null &&
        user != null &&
        businessId == null) {
      await ProxyService.local.login(
          userPhone: user.phoneNumber ?? user.email!,
          skipDefaultAppSetup: false);
    }

    bool value = await isSocialLoggedin();

    if (!value) {
      log("should not come here more often", name: "isLoggedIn()");
      await logSocial();
    }
    return ProxyService.box.getUserId() != null &&
        ProxyService.box.getBusinessId() != null;
  }

  Future<void> logSocial() async {
    final phoneNumber = ProxyService.box.getUserPhone()!.replaceFirst("+", "");
    final token = await ProxyService.realm.loginOnSocial(
      password: phoneNumber,
      phoneNumberOrEmail: phoneNumber,
    );

    ProxyService.box.writeString(
        key: 'whatsAppToken', value: "Bearer ${token?.body.token}");

    final businessId = ProxyService.box.getBusinessId()!;
    final data = Token(
      ObjectId(),
      id: randomNumber(),
      businessId: businessId,
      token: token?.body.token,
      validFrom: token?.body.validFrom,
      validUntil: token?.body.validUntil,
      type: socialApp,
    );

    await ProxyService.realm.create(data: data);
  }

  final _contacts = ReactiveValue<List<Business>>([]);
  List<Business> get contacts => _contacts.value;

  /// contact are business in other words
  Future<void> loadContacts() async {
    List<Business> contacts = await ProxyService.local.getContacts();
    _contacts.value = contacts;
  }

  /// check the default business/branch
  /// set the env the current user is operating in.
  Future<void> appInit() async {
    int? userId = ProxyService.box.getUserId();

    if (userId == null) return;

    List<Business> businesses = await ProxyService.local
        .businesses(userId: ProxyService.box.getUserId()!);

    if (businesses.isEmpty) {
      try {
        Business business =
            await ProxyService.local.getOnlineBusiness(userId: userId);
        businesses.add(business);
      } catch (e) {
        rethrow;
      }
    }

    await loadTenants(businesses);

    List<Branch> branches = await ProxyService.local
        .branches(businessId: ProxyService.box.getBusinessId());

    bool authComplete = await ProxyService.box.authComplete();

    if ((businesses.length > 1 || branches.length > 1) &&
        !Platform.isWindows &&
        !authComplete) {
      throw LoginChoicesException(term: "Choose default business");
    } else {
      /// we have one business and one branch so we can set default tin and bhfid to be used during this session
      // ProxyService.box
      //     .writeString(key: 'bhfId', value: businesses.first.bhfId ?? "00");
      ProxyService.box
          .writeInt(key: 'tin', value: businesses.first.tinNumber ?? 0);
    }
  }

  Future<void> loadTenants(List<Business> businesses) async {
    bool authComplete = await ProxyService.box.authComplete();
    // Check for internet connectivity
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none || authComplete) {
      // No internet connection, handle accordingly (e.g., show an error message)
      print('No internet connection or no need to reaload tenants again');
      return;
    }

    // Iterate over businesses and perform the operations
    for (Business business in businesses) {
      Tenant? tenant =
          await ProxyService.realm.tenant(businessId: business.serverId!);
      if (tenant == null) {
        await ProxyService.local
            .tenantsFromOnline(businessId: business.serverId!);
      }
    }
  }

  NFCManager nfc = NFCManager();
  static final StreamController<String> cleanedDataController =
      StreamController<String>.broadcast();
  static Stream<String> get cleanedData => cleanedDataController.stream;

  Stream<bool> checkInternetConnectivity() async* {
    final Connectivity connectivity = Connectivity();
    yield await connectivity.checkConnectivity() != ConnectivityResult.none;

    await for (List<ConnectivityResult> result
        in connectivity.onConnectivityChanged) {
      yield result != ConnectivityResult.none;
    }
  }

  AppService() {
    listenToReactiveValues([_categories, _business, _contacts]);
  }

  Future<bool> isSocialLoggedin() async {
    if (ProxyService.box.getDefaultApp() == "2") {
      int businessId = ProxyService.box.getBusinessId()!;
      return await ProxyService.realm
          .isTokenValid(businessId: businessId, tokenType: socialApp);
    }

    /// should return true if the app is not 2 by default this is because otherwise it will keep pinging the server to log in
    return true;
  }
}
