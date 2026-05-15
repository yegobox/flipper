import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/helperModels/sale_completion_helpers.dart';
import 'package:flipper_models/mixins/TaxController.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/keypad_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' hide Category;
import 'package:talker_flutter/talker_flutter.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'dart:typed_data';

import 'package:flutter/material.dart';

// adjust if needed

mixin TransactionMixinOld {
  final KeyPadService keypad = getIt<KeyPadService>();

  final talker = Talker();

  Future<void> _awaitPossibleFuture(dynamic result) async {
    if (result is Future) await result;
  }

  Future<RwApiResponse> finalizePayment({
    String? purchaseCode,
    required String paymentType,
    required ITransaction transaction,
    String? categoryId,
    required String transactionType,
    required double amount,
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required TextEditingController customerNameController,
    required Function onComplete,
    required TextEditingController countryCodeController,
    void Function()? onSuccess,
    required double discount,
    List<TransactionItem>? preloadedLineItemsForCollectPayment,

    /// When true, [collectPayment] updates shift totals and in-memory fields only;
    /// the caller must persist the transaction (e.g. [markTransactionAsCompleted]).
    bool skipTransactionPersist = false,

    /// When true, tax/receipt handling does not call [updateTransaction] for receipt
    /// metadata; the completion persist should include those fields (Capella sale flow).
    bool deferPersistTaxReceiptFields = false,
  }) async {
    try {
      final businessId = ProxyService.box.getBusinessId();
      final branchId = ProxyService.box.getBranchId();
      if (businessId == null || branchId == null) {
        throw Exception('Business ID or Branch ID not found');
      }
      final taxEnabled = await ProxyService.strategy.isTaxEnabled(
        businessId: businessId,
        branchId: branchId,
      );
      RwApiResponse? response;
      final ebm = await ProxyService.strategy.ebm(branchId: branchId);
      final hasUser = (await ProxyService.box.bhfId()) != null;
      final isTaxServiceStoped = ProxyService.box.stopTaxService() ?? false;

      final isLoan = transaction.isLoan == true;
      final isFullyPaid =
          ((transaction.cashReceived ?? 0) + amount) >=
          (transaction.subTotal ?? 0);
      final shouldComplete = !isLoan || isFullyPaid;

      // Skip receipt generation entirely for loan tickets — additional payments
      // on resumed loans should never trigger a receipt.
      if (taxEnabled &&
          ebm?.taxServerUrl != null &&
          hasUser &&
          !isTaxServiceStoped &&
          !isLoan &&
          shouldComplete &&
          isFullyPaid) {
        ProxyService.box.writeString(
          key: "getServerUrl",
          value: ebm!.taxServerUrl,
        );
        ProxyService.box.writeString(key: "bhfId", value: ebm.bhfId);
        // Collect payment and complete transaction details before generating receipt

        response = await handleReceiptGeneration(
          formKey: formKey,
          context: context,
          transaction: transaction,
          purchaseCode: purchaseCode,
          onSuccess: onSuccess,
          persistReceiptTransactionFields: !deferPersistTaxReceiptFields,
        );
        if (response.resultCd != "000") {
          throw Exception(response.resultMsg);
        } else {
          await _completeTransactionAfterTaxValidation(
            transaction,
            customerName: customerNameController.text,
            countryCode: countryCodeController.text,
            preloadedLineItems: preloadedLineItemsForCollectPayment,
            tenderAmount: amount,
            skipTransactionPersist: skipTransactionPersist,
          );
        }
      } else {
        // For non-tax enabled scenarios OR partial loan payments, complete the transaction data update
        // but it won't be marked as COMPLETE in the DB yet if it's a partial loan payment
        // because collectPayment (called inside) only updates cashReceived and balance.
        await _completeTransactionAfterTaxValidation(
          transaction,
          customerName: customerNameController.text,
          countryCode: countryCodeController.text,
          preloadedLineItems: preloadedLineItemsForCollectPayment,
          tenderAmount: amount,
          skipTransactionPersist: skipTransactionPersist,
        );
      }

      if (response == null) {
        await _awaitPossibleFuture(onComplete());
        return RwApiResponse(
          resultCd: "001",
          resultMsg: isLoan && !isFullyPaid
              ? "Payment recorded"
              : "Sale completed",
        );
      }

      // Only call onComplete on success, not on error
      await _awaitPossibleFuture(onComplete());

      return response;
    } catch (e) {
      talker.error('Error in finalizePayment: $e');
      rethrow;
    }
  }

  Future<void> printing(Uint8List? bytes, BuildContext context) async {
    if (Platform.isAndroid || Platform.isIOS) {
      print("can't direct pring on ios, android using direct printer.");
    } else {
      final printers = await Printing.listPrinters();

      if (printers.isNotEmpty) {
        Printer? selectedPrinter;

        // Try to find default printer
        final String? savedPrinterName = ProxyService.box.readString(
          key: 'defaultPrinter',
        );
        if (savedPrinterName != null) {
          try {
            // Find by name
            selectedPrinter = printers.firstWhere(
              (p) => p.name == savedPrinterName,
            );
            talker.info("Using default printer: ${selectedPrinter.name}");
          } catch (e) {
            talker.warning("Default printer not found in available printers");
          }
        }

        if (selectedPrinter == null) {
          // If only one printer is available, use it by default
          if (printers.length == 1) {
            selectedPrinter = printers.first;
            talker.info(
              "Auto-selecting single available printer: ${selectedPrinter.name}",
            );
            ProxyService.box.writeString(
              key: 'defaultPrinter',
              value: selectedPrinter.name,
            );
          }
        }

        if (selectedPrinter == null) {
          // If we have context and it's mounted, ask user
          if (context.mounted) {
            selectedPrinter = await Printing.pickPrinter(
              context: context,
              title: "List of printers",
            );
            // Save as default if selected
            if (selectedPrinter != null) {
              ProxyService.box.writeString(
                key: 'defaultPrinter',
                value: selectedPrinter.name,
              );
            }
          } else {
            talker.warning(
              "Cannot pick printer: Context not mounted and no default printer.",
            );
            return;
          }
        }

        if (selectedPrinter != null && bytes != null) {
          await Printing.directPrintPdf(
            printer: selectedPrinter,
            onLayout: (PdfPageFormat format) async => bytes,
          );
        }
      }
    }
  }

  FilterType getFilterType({String? transactionType}) {
    if (transactionType == "NR") {
      return FilterType.NR;
    }
    if (transactionType == "CR") {
      return FilterType.CR;
    }
    if (transactionType == "CS") {
      return FilterType.CS;
    }
    if (transactionType == "TR") {
      return FilterType.TR;
    }
    if (ProxyService.box.isProformaMode()) {
      return FilterType.PS;
    } else if (ProxyService.box.isTrainingMode()) {
      return FilterType.TS;
    } else {
      return FilterType.NS;
    }
  }

  Future<RwApiResponse> handleReceiptGeneration({
    String? purchaseCode,
    ITransaction? transaction,
    required GlobalKey<FormState> formKey,
    void Function()? onSuccess,
    required BuildContext context,
    bool persistReceiptTransactionFields = true,
  }) async {
    try {
      // Note: This method is now called unawaited by finalizePayment.
      // We perform the heavy listing here (signing, printing).
      // If context unmounts, we try to handle gracefully.

      final responseFrom = await TaxController(object: transaction!)
          .handleReceipt(
            purchaseCode: purchaseCode,
            filterType: getFilterType(transactionType: transaction.receiptType),
            onSuccess: onSuccess,
            persistReceiptTransactionFields: persistReceiptTransactionFields,
          );
      final (:response, :bytes) = responseFrom;

      try {
        formKey.currentState?.reset();
      } catch (e) {
        // Ignore form reset error if unmounted
      }

      if (bytes != null) {
        // Run printing
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
      pendingTransaction: pendingTransaction,
      sarTyCd: sarTyCd,
    );
  }

  Future<void> _completeTransaction({
    required ITransaction pendingTransaction,
    String? sarTyCd,
  }) async {
    final businessId = ProxyService.box.getBusinessId();
    final branchId = ProxyService.box.getBranchId();
    if (businessId == null || branchId == null) {
      throw Exception('Business ID or Branch ID not found');
    }

    Business? business = await ProxyService.strategy.getBusiness(
      businessId: businessId,
    );

    final bool isEbmEnabled = await ProxyService.strategy.isTaxEnabled(
      businessId: business!.id,
      branchId: branchId,
    );
    if (isEbmEnabled) {
      try {
        await ProxyService.getStrategy(Strategy.capella).updateTransaction(
          sarTyCd: sarTyCd,
          isUnclassfied: true,
          transaction: pendingTransaction,
          status: COMPLETE,
          ebmSynced: false,
        );
      } catch (e) {
        talker.error('Error completing transaction: $e');
        rethrow;
      }
    }
  }

  /// Completes the transaction after tax validation has succeeded
  /// This ensures we only mark the transaction as complete after we've received
  /// a successful response from the tax service
  Future<void> _completeTransactionAfterTaxValidation(
    ITransaction transaction, {
    required String customerName,
    required String countryCode,
    List<TransactionItem>? preloadedLineItems,
    required double tenderAmount,
    bool skipTransactionPersist = false,
  }) async {
    try {
      final branchId = ProxyService.box.getBranchId();
      if (branchId == null) {
        throw Exception('Branch ID not found');
      }

      final bhfId = (await ProxyService.box.bhfId()) ?? "00";
      const eps = 0.0001;
      var amount = tenderAmount;
      if (amount <= eps) {
        amount =
            double.tryParse(
              ProxyService.box.readString(key: 'receivedAmount') ?? "0",
            ) ??
            0;
      }
      if (amount <= eps) {
        amount = ProxyService.box.getCashReceived() ?? 0;
      }
      final discount =
          double.tryParse(
            ProxyService.box.readString(key: 'discountRate') ?? "0",
          ) ??
          0;
      final paymentType = ProxyService.box.paymentType() ?? "CASH";
      // Domain type for Capella business logic (e.g. personal-goal sweep) must be
      // [TransactionType.sale], not [transaction.receiptType] (EBM filter codes
      // like NS/PS from [getFilterType]).
      final transactionTypeForCollect =
          transaction.transactionType ?? TransactionType.sale;
      Customer? customer;
      // Only fetch customer from DB if transaction has a valid customerId
      if (transaction.customerId != null &&
          transaction.customerId!.isNotEmpty) {
        customer = (await ProxyService.getStrategy(
          Strategy.capella,
        ).customers(id: transaction.customerId)).firstOrNull;
      }

      // Prioritize ProxyService.box.customerName() over other sources
      final finalCustomerName =
          ProxyService.box.customerName() ?? customer?.custNm ?? customerName;
      // Calculate and update tax amount before finalizing payment
      final items =
          preloadedLineItems ??
          await ProxyService.getStrategy(
            Strategy.capella,
          ).transactionItems(transactionId: transaction.id);
      double totalTax = 0.0;
      for (final item in items) {
        totalTax += item.taxAmt?.toDouble() ?? 0.0;
      }

      // Update transaction with calculated tax amount
      transaction.taxAmount = totalTax;

      // [collectPayment] runs before [onComplete] (e.g. PreviewCart's
      // [markTransactionAsCompleted]), so [transaction.status] is often still
      // pending here. Derive the same completion vs parked outcome as the cart
      // so personal-goal auto-sweep sees `completed` when appropriate.
      final saleTotalForDerived = items.isEmpty
          ? amount
          : items.fold<double>(
              0,
              (a, b) => a + (b.price.toDouble() * b.qty.toDouble()),
            );
      final derivedCompletion = deriveSaleCompletionState(
        transactionCashReceived: (transaction.cashReceived ?? 0) + amount,
        finalSubTotal: saleTotalForDerived,
        paymentMethods: [
          PaymentLineForSaleCompletion(amount: amount, method: paymentType),
        ],
      );

      // Collect payment via Capella so items are read from Ditto
      await ProxyService.getStrategy(Strategy.capella).collectPayment(
        branchId: branchId,
        isProformaMode: ProxyService.box.isProformaMode(),
        isTrainingMode: ProxyService.box.isTrainingMode(),
        countryCode: countryCode,
        bhfId: bhfId,
        customerName: finalCustomerName,
        customerTin: customer?.custTin,
        cashReceived: amount,
        transaction: transaction,
        categoryId: transaction.categoryId,
        transactionType: transactionTypeForCollect,
        isIncome: true,
        paymentType: paymentType,
        discount: discount,
        directlyHandleReceipt: false,
        customerPhone:
            customer?.telNo ??
            ProxyService.box.currentSaleCustomerPhoneNumber(),
        preloadedLineItems: items,
        skipTransactionPersist: skipTransactionPersist,
        completionStatus: derivedCompletion.status,
      );
      // Clean up temporary storage
      ProxyService.box.remove(key: 'pendingCustomerName');
      ProxyService.box.remove(key: 'pendingCustomerTin');

      talker.debug(
        'Transaction ${transaction.id} completed successfully after tax validation',
      );
    } catch (e) {
      talker.error('Error in _completeTransactionAfterTaxValidation: $e');
      rethrow;
    }
  }
}
