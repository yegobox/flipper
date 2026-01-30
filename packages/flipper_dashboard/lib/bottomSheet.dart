// ignore_for_file: unused_result

import 'package:flipper_dashboard/SearchCustomer.dart';
import 'package:flipper_dashboard/widgets/payment_methods_card.dart';
import 'package:flipper_models/helperModels/extensions.dart';
import 'package:flipper_models/providers/digital_payment_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/view_models/coreViewModel.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/dialogs/SharedTicketDialog.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/providers/pay_button_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart'
    as oldProvider;
import 'package:flipper_dashboard/providers/customer_phone_provider.dart';
import 'package:flipper_services/utils.dart';
import 'dart:async';
import 'package:flipper_dashboard/utils/resume_transaction_helper.dart';
import 'package:flipper_dashboard/mixins/transaction_computation_mixin.dart';

import 'data_view_reports/DynamicDataSource.dart';

enum ChargeButtonState {
  initial, // "Charge"
  waitingForPayment, // "Waiting for payment..."
  printingReceipt, // "Printing receipt..."
  failed, // "Payment Failed. Retry?"
}

class BottomSheets {
  static void showBottom({
    required BuildContext context,
    required WidgetRef ref,
    required Function doneDelete,
    required Function onCharge,
    ITransaction? transaction,
  }) {
    if (transaction == null) {
      return; // Handle null case
    }

    WoltModalSheet.show<void>(
      onModalDismissedWithBarrierTap: () {
        ref.read(oldProvider.loadingProvider.notifier).stopLoading();
      },
      barrierDismissible: false,
      enableDrag: false,
      context: context,
      pageListBuilder: (BuildContext context) {
        return [
          WoltModalSheetPage(
            isTopBarLayerAlwaysVisible: false,
            hasSabGradient: false,
            hasTopBarLayer: false,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Modal handle
                  Container(
                    width: 40,
                    height: 4,
                    margin: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Header
                  _BottomSheetHeader(
                    ref: ref,
                    context: context,
                    transaction: transaction,
                  ),
                  Divider(height: 1, color: Colors.grey[200]),
                  // Content
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: _BottomSheetContent(
                        transactionIdInt: transaction.id,
                        transaction: transaction,
                        doneDelete: doneDelete,
                        onCharge: onCharge,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ];
      },
    );
  }
}

class _BottomSheetContent extends ConsumerStatefulWidget {
  const _BottomSheetContent({
    required this.transactionIdInt,
    required this.transaction,
    required this.doneDelete,
    required this.onCharge,
  });
  final String transactionIdInt;
  final ITransaction transaction;
  final Function doneDelete;
  final Function onCharge;

  @override
  ConsumerState<_BottomSheetContent> createState() =>
      _BottomSheetContentState();
}

class _BottomSheetContentState extends ConsumerState<_BottomSheetContent>
    with TickerProviderStateMixin, TransactionComputationMixin {
  ChargeButtonState _chargeState = ChargeButtonState.initial;
  bool _isImmediateCompletion = false; // Track which button was clicked
  String?
  _lastTransactionId; // Track the last transaction ID for payment initialization
  String? _itemToDeleteId; // Track which item's delete button is visible

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TransactionInitializationHelper.initializeSession(
        ref: ref,
        transaction: widget.transaction,
      );
    });
  }

  Future<void> _showParkDialog(BuildContext context) async {
    await showSharedTicketDialog(
      context: context,
      transaction: widget.transaction,
      model: CoreViewModel(),
    );
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  static Future<void> edit({
    required BuildContext context,
    required WidgetRef ref,
    required TransactionItem transactionItem,
    required Function doneDelete,
    required String transactionId,
    required ITransaction transaction,
  }) async {
    TextEditingController newQtyController = TextEditingController();
    newQtyController.text = transactionItem.qty.toString();

    TextEditingController newPriceController = TextEditingController();
    newPriceController.text = transactionItem.price.toString();

    // Create a completer to signal when the edit is complete
    final completer = Completer<bool>();

    WoltModalSheet.show<void>(
      context: context,
      pageListBuilder: (BuildContext context) {
        return [
          WoltModalSheetPage(
            hasSabGradient: false,
            isTopBarLayerAlwaysVisible: false,
            hasTopBarLayer: false,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Modal handle
                  Container(
                    width: 40,
                    height: 4,
                    margin: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Header
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, color: Colors.blue, size: 24),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Edit ${transactionItem.name}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1, color: Colors.grey[200]),
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: StatefulBuilder(
                      builder: (context, setModalState) {
                        double localQty =
                            double.tryParse(newQtyController.text) ??
                            transactionItem.qty.toDouble();
                        final originalUnitPrice =
                            transactionItem.retailPrice ??
                            transactionItem.price;

                        // If price controller is empty, we use the original unit price
                        double localPriceInput =
                            double.tryParse(newPriceController.text) ?? 0.0;

                        // Determine if the user is overriding the price (entering total instead of unit price)
                        bool isPriceOverride =
                            originalUnitPrice > 0 &&
                            localPriceInput > 0 &&
                            localPriceInput != originalUnitPrice;

                        // Calculate total based on whether price is being overridden
                        double localTotal = isPriceOverride
                            ? localPriceInput // When price override, the entered price IS the total
                            : localQty *
                                  (localPriceInput > 0
                                      ? localPriceInput
                                      : originalUnitPrice.toDouble());

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Quantity input with improved styling
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: Row(
                                children: [
                                  // Decrement button (-)
                                  IconButton(
                                    icon: Icon(Icons.remove, color: Colors.red),
                                    onPressed: () {
                                      double currentValue =
                                          double.tryParse(
                                            newQtyController.text,
                                          ) ??
                                          0.0;
                                      if (currentValue > 0) {
                                        newQtyController.text =
                                            (currentValue - 1).toString();
                                        if (newQtyController.text.endsWith(
                                          '.0',
                                        )) {
                                          newQtyController.text =
                                              newQtyController.text.replaceAll(
                                                '.0',
                                                '',
                                              );
                                        }
                                        setModalState(() {});
                                      }
                                    },
                                  ),

                                  // Text field
                                  Expanded(
                                    child: TextFormField(
                                      controller: newQtyController,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                            decimal: true,
                                          ),
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        labelText: 'Quantity',
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 16,
                                        ),
                                      ),
                                      onChanged: (val) {
                                        setModalState(() {
                                          // This will trigger a rebuild with updated values
                                        });
                                      },
                                    ),
                                  ),

                                  // Increment button (+)
                                  IconButton(
                                    icon: Icon(Icons.add, color: Colors.blue),
                                    onPressed: () {
                                      double currentValue =
                                          double.tryParse(
                                            newQtyController.text,
                                          ) ??
                                          0.0;
                                      newQtyController.text = (currentValue + 1)
                                          .toString();
                                      if (newQtyController.text.endsWith(
                                        '.0',
                                      )) {
                                        newQtyController.text = newQtyController
                                            .text
                                            .replaceAll('.0', '');
                                      }
                                      setModalState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            // Price information card
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.blue[100]!),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Unit Price:',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      Container(
                                        width: 100,
                                        child: TextFormField(
                                          controller: newPriceController,
                                          keyboardType:
                                              const TextInputType.numberWithOptions(
                                                decimal: true,
                                              ),
                                          textAlign: TextAlign.end,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          decoration: InputDecoration(
                                            border:
                                                const UnderlineInputBorder(),
                                            contentPadding: EdgeInsets.zero,
                                            isDense: true,
                                            helperText: (() {
                                              final parsedPrice =
                                                  double.tryParse(
                                                    newPriceController.text,
                                                  ) ??
                                                  0;
                                              return parsedPrice > 0 &&
                                                      originalUnitPrice > 0
                                                  ? 'Qty: ${(parsedPrice / originalUnitPrice).toStringAsFixed(2)} (calc.)'
                                                  : null;
                                            })(),
                                            helperStyle: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          onChanged: (val) {
                                            final newPrice =
                                                double.tryParse(val) ?? 0.0;
                                            if (originalUnitPrice > 0 &&
                                                newPrice > 0) {
                                              final newQty =
                                                  newPrice / originalUnitPrice;
                                              newQtyController.text = newQty
                                                  .toStringAsFixed(2);
                                              if (newQtyController.text
                                                  .endsWith('.00')) {
                                                newQtyController.text =
                                                    newQtyController.text
                                                        .replaceAll('.00', '');
                                              }
                                            }
                                            setModalState(() {});
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total:',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue[700],
                                        ),
                                      ),
                                      Text(
                                        localTotal.toCurrencyFormatted(),
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 24),
                            // Action buttons
                            FlipperButton(
                              color: Colors.blue,
                              width: double.infinity,
                              text: 'Update Item',
                              onPressed: () async {
                                final qty = double.tryParse(
                                  newQtyController.text,
                                );
                                final price = double.tryParse(
                                  newPriceController.text,
                                );
                                if (qty != null && qty != 0 && price != null) {
                                  try {
                                    final originalUnitPrice =
                                        transactionItem.retailPrice ??
                                        transactionItem.price;

                                    // Use the same logic as the UI to determine if price is being overridden
                                    bool isPriceOverride =
                                        originalUnitPrice > 0 &&
                                        price > 0 &&
                                        price != originalUnitPrice;

                                    if (isPriceOverride) {
                                      final newQty = price / originalUnitPrice;
                                      await ProxyService.strategy
                                          .updateTransactionItem(
                                            qty: newQty,
                                            price: originalUnitPrice.toDouble(),
                                            ignoreForReport: false,
                                            transactionItemId:
                                                transactionItem.id,
                                          );
                                    } else {
                                      await ProxyService.strategy
                                          .updateTransactionItem(
                                            qty: qty,
                                            price: price,
                                            ignoreForReport: false,
                                            transactionItemId:
                                                transactionItem.id,
                                          );
                                    }

                                    // Force refresh the provider
                                    await ref.refresh(
                                      transactionItemsStreamProvider(
                                        transactionId: transactionId,
                                        branchId: ProxyService.box
                                            .getBranchId()!,
                                      ).future,
                                    );

                                    // Complete with success
                                    completer.complete(true);

                                    if (Navigator.of(context).canPop())
                                      Navigator.of(context).pop();
                                  } catch (e) {
                                    completer.complete(false);
                                    showErrorNotification(
                                      context,
                                      'Error updating item: ${e.toString()}',
                                    );
                                  }
                                }
                              },
                            ),
                            SizedBox(height: 12),
                            FlipperIconButton(
                              icon: Icons.delete_outline,
                              iconColor: (transaction.cashReceived ?? 0) > 0
                                  ? Colors.grey
                                  : Colors.red[400],
                              textColor: (transaction.cashReceived ?? 0) > 0
                                  ? Colors.grey
                                  : Colors.red[400],
                              text: 'Remove Product',
                              onPressed: (transaction.cashReceived ?? 0) > 0
                                  ? () {
                                      showErrorNotification(
                                        context,
                                        'Cannot delete items from a transaction with partial payments',
                                      );
                                    }
                                  : () async {
                                      try {
                                        await ProxyService.strategy
                                            .deleteItemFromCart(
                                              transactionItemId:
                                                  transactionItem,
                                              transactionId: transactionId,
                                            );
                                        Navigator.of(context).pop();
                                        doneDelete();
                                      } catch (e) {
                                        showErrorNotification(
                                          context,
                                          'Error removing product: ${e.toString()}',
                                        );
                                      }
                                    },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ];
      },
    );

    // Wait for the edit to complete
    await completer.future;

    // Ensure the parent widget rebuilds with the updated data
    ref.invalidate(
      transactionItemsStreamProvider(
        transactionId: transactionId,
        branchId: ProxyService.box.getBranchId()!,
      ),
    );
  }

  Future<void> _handleCharge(
    String transactionId,
    double total, {
    bool immediateCompletion = false,
  }) async {
    // Haptic feedback
    HapticFeedback.lightImpact();

    // Validate that a customer has been added
    final customerPhone = ref.read(customerPhoneNumberProvider);
    if (customerPhone == null || customerPhone.isEmpty) {
      showErrorNotification(
        context,
        'Please add a customer to the sale before completing',
      );
      return;
    }

    // Set appropriate state based on completion type
    setState(() {
      _isImmediateCompletion = immediateCompletion;
      if (!immediateCompletion) {
        _chargeState = ChargeButtonState.waitingForPayment;
      } else {
        // For immediate completion, set to printingReceipt to show loading spinner
        _chargeState = ChargeButtonState.printingReceipt;
      }
    });
    ref.read(oldProvider.loadingProvider.notifier).startLoading();

    try {
      // Define callbacks for payment state changes
      void onPaymentConfirmed() {
        if (mounted) {
          setState(() {
            _chargeState = ChargeButtonState.printingReceipt;
          });
        }
      }

      void onPaymentFailed(String error) {
        if (mounted) {
          setState(() {
            _chargeState = ChargeButtonState.failed;
          });
          ref.read(oldProvider.loadingProvider.notifier).stopLoading();
          showErrorNotification(context, error);
        }
      }

      // Call onCharge with callbacks and immediateCompletion flag
      final shouldWaitForPayment = await widget.onCharge(
        transactionId,
        total,
        onPaymentConfirmed,
        onPaymentFailed,
        immediateCompletion,
      );

      // Handle immediate completion (cash payments or immediate completion button)
      if (mounted && (shouldWaitForPayment != true || immediateCompletion)) {
        setState(() {
          _chargeState = ChargeButtonState.initial;
        });
        ref.read(oldProvider.loadingProvider.notifier).stopLoading();
      }
    } catch (e) {
      talker.error('Charge failed: $e');
      if (mounted) {
        setState(() {
          _chargeState = ChargeButtonState.failed;
        });
        ref.read(oldProvider.loadingProvider.notifier).stopLoading();
        showErrorNotification(context, "Error occurred");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen for loading state changes to detect errors during payment
    ref.listen(payButtonStateProvider, (previous, next) {
      // If we're waiting for payment and loading stops, reset the button state.
      final wasLoading = previous?[ButtonType.pay] == true;
      final isNowLoading = next[ButtonType.pay] == true;

      if (_chargeState == ChargeButtonState.printingReceipt &&
          wasLoading &&
          !isNowLoading) {
        if (mounted) {
          setState(() {
            _chargeState = ChargeButtonState.initial;
          });
        }
        Navigator.of(context).pop(); // Close the sheet after payment completes
      }
    });

    final itemsAsync = ref.watch(
      transactionItemsStreamProvider(
        transactionId: widget.transactionIdInt,
        branchId: ProxyService.box.getBranchId()!,
      ),
    );

    // Watch digital payment status
    final digitalPaymentAsync = ref.watch(isDigitalPaymentEnabledProvider);

    // Watch customer phone number to update button state
    final customerPhone = ref.watch(customerPhoneNumberProvider);

    // Watch transaction to get authoritative total
    final transactionAsync = ref.watch(
      transactionByIdProvider(widget.transactionIdInt.toString()),
    );

    // Watch payment methods
    final payments = ref.watch(oldProvider.paymentMethodsProvider);

    // Standardized pre-filling initialization (ensures it happens once both items and transaction are ready)
    String? currentTransactionId =
        (transactionAsync.value ?? widget.transaction).id;
    if (itemsAsync.hasValue &&
        transactionAsync.hasValue &&
        _lastTransactionId != currentTransactionId) {
      _lastTransactionId = currentTransactionId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        standardizedPaymentInitialization(
          ref: ref,
          transaction: transactionAsync.value ?? widget.transaction,
          total: calculateTransactionTotal(
            items: itemsAsync.value ?? [],
            transaction: transactionAsync.value ?? widget.transaction,
          ),
        );
      });
    }

    final alreadyPaid =
        transactionAsync.value?.cashReceived ??
        widget.transaction.cashReceived ??
        0.0;
    final pendingPayment = calculateTotalPaid(payments);
    final totalPaid = alreadyPaid + pendingPayment;

    // Calculate reliable total
    double totalAmount = 0.0;
    if (itemsAsync.asData?.value != null) {
      totalAmount = calculateTransactionTotal(
        items: itemsAsync.asData!.value,
        transaction: transactionAsync.asData?.value ?? widget.transaction,
      );
    } else {
      totalAmount = widget.transaction.subTotal ?? 0.0;
    }

    talker.warning(
      "BottomSheet: Final TotalAmount passed to PaymentMethodsCard: $totalAmount",
    );

    final remainingBalance = calculateRemainingBalance(
      total: totalAmount,
      paid: totalPaid,
    );

    // Debug logging
    talker.warning(
      "BottomSheet: TotalAmount: $totalAmount, TotalPaid: $totalPaid, RemainingBalance: $remainingBalance",
    );

    return itemsAsync.when(
      data: (items) {
        // Get digital payment status, defaulting to false if loading or error
        final isDigitalPaymentEnabled =
            digitalPaymentAsync.asData?.value ?? false;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SearchInputWithDropdown(),
              SizedBox(height: 5),
              _buildItemsList(
                items,
                transaction: transactionAsync.value ?? widget.transaction,
              ),
              SizedBox(height: 20),
              _buildTotalSection(
                items,
                isDigitalPaymentEnabled: isDigitalPaymentEnabled,
                totalPaid: totalPaid,
                remainingBalance: remainingBalance,
                alreadyPaid: alreadyPaid,
                pendingPayment: pendingPayment,
                customerPhone: customerPhone,
                transactionAsync: transactionAsync,
              ),
            ],
          ),
        );
      },
      loading: () => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading items...', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
      error: (error, stack) => Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
              SizedBox(height: 16),
              Text(
                'Error loading items',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                error.toString(),
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _getButtonEnabled(bool isEmpty, String? customerPhone) {
    // Check if customer has been added
    final hasCustomer = customerPhone != null && customerPhone.isNotEmpty;

    return !isEmpty &&
        hasCustomer &&
        _chargeState != ChargeButtonState.waitingForPayment &&
        _chargeState != ChargeButtonState.printingReceipt;
  }

  bool _shouldShowSpinner() {
    return _chargeState == ChargeButtonState.waitingForPayment ||
        _chargeState == ChargeButtonState.printingReceipt;
  }

  String _getButtonText(
    bool isEmpty,
    double total,
    String? customerPhone, [
    double remainingBalance = 0,
  ]) {
    if (isEmpty) return 'Add items to charge';

    // Check if customer has been added
    final hasCustomer = customerPhone != null && customerPhone.isNotEmpty;
    if (!hasCustomer) return 'Add customer to continue';

    switch (_chargeState) {
      case ChargeButtonState.initial:
        return remainingBalance > 0 ? 'Record Payment' : 'Charge Now';
      case ChargeButtonState.waitingForPayment:
        return 'Waiting for payment...';
      case ChargeButtonState.printingReceipt:
        return 'Printing receipt...';
      case ChargeButtonState.failed:
        return 'Payment Failed. Retry?';
    }
  }

  Widget _buildTransactionItem(
    TransactionItem transactionItem, {
    required ITransaction transaction,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.inventory_2_outlined, color: Colors.blue, size: 20),
        ),
        title: Text(
          transactionItem.name,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${formatNumber(transactionItem.price.toDouble())} × ${transactionItem.qty}',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              (transactionItem.price * transactionItem.qty)
                  .toCurrencyFormatted(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.green[700],
              ),
            ),
            SizedBox(width: 8),
            if (_itemToDeleteId == transactionItem.id)
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: (transaction.cashReceived ?? 0) > 0
                    ? () {
                        setState(() {
                          _itemToDeleteId = null;
                        });
                        showErrorNotification(
                          context,
                          'Cannot delete items from a transaction with partial payments',
                        );
                      }
                    : () async {
                        try {
                          await ProxyService.strategy.deleteItemFromCart(
                            transactionItemId: transactionItem,
                            transactionId: widget.transactionIdInt.toString(),
                          );
                          setState(() {
                            _itemToDeleteId = null;
                          });
                          widget.doneDelete();
                        } catch (e) {
                          showErrorNotification(
                            context,
                            'Error removing product: ${e.toString()}',
                          );
                        }
                      },
                style: IconButton.styleFrom(
                  backgroundColor: Colors.red[50],
                  padding: EdgeInsets.all(8),
                ),
              )
            else
              GestureDetector(
                onLongPress: () {
                  setState(() {
                    _itemToDeleteId = transactionItem.id;
                  });
                  // Auto-hide after 5 seconds
                  Future.delayed(Duration(seconds: 5), () {
                    if (mounted && _itemToDeleteId == transactionItem.id) {
                      setState(() {
                        _itemToDeleteId = null;
                      });
                    }
                  });
                },
                child: IconButton(
                  icon: Icon(Icons.edit_outlined, color: Colors.blue),
                  onPressed: () {
                    edit(
                      doneDelete: widget.doneDelete,
                      context: context,
                      ref: ref,
                      transactionItem: transactionItem,
                      transactionId: widget.transactionIdInt.toString(),
                      transaction: transaction,
                    );
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.blue[50],
                    padding: EdgeInsets.all(8),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsList(
    List<TransactionItem> items, {
    required ITransaction transaction,
  }) {
    if (items.isEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              'No items in cart',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            'Items (${items.length})',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ),
        SizedBox(height: 12),
        ...items
            .map(
              (item) => _buildTransactionItem(item, transaction: transaction),
            )
            .toList(),
        PaymentMethodsCard(
          transactionId: widget.transactionIdInt,
          totalPayable: calculateRemainingBalance(
            total: calculateTransactionTotal(
              items: items,
              transaction: transaction,
            ),
            paid: transaction.cashReceived ?? 0.0,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalSection(
    List<TransactionItem> items, {
    required bool isDigitalPaymentEnabled,
    required double totalPaid,
    required double remainingBalance,
    required double alreadyPaid,
    required double pendingPayment,
    required String? customerPhone,
    required AsyncValue<ITransaction?> transactionAsync,
  }) {
    final total = calculateTransactionTotal(
      items: items,
      transaction: transactionAsync.value ?? widget.transaction,
    );

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FlipperButtonFlat(
                textColor:
                    (transactionAsync.value?.cashReceived ?? 0) > 0 ||
                        items.isEmpty
                    ? Colors.grey
                    : Colors.red[600],
                onPressed: items.isEmpty
                    ? null
                    : () {
                        if ((transactionAsync.value?.cashReceived ?? 0) > 0) {
                          showErrorNotification(
                            context,
                            'Cannot clear items from a transaction with partial payments',
                          );
                          return;
                        }
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Clear All Items'),
                            content: Text(
                              'Are you sure you want to remove all items from the cart?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  try {
                                    for (TransactionItem item in items) {
                                      await ProxyService.strategy
                                          .deleteItemFromCart(
                                            transactionItemId: item,
                                            transactionId: widget
                                                .transactionIdInt
                                                .toString(),
                                          );
                                    }
                                    ref.refresh(
                                      transactionItemsStreamProvider(
                                        transactionId: widget.transactionIdInt,
                                        branchId: ProxyService.box
                                            .getBranchId()!,
                                      ),
                                    );
                                    widget.doneDelete();
                                    Navigator.pop(context);
                                  } catch (e) {
                                    showErrorNotification(
                                      context,
                                      'Error clearing cart: ${e.toString()}',
                                    );
                                  }
                                },
                                child: Text(
                                  'Clear All',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                text: 'Clear All',
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Total Amount',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    Text(
                      total.toCurrencyFormatted(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                    if (alreadyPaid > 0) ...[
                      SizedBox(height: 4),
                      Text(
                        'Already Paid: ${alreadyPaid.toCurrencyFormatted()}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                    Text(
                      'Remaining Balance: ${remainingBalance.toCurrencyFormatted()}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[700],
                      ),
                    ),
                    if (pendingPayment > 0) ...[
                      SizedBox(height: 8),
                      Divider(height: 1, color: Colors.grey[300]),
                      SizedBox(height: 8),
                      Text(
                        'This Payment: ${pendingPayment.toCurrencyFormatted()}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue[600],
                        ),
                      ),
                      Text(
                        remainingBalance > 0
                            ? 'Balance after payment: ${remainingBalance.toCurrencyFormatted()}'
                            : 'Change: ${(alreadyPaid + pendingPayment - total).toCurrencyFormatted()}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: remainingBalance > 0
                              ? Colors.orange[700]
                              : Colors.green[700],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          if (items.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 12),
              child: SaveTicketButton(
                onPressed: () => _showParkDialog(context),
              ),
            ),
          // Conditional button layout based on digital payment status
          if (isDigitalPaymentEnabled) ...[
            // Two-button layout when digital payment is enabled
            SizedBox(
              height: 56,
              child: Row(
                children: [
                  // Left button: Charge (waits for payment)
                  Expanded(
                    child: FlipperButton(
                      height: 56,
                      color: Colors.blue.shade700,
                      text: _getButtonText(
                        items.isEmpty,
                        total,
                        customerPhone,
                        remainingBalance,
                      ),
                      textColor: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                      isLoading:
                          !_isImmediateCompletion && _shouldShowSpinner(),
                      onPressed: _getButtonEnabled(items.isEmpty, customerPhone)
                          ? () => _handleCharge(
                              widget.transactionIdInt.toString(),
                              total,
                              immediateCompletion: false,
                            )
                          : null,
                    ),
                  ),
                  // Divider
                  Container(width: 1, height: 56, color: Colors.grey.shade300),
                  // Right button: Complete Now (immediate)
                  Expanded(
                    child: FlipperButton(
                      height: 56,
                      color: Colors.green,
                      text: remainingBalance > 0.01
                          ? 'Record Payment'
                          : 'Complete Now',
                      textColor: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      isLoading: _isImmediateCompletion && _shouldShowSpinner(),
                      onPressed: _getButtonEnabled(items.isEmpty, customerPhone)
                          ? () => _handleCharge(
                              widget.transactionIdInt.toString(),
                              total,
                              immediateCompletion: true,
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            // Single button when digital payment is disabled
            FlipperButton(
              height: 56,
              width: double.infinity,
              color: Colors.green,
              text: remainingBalance > 0.01 ? 'Record Payment' : 'Complete Now',
              textColor: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12)),
              isLoading: _isImmediateCompletion && _shouldShowSpinner(),
              onPressed: _getButtonEnabled(items.isEmpty, customerPhone)
                  ? () => _handleCharge(
                      widget.transactionIdInt.toString(),
                      total,
                      immediateCompletion: true,
                    )
                  : null,
            ),
          ],
        ],
      ),
    );
  }
}

class _BottomSheetHeader extends HookConsumerWidget {
  final WidgetRef ref;
  final BuildContext context;
  final ITransaction transaction;

  const _BottomSheetHeader({
    required this.ref,
    required this.context,
    required this.transaction,
  });

  Color _getStatusColor(String? status) {
    switch (status?.toUpperCase()) {
      case 'COMPLETED':
        return Colors.green;
      case 'PENDING':
        return Colors.orange;
      case 'PARKED':
        return Colors.blue;
      case 'CANCELLED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerPhone = ref.watch(customerPhoneNumberProvider);

    // Watch the transaction provider to get live updates
    final transactionAsync = ref.watch(
      transactionByIdProvider(transaction.id.toString()),
    );

    // Use the latest transaction data or fall back to the passed transaction
    final currentTransaction = transactionAsync.value ?? transaction;

    final attachedCustomerAsync = ref.watch(
      oldProvider.attachedCustomerProvider(currentTransaction.customerId),
    );

    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
      child: Row(
        children: [
          // Customer info
          if (currentTransaction.customerId != null ||
              (customerPhone != null && customerPhone.isNotEmpty))
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.person, size: 16, color: Colors.blue),
                SizedBox(width: 4),
                attachedCustomerAsync.maybeWhen(
                  data: (customer) => Text(
                    customer?.custNm ??
                        currentTransaction.customerName ??
                        customerPhone ??
                        'Customer',
                    style: TextStyle(color: Colors.blue, fontSize: 14),
                  ),
                  orElse: () => Text(
                    currentTransaction.customerName ??
                        customerPhone ??
                        'Customer',
                    style: TextStyle(color: Colors.blue, fontSize: 14),
                  ),
                ),
              ],
            ),
          SizedBox(width: 12),
          // Transaction status
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(currentTransaction.status),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              currentTransaction.status?.toUpperCase() ?? 'PENDING',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.close, color: Colors.grey[600]),
            onPressed: () {
              ref.read(oldProvider.loadingProvider.notifier).stopLoading();
              Navigator.of(context).pop();
            },
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey[100],
              padding: EdgeInsets.all(8),
            ),
          ),
        ],
      ),
    );
  }
}
