import 'dart:developer';
import 'dart:typed_data';
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
      {
      /// This paramter is needed when we are printing a copy of the receipt without necessary telling
      /// RRA that this is a copy, this might be needed when completed transaction
      /// and for some reason you missed the print but the customer still stands while waiting for receipt
      required Function(Uint8List bytes) printCallback,
      bool skiGenerateRRAReceiptSignature = false}) async {
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
        await printReceipt(
          receiptType: transaction.receiptType!,
          transaction: transaction,
          skiGenerateRRAReceiptSignature: skiGenerateRRAReceiptSignature,
          printCallback: (bytes) {
            printCallback(bytes);
          },
        );
      } else if ((transaction.receiptType == TransactionReceptType.NR ||
              transaction.receiptType == TransactionReceptType.TS ||
              transaction.receiptType == TransactionReceptType.PS ||
              transaction.receiptType == TransactionReceptType.CS) &&
          transaction.status == COMPLETE) {
        await printReceipt(
          receiptType: transaction.receiptType!,
          transaction: transaction,
          skiGenerateRRAReceiptSignature: skiGenerateRRAReceiptSignature,
          printCallback: (bytes) {
            printCallback(bytes);
          },
        );
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
  Future<void> printReceipt({
    required String receiptType,
    required ITransaction transaction,
    String? purchaseCode,
    bool skiGenerateRRAReceiptSignature = false,
    required Function(Uint8List bytes) printCallback,
  }) async {
    if (!skiGenerateRRAReceiptSignature) {
      await generateRRAReceiptSignature(
        // business: business,
        transaction: transaction,
        receiptType: transaction.receiptType!,
        purchaseCode: purchaseCode,
      );
    }
    Business? business = await ProxyService.local.getBusiness();
    List<TransactionItem> items =
        await ProxyService.realm.getTransactionItemsByTransactionId(
      transactionId: transaction.id,
    );
    Receipt? receipt =
        await ProxyService.realm.getReceipt(transactionId: transaction.id!);

    Map<String, double> taxTotals = {
      'A': 0.0,
      'B': 0.0,
      'C': 0.0,
      'D': 0.0,
    };

    try {
      for (var item in items) {
        // Log the item details
        talker.warning(
            "Processing item with price: ${(item.price == 0.0 ? 1 : item.price)} and quantity: ${item.qty}");

        // Fetch the tax configuration
        var taxConfig =
            ProxyService.realm.getByTaxType(taxtype: item.taxTyCd ?? "B");

        talker.info("Tax To be applied on: ${item.taxTyCd}");
        // Ensure taxPercentage is not null
        if (taxConfig.taxPercentage == 0.0) {
          talker.warning(
              "Tax percentage is null for tax type: ${item.taxTyCd ?? "B"}");
          continue; // Skip this item if tax percentage is null
        }

        // Calculate the tax amount
        double taxAmount = (((item.price == 0.0 ? 1 : item.price) * item.qty) *
                (taxConfig.taxPercentage!)) /
            118;

        // Accumulate tax amount instead of overwriting
        String taxType = item.taxTyCd ?? "B";
        taxTotals[taxType] = (taxTotals[taxType] ?? 0.0) + taxAmount;

        // Log the accumulated tax amount
        talker.warning(
            "Accumulated tax amount for ${taxType}: ${taxTotals[taxType]}");
      }
    } catch (s) {
      talker.error(s);
    }

    double totalTaxA = taxTotals['A'] ?? 0.0;
    double totalTaxB = taxTotals['B'] ?? 0.0;
    double totalTaxC = taxTotals['C'] ?? 0.0;
    double totalTaxD = taxTotals['D'] ?? 0.0;

    talker.warning("Final computed Tax for A: $totalTaxA");
    talker.warning("Final computed Tax for B: $totalTaxB");
    talker.warning("Final computed Tax for C: $totalTaxC");
    talker.warning("Final computed Tax for D: $totalTaxD");

    Customer? customer =
        ProxyService.realm.getCustomer(id: transaction.customerId ?? 0);

    Print print = Print();

    await print.print(
      grandTotal: transaction.subTotal,
      totalTaxA: totalTaxA,
      totalTaxB: totalTaxB,
      totalTaxC: totalTaxC,
      totalTaxD: totalTaxD,
      currencySymbol: "RW",
      transaction: transaction,
      totalTax:
          (totalTaxA + totalTaxB + totalTaxC + totalTaxD).toStringAsFixed(2),
      items: items,
      cash: transaction.subTotal,
      received: transaction.cashReceived,
      payMode: "Cash",
      mrc: receipt!.mrcNo ?? "",
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
          ProxyService.box.currentSaleCustomerPhoneNumber(),
      receiptType: receiptType,
      customerName: customer?.custNm ?? "N/A",
      printCallback: (Uint8List bytes) {
        printCallback(bytes);
      },
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
          invcNo: 1,
          lastTouched: DateTime.now(),
          receiptType: receiptType,
        );
        await ProxyService.realm.realm!.putAsync(counter);
      }

      /// check if counter.curRcptNo or counter.totRcptNo is zero increment it first

      // increment the counter before we pass it in
      // this is because if we don't then the EBM counter will give us the
      RwApiResponse? receiptSignature =
          await ProxyService.tax.generateReceiptSignature(
        transaction: transaction,
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

      /// I have a dought that maybe wrapping this into write does not make sense as this code is called before in realmExtension
      /// and the wrapper is wrapped before.
      ProxyService.realm.realm!.write(() {
        counters.map((Counter count) {
          count.totRcptNo = receiptSignature.data?.totRcptNo;
          count.curRcptNo = receiptSignature.data?.rcptNo;
          count.invcNo = (count.invcNo != null) ? count.invcNo! + 1 : 1;
          return count;
        }).toList();
      });
    } catch (e, s) {
      talker.critical(s);
      talker.critical(e);
      rethrow;
    }
  }

  Future<void> updateDrawer(
      String receiptType, ITransaction transaction) async {
    Drawers? drawer = await ProxyService.realm
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
    String receiptType,
  ) async {
    try {
      await ProxyService.realm.createReceipt(
        signature: receiptSignature,
        transaction: transaction,
        qrCode: qrCode,
        counter: counter,
        receiptType: receiptType,
      );
    } catch (e) {
      rethrow;
    }
  }

  String generateQRCode(String formattedDate, RwApiResponse receiptSignature) {
    return '$formattedDate#${DateTime.now().toString().substring(11, 19)}#${receiptSignature.data?.sdcId}#${receiptSignature.data?.rcptNo}/${receiptSignature.data?.totRcptNo}#${receiptSignature.data?.intrlData}#${receiptSignature.data?.rcptSign}';
  }
}
