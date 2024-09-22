// ignore_for_file: unused_result

import 'dart:typed_data';

import 'package:flipper_dashboard/TextEditingControllersMixin.dart';
import 'package:flipper_models/mixins/TaxController.dart';
import 'package:flipper_models/states/selectedSupplierProvider.dart';
import 'package:flipper_models/view_models/mixins/_transaction.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/foundation.dart';

import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

mixin PreviewcartMixin<T extends ConsumerStatefulWidget>
    on ConsumerState<T>, TransactionMixin, TextEditingControllersMixin {
  /// this mthod will either preview or completeOrder
  Future<void> previewOrOrder(
      {bool isShopingFromWareHouse = true,
      required ITransaction transaction}) async {
    ref.read(previewingCart.notifier).state = !ref.read(previewingCart);

    if (!isShopingFromWareHouse) {
      /// here we just navigate to Quick setting to preview what's on cart
      /// just return as nothing to be done.
      return;
    }

    /// the code is reviewing the cart while shoping as external party e.g a sub branch
    /// shoping to main warehouse

    try {
      String deliveryNote = deliveryNoteCotroller.text;

      final dateRange = ref.watch(dateRangeProvider);
      final startDate = dateRange['startDate'];

      final items = ProxyService.realm.transactionItems(
        branchId: ProxyService.box.getBranchId()!,
        transactionId: transaction.id!,
        doneWithTransaction: false,
        active: true,
      );

      /// previewingCart start with state false then if is true then we are previewing stop completing the order
      if (items.isEmpty || ref.read(previewingCart)) {
        // ref.read(toggleProvider.notifier).state = false;
        return;
      }

      // ignore: unused_local_variable
      int orderId = ProxyService.realm.createStockRequest(items,
          deliveryNote: deliveryNote,
          deliveryDate: startDate,
          mainBranchId: ref.read(selectedSupplierProvider).value!.serverId!);
      await _markItemsAsDone(items, transaction);
      _changeTransactionStatus(transaction: transaction);
      await _refreshTransactionItems(transactionId: transaction.id!);

      // locator<RouterService>()
      //     .navigateTo(WaitingOrdersPlacedRoute(orderId: orderId));

      /// when order is completed procced to waiting orders page

      // print("Order placed with ${items.length} items in basket");
    } catch (e, s) {
      talker.info(e);
      talker.error(s);
      rethrow;
    }
  }

  void _changeTransactionStatus({required ITransaction transaction}) {
    ProxyService.realm.realm!.write(() {
      /// we mark the status so next time we query pending transaction we don't
      /// accidently query this PENDING transaction and avoid mixxing things up
      transaction.status = ORDERING;
    });
  }

  Future<void> _markItemsAsDone(
      List<TransactionItem> items, dynamic pendingTransaction) async {
    markItemAsDoneWithTransaction(
      isDoneWithTransaction: true,
      inactiveItems: items,
      pendingTransaction: pendingTransaction,
    );
  }

  Future<void> _refreshTransactionItems({required int transactionId}) async {
    ref.refresh(freshtransactionItemsProviderByIdProvider(
        (transactionId: transactionId)));

    ref.refresh(pendingTransactionProviderNonStream(
        (isExpense: false, mode: TransactionType.sale)));

    /// get new transaction id
    ref.refresh(pendingTransactionProvider(
        (mode: TransactionType.sale, isExpense: false)));

    ref.refresh(transactionItemsProvider((isExpense: false)));
    ref.read(loadingProvider.notifier).state = false;
  }

  void handleCompleteTransaction(ITransaction transaction) {
    if (transaction.subTotal != 0) {
      ref.read(loadingProvider.notifier).state = true;
      Customer? customer =
          ProxyService.realm.getCustomer(id: transaction.customerId);

      final amount = double.tryParse(receivedAmountController.text) ?? 0;
      final discount = double.tryParse(discountController.text) ?? 0;
      final state = (formKey.currentState?.validate() ?? true);

      /// on mobile we are not validating state hence it is always true && customer ==null
      if (state && customer == null) {
        handlePayment(
          paymentType: ProxyService.box.paymentType() ?? "Cash",
          transactionType: TransactionType.sale,
          transaction: transaction,
          amount: amount,
          discount: discount,
        );
        ref.read(loadingProvider.notifier).state = false;
        _refreshTransactionItems(transactionId: transaction.id!);
      } else {
        confirmPayment(
          amount: amount,
          discount: discount,
          paymentType: paymentTypeController.text,
          transaction: transaction,
        );
        _refreshTransactionItems(transactionId: transaction.id!);
        ref.read(loadingProvider.notifier).state = false;
      }
    } else {
      showSimpleNotification(
        Text(FLocalization.of(context).noPayable),
        background: Colors.red,
        contentPadding: EdgeInsets.only(left: 120, right: 120),
        position: NotificationPosition.bottom,
      );
    }
  }

  Future<void> handlePayment(
      {String? purchaseCode,
      required String paymentType,
      required ITransaction transaction,
      String? categoryId,
      required String transactionType,
      required double amount,
      required double discount}) async {
    ITransaction trans = ProxyService.realm.collectPayment(
      branchId: ProxyService.box.getBranchId()!,
      isProformaMode: ProxyService.box.isProformaMode(),
      isTrainingMode: ProxyService.box.isTrainingMode(),
      bhfId: ProxyService.box.bhfId() ?? "00",
      cashReceived: amount,
      transaction: transaction,
      categoryId: categoryId,
      transactionType: transactionType,
      isIncome: true,
      paymentType: paymentType,
      discount: discount,
      directlyHandleReceipt: false,
    );
    final taxExanbled = ProxyService.realm
        .isTaxEnabled(business: ProxyService.local.getBusiness());

    final hasServerUrl = ProxyService.box.getServerUrl() != null;
    final hasUser = ProxyService.box.bhfId() != null;
    if (taxExanbled && hasServerUrl && hasUser) {
      await handleReceiptGeneration(
          transaction: trans, purchaseCode: purchaseCode);
    } else {
      talker.warning("No EBM receipt generated");
    }
  }

  Future<void> handleReceiptGeneration(
      {String? purchaseCode, ITransaction? transaction}) async {
    try {
      ITransaction? trans =
          await ProxyService.realm.getTransactionById(id: transaction!.id!);

      TaxController(object: trans).handleReceipt(
        purchaseCode: purchaseCode,
        printCallback: (Uint8List bytes) async {
          formKey.currentState?.reset();
          ref.refresh(loadingProvider.notifier);

          // receivedAmountController.clear();
          ref.read(loadingProvider.notifier).state = false;
          ref.refresh(loadingProvider.notifier);
          ref.read(isProcessingProvider.notifier).stopProcessing();
          ref.refresh(pendingTransactionProvider(
              (mode: TransactionType.sale, isExpense: false)));

          await printing(bytes);
        },
      );
    } catch (e) {
      talker.error(e);
    }
  }

  Future<void> printing(Uint8List bytes) async {
    final printers = await Printing.listPrinters();

    if (printers.isNotEmpty) {
      Printer? pri = await Printing.pickPrinter(
          context: context, title: "List of printers");

      await Printing.directPrintPdf(
          printer: pri!, onLayout: (PdfPageFormat format) async => bytes);
    }
  }

  Future<void> confirmPayment(
      {required String paymentType,
      required double amount,
      required ITransaction transaction,
      required double discount}) async {
    if (transaction.customerId != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          final double height = MediaQuery.of(context).size.height;
          final double adjustedHeight = height * 0.8;

          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: Colors.grey[100],
            title: Text(
              'Digital Receipt',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.blue[800]),
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: adjustedHeight),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: purchaseCodeFormkey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          'Do you need a digital receipt?',
                          style:
                              TextStyle(fontSize: 18, color: Colors.grey[800]),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24),
                        TextFormField(
                          controller: purchasecodecontroller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Purchase Code',
                            // filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon:
                                Icon(Icons.receipt, color: Colors.blue[800]),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a purchase code';
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            talker.warning("purchase code submitted[1]");
                            _refreshTransactionItems(
                                transactionId: transaction.id!);
                          },
                          onSaved: (value) {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child:
                    Text('Cancel', style: TextStyle(color: Colors.grey[600])),
                onPressed: () {
                  ref.read(isProcessingProvider.notifier).stopProcessing();
                  Navigator.of(context).pop();
                },
              ),
              FlipperButton(
                busy: ref.watch(isProcessingProvider),
                text: 'Submit',
                textColor: Colors.black,
                onPressed: () async {
                  if (purchaseCodeFormkey.currentState?.validate() ?? false) {
                    ref.read(isProcessingProvider.notifier).toggleProcessing();
                    // _purchaseCodeFormkey.currentState?.save();
                    String purchaseCode = purchasecodecontroller.text;
                    talker.warning("received purchase code: $purchaseCode");
                    await handlePayment(
                        transactionType: TransactionType.sale,
                        categoryId: "0",
                        paymentType: paymentType,
                        transaction: transaction,
                        amount: amount,
                        discount: discount,
                        purchaseCode: purchaseCode);
                    ref.read(loadingProvider.notifier).state = false;
                    talker.warning("purchase code submitted[2]");

                    _refreshTransactionItems(transactionId: transaction.id!);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          );
        },
      );
    }

    /// refresh and go home
    ref.refresh(pendingTransactionProvider(
        (mode: TransactionType.sale, isExpense: false)));

    // model.handlingConfirm = false;
  }

  void handleTicketNavigation(ITransaction transaction) {
    final _routerService = locator<RouterService>();
    _routerService.navigateTo(TicketsListRoute(transaction: transaction));
  }

  String getCartItemCount() {
    return ref
            .watch(transactionItemsProvider((isExpense: false)))
            .value
            ?.length
            .toString() ??
        '0';
  }

  double getSumOfItems() {
    final transactionItems =
        ref.watch(transactionItemsProvider((isExpense: false)));

    // Check if the AsyncValue is in a data state (has data)
    if (transactionItems.hasValue) {
      return transactionItems.value!.fold(
        0,
        (sum, item) => sum + (item.price * item.qty),
      );
    } else {
      // Return 0 or handle the case where data is not available
      return 0.0;
    }
  }
}
