import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/supabase_realtime_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

/// Service responsible for verifying payment status throughout the app lifecycle.
/// This service only handles verification logic - navigation is handled by callers.
class PaymentVerificationService {
  static PaymentVerificationService? _instance;

  Timer? _verificationTimer;

  RealtimeChannel? _planChannel;
  Timer? _realtimeDebounce;
  String? _watchedBusinessId;

  /// Guards against two verifications overlapping — the timer and a realtime
  /// event can land together, and `verifyPaymentStatus` makes three network
  /// round trips.
  bool _verifying = false;

  // Callback for when payment status changes
  Function(PaymentVerificationResponse)? onPaymentStatusChanged;

  /// Singleton instance
  factory PaymentVerificationService() {
    _instance ??= PaymentVerificationService._internal();
    return _instance!;
  }

  PaymentVerificationService._internal();

  /// For testing purposes only - resets the singleton instance
  @visibleForTesting
  static void resetInstance() {
    _instance?.dispose(); // Ensure proper cleanup before resetting
    _instance = null;
  }

  /// Sets up a callback to be notified when payment status changes
  void setPaymentStatusChangeCallback(
    Function(PaymentVerificationResponse) callback,
  ) {
    onPaymentStatusChanged = callback;
  }

  /// Starts periodic payment verification.
  ///
  /// This is the **floor**, not the mechanism: on its own a four-hour interval
  /// means a till keeps working for up to four hours after a subscription
  /// lapses, and — more visibly — a second device stays locked out for up to
  /// four hours after the owner pays on their phone. Pair it with
  /// [startRealtimeVerification], which reacts the moment the plan row changes;
  /// the timer then only has to cover devices that were offline when it did.
  ///
  /// [intervalMinutes] defines how often to check (defaults to 30 minutes)
  void startPeriodicVerification({int intervalMinutes = 30}) {
    stopPeriodicVerification();

    _verificationTimer = Timer.periodic(Duration(minutes: intervalMinutes), (
      _,
    ) async {
      await _verifyAndNotify(reason: 'periodic');
    });

    talker.info(
      'Payment verification service started with interval of $intervalMinutes minutes',
    );
  }

  /// Stops periodic payment verification
  void stopPeriodicVerification() {
    _verificationTimer?.cancel();
    _verificationTimer = null;
  }

  /// Re-verifies the moment this business's plan row changes, on **every**
  /// signed-in device rather than only the one that made the payment.
  ///
  /// `plans` is written by data-connector when a charge settles, when a cycle
  /// goes unpaid, and when a plan is changed — all of which alter whether this
  /// device may keep operating. Waiting out the poll interval to notice is what
  /// makes a paid-for subscription look unpaid on the shop's other till.
  ///
  /// Same shape as `useAccessPermissionsRealtimeSync`: one channel, debounced,
  /// errors logged rather than fatal. Requires `public.plans` to be in the
  /// `supabase_realtime` publication and RLS that lets the signed-in user
  /// receive events for their business.
  ///
  /// Safe to call repeatedly; re-subscribing for the same business is a no-op.
  Future<void> startRealtimeVerification({String? businessId}) async {
    final id = businessId ?? await _activeBusinessId();
    if (id == null || id.isEmpty) {
      talker.warning(
        'Payment realtime verification not started: no active business yet',
      );
      return;
    }
    if (_planChannel != null && _watchedBusinessId == id) return;

    await stopRealtimeVerification();
    _watchedBusinessId = id;

    void onPlanChanged(PostgresChangePayload payload) {
      // Debounced: a settlement writes several columns and can arrive as more
      // than one event, and each verification is three network round trips.
      _realtimeDebounce?.cancel();
      _realtimeDebounce = Timer(const Duration(seconds: 1), () {
        unawaited(_verifyAndNotify(reason: 'plans realtime'));
      });
    }

    _planChannel = Supabase.instance.client
        .channel('payment-verification-$id')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'plans',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'business_id',
            value: id,
          ),
          callback: onPlanChanged,
        )
        .subscribe(onSupabaseChannelSubscribeStatus);

    talker.info('Payment verification watching plans for business $id');
  }

  /// Stops the realtime watch and releases the channel.
  Future<void> stopRealtimeVerification() async {
    _realtimeDebounce?.cancel();
    _realtimeDebounce = null;
    final channel = _planChannel;
    _planChannel = null;
    _watchedBusinessId = null;
    if (channel == null) return;
    try {
      await Supabase.instance.client.removeChannel(channel);
    } catch (e) {
      logSupabaseRealtimeError(e, source: 'payment verification unsubscribe');
    }
  }

  /// Verify now and tell the listener, whatever triggered it.
  ///
  /// Overlapping runs are dropped rather than queued: the next trigger reads
  /// the same state anyway, and two concurrent verifications can hand the
  /// navigator conflicting verdicts.
  Future<void> _verifyAndNotify({required String reason}) async {
    if (_verifying) {
      talker.info('Payment verification ($reason) skipped: one already running');
      return;
    }
    _verifying = true;
    try {
      final response = await verifyPaymentStatus();
      onPaymentStatusChanged?.call(response);
    } catch (e, stackTrace) {
      talker.error('Payment verification ($reason) failed', e, stackTrace);
    } finally {
      _verifying = false;
    }
  }

  /// Verify now because something outside changed — a reconnect, a resume, a
  /// payment the user just made. Nothing here assumes the caller knows the
  /// current status; it re-reads it.
  Future<void> verifyNow({String reason = 'manual'}) =>
      _verifyAndNotify(reason: reason);

  Future<String?> _activeBusinessId() async {
    try {
      final business = await ProxyService.strategy.activeBusiness().timeout(
        const Duration(seconds: 10),
      );
      return business?.id;
    } catch (e) {
      talker.warning('Payment verification could not resolve a business: $e');
      return null;
    }
  }

  /// Verifies the current business payment status
  /// Returns a detailed response that callers can use to decide what action to take
  Future<PaymentVerificationResponse> verifyPaymentStatus() async {
    debugPrint('🚀 [PaymentVerificationService] Verifying payment status...');

    try {
      final business = await ProxyService.strategy.activeBusiness().timeout(
        const Duration(seconds: 10),
      );
      if (business?.id == null) {
        talker.error('Payment verification failed: No active business found');
        return const PaymentVerificationResponse(
          result: PaymentVerificationResult.error,
          errorMessage: 'No active business found',
        );
      }

      final businessId = business!.id;
      debugPrint(
        '🚀 [PaymentVerificationService] Checking plan for business: $businessId',
      );

      // First check if a payment plan exists at all
      final plan = await ProxyService.strategy
          .getPaymentPlan(
            businessId: businessId,
            fetchOnline: true,
            preferFresh: true,
          )
          .timeout(const Duration(seconds: 15));

      if (plan == null) {
        debugPrint(
          '🚀 [PaymentVerificationService] No payment plan found for business: $businessId',
        );
        return const PaymentVerificationResponse(
          result: PaymentVerificationResult.noPlan,
          errorMessage: 'No payment plan exists for this business',
        );
      }

      debugPrint(
        '🚀 [PaymentVerificationService] Found plan, checking subscription status...',
      );

      // A plan exists, now check if it's active
      try {
        final isActive = await ProxyService.strategy
            .hasActiveSubscription(
              businessId: businessId,
              flipperHttpClient: ProxyService.http,
              fetchRemote: true,
            )
            .timeout(const Duration(seconds: 15));

        if (isActive) {
          debugPrint('🚀 [PaymentVerificationService] Subscription is active');
          return PaymentVerificationResponse(
            result: PaymentVerificationResult.active,
            plan: plan,
          );
        } else {
          debugPrint(
            '🚀 [PaymentVerificationService] Subscription is NOT active',
          );
          return PaymentVerificationResponse(
            result: PaymentVerificationResult.planExistsButInactive,
            errorMessage: 'Payment plan exists but subscription is not active',
            plan: plan,
          );
        }
      } on PaymentIncompleteException catch (e) {
        debugPrint(
          '🚀 [PaymentVerificationService] Payment incomplete/expired: $e',
        );
        return PaymentVerificationResponse(
          result: PaymentVerificationResult.planExistsButInactive,
          errorMessage: e.message,
          plan: plan,
          exception: e,
        );
      } on FailedPaymentException catch (e) {
        debugPrint('🚀 [PaymentVerificationService] Payment failed: $e');
        return PaymentVerificationResponse(
          result: PaymentVerificationResult.planExistsButInactive,
          errorMessage: e.message,
          plan: plan,
          exception: e,
        );
      } catch (e) {
        debugPrint(
          '🚀 [PaymentVerificationService] Error checking subscription status: $e',
        );
        rethrow;
      }
    } catch (e) {
      debugPrint(
        '🚀 [PaymentVerificationService] ERROR during verification: $e',
      );
      return PaymentVerificationResponse(
        result: PaymentVerificationResult.error,
        errorMessage: 'Failed to verify payment status: $e',
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
        'Forced payment verification failed: ${response.errorMessage}',
      );
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
    _verificationTimer = null; // Explicitly set to null
    unawaited(stopRealtimeVerification());
    onPaymentStatusChanged = null;
  }

  /// Returns true if the periodic verification timer is currently active.
  @visibleForTesting
  bool get isTimerActive => _verificationTimer?.isActive ?? false;

  /// Returns true while a plan row is being watched over Realtime.
  @visibleForTesting
  bool get isWatchingPlans => _planChannel != null;

  @visibleForTesting
  String? get watchedBusinessId => _watchedBusinessId;
}
