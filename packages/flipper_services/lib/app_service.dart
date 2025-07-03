import 'dart:async';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:stacked/stacked.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.dialogs.dart';
import 'proxy.dart';
// import 'package:flipper_nfc/flipper_nfc.dart';
import 'package:package_info_plus/package_info_plus.dart';

const socialApp = "socials";

class AppService with ListenableServiceMixin {
  // required constants
  int? get userid => ProxyService.box.getUserId();
  int? get businessId => ProxyService.box.getBusinessId();
  int? get branchId => ProxyService.box.getBranchId();

  final _business = ReactiveValue<Business>(Business(
    serverId: randomNumber(),
    isDefault: false,
    encryptionKey: "11",
  ));
  Business get business => _business.value;
  setBusiness({required Business business}) {
    _business.value = business;
  }

  Future<String> version() async {
    final packageInfo = await PackageInfo.fromPlatform();
    print("ExpectedVersion${packageInfo.version}+${packageInfo.buildNumber}");

    return "${packageInfo.version}+${packageInfo.buildNumber}";
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
        await ProxyService.strategy.categories(branchId: branchId ?? 0);

    _categories.value = result;
    notifyListeners();
  }

  /// we fist log in to the business portal
  /// before we log to other apps as the business portal
  /// is the mother of all apps
  ///
  Future<bool> isLoggedIn() async {
    if (ProxyService.box.getUserId() == null) {
      throw Exception("Not logged in User is null");
    }
    return true;
  }

  Future<void> logSocial() async {
    final phoneNumber = ProxyService.box.getUserPhone()!.replaceFirst("+", "");
    final token = await ProxyService.strategy.loginOnSocial(
      password: phoneNumber,
      phoneNumberOrEmail: phoneNumber,
    );

    ProxyService.box.writeString(
        key: 'whatsAppToken', value: "Bearer ${token?.body.token}");

    final businessId = ProxyService.box.getBusinessId()!;
    final data = Token(
      businessId: businessId,
      token: token?.body.token,
      validFrom: token?.body.validFrom,
      validUntil: token?.body.validUntil,
      type: socialApp,
    );

    await ProxyService.strategy.create(data: data);
  }

  final _contacts = ReactiveValue<List<Business>>([]);
  List<Business> get contacts => _contacts.value;

  /// contact are business in other words
  Future<void> loadContacts() async {
    List<Business> contacts = await ProxyService.strategy.getContacts();
    _contacts.value = contacts;
  }

  Future<void> updateAllBranchesInactive() async {
    final branches = await ProxyService.strategy.branches(
      businessId: ProxyService.box.getBusinessId()!,
      active: true,
    );
    for (final branch in branches) {
      await ProxyService.strategy.updateBranch(
          branchId: branch.serverId!, active: false, isDefault: false);
    }
  }

  /// check the default business/branch
  /// set the env the current user is operating in.
  Future<void> appInit() async {
    List<Business> businesses = await ProxyService.strategy
        .businesses(userId: ProxyService.box.getUserId()!, active: true);

    List<Branch> branches = await ProxyService.strategy.branches(
      businessId: ProxyService.box.getBusinessId()!,
      active: true,
    );

    bool hasMultipleBusinesses = businesses.length > 1;
    bool hasMultipleBranches = branches.length > 1;

    if (businesses.length == 1) {
      // set it as default
      await ProxyService.strategy.updateBusiness(
        businessId: businesses.first.serverId,
        active: true,
        isDefault: true,
      );
    }
    if (branches.length == 1) {
      // set it as default directly
      await ProxyService.strategy.updateBranch(
          branchId: branches.first.serverId!, active: true, isDefault: true);
    }

    if ((hasMultipleBusinesses || hasMultipleBranches)) {
      throw LoginChoicesException(term: "Choose default business");
    }

    // After successful business/branch selection, check for active shift
    final userId = ProxyService.box.getUserId();
    if (userId != null) {
      final currentShift = await ProxyService.strategy.getCurrentShift(userId: userId);
      if (currentShift == null) {
        // No active shift, show dialog to start one
        final dialogService = locator<DialogService>();
        final response = await dialogService.showCustomDialog(
          variant: DialogType.startShift,
          title: 'Start New Shift',
        );
        if (response?.confirmed != true) {
          // User cancelled starting shift, prevent proceeding
          throw Exception('Shift not started. Please start a shift to proceed.');
        }
      }
    } else {
      // User ID is null, this should ideally not happen at this stage
      throw Exception('User not logged in. Cannot start shift.');
    }
  }

  // NFCManager nfc = NFCManager();
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
      // int businessId = ProxyService.box.getBusinessId()!;
      // return await ProxyService.strategy
      //     .isTokenValid(businessId: businessId, tokenType: socialApp);
    }

    /// should return true if the app is not 2 by default this is because otherwise it will keep pinging the server to log in
    return true;
  }
}
