import 'dart:developer';

import 'package:flipper_models/isar/random.dart';
import 'package:flipper_models/isar/receipt_signature.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/constants.dart';

import 'package:flipper_services/proxy.dart';
import 'package:intl/intl.dart';
import 'package:receipt/print.dart';

class EBMHandler<OBJ> {
  EBMHandler({this.object}); // Use a constructor for clarity

  OBJ? object;

  Future<void> handleReceipt() async {
    if (object is ITransaction) {
      ITransaction transaction = object as ITransaction;

      /// when the customer is not added to the sale then we shall print the rra receipt
      /// automatically if the customer is added though we shall wait for the purchase code from
      /// user for us to proceed
      if (transaction.status == COMPLETE && transaction.customerId == null) {
        //// generate a receipt for this completed transaction
        /// if a customer is attached and the customer is of type business
        /// we stop and wait for a business to give us purchase code!
        /// so when a customerI is not empty we will wait for the purchase code from the user
        /// and if the cashier does not provide it then we will go ahead and finish a transaction
        /// without the purchase code and the user detail added to the transaction
        await handleReceiptGeneration(transaction: transaction);
      }
    }
  }

  /// Generates a receipt for the given transaction. Checks if tax is enabled, gets the
  /// business and transaction items from the database, generates a signature, prints the
  /// receipt, and handles any errors.
  Future<void> handleReceiptGeneration(
      {required ITransaction transaction, String? purchaseCode}) async {
    if (await ProxyService.isar.isTaxEnabled()) {
      Business? business = await ProxyService.isar.getBusiness();
      List<TransactionItem> items =
          await ProxyService.isar.getTransactionItemsByTransactionId(
        transactionId: transaction.id,
      );

      try {
        await generateRRAReceiptSignature(
          items: items,
          business: business!,
          transaction: transaction,
          receiptType: transaction.receiptType!,
          purchaseCode: purchaseCode,
        );

        await printReceipt(
          items: items,
          business: business,
          transaction: transaction,
          receiptType: transaction.receiptType!,
        );
      } catch (e) {
        rethrow;
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
        await ProxyService.isar.getReceipt(transactionId: transaction.id);

    Print print = Print();
    log(items.toString(), name: "Items");
    log(transaction.toJson().toString(), name: "ITransaction");
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
      mrc: receipt!.mrcNo,
      internalData: receipt.intrlData,
      receiptQrCode: receipt.qrCode,
      receiptSignature: receipt.rcptSign,
      cashierName: business.name!,
      sdcId: receipt.sdcId,
      sdcReceiptNum: receipt.receiptType,
      invoiceNum: receipt.totRcptNo,
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
    log(receiptType, name: "onBefore: current Counter");
    int branchId = ProxyService.box.getBranchId()!;
    Counter? counter = await ProxyService.isar
        .getCounter(branchId: branchId, receiptType: receiptType);

    if (counter == null) {
      ProxyService.isar.create<Counter>(
        data: Counter(
          id: randomNumber(),
          branchId: ProxyService.box.getBranchId()!,
          businessId: ProxyService.box.getBusinessId()!,
          curRcptNo: 0,
          lastTouched: DateTime.now(),
          receiptType: receiptType,
          totRcptNo: 0,
        ),
      );
    }

    try {
      EBMApiResponse? receiptSignature =
          await ProxyService.tax.generateReceiptSignature(
        transaction: transaction,
        items: items,
        receiptType: receiptType,
        counter: counter!,
        purchaseCode: purchaseCode,
      );
      //updateTransactionAndDrawer(receiptType, transaction);

      DateTime now = DateTime.now();
      String formattedDate = DateFormat('dd-MM-yyyy').format(now);

      String receiptNumber =
          "${receiptSignature!.data?.rcptNo}/${receiptSignature.data?.totRcptNo}";
      String qrCode = generateQRCode(formattedDate, receiptSignature);

      log("afterGenerating Qr", name: "generateQRCode");

      await createReceiptInIsar(
          receiptSignature, transaction, qrCode, counter, receiptNumber);

      counter
        ..totRcptNo = receiptSignature.data?.totRcptNo ?? 0 + 1
        ..curRcptNo = receiptSignature.data?.rcptNo ?? 0 + 1;
      updateCounter(counter);
    } catch (e) {
      rethrow;
    }
  }

  void updateTransactionAndDrawer(
      String receiptType, ITransaction transaction) async {
    await updateDrawer(receiptType, transaction);
    ProxyService.isar.update(data: transaction);
  }

  Future<void> updateDrawer(
      String receiptType, ITransaction transaction) async {
    Drawers? drawer = await ProxyService.isar
        .getDrawer(cashierId: ProxyService.box.getBusinessId()!);
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
    // update drawer
    await ProxyService.isar.update(data: drawer);
  }

  Future<void> updateCounter(Counter counter) async {
    await ProxyService.isar.update(data: counter);
  }

  Future<void> createReceiptInIsar(
    EBMApiResponse receiptSignature,
    ITransaction transaction,
    String qrCode,
    Counter counter,
    String receiptNumber,
  ) async {
    await ProxyService.isar.createReceipt(
      signature: receiptSignature,
      transaction: transaction,
      qrCode: qrCode,
      counter: counter,
      receiptType: receiptNumber,
    );
  }

  String generateQRCode(String formattedDate, EBMApiResponse receiptSignature) {
    return '$formattedDate#${DateTime.now().toString().substring(11, 19)}#${receiptSignature.data?.sdcId}#${receiptSignature.data?.rcptNo}/${receiptSignature.data?.totRcptNo}#${receiptSignature.data?.intrlData}#${receiptSignature.data?.rcptSign}';
  }
}
