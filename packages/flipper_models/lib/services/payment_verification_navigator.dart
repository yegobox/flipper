import 'package:flutter/foundation.dart';

import 'package:flipper_models/exceptions.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/helpers/agent_session_helper.dart';
import 'package:flipper_models/services/bar_mode_branch_settings_service.dart';
import 'package:flipper_models/services/hotel_mode_branch_settings_service.dart';
import 'package:flipper_models/services/payment_verification_service.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked_services/stacked_services.dart';

/// Routes the user based on [PaymentVerificationResponse] (startup, periodic, manual).
class PaymentVerificationNavigator {
  PaymentVerificationNavigator._();

  static final _routerService = locator<RouterService>();

  /// The lockout screens.
  ///
  /// Being on one of these is the *only* reason a background check that comes
  /// back healthy has to move the user: their subscription just started
  /// working again and they are stuck behind a paywall that no longer applies.
  ///
  /// The current route is the single source of truth for "is this device
  /// locked out". A boolean latch used to be kept alongside it, which went
  /// stale the moment the user left the paywall by any route other than a
  /// verification (back button, the plan screen navigating on its own).
  @visibleForTesting
  static const paywallRoutes = {
    PaymentPlanUIRoute.name,
    FailedPaymentRoute.name,
  };

  /// Whether a verification is allowed to send the user to the authenticated
  /// home, given who asked for it and where the user currently is.
  ///
  /// Pure and exposed so the rule stays pinned by tests: a healthy background
  /// check must not move a user who is working. Before this existed,
  /// `_handleActiveSubscription` navigated home on every successful check, so a
  /// periodic tick or a `plans` realtime event popped whatever page the user
  /// was on even though nothing was owed.
  @visibleForTesting
  static bool mayEnterHomeFor({
    required String currentRoute,
    required bool userInitiated,
    required bool isInitialStartup,
  }) =>
      userInitiated || isInitialStartup || paywallRoutes.contains(currentRoute);

  /// Whether a verification that *could not complete* may still send the user
  /// home ("proceed despite the error").
  ///
  /// Narrower than [mayEnterHomeFor]: an error says nothing about whether money
  /// is owed, so it must not lift a paywall. Startup keeps failing open so an
  /// offline shop can still trade, and a check the user asked for may too. A
  /// background check on the paywall may not: the card checkout writes the
  /// `plans` row before it calls the connector, that write triggers a
  /// verification, and any blip in it (a turbo timeout, a dev backend that
  /// isn't up) waved an unpaid user into the dashboard until the next check
  /// sent them back.
  @visibleForTesting
  static bool mayFailOpenFor({
    required bool userInitiated,
    required bool isInitialStartup,
  }) => userInitiated || isInitialStartup;

  static const _criticalRoutes = {
    'AddProductView',
    'Sell',
    'Payments',
    'PaymentConfirmation',
    'TransactionDetail',
    'CheckOut',
    'NewTicket',
    'BarModeHost',
    'HotelModeHost',
  };

  /// Routes that exist before the user has authenticated. Background/periodic
  /// payment verification must never force navigation away from these — doing
  /// so would silently "log in" a user sitting on the PIN/login screen by
  /// pushing them straight to the authenticated home once verification errors
  /// out (e.g. because no business/branch is selected yet).
  static const _preAuthRoutes = {
    'StartUpView',
    'Login',
    'PinLogin',
    'Landing',
    'Auth',
    'CountryPicker',
    'PhoneInputScreen',
    'LoginChoices',
    'SignUpView',
  };

  static const _barModeEnabledKey = BarModeBranchSettingsService.enabledKey;
  static const _hotelModeEnabledKey = HotelModeBranchSettingsService.enabledKey;

  /// Which surface *this device* was set to run. Mirrors `deviceServiceMode`
  /// in flipper_dashboard, read by key because this package sits below it.
  static const _deviceServiceModeKey = 'deviceServiceMode';

  /// Refuses an authenticated route when no signed-in user remains, and says so.
  ///
  /// Call this immediately before every authenticated `navigateTo` rather than
  /// once on entry. Every path here awaits — the personal-app check, the
  /// commission check, bar-mode hydration — and logout clears the box
  /// asynchronously, so a session that existed when the check ran can be gone
  /// by the time the navigation happens.
  static bool _refuseWhenSignedOut(String route) {
    final userId = ProxyService.box.getUserId()?.trim();
    if (userId != null && userId.isNotEmpty) return false;
    talker.warning('Refusing to navigate to $route: no signed-in user');
    return true;
  }

  /// Verifies payment online and navigates. Use after signup when payment was just completed.
  static Future<PaymentVerificationResponse> verifyAndNavigate({
    bool userInitiated = true,
  }) async {
    final service = PaymentVerificationService();
    final response = await service.verifyPaymentStatus();
    await handle(response, userInitiated: userInitiated);
    return response;
  }

  static Future<void> handle(
    PaymentVerificationResponse response, {
    bool userInitiated = false,
    bool isInitialStartup = false,
    DateTime? lastUserActivity,
    Duration userActivityThreshold = const Duration(minutes: 5),
  }) async {
    final currentRoute = _routerService.router.current.name;

    // A verification that finds nothing wrong is not a reason to navigate.
    // Only three things are: the user asked for the check, we are still on the
    // splash screen and have nowhere else to be, or the user is sitting behind
    // a paywall that has just been lifted.
    //
    // Without this gate every periodic tick and every `plans` realtime event
    // pushed whoever was using the app back to the home shell — mid-report,
    // mid-settings, mid-stock-count — because `_handleActiveSubscription`
    // navigated home unconditionally. `_criticalRoutes` only ever covered
    // checkout, so the rest of the app was fair game.
    final mayEnterHome = mayEnterHomeFor(
      currentRoute: currentRoute,
      userInitiated: userInitiated,
      isInitialStartup: isInitialStartup,
    );

    if (!userInitiated) {
      if (_criticalRoutes.contains(currentRoute)) {
        talker.info(
          'Skipping payment verification navigation - user on critical page: $currentRoute',
        );
        return;
      }

      // The pre-auth guard is only meant to stop *background/periodic*
      // verification from yanking a user off a login/PIN screen. The initial
      // startup verification legitimately runs while sitting on StartUpView and
      // must be allowed to navigate to the authenticated home — otherwise the
      // app freezes on the splash screen at 100%.
      if (!isInitialStartup && _preAuthRoutes.contains(currentRoute)) {
        talker.info(
          'Skipping payment verification navigation - user not yet authenticated: $currentRoute',
        );
        return;
      }

      if (!isInitialStartup &&
          lastUserActivity != null &&
          DateTime.now().difference(lastUserActivity) < userActivityThreshold) {
        talker.info(
          'Skipping payment verification navigation - user recently active',
        );
        return;
      }
    }

    switch (response.result) {
      case PaymentVerificationResult.active:
        await _handleActiveSubscription(mayEnterHome: mayEnterHome);
        break;
      case PaymentVerificationResult.noPlan:
        await _handleNoPlan();
        break;
      case PaymentVerificationResult.planExistsButInactive:
        await _handleInactivePlan(response);
        break;
      case PaymentVerificationResult.error:
        await _handleVerificationError(
          response,
          mayFailOpen: mayFailOpenFor(
            userInitiated: userInitiated,
            isInitialStartup: isInitialStartup,
          ),
        );
        break;
    }
  }

  static Future<void> _handleActiveSubscription({
    required bool mayEnterHome,
  }) async {
    talker.info('Payment verification successful: Subscription is active');

    // The latch is no longer true whatever we do next, and it must be cleared
    // even when we do not navigate — otherwise a user who left the paywall on
    // their own keeps looking "on the payment screen" for the whole session.
    if (!mayEnterHome) {
      talker.info(
        'Subscription active and user is already working - staying on '
        '${_routerService.router.current.name}',
      );
      return;
    }

    final currentRoute = _routerService.router.current.name;
    if (currentRoute == BarModeHostRoute.name ||
        currentRoute == HotelModeHostRoute.name) {
      talker.info('Already in a service mode — skipping home navigation');
      return;
    }

    talker.info('Returning to main app after successful payment verification');
    await _navigateToAuthenticatedHome();
  }

  static Future<void> _handleNoPlan() async {
    if (await _navigateCommissionOnlyIfNeeded()) return;

    talker.warning('No payment plan found, directing to payment plan screen');
    _routerService.navigateTo(PaymentPlanUIRoute());
  }

  static Future<void> _handleInactivePlan(
    PaymentVerificationResponse response,
  ) async {
    if (await _navigateCommissionOnlyIfNeeded()) return;

    talker.error(
      'Payment plan exists but is not active: ${response.errorMessage}',
    );
    _routerService.navigateTo(FailedPaymentRoute());
  }

  static Future<void> _handleVerificationError(
    PaymentVerificationResponse response, {
    required bool mayFailOpen,
  }) async {
    talker.error('Error during payment verification: ${response.errorMessage}');

    // A verification that could not complete says nothing about whether money
    // is owed, so it is never a reason to move someone who is already working.
    // Only the two branches below that identify a *real* payment problem may
    // still interrupt; everything else (a dropped connection, a Supabase
    // hiccup, "no active business found") used to fall through to "proceed to
    // main app" and pop the user's page for no reason. Nor may it lift a
    // paywall from the background: see [mayFailOpenFor].
    final isPaymentProblem =
        response.exception is NoPaymentPlanFound ||
        response.exception is PaymentIncompleteException ||
        response.exception is FailedPaymentException;

    if (!mayFailOpen && !isPaymentProblem) {
      talker.warning(
        'Ignoring payment verification error on '
        '${_routerService.router.current.name}',
      );
      return;
    }

    if (await _navigateCommissionOnlyIfNeeded()) return;

    final shouldGoToPersonal = await _shouldNavigateToPersonalApp();
    if (shouldGoToPersonal) {
      if (_refuseWhenSignedOut('PersonalHome')) return;
      talker.info(
        'Navigating to personal app for individual business despite payment verification error',
      );
      _routerService.navigateTo(PersonalHomeScreenRoute());
      return;
    }

    if (response.exception is NoPaymentPlanFound) {
      _routerService.navigateTo(PaymentPlanUIRoute());
    } else if (response.exception is PaymentIncompleteException ||
        response.exception is FailedPaymentException) {
      _routerService.navigateTo(FailedPaymentRoute());
    } else if (mayFailOpen) {
      talker.warning(
        'Proceeding to main app despite payment verification error',
      );
      await _navigateToAuthenticatedHome(skipPersonalCheck: true);
    }
  }

  static Future<bool> _navigateCommissionOnlyIfNeeded() async {
    final commissionOnly = await refreshCommissionOnlySession();
    if (!commissionOnly) return false;

    // Reported as handled so callers stop here rather than falling through to
    // another authenticated route.
    if (_refuseWhenSignedOut('AgentCommission')) return true;

    talker.info(
      'Navigating to agent commission screen for commission-only session',
    );
    _routerService.navigateTo(AgentCommissionScreenRoute());
    return true;
  }

  static Future<void> navigateToAuthenticatedHome({
    bool skipPersonalCheck = false,
    bool skipCommissionCheck = false,
    bool clearStack = false,
  }) => _navigateToAuthenticatedHome(
    skipPersonalCheck: skipPersonalCheck,
    skipCommissionCheck: skipCommissionCheck,
    clearStack: clearStack,
  );

  static Future<void> _navigateToAuthenticatedHome({
    bool skipPersonalCheck = false,
    bool skipCommissionCheck = false,
    bool clearStack = false,
  }) async {
    // Hard invariant, independent of route names and of the isInitialStartup
    // grace period: nothing may push a signed-out device into the authenticated
    // home. Without this, a verification error while sitting on the login or
    // signup screen fell through to "proceed to main app" and entered the app
    // with no session. Checked again at each navigation below, since the work
    // in between awaits.
    if (_refuseWhenSignedOut('authenticated home')) return;

    if (!skipPersonalCheck) {
      final shouldGoToPersonal = await _shouldNavigateToPersonalApp();
      if (shouldGoToPersonal) {
        if (_refuseWhenSignedOut('PersonalHome')) return;
        talker.info('Navigating to personal app for individual business');
        _routerService.navigateTo(PersonalHomeScreenRoute());
        return;
      }
    }

    // Callers that already resolved commission-only status (e.g. LoginChoices,
    // which just awaited refreshCommissionOnlySession) can skip this so we
    // don't repeat the same 5s-bounded Supabase round trip during the
    // branch->home transition.
    if (!skipCommissionCheck && await _navigateCommissionOnlyIfNeeded()) {
      return;
    }

    // Both, in parallel: the bar decision now also asks whether this branch
    // runs a front desk, and hydrating them end to end would cost two timeouts
    // on a cold device.
    await Future.wait([
      BarModeBranchSettingsService.hydrateForActiveBranch(),
      HotelModeBranchSettingsService.hydrateForActiveBranch(),
    ]);

    if (_shouldOpenBarMode()) {
      if (_refuseWhenSignedOut('BarMode')) return;
      talker.info('Bar mode launch on start — opening bar register');
      if (clearStack) {
        await _routerService.clearStackAndShow(BarModeHostRoute());
      } else {
        _routerService.navigateTo(BarModeHostRoute());
      }
      return;
    }

    if (_refuseWhenSignedOut('FlipperApp')) return;

    if (clearStack) {
      await _routerService.clearStackAndShow(FlipperAppRoute());
    } else {
      _routerService.navigateTo(FlipperAppRoute());
    }
  }

  /// Whether this terminal's own service mode is the bar floor.
  ///
  /// Mirrors `resolveServiceMode` in flipper_dashboard (which this package
  /// cannot import) — keep the two in step. Everything else falls through to
  /// [FlipperAppRoute], whose startup redirect resolves the mode properly, so
  /// only the bar needs answering here.
  static bool _shouldOpenBarMode() {
    final barEnabled =
        ProxyService.box.readBool(key: _barModeEnabledKey) ?? false;
    if (!barEnabled) return false;

    final device = ProxyService.box.readString(key: _deviceServiceModeKey);
    if (device == 'bar') return true;
    if (device == 'hotel' || device == 'pos') return false;

    // No device pick: hotel wins, so a front desk is never dropped onto the
    // bar's table floor by a payment check.
    return !(ProxyService.box.readBool(key: _hotelModeEnabledKey) ?? false);
  }

  static Future<bool> _shouldNavigateToPersonalApp() async {
    try {
      final activeBusiness = await ProxyService.strategy.activeBusiness();
      return activeBusiness != null &&
          activeBusiness.businessTypeId == 2 &&
          activeBusiness.isDefault == true;
    } catch (e) {
      talker.warning('Error checking if should navigate to personal app: $e');
      return false;
    }
  }
}
