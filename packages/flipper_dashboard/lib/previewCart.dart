// ignore_for_file: unused_result

import 'package:flipper_dashboard/PurchaseCodeForm.dart';
import 'package:flipper_dashboard/TextEditingControllersMixin.dart';
import 'package:flipper_models/power_sync/schema.dart';
import 'package:flipper_models/realmExtension.dart';
import 'package:flipper_models/states/selectedSupplierProvider.dart';
import 'package:flipper_models/view_models/mixins/_transaction.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:supabase_models/brick/models/all_models.dart' as brick;
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:realm/realm.dart';

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

      final items = ProxyService.local.transactionItems(
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
      int orderId = ProxyService.local.createStockRequest(items,
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
    ProxyService.local.realm!.write(() {
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
  }

  Future<void> applyDiscount(ITransaction transaction) async {
    if (transaction.id == null) return;

    // get items on cart
    final items = await ProxyService.local.transactionItems(
      branchId: ProxyService.box.getBranchId()!,
      transactionId: transaction.id!,
      doneWithTransaction: false,
      active: true,
    );

    double discountRate = double.tryParse(discountController.text) ?? 0;
    if (discountRate <= 0) return;

    double itemsTotal = 0;

    // Calculate total amount before discount
    for (var item in items) {
      itemsTotal += (item.price * item.qty);
    }

    if (itemsTotal <= 0) return;

    // Calculate discount amount based on rate
    final discountAmount = (discountRate * itemsTotal) / 100;
    double remainingDiscount = discountAmount;

    try {
      await ProxyService.local.realm!.writeN(
        tableName: transactionTable,
        writeCallback: () {
          // Update items
          for (var i = 0; i < items.length; i++) {
            var item = items[i];
            double itemTotal = item.price * item.qty;
            double itemDiscountAmount;

            if (i == items.length - 1) {
              // Last item gets remaining discount to avoid rounding issues
              itemDiscountAmount = remainingDiscount;
            } else {
              itemDiscountAmount = (itemTotal / itemsTotal) * discountAmount;
              remainingDiscount -= itemDiscountAmount;
            }

            item.dcRt = discountRate;
            item.dcAmt = itemDiscountAmount;
          }

          // Update transaction
          transaction.subTotal = itemsTotal - discountAmount;
          return transaction;
        },
        onAdd: (data) {
          // ProxyService.backUp.replicateData(transactionTable, data);
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  void startCompleteTransactionFlow({
    required ITransaction transaction,
    required Function completeTransaction,
    required List<Payment> paymentMethods,
  }) async {
    try {
      // Validate transaction ID
      final transactionId = transaction.id;
      if (transactionId == null) {
        throw Exception('Transaction ID is required');
      }

      // Save payment methods
      for (var payment in paymentMethods) {
        ProxyService.local.savePaymentType(
          amount: payment.amount,
          transactionId: transactionId,
          paymentMethod: payment.method,
        );
      }

      // Check subtotal
      if (transaction.subTotal == 0) {
        throw Exception("No Payable");
      }

      // Parse amounts
      final amount = double.tryParse(receivedAmountController.text) ?? 0;
      final discount = double.tryParse(discountController.text) ?? 0;
      final state = (formKey.currentState?.validate() ?? true);

      // Get customer
      Customer? customer =
          await ProxyService.local.getCustomer(id: transaction.customerId);

      // Handle payment based on customer presence
      if (state && customer == null) {
        await finalizePayment(
          formKey: formKey,
          customerNameController: customerNameController,
          context: context,
          paymentType: ProxyService.box.paymentType() ?? "Cash",
          transactionType: TransactionType.sale,
          transaction: transaction,
          amount: amount,
          onComplete: completeTransaction,
          discount: discount,
        );
      } else if (state && customer != null) {
        await additionalInformationIsRequiredToCompleteTransaction(
          amount: amount,
          onComplete: completeTransaction,
          discount: discount,
          paymentType: paymentTypeController.text,
          transaction: transaction,
          context: context,
        );
      }

      // Refresh transaction items only if payment was successful
      await _refreshTransactionItems(transactionId: transactionId);
    } catch (e, s) {
      talker.error(e, s);
      ref.read(loadingProvider.notifier).stopLoading();
      String v = e
          .toString()
          .split('Caught Exception: ')
          .last
          .replaceAll("Exception: ", "");

      ///TODO: this is not nice rmeove it ASAP.
      if (v == "Invoice number already exists.") {
        // talker.error("IIIII");
        // A Quick fix increment counter for now.
        List<brick.Counter> counters = await ProxyService.strategy
            .getCounters(branchId: ProxyService.box.getBranchId()!);

        ProxyService.strategy.updateCounters(counters: counters);
      }
      // Handle general errors
      _handlePaymentError(e, s, context);
      rethrow; // Rethrow the error if needed for upper level handling
    }
  }

// Helper method to handle payment errors
  void _handlePaymentError(
      dynamic error, StackTrace stackTracke, BuildContext context) {
    if (ProxyService.box.enableDebug()!) {
      // show stackTracke instead
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 10),
        backgroundColor: Colors.red,
        content: Text(stackTracke.toString()),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
        closeIconColor: Colors.red,
      ));
    } else {
      String errorMessage = error.toString();
      if (error is Exception) {
        errorMessage = error.toString().split('Exception: ').last;
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 10),
        backgroundColor: Colors.red,
        content: Text(errorMessage.toString().split('Caught Exception: ').last),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
        closeIconColor: Colors.red,
      ));
    }
  }

  Future<void> additionalInformationIsRequiredToCompleteTransaction({
    required String paymentType,
    required double amount,
    required ITransaction transaction,
    required double discount,
    required Function onComplete,
    required BuildContext context,
  }) async {
    if (transaction.customerId != null) {
      await showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          final double height = MediaQuery.of(dialogContext).size.height;
          final double adjustedHeight = height * 0.8;

          return BlocProvider(
            create: (context) => PurchaseCodeFormBloc(
              formKey: formKey,
              onComplete: onComplete,
              customerNameController: customerNameController,
              amount: amount,
              discount: discount,
              paymentType: paymentType,
              transaction: transaction,
              context: dialogContext,
            ),
            child: Builder(
              builder: (context) {
                final formBloc = context.read<PurchaseCodeFormBloc>();

                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Colors.grey[100],
                  title: Text(
                    'Digital Receipt',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  content: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: adjustedHeight),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: FormBlocListener<PurchaseCodeFormBloc, String,
                            String>(
                          onSubmitting: (context, state) {
                            ref
                                .read(isProcessingProvider.notifier)
                                .toggleProcessing();
                          },
                          onSuccess: (context, state) {
                            ref
                                .read(isProcessingProvider.notifier)
                                .stopProcessing();
                            _refreshTransactionItems(
                                transactionId: transaction.id!);
                            Navigator.of(context).pop();

                            ref.refresh(pendingTransactionProvider(
                              (mode: TransactionType.sale, isExpense: false),
                            ));
                          },
                          onFailure: (context, state) {
                            ref
                                .read(isProcessingProvider.notifier)
                                .stopProcessing();
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Text(
                                'Do you need a digital receipt?',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[800],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 24),
                              TextFieldBlocBuilder(
                                textFieldBloc: formBloc.purchaseCode,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Purchase Code',
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.receipt,
                                    color: Colors.blue[800],
                                  ),
                                ),
                                onSubmitted: (value) {
                                  talker.warning("purchase code submitted[1]");
                                  formBloc.submit();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      onPressed: () {
                        ref.read(loadingProvider.notifier).stopLoading();
                        ref
                            .read(isProcessingProvider.notifier)
                            .stopProcessing();
                        Navigator.of(context).pop();
                      },
                    ),
                    BlocBuilder<PurchaseCodeFormBloc, FormBlocState>(
                      builder: (context, state) {
                        return FlipperButton(
                          busy: state is FormBlocSubmitting,
                          text: 'Submit',
                          textColor: Colors.black,
                          onPressed: () => formBloc.submit(),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          );
        },
      );
    }
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
