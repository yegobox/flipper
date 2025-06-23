import 'dart:io';

import 'package:flipper_models/helperModels/talker.dart';
import 'package:flutter/foundation.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:supabase_models/brick/models/all_models.dart' as brick;
import 'package:flipper_services/proxy.dart';
// import 'package:cbl/cbl.dart'
//     if (dart.library.html) 'package:flipper_services/DatabaseProvider.dart';
import 'package:uuid/uuid.dart';
import 'package:receipt/print.dart';

class TaxController<OBJ> {
  TaxController({this.object});

  OBJ? object;

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
            purchaseCode: purchaseCode,
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
            transaction: transaction,
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
            skiGenerateRRAReceiptSignature: skiGenerateRRAReceiptSignature,
          );
        } catch (e) {
          rethrow;
        }
      } else if (filterType == FilterType.TR) {
        try {
          return await printReceipt(
            purchaseCode: purchaseCode,
            receiptType: TransactionReceptType.TR,
            transaction: transaction,
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
            transaction: transaction,
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
    return (tax * percentage) / 118;
  }

  /**
   * Prints a receipt for the given transaction.
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
    bool skiGenerateRRAReceiptSignature = false,
  }) async {
    RwApiResponse responses;
    Uint8List? bytes;
    if (!skiGenerateRRAReceiptSignature) {
      try {
        responses = await generateRRAReceiptSignature(
          transaction: transaction,
          receiptType: receiptType,
          purchaseCode: purchaseCode,
        );

        if (responses.resultCd == "000") {
          Business? business = await ProxyService.strategy
              .getBusiness(businessId: ProxyService.box.getBusinessId()!);
          List<TransactionItem> items =
              await ProxyService.strategy.transactionItems(
            transactionId: transaction.id,
            branchId: (await ProxyService.strategy.activeBranch()).id,
          );
          Receipt? receipt = await ProxyService.strategy
              .getReceipt(transactionId: transaction.id);

          double totalB = 0;
          double totalC = 0;
          double totalA = 0;
          double totalD = 0;
          double totalDiscount = 0;

          try {
            for (var item in items) {
              // Calculate discounted price if discount rate exists and is not 0
              var discountedPrice = item.price;
              if (item.dcRt != 0) {
                discountedPrice = item.price * (1 - item.dcRt! / 100);
                // Calculate and add the discount amount for this item
                var discountAmount = (item.price - discountedPrice) * item.qty;
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

          Customer? customer = (await ProxyService.strategy.customers(
                  id: transaction.customerId ?? "",
                  branchId: ProxyService.box.getBranchId()!))
              .firstOrNull;

          Print print = Print();

          final List<TransactionPaymentRecord> paymentTypes = await ProxyService
              .strategy
              .getPaymentType(transactionId: transaction.id);
          await print.print(
            customerPhone: customer?.telNo ??
                ProxyService.box.currentSaleCustomerPhoneNumber(),
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
            transaction: transaction,

            /// TODO: for totalTax we are not accounting other taxes only B
            /// so need to account them in future
            totalTax: (totalB * 18 / 118).toStringAsFixed(2),
            items: items,
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
            brandAddress: business.adrs ?? "Kigali,Rwanda",
            brandTel: ProxyService.box.getUserPhone()!,
            brandTIN: business.tinNumber.toString(),
            brandDescription: business.name!,
            brandFooter: business.name!,
            emails: ['info@yegobox.com'],
            brandEmail: business.email,
            customerTin: customer?.custTin == null ||
                    customer?.custTin?.toLowerCase() == 'null'
                ? null
                : customer?.custTin,
            receiptType: receiptType,
            customerName:
                customer?.custNm ?? ProxyService.box.customerName() ?? "N/A",
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
  }) async {
    try {
      int branchId = ProxyService.box.getBranchId()!;
      List<brick.Counter> counters = await ProxyService.strategy.getCounters(
          branchId: ProxyService.box.getBranchId()!,
          fetchRemote: !Platform.isWindows);
      brick.Counter? counter = await ProxyService.strategy.getCounter(
          branchId: branchId,
          receiptType: receiptType,
          fetchRemote: !Platform.isWindows);
      if (counter == null) {
        throw Exception(
            "Counter have not been initialized, call +250783054874");
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
        URI: await ProxyService.box.getServerUrl() ?? "",
        purchaseCode: purchaseCode,
        timeToUser: now,
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

            totalReceiptNumber: counter.totRcptNo,
            invoiceNumber: counter.invcNo,
            customerName: transaction.customerName ?? "N/A",
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
            ebmSynced: transaction.ebmSynced,
            isIncome: transaction.isIncome,
            isExpense: transaction.isExpense,
            isRefunded: transaction.isRefunded,
            customerTin: transaction.customerTin,
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
            receiptNumber: counter.invcNo,
            totalReceiptNumber: counter.totRcptNo,
            invoiceNumber: counter.invcNo,
            isProformaMode: ProxyService.box.isProformaMode(),
            isTrainingMode: ProxyService.box.isTrainingMode(),
          );
        }

        await saveReceipt(
            receiptSignature, transaction, qrCode, counter, receiptNumber,
            whenCreated: now, invoiceNumber: counter.invcNo!);

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

  Future<void> updateDrawer(
      String receiptType, ITransaction transaction) async {
    Drawers? drawer = await ProxyService.strategy
        .getDrawer(cashierId: ProxyService.box.getUserId()!);

    ProxyService.strategy.updateDrawer(
      drawerId: drawer!.id,
      cashierId: ProxyService.box.getBusinessId()!,
      nsSaleCount: receiptType == "NS"
          ? drawer.nsSaleCount ?? 0 + 1
          : drawer.nsSaleCount ?? 0,
      trSaleCount: receiptType == "TR"
          ? drawer.trSaleCount ?? 0 + 1
          : drawer.trSaleCount ?? 0,
      psSaleCount: receiptType == "PS"
          ? drawer.psSaleCount ?? 0 + 1
          : drawer.psSaleCount ?? 0,
      csSaleCount: receiptType == "CS"
          ? drawer.csSaleCount ?? 0 + 1
          : drawer.csSaleCount ?? 0,
      nrSaleCount: receiptType == "NR"
          ? drawer.nrSaleCount ?? 0 + 1
          : drawer.nrSaleCount ?? 0,
      incompleteSale: 0,
      totalCsSaleIncome: receiptType == "CS"
          ? drawer.totalCsSaleIncome ?? 0 + transaction.subTotal!
          : drawer.totalCsSaleIncome ?? 0,
      totalNsSaleIncome: receiptType == "NS"
          ? drawer.totalNsSaleIncome ?? 0 + transaction.subTotal!
          : drawer.totalNsSaleIncome ?? 0,
      openingDateTime: DateTime.now().toUtc(),
      open: true,
    );
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
