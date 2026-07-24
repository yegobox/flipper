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
import 'package:flipper_models/widgets/printer_picker_dialog.dart';

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

      // Ticket Review + Handover workflow (opt-in per business): when enabled, a
      // fully-paid sale is only FLAGGED paid at Pay — payment is recorded and the
      // caller's onComplete persists status `pendingReview`. Tax signing, RRA
      // receipt, fiscal counters and stock deduction are ALL deferred to the
      // Stock Manager's handover step (see [finalizeSaleForHandover] + the
      // handover action). Loan / partial / parked sales are never deferred and
      // behave exactly as today. When the setting is OFF this branch is skipped
      // and completion is byte-identical to before.
      final ticketReviewWorkflowEnabled =
          ProxyService.box.readBool(key: 'ticketReviewWorkflowEnabled') ?? false;
      final deferForReview =
          ticketReviewWorkflowEnabled && !isLoan && shouldComplete && isFullyPaid;
      talker.debug(
        '[ticket_review_workflow] finalizePayment: '
        'ticketReviewWorkflowEnabled=$ticketReviewWorkflowEnabled '
        'isLoan=$isLoan isFullyPaid=$isFullyPaid deferForReview=$deferForReview '
        'transactionId=${transaction.id}',
      );
      if (deferForReview) {
        if (skipTransactionPersist) {
          // Record payment fields in memory; onComplete persists the balances.
          applySalePaymentFieldsInMemory(
            transaction: transaction,
            tenderAmount: amount,
            paymentType: ProxyService.box.paymentType() ?? paymentType,
            customerName: customerNameController.text,
            countryCode: countryCodeController.text,
            preloadedLineItems: preloadedLineItemsForCollectPayment,
            mutateCashFields: false,
          );
          final items =
              preloadedLineItemsForCollectPayment ?? const <TransactionItem>[];
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
              PaymentLineForSaleCompletion(amount: amount, method: paymentType),
            ],
          );
          // Shift totals + personal-goal sweep (money IS collected now). This
          // does NOT sign tax or print a receipt.
          scheduleDeferredSaleCollectSideEffects(
            transaction: transaction,
            branchId: branchId,
            bhfId: (await ProxyService.box.bhfId()) ?? '',
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
        await _awaitPossibleFuture(onComplete());
        return RwApiResponse(
          resultCd: "001",
          resultMsg: "Payment recorded — pending review",
        );
      }

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
          value: ebm!.taxServerUrl!,
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
            // Do not accumulate cashReceived here — markTransactionAsCompleted
            // (onComplete) owns the authoritative loan/complete balances.
            applySalePaymentFieldsInMemory(
              transaction: transaction,
              tenderAmount: amount,
              paymentType: ProxyService.box.paymentType() ?? paymentType,
              customerName: customerNameController.text,
              countryCode: countryCodeController.text,
              preloadedLineItems: preloadedLineItemsForCollectPayment,
              mutateCashFields: false,
            );
            final items = preloadedLineItemsForCollectPayment ?? const [];
            final saleTotal = items.isEmpty
                ? amount
                : items.fold<double>(
                    0,
                    (sum, item) =>
                        sum + item.price.toDouble() * item.qty.toDouble(),
                  );
            // Prior paid is still on the row (loan cashReceived); amount is this
            // installment. Passing cashReceived+amount without prior made the
            // "yield to lower payment rows" branch drop the prior and park.
            final priorPaid = transaction.isLoan == true
                ? (transaction.cashReceived ?? 0.0)
                : 0.0;
            final derived = deriveSaleCompletionState(
              transactionCashReceived: transaction.cashReceived ?? 0,
              finalSubTotal: saleTotal,
              paymentMethods: [
                PaymentLineForSaleCompletion(
                  amount: amount,
                  method: paymentType,
                ),
              ],
              priorAlreadyPaidNonCredit: priorPaid,
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

        // Branch is not EBM-registered (or EBM/tax checks above failed for
        // another reason): there's no RRA-signed receipt to print, but the
        // sale is still a completed sale, so print a plain, non-fiscal
        // receipt instead. Only for a real, fully paid sale completion —
        // never for partial loan payments, which never got a receipt either.
        if (!isLoan && shouldComplete && isFullyPaid && !sendDigitalReceipt) {
          try {
            final items = preloadedLineItemsForCollectPayment ??
                await ProxyService.getStrategy(
                  Strategy.capella,
                ).transactionItems(transactionId: transaction.id);
            if (items.isNotEmpty) {
              final bytes = await TaxController(object: transaction)
                  .buildNonFiscalReceiptPdfBytes(
                transaction: transaction,
                transactionItems: items,
              );
              if (bytes != null) {
                try {
                  formKey.currentState?.reset();
                } catch (_) {}
                await printing(
                  bytes,
                  context,
                  transaction: transaction,
                  transactionItems: items,
                );
              }
            }
          } catch (e, s) {
            talker.error('Non-fiscal receipt print failed: $e', s);
          }
        }
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

  /// Ticket Review + Handover workflow: finalize a paid ticket at the Stock
  /// Manager's handover step — RRA sign + receipt + fiscal counters. Payment was
  /// already recorded at Pay (the ticket is in `awaitingHandover`), so this does
  /// NOT record payment, touch shift totals, or flip status. The caller runs
  /// stock deduction (dashboard side) and the status flip to COMPLETE only on
  /// success. Throws on RRA signing failure so the ticket stays awaiting handover.
  Future<RwApiResponse> finalizeSaleForHandover({
    required ITransaction transaction,
    required BuildContext context,
    required List<TransactionItem> items,
    String? purchaseCode,
  }) async {
    final businessId = ProxyService.box.getBusinessId();
    final branchId = ProxyService.box.getBranchId();
    if (businessId == null || branchId == null) {
      throw Exception('Business ID or Branch ID not found');
    }
    final taxEnabled = await ProxyService.getStrategy(
      Strategy.capella,
    ).isTaxEnabled(businessId: businessId, branchId: branchId);
    final ebm =
        await ProxyService.getStrategy(Strategy.capella).ebm(branchId: branchId);
    final hasUser = (await ProxyService.box.bhfId()) != null;
    final isTaxServiceStoped = ProxyService.box.stopTaxService() ?? false;
    final formKey = GlobalKey<FormState>();

    if (taxEnabled &&
        ebm?.taxServerUrl != null &&
        hasUser &&
        !isTaxServiceStoped) {
      ProxyService.box.writeString(key: "getServerUrl", value: ebm!.taxServerUrl!);
      ProxyService.box.writeString(key: "bhfId", value: ebm.bhfId);

      final signOutcome = await handleReceiptGeneration(
        formKey: formKey,
        context: context,
        transaction: transaction,
        purchaseCode: purchaseCode,
        persistReceiptTransactionFields: false,
        signOnly: true,
        transactionItems: items,
      );
      final response = signOutcome.response;
      if (response.resultCd != "000") {
        throw Exception(response.resultMsg);
      }
      if (context.mounted) {
        await _presentReceiptAfterSale(
          formKey: formKey,
          context: context,
          transaction: transaction,
          signedResponse: response,
          purchaseCode: purchaseCode,
          sendDigitalReceipt: false,
          transactionItems: items,
          presentationReceipt: signOutcome.presentationReceipt,
        );
      }
      scheduleDeferredSaleReceiptPersist(signOutcome.deferredPersist);
      return response;
    }

    // Branch not EBM-registered: no RRA signature, but still print a plain
    // non-fiscal receipt at handover so the customer gets a document.
    if (items.isNotEmpty && context.mounted) {
      try {
        final bytes = await TaxController(object: transaction)
            .buildNonFiscalReceiptPdfBytes(
          transaction: transaction,
          transactionItems: items,
        );
        if (bytes != null) {
          await printing(
            bytes,
            context,
            transaction: transaction,
            transactionItems: items,
          );
        }
      } catch (e, s) {
        talker.error('Non-fiscal handover receipt print failed: $e', s);
      }
    }
    return RwApiResponse(resultCd: "001", resultMsg: "Sale completed");
  }

  Future<void> printing(
    Uint8List? bytes,
    BuildContext context, {
    ITransaction? transaction,
    List<TransactionItem>? transactionItems,
  }) async {
    if (Platform.isAndroid || Platform.isIOS) {
      print("can't direct pring on ios, android using direct printer.");
    } else {
      final printers = await Printing.listPrinters();

      if (printers.isNotEmpty) {
        Printer? selectedPrinter;
        bool saveAsPdf = false;
        int copies = 1;

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
            final result = await showPrinterPickerDialog(
              context: context,
              printers: printers,
              defaultPrinterName: savedPrinterName,
              itemCount: transactionItems?.length ?? 1,
              amount: transaction?.subTotal ?? 0,
              currency: ProxyService.box.defaultCurrency(),
              invoiceNumber: transaction?.invoiceNumber,
            );
            if (result == null) {
              talker.info("Printer selection cancelled by user.");
              return;
            }
            selectedPrinter = result.printer;
            saveAsPdf = result.saveAsPdf;
            copies = result.copies;
            // Save as default if a physical printer was selected
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

        if (bytes == null) return;

        if (saveAsPdf) {
          await Printing.sharePdf(bytes: bytes, filename: 'receipt.pdf');
          return;
        }

        if (selectedPrinter != null) {
          for (var i = 0; i < copies; i++) {
            await Printing.directPrintPdf(
              printer: selectedPrinter,
              onLayout: (PdfPageFormat format) async => bytes,
            );
          }
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Sent ${copies > 1 ? '$copies copies' : '1 copy'} to ${selectedPrinter.name}',
                ),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(milliseconds: 2400),
              ),
            );
          }
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
          await printing(
            bytes,
            context,
            transaction: transaction,
            transactionItems: transactionItems,
          );
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
        await printing(
          bytes,
          context,
          transaction: transaction,
          transactionItems: transactionItems,
        );
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

      // Prefer non-empty session/typed name, then attached customer, then the
      // denormalized ticket fields (till finalize) / controller argument.
      String? nonEmpty(String? v) {
        final t = v?.trim();
        return (t == null || t.isEmpty) ? null : t;
      }

      final finalCustomerName = nonEmpty(ProxyService.box.customerName()) ??
          nonEmpty(customer?.custNm) ??
          nonEmpty(customerName) ??
          nonEmpty(transaction.customerName);
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
      // For resumed loans, cashReceived is prior paid; [amount] is this
      // installment. Do not pre-sum them into transactionCashReceived — that
      // tripped "yield to lower payment rows" and parked a fully-paid ticket.
      final priorPaidForDerived = transaction.isLoan == true
          ? (transaction.cashReceived ?? 0.0)
          : 0.0;
      final derivedCompletion = deriveSaleCompletionState(
        transactionCashReceived: transaction.cashReceived ?? 0,
        finalSubTotal: saleTotalForDerived,
        paymentMethods: [
          PaymentLineForSaleCompletion(amount: amount, method: paymentType),
        ],
        priorAlreadyPaidNonCredit: priorPaidForDerived,
      );

      // Ticket Review + Handover workflow (opt-in per business): a fully-paid
      // ticket is persisted as PENDING_REVIEW instead of COMPLETE so it stays
      // visible in the Review Queue. Payment/tax timing is unchanged — only
      // the persisted status is redirected; `derivedCompletion.status` below
      // still carries the real outcome for financial-sweep eligibility.
      final persistedCompletionStatus = applyTicketReviewWorkflowRedirect(
        derivedStatus: derivedCompletion.status,
        ticketReviewWorkflowEnabled:
            ProxyService.box.readBool(key: 'ticketReviewWorkflowEnabled') ??
                false,
      );

      // NOTE: do NOT mutate transaction.isLoan here. Setting it before
      // collectPayment forces its loan branch, which changes cashReceived /
      // lastPaymentDate handling and breaks the parked-as-loan completion
      // derived later by markTransactionAsCompleted. The parked status alone
      // signals the loan; the journal poster and customer linker derive
      // loan-ness from completionStatus (see PosJournalPoster / LoanCustomerLinker).

      // Collect payment via Capella so items are read from Ditto.
      // When the caller will persist via markTransactionAsCompleted, skip both
      // the Ditto write and in-memory cash accumulation so stale
      // remainingBalance=0 cannot leak into a later partial update.
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
        customerPhone: nonEmpty(customer?.telNo) ??
            nonEmpty(ProxyService.box.currentSaleCustomerPhoneNumber()) ??
            nonEmpty(transaction.customerPhone),
        preloadedLineItems: items,
        skipTransactionPersist: skipTransactionPersist,
        skipCashMutation: skipTransactionPersist,
        completionStatus: persistedCompletionStatus,
        financialCompletionStatus: derivedCompletion.status,
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
