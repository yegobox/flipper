import 'package:flipper_models/exceptions.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/helpers/agent_session_helper.dart';
import 'package:flipper_models/services/bar_mode_branch_settings_service.dart';
import 'package:flipper_models/services/payment_verification_service.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked_services/stacked_services.dart';

/// Routes the user based on [PaymentVerificationResponse] (startup, periodic, manual).
class PaymentVerificationNavigator {
  PaymentVerificationNavigator._();

  static final _routerService = locator<RouterService>();
  static bool _isOnPaymentScreen = false;

  static const _criticalRoutes = {
    'AddProductView',
    'Sell',
    'Payments',
    'PaymentConfirmation',
    'TransactionDetail',
    'CheckOut',
    'NewTicket',
    'BarModeHost',
  };

  static const _barModeEnabledKey = BarModeBranchSettingsService.enabledKey;

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
    if (!userInitiated) {
      final currentRoute = _routerService.router.current.name;
      if (_criticalRoutes.contains(currentRoute)) {
        talker.info(
          'Skipping payment verification navigation - user on critical page: $currentRoute',
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
        await _handleActiveSubscription();
        break;
      case PaymentVerificationResult.noPlan:
        await _handleNoPlan();
        break;
      case PaymentVerificationResult.planExistsButInactive:
        await _handleInactivePlan(response);
        break;
      case PaymentVerificationResult.error:
        await _handleVerificationError(response);
        break;
    }
  }

  static Future<void> _handleActiveSubscription() async {
    talker.info('Payment verification successful: Subscription is active');

    if (_isOnPaymentScreen) {
      talker.info(
        'Returning to main app after successful payment verification',
      );
      _isOnPaymentScreen = false;
    }

    final currentRoute = _routerService.router.current.name;
    if (currentRoute == BarModeRoute.name) {
      talker.info('Already in bar mode — skipping home navigation');
      return;
    }

    await _navigateToAuthenticatedHome();
  }

  static Future<void> _handleNoPlan() async {
    if (await _navigateCommissionOnlyIfNeeded()) return;

    talker.warning('No payment plan found, directing to payment plan screen');
    _isOnPaymentScreen = true;
    _routerService.navigateTo(PaymentPlanUIRoute());
  }

  static Future<void> _handleInactivePlan(
    PaymentVerificationResponse response,
  ) async {
    if (await _navigateCommissionOnlyIfNeeded()) return;

    talker.error(
      'Payment plan exists but is not active: ${response.errorMessage}',
    );
    _isOnPaymentScreen = true;
    _routerService.navigateTo(FailedPaymentRoute());
  }

  static Future<void> _handleVerificationError(
    PaymentVerificationResponse response,
  ) async {
    talker.error('Error during payment verification: ${response.errorMessage}');

    if (await _navigateCommissionOnlyIfNeeded()) return;

    final shouldGoToPersonal = await _shouldNavigateToPersonalApp();
    if (shouldGoToPersonal) {
      talker.info(
        'Navigating to personal app for individual business despite payment verification error',
      );
      _routerService.navigateTo(PersonalHomeRoute());
      return;
    }

    if (response.exception is NoPaymentPlanFound) {
      _isOnPaymentScreen = true;
      _routerService.navigateTo(PaymentPlanUIRoute());
    } else if (response.exception is PaymentIncompleteException ||
        response.exception is FailedPaymentException) {
      _isOnPaymentScreen = true;
      _routerService.navigateTo(FailedPaymentRoute());
    } else {
      talker.warning(
        'Proceeding to main app despite payment verification error',
      );
      await _navigateToAuthenticatedHome(skipPersonalCheck: true);
    }
  }

  static Future<bool> _navigateCommissionOnlyIfNeeded() async {
    final commissionOnly = await refreshCommissionOnlySession();
    if (!commissionOnly) return false;

    talker.info(
      'Navigating to agent commission screen for commission-only session',
    );
    _routerService.navigateTo(const AgentCommissionRoute());
    return true;
  }

  static Future<void> _navigateToAuthenticatedHome({
    bool skipPersonalCheck = false,
  }) async {
    if (!skipPersonalCheck) {
      final shouldGoToPersonal = await _shouldNavigateToPersonalApp();
      if (shouldGoToPersonal) {
        talker.info('Navigating to personal app for individual business');
        _routerService.navigateTo(PersonalHomeRoute());
        return;
      }
    }

    if (await _navigateCommissionOnlyIfNeeded()) return;

    await BarModeBranchSettingsService.hydrateForActiveBranch();

    if (_shouldOpenBarMode()) {
      talker.info('Bar mode launch on start — opening bar register');
      _routerService.navigateTo(BarModeRoute());
      return;
    }

    _routerService.navigateTo(FlipperAppRoute());
  }

  static bool _shouldOpenBarMode() {
    return ProxyService.box.readBool(key: _barModeEnabledKey) ?? false;
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
