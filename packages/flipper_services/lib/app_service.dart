import 'dart:async';
import 'dart:developer';
import 'package:flipper_models/helperModels/random.dart';
import 'package:realm/realm.dart';
import 'package:stacked/stacked.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'proxy.dart';
import 'package:flipper_nfc/flipper_nfc.dart';

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
        await ProxyService.local.categories(branchId: branchId ?? 0);

    _categories.value = result;
    notifyListeners();
  }

  /// we fist log in to the business portal
  /// before we log to other apps as the business portal
  /// is the mother of all apps
  ///
  Future<bool> isLoggedIn() async {
    if (ProxyService.box.getUserId() == null ||
        ProxyService.box.getBranchId() == null ||
        ProxyService.box.getBusinessId() == null) {
      throw Exception();
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
    final token = await ProxyService.local.loginOnSocial(
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

    await ProxyService.local.create(data: data);
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
    List<Business> businesses = await ProxyService.local.businesses();

    List<Branch> branches = await ProxyService.local.branches(
        businessId: ProxyService.box.getBusinessId()!, includeSelf: true);

    bool hasMultipleBusinesses = businesses.length > 1;
    bool hasMultipleBranches = branches.length > 1;

    if ((hasMultipleBusinesses || hasMultipleBranches)) {
      throw LoginChoicesException(term: "Choose default business");
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
      return await ProxyService.local
          .isTokenValid(businessId: businessId, tokenType: socialApp);
    }

    /// should return true if the app is not 2 by default this is because otherwise it will keep pinging the server to log in
    return true;
  }
}
