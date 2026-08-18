import 'package:flipper_hr/features/billing/application/hr_billing_providers.dart';
import 'package:flipper_hr/features/billing/data/hr_billing_repository.dart';
import 'package:flipper_hr/features/billing/data/hr_entitlement.dart';
import 'package:flipper_hr/features/billing/data/hr_momo_gateway.dart';
import 'package:flipper_hr/features/billing/data/hr_msisdn.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// How often the request-to-pay status is read. Matches Books' cadence;
/// shrunk to milliseconds in tests.
final hrMomoPollIntervalProvider = Provider<Duration>(
  (ref) => const Duration(seconds: 6),
);

/// How long to wait for the payer's PIN before giving up on the *poll*. The
/// payment itself may still settle afterwards, which is why the timeout wording
/// never says it failed.
final hrMomoPollTimeoutProvider = Provider<Duration>(
  (ref) => const Duration(minutes: 5),
);

/// Where one subscription purchase has got to.
enum HrPaymentStage {
  idle,

  /// Pricing the plan and writing the plan row.
  preparing,

  /// The push is out; the payer has to approve it on their handset.
  awaitingApproval,

  /// MTN settled it, and the plan is paid.
  confirmed,
  failed,

  /// Still unresolved when the poll window closed.
  timedOut,
}

class HrPaymentState {
  const HrPaymentState({
    this.stage = HrPaymentStage.idle,
    this.planId,
    this.reference,
    this.amountRwf = 0,
    this.message,
  });

  final HrPaymentStage stage;
  final String? planId;
  final String? reference;
  final int amountRwf;

  /// What to tell the user — an error while failed, progress otherwise.
  final String? message;

  bool get isBusy =>
      stage == HrPaymentStage.preparing ||
      stage == HrPaymentStage.awaitingApproval;

  HrPaymentState copyWith({
    HrPaymentStage? stage,
    String? planId,
    String? reference,
    int? amountRwf,
    String? message,
    bool clearMessage = false,
  }) {
    return HrPaymentState(
      stage: stage ?? this.stage,
      planId: planId ?? this.planId,
      reference: reference ?? this.reference,
      amountRwf: amountRwf ?? this.amountRwf,
      message: clearMessage ? null : (message ?? this.message),
    );
  }
}

/// Drives one subscription purchase: price it server-side, write the plan row,
/// charge it, then poll until MTN gives a verdict or the window closes.
///
/// The amount is never chosen here. `hr_start_subscription()` writes the price
/// onto the plan row and data-connector charges what the plan says, so the only
/// thing this controller contributes to the figure is showing it.
class HrSubscriptionController extends Notifier<HrPaymentState> {
  bool _disposed = false;

  @override
  HrPaymentState build() {
    ref.onDispose(() => _disposed = true);
    return const HrPaymentState();
  }

  /// Writes only while alive. Leaving the paywall mid-poll disposes this
  /// notifier; the charge continues server-side and the next entitlement read
  /// finds it settled.
  void _set(HrPaymentState next) {
    if (_disposed) return;
    state = next;
  }

  void reset() => _set(const HrPaymentState());

  Future<void> pay({
    required String businessId,
    required String phoneNumber,
    String slug = 'basic',
    bool isYearly = false,
  }) async {
    if (state.isBusy) return;

    if (!HrMsisdn.isValid(phoneNumber)) {
      _set(
        const HrPaymentState(
          stage: HrPaymentStage.failed,
          message: 'Enter a valid MTN or Airtel number, e.g. 0788123456.',
        ),
      );
      return;
    }

    _set(
      const HrPaymentState(
        stage: HrPaymentStage.preparing,
        message: 'Preparing your subscription…',
      ),
    );

    final HrSubscriptionStart start;
    try {
      start = await ref
          .read(hrBillingRepositoryProvider)
          .startSubscription(
            businessId: businessId,
            slug: slug,
            isYearly: isYearly,
            phoneNumber: phoneNumber,
          );
    } on HrBillingSchemaMissing catch (e) {
      _set(
        HrPaymentState(stage: HrPaymentStage.failed, message: e.toString()),
      );
      return;
    } on HrBillingException catch (e) {
      _set(HrPaymentState(stage: HrPaymentStage.failed, message: e.message));
      return;
    } catch (e) {
      _set(
        HrPaymentState(
          stage: HrPaymentStage.failed,
          message: 'Could not start the subscription: $e',
        ),
      );
      return;
    }

    // Already paid — somebody settled it on another device while this screen was
    // open. Charging again would take a second month's money for nothing.
    if (start.alreadyActive) {
      await _refreshAccess(businessId);
      _set(
        HrPaymentState(
          stage: HrPaymentStage.confirmed,
          planId: start.planId,
          amountRwf: start.amountRwf,
          message: 'This subscription is already active.',
        ),
      );
      return;
    }

    _set(
      state.copyWith(
        planId: start.planId,
        amountRwf: start.amountRwf,
        message: 'Sending the request to your phone…',
      ),
    );

    final String reference;
    try {
      reference = await ref
          .read(hrMomoGatewayProvider)
          .payPlan(
            planId: start.planId,
            businessId: businessId,
            phoneNumber: phoneNumber,
            amountRwf: start.amountRwf,
          );
    } on HrMomoException catch (e) {
      _set(state.copyWith(stage: HrPaymentStage.failed, message: e.message));
      return;
    } catch (e) {
      _set(
        state.copyWith(
          stage: HrPaymentStage.failed,
          message: 'The payment could not be started: $e',
        ),
      );
      return;
    }

    _set(
      state.copyWith(
        stage: HrPaymentStage.awaitingApproval,
        reference: reference,
        message: 'Approve the Mobile Money request on your phone.',
      ),
    );

    await _pollUntilSettled(
      businessId: businessId,
      planId: start.planId,
      reference: reference,
    );
  }

  Future<void> _pollUntilSettled({
    required String businessId,
    required String planId,
    required String reference,
  }) async {
    final gateway = ref.read(hrMomoGatewayProvider);
    final interval = ref.read(hrMomoPollIntervalProvider);
    final deadline = DateTime.now().add(ref.read(hrMomoPollTimeoutProvider));

    while (!_disposed && DateTime.now().isBefore(deadline)) {
      await Future<void>.delayed(interval);
      if (_disposed) return;

      HrMomoSettlement settlement;
      try {
        settlement = await gateway.status(reference);
      } catch (_) {
        // A failed *read* is not a failed payment — the connection may simply
        // have blinked. Keep polling until the deadline.
        continue;
      }

      // A pending status can still carry an explanation, and when it does it is
      // usually the reason no prompt will ever arrive: a gateway that could not
      // reach MTN reports PENDING with the transport error attached. Keep
      // polling, but stop hiding it — five silent minutes waiting for a push
      // that was never sent looks exactly like a slow payer.
      final reason = settlement.reason?.trim();
      if (settlement.isPending && reason != null && reason.isNotEmpty) {
        _set(state.copyWith(message: reason));
      }

      if (settlement.isSuccessful) {
        // Nudge the backend to settle the plan row now rather than on its next
        // sweep, then re-read entitlement so the roster opens on this device.
        await gateway.finalizeOnSuccess(planId: planId, reference: reference);
        await _refreshAccess(businessId);
        _set(
          state.copyWith(
            stage: HrPaymentStage.confirmed,
            message: 'Payment received. Your subscription is active.',
          ),
        );
        return;
      }

      if (settlement.status == HrMomoStatus.failed) {
        _set(
          state.copyWith(
            stage: HrPaymentStage.failed,
            message: reason == null || reason.isEmpty
                ? 'The payment was not completed on your phone.'
                : reason,
          ),
        );
        return;
      }
    }

    _set(
      state.copyWith(
        stage: HrPaymentStage.timedOut,
        message:
            'We have not had a verdict from Mobile Money yet. If you approved '
            'the request, it will unlock shortly — check again in a moment.',
      ),
    );
  }

  /// Re-reads entitlement for [businessId] and waits for the new value, so the
  /// screen that follows a payment is never rendered against the pre-payment
  /// answer.
  Future<void> _refreshAccess(String businessId) async {
    ref.invalidate(hrAccessStateProvider(businessId));
    try {
      await ref.read(hrAccessStateProvider(businessId).future);
    } catch (_) {
      // The paywall's own retry covers this; a failed refresh must not turn a
      // settled payment into an error.
    }
  }
}

final hrSubscriptionControllerProvider =
    NotifierProvider<HrSubscriptionController, HrPaymentState>(
      HrSubscriptionController.new,
      isAutoDispose: true,
    );
