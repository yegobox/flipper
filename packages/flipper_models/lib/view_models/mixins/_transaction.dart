import 'dart:async';

import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/helperModels/sale_completion_helpers.dart';
import 'package:flipper_models/helpers/deferred_sale_receipt_persist.dart';
import 'package:flipper_models/helpers/sale_completion_collect.dart';
import 'package:flipper_models/mixins/TaxController.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/digital_receipt_service.dart';
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

    /// When true, receipt PDF is generated and uploaded but not opened/printed;
    /// SMS is sent after upload when [DigitalReceiptService.queueSmsAfterReceiptUpload] was called.
    bool sendDigitalReceipt = false,

    /// When set (e.g. POS checkout), skips [resolveCustomerForReceipt] DB lookup.
    Customer? customer,
  }) async {
    try {
      final businessId = ProxyService.box.getBusinessId();
      final branchId = ProxyService.box.getBranchId();
      if (businessId == null || branchId == null) {
        throw Exception('Business ID or Branch ID not found');
      }
      final taxEnabled = await ProxyService.getStrategy(
        Strategy.capella,
      ).isTaxEnabled(businessId: businessId, branchId: branchId);
      RwApiResponse? response;
      final ebm = await ProxyService.getStrategy(
        Strategy.capella,
      ).ebm(branchId: branchId);
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

        // Quick-selling: RRA sign → persist sale → UI success, then PDF/print.
        if (deferPersistTaxReceiptFields) {
          final completionSw = Stopwatch()..start();
          final signSw = Stopwatch()..start();
          final signOutcome = await handleReceiptGeneration(
            formKey: formKey,
            context: context,
            transaction: transaction,
            purchaseCode: purchaseCode,
            onSuccess: onSuccess,
            persistReceiptTransactionFields: false,
            sendDigitalReceipt: sendDigitalReceipt,
            signOnly: true,
            transactionItems: preloadedLineItemsForCollectPayment,
            customer: customer,
          );
          talker.debug(
            '[sale_completion_timing] rra_sign_ms=${signSw.elapsedMilliseconds}',
          );
          response = signOutcome.response;
          if (response.resultCd != "000") {
            throw Exception(response.resultMsg);
          }
          final collectSw = Stopwatch()..start();
          if (skipTransactionPersist) {
            applySalePaymentFieldsInMemory(
              transaction: transaction,
              tenderAmount: amount,
              paymentType: ProxyService.box.paymentType() ?? paymentType,
              customerName: customerNameController.text,
              countryCode: countryCodeController.text,
              preloadedLineItems: preloadedLineItemsForCollectPayment,
            );
            final items = preloadedLineItemsForCollectPayment ?? const [];
            final saleTotal = items.isEmpty
                ? amount
                : items.fold<double>(
                    0,
                    (sum, item) =>
                        sum + item.price.toDouble() * item.qty.toDouble(),
                  );
            final derived = deriveSaleCompletionState(
              transactionCashReceived: transaction.cashReceived ?? 0,
              finalSubTotal: saleTotal,
              paymentMethods: [
                PaymentLineForSaleCompletion(
                  amount: amount,
                  method: paymentType,
                ),
              ],
            );
            scheduleDeferredSaleCollectSideEffects(
              transaction: transaction,
              branchId: branchId,
              bhfId: ebm.bhfId,
              items: items,
              completionStatus: derived.status,
              isProformaMode: ProxyService.box.isProformaMode(),
              isTrainingMode: ProxyService.box.isTrainingMode(),
            );
            ProxyService.box.remove(key: 'pendingCustomerName');
            ProxyService.box.remove(key: 'pendingCustomerTin');
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
          talker.debug(
            '[sale_completion_timing] collect_payment_ms=${collectSw.elapsedMilliseconds}',
          );
          final onCompleteSw = Stopwatch()..start();
          await _awaitPossibleFuture(onComplete());
          talker.debug(
            '[sale_completion_timing] on_complete_ms=${onCompleteSw.elapsedMilliseconds}',
          );

          // Print before heavy Ditto writes (createReceipt/updateCounters) so PDF
          // generation is not stuck behind a congested store queue.
          final printSw = Stopwatch()..start();
          try {
            await _presentReceiptAfterSale(
              formKey: formKey,
              context: context,
              transaction: transaction,
              signedResponse: response,
              purchaseCode: purchaseCode,
              sendDigitalReceipt: sendDigitalReceipt,
              transactionItems: preloadedLineItemsForCollectPayment,
              presentationReceipt: signOutcome.presentationReceipt,
            );
          } catch (e, s) {
            talker.error('Receipt print after sale failed: $e', s);
          }
          talker.debug(
            '[sale_completion_timing] present_receipt_ms=${printSw.elapsedMilliseconds}',
          );

          scheduleDeferredSaleReceiptPersist(signOutcome.deferredPersist);
          talker.debug(
            '[sale_completion_timing] finalize_payment_quick_sell_ms='
            '${completionSw.elapsedMilliseconds}',
          );
          return response;
        }

        final receiptOutcome = await handleReceiptGeneration(
          formKey: formKey,
          context: context,
          transaction: transaction,
          purchaseCode: purchaseCode,
          onSuccess: onSuccess,
          persistReceiptTransactionFields: !deferPersistTaxReceiptFields,
          sendDigitalReceipt: sendDigitalReceipt,
          transactionItems: preloadedLineItemsForCollectPayment,
          customer: customer,
        );
        response = receiptOutcome.response;
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

  Future<
    ({
      RwApiResponse response,
      DeferredSaleReceiptPersist? deferredPersist,
      Receipt? presentationReceipt,
    })
  >
  handleReceiptGeneration({
    String? purchaseCode,
    ITransaction? transaction,
    required GlobalKey<FormState> formKey,
    void Function()? onSuccess,
    required BuildContext context,
    bool persistReceiptTransactionFields = true,
    bool sendDigitalReceipt = false,
    bool signOnly = false,
    bool presentationOnly = false,
    RwApiResponse? signedResponse,
    List<TransactionItem>? transactionItems,
    Receipt? presentationReceiptForPdf,
    Customer? customer,
  }) async {
    try {
      if (sendDigitalReceipt && !presentationOnly) {
        await DigitalReceiptService.queueSmsAfterReceiptUpload(transaction!.id);
      }

      final responseFrom = await TaxController(object: transaction!)
          .handleReceipt(
            purchaseCode: purchaseCode,
            filterType: getFilterType(transactionType: transaction.receiptType),
            onSuccess: onSuccess,
            persistReceiptTransactionFields: persistReceiptTransactionFields,
            skipPresentation: sendDigitalReceipt,
            signOnly: signOnly,
            presentationOnly: presentationOnly,
            signedResponse: signedResponse,
            transactionItems: transactionItems,
            presentationReceiptForPdf: presentationReceiptForPdf,
            customer: customer,
          );
      final (:response, :bytes, :deferredPersist, :presentationReceipt) =
          responseFrom;

      if (!signOnly) {
        try {
          formKey.currentState?.reset();
        } catch (_) {}

        if (bytes != null && !sendDigitalReceipt) {
          await printing(bytes, context);
        }
      }
      return (
        response: response,
        deferredPersist: deferredPersist,
        presentationReceipt: presentationReceipt,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _presentReceiptAfterSale({
    required GlobalKey<FormState> formKey,
    required BuildContext context,
    required ITransaction transaction,
    required RwApiResponse signedResponse,
    String? purchaseCode,
    required bool sendDigitalReceipt,
    List<TransactionItem>? transactionItems,
    Receipt? presentationReceipt,
  }) async {
    try {
      final responseFrom = await TaxController(object: transaction)
          .handleReceipt(
            purchaseCode: purchaseCode,
            filterType: getFilterType(transactionType: transaction.receiptType),
            persistReceiptTransactionFields: false,
            skipPresentation: sendDigitalReceipt,
            presentationOnly: true,
            signedResponse: signedResponse,
            transactionItems: transactionItems,
            presentationReceiptForPdf: presentationReceipt,
          );
      final bytes = responseFrom.bytes;
      if (!context.mounted) return;
      try {
        formKey.currentState?.reset();
      } catch (_) {}
      if (bytes != null && !sendDigitalReceipt) {
        await printing(bytes, context);
      }
    } catch (e, s) {
      talker.error('Deferred receipt print failed: $e', s);
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

    Business? business = await ProxyService.getStrategy(
      Strategy.capella,
    ).getBusiness(businessId: businessId);

    final bool isEbmEnabled = await ProxyService.getStrategy(
      Strategy.capella,
    ).isTaxEnabled(businessId: business!.id, branchId: branchId);
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
      if (transaction.customerId != null &&
          transaction.customerId!.isNotEmpty &&
          transaction.customerTin != null &&
          transaction.customerTin!.isNotEmpty) {
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

      // NOTE: do NOT mutate transaction.isLoan here. Setting it before
      // collectPayment forces its loan branch, which changes cashReceived /
      // lastPaymentDate handling and breaks the parked-as-loan completion
      // derived later by markTransactionAsCompleted. The parked status alone
      // signals the loan; the journal poster and customer linker derive
      // loan-ness from completionStatus (see PosJournalPoster / LoanCustomerLinker).

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
