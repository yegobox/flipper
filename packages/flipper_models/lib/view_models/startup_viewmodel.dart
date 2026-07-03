import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flipper_services/ebm_sync_service.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:supabase_models/brick/repository.dart';
import 'package:flipper_models/AppInitializer.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/services/payment_verification_navigator.dart';
import 'package:flipper_models/services/payment_verification_service.dart';
import 'package:flipper_models/services/internet_connection_service.dart';
import 'package:flipper_services/Miscellaneous.dart';
import 'package:flipper_services/locator.dart' as loc;
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/asset_sync_service.dart';
import 'package:flipper_services/receipt_sync_service.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends FlipperBaseModel with CoreMiscellaneous {
  StartupViewModel() {
    debugPrint('🚀 [StartupViewModel] constructor called');
  }
  final appService = loc.getIt<AppService>();
  bool isBusinessSet = false;
  final _routerService = locator<RouterService>();

  Future<void> listenToAuthChange() async {}

  // Payment verification service instance
  final _paymentVerificationService = PaymentVerificationService();

  // Internet connection service instance
  final _internetConnectionService = InternetConnectionService();

  // Track last user activity to avoid interrupting active users
  DateTime? _lastUserActivity;
  static const Duration _userActivityThreshold = Duration(minutes: 5);
  bool _isInitialStartup = true;
  bool _hasRetriedAfterTimeout = false;
  double _progress = 0.0;
  double get progress => _progress;

  Future<void> runStartupLogic() async {
    // await logOut();
    try {
      debugPrint('🚀 [StartupViewModel] Starting runStartupLogic...');
      _progress = 0.0;
      notifyListeners();
      final startTime = DateTime.now();

      final forceLogout = ProxyService.box.getForceLogout();
      if (forceLogout) {
        talker.warning('Force logout detected - logging out user');
        // Reset the force logout flag to prevent repeated logouts
        await ProxyService.box.setForceLogout(false);
        await logOut();
        _routerService.navigateTo(LoginRoute());
        return;
      }
      talker.warning("StartupViewModel runStartupLogic");
      // ------------------------------------------------------

      // Initialize Ditto early if user is logged in
      // This ensures Ditto is available for LoginChoices screen to fetch businesses
      final userId = ProxyService.box.getUserId();
      if (userId == null) {
        debugPrint(
          '🚀 [StartupViewModel] No user in local storage; showing login',
        );
        _routerService.clearStackAndShow(LoginRoute());
        return;
      }

      try {
        debugPrint(
          '🚀 [StartupViewModel] Initializing Ditto early for userId: $userId',
        );
        final earlyInit = userId.startsWith('login-')
            ? appService.initDittoForLogin(userId)
            : appService.initDittoEarlyForSession(userId);
        await earlyInit.timeout(const Duration(seconds: 10));
        debugPrint('🚀 [StartupViewModel] Ditto initialized early');
      } catch (e) {
        debugPrint(
          '⚠️ [StartupViewModel] Failed to initialize Ditto early (will continue): $e',
        );
      }
      _progress = 0.2;
      notifyListeners();

      debugPrint('🚀 [StartupViewModel] Checking requirements...');
      await _requirementsMeetsWithRetry();
      debugPrint('🚀 [StartupViewModel] Requirements met');
      _progress = 0.4;
      notifyListeners();

      debugPrint('🚀 [StartupViewModel] Initializing app components...');
      AppInitializer.initialize();

      final repository = Repository();
      EbmSyncService(repository);

      AssetSyncService().initialize();
      ReceiptSyncService().initialize();

      ProxyService.strategy.cleanDuplicatePlans();
      debugPrint('🚀 [StartupViewModel] App components initialized');
      _progress = 0.6;
      notifyListeners();

      _paymentVerificationService.setPaymentStatusChangeCallback((response) {
        unawaited(_handlePaymentStatusChange(response));
      });
      _paymentVerificationService.startPeriodicVerification(
        intervalMinutes: kDebugMode ? 20 : 240,
      );

      _internetConnectionService.startPeriodicConnectionCheck();

      debugPrint('🚀 [StartupViewModel] Running appService.appInit()...');
      await appService.appInit().timeout(const Duration(seconds: 30));
      debugPrint('🚀 [StartupViewModel] appService.appInit() complete');
      _progress = 0.8;
      notifyListeners();

      debugPrint('🚀 [StartupViewModel] Verifying payment status...');
      await _handleInitialPaymentVerification().timeout(
        const Duration(seconds: 15),
      );
      debugPrint('🚀 [StartupViewModel] Payment verification complete');
      _progress = 1.0;
      notifyListeners();

      debugPrint(
        '🎉 [StartupViewModel] runStartupLogic completed in ${DateTime.now().difference(startTime).inMilliseconds}ms',
      );
    } catch (e, stackTrace) {
      debugPrint('❌ [StartupViewModel] ERROR during runStartupLogic: $e');
      talker.error(e, stackTrace);
      await _handleStartupError(e, stackTrace);
    }
  }

  /// Handle payment status changes from periodic verification
  Future<void> _handlePaymentStatusChange(
    PaymentVerificationResponse response,
  ) async {
    await PaymentVerificationNavigator.handle(
      response,
      isInitialStartup: _isInitialStartup,
      lastUserActivity: _lastUserActivity,
      userActivityThreshold: _userActivityThreshold,
    );
    if (response.result == PaymentVerificationResult.active) {
      _isInitialStartup = false;
    }
  }

  /// Handle initial payment verification during startup
  Future<void> _handleInitialPaymentVerification() async {
    try {
      final response = await _paymentVerificationService.verifyPaymentStatus();
      _handlePaymentStatusChange(response);
    } catch (e, stackTrace) {
      // If payment verification itself throws an exception, create a response and handle it
      talker.error(e, stackTrace);
      await PaymentVerificationNavigator.handle(
        PaymentVerificationResponse(
          result: PaymentVerificationResult.error,
          errorMessage: 'Payment verification failed: $e',
          exception: Exception(e),
        ),
        isInitialStartup: _isInitialStartup,
        lastUserActivity: _lastUserActivity,
        userActivityThreshold: _userActivityThreshold,
      );
    }
  }

  /// Call this method whenever user interacts with the app
  void updateUserActivity() {
    _lastUserActivity = DateTime.now();
    _isInitialStartup = false;
  }

  /// Force payment verification with navigation (e.g. sales / support).
  Future<void> forcePaymentVerification() async {
    await PaymentVerificationNavigator.verifyAndNavigate(userInitiated: true);
  }

  /// Ensures the specified user has all required admin access for all features.
  static Future<void> ensureAdminAccessForUser({
    required String userId,
    required String branchId,
    required String businessId,
    required dynamic talker,
  }) async {
    try {
      // Use features from flipper_services/constants.dart
      final List<String> featureNames = features
          .map((f) => f.toString())
          .toList();
      for (String feature in featureNames) {
        talker.warning(
          "Checking permission for userId: $userId, feature: $feature",
        );
        List<Access> hasAccess = await ProxyService.strategy.access(
          userId: userId,
          featureName: feature,
          fetchRemote: true,
        );
        if (hasAccess.isEmpty) {
          await ProxyService.strategy.addAccess(
            branchId: branchId,
            businessId: businessId,
            userId: userId,
            featureName: feature,
            accessLevel: 'admin',
            status: 'active',
            userType: "Admin",
          );
          talker.info("Assigned admin access for $feature to user $userId");
        }
      }
    } catch (e, stack) {
      talker.error(e, stack);
    }
  }

  /// Handles different error scenarios during startup.
  Future<void> _handleStartupError(Object e, StackTrace stackTrace) async {
    if (e is LoginChoicesException) {
      _routerService.navigateTo(LoginChoicesRoute());
    } else if (e is SessionException || e is PinError) {
      log(stackTrace.toString(), name: 'runStartupLogic');
      await logOut();
      _routerService.clearStackAndShow(LoginRoute());
      return;
    } else if (e is BusinessNotFoundException || e == NeedSignUpException) {
      if (Platform.isWindows) {
        // Handle BusinessNotFoundException for desktop.
        _handleBusinessNotFoundForDesktop();
        return;
      } else {
        // Handle BusinessNotFoundException for mobile.
        _routerService.navigateTo(SignUpViewRoute(countryNm: "Rwanda"));
        return;
      }
    } else if (e is SubscriptionError) {
      _routerService.navigateTo(PaymentPlanUIRoute());
      return;
    } else if (e is FailedPaymentException) {
      _routerService.navigateTo(FailedPaymentRoute());
    } else if (e is NoPaymentPlanFound) {
      _routerService.navigateTo(PaymentPlanUIRoute());
      return;
    } else if (e is TimeoutException) {
      if (!_hasRetriedAfterTimeout) {
        _hasRetriedAfterTimeout = true;
        talker.warning('Startup timed out, retrying once...');
        await runStartupLogic();
        return;
      }
      talker.error('Startup failed after timeout retry', e, stackTrace);
      final businessId = ProxyService.box.getBusinessId();
      final branchId = ProxyService.box.getBranchId();
      if (businessId != null && branchId != null) {
        talker.warning(
          'Entering app with cached session despite startup timeout',
        );
        await _handleInitialPaymentVerification();
      }
      return;
    } else {
      try {
        logOut();
        _routerService.navigateTo(LoginRoute());
      } catch (e) {
        _routerService.navigateTo(LoginRoute());
      }
      // check if there is any view navigated to
      return;
    }
  }

  /// Handles BusinessNotFoundException specifically for the desktop platform.
  void _handleBusinessNotFoundForDesktop() {
    ProxyService.notie.sendData(
      'Could not login business with user ${ProxyService.box.getUserId()} not found!',
    );
    logOut();
    _routerService.clearStackAndShow(LoginRoute());
  }

  bool isTestEnvironment() {
    return const bool.fromEnvironment('FLUTTER_TEST_ENV') == true;
  }

  Future<void> _requirementsMeetsWithRetry() async {
    try {
      await _allRequirementsMeets().timeout(const Duration(seconds: 15));
    } on TimeoutException {
      talker.warning(
        'Requirements check timed out, retrying once (local only)...',
      );
      await _allRequirementsMeets().timeout(const Duration(seconds: 15));
    }
  }

  Future<void> _allRequirementsMeets() async {
    try {
      if (isTestEnvironment()) {
        return;
      }
      final userId = ProxyService.box.getUserId();
      if (userId == null) {
        throw SessionException(term: 'No user in local storage');
      }
      talker.warning("StartupViewModel _allRequirementsMeets");

      // Check if business ID is set
      final businessId = ProxyService.box.getBusinessId();
      if (businessId == null) {
        throw Exception("Business ID is not set in local storage");
      }

      // Check if branch ID is set
      final branchId = ProxyService.box.getBranchId();
      if (branchId == null) {
        throw LoginChoicesException(term: "Branch ID not set");
      }

      // Local-only: avoid Turso pull / Supabase hydrate during startup checks.
      final business = await ProxyService.strategy.getBusinessById(
        businessId: businessId,
        fetchOnline: false,
      );
      if (business == null) {
        throw Exception("Business not found locally");
      }
      talker.warning("Business found: ${business.name}");

      // Check branches for the specific business
      List<Branch> branches = await ProxyService.strategy.branches(
        businessId: businessId,
        active: true,
        localOnly: true,
      );
      talker.warning("branches: ${branches.length}");

      if (branches.isEmpty) {
        throw Exception(
          "requirements failed for having branches saved locally",
        );
      }
    } catch (e, stackTrace) {
      talker.error(e, stackTrace);
      rethrow;
    }
  }

  /// Clean up resources when the view model is disposed
  @override
  void dispose() {
    _internetConnectionService.stopPeriodicConnectionCheck();
    super.dispose();
  }
}
