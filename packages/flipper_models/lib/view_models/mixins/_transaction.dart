import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/isolateHandelr.dart';
import 'package:flipper_models/mixins/TaxController.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/keypad_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'dart:typed_data';

import 'package:flutter/material.dart';

// adjust if needed

mixin TransactionMixinOld {
  final KeyPadService keypad = getIt<KeyPadService>();

  final talker = Talker();

  Future<RwApiResponse> finalizePayment(
      {String? purchaseCode,
      required String paymentType,
      required ITransaction transaction,
      String? categoryId,
      required String transactionType,
      required double amount,
      required BuildContext context,
      required GlobalKey<FormState> formKey,
      required TextEditingController customerNameController,
      required Function onComplete,
      required double discount}) async {
    try {
      final taxExanbled = await ProxyService.strategy
          .isTaxEnabled(businessId: ProxyService.box.getBusinessId()!);
      RwApiResponse? response;
      final ebm = await ProxyService.strategy
          .ebm(branchId: ProxyService.box.getBranchId()!);
      final hasUser = (await ProxyService.box.bhfId()) != null;
      final isTaxServiceStoped = ProxyService.box.stopTaxService() ?? false;

      /// update transaction type

      if (taxExanbled &&
          ebm?.taxServerUrl != null &&
          hasUser &&
          !isTaxServiceStoped) {
        ProxyService.box.writeString(
          key: "getServerUrl",
          value: ebm!.taxServerUrl,
        );
        ProxyService.box.writeString(
          key: "bhfId",
          value: ebm.bhfId,
        );
        response = await handleReceiptGeneration(
          formKey: formKey,
          context: context,
          transaction: transaction,
          purchaseCode: purchaseCode,
        );
        if (response.resultCd != "000") {
          throw Exception("Invalid response from server");
        }

        // Only complete the transaction after successful tax service response
        await _completeTransactionAfterTaxValidation(transaction,
            customerName: customerNameController.text);

        onComplete();
      } else {
        // For non-tax enabled scenarios, complete the transaction here
        await _completeTransactionAfterTaxValidation(transaction,
            customerName: customerNameController.text);
        onComplete();
      }

      if (response == null) {
        return RwApiResponse(resultCd: "001", resultMsg: "Sale completed");
      }
      return response;
    } catch (e) {
      talker.error('Error in finalizePayment: $e');
      rethrow;
    } finally {
      // Always call onComplete to ensure the loading state is reset
      // This ensures the pay button stops loading even if there's an error
      onComplete();
    }
  }

  Future<void> printing(Uint8List? bytes, BuildContext context) async {
    if (Platform.isAndroid || Platform.isIOS) {
      print("can't direct pring on ios, android using direct printer.");
    } else {
      final printers = await Printing.listPrinters();
      //
      if (printers.isNotEmpty) {
        Printer? pri = await Printing.pickPrinter(
            context: context, title: "List of printers");
        if (bytes == null) {
          return;
        }

        await Printing.directPrintPdf(
            printer: pri!, onLayout: (PdfPageFormat format) async => bytes);
      }
    }
  }

  FilterType getFilterType({required String transactionType}) {
    if (ProxyService.box.isProformaMode()) {
      return FilterType.PS;
    } else if (ProxyService.box.isTrainingMode()) {
      return FilterType.TS;
    } else {
      return FilterType.NS;
    }
  }

  Future<RwApiResponse> handleReceiptGeneration(
      {String? purchaseCode,
      ITransaction? transaction,
      required GlobalKey<FormState> formKey,
      required BuildContext context}) async {
    try {
      final responseFrom =
          await TaxController(object: transaction!).handleReceipt(
        purchaseCode: purchaseCode,
        filterType:
            getFilterType(transactionType: transaction.receiptType ?? "NS"),
      );
      final (:response, :bytes) = responseFrom;

      formKey.currentState?.reset();

      if (bytes != null) {
        await printing(bytes, context);
      }
      return response;
    } catch (e) {
      rethrow;
    }
  }

  ///  combines the `saveTransaction` and  `ProxyService.strategy.updateTransaction` calls into a single, more streamlined function

  ///Completes the transaction
  Future<void> completeTransaction({
    required ITransaction pendingTransaction,
    String? sarTyCd,
  }) async {
    await _completeTransaction(
        pendingTransaction: pendingTransaction, sarTyCd: sarTyCd);
  }

  Future<void> _completeTransaction({
    required ITransaction pendingTransaction,
    String? sarTyCd,
  }) async {
    Business? business = await ProxyService.strategy
        .getBusiness(businessId: ProxyService.box.getBusinessId()!);

    final bool isEbmEnabled = await ProxyService.strategy
        .isTaxEnabled(businessId: business!.serverId);
    if (isEbmEnabled) {
      try {
        ProxyService.strategy.updateTransaction(
            sarTyCd: sarTyCd,
            isUnclassfied: true,
            transaction: pendingTransaction,
            status: COMPLETE,
            ebmSynced: false);
        final tinNumber = ProxyService.box.tin();
        final bhfId = await ProxyService.box.bhfId();
        PatchTransactionItem.patchTransactionItem(
          tinNumber: tinNumber,
          bhfId: bhfId!,
          URI: (await ProxyService.box.getServerUrl())!,
          sendPort: (message) {
            ProxyService.notification.sendLocalNotification(body: "Stock IO");
          },
        );
      } catch (e) {
        // Rethrow the error instead of silently catching it
        // This ensures the transaction isn't marked as complete when there's an error
        talker.error('Error completing transaction: $e');
        rethrow;
      }
    }
  }

  /// Completes the transaction after tax validation has succeeded
  /// This ensures we only mark the transaction as complete after we've received
  /// a successful response from the tax service
  Future<void> _completeTransactionAfterTaxValidation(ITransaction transaction,
      {required String customerName}) async {
    try {
      final bhfId = (await ProxyService.box.bhfId()) ?? "00";
      final amount = double.tryParse(
              ProxyService.box.readString(key: 'receivedAmount') ?? "0") ??
          0;
      final discount = double.tryParse(
              ProxyService.box.readString(key: 'discountRate') ?? "0") ??
          0;
      final paymentType = ProxyService.box.paymentType() ?? "CASH";
      final transactionType = transaction.receiptType ?? TransactionType.sale;
      Customer? customer = (await ProxyService.strategy.customers(
              id: transaction.customerId,
              branchId: ProxyService.box.getBranchId()!))
          .firstOrNull;
      // First collect the payment
      ProxyService.strategy.collectPayment(
        branchId: ProxyService.box.getBranchId()!,
        isProformaMode: ProxyService.box.isProformaMode(),
        isTrainingMode: ProxyService.box.isTrainingMode(),
        bhfId: bhfId,
        customerName: customer == null
            ? ProxyService.box.customerName() ?? "N/A"
            : customerName,
        customerTin: customer == null
            ? ProxyService.box.currentSaleCustomerPhoneNumber()
            : customer.custTin,
        cashReceived: amount,
        transaction: transaction,
        categoryId: transaction.categoryId,
        transactionType: transactionType,
        isIncome: true,
        paymentType: paymentType,
        discount: discount,
        directlyHandleReceipt: false,
      );
      // final tinNumber = ProxyService.box.tin();
      // Clean up temporary storage
      ProxyService.box.remove(key: 'pendingCustomerName');
      ProxyService.box.remove(key: 'pendingCustomerTin');

      talker.debug(
          'Transaction ${transaction.id} completed successfully after tax validation');
    } catch (e) {
      talker.error('Error in _completeTransactionAfterTaxValidation: $e');
      rethrow;
    }
  }
}
