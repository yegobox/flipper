import 'dart:io';
import 'dart:math' as math;

import 'package:flipper_models/helperModels/talker.dart';
import 'package:flutter/foundation.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:supabase_models/brick/models/all_models.dart' as brick;
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/mixins/transaction_delegation_mixin.dart';
import 'package:uuid/uuid.dart';
import 'package:receipt/print.dart';

class TaxController<OBJ> with TransactionDelegationMixin {
  TaxController({this.object});

  OBJ? object;

  /// Implement the createTaxController method required by the mixin
  @override
  dynamic createTaxController(ITransaction transaction) {
    return TaxController<ITransaction>(object: transaction);
  }

  Future<({RwApiResponse response, Uint8List? bytes})> handleReceipt(
      {bool skiGenerateRRAReceiptSignature = false,
      String? purchaseCode,
      required FilterType filterType}) async {
    if (object is ITransaction) {
      ITransaction transaction = object as ITransaction;
      if (filterType == FilterType.CR) {
        try {
          return await printReceipt(
            receiptType: TransactionReceptType.CR,
            transaction: transaction,
            originalInvoiceNumber: transaction.invoiceNumber,
            salesSttsCd: SalesSttsCd.approved,
            purchaseCode: purchaseCode,
            // sarTyCd: StockInOutType.stockMovementIn,
            skiGenerateRRAReceiptSignature: skiGenerateRRAReceiptSignature,
          );
        } catch (e) {
          rethrow;
        }
      } else if (filterType == FilterType.NS) {
        try {
          return await printReceipt(
            receiptType: TransactionReceptType.NS,
            transaction: transaction,
            salesSttsCd: SalesSttsCd.approved,
            sarTyCd: StockInOutType.sale,
            purchaseCode: purchaseCode,
            skiGenerateRRAReceiptSignature: skiGenerateRRAReceiptSignature,
          );
        } catch (e) {
          rethrow;
        }
      } else if (filterType == FilterType.NR) {
        try {
          return await printReceipt(
            purchaseCode: purchaseCode,
            receiptType: TransactionReceptType.NR,
            sarTyCd: StockInOutType.returnIn,
            transaction: transaction,
            originalInvoiceNumber: transaction.invoiceNumber,
            salesSttsCd: SalesSttsCd.refunded,
            skiGenerateRRAReceiptSignature: skiGenerateRRAReceiptSignature,
          );
        } catch (e) {
          rethrow;
        }
      } else if (filterType == FilterType.TS) {
        try {
          return await printReceipt(
            purchaseCode: purchaseCode,
            receiptType: TransactionReceptType.TS,
            transaction: transaction,
            salesSttsCd: SalesSttsCd.approved,
            sarTyCd: StockInOutType.sale,
            skiGenerateRRAReceiptSignature: skiGenerateRRAReceiptSignature,
          );
        } catch (e) {
          rethrow;
        }
      } else if (filterType == FilterType.PS) {
        try {
          return await printReceipt(
            purchaseCode: purchaseCode,
            receiptType: TransactionReceptType.PS,
            transaction: transaction,
            sarTyCd: StockInOutType.sale,
            salesSttsCd: SalesSttsCd.approved,
            skiGenerateRRAReceiptSignature: skiGenerateRRAReceiptSignature,
          );
        } catch (e) {
          rethrow;
        }
      } else if (filterType == FilterType.TR) {
        try {
          return await printReceipt(
            purchaseCode: purchaseCode,
            originalInvoiceNumber: transaction.invoiceNumber,
            receiptType: TransactionReceptType.TR,
            transaction: transaction,
            salesSttsCd: SalesSttsCd.refunded,
            sarTyCd: StockInOutType.returnIn,
            skiGenerateRRAReceiptSignature: skiGenerateRRAReceiptSignature,
          );
        } catch (e) {
          rethrow;
        }
      } else if (filterType == FilterType.CS) {
        try {
          return await printReceipt(
            purchaseCode: purchaseCode,
            receiptType: TransactionReceptType.CS,
            salesSttsCd: SalesSttsCd.approved,
            transaction: transaction,
            originalInvoiceNumber: transaction.invoiceNumber,
            skiGenerateRRAReceiptSignature: skiGenerateRRAReceiptSignature,
          );
        } catch (e) {
          rethrow;
        }
      }
    }
    throw Exception("Invalid action");
  }

  void handleNotificationMessaging(Object e) {
    String errorMessage = e.toString();
    int startIndex = errorMessage.indexOf(': ');
    if (startIndex != -1) {
      errorMessage = errorMessage.substring(startIndex + 2);
    }
    ProxyService.notie.sendData(
      errorMessage,
    );
  }

  double calculateTotalTax(double tax, Configurations config) {
    final percentage = config.taxPercentage ?? 0;
    // For TT tax type, use the standard formula: (amount * rate) / (100 + rate)
    if (config.taxType == "TT") {
      return (tax * percentage) / (100 + percentage);
    }
    // For tax type B, use the specific 18/118 formula
    if (config.taxType == "B") {
      return (tax * 18) / 118;
    }
    // For other tax types, use the standard formula
    return (tax * percentage) / (100 + percentage);
  }

  /**
   * Prints a receipt for the given transaction.
   * 
   * On mobile devices, if delegation is enabled and EBM server is not accessible,
   * the transaction will be delegated to desktop for processing.
   * 
   * @params items - The list of transaction items. 
   * @params business - The business this transaction is for.
   * @params receiptType - The type of receipt to print.
   * @params transaction - The transaction to print a receipt for.
   */
  Future<({RwApiResponse response, Uint8List? bytes})> printReceipt({
    required String receiptType,
    required ITransaction transaction,
    String? purchaseCode,
    required String salesSttsCd,
    bool skiGenerateRRAReceiptSignature = false,
    int? originalInvoiceNumber,
    String? sarTyCd,
    List<TransactionItem>? items,
  }) async {
    // Use provided items or fetch transaction items
    List<TransactionItem> transactionItems = items ?? [];
    if (transactionItems.isEmpty) {
      try {
        transactionItems = await ProxyService.strategy.transactionItems(
          transactionId: transaction.id,
          branchId: (await ProxyService.strategy.activeBranch()).id,
        );
      } catch (e) {
        // If we can't fetch items, continue with empty list for delegation
        talker.warning('Could not fetch transaction items: $e');
      }
    }

    // Try normal processing first
    try {
      // Normal processing (desktop or mobile)
      RwApiResponse responses;
      Uint8List? bytes;
      if (!skiGenerateRRAReceiptSignature) {
        try {
          //
          if (await isDelegationEnabled() && isMobileDevice) {
            throw Exception("Delegation enabled, skipping local processing");
          }
          responses = await generateRRAReceiptSignature(
            transaction: transaction,
            receiptType: receiptType,
            salesSttsCd: salesSttsCd,
            originalInvoiceNumber: originalInvoiceNumber,
            purchaseCode: purchaseCode,
            sarTyCd: sarTyCd,
          );
          // fetch same transaction

          if (responses.resultCd == "000") {
            Business? business = await ProxyService.strategy
                .getBusiness(businessId: ProxyService.box.getBusinessId()!);
            Ebm? ebm = await ProxyService.strategy
                .ebm(branchId: ProxyService.box.getBranchId()!);
            Receipt? receipt = await ProxyService.strategy
                .getReceipt(transactionId: transaction.id);

            double totalB = 0;
            double totalC = 0;
            double totalA = 0;
            double totalD = 0;
            double totalTT = 0;
            double totalDiscount = 0;

            try {
              for (var item in transactionItems) {
                // Calculate discounted price if discount rate exists and is not 0
                var discountedPrice = item.price;
                if (item.dcRt != 0) {
                  discountedPrice = item.price * (1 - item.dcRt! / 100);
                  // Calculate and add the discount amount for this item
                  var discountAmount =
                      (item.price - discountedPrice) * item.qty;
                  totalDiscount += discountAmount;
                }

                // Calculate total with discounted price * quantity
                var itemTotal = discountedPrice * item.qty;

                // Add to respective totals based on tax type code
                switch (item.taxTyCd) {
                  case "B":
                    totalB += itemTotal;
                    break;
                  case "C":
                    totalC += itemTotal;
                    break;
                  case "A":
                    totalA += itemTotal;
                    break;
                  case "D":
                    totalD += itemTotal;
                    break;
                  case "TT":
                    totalTT += itemTotal;
                    break;
                }
              }
            } catch (s) {
              rethrow;
            }

            Configurations? taxConfigTaxB =
                await ProxyService.strategy.getByTaxType(taxtype: "B");
            Configurations? taxConfigTaxA =
                await ProxyService.strategy.getByTaxType(taxtype: "A");
            Configurations? taxConfigTaxC =
                await ProxyService.strategy.getByTaxType(taxtype: "C");
            Configurations? taxConfigTaxD =
                await ProxyService.strategy.getByTaxType(taxtype: "D");
            Configurations? taxConfigTaxTT =
                await ProxyService.strategy.getByTaxType(taxtype: "TT");

            Print print = Print();

            final List<TransactionPaymentRecord> paymentTypes =
                await ProxyService.strategy
                    .getPaymentType(transactionId: transaction.id);
            await print.print(
              vatEnabled: ebm!.vatEnabled ?? false,
              taxTT: totalTT,
              totalTaxTT: calculateTotalTax(totalTT, taxConfigTaxTT!),
              customerPhone: (transaction.customerPhone?.isNotEmpty ?? false)
                  ? transaction.customerPhone
                  : ProxyService.box.currentSaleCustomerPhoneNumber(),
              totalDiscount: totalDiscount,
              whenCreated: receipt!.whenCreated!,
              timeFromServer:
                  responses.data?.vsdcRcptPbctDate?.toCompactDateTime() ??
                      receipt.timeReceivedFromserver!,
              taxB: totalB,
              taxC: totalC,
              taxA: totalA,
              taxD: totalD,
              grandTotal: transaction.subTotal!,
              totalTaxA: calculateTotalTax(totalA, taxConfigTaxA!),
              totalTaxB: calculateTotalTax(totalB, taxConfigTaxB!),
              totalTaxC: calculateTotalTax(totalC, taxConfigTaxC!),
              totalTaxD: calculateTotalTax(totalD, taxConfigTaxD!),
              currencySymbol: "RW",
              originalInvoiceNumber: originalInvoiceNumber,
              transaction: transaction,
              totalTax: (totalB * 18 / 118).toStringAsFixed(2),
              items: transactionItems,
              cash: transaction.subTotal!,
              received: transaction.cashReceived!,
              payMode: paymentTypes.isEmpty
                  ? "CASH".toPaymentType()
                  : paymentTypes.last.paymentMethod?.toPaymentType() ??
                      "CASH".toPaymentType(),
              mrc: receipt.mrcNo ?? "",
              internalData: receipt.intrlData ?? "",
              receiptQrCode: receipt.qrCode ?? "",
              receiptSignature: receipt.rcptSign ?? "",
              cashierName: business!.name!,
              sdcId: receipt.sdcId ?? "",
              invoiceNum: receipt.invcNo!,
              rcptNo: receipt.rcptNo ?? 0,
              totRcptNo: receipt.totRcptNo ?? 0,
              brandName: business.name!,
              brandAddress: business.adrs ?? "",
              brandTel: business.phoneNumber ?? "",
              brandTIN:
                  (ebm.tinNumber)
                      .toString(),
              brandDescription: business.name!,
              brandFooter: business.name!,
              emails: [business.email ?? ""],
              brandEmail: business.email ?? "info@yegobox.com",
              customerTin: (transaction.customerTin?.isNotEmpty ?? false)
                  ? transaction.customerTin
                  : ProxyService.box.customerTin(),
              receiptType: receiptType,
              customerName: (transaction.customerName?.isNotEmpty ?? false)
                  ? transaction.customerName!
                  : ProxyService.box.customerName()!,
              printCallback: (Uint8List data) {
                bytes = data;
              },
            );
            return (response: responses, bytes: bytes);
          }
          throw Exception("Invalid action");
        } catch (e) {
          rethrow;
        }
      }
      throw Exception("invalid action");
    } catch (e) {
      // If normal processing fails and we're on mobile with delegation enabled, try delegation
      if (isMobileDevice &&
          await isDelegationEnabled() &&
          !skiGenerateRRAReceiptSignature) {
        try {
          talker.warning(
              'Normal receipt processing failed, delegating to desktop: $e');

          // Delegate to desktop for processing
          await delegateTransactionToDesktop(
            transaction: transaction,
            receiptType: receiptType,
            purchaseCode: purchaseCode,
            salesSttsCd: salesSttsCd,
            originalInvoiceNumber: originalInvoiceNumber,
            sarTyCd: sarTyCd,
            items: transactionItems,
          );

          // Return a placeholder response indicating delegation
          return (
            response: RwApiResponse(
              resultCd: '001',
              resultMsg:
                  'Transaction delegated to desktop for processing after local failure',
              resultDt: DateTime.now().toIso8601String(),
            ),
            bytes: null,
          );
        } catch (delegationError) {
          // If delegation also fails, rethrow the original error
          talker.error(
              'Both normal processing and delegation failed: $e, delegation error: $delegationError');
          rethrow;
        }
      } else {
        // Not mobile or delegation not enabled, rethrow the original error
        rethrow;
      }
    }
  }

  /**
   * Generates a receipt signature by calling the EBM API, updates the receipt 
   * counter, and saves the receipt to the local database.
   * 
   * @param items - List of transaction items 
   * @param business - The business object
   * @param receiptType - Type of receipt (e.g. 'SALES')
   * @param transaction - The transaction object
  */
  Future<RwApiResponse> generateRRAReceiptSignature({
    required String receiptType,
    required ITransaction transaction,
    String? purchaseCode,
    required String salesSttsCd,
    int? originalInvoiceNumber,
    String? sarTyCd,
  }) async {
    try {
      int branchId = ProxyService.box.getBranchId()!;
      List<brick.Counter> counters = await ProxyService.strategy.getCounters(
          branchId: ProxyService.box.getBranchId()!,
          fetchRemote: !Platform.isWindows);
      // Determine the highest invoice number across all counters and use that
      // when assigning invoiceNumber. We still pass the specific `counter`
      // instance to the external tax service, but persist the highest value
      // as the invoiceNumber so it reflects the latest counter globally.
      final int highestInvcNo =
          counters.fold<int>(0, (prev, c) => math.max(prev, c.invcNo ?? 0));
      brick.Counter? counter = await ProxyService.strategy.getCounter(
          branchId: branchId,
          receiptType: receiptType,
          fetchRemote: !Platform.isWindows);
      if (counter == null) {
        // Initialize counter if it doesn't exist
        final businessId = ProxyService.box.getBusinessId();
        final bhfId = await ProxyService.box.bhfId() ?? "00";

        counter = brick.Counter(
          branchId: branchId,
          curRcptNo: 1,
          totRcptNo: 1,
          invcNo: 1,
          businessId: businessId,
          createdAt: DateTime.now().toUtc(),
          lastTouched: DateTime.now().toUtc(),
          receiptType: receiptType,
          bhfId: bhfId,
        );

        // Save the new counter to database
        await ProxyService.strategy.create<brick.Counter>(data: counter);

        // Add the new counter to the counters list for later updateCounters call
        counters.add(counter);

        talker.info(
            'Initialized new counter for receiptType: $receiptType, branchId: $branchId');
      }

      /// check if counter.curRcptNo or counter.totRcptNo is zero increment it first

      // increment the counter before we pass it in
      // this is because if we don't then the EBM counter will give us the

      // Receipt? receipt =
      //     await ProxyService.strategy.getReceipt(transactionId: transaction.id);
      DateTime now = DateTime.now();

      RwApiResponse receiptSignature =
          await ProxyService.tax.generateReceiptSignature(
        transaction: transaction,
        receiptType: receiptType,
        counter: counter,
        salesSttsCd: salesSttsCd,
        originalInvoiceNumber: originalInvoiceNumber,
        URI: await ProxyService.box.getServerUrl() ?? "",
        purchaseCode: purchaseCode,
        timeToUser: now,
        sarTyCd: sarTyCd,
      );

      if (receiptSignature.resultCd == "000" && !transaction.isExpense!) {
        String receiptNumber =
            "${receiptSignature.data?.rcptNo}/${receiptSignature.data?.totRcptNo}";
        // Convert the date string to DateTime first, then format it properly
        final dateTime =
            receiptSignature.data?.vsdcRcptPbctDate?.toCompactDateTime();
        final formattedDate =
            dateTime != null ? dateTime.toFormattedDateTime() : "";

        String qrCode = generateQRCode(formattedDate, receiptSignature,
            receiptType: receiptType, whenCreated: formattedDate);

        /// update transaction with receipt number and total receipt number

        if (receiptType == "CR" ||
            receiptType == "NR" ||
            receiptType == "TR" ||
            receiptType == "CS") {
          final newTransaction = ITransaction(
            originalTransactionId: transaction.id,
            isOriginalTransaction: false,
            receiptNumber: counter.invcNo,
            customerPhone: (transaction.customerPhone?.isNotEmpty ?? false)
                ? transaction.customerPhone!
                : ProxyService.box.currentSaleCustomerPhoneNumber(),
            totalReceiptNumber: counter.totRcptNo,
            // Use the highest invoice number across counters as requested
            invoiceNumber: highestInvcNo,
            customerName: (transaction.customerName?.isNotEmpty ?? false)
                ? transaction.customerName!
                : ProxyService.box.customerName(),
            paymentType: transaction.paymentType,
            subTotal: transaction.subTotal,
            // Adding other fields from transaction object
            reference: transaction.reference,
            categoryId: transaction.categoryId,
            transactionNumber: transaction.transactionNumber,
            branchId: transaction.branchId,
            status: COMPLETE,
            transactionType: receiptType,
            receiptType: receiptType,
            cashReceived: transaction.cashReceived,
            customerChangeDue: transaction.customerChangeDue,
            createdAt: transaction.createdAt ?? DateTime.now().toUtc(),
            updatedAt: transaction.updatedAt,
            customerId: transaction.customerId,
            customerType: transaction.customerType,
            note: transaction.note,
            lastTouched: transaction.lastTouched,
            ticketName: transaction.ticketName,
            supplierId: transaction.supplierId,
            ebmSynced: true,
            isIncome: transaction.isIncome,
            isExpense: transaction.isExpense,
            isRefunded: transaction.isRefunded,
            customerTin: (transaction.customerTin?.isNotEmpty ?? false)
                ? transaction.customerTin
                : ProxyService.box.customerTin(),
            remark: transaction.remark,
            customerBhfId: transaction.customerBhfId,
            sarTyCd: transaction.sarTyCd,
            taxAmount: transaction.taxAmount,
          );
          await ProxyService.strategy
              .addTransaction(transaction: newTransaction);
          //query item and re-assign
          final List<TransactionItem> items =
              await ProxyService.strategy.transactionItems(
            branchId: (await ProxyService.strategy.activeBranch()).id,
            transactionId: transaction.id,
          );
          // copy TransactionItem
          for (TransactionItem item in items) {
            final copy = item.copyWith(
              id: const Uuid().v4(),
              name: item.name,
              transactionId: newTransaction.id, // Update transactionId
              variantId: transaction.id, // Update variantId
            );
            // get variant
            Variant? variant =
                await ProxyService.strategy.getVariant(id: item.variantId);

            await ProxyService.strategy.addTransactionItem(
              transaction: newTransaction,
              item: copy,
              ignoreForReport: true,
              variation: variant,
              partOfComposite: item.partOfComposite ?? false,
              lastTouched: item.lastTouched ?? DateTime.now().toUtc(),
              discount: item.discount.toDouble(),
              compositePrice: item.compositePrice?.toDouble() ?? 0.0,
              quantity: item.qty.toDouble(),
              currentStock: item.remainingStock?.toDouble() ?? 0,
              name: item.name,
              amountTotal: item.totAmt?.toDouble() ?? 0.0,
            );
          }
        } else if (receiptType == "NS" ||
            receiptType == "TS" ||
            receiptType == "PS") {
          ProxyService.strategy.updateTransaction(
            transaction: transaction,
            receiptType: receiptType,
            sarNo: counter.invcNo.toString(),
            receiptNumber: counter.invcNo,
            totalReceiptNumber: counter.totRcptNo,
            // Prefer an existing transaction.invoiceNumber, otherwise use the
            // highest invoice number across counters.
            invoiceNumber: transaction.invoiceNumber ?? highestInvcNo,
            isProformaMode: ProxyService.box.isProformaMode(),
            isTrainingMode: ProxyService.box.isTrainingMode(),
          );
        }

        await saveReceipt(
            receiptSignature, transaction, qrCode, counter, receiptNumber,
            whenCreated: now, invoiceNumber: highestInvcNo);

        /// by incrementing this by 1 we get ready for next value to use so there will be no need to increment it
        /// at the time of passing in data, I have to remember to clean it in rw_tax.dart
        /// since curRcptNo need to be update when one change to keep track on current then we find all
        // Fetch the counters from the database

        ProxyService.strategy.updateCounters(
          counters: counters,
          receiptSignature: receiptSignature,
        );
      }
      return receiptSignature;
    } catch (e, s) {
      talker.info(e);
      talker.error(s);
      rethrow;
    }
  }

  Future<void> saveReceipt(
      RwApiResponse receiptSignature,
      ITransaction transaction,
      String qrCode,
      brick.Counter counter,
      String receiptType,
      {required DateTime whenCreated,
      required int invoiceNumber}) async {
    try {
      await ProxyService.strategy.createReceipt(
        signature: receiptSignature,
        transaction: transaction,
        qrCode: qrCode,
        timeReceivedFromserver: receiptSignature.data!.vsdcRcptPbctDate!,
        counter: counter,
        receiptType: receiptType,
        whenCreated: whenCreated,
        invoiceNumber: invoiceNumber,
      );
    } catch (e) {
      rethrow;
    }
  }

  String generateQRCode(String formattedDate, RwApiResponse receiptSignature,
      {required String receiptType, required String whenCreated}) {
    // No need to parse the date again, we already have it formatted correctly

    final data = receiptSignature.data;
    if (data == null) {
      return '';
    }

    final qrCodeParts = [
      formattedDate, // Already formatted without seconds
      data.sdcId ?? 'N/A',
      '${data.rcptNo ?? 'N/A'}/${data.totRcptNo ?? 'N/A'}/$receiptType',
      data.intrlData ?? 'N/A',
      data.rcptSign ?? 'N/A',
    ];

    return qrCodeParts.join('#');
  }
}
