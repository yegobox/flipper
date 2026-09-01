import 'package:flipper_payments/src/logging.dart';
import 'package:flipper_payments/src/momo/momo_client.dart';
import 'package:flipper_payments/src/momo/momo_models.dart';
import 'package:flipper_payments/src/momo/momo_msisdn.dart';

/// How a collection ended.
enum MomoCollectionOutcome {
  /// MTN confirmed the money moved. This is the only value that may complete a
  /// sale, grant credits or mark a subscription paid.
  settled,

  /// MTN refused it, or the payer rejected it on their handset. Terminal.
  refused,

  /// The gateway never accepted the request — nothing was debited.
  notStarted,

  /// Still in flight when the poll window closed. **Not** a failure: the
  /// payment may settle minutes later, which is why the copy for this case must
  /// never say the payment failed.
  timedOut,
}

/// The end of one collection.
class MomoCollectionResult {
  const MomoCollectionResult({
    required this.outcome,
    this.reference,
    this.settlement,
    this.initiation,
    this.message,
  });

  final MomoCollectionOutcome outcome;

  /// The MTN reference. Present for everything except [MomoCollectionOutcome.notStarted],
  /// and the value to persist so an unresolved payment can be reconciled later.
  final String? reference;

  final MomoSettlement? settlement;
  final MomoInitiation? initiation;

  /// What to show the user. Carries the gateway's own words when it gave any.
  final String? message;

  bool get isSettled => outcome == MomoCollectionOutcome.settled;

  /// The verdict will not change; stop polling.
  bool get isTerminal =>
      outcome == MomoCollectionOutcome.settled ||
      outcome == MomoCollectionOutcome.refused ||
      outcome == MomoCollectionOutcome.notStarted;

  /// The amount MTN actually settled — trusted over what was requested.
  int? get settledAmount => settlement?.settledAmountRwf;

  String? get financialTransactionId => settlement?.financialTransactionId;

  @override
  String toString() =>
      'MomoCollectionResult($outcome, ref=$reference, message=$message)';
}

/// Runs one collection end to end: validate, submit, then poll until MTN gives
/// a verdict or the window closes.
///
/// Every caller in the app funnels through here so the loop is written once —
/// the previous copies each had their own cadence, their own idea of what
/// counted as failure, and none of them stopped early on a refusal.
class MomoCollection {
  const MomoCollection(this._client);

  final MomoClient _client;

  /// Matches the cadence the POS and subscription screens already used.
  static const Duration defaultPollInterval = Duration(seconds: 5);
  static const Duration defaultPollTimeout = Duration(minutes: 5);

  /// Submit and wait.
  ///
  /// [onReference] fires the moment a reference exists, before any polling.
  /// Persist it there: if the app dies mid-poll, that reference is the only way
  /// to find out whether the payer was debited.
  Future<MomoCollectionResult> collect({
    required String phoneNumber,
    required int amount,
    required String paymentType,
    required String payerMessage,
    required String payeeNote,
    required String idempotencyKey,
    String? branchId,
    Object? businessId,
    String? planId,
    String? externalId,
    String? customerPaymentId,
    String? transactionId,
    String? customerId,
    Duration pollInterval = defaultPollInterval,
    Duration pollTimeout = defaultPollTimeout,
    void Function(String reference)? onReference,
    void Function(MomoSettlement settlement)? onPoll,
  }) async {
    MomoInitiation initiation;
    try {
      initiation = await _client.payNow(
        phoneNumber: phoneNumber,
        amount: amount,
        paymentType: paymentType,
        payerMessage: payerMessage,
        payeeNote: payeeNote,
        branchId: branchId,
        businessId: businessId,
        planId: planId,
        externalId: externalId,
        idempotencyKey: idempotencyKey,
        customerPaymentId: customerPaymentId,
        transactionId: transactionId,
        customerId: customerId,
      );
    } on MomoException catch (e) {
      return MomoCollectionResult(
        outcome: MomoCollectionOutcome.notStarted,
        message: e.message,
      );
    }

    onReference?.call(initiation.reference);
    if (initiation.isDeduplicated) {
      payLogInfo(
        'MoMo: ${initiation.outcome} for ${MomoMsisdn.masked(phoneNumber)} — '
        'reusing reference ${initiation.reference}, no second debit',
      );
    }

    final settlement = await awaitSettlement(
      initiation.reference,
      branchId: branchId,
      pollInterval: pollInterval,
      pollTimeout: pollTimeout,
      onPoll: onPoll,
    );

    return _resultFor(settlement, initiation);
  }

  /// Polls an existing reference until MTN gives a verdict or [pollTimeout]
  /// elapses. Use this to resume a payment whose reference was persisted.
  Future<MomoSettlement> awaitSettlement(
    String reference, {
    String? branchId,
    Duration pollInterval = defaultPollInterval,
    Duration pollTimeout = defaultPollTimeout,
    void Function(MomoSettlement settlement)? onPoll,
  }) async {
    final deadline = DateTime.now().add(pollTimeout);
    var latest = MomoSettlement.unresolved(reference);

    while (DateTime.now().isBefore(deadline)) {
      await Future<void>.delayed(pollInterval);

      MomoSettlement settlement;
      try {
        settlement = await _client.requestToPayStatus(
          reference,
          branchId: branchId,
        );
      } catch (e) {
        // A failed *read* is not a failed payment — the till may simply be
        // offline. Keep polling until the deadline.
        payLogWarning('MoMo status read failed for $reference: $e');
        continue;
      }

      latest = settlement;
      onPoll?.call(settlement);

      // A pending status can still carry an explanation, and when it does it is
      // usually the reason no prompt will ever arrive — a gateway that could
      // not reach MTN reports PENDING with the transport error attached.
      // Surface it rather than waiting five silent minutes.
      final reason = settlement.reason?.trim();
      if (settlement.isPending && reason != null && reason.isNotEmpty) {
        payLogWarning('MoMo $reference still pending: $reason');
      }

      if (settlement.isTerminal) return settlement;
    }
    return latest;
  }

  MomoCollectionResult _resultFor(
    MomoSettlement settlement,
    MomoInitiation initiation,
  ) {
    if (settlement.isSuccessful) {
      return MomoCollectionResult(
        outcome: MomoCollectionOutcome.settled,
        reference: initiation.reference,
        settlement: settlement,
        initiation: initiation,
      );
    }
    if (settlement.isFailed) {
      return MomoCollectionResult(
        outcome: MomoCollectionOutcome.refused,
        reference: initiation.reference,
        settlement: settlement,
        initiation: initiation,
        message: settlement.reason?.isNotEmpty == true
            ? settlement.reason
            : 'The payment was not completed on the payer\'s phone.',
      );
    }
    return MomoCollectionResult(
      outcome: MomoCollectionOutcome.timedOut,
      reference: initiation.reference,
      settlement: settlement,
      initiation: initiation,
      message:
          'No confirmation yet. The payment may still go through — check the '
          'MoMo statement before charging again.',
    );
  }
}
