import 'dart:async';

import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/proxy.dart';
import 'package:meta/meta.dart';
import 'package:supabase_models/brick/models/plans.model.dart';

/// Represents the different states of payment verification
enum PaymentVerificationResult { active, noPlan, planExistsButInactive, error }

/// Contains the result of payment verification with additional context
class PaymentVerificationResponse {
  final PaymentVerificationResult result;
  final String? errorMessage;
  final Plan? plan;
  final Exception? exception;

  const PaymentVerificationResponse({
    required this.result,
    this.errorMessage,
    this.plan,
    this.exception,
  });

  bool get isActive => result == PaymentVerificationResult.active;
  bool get requiresPaymentSetup => result == PaymentVerificationResult.noPlan;
  bool get requiresPaymentResolution =>
      result == PaymentVerificationResult.planExistsButInactive;
  bool get hasError => result == PaymentVerificationResult.error;
}

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
/// This service only handles verification logic - navigation is handled by callers.
class PaymentVerificationService {
  static final PaymentVerificationService _instance =
      PaymentVerificationService._internal();

  Timer? _verificationTimer;

  // Callback for when payment status changes
  Function(PaymentVerificationResponse)? onPaymentStatusChanged;

  /// Singleton instance
  factory PaymentVerificationService() {
    return _instance;
  }

  PaymentVerificationService._internal();

  /// Sets up a callback to be notified when payment status changes
  void setPaymentStatusChangeCallback(
      Function(PaymentVerificationResponse) callback) {
    onPaymentStatusChanged = callback;
  }

  /// Starts periodic payment verification
  /// [intervalMinutes] defines how often to check (defaults to 60 minutes)
  void startPeriodicVerification({int intervalMinutes = 1}) {
    stopPeriodicVerification();

    _verificationTimer = Timer.periodic(
      Duration(minutes: intervalMinutes),
      (_) async {
        final response = await verifyPaymentStatus();
        onPaymentStatusChanged?.call(response);
      },
    );

    talker.info(
        'Payment verification service started with interval of $intervalMinutes minutes');
  }

  /// Stops periodic payment verification
  void stopPeriodicVerification() {
    _verificationTimer?.cancel();
    _verificationTimer = null;
  }

  /// Verifies the current business payment status
  /// Returns a detailed response that callers can use to decide what action to take
  Future<PaymentVerificationResponse> verifyPaymentStatus() async {
    talker.info('Verifying payment status');

    try {
      final business = await ProxyService.strategy.activeBusiness();
      if (business?.id == null) {
        return PaymentVerificationResponse(
          result: PaymentVerificationResult.error,
          errorMessage: 'No active business found',
        );
      }

      final businessId = business!.id;

      // First check if a payment plan exists at all
      final plan = await ProxyService.strategy.getPaymentPlan(
        businessId: businessId,
        fetchOnline: true,
      );

      if (plan == null) {
        talker.warning('No payment plan found for business: $businessId');
        return PaymentVerificationResponse(
          result: PaymentVerificationResult.noPlan,
          errorMessage: 'No payment plan exists for this business',
        );
      }

      // A plan exists, now check if it's active
      try {
        final isActive = await ProxyService.strategy.hasActiveSubscription(
          businessId: businessId,
          flipperHttpClient: ProxyService.http,
          fetchRemote: true,
        );

        if (isActive) {
          talker
              .info('Payment verification successful: Subscription is active');
          return PaymentVerificationResponse(
            result: PaymentVerificationResult.active,
            plan: plan,
          );
        } else {
          talker.error('Payment plan exists but is not active');
          return PaymentVerificationResponse(
            result: PaymentVerificationResult.planExistsButInactive,
            errorMessage: 'Payment plan exists but subscription is not active',
            plan: plan,
          );
        }
      } on PaymentIncompleteException catch (e) {
        talker.error('Payment incomplete: $e');
        return PaymentVerificationResponse(
          result: PaymentVerificationResult.planExistsButInactive,
          errorMessage: 'Payment incomplete: ${e.message}',
          plan: plan,
          exception: e,
        );
      } catch (e) {
        // For any other error during subscription check, still consider it as planExistsButInactive
        talker.error('Error checking subscription status: $e');
        return PaymentVerificationResponse(
          result: PaymentVerificationResult.planExistsButInactive,
          errorMessage: 'Error checking subscription status: ${e.toString()}',
          plan: plan,
          exception: e is Exception ? e : Exception(e.toString()),
        );
      }
    } catch (e) {
      talker.error('Error during payment verification: $e');
      return PaymentVerificationResponse(
        result: PaymentVerificationResult.error,
        errorMessage: 'Failed to verify payment status: ${e.toString()}',
        exception: e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  /// Force immediate payment verification
  /// Returns the verification response for the caller to handle
  Future<PaymentVerificationResponse> forcePaymentVerification() async {
    final response = await verifyPaymentStatus();

    if (!response.isActive) {
      talker.warning(
          'Forced payment verification failed: ${response.errorMessage}');
    }

    return response;
  }

  /// Helper method to check if payment is required
  /// Useful for quick checks without full verification details
  Future<bool> isPaymentRequired() async {
    final response = await verifyPaymentStatus();
    return !response.isActive;
  }

  /// Dispose method to clean up resources
  void dispose() {
    stopPeriodicVerification();
    onPaymentStatusChanged = null;
  }

  /// Returns true if the periodic verification timer is currently active.
  @visibleForTesting
  bool get isTimerActive => _verificationTimer?.isActive ?? false;
}
