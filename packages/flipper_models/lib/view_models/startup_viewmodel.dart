import 'dart:developer';
import 'dart:io';

import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/Miscellaneous.dart';
import 'package:flipper_services/locator.dart' as loc;
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:talker_flutter/talker_flutter.dart';

class StartupViewModel extends FlipperBaseModel with CoreMiscellaneous {
  final appService = loc.getIt<AppService>();
  bool isBusinessSet = false;
  final _routerService = locator<RouterService>();

  Future<void> listenToAuthChange() async {}

  Future<void> runStartupLogic({
    required bool refreshCredentials,
  }) async {
    final talker = TalkerFlutter.init();

    try {
      // Handle authentication refreshing.
      if (refreshCredentials) {
        await appService.isLoggedIn();
        await appService.appInit();
      }
      // Ensure realm is initialized before proceeding.
      await ensureRealmInitialized();
      await _hasActiveSubscription();

      // Handle navigation based on user state and app settings.
      if (ProxyService.local.isDrawerOpen(
          cashierId: ProxyService.box.getUserId()!,
          branchId: ProxyService.box.getBranchId()!)) {
        // Drawer should be open - handle data bootstrapping and navigation.
        _handleDrawerOpen();
      } else {
        // Drawer should be closed - handle data bootstrapping and navigation.
        _handleDrawerClosed();
      }
    } catch (e, stackTrace) {
      talker.info("StartupViewModel ${e}");
      talker.error("StartupViewModel ${stackTrace}");
      await _handleStartupError(e, stackTrace);
    }
  }

  /// Handles the scenario where the drawer should be open.
  void _handleDrawerOpen() {
    // Bootstrap initial data if required.
    ProxyService.forceDateEntry.dataBootstrapper();

    // Navigate to the appropriate home view based on app settings.
    if (ProxyService.box.getDefaultApp() == 2) {
      _routerService.navigateTo(SocialHomeViewRoute());
    } else {
      _routerService.navigateTo(FlipperAppRoute());
    }
  }

  /// Handles the scenario where the drawer should be closed.
  void _handleDrawerClosed() {
    // Bootstrap initial data if required.
    ProxyService.forceDateEntry.dataBootstrapper();

    // Navigate to the appropriate home view based on app settings.
    if (ProxyService.box.getDefaultApp() == 2) {
      _routerService.navigateTo(SocialHomeViewRoute());
    } else {
      openDrawer();
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
    } else if (e is BusinessNotFoundException) {
      if (Platform.isWindows) {
        // Handle BusinessNotFoundException for desktop.
        _handleBusinessNotFoundForDesktop();
      } else {
        // Handle BusinessNotFoundException for mobile.
        _routerService.navigateTo(SignUpViewRoute(countryNm: "Rwanda"));
      }
    } else if (e is SubscriptionError) {
      _routerService.navigateTo(PaymentPlanUIRoute());
    } else if (e is FailedPaymentException) {
      _routerService.navigateTo(FailedPaymentRoute());
    } else {
      // Handle other unexpected errors.
      await logOut();
      _routerService.clearStackAndShow(LoginRoute());
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
    await ProxyService.realm.hasActiveSubscription(
        businessId: ProxyService.box.getBusinessId()!,
        flipperHttpClient: ProxyService.http);
  }
}
