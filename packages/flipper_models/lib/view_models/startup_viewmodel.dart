import 'dart:developer';
import 'dart:io';

import 'package:flipper_services/ebm_sync_service.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:flipper_models/AppInitializer.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/services/payment_verification_service.dart';
import 'package:flipper_models/services/internet_connection_service.dart';
import 'package:flipper_services/Miscellaneous.dart';
import 'package:flipper_services/locator.dart' as loc;
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flipper_services/asset_sync_service.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_models/view_models/migrate_db_util.dart';

class StartupViewModel extends FlipperBaseModel with CoreMiscellaneous {
  final appService = loc.getIt<AppService>();
  bool isBusinessSet = false;
  final _routerService = locator<RouterService>();

  Future<void> listenToAuthChange() async {}

  // Payment verification service instance
  final _paymentVerificationService = PaymentVerificationService();

  // Internet connection service instance
  final _internetConnectionService = InternetConnectionService();

  // Flag to track if we're currently on a payment screen
  bool _isOnPaymentScreen = false;

  // Track last user activity to avoid interrupting active users
  DateTime? _lastUserActivity;
  static const Duration _userActivityThreshold = Duration(minutes: 5);
  bool _isInitialStartup = true;

  Future<void> runStartupLogic() async {
    // await logOut();
    try {
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

      // --- DB Migration Step for folder rename (_db -> .db) ---
      try {
        final appDir = await getApplicationDocumentsDirectory();
        await hideDbDirectoryIfWindows(appDir: appDir.path, talker: talker);
      } catch (e) {
        talker.warning("DB migration step failed: $e");
      }
      // ------------------------------------------------------

      // Ensure db is initialized before proceeding.
      await _allRequirementsMeets();
      talker.warning("StartupViewModel Below allRequirementsMeets");

      // Ensure admin access for API/onboarded users
      AppInitializer.initialize();

      // Initialize the EBM Sync Service to listen for customer updates.
      final repository = Repository();
      EbmSyncService(repository);

      AssetSyncService().initialize();
      ProxyService.strategy.supabaseAuth();
      ProxyService.strategy.cleanDuplicatePlans();

      talker.warning("StartupViewModel Below AppInitializer.initialize()");

      // Set up payment verification callback and start periodic verification
      _paymentVerificationService
          .setPaymentStatusChangeCallback(_handlePaymentStatusChange);
      _paymentVerificationService.startPeriodicVerification();

      // Start periodic internet connection check (check every 6 hours)
      _internetConnectionService.startPeriodicConnectionCheck();

      /// listen all database change and replicate them in sync db.
      // ProxyService.backUp.listen();
      await appService.appInit();

      // Check payment status before navigating to main app
      await _handleInitialPaymentVerification();

      talker.warning("StartupViewModel Below payment verification");
    } catch (e, stackTrace) {
      talker.info("StartupViewModel ${e}");
      talker.error("StartupViewModel ${stackTrace}");
      await _handleStartupError(e, stackTrace);
    }
  }

  /// Handle payment status changes from periodic verification
  void _handlePaymentStatusChange(PaymentVerificationResponse response) {
    // Check if user is currently on a modal or critical page
    final currentRoute = _routerService.router.current.name;
    final criticalRoutes = [
      'AddProductView',
      'Sell',
      'Payments',
      'PaymentConfirmation',
      'TransactionDetail',
      'CheckOut',
      'NewTicket',
      'CheckOut'
    ];

    // Don't interrupt user during critical operations
    if (criticalRoutes.contains(currentRoute)) {
      talker.info(
          'Skipping payment verification navigation - user on critical page: $currentRoute');
      return;
    }

    // Don't interrupt if user was recently active (but allow during initial startup)
    if (!_isInitialStartup &&
        _lastUserActivity != null &&
        DateTime.now().difference(_lastUserActivity!) <
            _userActivityThreshold) {
      talker.info(
          'Skipping payment verification navigation - user recently active');
      return;
    }

    switch (response.result) {
      case PaymentVerificationResult.active:
        _handleActiveSubscription();
        break;
      case PaymentVerificationResult.noPlan:
        _handleNoPlan();
        break;
      case PaymentVerificationResult.planExistsButInactive:
        _handleInactivePlan(response);
        break;
      case PaymentVerificationResult.error:
        _handleVerificationError(response);
        break;
    }
  }

  /// Handle initial payment verification during startup
  Future<void> _handleInitialPaymentVerification() async {
    try {
      final response = await _paymentVerificationService.verifyPaymentStatus();
      _handlePaymentStatusChange(response);
    } catch (e) {
      // If payment verification itself throws an exception, create a response and handle it
      talker.error("Exception during initial payment verification: $e");
      _handleVerificationError(PaymentVerificationResponse(
        result: PaymentVerificationResult.error,
        errorMessage: 'Payment verification failed: $e',
        exception: Exception(e),
      ));
    }
  }

  void _handleActiveSubscription() {
    talker.info('Payment verification successful: Subscription is active');

    // If we were on a payment screen, navigate back to the main app
    if (_isOnPaymentScreen) {
      talker
          .info('Returning to main app after successful payment verification');
      _clearPaymentScreenFlag();
      _routerService.navigateTo(FlipperAppRoute());
    } else {
      // First time startup with active subscription
      _routerService.navigateTo(FlipperAppRoute());
      talker.warning("StartupViewModel Below navigateTo(FlipperAppRoute)");
    }
    _isInitialStartup = false;
  }

  void _handleNoPlan() {
    talker.warning('No payment plan found, directing to payment plan screen');
    _setOnPaymentScreen();
    _routerService.navigateTo(PaymentPlanUIRoute());
  }

  void _handleInactivePlan(PaymentVerificationResponse response) {
    talker.error(
        'Payment plan exists but is not active: ${response.errorMessage}');
    _setOnPaymentScreen();
    _routerService.navigateTo(FailedPaymentRoute());
  }

  void _handleVerificationError(PaymentVerificationResponse response) {
    talker.error('Error during payment verification: ${response.errorMessage}');

    // Handle specific error types
    if (response.exception is NoPaymentPlanFoundException) {
      _setOnPaymentScreen();
      _routerService.navigateTo(PaymentPlanUIRoute());
    } else if (response.exception is PaymentIncompleteException) {
      _setOnPaymentScreen();
      _routerService.navigateTo(FailedPaymentRoute());
    } else {
      // For other errors, still allow access to main app but log the issue
      talker
          .warning("Proceeding to main app despite payment verification error");
      _routerService.navigateTo(FlipperAppRoute());
    }
  }

  void _setOnPaymentScreen() {
    _isOnPaymentScreen = true;
    talker.info('Payment screen flag set to true');
  }

  void _clearPaymentScreenFlag() {
    _isOnPaymentScreen = false;
    talker.info('Payment screen flag set to false');
  }

  /// Call this method whenever user interacts with the app
  void updateUserActivity() {
    _lastUserActivity = DateTime.now();
    _isInitialStartup = false;
  }

  /// Force payment verification with navigation handling
  Future<void> forcePaymentVerification() async {
    final response =
        await _paymentVerificationService.forcePaymentVerification();
    _handlePaymentStatusChange(response);
  }

  /// Check if payment is required without navigation
  Future<bool> isPaymentRequired() async {
    return await _paymentVerificationService.isPaymentRequired();
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
      final List<String> featureNames =
          features.map((f) => f.toString()).toList();
      for (String feature in featureNames) {
        talker.warning(
            "Checking permission for userId: $userId, feature: $feature");
        List<Access> hasAccess = await ProxyService.strategy.access(
            userId: int.parse(userId), featureName: feature, fetchRemote: true);
        if (hasAccess.isEmpty) {
          await ProxyService.strategy.addAccess(
            branchId: int.parse(branchId),
            businessId: int.parse(businessId),
            userId: int.parse(userId),
            featureName: feature,
            accessLevel: 'admin',
            status: 'active',
            userType: "Admin",
          );
          talker.info("Assigned admin access for $feature to user $userId");
        }
      }
    } catch (e, stack) {
      talker.error("Error ensuring admin access: $e\n$stack");
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
        'Could not login business with user ${ProxyService.box.getUserId()} not found!');
    logOut();
    _routerService.clearStackAndShow(LoginRoute());
  }

  bool isTestEnvironment() {
    return const bool.fromEnvironment('FLUTTER_TEST_ENV') == true;
  }

  Future<void> _allRequirementsMeets() async {
    try {
      if (isTestEnvironment()) {
        return;
      }
      // check there is a user logged in by getUserId()!
      ProxyService.box.getUserId()!;
      talker.warning("StartupViewModel _allRequirementsMeets");

      // Check if business ID is set
      final businessId = ProxyService.box.getBusinessId();
      if (businessId == null) {
        throw Exception("Business ID is not set in local storage");
      }

      // Check if the specific business exists instead of fetching all businesses
      final business =
          await ProxyService.strategy.getBusiness(businessId: businessId);
      if (business == null) {
        throw Exception("Business not found locally");
      }
      talker.warning("Business found: ${business.name}");

      // Check branches for the specific business
      List<Branch> branches = await ProxyService.strategy
          .branches(businessId: businessId, active: true);
      talker.warning("branches: ${branches.length}");

      if (branches.isEmpty) {
        throw Exception(
            "requirements failed for having branches saved locally");
      }
    } catch (e) {
      talker.error("StartupViewModel _allRequirementsMeets ${e}");
      rethrow;
    }
  }

  /// Clean up resources when the view model is disposed
  @override
  void dispose() {
    _paymentVerificationService.dispose();
    _internetConnectionService.stopPeriodicConnectionCheck();
    super.dispose();
  }
}
