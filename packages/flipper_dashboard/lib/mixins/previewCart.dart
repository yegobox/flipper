// ignore_for_file: unused_result

import 'dart:async';

import 'package:flipper_dashboard/PurchaseCodeForm.dart';
import 'package:flipper_dashboard/TextEditingControllersMixin.dart';
import 'package:flipper_models/providers/date_range_provider.dart';
import 'package:flipper_models/providers/pay_button_provider.dart';
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

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:supabase_models/brick/repository.dart';

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
      final startDate = dateRange.startDate;

      final items = await ProxyService.strategy.transactionItems(
        branchId: ProxyService.box.getBranchId()!,
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
      String orderId = ProxyService.strategy.createStockRequest(items,
          deliveryNote: deliveryNote,
          deliveryDate: startDate,
          mainBranchId: ref.read(selectedSupplierProvider).value!.serverId!);
      await _markItemsAsDone(items, transaction);
      _changeTransactionStatus(transaction: transaction);
      await _refreshTransactionItems(transactionId: transaction.id);

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

  FutureOr<void> _changeTransactionStatus(
      {required ITransaction transaction}) async {
    await ProxyService.strategy
        .updateTransaction(transaction: transaction, status: ORDERING);
  }

  Future<void> _markItemsAsDone(
      List<TransactionItem> items, dynamic pendingTransaction) async {
    markItemAsDoneWithTransaction(
      isDoneWithTransaction: true,
      inactiveItems: items,
      pendingTransaction: pendingTransaction,
    );
  }

  Future<void> _refreshTransactionItems({required String transactionId}) async {
    ref.refresh(freshtransactionItemsProviderByIdProvider(
        (transactionId: transactionId)));

    ref.refresh(pendingTransactionProviderNonStream(
        (isExpense: false, mode: TransactionType.sale)));
    final branchId = ProxyService.box.getBranchId()!;

    /// get new transaction id
    ref.refresh(pendingTransactionProvider(
        (mode: TransactionType.sale, isExpense: false, branchId: branchId)));

    ref.refresh(transactionItemsProvider((isExpense: false)));
  }

  Future<void> applyDiscount(ITransaction transaction) async {
    // get items on cart
    final items = await ProxyService.strategy.transactionItems(
      branchId: ProxyService.box.getBranchId()!,
      transactionId: transaction.id,
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
        ProxyService.strategy.updateTransactionItem(
          transactionItemId: item.id,
          dcRt: discountRate,
          dcAmt: itemDiscountAmount,
        );
      }
      ProxyService.strategy.updateTransaction(
        transaction: transaction,
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
      // Save payment methods
      for (var payment in paymentMethods) {
        ProxyService.strategy.savePaymentType(
          singlePaymentOnly: paymentMethods.length == 1,
          amount: payment.amount,
          transactionId: transaction.id,
          paymentMethod: payment.method,
        );
      }

      // Validate transaction
      if (transaction.subTotal == 0) {
        throw Exception("No Payable");
      }

      final amount = double.tryParse(receivedAmountController.text) ?? 0;
      final discount = double.tryParse(discountController.text) ?? 0;
      final isValid = formKey.currentState?.validate() ?? true;
      final String branchId = (await ProxyService.strategy.activeBranch()).id;
      final paymentType = ProxyService.box.paymentType() ?? "Cash";

      // Get customer if exists
      final customer = await _getCustomer(transaction.customerId);

      if (!isValid) return;

      final isDigitalPaymentEnabled = await ProxyService.strategy
          .isBranchEnableForPayment(currentBranchId: branchId);

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
        await _processCashPayment(
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
      // Example: Stop loading from another widget or function
      ref.read(payButtonLoadingProvider.notifier).stopLoading();
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

        if (customer != null) {
          await additionalInformationIsRequiredToCompleteTransaction(
            amount: amount,
            onComplete: completeTransaction,
            discount: discount,
            paymentType: paymentTypeController.text,
            transaction: transaction,
            context: context,
          );
          final branchId = ProxyService.box.getBranchId()!;

          // Example: Stop loading from another widget or function
          ref.read(payButtonLoadingProvider.notifier).stopLoading();
          ref.refresh(pendingTransactionProvider((
            mode: TransactionType.sale,
            isExpense: false,
            branchId: branchId
          )));
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
          final branchId = ProxyService.box.getBranchId()!;

          ref.read(payButtonLoadingProvider.notifier).stopLoading();
          ref.refresh(pendingTransactionProvider((
            mode: TransactionType.sale,
            isExpense: false,
            branchId: branchId
          )));
        }
      },
      onError: (error) => talker.warning(error),
    );
  }

  Future<void> _processCashPayment({
    required Customer? customer,
    required ITransaction transaction,
    required double amount,
    required double discount,
    required String paymentType,
    required Function completeTransaction,
  }) async {
    if (customer != null) {
      await additionalInformationIsRequiredToCompleteTransaction(
        amount: amount,
        onComplete: completeTransaction,
        discount: discount,
        paymentType: paymentTypeController.text,
        transaction: transaction,
        context: context,
      );
      final branchId = ProxyService.box.getBranchId()!;

      ref.read(payButtonLoadingProvider.notifier).stopLoading();
      ref.refresh(pendingTransactionProvider(
          (mode: TransactionType.sale, isExpense: false, branchId: branchId)));
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
      final branchId = ProxyService.box.getBranchId()!;

      ref.read(payButtonLoadingProvider.notifier).stopLoading();
      ref.refresh(pendingTransactionProvider(
          (mode: TransactionType.sale, isExpense: false, branchId: branchId)));
    }
  }

  /// a method to send payment request
  Future<bool> _sendpaymentRequest({
    required String phoneNumber,
    required int finalPrice,
    required String branchId,
    required String externalId,
  }) async {
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
                                transactionId: transaction.id);
                            Navigator.of(context).pop();
                            final branchId = ProxyService.box.getBranchId()!;
                            ref.refresh(pendingTransactionProvider(
                              (
                                mode: TransactionType.sale,
                                isExpense: false,
                                branchId: branchId
                              ),
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
                        ref
                            .read(payButtonLoadingProvider.notifier)
                            .stopLoading();
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
