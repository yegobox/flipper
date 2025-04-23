// ignore_for_file: unused_result

import 'package:flipper_dashboard/create/category_selector.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:synchronized/synchronized.dart';

class KeyPadView extends StatefulHookConsumerWidget {
  final CoreViewModel model;
  final bool isBigScreen;
  final bool accountingMode;
  final String transactionType;
  final String? categoryId;
  final VoidCallback onConfirm;

  const KeyPadView({
    Key? key,
    required this.model,
    this.isBigScreen = false,
    this.accountingMode = false,
    this.categoryId,
    required this.onConfirm,
    this.transactionType = TransactionType.cashOut,
  }) : super(key: key);

  const KeyPadView.cashBookMode({
    Key? key,
    required this.model,
    this.isBigScreen = false,
    this.categoryId,
    required this.onConfirm,
    required this.accountingMode,
    required this.transactionType,
  }) : super(key: key);

  @override
  KeyPadViewState createState() => KeyPadViewState();
}

class KeyPadViewState extends ConsumerState<KeyPadView> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final paddingHeight = screenHeight * 0.05;
    final keypad = ref.watch(keypadProvider);

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDisplay(paddingHeight, keypad),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return _buildKeypad(constraints);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisplay(double paddingHeight, String keypad) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: widget.accountingMode ? paddingHeight / 2 : paddingHeight,
        horizontal: 24,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: widget.accountingMode
          ? _buildAccountingModeDisplay(keypad)
          : _buildStandardDisplay(keypad),
    );
  }

  Widget _buildAccountingModeDisplay(String keypad) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Column(
      children: [
        Text(
          double.tryParse(keypad)?.toRwf() ?? '0',
          style: GoogleFonts.poppins(
            fontSize: 40 * textScaleFactor,
            fontWeight: FontWeight.w600,
            color: Colors.blue[800],
            height: 1,
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.transactionType == TransactionType.cashIn
                  ? 'Cash in for'
                  : 'Cash out for',
              style: GoogleFonts.poppins(
                fontSize: 18 * textScaleFactor,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
            CategorySelector.transactionMode(),
          ],
        ),
      ],
    );
  }

  Widget _buildStandardDisplay(String keypad) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Text(
      (double.tryParse(keypad) ?? 0.0).toRwf(),
      style: GoogleFonts.poppins(
        fontSize: 40 * textScaleFactor,
        fontWeight: FontWeight.w600,
        color: Colors.blue[800],
        height: 1.5,
      ),
    );
  }

  Widget _buildKeypad(BoxConstraints constraints) {
    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['C', '0', widget.accountingMode ? 'Confirm' : '+'],
    ];

    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: keys
            .map((row) => _buildKeyPadRow(keys: row, constraints: constraints))
            .toList(),
      ),
    );
  }

  Widget _buildKeyPadRow(
      {required List<String> keys, required BoxConstraints constraints}) {
    return Expanded(
      child: Row(
        children: keys
            .map(
                (key) => _buildKeyPadButton(key: key, constraints: constraints))
            .toList(),
      ),
    );
  }

  Widget _buildKeyPadButton(
      {required String key, required BoxConstraints constraints}) {
    final isSpecialKey = ['C', 'Confirm', '+'].contains(key);
    final backgroundColor = isSpecialKey ? Colors.blue[700] : Colors.white;
    final textColor = isSpecialKey ? Colors.white : Colors.blue[700];

    return Expanded(
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          onTap: () => _handleKeyPress(key),
          splashColor: Colors.blue.withOpacity(0.3),
          child: Center(
            child: key == 'Confirm'
                ? Icon(Icons.check,
                    color: textColor, size: constraints.maxWidth * 0.1)
                : Text(
                    key,
                    style: GoogleFonts.poppins(
                      fontSize: constraints.maxWidth * 0.1,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  void _handleKeyPress(String key) async {
    if (['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'].contains(key)) {
      await _handleNumberKey(key);
    } else {
      await _handleSpecialKey(key);
    }
  }

  Future<void> _handleNumberKey(String key, {ITransaction? transaction}) async {
    if (key.isEmpty ||
        !['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'].contains(key)) {
      return; // Ignore invalid input
    }

    ref.read(keypadProvider.notifier).addKey(key);
    HapticFeedback.lightImpact();
    widget.model.keyboardKeyPressed(
      isExpense: widget.transactionType == TransactionType.cashOut,
      reset: () {
        ref.read(keypadProvider.notifier).reset();
      },
      key: ref.watch(keypadProvider),
    );

    ref.refresh(transactionItemsProvider(transactionId: transaction?.id));
  }

  Future<void> _handleSpecialKey(String key) async {
    final transaction = ref.read(pendingTransactionStreamProvider(
      isExpense:
          widget.transactionType == TransactionType.cashOut ? true : false,
    ));

    if (key == 'C') {
      // Properly handle the clear key by calling the CoreViewModel's handleClearKey method
      List<TransactionItem> items =
          await ProxyService.strategy.transactionItems(
        branchId: (await ProxyService.strategy.activeBranch()).id,
        transactionId: transaction.value?.id,
        doneWithTransaction: false,
        active: false,
      );

      widget.model.handleClearKey(items, transaction.value, () {
        ref.read(keypadProvider.notifier).reset();
      });

      // Also reset the keypad display
      ref.read(keypadProvider.notifier).reset();
      HapticFeedback.lightImpact();
    } else if (key == 'Confirm') {
      await _handleConfirmKey(transaction);
    } else if (key == '+') {
      await _handlePlusKey(transaction);
    }
  }

  Future<void> _handleConfirmKey(AsyncValue<ITransaction> transaction) async {
    final currentValue = ref.read(keypadProvider);
    final amount = double.tryParse(currentValue) ?? 0.0;

    if (amount == 0) {
      return;
    }

    widget.model.keypad.setCashReceived(amount: amount);

    bool? dialogResult = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Save ${widget.transactionType} transaction'),
          content: Text('Are you sure you want to save this transaction?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () async {
                final bool isIncome =
                    (widget.transactionType == TransactionType.cashIn ||
                        widget.transactionType == TransactionType.sale);
                Category? activeCat = await ProxyService.strategy
                    .activeCategory(branchId: ProxyService.box.getBranchId()!);
                if (activeCat == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('A category must be selected'),
                      duration: Duration(seconds: 3),
                      action: SnackBarAction(
                        label: 'OK',
                        onPressed: () {},
                      ),
                    ),
                  );
                  return;
                }
                try {
                  await HandleTransactionFromCashBook(
                    cashReceived: amount,
                    paymentType: ProxyService.box.paymentType() ?? "Cash",
                    discount: 0,
                    transactionType: widget.transactionType,
                    isIncome: isIncome,
                  );
                  Navigator.of(context).pop(true); // Return true on success
                  widget.onConfirm(); // Ensure pop is called
                } catch (e) {
                  talker.error(e);
                  Navigator.of(context)
                      .pop(true); // Return true even on error to close dialog
                  widget.onConfirm(); // Ensure pop is called
                }
              },
            ),
          ],
        );
      },
    );

    if (dialogResult == true) {
      widget.model.keyboardKeyPressed(
        isExpense: widget.transactionType == TransactionType.cashOut,
        key: '+',
        reset: () {
          ref.read(keypadProvider.notifier).reset();
        },
      );

      talker.info(currentValue);
      HapticFeedback.lightImpact();
    }
  }

  Future<void> _handlePlusKey(AsyncValue<ITransaction?> transaction) async {
    HapticFeedback.lightImpact();
    widget.model.keyboardKeyPressed(
      isExpense: widget.transactionType == TransactionType.cashOut,
      key: '+',
      reset: () {
        ref.read(keypadProvider.notifier).reset();
      },
    );
    ref.refresh(transactionItemsProvider(transactionId: transaction.value?.id));
  }

  Future<void> HandleTransactionFromCashBook({
    required String paymentType,
    required double cashReceived,
    required int discount,
    required bool isIncome,
    required String transactionType,
  }) async {
    widget.model.newTransactionPressed = false;
    final lock = Lock();

    try {
      // Use a lock to ensure transaction operations are atomic
      await lock.synchronized(() async {
        // First, ensure we have a transaction by calling manageTransaction directly
        // This follows the pattern used in QuickSellingView
        ITransaction? pendingTransaction =
            await ProxyService.strategy.manageTransaction(
          branchId: ProxyService.box.getBranchId()!,
          transactionType: transactionType,
          isExpense: !isIncome,
        );

        if (pendingTransaction == null) {
          talker.error("Failed to create or get a pending transaction");
          return;
        }

        // Now that we have a valid transaction, we can proceed
        widget.model.keyboardKeyPressed(
          isExpense: !isIncome,
          key: '+',
          reset: () {
            ref.read(keypadProvider.notifier).reset();
          },
        );

        Category? category = await ProxyService.strategy
            .activeCategory(branchId: ProxyService.box.getBranchId()!);
        var shortestSide = MediaQuery.of(context).size.shortestSide;
        var useMobileLayout = shortestSide < 600;

        // For cashbook transactions, the subtotal should be the cash received amount
        double subTotal = cashReceived;

        talker.info("Processing transaction with subtotal: $subTotal");

        // First update the transaction with the correct subtotal
        await ProxyService.strategy.updateTransaction(
          transaction: pendingTransaction,
          subTotal: subTotal,
        );

        // Ensure the transaction is properly updated with the subtotal and marked as complete
        ITransaction updatedTransaction =
            await ProxyService.strategy.collectPayment(
          cashReceived: cashReceived,
          branchId: ProxyService.box.getBranchId()!,
          bhfId: (await ProxyService.box.bhfId()) ?? "00",
          isProformaMode: ProxyService.box.isProformaMode(),
          isTrainingMode: ProxyService.box.isTrainingMode(),
          transaction: pendingTransaction,
          paymentType: paymentType,
          discount: discount.toDouble(),
          transactionType:
              useMobileLayout ? category?.name ?? "" : TransactionType.sale,
          directlyHandleReceipt: false,
          isIncome: isIncome,
          categoryId: category?.id.toString(),
        );

        // Always explicitly update the transaction status to ensure it's marked as complete
        updatedTransaction.status = COMPLETE;
        updatedTransaction.subTotal = subTotal;

        // Use updateTransaction method to ensure the transaction is properly saved
        // Call it twice to ensure the transaction is properly saved
        await ProxyService.strategy.updateTransaction(
          transaction: updatedTransaction,
          status: COMPLETE,
          subTotal: subTotal,
        );

        // Wait a short time to ensure the first update completes
        await Future.delayed(const Duration(milliseconds: 100));

        // Call update again to ensure it's properly saved
        await ProxyService.strategy.updateTransaction(
          transaction: updatedTransaction,
          status: COMPLETE,
          subTotal: subTotal,
        );

        talker.info(
            "Transaction explicitly marked as complete with subtotal: $subTotal");

        // Refresh providers to update UI
        ref.refresh(
            transactionItemsProvider(transactionId: pendingTransaction.id));
        ref.refresh(pendingTransactionStreamProvider(isExpense: !isIncome));
        ref.refresh(dashboardTransactionsProvider);
      });
    } catch (e, s) {
      talker.error("Error in HandleTransactionFromCashBook: $e");
      talker.error(s);
    }
  }
}
