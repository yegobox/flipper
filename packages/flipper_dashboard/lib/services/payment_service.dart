import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/momo/momo_client.dart';
import 'package:flipper_services/momo/momo_collection.dart';
import 'package:flipper_services/momo/momo_msisdn.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';

/// Matches [FailedPayment] MoMo flow: first status check after [pollInterval].
const Duration _gigMomoPollInterval = Duration(seconds: 12);
const Duration _gigMomoMaxWait = Duration(minutes: 5);

/// Outcome of gig MoMo polling (includes MTN fields for Supabase / commission).
class GigMomoSettlement {
  const GigMomoSettlement({
    required this.confirmed,
    required this.paymentReference,
    this.financialTransactionId,
    this.externalId,
    this.settledAmountRwf,
    this.refused = false,
    this.message,
  });

  final bool confirmed;
  final String paymentReference;
  final String? financialTransactionId;
  final String? externalId;
  final int? settledAmountRwf;

  /// MTN turned the payment down, or the payer rejected it. Terminal — unlike a
  /// timeout, retrying is the right thing to offer, and nothing was debited.
  final bool refused;

  /// What to tell the user. Carries the gateway's own words when it gave any;
  /// "payment failed" with no reason is what made these impossible to support.
  final String? message;

  /// The verdict will not change. A timeout is *not* terminal: the payment may
  /// still settle, so the till must not re-charge on the strength of it.
  bool get isTerminal => confirmed || refused;
}

class PaymentService {
  final BuildContext context;

  PaymentService(this.context);

  /// Branch id for payNow + requesttopay status.
  static String get mtnPayNowBranchId => MomoClient.defaultCollectionBranchId;

  /// MTN / payNow expects MSISDN digits only (no `+`, spaces, or separators).
  static String normalizeMomoMsisdn(String phoneNumber) =>
      MomoMsisdn.normalise(phoneNumber);

  /// POST payNow, then poll MTN until it gives a verdict or the window closes.
  ///
  /// [idempotencyKey] must be stable for one sale and different between two \u2014
  /// derive it from the id of whatever the customer is paying for (see
  /// [MomoIdempotency]). Without it, a second tap is a second debit.
  ///
  /// [branchId] for the status GET must match payNow (omit to use
  /// [mtnPayNowBranchId]). It used to be hardcoded to `"1"` on the status leg,
  /// which is not a branch this app has ever had.
  Future<GigMomoSettlement> waitForPaymentConfirmation({
    required String phoneNumber,
    required int finalPrice,
    required String idempotencyKey,
    String? branchId,
    String payerMessage = 'Service gig payment',
    String? customerPaymentId,
    String? transactionId,
    void Function(String reference)? onReference,
  }) async {
    final branch = (branchId != null && branchId.trim().isNotEmpty)
        ? branchId.trim()
        : mtnPayNowBranchId;
    try {
      final collection = MomoCollection(MomoClient(ProxyService.http));
      final result = await collection.collect(
        phoneNumber: phoneNumber,
        amount: finalPrice,
        paymentType: 'PaymentNormal',
        payerMessage: payerMessage,
        payeeNote: 'Pay for Goods',
        idempotencyKey: idempotencyKey,
        branchId: branch,
        customerPaymentId: customerPaymentId,
        transactionId: transactionId,
        pollInterval: _gigMomoPollInterval,
        pollTimeout: _gigMomoMaxWait,
        onReference: onReference,
      );

      if (result.isSettled) {
        return GigMomoSettlement(
          confirmed: true,
          paymentReference: result.reference!,
          financialTransactionId: result.financialTransactionId,
          externalId: result.settlement?.externalId,
          // Trust what MTN settled over what we asked for.
          settledAmountRwf: result.settledAmount ?? finalPrice,
        );
      }

      if (result.outcome == MomoCollectionOutcome.timedOut) {
        talker.warning(
          'MTN payment not confirmed within ${_gigMomoMaxWait.inMinutes} minutes '
          '(reference ${result.reference})',
        );
      }
      return GigMomoSettlement(
        confirmed: false,
        paymentReference: result.reference ?? '',
        refused: result.outcome == MomoCollectionOutcome.refused ||
            result.outcome == MomoCollectionOutcome.notStarted,
        message: result.message,
      );
    } catch (e, st) {
      talker.error('Payment confirmation failed: $e', e, st);
      return GigMomoSettlement(
        confirmed: false,
        paymentReference: '',
        message: e.toString(),
      );
    }
  }

  void handlePaymentError(dynamic error, StackTrace stackTrace) {
    if (ProxyService.box.enableDebug()!) {
      _showErrorSnackBar(stackTrace.toString());
    } else {
      String errorMessage = _formatErrorMessage(error);
      _showErrorSnackBar(errorMessage);
    }
  }

  String _formatErrorMessage(dynamic error) {
    if (error is Exception) {
      return error.toString().split('Exception: ').last;
    }
    return error.toString().split('Caught Exception: ').last;
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 10),
        backgroundColor: Colors.red,
        content: Text(message),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
        closeIconColor: Colors.red,
      ),
    );
  }
}
