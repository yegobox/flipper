import 'dart:developer';
import 'dart:io';

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

import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends FlipperBaseModel with CoreMiscellaneous {
  final appService = loc.getIt<AppService>();
  bool isBusinessSet = false;
  final _routerService = locator<RouterService>();

  Future<void> listenToAuthChange() async {}

  // Payment verification service instance
  final _paymentVerificationService = PaymentVerificationService();

  // Internet connection service instance
  final _internetConnectionService = InternetConnectionService();

  Future<void> runStartupLogic() async {
    // await logOut();
    try {
      if (ProxyService.box.getForceLogout()) {
        await logOut();
        _routerService.navigateTo(LoginRoute());
        return;
      }
      talker.warning("StartupViewModel runStartupLogic");
      // Ensure realm is initialized before proceeding.

      await _allRequirementsMeets();
      talker.warning("StartupViewModel Below allRequirementsMeets");
      // Ensure admin access for API/onboarded users

      AppInitializer.initialize();

      talker.warning("StartupViewModel Below AppInitializer.initialize()");

      // Start periodic payment verification (check every 60 minutes)
      _paymentVerificationService.startPeriodicVerification();

      // Start periodic internet connection check (check every 6 hours)
      _internetConnectionService.startPeriodicConnectionCheck();

      /// listen all database change and replicate them in sync db.
      // ProxyService.backUp.listen();

      // Handle navigation based on user state and app settings.
      _routerService.navigateTo(FlipperAppRoute());
      talker.warning("StartupViewModel Below navigateTo(FlipperAppRoute)");
      // if (ProxyService.strategy.isDrawerOpen(
      //     cashierId: ProxyService.box.getUserId()!,
      //     branchId: ProxyService.box.getBranchId()!)) {
      //   // Drawer should be open - handle data bootstrapping and navigation.
      //   _handleDrawerOpen();
      // } else {
      //   // Drawer should be closed - handle data bootstrapping and navigation.
      //   _handleDrawerClosed();
      // }
    } catch (e, stackTrace) {
      talker.info("StartupViewModel ${e}");
      talker.error("StartupViewModel ${stackTrace}");
      await _handleStartupError(e, stackTrace);
    }
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
        List<Access> hasAccess = await ProxyService.strategy
            .access(userId: int.parse(userId), featureName: feature);
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

  Future<void> hasActiveSubscription() async {
    await ProxyService.strategy.hasActiveSubscription(
        fetchRemote: false,
        businessId: ProxyService.box.getBusinessId()??0,
        flipperHttpClient: ProxyService.http);
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
      List<Branch> branches =
          await ProxyService.strategy.branches(businessId: businessId);
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
}
