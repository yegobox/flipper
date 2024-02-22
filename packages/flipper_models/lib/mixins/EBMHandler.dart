import 'dart:developer';

import 'package:flipper_models/isar/receipt_signature.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/constants.dart';

import 'package:flipper_services/proxy.dart';
import 'package:intl/intl.dart';
import 'package:receipt/print.dart';

class EBMHandler<OBJ> {
  EBMHandler({required this.object}); // Use a constructor for clarity

  late OBJ object;

  Future<void> handleReceipt() async {
    if (object is ITransaction) {
      ITransaction transaction = object as ITransaction;
      if (transaction.status == COMPLETE) {
        //// generate a receipt for this completed transaction
        /// if a customer is attached and the customer is of type business
        /// we stop and wait for a business to give us purchase code!
        // Define this constant at the top level of your file
        const String customerTypeBusiness = "Business";

        if (transaction.customerId != null) {
          try {
            /// get this customer from db
            Customer? customer =
                await ProxyService.isar.getCustomer(id: transaction.customerId);

            /// for business customer we do not proceed generating receipt as a purchase code
            /// is mandatory we stop and wait for the purchase code from the user
            if (customer != null &&
                customer.customerType == customerTypeBusiness) {
              log("A customer was given and was a business, we stoped to generate receipt until purchase code is given",
                  name: "Purchase code");
              return;
            }
          } catch (e) {
            log('Failed to get customer: $e');
            // Handle the error as appropriate for your application
          }
        }

        if (await ProxyService.isar.isTaxEnabled()) {
          Business? business = await ProxyService.isar.getBusiness();
          List<TransactionItem> items =
              await ProxyService.isar.getTransactionItemsByTransactionId(
            transactionId: transaction.id,
          );

          /// modify transaction add customer required fields
          // tra
          /// prepare the receipt, this steps invloves generating the data required to
          /// print on receipt, get data required from ebm server after getting data required
          /// then get these data saved in our database so whenever we want to print receipt of same
          /// transaction it will be ready by then
          log(business?.id.toString() ?? "-",
              name: "generateRRAReceiptSignature");
          await generateRRAReceiptSignature(
            items: items,
            business: business!,
            transaction: transaction,
            receiptType: transaction.receiptType!,
          );
          log("generating EBM", name: "Generating Receipt");

          /// print the actual receipt
          printReceipt(
            items: items,
            business: business,
            transaction: transaction,
            receiptType: transaction.receiptType!,
          );
        }
      }
    }
  }

  Future<void> handleEBMInteraction() async {
    if (object is Variant) {
      Variant variant = object as Variant;
      if (await ProxyService.isar.isTaxEnabled()) {
        /// to avoid infinite loop where we save something in main db and then sync db
        /// for sync db to also call this handleEBMInteraction again
        /// we just are intrested in object that are not ebm backed also this has some piful
        /// as the function might repeat if ebmSynced property have not updated to true
        if (!variant.ebmSynced) {
          try {
            ProxyService.tax.saveItem(variation: variant);
            variant.ebmSynced = true;
            ProxyService.isar.update(data: variant, localUpdate: true);
          } catch (e) {
            handleNotificationMessaging(e);
            variant.ebmSynced = false;
            ProxyService.isar.update(data: variant, localUpdate: true);
          }
        }
      }
    }
    if (object is Stock) {
      Stock stock = object as Stock;
      if (await ProxyService.isar.isTaxEnabled()) {
        /// to avoid infinite loop where we save something in main db and then sync db
        /// for sync db to also call this handleEBMInteraction again
        /// we just are intrested in object that are not ebm backed
        if (!stock.ebmSynced) {
          try {
            ProxyService.tax.saveStock(stock: stock);
            stock.ebmSynced = true;
            ProxyService.isar.update(data: stock, localUpdate: true);
          } catch (e) {
            handleNotificationMessaging(e);
            stock.ebmSynced = false;
            ProxyService.isar.update(data: stock, localUpdate: true);
          }
        }
      }
    }
    if (object is Customer) {
      Customer customer = object as Customer;
      if (await ProxyService.isar.isTaxEnabled()) {
        /// to avoid infinite loop where we save something in main db and then sync db
        /// for sync db to also call this handleEBMInteraction again
        /// we just are intrested in object that are not ebm backed
        if (!customer.ebmSynced) {
          try {
            ProxyService.tax.saveCustomer(customer: customer);
            customer.ebmSynced = true;
            ProxyService.isar.update(data: customer, localUpdate: true);
          } catch (e) {
            handleNotificationMessaging(e);
            customer.ebmSynced = false;
            ProxyService.isar.update(data: customer, localUpdate: true);
          }
        }
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
  }) async {
    // Use local counter as long as it is marked as synced.
    log(receiptType, name: "onBefore: current Counter");
    int branchId = ProxyService.box.getBranchId()!;
    Counter? counter = await ProxyService.isar
        .getCounter(branchId: branchId, receiptType: receiptType);
    // Counter? counter = null;
    //log(counter?.toRawJson() ?? "No counter", name: "onAfter:current Counter");

    if (counter == null) {
      updateCounter(
        Counter(
          branchId: ProxyService.box.getBranchId()!,
          businessId: ProxyService.box.getBusinessId()!,
          curRcptNo: 0,
          lastTouched: DateTime.now(),
          receiptType: receiptType,
          totRcptNo: 0,
        ),
      );
    }

    EBMApiResponse? receiptSignature =
        await ProxyService.tax.generateReceiptSignature(
      transaction: transaction,
      items: items,
      receiptType: receiptType,
      counter: counter!,
    );

    log(receiptSignature?.toRawJson() ?? "No receipt signature",
        name: "Receipt Signature");

    if (receiptSignature == null) {
      throw Exception("Signature is null the receipt was not generated");
    }

    //updateTransactionAndDrawer(receiptType, transaction);

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);

    String receiptNumber =
        "${receiptSignature.data.rcptNo}/${receiptSignature.data.totRcptNo}";
    String qrCode = generateQRCode(formattedDate, receiptSignature);

    log("afterGenerating Qr", name: "generateQRCode");

    await createReceiptInIsar(
        receiptSignature, transaction, qrCode, counter, receiptNumber);

    counter
      ..totRcptNo = receiptSignature.data.totRcptNo + 1
      ..curRcptNo = receiptSignature.data.rcptNo + 1;
    updateCounter(counter);
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
    return '$formattedDate#${DateTime.now().toString().substring(11, 19)}#${receiptSignature.data.sdcId}#${receiptSignature.data.rcptNo}/${receiptSignature.data.totRcptNo}#${receiptSignature.data.intrlData}#${receiptSignature.data.rcptSign}';
  }
}
