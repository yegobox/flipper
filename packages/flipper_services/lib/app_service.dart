import 'dart:async';
import 'dart:io';

import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/sync/mixins/auth_mixin.dart';
import 'package:flipper_models/sync/branch_catalog_cloud_sync.dart';
import 'package:flipper_web/core/utils/ditto_singleton.dart';
import 'package:stacked/stacked.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.dialogs.dart';
import 'package:supabase_models/sync/ditto_sync_coordinator.dart';
import 'package:supabase_models/brick/repository/local_storage.dart';
import 'locator.dart';
import 'proxy.dart';
import 'setting_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flipper_web/core/secrets.dart';
import 'package:flipper_models/ebm_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flipper_models/helperModels/business_type.dart' as helper;
import 'package:flipper_services/Miscellaneous.dart';

const socialApp = "socials";

class AppService with ListenableServiceMixin {
  /// Shared QR-login teardown started from desktop login or PIN screen.
  static Future<void>? _qrLoginTeardownInFlight;

  /// Idempotent: stop QR polling immediately, close login Ditto in background.
  Future<void> beginQrLoginTeardown() {
    _qrLoginTeardownInFlight ??= _runQrLoginTeardown();
    return _qrLoginTeardownInFlight!;
  }

  static void resetQrLoginTeardownState() {
    _qrLoginTeardownInFlight = null;
  }

  Future<void> _runQrLoginTeardown() async {
    // Stop polling/observers first — cheap and must not wait on Ditto.close().
    ProxyService.event.unsubscribeLoginEvent();
    AuthMixin.resetDittoInitializationStatic();

    try {
      await DittoSyncCoordinator.instance.setDitto(null);
      final persistenceUserId = DittoSingleton.persistenceUserId;
      final isQrIdentity = persistenceUserId?.startsWith('login-') ?? false;
      if (DittoSingleton.instance.ditto != null || isQrIdentity) {
        await DittoSingleton.instance.dispose(quick: true);
        print('Ditto QR-login singleton disposed');
      }
    } catch (e) {
      print('beginQrLoginTeardown: $e');
    }
  }

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
      return false;
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

  Future<void> setDefaultBusiness(
    Business business, {
    bool persistToSqlite = true,
  }) async {
    // Update Hive preferences first (fast, no DB locks)
    await _updateBusinessPreferences(business);

    if (persistToSqlite) {
      // Defer SQLite updates to avoid blocking UI - runs in background
      Future.delayed(Duration.zero, () async {
        await updateAllBusinessesInactive();
        await ProxyService.strategy.updateBusiness(
          businessId: business.id,
          active: true,
          isDefault: true,
        );
      });
    }

    if (ProxyService.ditto.isReady()) {
      loadFeatures();
    }
  }

  Future<void> setDefaultBranch(
    Branch branch, {
    bool registerDittoSubscriptions = true,
    bool persistToSqlite = true,
  }) async {
    // Batch all Hive writes together first (fast, no DB locks)
    await Future.wait<void>([
      ProxyService.box.writeString(key: 'branchId', value: branch.id),
      ProxyService.box.writeString(key: 'branchIdString', value: branch.id),
      ProxyService.box.writeBool(key: 'branch_switched', value: true),
      ProxyService.box.writeInt(
        key: 'last_branch_switch_timestamp',
        value: DateTime.now().millisecondsSinceEpoch,
      ),
      ProxyService.box.writeString(key: 'active_branch_id', value: branch.id),
      ProxyService.box.writeString(
        key: 'currentBusinessId',
        value: branch.businessId ?? ProxyService.box.getBusinessId()!,
      ),
      ProxyService.box.writeString(key: 'currentBranchId', value: branch.id),
    ]);

    if (registerDittoSubscriptions) {
      _registerBranchDittoSubscriptions(branchId: branch.id);
    }

    if (persistToSqlite) {
      // Defer SQLite updates to avoid blocking UI - runs in background
      Future.delayed(Duration.zero, () async {
        await updateAllBranchesInactive();
        await ProxyService.strategy.updateBranch(
          branchId: branch.id,
          active: true,
          isDefault: true,
        );
      });
    }
  }

  /// Mirrors business/branch active flags into Brick/SQLite after login choices.
  /// Login selection uses Ditto + Hive only; call once the dashboard is mounted.
  Future<void> persistBusinessBranchSelectionToSqlite() async {
    final businessId =
        ProxyService.box.getBusinessId() ??
        ProxyService.box.readString(key: 'currentBusinessId');
    final branchId = ProxyService.box.getBranchId();
    if (businessId == null || branchId == null) return;

    try {
      await updateAllBusinessesInactive();
      await ProxyService.strategy.updateBusiness(
        businessId: businessId,
        active: true,
        isDefault: true,
      );
      await updateAllBranchesInactive();
      await ProxyService.strategy.updateBranch(
        branchId: branchId,
        active: true,
        isDefault: true,
      );
    } catch (e) {
      print('⚠️ persistBusinessBranchSelectionToSqlite failed: $e');
    }
  }

  /// Finishes Ditto auth + replication after [LoginChoices] when PIN login used
  /// the fast path (`deferSyncStart`) and threw before [appInit] could run.
  Future<void> completeDittoAfterLoginChoices() async {
    final userId = ProxyService.box.getUserId();
    if (userId == null || userId.isEmpty) return;

    final appID = kDebugMode ? AppSecrets.appIdDebug : AppSecrets.appId;
    try {
      await Future(() async {
        await DittoSingleton.instance.ensureAuthenticatedAndSyncing(
          appId: appID,
        );
        final ditto = DittoSingleton.instance.ditto;
        if (ditto != null) {
          await DittoSyncCoordinator.instance.setDitto(
            ditto,
            skipInitialFetch: true,
          );
          if (!ProxyService.ditto.isReady()) {
            ProxyService.ditto.setDitto(ditto);
          }
        }
      }).timeout(const Duration(seconds: 15));
      await _attachLocalStorageDittoIfReady();
      print('✅ Ditto ready after login choices');
    } catch (e) {
      print('⚠️ completeDittoAfterLoginChoices failed: $e');
    }
  }

  /// SQLite-backed setup deferred from [LoginChoices] (shift, device, payment plan).
  Future<void> completePostLoginLocalSetup() async {
    final userId = ProxyService.box.getUserId();
    final businessId = ProxyService.box.getBusinessId();
    if (userId == null) return;

    await persistBusinessBranchSelectionToSqlite();

    if (businessId != null) {
      unawaited(
        ProxyService.strategy.getPaymentPlan(
          businessId: businessId,
          fetchOnline: true,
        ),
      );
    }

    final effectiveApp = ProxyService.box.getDefaultApp() ?? 'POS';
    if (effectiveApp == 'POS') {
      await checkAndStartShift(userId: userId);
    }

    await _saveDesktopDeviceRecordIfNeeded();
    unawaited(ProxyService.cron.setupDelegationMonitoringIfNeeded());
  }

  Future<void> _saveDesktopDeviceRecordIfNeeded() async {
    if (Platform.isAndroid || Platform.isIOS) return;

    try {
      final userId = ProxyService.box.getUserId();
      final businessId = ProxyService.box.getBusinessId();
      final branchId = ProxyService.box.getBranchId();
      final phone = ProxyService.box.getUserPhone();
      final defaultApp = ProxyService.box.getDefaultApp();

      if (userId == null || businessId == null || branchId == null) return;

      final deviceVersion = await CoreMiscellaneous.getDeviceVersionStatic();

      // Reuse this machine's own previously-persisted id, if any, so repeat
      // runs update the same Device row instead of creating a new one.
      // Upserting by id (rather than going through the userId-based lookup
      // in ProxyService.strategy.create) matters here: several desktop
      // stations can be logged in under the same userId, and that lookup
      // would otherwise collapse them into a single shared Device row,
      // causing a station to receive delegations meant for another one.
      final existingDeviceId = ProxyService.box.getThisDeviceId();
      final device = Device(
        id: existingDeviceId,
        pubNubPublished: false,
        branchId: branchId,
        businessId: businessId,
        defaultApp: defaultApp ?? 'POS',
        phone: phone ?? '',
        userId: userId,
        deviceName: Platform.operatingSystem,
        deviceVersion: deviceVersion,
      );
      await ProxyService.strategy.upsertDevice(device);
      await ProxyService.box.writeString(key: 'thisDeviceId', value: device.id);
    } catch (e) {
      print('⚠️ _saveDesktopDeviceRecordIfNeeded failed: $e');
    }
  }

  Future<void> _updateBusinessPreferences(Business business) async {
    final existingTin = ProxyService.box.readInt(key: 'tin');
    final existingBusinessId = ProxyService.box.getBusinessId();
    final existingEncryptionKey = ProxyService.box.readString(
      key: 'encryptionKey',
    );

    // Only write if values have changed to avoid unnecessary Hive writes
    final futures = <Future>[];

    if (existingBusinessId != business.id) {
      futures.add(
        ProxyService.box.writeString(key: 'businessId', value: business.id),
      );
    }

    final bhfId = await ProxyService.box.bhfId();
    if (bhfId == null) {
      futures.add(
        ProxyService.box.writeString(key: 'bhfId', value: bhfId ?? "00"),
      );
    }

    final resolvedTin = await effectiveTin(business: business);
    if (existingTin == null || (resolvedTin ?? -1) > 0) {
      final newTin = resolvedTin ?? existingTin ?? 0;
      if (existingTin != newTin) {
        futures.add(ProxyService.box.writeInt(key: 'tin', value: newTin));
      }
    }

    if (existingEncryptionKey != business.encryptionKey) {
      futures.add(
        ProxyService.box.writeString(
          key: 'encryptionKey',
          value: business.encryptionKey ?? "",
        ),
      );
    }

    if (futures.isNotEmpty) {
      await Future.wait(futures);
    }
  }

  /// Registers Ditto cloud pull subscriptions for the active branch (catalog, counters, SARs).
  void ensureBranchDittoSubscriptionsForCurrentBranch() {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null || branchId.isEmpty) return;
    _registerBranchDittoSubscriptions(branchId: branchId);
  }

  void _registerBranchDittoSubscriptions({required String branchId}) {
    final ditto = DittoSingleton.instance.ditto;
    if (ditto == null || branchId.isEmpty) return;

    unawaited(
      ensureBranchCatalogCloudSubscriptions(
        ditto: ditto,
        branchId: branchId,
        businessId: ProxyService.box.getBusinessId(),
      ),
    );
    unawaited(
      ensureBranchCounterCloudSubscription(ditto: ditto, branchId: branchId),
    );
    unawaited(
      ensureBranchSarCloudSubscription(ditto: ditto, branchId: branchId),
    );
    unawaited(
      ensureBranchDelegationCloudSubscription(ditto: ditto, branchId: branchId),
    );
    unawaited(
      ensureDailyReportFilesCloudSubscription(ditto: ditto, branchId: branchId),
    );
  }

  /// Initialize Ditto for the desktop login screen (using login code as temp ID)
  Future<void> initDittoForLogin(String tempUserId) async {
    print("Initialize Ditto for login with tempId: $tempUserId");
    resetQrLoginTeardownState();
    final appID = kDebugMode ? AppSecrets.appIdDebug : AppSecrets.appId;

    // Initialize DittoSingleton with the temporary ID
    await DittoSingleton.instance.initialize(appId: appID, userId: tempUserId);

    // QR login only needs the events collection subscription. Do not attach the
    // generated model sync coordinator to the temporary login Ditto identity.
    await DittoSyncCoordinator.instance.setDitto(null);
    print("Ditto initialized for login flow");
  }

  /// Opens Ditto for a returning session (real user id) before LoginChoices.
  ///
  /// Unlike [initDittoForLogin], this does not tear down the sync coordinator and
  /// does not start replication until [appInit] — avoids Ditto sqlite3 + Brick
  /// sqlite opening at the same time on macOS.
  Future<void> initDittoEarlyForSession(String userId) async {
    final appID = kDebugMode ? AppSecrets.appIdDebug : AppSecrets.appId;
    await DittoSingleton.instance.initialize(
      appId: appID,
      userId: userId,
      deferSyncStart: true,
    );

    final ditto = DittoSingleton.instance.ditto;
    if (ditto != null && !ProxyService.ditto.isReady()) {
      ProxyService.ditto.setDitto(ditto);
    }

    // Auth for local reads; replication starts in appInit.
    await DittoSingleton.instance.ensureAuthenticated(appId: appID);
    print('Ditto early session init complete (sync deferred)');
  }

  /// Tear down Ditto started for desktop QR login (temp identity + replication).
  /// Call when the user switches to PIN so sync does not compete with SQLite/Brick.
  Future<void> disposeQrLoginDitto() => beginQrLoginTeardown();

  Future<void> _attachLocalStorageDittoIfReady() async {
    if (!ProxyService.ditto.isReady()) return;
    final box = ProxyService.box;
    if (box is! SharedPreferenceStorage) return;
    try {
      await box.attachDittoPersistence();
    } catch (e) {
      print('⚠️ attachDittoPersistence failed: $e');
    }
  }

  Future<void> _hydrateSettingsToggles() async {
    try {
      await getIt<SettingsService>().hydrateToggleStatesFromSettings();
    } catch (e) {
      print('⚠️ hydrateToggleStatesFromSettings failed: $e');
    }
  }

  /// check the default business/branch
  /// set the env the current user is operating in.
  Future<void> appInit() async {
    print("App init");
    // Check if this is a fresh signup - always show login choices
    bool isFreshSignup = ProxyService.box.readBool(key: 'freshSignup') ?? false;
    if (isFreshSignup) {
      // Clear the flag after use (non-blocking)
      Future.microtask(
        () => ProxyService.box.writeBool(key: 'freshSignup', value: false),
      );
      throw LoginChoicesException(term: "Choose default business");
    }

    final userId = ProxyService.box.getUserId();
    if (userId == null) {
      throw Exception('User not logged in. Cannot initialize app.');
    }

    // Initialize Ditto — non-blocking: if it fails (e.g., no internet),
    // the app continues with locally cached data.
    bool dittoAvailable = false;
    try {
      final appID = kDebugMode ? AppSecrets.appIdDebug : AppSecrets.appId;
      // Hard cap the Ditto init/auth/sync sequence so no single network call can
      // consume the whole startup budget. On timeout this throws and the catch
      // below lets the app continue offline with locally cached data.
      await Future(() async {
        await DittoSingleton.instance.initialize(appId: appID, userId: userId);
        // Startup may have opened Ditto with deferSyncStart; start replication
        // here after Brick is initialized, not during LoginChoices.
        await DittoSingleton.instance
            .ensureAuthenticatedAndSyncing(appId: appID);
        await DittoSyncCoordinator.instance.setDitto(
          DittoSingleton.instance.ditto,
          skipInitialFetch: true,
        );
      }).timeout(const Duration(seconds: 15));
      dittoAvailable = DittoSingleton.instance.isReady;
      print("User id set to $userId and Ditto initialized: $dittoAvailable");

      // Safety net: ensure DittoService (used by ProxyService.ditto) has the instance
      if (dittoAvailable && !ProxyService.ditto.isReady()) {
        print("⚠️ Bridging DittoSingleton → DittoService manually");
        ProxyService.ditto.setDitto(DittoSingleton.instance.ditto!);
      }

      final branchId = ProxyService.box.getBranchId();
      if (branchId != null && dittoAvailable) {
        _registerBranchDittoSubscriptions(branchId: branchId);
        // Journal-entry posting and backfill now happen server-side in
        // data-connector (live observer + periodic sweep over completed
        // transactions). The client no longer posts or backfills entries.
      }
    } catch (e) {
      print("⚠️ Ditto initialization failed (app will continue offline): $e");
    }

    await _attachLocalStorageDittoIfReady();

    if (dittoAvailable && !Platform.isAndroid && !Platform.isIOS) {
      await _saveDesktopDeviceRecordIfNeeded();
      await ProxyService.cron.setupDelegationMonitoringIfNeeded();
    }

    // Try to get user access from Ditto if available
    Map<String, dynamic>? userAccess;
    if (dittoAvailable) {
      int retries = 0;
      while (retries < 3) {
        try {
          userAccess = await ProxyService.ditto.getUserAccess(userId);
          break;
        } catch (e) {
          print("getUserAccess failed (attempt ${retries + 1}): $e");
          retries++;
          if (retries < 3) {
            await Future.delayed(const Duration(milliseconds: 500));
          }
        }
      }
    } else {
      print(
        "⚠️ Ditto not available — using locally cached business/branch data",
      );
    }

    List<Business> businesses = [];
    List<Branch> branches = [];

    if (userAccess != null && userAccess.containsKey('businesses')) {
      final List<dynamic> businessesJson = userAccess['businesses'];
      businesses = businessesJson
          .map((json) => Business.fromMap(Map<String, dynamic>.from(json)))
          .toList();

      // If the server returned a user record but with no businesses, this user
      // account is invalid/a duplicate. Force a logout so the user can sign in
      // with the correct account (e.g., the one whose phone has a + prefix).
      if (businesses.isEmpty) {
        throw SessionException(
          term:
              'No businesses found for this user account. Please sign in again.',
        );
      }

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
    } else {
      // Fallback: use locally stored business/branch IDs
      final businessId = ProxyService.box.getBusinessId();
      final branchId = ProxyService.box.getBranchId();
      if (businessId != null && branchId != null) {
        print(
          "✅ Using locally cached businessId=$businessId, branchId=$branchId",
        );
        await _hydrateSettingsToggles();
        // Defer shift check to avoid blocking startup
        Future.delayed(Duration.zero, () async {
          await checkAndStartShift(userId: userId);
        });
        return;
      } else {
        // No local data and no Ditto — user must be online for first setup
        throw Exception(
          'No cached data available. Please connect to the internet for initial setup.',
        );
      }
    }

    bool hasMultipleBusinesses = businesses.length > 1;
    bool hasMultipleBranches = branches.length > 1;

    // Defer SQLite updates to avoid blocking startup
    // These will run in the background without blocking the UI
    if (businesses.length == 1) {
      Future.delayed(Duration.zero, () async {
        await ProxyService.strategy.updateBusiness(
          businessId: businesses.first.id,
          active: true,
          isDefault: true,
        );
      });
    }
    if (branches.length == 1) {
      Future.delayed(Duration.zero, () async {
        await ProxyService.strategy.updateBranch(
          branchId: branches.first.id,
          active: true,
          isDefault: true,
        );
      });
    }

    if ((hasMultipleBusinesses || hasMultipleBranches)) {
      throw LoginChoicesException(term: "Choose default business");
    }

    await _hydrateSettingsToggles();

    // After successful business/branch selection, defer shift check to avoid blocking
    Future.delayed(Duration.zero, () async {
      await checkAndStartShift(userId: userId);
      if (ProxyService.ditto.isReady()) {
        loadFeatures();
      }
    });
  }

  /// Returns `true` if a shift is open (or was just started), `false` if the
  /// user cancelled the start-shift dialog.
  Future<bool> checkAndStartShift({required String userId}) async {
    dynamic currentShift;
    try {
      currentShift = await ProxyService.strategy
          .getCurrentShift(userId: userId)
          .timeout(const Duration(seconds: 12));
    } on TimeoutException {
      print(
        '⚠️ getCurrentShift timed out during login; continuing without blocking',
      );
      return true;
    }
    if (currentShift == null) {
      final dialogService = locator<DialogService>();
      final response = await dialogService.showCustomDialog(
        variant: DialogType.startShift,
        title: 'Start New Shift',
      );
      if (response == null || !response.confirmed) {
        return false;
      }
      final openingBalance = response.data['openingBalance'] as double? ?? 0.0;
      final notes = response.data['notes'] as String?;
      await ProxyService.strategy.startShift(
        userId: userId,
        openingBalance: openingBalance,
        note: notes,
      );
    }
    return true;
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
    listenToReactiveValues([_categories, _business, _contacts, _features]);
  }

  Future<List<Branch>> searchSuppliers(String query) async {
    if (query.isEmpty) {
      return [];
    }

    final List<dynamic> data = await Supabase.instance.client
        .from('branches')
        .select()
        .ilike('name', '%$query%');

    return data.map<Branch>((item) => Branch.fromMap(item)).toList();
  }

  Future<List<helper.BusinessType>> getBusinessTypes() async {
    try {
      final response = await Supabase.instance.client
          .from('business_types')
          .select();
      return (response as List)
          .map(
            (e) => helper.BusinessType.fromSupabaseRow(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching business types: $e');
      }
      return helper.BusinessTypeEnum.values
          .map((e) => helper.BusinessType(id: e.id, typeName: e.typeName))
          .toList();
    }
  }

  final _features = ReactiveValue<List<String>>([]);
  List<String> get features => _features.value;

  StreamSubscription<BusinessFeature?>? _featuresSubscription;

  void loadFeatures() {
    // 1. Check if Ditto is ready
    if (!ProxyService.ditto.isReady()) {
      _features.value = [];
      return;
    }

    final businessId = ProxyService.box.getBusinessId();
    if (businessId == null) return;

    _featuresSubscription?.cancel();
    // 2. Add onError handler
    _featuresSubscription = ProxyService.ditto
        .businessFeatureStream(businessId: businessId)
        .listen(
          (feature) {
            if (feature != null) {
              _features.value = feature.features;
            } else {
              _features.value = [];
            }
          },
          onError: (error) {
            print("Error in businessFeatureStream: $error");
            _features.value = [];
            _featuresSubscription?.cancel();
          },
        );
  }
}
