import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/HttpApi.dart';
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
  });

  final bool confirmed;
  final String paymentReference;
  final String? financialTransactionId;
  final String? externalId;
  final int? settledAmountRwf;
}

class PaymentService {
  final BuildContext context;

  PaymentService(this.context);

  /// Branch id for payNow + requesttopay status (same as [HttpApi.defaultMtnRequestToPayBranchId]).
  static String get mtnPayNowBranchId => HttpApi.defaultMtnRequestToPayBranchId;

  /// MTN / payNow expects MSISDN digits only (no `+`, spaces, or separators).
  static String normalizeMomoMsisdn(String phoneNumber) {
    var s = phoneNumber.trim();
    s = s.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    s = s.replaceAll('+', '');
    s = s.replaceAll('\uFF0B', ''); // fullwidth plus (some keyboards)
    s = s.replaceAll(RegExp(r'\D'), '');
    return s;
  }

  /// POST payNow (200/202 + [paymentReference]), then poll MTN until success or timeout.
  /// [branchId] for status GET must match payNow (omit to use [mtnPayNowBranchId]).
  Future<GigMomoSettlement> waitForPaymentConfirmation({
    required String phoneNumber,
    required int finalPrice,
    String? branchId,
  }) async {
    final branch = (branchId != null && branchId.trim().isNotEmpty)
        ? branchId.trim()
        : mtnPayNowBranchId;
    try {
      final msisdn = normalizeMomoMsisdn(phoneNumber);
      if (msisdn.length < 9) {
        talker.error(
          'Payment request failed: invalid phone (need digits only, e.g. 250783054874)',
        );
        return const GigMomoSettlement(confirmed: false, paymentReference: '');
      }
      final initiated = await ProxyService.ht.initiatePayNowWithReference(
        flipperHttpClient: ProxyService.http,
        branchId: branch,
        paymentType: 'PaymentNormal',
        payeemessage: 'Pay for Goods',
        amount: finalPrice,
        phoneNumber: msisdn,
      );
      final paymentReference = HttpApi.sanitizeMtnRequestToPayReferenceId(
        initiated.paymentReference,
      );
      if (paymentReference == null || paymentReference.isEmpty) {
        talker.error('PayNow succeeded but paymentReference was missing');
        return const GigMomoSettlement(confirmed: false, paymentReference: '');
      }

      final deadline = DateTime.now().add(_gigMomoMaxWait);
      while (DateTime.now().isBefore(deadline)) {
        await Future<void>.delayed(_gigMomoPollInterval);
        if (!DateTime.now().isBefore(deadline)) break;
        final snap = await ProxyService.ht.fetchRequestToPayHttpSnapshot(
          flipperHttpClient: ProxyService.http,
          paymentReference: paymentReference,
          branchId: "1",
        );
        if (snap != null && snap.isMtnSuccessful) {
          final settled = snap.settledAmountRwf ?? finalPrice;
          return GigMomoSettlement(
            confirmed: true,
            paymentReference: paymentReference,
            financialTransactionId: snap.financialTransactionId,
            externalId: snap.externalId,
            settledAmountRwf: settled,
          );
        }
      }
      talker.warning(
        'MTN payment not confirmed within ${_gigMomoMaxWait.inMinutes} minutes',
      );
      return GigMomoSettlement(
        confirmed: false,
        paymentReference: paymentReference,
      );
    } catch (e, st) {
      talker.error('Payment confirmation failed: $e', e, st);
      return const GigMomoSettlement(confirmed: false, paymentReference: '');
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
