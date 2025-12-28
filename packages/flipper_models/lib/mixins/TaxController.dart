import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/isolateHandelr.dart';
import 'package:flutter/foundation.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:supabase_models/brick/models/all_models.dart' as brick;
import 'package:flipper_services/proxy.dart';
import 'package:uuid/uuid.dart';
import 'package:receipt/print.dart';

class TaxController<OBJ> {
  TaxController({this.object});

  OBJ? object;

  Future<({RwApiResponse response, Uint8List? bytes})> handleReceipt(
      {bool skiGenerateRRAReceiptSignature = false,
      String? purchaseCode,
      void Function()? onSuccess,
      required FilterType filterType}) async {
    if (object is ITransaction) {
      ITransaction transaction = object as ITransaction;
      Customer? customer;
      try {
        customer =
            await ProxyService.strategy.customerById(transaction.customerId!);
        talker.info('Resolved customer from id: ${customer?.id}');
      } catch (e) {
        talker.warning(
            'Failed to resolve customer for id ${transaction.customerId}: $e');
      }
      // Resolve phone number with normalization and null safety
      String? rawPhone = transaction.customerPhone ??
          ProxyService.box.currentSaleCustomerPhoneNumber();
      String? custMblNo;
      if (rawPhone != null) {
        // Remove non-digit characters and trim whitespace
        custMblNo = rawPhone.trim().replaceAll(RegExp(r'\D'), '');
      } else {
        custMblNo = null;
      }

      // Resolve customer name with fallback and whitespace guard
      var name = transaction.customerName ??
          ProxyService.box.customerName() ??
          customer?.custNm ??
          '';
      name = name.trim();
      if (name.isEmpty) {
        name = 'Walk-in Customer';
      }
      String customerName = name;

      if (filterType == FilterType.CR) {
        try {
          return await printReceipt(
            custMblNo: custMblNo,
            customerName: customerName,
            customer: customer,
            receiptType: TransactionReceptType.CR,
            transaction: transaction,
            originalInvoiceNumber: transaction.invoiceNumber,
            salesSttsCd: SalesSttsCd.approved,
            purchaseCode: purchaseCode,
            // sarTyCd: StockInOutType.stockMovementIn,
            skiGenerateRRAReceiptSignature: skiGenerateRRAReceiptSignature,
            onSuccess: onSuccess,
          );
        } catch (e) {
          rethrow;
        }
      } else if (filterType == FilterType.NS) {
        try {
          return await printReceipt(
            custMblNo: custMblNo,
            customerName: customerName,
            customer: customer,
            receiptType: TransactionReceptType.NS,
            transaction: transaction,
            salesSttsCd: SalesSttsCd.approved,
            sarTyCd: StockInOutType.sale,
            purchaseCode: purchaseCode,
            skiGenerateRRAReceiptSignature: skiGenerateRRAReceiptSignature,
            onSuccess: onSuccess,
          );
        } catch (e) {
          rethrow;
        }
      } else if (filterType == FilterType.NR) {
        try {
          return await printReceipt(
            custMblNo: custMblNo,
            customerName: customerName,
            customer: customer,
            purchaseCode: purchaseCode,
            receiptType: TransactionReceptType.NR,
            sarTyCd: StockInOutType.returnIn,
            transaction: transaction,
            originalInvoiceNumber: transaction.invoiceNumber,
            salesSttsCd: SalesSttsCd.refunded,
            skiGenerateRRAReceiptSignature: skiGenerateRRAReceiptSignature,
            onSuccess: onSuccess,
          );
        } catch (e) {
          rethrow;
        }
      } else if (filterType == FilterType.TS) {
        try {
          return await printReceipt(
            custMblNo: custMblNo,
            customerName: customerName,
            customer: customer,
            purchaseCode: purchaseCode,
            receiptType: TransactionReceptType.TS,
            transaction: transaction,
            salesSttsCd: SalesSttsCd.approved,
            sarTyCd: StockInOutType.sale,
            skiGenerateRRAReceiptSignature: skiGenerateRRAReceiptSignature,
            onSuccess: onSuccess,
          );
        } catch (e) {
          rethrow;
        }
      } else if (filterType == FilterType.PS) {
        try {
          return await printReceipt(
            custMblNo: custMblNo,
            customerName: customerName,
            customer: customer,
            purchaseCode: purchaseCode,
            receiptType: TransactionReceptType.PS,
            transaction: transaction,
            sarTyCd: StockInOutType.sale,
            salesSttsCd: SalesSttsCd.approved,
            skiGenerateRRAReceiptSignature: skiGenerateRRAReceiptSignature,
            onSuccess: onSuccess,
          );
        } catch (e) {
          rethrow;
        }
      } else if (filterType == FilterType.TR) {
        try {
          return await printReceipt(
            custMblNo: custMblNo,
            customerName: customerName,
            customer: customer,
            purchaseCode: purchaseCode,
            originalInvoiceNumber: transaction.invoiceNumber,
            receiptType: TransactionReceptType.TR,
            transaction: transaction,
            salesSttsCd: SalesSttsCd.refunded,
            sarTyCd: StockInOutType.returnIn,
            skiGenerateRRAReceiptSignature: skiGenerateRRAReceiptSignature,
            onSuccess: onSuccess,
          );
        } catch (e) {
          rethrow;
        }
      } else if (filterType == FilterType.CS) {
        try {
          return await printReceipt(
            custMblNo: custMblNo,
            customerName: customerName,
            customer: customer,
            purchaseCode: purchaseCode,
            receiptType: TransactionReceptType.CS,
            salesSttsCd: SalesSttsCd.approved,
            transaction: transaction,
            originalInvoiceNumber: transaction.invoiceNumber,
            skiGenerateRRAReceiptSignature: skiGenerateRRAReceiptSignature,
            onSuccess: onSuccess,
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

  /// Check if the current device is mobile
  bool get isMobileDevice {
    return Platform.isAndroid || Platform.isIOS;
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
    String? custMblNo,
    required String customerName,
    Customer? customer,
    void Function()? onSuccess,
  }) async {
    // Use provided items or fetch transaction items
    List<TransactionItem> transactionItems = items ?? [];
    if (transactionItems.isEmpty) {
      try {
        transactionItems =
            await ProxyService.getStrategy(Strategy.capella).transactionItems(
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
      // touch the transaction unawaited
      transaction.lastPaymentDate = DateTime.now();
      transaction.createdAt = DateTime.now();
      transaction.updatedAt = DateTime.now();
      unawaited(repository.upsert(transaction));
      // Normal processing (desktop or mobile)
      RwApiResponse responses;
      Uint8List? bytes;
      if (!skiGenerateRRAReceiptSignature) {
        final enableTransactionDelegation = ProxyService.box.readBool(
          key: 'enableTransactionDelegation',
        );
        try {
          if (enableTransactionDelegation != null &&
              enableTransactionDelegation &&
              isMobileDevice) {
            return await _handleDelegationFallback(
              transaction: transaction,
              receiptType: receiptType,
              purchaseCode: purchaseCode,
              salesSttsCd: salesSttsCd,
              originalInvoiceNumber: originalInvoiceNumber,
              sarTyCd: sarTyCd,
              transactionItems: transactionItems,
              skiGenerateRRAReceiptSignature: skiGenerateRRAReceiptSignature,
              onSuccess: onSuccess,
            );
          }
          responses = await generateRRAReceiptSignature(
            custMblNo: custMblNo,
            customerName: customerName,
            customer: customer,
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
              totalTax: ebm.vatEnabled == true
                  ? (totalB * 18 / 118).toStringAsFixed(2)
                  : 0.toStringAsFixed(2),
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
              brandTIN: (ebm.tinNumber).toString(),
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
                onSuccess?.call();
              },
            );

            // Update receiptPrinted to true after successful printing
            await ProxyService.strategy.updateTransaction(
              transactionId: transaction.id,
              receiptPrinted: true,
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
      rethrow;
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
    String? custMblNo,
    required String customerName,
    Customer? customer,
  }) async {
    try {
      String branchId = ProxyService.box.getBranchId()!;
      List<brick.Counter> counters =
          await ProxyService.getStrategy(Strategy.capella).getCounters(
              branchId: ProxyService.box.getBranchId()!,
              fetchRemote: !Platform.isWindows);
      // Determine the highest invoice number across all counters and use that
      // when assigning invoiceNumber. We still pass the specific `counter`
      // instance to the external tax service, but persist the highest value
      // as the invoiceNumber so it reflects the latest counter globally.
      final int highestInvcNo =
          counters.fold<int>(0, (prev, c) => math.max(prev, c.invcNo ?? 0));

      if (counters.isEmpty) {
        throw Exception(
            'Counter not found for receiptType: $receiptType, branchId: $branchId. Counter must be properly initialized.');
      }

      /// check if counter.curRcptNo or counter.totRcptNo is zero increment it first

      // increment the counter before we pass it in
      // this is because if we don't then the EBM counter will give us the

      // Receipt? receipt =
      //     await ProxyService.strategy.getReceipt(transactionId: transaction.id);
      DateTime now = DateTime.now();

      RwApiResponse receiptSignature =
          await ProxyService.tax.generateReceiptSignature(
        custMblNo: custMblNo,
        customerName: customerName,
        customer: customer,
        transaction: transaction,
        receiptType: receiptType,
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
            agentId: transaction.agentId,
            originalTransactionId: transaction.id,
            isOriginalTransaction: false,
            receiptNumber: highestInvcNo,
            customerPhone: (transaction.customerPhone?.isNotEmpty ?? false)
                ? transaction.customerPhone!
                : ProxyService.box.currentSaleCustomerPhoneNumber(),
            totalReceiptNumber: highestInvcNo,
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
              await ProxyService.getStrategy(Strategy.capella).transactionItems(
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
            sarNo: highestInvcNo.toString(),
            receiptNumber: highestInvcNo,
            totalReceiptNumber: highestInvcNo,
            // Prefer an existing transaction.invoiceNumber, otherwise use the
            // highest invoice number across counters.
            invoiceNumber: transaction.invoiceNumber ?? highestInvcNo,
            isProformaMode: ProxyService.box.isProformaMode(),
            isTrainingMode: ProxyService.box.isTrainingMode(),
          );
        }

        await saveReceipt(
            receiptSignature, transaction, qrCode, highestInvcNo, receiptNumber,
            whenCreated: now, invoiceNumber: highestInvcNo);

        /// Ensure all counters of the same branch are synchronized
        await ProxyService.strategy.updateCounters(
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
      int highestInvcNo,
      String receiptType,
      {required DateTime whenCreated,
      required int invoiceNumber}) async {
    try {
      await ProxyService.strategy.createReceipt(
        signature: receiptSignature,
        transaction: transaction,
        qrCode: qrCode,
        timeReceivedFromserver: receiptSignature.data!.vsdcRcptPbctDate!,
        highestInvcNo: highestInvcNo,
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

  /// Handles delegation fallback when normal receipt processing fails on mobile
  ///
  /// If delegation is enabled and we're on a mobile device, this method will
  /// attempt to delegate the transaction to a desktop for processing.
  ///
  /// Returns a placeholder response if delegation succeeds, or rethrows the
  /// original error if delegation is not available or fails.
  Future<({RwApiResponse response, Uint8List? bytes})>
      _handleDelegationFallback({
    required ITransaction transaction,
    required String receiptType,
    String? purchaseCode,
    required String salesSttsCd,
    int? originalInvoiceNumber,
    String? sarTyCd,
    required List<TransactionItem> transactionItems,
    required bool skiGenerateRRAReceiptSignature,
    void Function()? onSuccess,
  }) async {
    final enableTransactionDelegation = ProxyService.box.readBool(
      key: 'enableTransactionDelegation',
    );
    if (isMobileDevice &&
        enableTransactionDelegation != null &&
        enableTransactionDelegation &&
        !skiGenerateRRAReceiptSignature) {
      try {
        await ProxyService.getStrategy(Strategy.capella).createDelegation(
          transactionId: transaction.id,
          branchId: transaction.branchId!,
          selectedDelegationDeviceId:
              ProxyService.box.selectedDelegationDeviceId(),
          receiptType: receiptType,
          customerName: transaction.customerName,
          customerTin: transaction.customerTin,
          customerBhfId: transaction.customerBhfId,
          isAutoPrint: ProxyService.box.isAutoPrintEnabled(),
          subTotal: transaction.subTotal,
          paymentType: transaction.paymentType,
          additionalData: {
            'salesSttsCd': salesSttsCd,
            'purchaseCode': purchaseCode,
            'originalInvoiceNumber': originalInvoiceNumber,
            'sarTyCd': sarTyCd,
            'businessId': ProxyService.box.getBusinessId(),
            'items': transactionItems.map((item) => item.id).toList(),
          },
        );

        /// return dummy data
        Uint8List? bytes;
        onSuccess?.call();
        return (
          response: RwApiResponse(resultCd: "000", resultMsg: "Delegated"),
          bytes: bytes
        );
      } catch (delegationError) {
        throw delegationError;
      }
    }
    throw "Invalid action";
  }
}
