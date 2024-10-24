import 'dart:developer';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/power_sync/schema.dart';
import 'package:flutter/foundation.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/realmExtension.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:intl/intl.dart';

import 'package:flipper_services/proxy.dart';
import 'package:realm/realm.dart';
import 'package:receipt/print.dart';

class TaxController<OBJ> {
  TaxController({this.object});

  OBJ? object;

  Future<({RwApiResponse response, Uint8List? bytes})> handleReceipt(
      {bool skiGenerateRRAReceiptSignature = false,
      String? purchaseCode}) async {
    if (object is ITransaction) {
      ITransaction transaction = object as ITransaction;

      if (transaction.status == COMPLETE) {
        if (transaction.receiptType == TransactionReceptType.NS) {
          try {
            return await printReceipt(
              receiptType: transaction.receiptType!,
              transaction: transaction,
              purchaseCode: purchaseCode,
              skiGenerateRRAReceiptSignature: skiGenerateRRAReceiptSignature,
            );
          } catch (e) {
            rethrow;
          }
        } else if (transaction.receiptType == TransactionReceptType.NR) {
          try {
            return await printReceipt(
              purchaseCode: purchaseCode,
              receiptType: transaction.receiptType!,
              transaction: transaction,
              skiGenerateRRAReceiptSignature: skiGenerateRRAReceiptSignature,
            );
          } catch (e) {
            rethrow;
          }
        } else if (transaction.receiptType == TransactionReceptType.TS) {
          try {
            return await printReceipt(
              purchaseCode: purchaseCode,
              receiptType: transaction.receiptType!,
              transaction: transaction,
              skiGenerateRRAReceiptSignature: skiGenerateRRAReceiptSignature,
            );
          } catch (e) {
            rethrow;
          }
        } else if (transaction.receiptType == TransactionReceptType.PS) {
          try {
            return await printReceipt(
              purchaseCode: purchaseCode,
              receiptType: transaction.receiptType!,
              transaction: transaction,
              skiGenerateRRAReceiptSignature: skiGenerateRRAReceiptSignature,
            );
          } catch (e) {
            rethrow;
          }
        } else if (transaction.receiptType == TransactionReceptType.CS) {
          try {
            return await printReceipt(
              purchaseCode: purchaseCode,
              receiptType: transaction.receiptType!,
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
          receiptType: transaction.receiptType!,
          purchaseCode: purchaseCode,
        );

        if (responses.resultCd == "000") {
          Business? business = await ProxyService.local.getBusiness();
          List<TransactionItem> items =
              await ProxyService.local.getTransactionItemsByTransactionId(
            transactionId: transaction.id,
          );
          Receipt? receipt = await ProxyService.local
              .getReceipt(transactionId: transaction.id!);

          double totalB = 0;
          double totalC = 0;
          double totalA = 0;
          double totalD = 0;

          try {
            for (var item in items) {
              if (item.taxTyCd == "B") {
                totalB = totalB + (item.price * item.qty);
              }
              if (item.taxTyCd == "C") {
                totalC = totalC + (item.price * item.qty);
              }
              if (item.taxTyCd == "A") {
                totalA = totalA + (item.price * item.qty);
              }
              if (item.taxTyCd == "D") {
                totalD = totalD + (item.price * item.qty);
              }
            }
          } catch (s) {
            rethrow;
          }

          Configurations taxConfigTaxB =
              ProxyService.local.getByTaxType(taxtype: "B");
          Configurations taxConfigTaxA =
              ProxyService.local.getByTaxType(taxtype: "A");
          Configurations taxConfigTaxC =
              ProxyService.local.getByTaxType(taxtype: "C");
          Configurations taxConfigTaxD =
              ProxyService.local.getByTaxType(taxtype: "D");

          Customer? customer =
              ProxyService.local.getCustomer(id: transaction.customerId ?? 0);

          Print print = Print();

          talker.error("totalB: ${totalB}");
          talker.error("taxB: ${calculateTotalTax(totalB, taxConfigTaxB)}");

          await print.print(
            whenCreated: receipt!.whenCreated!,
            taxB: totalB,
            taxC: totalC,
            taxA: totalA,
            taxD: totalD,
            grandTotal: transaction.subTotal,
            totalTaxA: calculateTotalTax(totalA, taxConfigTaxA),
            totalTaxB: calculateTotalTax(totalB, taxConfigTaxB),
            totalTaxC: calculateTotalTax(totalC, taxConfigTaxC),
            totalTaxD: calculateTotalTax(totalD, taxConfigTaxD),
            currencySymbol: "RW",
            transaction: transaction,

            /// TODO: for totalTax we are not accounting other taxes only B
            /// so need to account them in future
            totalTax: (totalB * 18 / 118).toStringAsFixed(2),
            items: items,
            cash: transaction.subTotal,
            received: transaction.cashReceived,
            payMode: "Cash",
            mrc: receipt.mrcNo ?? "",
            internalData: receipt.intrlData ?? "",
            receiptQrCode: receipt.qrCode ?? "",
            receiptSignature: receipt.rcptSign ?? "",
            cashierName: business.name!,
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
            customerTin: customer?.custTin ??
                "0" + ProxyService.box.currentSaleCustomerPhoneNumber()!,
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
    // Use local counter as long as it is marked as synced.

    try {
      log(receiptType, name: "onBefore: current Counter");
      int branchId = ProxyService.box.getBranchId()!;
      Counter? counter = await ProxyService.local
          .getCounter(branchId: branchId, receiptType: receiptType);

      if (counter == null) {
        counter = Counter(
          ObjectId(),
          id: randomNumber(),
          branchId: ProxyService.box.getBranchId()!,
          businessId: ProxyService.box.getBusinessId()!,
          invcNo: 1,
          lastTouched: DateTime.now(),
          receiptType: receiptType,
        );
        ProxyService.local.realm!.put(counter, tableName: 'counters');
      }

      /// check if counter.curRcptNo or counter.totRcptNo is zero increment it first

      // increment the counter before we pass it in
      // this is because if we don't then the EBM counter will give us the

      DateTime now = DateTime.now();

      RwApiResponse receiptSignature =
          await ProxyService.tax.generateReceiptSignature(
        transaction: transaction,
        receiptType: receiptType,
        counter: counter,
        URI: ProxyService.box.getServerUrl()!,
        purchaseCode: purchaseCode,
        timeToUser: now,
      );

      if (receiptSignature.resultCd == "000" && !transaction.isExpense) {
        String receiptNumber =
            "${receiptSignature.data?.rcptNo}/${receiptSignature.data?.totRcptNo}";
        String qrCode = generateQRCode(now.toYYYMMdd(), receiptSignature);
        List<Counter> counters = ProxyService.local.realm!
            .query<Counter>(r'branchId == $0', [branchId]).toList();

        /// update transaction with receipt number and total receipt number
        ProxyService.local.realm!.writeN(
          tableName: transactionTable,
          writeCallback: () {
            transaction.receiptNumber = receiptSignature.data?.rcptNo;
            transaction.totalReceiptNumber = receiptSignature.data?.totRcptNo;
            transaction.invoiceNumber = counter!.invcNo;
            return transaction;
          },
          onAdd: (data) {
            ProxyService.synchronize.syncToFirestore(transactionTable, data);
          },
        );

        await saveReceipt(
            receiptSignature, transaction, qrCode, counter, receiptNumber,
            whenCreated: now, invoiceNumber: counter.invcNo!);

        /// by incrementing this by 1 we get ready for next value to use so there will be no need to increment it
        /// at the time of passing in data, I have to remember to clean it in rw_tax.dart
        /// since curRcptNo need to be update when one change to keep track on current then we find all
        // Fetch the counters from the database

        ProxyService.local.updateCounters(
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
    Drawers? drawer = await ProxyService.local
        .getDrawer(cashierId: ProxyService.box.getUserId()!);

    ProxyService.local.realm!.write(() {
      drawer!
        ..cashierId = ProxyService.box.getBusinessId()!
        ..nsSaleCount = receiptType == "NS"
            ? drawer.nsSaleCount ?? 0 + 1
            : drawer.nsSaleCount ?? 0
        ..trSaleCount = receiptType == "TR"
            ? drawer.trSaleCount ?? 0 + 1
            : drawer.trSaleCount ?? 0
        ..psSaleCount = receiptType == "PS"
            ? drawer.psSaleCount ?? 0 + 1
            : drawer.psSaleCount ?? 0
        ..csSaleCount = receiptType == "CS"
            ? drawer.csSaleCount ?? 0 + 1
            : drawer.csSaleCount ?? 0
        ..nrSaleCount = receiptType == "NR"
            ? drawer.nrSaleCount ?? 0 + 1
            : drawer.nrSaleCount ?? 0
        ..incompleteSale = 0
        ..totalCsSaleIncome = receiptType == "CS"
            ? drawer.totalCsSaleIncome ?? 0 + transaction.subTotal
            : drawer.totalCsSaleIncome ?? 0
        ..totalNsSaleIncome = receiptType == "NS"
            ? drawer.totalNsSaleIncome ?? 0 + transaction.subTotal
            : drawer.totalNsSaleIncome ?? 0
        ..openingDateTime = DateTime.now().toIso8601String()
        ..open = true;
    });
  }

  Future<void> saveReceipt(
      RwApiResponse receiptSignature,
      ITransaction transaction,
      String qrCode,
      Counter counter,
      String receiptType,
      {required DateTime whenCreated,
      required int invoiceNumber}) async {
    try {
      await ProxyService.local.createReceipt(
        signature: receiptSignature,
        transaction: transaction,
        qrCode: qrCode,
        counter: counter,
        receiptType: receiptType,
        whenCreated: whenCreated,
        invoiceNumber: invoiceNumber,
      );
    } catch (e) {
      rethrow;
    }
  }

  String generateQRCode(String formattedDate, RwApiResponse receiptSignature) {
    final now = DateTime.now();
    final timeFormatter = DateFormat('HH:mm:ss');
    final currentTime = timeFormatter.format(now);

    final data = receiptSignature.data;
    if (data == null) {
      throw ArgumentError('Receipt signature data is null');
    }

    final qrCodeParts = [
      formattedDate,
      currentTime,
      data.sdcId ?? 'N/A',
      '${data.rcptNo ?? 'N/A'}/${data.totRcptNo ?? 'N/A'}',
      data.intrlData ?? 'N/A',
      data.rcptSign ?? 'N/A',
    ];

    return qrCodeParts.join('#');
  }
}
