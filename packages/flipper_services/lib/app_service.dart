import 'dart:async';
import 'dart:developer';

import 'package:flipper_models/isar/random.dart';
import 'package:flipper_models/isar_models.dart' as isar;
import 'package:flipper_services/constants.dart';
import 'package:stacked/stacked.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flipper_models/isar_models.dart';
import 'proxy.dart';
import 'package:flipper_nfc/flipper_nfc.dart';
import 'package:firebase_auth/firebase_auth.dart';

const socialApp = "socials";

class AppService with ListenableServiceMixin {
  // required constants
  int? get userid => ProxyService.box.getUserId();
  int? get businessId => ProxyService.box.getBusinessId();
  int? get branchId => ProxyService.box.getBranchId();

  final _categories = ReactiveValue<List<Category>>([]);
  List<Category> get categories => _categories.value;

  final _business = ReactiveValue<isar.Business>(isar.Business(
    id: randomNumber(),
    isDefault: false,
    action: AppActions.create,
  ));
  isar.Business get business => _business.value;
  setBusiness({required isar.Business business}) {
    _business.value = business;
  }

  final _tenant = ReactiveValue<isar.ITenant?>(null);
  isar.ITenant? get tenant => _tenant.value;

  setTenant({required isar.ITenant tenant}) {
    _tenant.value = tenant;
  }

  final _units = ReactiveValue<List<IUnit>>([]);
  List<IUnit> get units => _units.value;

  final _colors = ReactiveValue<List<PColor>>([]);
  List<PColor> get colors => _colors.value;

  final _currentColor = ReactiveValue<String>('#0984e3');
  String get currentColor => _currentColor.value;

  final _customer = ReactiveValue<Customer?>(null);
  Customer? get customer => _customer.value;
  void setCustomer(Customer? customer) {
    _customer.value = customer;
  }

  setCurrentColor({required String color}) {
    _currentColor.value = color;
  }

  void loadCategories() async {
    int? branchId = ProxyService.box.getBranchId();

    final List<Category> result =
        await ProxyService.isar.categories(branchId: branchId ?? 0);

    _categories.value = result;
    notifyListeners();
  }

  Future<void> loadUnits() async {
    int? branchId = ProxyService.box.getBranchId();
    final List<IUnit> result =
        await ProxyService.isar.units(branchId: branchId!);

    _units.value = result;
  }

  Future<void> loadColors() async {
    int? branchId = ProxyService.box.getBranchId();

    List<PColor> result = await ProxyService.isar.colors(branchId: branchId!);
    _colors.value = result;

    for (PColor color in result) {
      if (color.active) {
        setCurrentColor(color: color.name!);
      }
    }
  }

  /// we fist log in to the business portal
  /// before we log to other apps as the business portal
  /// is the mother of all apps
  Future<bool> isLoggedIn() async {
    User? user = FirebaseAuth.instance.currentUser;
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

    final socialBearerToken = "Bearer " + token.body.token;
    ProxyService.box.write(key: 'whatsAppToken', value: socialBearerToken);

    final businessId = ProxyService.box.getBusinessId()!;
    final data = Token(
      businessId: businessId,
      token: token.body.token,
      validFrom: token.body.validFrom,
      validUntil: token.body.validUntil,
      type: socialApp,
    );

    await ProxyService.isar.create(data: data);
  }

  final _contacts = ReactiveValue<List<Business>>([]);
  List<Business> get contacts => _contacts.value;

  /// contact are business in other words
  Future<void> loadContacts() async {
    Stream<List<Business>> contacts =
        ProxyService.isar.contacts().asBroadcastStream();
    contacts.listen((event) {
      _contacts.value = event;
    });
  }

  /// check the default business/branch
  /// set the env the current user is operating in.

  Future<void> appInit() async {
    int? userId = ProxyService.box.getUserId();
    if (userId == null) return;
    List<isar.Business> businesses =
        await ProxyService.isar.businesses(userId: userId);
    if (businesses.isEmpty) {
      try {
        Business b = await ProxyService.isar.getOnlineBusiness(userId: userId);
        businesses.add(b);
      } catch (e) {
        rethrow;
      }
    }
    if (businesses.length == 1) {
      await setActiveBusiness(businesses);
      await loadTenants(businesses);
      await loadCounters(businesses.first);

      ProxyService.box.write(key: 'businessId', value: businesses.first.id);
      bool defaultBranch = await setActiveBranch(businesses: businesses.first);

      if (!defaultBranch) {
        throw LoginChoicesException(term: "choose default branch");
      }
    } else {
      //we have more than one business check if there one set to be default then
      // do not throw the error
      bool defaultBusiness = false;
      for (Business business in businesses) {
        if (business.isDefault != null && business.isDefault == true) {
          ProxyService.box.write(key: 'businessId', value: business.id);
          await setActiveBusiness(businesses);
          await loadTenants(businesses);
          await loadCounters(businesses.first);
          defaultBusiness = true;
        }
      }
      if (!defaultBusiness) {
        throw LoginChoicesException(term: "Choose default business");
      }
    }
  }

  Future<void> loadTenants(List<isar.Business> businesses) async {
    List<ITenant> tenants = await ProxyService.isar
        .tenants(businessId: ProxyService.box.getBusinessId()!);
    if (tenants.isEmpty) {
      await ProxyService.isar
          .tenantsFromOnline(businessId: businesses.first.id);
    }
  }

  Future<bool> setActiveBranch({required isar.Business businesses}) async {
    List<isar.Branch> branches =
        await ProxyService.isar.branches(businessId: businesses.id);

    bool defaultBranch = false;
    for (Branch branch in branches) {
      if (branch.isDefault) {
        defaultBranch = true;
        ProxyService.box.write(key: 'branchId', value: branch.id);
      }
    }
    if (branches.length == 1) {
      defaultBranch = true;
      ProxyService.box.write(key: 'branchId', value: branches.first.id);
    }
    return defaultBranch;
  }

  Future<void> setActiveBusiness(List<isar.Business> businesses) async {
    ProxyService.app.setBusiness(business: businesses.first);

    ProxyService.box.write(key: 'businessId', value: businesses.first.id);
  }

  Future<void> loadCounters(isar.Business business) async {
    if (await ProxyService.isar.size(object: Counter(id: randomString())) ==
        0) {
      await ProxyService.isar.loadCounterFromOnline(businessId: business.id);
    }
  }

  NFCManager nfc = NFCManager();
  static final StreamController<String> cleanedDataController =
      StreamController<String>.broadcast();
  static Stream<String> get cleanedData => cleanedDataController.stream;

  Stream<bool> checkInternetConnectivity() async* {
    final Connectivity connectivity = Connectivity();
    yield await connectivity.checkConnectivity() != ConnectivityResult.none;

    await for (ConnectivityResult result
        in connectivity.onConnectivityChanged) {
      yield result != ConnectivityResult.none;
    }
  }

  AppService() {
    listenToReactiveValues(
        [_categories, _units, _colors, _currentColor, _business, _contacts]);
  }

  Future<bool> isSocialLoggedin() async {
    if (ProxyService.box.getDefaultApp() == 2) {
      int businessId = ProxyService.box.getBusinessId()!;
      return await ProxyService.isar
          .isTokenValid(businessId: businessId, tokenType: socialApp);
    }

    /// should return true if the app is not 2 by default this is because otherwise it will keep pinging the server to log in
    return true;
  }
}
