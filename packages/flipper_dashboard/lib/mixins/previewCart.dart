// ignore_for_file: unused_result

import 'dart:async';
import 'dart:io';

import 'package:flipper_dashboard/PurchaseCodeForm.dart';
import 'package:flipper_dashboard/TextEditingControllersMixin.dart';
import 'package:flipper_dashboard/providers/customer_provider.dart';
// ignore: unused_import
import 'package:flipper_dashboard/utils/snack_bar_utils.dart';
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
import 'package:supabase_models/services/turbo_tax_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Stock validation functions have been moved to utils/stock_validator.dart

/// Fetches transaction items for the given transaction ID
Future<List<TransactionItem>> _getTransactionItems(
    {required ITransaction transaction}) async {
  final items = await ProxyService.strategy.transactionItems(
    branchId: (await ProxyService.strategy.activeBranch()).id,
    transactionId: transaction.id,
    doneWithTransaction: false,
    active: true,
  );
  return items;
}

mixin PreviewCartMixin<T extends ConsumerStatefulWidget>
    on ConsumerState<T>, TransactionMixinOld, TextEditingControllersMixin {
  // Store stream subscription for proper cleanup
  StreamSubscription? _paymentStatusSubscription;
  RealtimeChannel? _paymentStatusChannel;

  // Track if we're already processing a payment to prevent double-processing
  bool _isProcessingPayment = false;

  @override
  void dispose() {
    _paymentStatusSubscription?.cancel();
    _paymentStatusChannel?.unsubscribe();
    super.dispose();
  }

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
          mainBranchId: ref.read(selectedSupplierProvider)!.serverId!,
          subBranchId: ProxyService.box.getBranchId()!,
          deliveryNote: deliveryNote,
          orderNote: null,
          financingId: financeOption.id);
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

  Future<bool> startCompleteTransactionFlow({
    required String transactionId,
    required Function completeTransaction,
    required List<Payment> paymentMethods,
    bool immediateCompletion = false,
    Function? onPaymentConfirmed,
    Function(String)? onPaymentFailed,
  }) async {
    // Store original stock quantities for potential rollback
    final Map<String, double> originalStockQuantities = {};

    try {
      // Fetch the latest transaction from the database to ensure subTotal is up-to-date
      final transaction = await ProxyService.strategy.getTransaction(
          id: transactionId, branchId: ProxyService.box.getBranchId()!);

      if (transaction == null) {
        throw Exception("Transaction not found for completion.");
      }
      final isValid = formKey.currentState?.validate() ?? true;
      if (!isValid) return false;

      // Validate stock levels before proceeding
      final transactionItems =
          await _getTransactionItems(transaction: transaction);
      // Filter out services (itemTyCd == "3") from stock validation
      final itemsToValidate =
          transactionItems.where((item) => item.itemTyCd != "3").toList();
      final outOfStockItems = await validateStockQuantity(itemsToValidate);
      if (outOfStockItems.isNotEmpty) {
        if (mounted) {
          await showOutOfStockDialog(context, outOfStockItems);
        }
        ref.read(payButtonStateProvider.notifier).stopLoading();
        return false;
      }

      // Deduct stock for each transaction item
      for (var item in transactionItems) {
        // Do not deduct stock for services
        if (item.itemTyCd == "3") {
          continue;
        }
        final variant =
            await ProxyService.strategy.getVariant(id: item.variantId!);
        if (variant != null &&
            !(await TurboTaxService.handleProformaOrTrainingMode())) {
          final stock = variant.stock;
          if (stock != null) {
            originalStockQuantities[stock.id] =
                stock.currentStock!; // Store original
            final newStock = stock.currentStock! - item.qty;
            await ProxyService.strategy.updateStock(
                stockId: stock.id, currentStock: newStock, rsdQty: newStock);
          }
        }
      }

      // update this transaction as completed

      final double finalSubTotal = transactionItems.fold(
          0, (sum, item) => sum + (item.price * item.qty));

      await ProxyService.strategy.updateTransaction(
        transaction: transaction,
        status: COMPLETE,
        cashReceived: ProxyService.box.getCashReceived(),
        subTotal: finalSubTotal,
      );
      transaction.subTotal =
          finalSubTotal; // Update the local object's subTotal
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
        throw Exception("Remove item and add them back, we encountered error");
      }

      final amount = double.tryParse(receivedAmountController.text) ?? 0;
      final discount = double.tryParse(discountController.text) ?? 0;

      final String branchId = (await ProxyService.strategy.activeBranch()).id;
      final paymentType = ProxyService.box.paymentType() ?? "Cash";

      // Get customer if exists
      final customer = await _getCustomer(transaction.customerId);

      if (!isValid) return false;

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
          onPaymentConfirmed: onPaymentConfirmed,
          onPaymentFailed: onPaymentFailed,
        );
        // Return true to indicate we're waiting for payment confirmation
        // Bottom sheet should NOT close yet
        return true;
      } else {
        // Process cash payment or skip digital payment if immediateCompletion is true
        await _finalStepInCompletingTransaction(
          customer: customer,
          transaction: transaction,
          amount: amount,
          discount: discount,
          paymentType: paymentType,
          completeTransaction: () async {
            // Show success confirmation before completing
            if (mounted && context.mounted) {
              await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.white,
                    title: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 28),
                        SizedBox(width: 12),
                        Text(
                          'Payment Successful!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                      ],
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Transaction completed successfully.',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Amount: ${transaction.subTotal!.toStringAsFixed(2)} RWF',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Would you like to print a receipt?',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.of(dialogContext).pop();
                          ref
                              .read(payButtonStateProvider.notifier)
                              .stopLoading();
                          completeTransaction();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: Text('Ok'),
                      ),
                    ],
                  );
                },
              );
            } else {
              completeTransaction(); // Fallback if context not available
            }
          },
        );
        // Return false to indicate payment is complete
        // Bottom sheet will close after user confirmation
        return false;
      }
    } catch (e, s) {
      talker.error("Error in complete transaction flow: $e", s);

      // Rollback stock quantities
      for (var entry in originalStockQuantities.entries) {
        final stockId = entry.key;
        final originalStock = entry.value;
        await ProxyService.strategy.updateStock(
            stockId: stockId,
            currentStock: originalStock,
            rsdQty: originalStock);
      }

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
        transactionId: transactionId,
        status: PENDING,
        cashReceived: ProxyService.box.getCashReceived(),
      );

      if (mounted) {
        ref.read(payButtonStateProvider.notifier).stopLoading();
      }
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

  /// Get country calling code from country name
  String _getCountryCallingCode(String? countryName) {
    final countryCodeMap = {
      'Rwanda': '250',
      'Kenya': '254',
      'Uganda': '256',
      'Tanzania': '255',
      'Burundi': '257',
      'South Africa': '27',
      'Zambia': '260',
      'Mozambique': '258',
      'Zimbabwe': '263',
      'Malawi': '265',
      'DRC': '243',
      'Congo': '243',
    };
    return countryCodeMap[countryName] ??
        '250'; // Default to Rwanda if country not found
  }

  Future<void> _processDigitalPayment({
    required Customer? customer,
    required ITransaction transaction,
    required double amount,
    required double discount,
    required String branchId,
    required Function completeTransaction,
    required String paymentType,
    Function? onPaymentConfirmed,
    Function(String)? onPaymentFailed,
  }) async {
    try {
      // customer.telNo from database already has country code (e.g., "+250783054874")
      // currentSaleCustomerPhoneNumber from localStorage is just digits (e.g., "783054874")
      String phoneNumber;
      if (customer?.telNo != null) {
        phoneNumber = customer!.telNo!.replaceAll("+", "");
      } else {
        // Get country code dynamically from business country
        final branch = await ProxyService.strategy.activeBranch();
        final business = await ProxyService.strategy
            .getBusiness(businessId: branch.businessId!);
        final countryCode = _getCountryCallingCode(business?.country);

        String localPhone =
            ProxyService.box.currentSaleCustomerPhoneNumber() ?? "";

        // Remove leading 0 if present (e.g., "0783054874" -> "783054874")
        if (localPhone.startsWith("0")) {
          localPhone = localPhone.substring(1);
        }

        // Only add country code prefix if phone doesn't already start with it
        phoneNumber = localPhone.startsWith(countryCode)
            ? localPhone
            : "$countryCode$localPhone";
      }

      await _sendpaymentRequest(
        phoneNumber: phoneNumber,
        branchId: branchId,
        externalId: transaction.id,
        finalPrice: transaction.subTotal!.toInt(),
      );

      talker.info("📤 Payment request sent to phone: $phoneNumber");
      talker.info("💰 Amount: ${transaction.subTotal!.toInt()}");

      await Supabase.instance.client.from('customer_payments').upsert({
        'phoneNumber': phoneNumber,
        'paymentStatus': "pending",
        'amountPayable': transaction.subTotal!,
        'transactionId': transaction.id,
      });

      talker.info(
          "⏳ Payment status set to PENDING - Waiting for user confirmation...");
      talker.info(
          "🔍 Setting up realtime listener for transaction: ${transaction.id}");

      talker.info(
          "👂 Realtime listener active - Will trigger when payment status = 'completed'");

      // Add timeout for payment confirmation (60 seconds)
      Timer? paymentTimeout = Timer(Duration(seconds: 60), () {
        if (!_isProcessingPayment) {
          talker.warning("⏰ Payment confirmation timeout after 60 seconds");
          onPaymentFailed
              ?.call('Payment confirmation timeout. Please try again.');
          _paymentStatusChannel?.unsubscribe();
        }
      });

      // Cancel any existing subscription
      await _paymentStatusSubscription?.cancel();

      // Create channel with callback
      final channel = Supabase.instance.client
          .channel('customer_payments_${transaction.id}')
          .onPostgresChanges(
            event: PostgresChangeEvent.update,
            schema: 'public',
            table: 'customer_payments',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'transactionId',
              value: transaction.id,
            ),
            callback: (payload) async {
              // Extract the new record from the payload
              final newRecord = payload.newRecord;
              // Filter for completed payments only
              if (newRecord['paymentStatus'] != 'completed') return;

              // Prevent double-processing
              if (_isProcessingPayment) {
                talker.warning(
                    "⚠️ Already processing payment, skipping duplicate event");
                return;
              }

              // Mark as processing
              _isProcessingPayment = true;

              talker.info(
                  "✅ Payment CONFIRMED by user - Status: ${newRecord['paymentStatus']}");
              talker.info(
                  "📱 Phone: ${newRecord['phoneNumber']}, Amount: ${newRecord['amountPayable']}");

              // Check if widget is still mounted before proceeding
              if (!mounted) {
                talker.warning("Widget disposed, skipping payment completion");
                _isProcessingPayment = false;
                return;
              }

              try {
                // Call the onPaymentConfirmed callback to update UI
                onPaymentConfirmed?.call();

                talker.info(
                    "🧾 Starting receipt generation after payment confirmation...");
                await _finalStepInCompletingTransaction(
                  customer: customer,
                  transaction: transaction,
                  amount: amount,
                  discount: discount,
                  paymentType: paymentType,
                  completeTransaction: () {
                    // For digital payments, don't call completeTransaction yet
                    // We'll call it after this succeeds
                    talker.info(
                        "✅ Receipt generation completed for digital payment");
                    talker.info("📄 Receipt successfully saved and synced");
                  },
                );

                // Execution reaches here AFTER _finalStepInCompletingTransaction completes
                talker.info(
                    "🏁 _finalStepInCompletingTransaction returned successfully");

                // Digital payment confirmed and receipt generated successfully
                // NOW we can call the actual completeTransaction callback
                talker.info(
                    "✅ Digital payment completed successfully - Closing bottom sheet");
                talker.info(
                    "⏰ Receipt generation took: ${DateTime.now().toIso8601String()}");
                talker.info(
                    "🔄 Calling completeTransaction callback to close bottom sheet...");
                _isProcessingPayment = false;
                paymentTimeout.cancel(); // Cancel timeout on success
                completeTransaction();
                talker.info(
                    "✅ completeTransaction callback executed - Bottom sheet should now close");
              } catch (e) {
                talker
                    .error("❌ Error completing transaction after payment: $e");
                _isProcessingPayment = false; // Reset flag on error
                paymentTimeout.cancel(); // Cancel timeout on error
                onPaymentFailed
                    ?.call(e.toString().replaceAll('Exception: ', ''));
                rethrow;
              }
            },
          );

      // Subscribe to the channel
      _paymentStatusChannel = channel.subscribe();
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
      // Check if widget is still mounted before using ref
      if (!mounted) {
        talker.warning("Widget disposed, cannot complete transaction");
        return;
      }

      if (customer != null) {
        await additionalInformationIsRequiredToCompleteTransaction(
          amount: amount,
          onComplete: completeTransaction,
          discount: discount,
          paymentType: paymentTypeController.text,
          transaction: transaction,
          context: context,
        );
        if (mounted) {
          ref.read(payButtonStateProvider.notifier).stopLoading();
          ref.refresh(pendingTransactionStreamProvider(
            isExpense: false,
          ));
        }
      } else {
        // Get the controller value before async operations
        final customerNameController = mounted
            ? ref.watch(customerNameControllerProvider)
            : TextEditingController();

        await finalizePayment(
          formKey: formKey,
          countryCodeController: countryCodeController,
          customerNameController: customerNameController,
          context: context,
          paymentType: paymentType,
          transactionType: TransactionType.sale,
          transaction: transaction,
          amount: amount,
          onComplete: completeTransaction,
          discount: discount,
        );

        if (mounted) {
          ref.read(payButtonStateProvider.notifier).stopLoading();
          ref.refresh(pendingTransactionStreamProvider(isExpense: false));
        }
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
              countryCodeController: countryCodeController,
              onComplete: onComplete,
              customerNameController: ref.watch(customerNameControllerProvider),
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
