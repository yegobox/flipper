import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/isolateHandelr.dart';
import 'package:flipper_models/mixins/TaxController.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/keypad_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:collection/collection.dart';

import 'package:talker_flutter/talker_flutter.dart';
import 'package:printing/printing.dart';
import 'package:flutter/foundation.dart';
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
      final bhfId = (await ProxyService.box.bhfId()) ?? "00";
      final taxExanbled = await ProxyService.strategy
          .isTaxEnabled(businessId: ProxyService.box.getBusinessId()!);
      RwApiResponse? response;
      final hasServerUrl = await ProxyService.box.getServerUrl() != null;
      final hasUser = (await ProxyService.box.bhfId()) != null;
      final isTaxServiceStoped = ProxyService.box.stopTaxService();

      /// update transaction type

      if (taxExanbled && hasServerUrl && hasUser && !isTaxServiceStoped!) {
        response = await handleReceiptGeneration(
            formKey: formKey,
            context: context,
            transaction: transaction,
            purchaseCode: purchaseCode);
        if (response.resultCd != "000") {
          throw Exception("Invalid response from server");
        } else {
          updateCustomerTransaction(
              transaction,
              bhfId: bhfId,
              customerNameController.text,
              customerNameController,
              amount,
              onComplete: onComplete,
              categoryId ?? "",
              transactionType,
              paymentType,
              discount);
        }
      } else {
        updateCustomerTransaction(
            transaction,
            bhfId: bhfId,
            customerNameController.text,
            customerNameController,
            amount,
            categoryId,
            transactionType,
            paymentType,
            onComplete: onComplete,
            discount);
      }
      if (response == null) {
        return RwApiResponse(resultCd: "001", resultMsg: "Sale completed");
      }
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateCustomerTransaction(
      ITransaction transaction,
      String customerName,
      TextEditingController customerNameController,
      double amount,
      String? categoryId,
      String transactionType,
      String paymentType,
      double discount,
      {required Function onComplete,
      required String bhfId}) async {
    await ProxyService.strategy.collectPayment(
      branchId: ProxyService.box.getBranchId()!,
      isProformaMode: ProxyService.box.isProformaMode(),
      isTrainingMode: ProxyService.box.isTrainingMode(),
      bhfId: bhfId,
      cashReceived: amount,
      transaction: transaction,
      categoryId: categoryId,
      transactionType: transactionType,
      isIncome: true,
      paymentType: paymentType,
      discount: discount,
      directlyHandleReceipt: false,
    );
    Customer? customer = (await ProxyService.strategy.customers(
            id: transaction.customerId,
            branchId: ProxyService.box.getBranchId()!))
        .firstOrNull;

    await ProxyService.strategy.updateTransaction(
      transaction: transaction,
      sarTyCd: "11",
      customerName: customer == null
          ? ProxyService.box.customerName() ?? "N/A"
          : customerNameController.text,
      customerTin: customer == null
          ? ProxyService.box.currentSaleCustomerPhoneNumber()
          : customer.custTin,
    );
  }

  Future<void> printing(Uint8List? bytes, BuildContext context) async {
    final printers = await Printing.listPrinters();

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
        filterType: getFilterType(transactionType: transaction.receiptType!),
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
        await ProxyService.strategy.updateTransaction(
            sarTyCd: sarTyCd,
            isUnclassfied: true,
            transaction: pendingTransaction,
            status: COMPLETE,
            ebmSynced: false);
        final tinNumber = ProxyService.box.tin();
        final bhfId = await ProxyService.box.bhfId();
        await PatchTransactionItem.patchTransactionItem(
          tinNumber: tinNumber,
          bhfId: bhfId!,
          URI: (await ProxyService.box.getServerUrl())!,
          sendPort: (message) {
            ProxyService.notification.sendLocalNotification(body: "Stock IO");
          },
        );
      } catch (e) {}
    }
  }
}
