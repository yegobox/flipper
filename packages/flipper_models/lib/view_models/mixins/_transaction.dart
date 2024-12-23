import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/helperModels/random.dart';
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
      final taxExanbled = ProxyService.strategy
          .isTaxEnabled(businessId: ProxyService.box.getBusinessId()!);
      RwApiResponse? response;
      final hasServerUrl = await ProxyService.box.getServerUrl() != null;
      final hasUser = (await ProxyService.box.bhfId()) != null;
      final isTaxServiceStoped = ProxyService.box.stopTaxService();

      /// update transaction type
      ProxyService.strategy.updateTransaction(
          transaction: transaction,
          isProformaMode: ProxyService.box.isProformaMode(),
          isTrainingMode: ProxyService.box.isTrainingMode());
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
            categoryId ?? "0",
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
      String categoryId,
      String transactionType,
      String paymentType,
      double discount,
      {required Function onComplete,
      required String bhfId}) async {
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
    Customer? customer =
        await ProxyService.strategy.getCustomer(id: transaction.customerId);

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
      String name = variation.productName ?? "N/A";

      TransactionItem? existTransactionItem = ProxyService.strategy
          .getTransactionItemByVariantId(
              variantId: variation.id, transactionId: pendingTransaction.id);

      await addTransactionItems(
        variationId: variation.id,
        pendingTransaction: pendingTransaction,
        name: name,
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
    required int variationId,
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
      if (item != null && !isCustom) {
        // Update existing non-custom item

        ProxyService.strategy.updateTransactionItem(
          transactionItemId: item.id,
          qty: item.qty + quantity,
          taxblAmt: variation.retailPrice! * quantity,
          price: amountTotal / quantity,
          totAmt: variation.retailPrice! * quantity,
          prc: item.prc + variation.retailPrice! * quantity,
          splyAmt: variation.supplyPrice,
          quantityApproved: 0,
          active: true,
          quantityRequested: ((item.qty) + quantity).toInt(),
          quantityShipped: 0,
        );
        updatePendingTransactionTotals(pendingTransaction);
      } else {
        // Add new item (for both custom and new non-custom items)
        double computedQty = isCustom ? 1.0 : quantity;
        if (partOfComposite) {
          Composite? composite =
              ProxyService.strategy.composite(variantId: variation.id);
          computedQty = composite?.qty ?? 0.0;
        }

        TransactionItem newItem = TransactionItem(
          compositePrice: partOfComposite == true ? compositePrice! : 0.0,
          id: randomNumber(),
          price: variation.retailPrice!,
          variantId: variation.id,
          name: name,
          quantityApproved: 0,
          quantityRequested: computedQty.toInt(),
          quantityShipped: 0,
          branchId: ProxyService.box.getBranchId(),
          discount: 0.0,
          prc: variation.retailPrice!,
          doneWithTransaction: false,
          active: true,
          transactionId: pendingTransaction.id,
          createdAt: DateTime.now().toString(),
          updatedAt: DateTime.now().toString(),
          remainingStock: currentStock - quantity,
          lastTouched: DateTime.now(),
          qty: computedQty,
          taxblAmt: variation.retailPrice! * quantity,
          taxAmt: double.parse((amountTotal * 18 / 118).toStringAsFixed(2)),
          totAmt: variation.retailPrice! * quantity,
          itemSeq: variation.itemSeq,
          isrccCd: variation.isrccCd,
          isrccNm: variation.isrccNm,
          isrcRt: variation.isrcRt,
          isrcAmt: variation.isrcAmt,
          taxTyCd: variation.taxTyCd,
          bcd: variation.bcd,
          itemClsCd: variation.itemClsCd,
          itemTyCd: variation.itemTyCd,
          itemStdNm: variation.itemStdNm,
          orgnNatCd: variation.orgnNatCd,
          pkg: variation.pkg,
          itemCd: variation.itemCd,
          pkgUnitCd: variation.pkgUnitCd,
          qtyUnitCd: variation.qtyUnitCd,
          itemNm: variation.itemNm!,
          splyAmt: variation.supplyPrice,
          tin: variation.tin,
          bhfId: variation.bhfId,
          dftPrc: variation.dftPrc,
          addInfo: variation.addInfo,
          isrcAplcbYn: variation.isrcAplcbYn,
          useYn: variation.useYn,
          regrId: variation.regrId,
          regrNm: variation.regrNm,
          modrId: variation.modrId,
          modrNm: variation.modrNm,
          partOfComposite: partOfComposite,
          dcRt: variation.dcRt,
          dcAmt: (variation.retailPrice! * variation.qty!) * variation.dcRt!,
        );

        ProxyService.strategy.addTransactionItem(
            transaction: pendingTransaction,
            item: newItem,
            partOfComposite: partOfComposite);
      }

      // Handle activation of inactive items
      List<TransactionItem> inactiveItems = await ProxyService.strategy
          .transactionItems(
              branchId: ProxyService.box.getBranchId()!,
              transactionId: pendingTransaction.id,
              doneWithTransaction: false,
              active: false);

      markItemAsDoneWithTransaction(
          inactiveItems: inactiveItems, pendingTransaction: pendingTransaction);
      updatePendingTransactionTotals(pendingTransaction);
    } catch (e, s) {
      talker.warning(e);
      talker.error(s);
      rethrow;
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
    String newUpdatedAt = DateTime.now().toIso8601String();
    DateTime newLastTouched = DateTime.now();

    // Check if we're already in a write transaction
    await ProxyService.strategy.updateTransaction(
      transaction: pendingTransaction,
      subTotal: newSubTotal,
      updatedAt: newUpdatedAt,
      lastTouched: newLastTouched,
    );
  }
}
