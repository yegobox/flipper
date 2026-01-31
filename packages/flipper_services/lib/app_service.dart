import 'dart:async';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_web/core/utils/ditto_singleton.dart';
import 'package:stacked/stacked.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.dialogs.dart';
import 'package:supabase_models/sync/ditto_sync_coordinator.dart';
import 'proxy.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flipper_web/core/secrets.dart';
import 'package:flipper_models/ebm_helper.dart';

const socialApp = "socials";

class AppService with ListenableServiceMixin {
  // required constants
  String? get userid => ProxyService.box.getUserId();
  String? get businessId => ProxyService.box.getBusinessId();
  String? get branchId => ProxyService.box.getBranchId();

  final _business = ReactiveValue<Business>(
    Business(
      serverId: randomNumber(),
      phoneNumber: "",
      isDefault: false,
      encryptionKey: "11",
    ),
  );
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

  final _categories = ReactiveValue<List<Category>>(
    List<Category>.empty(growable: true),
  );
  List<Category> get categories => _categories.value;

  StreamSubscription<List<Category>>? _categorySubscription;
  void loadCategories() {
    String? branchId = ProxyService.box.getBranchId();
    if (branchId == null) return;

    _categorySubscription?.cancel();
    _categorySubscription = ProxyService.strategy
        .categoryStream(branchId: branchId)
        .listen((result) {
          _categories.value = result;
          notifyListeners();
        });
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
      key: 'whatsAppToken',
      value: "Bearer ${token?.body.token}",
    );

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
    final businessId = ProxyService.box.getBusinessId();
    if (businessId == null) return;

    final userId = ProxyService.box.getUserId();
    final userAccess = await ProxyService.ditto.getUserAccess(userId!);

    if (userAccess != null && userAccess.containsKey('businesses')) {
      final List<dynamic> businessesJson = userAccess['businesses'];
      final businessJson = businessesJson.firstWhere(
        (b) => b['id'] == businessId,
        orElse: () => null,
      );

      if (businessJson != null && businessJson.containsKey('branches')) {
        final List<dynamic> branchesJson = businessJson['branches'];
        for (var branchJson in branchesJson) {
          await ProxyService.strategy.updateBranch(
            branchId: branchJson['id'],
            active: false,
            isDefault: false,
          );
        }
      }
    }
  }

  Future<void> updateAllBusinessesInactive() async {
    final userId = ProxyService.box.getUserId();
    if (userId == null) return;

    final userAccess = await ProxyService.ditto.getUserAccess(userId);

    if (userAccess != null && userAccess.containsKey('businesses')) {
      final List<dynamic> businessesJson = userAccess['businesses'];
      for (var businessJson in businessesJson) {
        await ProxyService.strategy.updateBusiness(
          businessId: businessJson['id'],
          active: false,
          isDefault: false,
        );
      }
    }
  }

  Future<void> setDefaultBusiness(Business business) async {
    await updateAllBusinessesInactive();
    await ProxyService.strategy.updateBusiness(
      businessId: business.id,
      active: true,
      isDefault: true,
    );
    await _updateBusinessPreferences(business);
  }

  Future<void> setDefaultBranch(Branch branch) async {
    await updateAllBranchesInactive();
    await ProxyService.strategy.updateBranch(
      branchId: branch.id,
      active: true,
      isDefault: true,
    );
    await ProxyService.box.writeString(key: 'branchId', value: branch.id);
    await ProxyService.box.writeString(key: 'branchIdString', value: branch.id);
    await ProxyService.box.writeBool(key: 'branch_switched', value: true);
    await ProxyService.box.writeInt(
      key: 'last_branch_switch_timestamp',
      value: DateTime.now().millisecondsSinceEpoch,
    );
    await ProxyService.box.writeString(
      key: 'active_branch_id',
      value: branch.id,
    );
    await ProxyService.box.writeString(
      key: 'currentBusinessId',
      value: branch.businessId ?? ProxyService.box.getBusinessId()!,
    );
    await ProxyService.box.writeString(
      key: 'currentBranchId',
      value: branch.id,
    );
  }

  Future<void> _updateBusinessPreferences(Business business) async {
    final existingTin = ProxyService.box.readInt(key: 'tin');
    final futures = <Future>[];

    futures.add(
      ProxyService.box.writeString(key: 'businessId', value: business.id),
    );
    futures.add(
      ProxyService.box.writeString(
        key: 'bhfId',
        value: (await ProxyService.box.bhfId()) ?? "00",
      ),
    );

    final resolvedTin = await effectiveTin(business: business);
    if (existingTin == null || (resolvedTin ?? -1) > 0) {
      futures.add(
        ProxyService.box.writeInt(
          key: 'tin',
          value: resolvedTin ?? existingTin ?? 0,
        ),
      );
    }

    futures.add(
      ProxyService.box.writeString(
        key: 'encryptionKey',
        value: business.encryptionKey ?? "",
      ),
    );

    await Future.wait(futures);
  }

  /// Initialize Ditto for the desktop login screen (using login code as temp ID)
  Future<void> initDittoForLogin(String tempUserId) async {
    print("Initialize Ditto for login with tempId: $tempUserId");
    final appID = kDebugMode ? AppSecrets.appIdDebug : AppSecrets.appId;

    // Initialize DittoSingleton with the temporary ID
    await DittoSingleton.instance.initialize(appId: appID, userId: tempUserId);

    // Set it in the coordinator
    DittoSyncCoordinator.instance.setDitto(
      DittoSingleton.instance.ditto,
      skipInitialFetch: true,
    );
    print("Ditto initialized for login flow");
  }

  /// check the default business/branch
  /// set the env the current user is operating in.
  Future<void> appInit() async {
    print("App init");
    // Check if this is a fresh signup - always show login choices
    bool isFreshSignup = ProxyService.box.readBool(key: 'freshSignup') ?? false;
    if (isFreshSignup) {
      // Clear the flag after use
      ProxyService.box.writeBool(key: 'freshSignup', value: false);
      throw LoginChoicesException(term: "Choose default business");
    }

    final userId = ProxyService.box.getUserId();
    if (userId == null) {
      throw Exception('User not logged in. Cannot initialize app.');
    }

    // Initialize Ditto with the authenticated user ID
    final appID = kDebugMode ? AppSecrets.appIdDebug : AppSecrets.appId;

    await DittoSingleton.instance.initialize(appId: appID, userId: userId);
    DittoSyncCoordinator.instance.setDitto(
      DittoSingleton.instance.ditto,
      skipInitialFetch:
          true, // Skip initial fetch to prevent upserting all models on startup
    );
    print("User id set to ${userId} and Ditto initialized");

    final userAccess = await ProxyService.ditto.getUserAccess(userId);
    List<Business> businesses = [];
    List<Branch> branches = [];

    if (userAccess != null && userAccess.containsKey('businesses')) {
      final List<dynamic> businessesJson = userAccess['businesses'];
      businesses = businessesJson
          .map((json) => Business.fromMap(Map<String, dynamic>.from(json)))
          .toList();

      final businessId = ProxyService.box.getBusinessId();
      if (businessId != null) {
        final businessJson = businessesJson.firstWhere(
          (b) => b['id'] == businessId,
          orElse: () => null,
        );

        if (businessJson != null && businessJson.containsKey('branches')) {
          final List<dynamic> branchesJson = businessJson['branches'];
          branches = branchesJson
              .map((json) => Branch.fromMap(Map<String, dynamic>.from(json)))
              .toList();
        }
      }
    }

    bool hasMultipleBusinesses = businesses.length > 1;
    bool hasMultipleBranches = branches.length > 1;

    if (businesses.length == 1) {
      // set it as default
      await ProxyService.strategy.updateBusiness(
        businessId: businesses.first.id,
        active: true,
        isDefault: true,
      );
    }
    if (branches.length == 1) {
      // set it as default directly
      await ProxyService.strategy.updateBranch(
        branchId: branches.first.id,
        active: true,
        isDefault: true,
      );
    }

    if ((hasMultipleBusinesses || hasMultipleBranches)) {
      throw LoginChoicesException(term: "Choose default business");
    }

    // After successful business/branch selection, check for active shift

    if (userId != null) {
      await checkAndStartShift(userId: userId);
    } else {
      // User ID is null, this should ideally not happen at this stage
      throw Exception('User not logged in. Cannot start shift.');
    }
  }

  Future<void> checkAndStartShift({required String userId}) async {
    final currentShift = await ProxyService.strategy.getCurrentShift(
      userId: userId,
    );
    if (currentShift == null) {
      // No active shift, show dialog to start one
      final dialogService = locator<DialogService>();
      final response = await dialogService.showCustomDialog(
        variant: DialogType.startShift,
        title: 'Start New Shift',
      );
      if (response == null || !response.confirmed) {
        // User cancelled starting shift, prevent proceeding
        throw Exception('Shift not started. Please start a shift to proceed.');
      } else {
        // Start the shift now that we have confirmation and data
        final openingBalance =
            response.data['openingBalance'] as double? ?? 0.0;
        final notes = response.data['notes'] as String?;
        await ProxyService.strategy.startShift(
          userId: userId,
          openingBalance: openingBalance,
          note: notes,
        );
      }
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
      // String businessId = ProxyService.box.getBusinessId()!;
      // return await ProxyService.strategy
      //     .isTokenValid(businessId: businessId, tokenType: socialApp);
    }

    /// should return true if the app is not 2 by default this is because otherwise it will keep pinging the server to log in
    return true;
  }
}
