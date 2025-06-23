// ignore_for_file: unused_result

import 'dart:async';
import 'dart:io';

import 'package:flipper_dashboard/PurchaseCodeForm.dart';
import 'package:flipper_dashboard/TextEditingControllersMixin.dart';
// ignore: unused_import
import 'package:flipper_dashboard/utils/snack_bar_utils.dart';
import 'package:flipper_models/providers/date_range_provider.dart';
import 'package:flipper_models/providers/pay_button_provider.dart';
import 'package:flipper_models/providers/selected_provider.dart';
import 'package:flipper_models/view_models/mixins/_transaction.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flipper_dashboard/utils/stock_validator.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:supabase_models/brick/repository.dart';

// Stock validation functions have been moved to utils/stock_validator.dart

/// Fetches transaction items for the given transaction ID
Future<List<TransactionItem>> _getTransactionItems(
    {required ITransaction transaction}) async {
  final items = transaction.items ?? [];
  return items.where((item) => item.active == true).toList();
}

mixin PreviewCartMixin<T extends ConsumerStatefulWidget>
    on ConsumerState<T>, TransactionMixinOld, TextEditingControllersMixin {
  /// this method will either preview or completeOrder
  Future<void> placeFinalOrder(
      {bool isShoppingFromWareHouse = true,
      required ITransaction transaction,
      required FinanceProvider financeOption}) async {
    ref.read(previewingCart.notifier).state = !ref.read(previewingCart);

    if (!isShoppingFromWareHouse) {
      /// here we just navigate to Quick setting to preview what's on cart
      /// just return as nothing to be done.
      return;
    }

    /// the code is reviewing the cart while shopping as external party e.g a sub branch
    /// shopping to main warehouse

    try {
      String deliveryNote = deliveryNoteCotroller.text;

      final dateRange = ref.watch(dateRangeProvider);
      final startDate = dateRange.startDate;

      final items = await ProxyService.strategy.transactionItems(
        branchId: (await ProxyService.strategy.activeBranch()).id,
        transactionId: transaction.id,
        doneWithTransaction: false,
        active: true,
      );

      /// previewingCart start with state false then if is true then we are previewing stop completing the order
      if (items.isEmpty || ref.read(previewingCart)) {
        // ref.read(toggleProvider.notifier).state = false;
        return;
      }

      // ignore: unused_local_variable
      String orderId = await ProxyService.strategy.createStockRequest(items,
          financeOption: financeOption,
          transaction: transaction,
          deliveryNote: deliveryNote,
          deliveryDate: startDate,
          mainBranchId: ref.read(selectedSupplierProvider)!.serverId!);
      await _markItemsAsDone(items, transaction);
      _changeTransactionStatus(transaction: transaction);
      await _refreshTransactionItems(transactionId: transaction.id);
    } catch (e, s) {
      talker.info(e);
      talker.error(s);
      rethrow;
    }
  }

  FutureOr<void> _changeTransactionStatus(
      {required ITransaction transaction}) async {
    await ProxyService.strategy
        .updateTransaction(transaction: transaction, status: ORDERING);
  }

  Future<void> _markItemsAsDone(
      List<TransactionItem> items, dynamic pendingTransaction) async {
    ProxyService.strategy.markItemAsDoneWithTransaction(
      isDoneWithTransaction: true,
      inactiveItems: items,
      ignoreForReport: false,
      pendingTransaction: pendingTransaction,
    );
  }

  Future<void> _refreshTransactionItems({required String transactionId}) async {
    ref.refresh(transactionItemsProvider(transactionId: transactionId));

    ref.refresh(pendingTransactionStreamProvider(isExpense: false));

    /// get new transaction id
    ref.refresh(pendingTransactionStreamProvider(isExpense: false));

    ref.refresh(transactionItemsProvider(transactionId: transactionId));
  }

  Future<void> applyDiscount(ITransaction transaction) async {
    // get items on cart
    final items = await ProxyService.strategy.transactionItems(
      branchId: (await ProxyService.strategy.activeBranch()).id,
      transactionId: transaction.id,
      doneWithTransaction: false,
      active: true,
    );

    double discountRate = double.tryParse(discountController.text) ?? 0;
    if (discountRate <= 0) return;

    double itemsTotal = 0;

    // Calculate total amount before discount
    for (var item in items) {
      itemsTotal += (item.price.toDouble() * item.qty.toDouble());
    }

    if (itemsTotal <= 0) return;

    // Calculate discount amount based on rate
    final discountAmount = (discountRate * itemsTotal) / 100;
    double remainingDiscount = discountAmount;

    try {
      // Update items
      for (var i = 0; i < items.length; i++) {
        var item = items[i];
        double itemTotal = item.price.toDouble() * item.qty.toDouble();
        double itemDiscountAmount;

        if (i == items.length - 1) {
          // Last item gets remaining discount to avoid rounding issues
          itemDiscountAmount = remainingDiscount;
        } else {
          itemDiscountAmount = (itemTotal / itemsTotal) * discountAmount;
          remainingDiscount -= itemDiscountAmount;
        }
        ProxyService.strategy.updateTransactionItem(
          transactionItemId: item.id,
          dcRt: discountRate,
          ignoreForReport: false,
          dcAmt: itemDiscountAmount,
        );
      }
      ProxyService.strategy.updateTransaction(
        transaction: transaction,
        cashReceived: ProxyService.box.getCashReceived(),
        subTotal: itemsTotal - discountAmount,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> startCompleteTransactionFlow({
    required ITransaction transaction,
    required Function completeTransaction,
    required List<Payment> paymentMethods,
    bool immediateCompletion = false, // New parameter
  }) async {
    try {
      final isValid = formKey.currentState?.validate() ?? true;
      if (!isValid) return;

      // Validate stock levels before proceeding
      final transactionItems =
          await _getTransactionItems(transaction: transaction);
      final outOfStockItems = await validateStockQuantity(transactionItems);
      if (outOfStockItems.isNotEmpty) {
        if (mounted) {
          await showOutOfStockDialog(context, outOfStockItems);
        }
        ref.read(payButtonStateProvider.notifier).stopLoading();
        return;
      }
      // update this transaction as completed
      await ProxyService.strategy.updateTransaction(
        transaction: transaction,
        status: COMPLETE,
        cashReceived: ProxyService.box.getCashReceived(),
      );
      // Save payment methods
      for (var payment in paymentMethods) {
        await ProxyService.strategy.savePaymentType(
          singlePaymentOnly: paymentMethods.length == 1,
          amount: payment.amount,
          transactionId: transaction.id,
          paymentMethod: payment.method,
        );
      }

      // Validate transaction
      if (transaction.subTotal == 0) {
        throw Exception("Please add items in basket to complete a transaction");
      }

      final amount = double.tryParse(receivedAmountController.text) ?? 0;
      final discount = double.tryParse(discountController.text) ?? 0;

      final String branchId = (await ProxyService.strategy.activeBranch()).id;
      final paymentType = ProxyService.box.paymentType() ?? "Cash";

      // Get customer if exists
      final customer = await _getCustomer(transaction.customerId);

      if (!isValid) return;

      final isDigitalPaymentEnabled = await ProxyService.strategy
          // since we need to have updated EBM settings and we rely on internet for that for the bellow platfrom
          // we haven't encountered with hydrating issue excluding windows.
          .isBranchEnableForPayment(
              currentBranchId: branchId,
              fetchRemote:
                  (Platform.isAndroid || Platform.isIOS || Platform.isMacOS));

      if (isDigitalPaymentEnabled && !immediateCompletion) {
        // Process digital payment only if immediateCompletion is false
        await _processDigitalPayment(
          customer: customer,
          transaction: transaction,
          amount: amount,
          discount: discount,
          branchId: branchId,
          completeTransaction: completeTransaction,
          paymentType: paymentType,
        );
      } else {
        // Process cash payment or skip digital payment if immediateCompletion is true
        await _finalStepInCompletingTransaction(
          customer: customer,
          transaction: transaction,
          amount: amount,
          discount: discount,
          paymentType: paymentType,
          completeTransaction: completeTransaction,
        );
      }

      await _refreshTransactionItems(transactionId: transaction.id);
    } catch (e, s) {
      talker.error("Error in complete transaction flow: $e", s);

      /// first check if there is other pending transaction delete it before we set this transaction to pending, this
      /// facilitate to get items back on QuickSell as there is only one pending transaction at a time
      final pendingTransactions = await ProxyService.strategy
          .pendingTransactionFuture(
              branchId: ProxyService.box.getBranchId()!,
              transactionType: TransactionType.sale,
              isExpense: false);

      if (pendingTransactions != null) {
        await ProxyService.strategy
            .flipperDelete(id: pendingTransactions.id, endPoint: 'transaction');
      }
      await ProxyService.strategy.updateTransaction(
        transaction: transaction,
        status: PENDING,
        cashReceived: ProxyService.box.getCashReceived(),
      );
      // Example: Stop loading from another widget or function
      ref.read(payButtonStateProvider.notifier).stopLoading();
      String errorMessage = e
          .toString()
          .split('Caught Exception: ')
          .last
          .replaceAll("Exception: ", "");
      _handlePaymentError(errorMessage, s, context);
      rethrow;
    }
  }

  Future<Customer?> _getCustomer(String? customerId) async {
    if (customerId == null) return null;

    final customers = await ProxyService.strategy.customers(
      id: customerId,
      branchId: ProxyService.box.getBranchId()!,
    );
    return customers.firstOrNull;
  }

  Future<void> _processDigitalPayment({
    required Customer? customer,
    required ITransaction transaction,
    required double amount,
    required double discount,
    required String branchId,
    required Function completeTransaction,
    required String paymentType,
  }) async {
    try {
      final phoneNumber = customer?.telNo?.replaceAll("+", "") ??
          "250${ProxyService.box.currentSaleCustomerPhoneNumber()}";

      await _sendpaymentRequest(
        phoneNumber: phoneNumber,
        branchId: branchId,
        externalId: transaction.id,
        finalPrice: amount.toInt(),
      );

      await ProxyService.strategy.upsertPayment(CustomerPayments(
        phoneNumber: phoneNumber,
        paymentStatus: "pending",
        amountPayable: transaction.subTotal!,
        transactionId: transaction.id,
      ));

      final query = Query(where: [
        Where('transactionId').isExactly(transaction.id),
        Where('paymentStatus').isExactly('completed'),
      ]);

      Repository().subscribeToRealtime<CustomerPayments>(query: query).listen(
        (data) async {
          if (data.isEmpty) return;
          talker.warning("Payment Completed by a user ${data}");

          await _finalStepInCompletingTransaction(
            customer: customer,
            transaction: transaction,
            amount: amount,
            discount: discount,
            paymentType: paymentType,
            completeTransaction: completeTransaction,
          );
        },
        onError: (error) {
          talker.error("Digital payment error: $error");
          throw Exception("Digital payment failed: $error");
        },
      );
    } catch (e) {
      talker.error("Error in digital payment processing: $e");
      rethrow;
    }
  }

  Future<void> _finalStepInCompletingTransaction({
    required Customer? customer,
    required ITransaction transaction,
    required double amount,
    required double discount,
    required String paymentType,
    required Function completeTransaction,
  }) async {
    try {
      if (customer != null) {
        await additionalInformationIsRequiredToCompleteTransaction(
          amount: amount,
          onComplete: completeTransaction,
          discount: discount,
          paymentType: paymentTypeController.text,
          transaction: transaction,
          context: context,
        );
        ref.read(payButtonStateProvider.notifier).stopLoading();
        ref.refresh(pendingTransactionStreamProvider(
          isExpense: false,
        ));
      } else {
        await finalizePayment(
          formKey: formKey,
          customerNameController: customerNameController,
          context: context,
          paymentType: paymentType,
          transactionType: TransactionType.sale,
          transaction: transaction,
          amount: amount,
          onComplete: completeTransaction,
          discount: discount,
        );

        ref.read(payButtonStateProvider.notifier).stopLoading();
        ref.refresh(pendingTransactionStreamProvider(isExpense: false));
      }
    } catch (e) {
      rethrow;
    }
  }

  /// a method to send payment request
  Future<bool> _sendpaymentRequest({
    required String phoneNumber,
    required int finalPrice,
    required String branchId,
    required String externalId,
  }) async {
    try {
      final response = await ProxyService.ht.makePayment(
        payeemessage: "Pay for Goods",
        paymentType: "PaymentNormal",
        externalId: externalId,
        phoneNumber: phoneNumber.replaceAll("+", ""),
        branchId: branchId,
        businessId: ProxyService.box.getBusinessId()!,
        amount: finalPrice,
        flipperHttpClient: ProxyService.http,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

// Helper method to handle payment errors
  void _handlePaymentError(
      dynamic error, StackTrace stackTrace, BuildContext context) {
    String errorMessage;

    if ((ProxyService.box.enableDebug() ?? false)) {
      // In debug mode, show the stack trace
      errorMessage = stackTrace.toString().split('Caught Exception: ').last;
    } else {
      // In production mode, show a user-friendly error message
      errorMessage = error.toString();
      if (error is Exception) {
        errorMessage = error.toString().split('Exception: ').last;
      }
      errorMessage = errorMessage.toString().split('Caught Exception: ').last;
    }

    // Use the standardized snackbar utility
    showCustomSnackBarUtil(
      context,
      errorMessage,
      backgroundColor: Colors.red[600],
      duration: const Duration(seconds: 10),
    );
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
                                transactionId: transaction.id);
                            Navigator.of(context).pop();
                            ref.refresh(pendingTransactionStreamProvider(
                              isExpense: false,
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
                        // Example: Stop loading from another widget or function
                        ref.read(payButtonStateProvider.notifier).stopLoading();
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

  String getCartItemCount({required String transactionId}) {
    return ref
            .watch(transactionItemsProvider(transactionId: transactionId))
            .value
            ?.length
            .toString() ??
        '0';
  }

  double getSumOfItems({String? transactionId}) {
    final transactionItems =
        ref.watch(transactionItemsProvider(transactionId: transactionId));

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
