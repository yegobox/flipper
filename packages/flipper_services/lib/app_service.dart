import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flipper_models/isar/random.dart';
import 'package:flipper_models/isar_models.dart' as isar;
import 'package:flipper_services/constants.dart';
import 'package:stacked/stacked.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flipper_models/isar_models.dart';
import 'proxy.dart';
import 'package:flipper_nfc/flipper_nfc.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

const socialApp = "socials";

class AppService with ListenableServiceMixin {
  // required constants
  int? get userid => ProxyService.box.getUserId();
  int? get businessId => ProxyService.box.getBusinessId();
  int? get branchId => ProxyService.box.getBranchId();

  final _categories = ReactiveValue<List<Category>>([]);
  List<Category> get categories => _categories.value;
  // TODO: make _business nullable when starting

  final _business = ReactiveValue<isar.IBusiness?>(isar.IBusiness(
    id: randomNumber(),
    isDefault: false,
    encryptionKey: "11",
    action: AppActions.created,
  ));
  isar.IBusiness? get business => _business.value;
  setBusiness({required isar.IBusiness business}) {
    _business.value = business;
  }

  final _branch = ReactiveValue<isar.IBranch?>(null);
  isar.IBranch? get branch => _branch.value;

  setActiveBranch({required isar.IBranch branch}) {
    _branch.value = branch;
  }

  void loadCategories() async {
    int? branchId = ProxyService.box.getBranchId();

    final List<Category> result =
        await ProxyService.isar.categories(branchId: branchId ?? 0);

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
      await ProxyService.isar.login(
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
    final token = await ProxyService.isar.loginOnSocial(
      password: phoneNumber,
      phoneNumberOrEmail: phoneNumber,
    );

    ProxyService.box.writeString(
        key: 'whatsAppToken', value: "Bearer ${token?.body.token}");

    final businessId = ProxyService.box.getBusinessId()!;
    final data = Token(
      id: randomNumber(),
      businessId: businessId,
      token: token?.body.token,
      validFrom: token?.body.validFrom,
      validUntil: token?.body.validUntil,
      type: socialApp,
    );

    await ProxyService.isar.create(data: data);
  }

  final _contacts = ReactiveValue<List<IBusiness>>([]);
  List<IBusiness> get contacts => _contacts.value;

  /// contact are business in other words
  Future<void> loadContacts() async {
    List<IBusiness> contacts = await ProxyService.isar.getContacts();
    _contacts.value = contacts;
  }

  /// check the default business/branch
  /// set the env the current user is operating in.
  Future<void> appInit() async {
    int? userId = ProxyService.box.getUserId();

    if (userId == null) return;

    List<isar.IBusiness> businesses = await ProxyService.isar.businesses();

    if (businesses.isEmpty) {
      try {
        IBusiness business =
            await ProxyService.isar.getOnlineBusiness(userId: userId);
        businesses.add(business);
      } catch (e) {
        rethrow;
      }
    }

    await loadTenants(businesses);

    List<isar.IBranch> branches = await ProxyService.isar.branches();

    bool authComplete = await ProxyService.box.authComplete();

    if ((businesses.length > 1 || branches.length > 1) &&
        !Platform.isWindows &&
        !authComplete) {
      throw LoginChoicesException(term: "Choose default business");
    } else {
      /// we have one business and one branch so we can set default tin and bhfid to be used during this session
      ProxyService.box
          .writeString(key: 'bhfId', value: businesses.first.bhfId ?? "");
      ProxyService.box
          .writeInt(key: 'tin', value: businesses.first.tinNumber ?? 0);
    }
  }

  Future<void> loadTenants(List<IBusiness> businesses) async {
    bool authComplete = await ProxyService.box.authComplete();
    // Check for internet connectivity
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none || authComplete) {
      // No internet connection, handle accordingly (e.g., show an error message)
      print('No internet connection or no need to reaload tenants again');
      return;
    }

    // Iterate over businesses and perform the operations
    for (IBusiness business in businesses) {
      await ProxyService.isar.tenantsFromOnline(businessId: business.id!);
    }

    for (IBusiness business in businesses) {
      await ProxyService.isar.loadCounterFromOnline(businessId: business.id!);
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
      return await ProxyService.isar
          .isTokenValid(businessId: businessId, tokenType: socialApp);
    }

    /// should return true if the app is not 2 by default this is because otherwise it will keep pinging the server to log in
    return true;
  }
}
