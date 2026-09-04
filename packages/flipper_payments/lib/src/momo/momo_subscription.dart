import 'package:flipper_payments/src/logging.dart';
import 'package:flipper_payments/src/momo/momo_client.dart';
import 'package:flipper_payments/src/momo/momo_models.dart';
import 'package:flipper_payments/src/momo/momo_msisdn.dart';

/// How a subscription charge ended.
enum MomoSubscriptionOutcome {
  /// A request-to-pay is in flight. Poll [MomoSubscriptionResult.reference].
  charged,

  /// The payer refused the mandate, or MTN would not issue one, and the caller
  /// asked for consent to be in place first. **Nothing was debited.**
  preapprovalRefused,

  /// The gateway refused the charge itself — an amount over the configured
  /// ceiling, a cycle already paid, a plan that is not due. Nothing was debited.
  chargeRejected,
}

/// The end of one subscription charge attempt.
class MomoSubscriptionResult {
  const MomoSubscriptionResult({
    required this.outcome,
    required this.mandate,
    this.reference,
    this.initiation,
    this.message,
    this.chargedOnPinPrompt = false,
  });

  final MomoSubscriptionOutcome outcome;

  /// The consent as it stood when the decision to charge was taken.
  final MomoMandate mandate;

  /// MTN reference to poll, when something was actually submitted.
  final String? reference;

  final MomoInitiation? initiation;
  final String? message;

  /// True when the debit went out **without** a covering mandate, so MTN will
  /// prompt the payer for a PIN. Legitimate for a first payment or an upgrade —
  /// the prompt is itself the consent — but never for unattended billing.
  final bool chargedOnPinPrompt;

  bool get didCharge => outcome == MomoSubscriptionOutcome.charged;

  @override
  String toString() =>
      'MomoSubscriptionResult($outcome, ref=$reference, mandate=$mandate, '
      'pinPrompt=$chargedOnPinPrompt)';
}

/// Charges a subscription **only after consent has been established**.
///
/// The order matters and flipper-turbo got it wrong: it fired `preApprove`,
/// read nothing but the HTTP status, and charged regardless. A mandate that had
/// expired, been revoked, or been authorised for less than the new price still
/// read as "subscribed", so the debit failed with no visible reason and the
/// plan sat unpaid. Here the mandate is a real object with a state, an expiry
/// and a ceiling, and a refusal stops the charge instead of preceding it.
class MomoSubscriptionCharger {
  const MomoSubscriptionCharger(this._client);

  final MomoClient _client;

  /// How long to wait for the payer to enter their PIN on the mandate prompt.
  static const Duration defaultApprovalTimeout = Duration(seconds: 90);

  /// Establish consent, then charge.
  ///
  /// [requirePreapproval] is the hard gate. Leave it on: with it, a payer who
  /// rejects the mandate is never debited. Turning it off restores the old
  /// behaviour of charging on a PIN prompt whatever the mandate said, and is
  /// only sound for a charge the user is watching happen.
  ///
  /// [awaitApproval] controls whether we wait for the PIN on the mandate. When
  /// the payer does not get to it in time the charge still goes out with a PIN
  /// prompt — MTN asks once, and that prompt is consent — but the result says
  /// so via [MomoSubscriptionResult.chargedOnPinPrompt].
  Future<MomoSubscriptionResult> charge({
    required String phoneNumber,
    required int amount,
    required String planId,
    Object? businessId,
    String? branchId,
    int? validitySeconds,
    String payerMessage = 'Flipper Subscription',
    String payeeNote = 'Flipper Subscription',
    bool requirePreapproval = true,
    bool awaitApproval = true,
    Duration approvalTimeout = defaultApprovalTimeout,
    void Function(MomoMandate mandate)? onMandate,
  }) async {
    // 1. Ask for (or reuse) consent. Idempotent server-side: a payer who has
    //    already approved is not prompted again.
    var mandate = await _client.ensurePreapproval(
      phoneNumber: phoneNumber,
      amount: amount,
      planId: planId,
      businessId: businessId,
      branchId: branchId,
      validitySeconds: validitySeconds,
      payerMessage: payerMessage,
    );
    onMandate?.call(mandate);

    // 2. Wait for the handset, if the payer has to act.
    if (awaitApproval && !mandate.covers(amount) && !mandate.isFailed) {
      mandate = await _client.awaitPreapproval(
        mandate,
        amount: amount,
        timeout: approvalTimeout,
        onUpdate: onMandate,
      );
    }

    // 3. The gate. A refused mandate means the payer said no — do not reach for
    //    their money a second way.
    if (requirePreapproval && mandate.isFailed) {
      payLogWarning(
        'MoMo: refusing to charge ${MomoMsisdn.masked(phoneNumber)} — '
        'pre-approval ${mandate.status ?? 'failed'}: ${mandate.error}',
      );
      return MomoSubscriptionResult(
        outcome: MomoSubscriptionOutcome.preapprovalRefused,
        mandate: mandate,
        message: mandate.error ??
            'Mobile Money consent was declined, so nothing was charged. '
            'Approve the request on your phone and try again.',
      );
    }

    final onPinPrompt = !mandate.covers(amount);
    if (onPinPrompt) {
      payLogInfo(
        'MoMo: charging ${MomoMsisdn.masked(phoneNumber)} without a covering '
        'mandate (${mandate.state}); MTN will ask for a PIN',
      );
    }

    // 4. Charge. The server prices the cycle itself and ignores our amount for
    //    subscriptions, so a franc of client-side rounding cannot fail the
    //    payment the way it used to.
    try {
      final initiation = await _client.payNow(
        phoneNumber: phoneNumber,
        amount: amount,
        paymentType: 'Subscription',
        payerMessage: payerMessage,
        payeeNote: payeeNote,
        branchId: branchId,
        businessId: businessId,
        planId: planId,
      );
      return MomoSubscriptionResult(
        outcome: MomoSubscriptionOutcome.charged,
        mandate: mandate,
        reference: initiation.reference,
        initiation: initiation,
        message: initiation.message,
        chargedOnPinPrompt: onPinPrompt,
      );
    } on MomoException catch (e) {
      return MomoSubscriptionResult(
        outcome: MomoSubscriptionOutcome.chargeRejected,
        mandate: mandate,
        message: e.message,
      );
    }
  }
}
