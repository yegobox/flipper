import 'dart:developer';
import 'dart:io';

import 'package:flipper_models/AppInitializer.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/services/payment_verification_service.dart';
import 'package:flipper_services/Miscellaneous.dart';
import 'package:flipper_services/locator.dart' as loc;
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';

import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends FlipperBaseModel with CoreMiscellaneous {
  final appService = loc.getIt<AppService>();
  bool isBusinessSet = false;
  final _routerService = locator<RouterService>();

  Future<void> listenToAuthChange() async {}

  // Payment verification service instance
  final _paymentVerificationService = PaymentVerificationService();

  Future<void> runStartupLogic() async {
    // await logOut();
    try {
      talker.warning("StartupViewModel runStartupLogic");
      // Ensure realm is initialized before proceeding.

      await _hasActiveSubscription();
      talker.warning("StartupViewModel Bellow hasActiveSubscription");
      await _allRequirementsMeets();
      talker.warning("StartupViewModel Below allRequirementsMeets");
      AppInitializer.initialize();

      talker.warning("StartupViewModel Below AppInitializer.initialize()");

      // Start periodic payment verification (check every 60 minutes)
      _paymentVerificationService.startPeriodicVerification();

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

  Future<void> _hasActiveSubscription() async {
    await ProxyService.strategy.hasActiveSubscription(
        fetchRemote: false,
        businessId: ProxyService.box.getBusinessId()!,
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
