import 'dart:developer';

import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/realmExtension.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';

import 'package:flipper_services/proxy.dart';
import 'package:intl/intl.dart';
import 'package:realm/realm.dart';
import 'package:receipt/print.dart';

class TaxController<OBJ> {
  TaxController({this.object}); // Use a constructor for clarity

  OBJ? object;

  Future<void> handleReceipt(
      {bool skiGenerateRRAReceiptSignature = false}) async {
    if (object is ITransaction) {
      ITransaction transaction = object as ITransaction;

      /// when the customer is not added to the sale then we shall print the rra receipt
      /// automatically if the customer is added though we shall wait for the purchase code from
      /// user for us to proceed
      /// for NS or normal sale we ask for purchase code! therefore the first condition should check if it is  NS
      /// as it require the purchase code and

      if (transaction.status == COMPLETE &&
          transaction.customerId == null &&
          transaction.receiptType == TransactionReceptType.NS) {
        //// generate a receipt for this completed transaction
        /// if a customer is attached and the customer is of type business
        /// we stop and wait for a business to give us purchase code!
        /// so when a customerI is not empty we will wait for the purchase code from the user
        /// and if the cashier does not provide it then we will go ahead and finish a transaction
        /// without the purchase code and the user detail added to the transaction
        await handleReceiptGeneration(
          transaction: transaction,
          skiGenerateRRAReceiptSignature: skiGenerateRRAReceiptSignature,
        );
      } else if ((transaction.receiptType == TransactionReceptType.NR ||
              transaction.receiptType == TransactionReceptType.TS ||
              transaction.receiptType == TransactionReceptType.PS ||
              transaction.receiptType == TransactionReceptType.CS) &&
          transaction.status == COMPLETE) {
        await handleReceiptGeneration(
          transaction: transaction,
          skiGenerateRRAReceiptSignature: skiGenerateRRAReceiptSignature,
        );
      }
    }
  }

  /// Generates a receipt for the given transaction. Checks if tax is enabled, gets the
  /// business and transaction items from the database, generates a signature, prints the
  /// receipt, and handles any errors.
  Future<void> handleReceiptGeneration(
      {required ITransaction transaction,
      String? purchaseCode,
      bool skiGenerateRRAReceiptSignature = false}) async {
    if (await ProxyService.realm.isTaxEnabled()) {
      Business? business = await ProxyService.local.getBusiness();
      List<TransactionItem> items =
          await ProxyService.realm.getTransactionItemsByTransactionId(
        transactionId: transaction.id,
      );

      try {
        if (!skiGenerateRRAReceiptSignature) {
          await generateRRAReceiptSignature(
            items: items,
            business: business,
            transaction: transaction,
            receiptType: transaction.receiptType!,
            purchaseCode: purchaseCode,
          );
        }

        await printReceipt(
          items: items,
          business: business,
          transaction: transaction,
          receiptType: transaction.receiptType!,
        );
      } catch (e, s) {
        talker.critical(s);
        //rethrow;
      }
    }
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

  /**
   * Prints a receipt for the given transaction.
   * 
   * @params items - The list of transaction items. 
   * @params business - The business this transaction is for.
   * @params receiptType - The type of receipt to print.
   * @params transaction - The transaction to print a receipt for.
   */
  Future<void> printReceipt(
      {required List<TransactionItem> items,
      required Business business,
      required String receiptType,
      required ITransaction transaction}) async {
    Receipt? receipt =
        await ProxyService.realm.getReceipt(transactionId: transaction.id!);

    Print print = Print();
    print.print(
      grandTotal: transaction.subTotal,
      currencySymbol: "RW",
      transaction: transaction,
      totalAEx: 0,
      items: items,
      totalB18: (transaction.subTotal * 18 / 118).toStringAsFixed(2),
      totalB: transaction.subTotal,
      totalTax: (transaction.subTotal * 18 / 118).toStringAsFixed(2),
      cash: transaction.subTotal,
      received: transaction.cashReceived,
      payMode: "Cash",
      mrc: receipt!.mrcNo ?? "",
      internalData: receipt.intrlData ?? "",
      receiptQrCode: receipt.qrCode ?? "",
      receiptSignature: receipt.rcptSign ?? "",
      cashierName: business.name!,
      sdcId: receipt.sdcId ?? "",
      sdcReceiptNum: receipt.receiptType ?? "",
      invoiceNum: receipt.totRcptNo ?? 0,
      brandName: business.name!,
      brandAddress: business.adrs ?? "Kigali,Rwanda",
      brandTel: ProxyService.box.getUserPhone()!,
      brandTIN: business.tinNumber.toString(),
      brandDescription: business.name!,
      brandFooter: business.name!,
      emails: ['info@yegobox.com'],
      customerTin: "0000000000",
      receiptType: receiptType,
    );
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
  Future<void> generateRRAReceiptSignature({
    required List<TransactionItem> items,
    required Business business,
    required String receiptType,
    required ITransaction transaction,
    String? purchaseCode,
  }) async {
    // Use local counter as long as it is marked as synced.

    try {
      log(receiptType, name: "onBefore: current Counter");
      int branchId = ProxyService.box.getBranchId()!;
      Counter? counter = await ProxyService.realm
          .getCounter(branchId: branchId, receiptType: receiptType);

      if (counter == null) {
        counter = Counter(
          ObjectId(),
          id: randomNumber(),
          branchId: ProxyService.box.getBranchId()!,
          businessId: ProxyService.box.getBusinessId()!,
          curRcptNo: 1,
          lastTouched: DateTime.now(),
          receiptType: receiptType,
          totRcptNo: 1,
        );
        await ProxyService.realm.realm!.putAsync(counter);
      }

      /// check if counter.curRcptNo or counter.totRcptNo is zero increment it first
      if (counter.totRcptNo == 0 || counter.curRcptNo == 0) {
        ProxyService.realm.realm!.writeAsync(() {
          counter!.totRcptNo = 1;
          counter.curRcptNo = 1;
        });
      }
      // increment the counter before we pass it in
      // this is because if we don't then the EBM counter will give us the
      RwApiResponse? receiptSignature =
          await ProxyService.tax.generateReceiptSignature(
        transaction: transaction,
        items: items,
        receiptType: receiptType,
        counter: counter,
        purchaseCode: purchaseCode,
      );
      //updateTransactionAndDrawer(receiptType, transaction);

      DateTime now = DateTime.now();
      String formattedDate = DateFormat('dd-MM-yyyy').format(now);

      String receiptNumber =
          "${receiptSignature!.data?.rcptNo}/${receiptSignature.data?.totRcptNo}";
      String qrCode = generateQRCode(formattedDate, receiptSignature);

      log("afterGenerating Qr", name: "generateQRCode");

      await saveReceipt(
          receiptSignature, transaction, qrCode, counter, receiptNumber);

      /// by incrementing this by 1 we get ready for next value to use so there will be no need to increment it
      /// at the time of passing in data, I have to remember to clean it in rw_tax.dart
      /// since curRcptNo need to be update when one change to keep track on current then we find all
      // Fetch the counters from the database
      List<Counter> counters = ProxyService.realm.realm!
          .query<Counter>(r'branchId == $0', [branchId]).toList();

// Create a new list to hold the updated counters

// Add all updated counters to the realm in a single transaction
      ProxyService.realm.realm!.write(() {
        counters.map((Counter count) {
          return count
            ..totRcptNo = receiptSignature.data?.totRcptNo
            ..curRcptNo = count.curRcptNo! + 1;
        }).toList();
        // ProxyService.realm.realm!.addAll(updatedCounters, update: true);
      });
    } catch (e, s) {
      talker.critical(s);
      talker.critical(e);
      rethrow;
    }
  }

  Future<void> updateDrawer(
      String receiptType, ITransaction transaction) async {
    Drawers? drawer = await ProxyService.local
        .getDrawer(cashierId: ProxyService.box.getBusinessId()!);

    ProxyService.realm.realm!.write(() {
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
    String receiptNumber,
  ) async {
    try {
      await ProxyService.realm.createReceipt(
        signature: receiptSignature,
        transaction: transaction,
        qrCode: qrCode,
        counter: counter,
        receiptType: receiptNumber,
      );
    } catch (e) {
      rethrow;
    }
  }

  String generateQRCode(String formattedDate, RwApiResponse receiptSignature) {
    return '$formattedDate#${DateTime.now().toString().substring(11, 19)}#${receiptSignature.data?.sdcId}#${receiptSignature.data?.rcptNo}/${receiptSignature.data?.totRcptNo}#${receiptSignature.data?.intrlData}#${receiptSignature.data?.rcptSign}';
  }
}
