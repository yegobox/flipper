

import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
class PaymentService {
  final BuildContext context;

  PaymentService(this.context);

  Future<bool> sendPaymentRequest({
    required String phoneNumber,
    required int finalPrice,
    required String branchId,
  }) async {
    try {
      await ProxyService.ht.makePayment(
        payeemessage: "Pay for Goods",
        paymentType: "PaymentNormal",
        phoneNumber: phoneNumber.replaceAll("+", ""),
        branchId: branchId,
        businessId: ProxyService.box.getBusinessId()!,
        amount: finalPrice,
        flipperHttpClient: ProxyService.http,
      );
      return true;
    } catch (e) {
      talker.error('Payment request failed: $e');
      return false;
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
    ));
  }
}