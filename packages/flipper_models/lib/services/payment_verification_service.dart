import 'dart:async';

import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked_services/stacked_services.dart';

/// Exception thrown when a payment plan is not found.
class NoPaymentPlanFoundException implements Exception {
  final String message;
  NoPaymentPlanFoundException(this.message);

  @override
  String toString() => message;
}

/// Exception thrown when payment has failed or is incomplete.
class PaymentIncompleteException implements Exception {
  final String message;
  PaymentIncompleteException(this.message);

  @override
  String toString() => message;
}

/// Service responsible for verifying payment status throughout the app lifecycle.
class PaymentVerificationService {
  static final PaymentVerificationService _instance =
      PaymentVerificationService._internal();
  final _routerService = locator<RouterService>();
  Timer? _verificationTimer;

  /// Singleton instance
  factory PaymentVerificationService() {
    return _instance;
  }

  PaymentVerificationService._internal();

  /// Starts periodic payment verification
  /// [intervalMinutes] defines how often to check (defaults to 60 minutes)
  void startPeriodicVerification({int intervalMinutes = 60}) {
    stopPeriodicVerification();

    _verificationTimer = Timer.periodic(
      Duration(minutes: intervalMinutes),
      (_) => verifyPaymentStatus(),
    );

    talker.info(
        'Payment verification service started with interval of $intervalMinutes minutes');
  }

  /// Stops periodic payment verification
  void stopPeriodicVerification() {
    _verificationTimer?.cancel();
    _verificationTimer = null;
  }

  /// Verifies if the current business has an active subscription
  /// Returns true if subscription is active, otherwise navigates to payment screen
  /// and returns false
  /// Flag to track if we're currently on a payment screen
  bool _isOnPaymentScreen = false;

  /// Set when navigating to a payment screen
  void _setOnPaymentScreen() {
    _isOnPaymentScreen = true;
    talker.info('Payment screen flag set to true');
  }

  /// Set when navigating back to the main app
  void _clearPaymentScreenFlag() {
    _isOnPaymentScreen = false;
    talker.info('Payment screen flag set to false');
  }

  Future<bool> verifyPaymentStatus() async {
    talker.info('Verifying payment status');

    try {
      final businessId = ProxyService.box.getBusinessId();
      if (businessId == null) {
        talker.warning('Cannot verify payment: Business ID is null');
        return false;
      }

      // First check if a payment plan exists at all
      final plan = await ProxyService.strategy.getPaymentPlan(
        businessId: businessId,
        fetchRemote: true,
      );

      if (plan == null) {
        // No payment plan exists, direct to payment plan screen
        talker
            .warning('No payment plan found, directing to payment plan screen');
        _setOnPaymentScreen();
        _routerService.navigateTo(PaymentPlanUIRoute());
        return false;
      }

      // A plan exists, now check if it's active
      try {
        await ProxyService.strategy.hasActiveSubscription(
          businessId: businessId,
          flipperHttpClient: ProxyService.http,
          fetchRemote: true,
        );

        talker.info('Payment verification successful: Subscription is active');

        // If we were on a payment screen, navigate back to the main app
        if (_isOnPaymentScreen) {
          talker.info(
              'Returning to main app after successful payment verification');
          _clearPaymentScreenFlag();
          _routerService.navigateTo(FlipperAppRoute());
        }

        return true;
      } catch (subscriptionError) {
        // Plan exists but is not active (payment failed or expired)
        talker
            .error('Payment plan exists but is not active: $subscriptionError');
        _setOnPaymentScreen();
        _routerService.navigateTo(FailedPaymentRoute());
        return false;
      }
    } catch (e) {
      talker.error('Error during payment verification: $e');
      _setOnPaymentScreen();

      // For general errors, direct to payment plan screen
      _routerService.navigateTo(PaymentPlanUIRoute());
      return false;
    }
  }

  /// Force immediate payment verification and redirect to payment screen if needed
  /// This can be called from any part of the app when payment verification is needed
  Future<void> forcePaymentVerification() async {
    final isActive = await verifyPaymentStatus();
    if (!isActive) {
      talker.warning(
          'Forced payment verification failed - redirecting to payment screen');
    }
  }
}
