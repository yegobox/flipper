import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/mixins/TaxController.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flipper_services/keypad_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';

import 'package:talker_flutter/talker_flutter.dart';
import 'package:printing/printing.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'dart:typed_data';

mixin TransactionMixin {
  final KeyPadService keypad = getIt<KeyPadService>();

  get quantity => keypad.quantity;
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
    ProxyService.strategy.collectPayment(
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

    ProxyService.strategy.updateTransaction(
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
      required bool partOfComposite}) async {
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
        item: existTransactionItem,
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
  }) async {
    try {
      // Update an existing item
      if (item != null && !isCustom) {
        _updateExistingTransactionItem(
          item: item,
          quantity: item.qty + quantity,
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
        quantity: computedQty,
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
      price: amountTotal / quantity,
      totAmt: variation.retailPrice! * quantity,
      prc: item.prc + variation.retailPrice! * quantity,
      splyAmt: variation.supplyPrice,
      quantityApproved: 0,
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

    if (partOfComposite) {
      final composite =
          (await ProxyService.strategy.composites(variantId: variation.id))
              .firstOrNull;
      return composite?.qty ?? 0.0;
    }

    return quantity;
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
}
