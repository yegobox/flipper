import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/isolateHandelr.dart';
import 'package:flipper_models/mixins/TaxController.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/keypad_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:collection/collection.dart';

import 'package:talker_flutter/talker_flutter.dart';
import 'package:printing/printing.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'dart:typed_data';

import 'package:flutter/material.dart';

// adjust if needed

mixin TransactionMixin {
  final KeyPadService keypad = getIt<KeyPadService>();

  final talker = Talker();

  Future<RwApiResponse> finalizePayment(
      {String? purchaseCode,
      required String paymentType,
      required ITransaction transaction,
      String? categoryId,
      required String transactionType,
      required double amount,
      required BuildContext context,
      required GlobalKey<FormState> formKey,
      required TextEditingController customerNameController,
      required Function onComplete,
      required double discount}) async {
    try {
      final bhfId = (await ProxyService.box.bhfId()) ?? "00";
      final taxExanbled = await ProxyService.strategy
          .isTaxEnabled(businessId: ProxyService.box.getBusinessId()!);
      RwApiResponse? response;
      final hasServerUrl = await ProxyService.box.getServerUrl() != null;
      final hasUser = (await ProxyService.box.bhfId()) != null;
      final isTaxServiceStoped = ProxyService.box.stopTaxService();

      /// update transaction type

      if (taxExanbled && hasServerUrl && hasUser && !isTaxServiceStoped!) {
        response = await handleReceiptGeneration(
            formKey: formKey,
            context: context,
            transaction: transaction,
            purchaseCode: purchaseCode);
        if (response.resultCd != "000") {
          throw Exception("Invalid response from server");
        } else {
          updateCustomerTransaction(
              transaction,
              bhfId: bhfId,
              customerNameController.text,
              customerNameController,
              amount,
              onComplete: onComplete,
              categoryId ?? "",
              transactionType,
              paymentType,
              discount);
        }
      } else {
        updateCustomerTransaction(
            transaction,
            bhfId: bhfId,
            customerNameController.text,
            customerNameController,
            amount,
            categoryId,
            transactionType,
            paymentType,
            onComplete: onComplete,
            discount);
      }
      if (response == null) {
        return RwApiResponse(resultCd: "001", resultMsg: "Sale completed");
      }
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateCustomerTransaction(
      ITransaction transaction,
      String customerName,
      TextEditingController customerNameController,
      double amount,
      String? categoryId,
      String transactionType,
      String paymentType,
      double discount,
      {required Function onComplete,
      required String bhfId}) async {
    // TODO: TODO: check if we are computing the stock's value propper.
    await ProxyService.strategy.collectPayment(
      branchId: ProxyService.box.getBranchId()!,
      isProformaMode: ProxyService.box.isProformaMode(),
      isTrainingMode: ProxyService.box.isTrainingMode(),
      bhfId: bhfId,
      cashReceived: amount,
      transaction: transaction,
      categoryId: categoryId,
      transactionType: transactionType,
      isIncome: true,
      paymentType: paymentType,
      discount: discount,
      directlyHandleReceipt: false,
    );
    Customer? customer = (await ProxyService.strategy.customers(
            id: transaction.customerId,
            branchId: ProxyService.box.getBranchId()!))
        .firstOrNull;

    await ProxyService.strategy.updateTransaction(
      transaction: transaction,
      sarTyCd: "11",
      customerName: customer == null
          ? ProxyService.box.customerName() ?? "N/A"
          : customerNameController.text,
      customerTin: customer == null
          ? ProxyService.box.currentSaleCustomerPhoneNumber()
          : customer.custTin,
    );
  }

  Future<void> printing(Uint8List? bytes, BuildContext context) async {
    final printers = await Printing.listPrinters();

    if (printers.isNotEmpty) {
      Printer? pri = await Printing.pickPrinter(
          context: context, title: "List of printers");
      if (bytes == null) {
        return;
      }

      await Printing.directPrintPdf(
          printer: pri!, onLayout: (PdfPageFormat format) async => bytes);
    }
  }

  FilterType getFilterType({required String transactionType}) {
    if (transactionType == "NS") {
      return FilterType.NS;
    } else if (transactionType == "PS") {
      return FilterType.PS;
    } else if (transactionType == "TS") {
      return FilterType.TS;
    } else {
      return FilterType.NS;
    }
  }

  Future<RwApiResponse> handleReceiptGeneration(
      {String? purchaseCode,
      ITransaction? transaction,
      required GlobalKey<FormState> formKey,
      required BuildContext context}) async {
    try {
      final responseFrom =
          await TaxController(object: transaction!).handleReceipt(
        purchaseCode: purchaseCode,
        filterType: getFilterType(transactionType: transaction.receiptType!),
      );
      final (:response, :bytes) = responseFrom;

      formKey.currentState?.reset();

      if (bytes != null) {
        await printing(bytes, context);
      }
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> saveTransaction(
      {double? compositePrice,
      required Variant variation,
      required double amountTotal,
      required bool customItem,
      required ITransaction pendingTransaction,
      required double currentStock,
      bool useTransactionItemForQty = false,
      required bool partOfComposite,
      TransactionItem? item}) async {
    try {
      TransactionItem? existTransactionItem = await ProxyService.strategy
          .getTransactionItemByVariantId(
              variantId: variation.id, transactionId: pendingTransaction.id);

      await addTransactionItems(
        variationId: variation.id,
        pendingTransaction: pendingTransaction,
        name: variation.name,
        variation: variation,
        currentStock: currentStock,
        amountTotal: amountTotal,
        isCustom: customItem,
        partOfComposite: partOfComposite,
        compositePrice: compositePrice,
        item: existTransactionItem ?? item,
        useTransactionItemForQty: useTransactionItemForQty,
      );

      return true;
    } catch (e, s) {
      talker.warning(e);
      talker.error(s);
      rethrow;
    }
  }

  Future<void> addTransactionItems({
    required String variationId,
    required ITransaction pendingTransaction,
    required String name,
    required Variant variation,
    required double currentStock,
    required double amountTotal,
    required bool isCustom,
    TransactionItem? item,
    double? compositePrice,
    required bool partOfComposite,
    bool useTransactionItemForQty = false,
  }) async {
    try {
      // Update an existing item
      if (item != null && !isCustom && !useTransactionItemForQty) {
        _updateExistingTransactionItem(
          item: item,

          /// the  item.qty + 1 is for when a user click on same item on cart to increment
          /// while  useTransactionItemForQty ? item.qty is when we are dealing with adjustment etc..
          quantity: item.qty + 1,
          variation: variation,
          amountTotal: amountTotal,
        );
        updatePendingTransactionTotals(pendingTransaction);
        return;
      }

      // Add a new item
      double computedQty = await _calculateQuantity(
        isCustom: isCustom,
        partOfComposite: partOfComposite,
        variation: variation,
      );

      ProxyService.strategy.addTransactionItem(
        transaction: pendingTransaction,
        lastTouched: DateTime.now(),
        discount: 0.0,
        compositePrice: partOfComposite ? compositePrice ?? 0.0 : 0.0,
        quantity: useTransactionItemForQty ? item!.qty : computedQty,
        currentStock: currentStock,
        partOfComposite: partOfComposite,
        variation: variation,
        name: name,
        amountTotal: amountTotal,
      );

      // Reactivate inactive items if necessary
      _reactivateInactiveItems(pendingTransaction);

      updatePendingTransactionTotals(pendingTransaction);
    } catch (e, s) {
      talker.warning(e);
      talker.error(s);
      rethrow;
    }
  }

// Helper: Update existing transaction item
  Future<void> _updateExistingTransactionItem({
    required TransactionItem item,
    required double quantity,
    required Variant variation,
    required double amountTotal,
  }) async {
    await ProxyService.strategy.updateTransactionItem(
      transactionItemId: item.id,
      doneWithTransaction: false,
      qty: quantity,
      taxblAmt: variation.retailPrice! * quantity,
      price: variation.retailPrice!,
      totAmt: variation.retailPrice! * quantity,
      prc: item.prc + variation.retailPrice! * quantity,
      splyAmt: variation.supplyPrice,
      active: true,
      quantityRequested: quantity.toInt(),
      quantityShipped: 0,
    );
  }

// Helper: Calculate quantity
  Future<double> _calculateQuantity({
    required bool isCustom,
    required bool partOfComposite,
    required Variant variation,
  }) async {
    if (isCustom) return 1.0;

    /// because for composite we might have more than one item to be added to the cart at once hence why we have this
    if (partOfComposite) {
      final composite =
          (await ProxyService.strategy.composites(variantId: variation.id))
              .firstOrNull;
      return composite?.qty ?? 0.0;
    }

    return 1;
  }

// Helper: Reactivate inactive items
  Future<void> _reactivateInactiveItems(ITransaction pendingTransaction) async {
    final inactiveItems = await ProxyService.strategy.transactionItems(
      branchId: ProxyService.box.getBranchId()!,
      transactionId: pendingTransaction.id,
      doneWithTransaction: false,
      active: false,
    );

    if (inactiveItems.isNotEmpty) {
      markItemAsDoneWithTransaction(
        inactiveItems: inactiveItems,
        pendingTransaction: pendingTransaction,
      );
    }
  }

  Future<void> markItemAsDoneWithTransaction(
      {required List<TransactionItem> inactiveItems,
      required ITransaction pendingTransaction,
      bool isDoneWithTransaction = false}) async {
    if (inactiveItems.isNotEmpty) {
      for (TransactionItem inactiveItem in inactiveItems) {
        inactiveItem.active = true;
        if (isDoneWithTransaction) {
          await ProxyService.strategy.updateTransactionItem(
            transactionItemId: inactiveItem.id,
            doneWithTransaction: true,
          );
        }
      }
    }
  }

  Future<void> updatePendingTransactionTotals(
      ITransaction pendingTransaction) async {
    List<TransactionItem> items = await ProxyService.strategy.transactionItems(
      branchId: ProxyService.box.getBranchId()!,
      transactionId: pendingTransaction.id,
      doneWithTransaction: false,
      active: true,
    );

    // Calculate the new values
    double newSubTotal = items.fold(0, (a, b) => a + (b.price * b.qty));
    DateTime newUpdatedAt = DateTime.now();
    DateTime newLastTouched = DateTime.now();

    // Check if we're already in a write transaction
    await ProxyService.strategy.updateTransaction(
      transaction: pendingTransaction,
      subTotal: newSubTotal,
      updatedAt: newUpdatedAt,
      lastTouched: newLastTouched,
      receiptType: "NS",
      isProformaMode: false,
      isTrainingMode: false,
    );
  }

  ///  combines the `saveTransaction` and  `ProxyService.strategy.updateTransaction` calls into a single, more streamlined function
  Future<void> assignTransaction({
    required Variant variant,
    required ITransaction pendingTransaction,
    required Business business,
    required int randomNumber,
    required String sarTyCd,

    /// usualy the flag useTransactionItemForQty is needed when we are dealing with adjustment
    /// transaction i.e not original transaction
    bool useTransactionItemForQty = false,
    TransactionItem? item,
  }) async {
    try {
      // Save the transaction item
      await saveTransaction(
        variation: variant,
        amountTotal: variant.retailPrice!,
        customItem: false,
        currentStock: variant.stock!.currentStock!,
        pendingTransaction: pendingTransaction,
        partOfComposite: false,
        compositePrice: 0,
        item: item,
        useTransactionItemForQty: useTransactionItemForQty,
      );

      // Update the transaction status to PARKED
      await _parkTransaction(
        pendingTransaction: pendingTransaction,
        variant: variant,
        sarTyCd: sarTyCd,
        business: business,
        randomNumber: randomNumber,
      );
    } catch (e, s) {
      talker.warning(e);
      talker.error(s);
      rethrow;
    }
  }

  ///Parks the transaction
  Future<void> _parkTransaction({
    required ITransaction pendingTransaction,
    required Variant variant,
    required dynamic business,
    required int randomNumber,
    required String sarTyCd,
  }) async {
    await ProxyService.strategy.updateTransaction(
      transaction: pendingTransaction,
      status: PARKED,
      sarTyCd: sarTyCd, //Incoming- Adjustment
      receiptNumber: randomNumber,
      reference: randomNumber.toString(),
      invoiceNumber: randomNumber,
      receiptType: TransactionType.adjustment,
      customerTin: ProxyService.box.tin().toString(),
      customerBhfId: await ProxyService.box.bhfId() ?? "00",
      subTotal: pendingTransaction.subTotal! + (variant.splyAmt ?? 0),
      cashReceived: -(pendingTransaction.subTotal! + (variant.splyAmt ?? 0)),
      customerName: business.name,
    );
  }

  ///Completes the transaction
  Future<void> completeTransaction({
    required ITransaction pendingTransaction,
  }) async {
    await _completeTransaction(pendingTransaction: pendingTransaction);
  }

  Future<void> _completeTransaction({
    required ITransaction pendingTransaction,
  }) async {
    Business? business = await ProxyService.strategy
        .getBusiness(businessId: ProxyService.box.getBusinessId()!);

    final bool isEbmEnabled = await ProxyService.strategy
        .isTaxEnabled(businessId: business!.serverId);
    if (isEbmEnabled) {
      try {
        VariantPatch.patchVariant(
          URI: (await ProxyService.box.getServerUrl())!,
        );
        await StockPatch.patchStock(
          URI: (await ProxyService.box.getServerUrl())!,
          sendPort: (message) {
            ProxyService.notification.sendLocalNotification(body: message);
          },
        );

        await ProxyService.strategy.updateTransaction(
            isUnclassfied: true,
            transaction: pendingTransaction,
            status: COMPLETE,
            ebmSynced: false);
        final tinNumber = ProxyService.box.tin();
        final bhfId = await ProxyService.box.bhfId();
        await PatchTransactionItem.patchTransactionItem(
          tinNumber: tinNumber,
          bhfId: bhfId!,
          URI: (await ProxyService.box.getServerUrl())!,
          sendPort: (message) {
            ProxyService.notification.sendLocalNotification(body: message);
          },
        );
      } catch (e) {}
    }
  }
}
