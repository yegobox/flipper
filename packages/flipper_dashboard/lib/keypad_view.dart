// ignore_for_file: unused_result

import 'dart:developer';

import 'package:flipper_dashboard/create/category_selector.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/DeviceType.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class KeyPadView extends StatefulHookConsumerWidget {
  final CoreViewModel model;
  final bool isBigScreen;
  final bool accountingMode;
  final String transactionType;
  final String categoryId;

  const KeyPadView({
    Key? key,
    required this.model,
    this.isBigScreen = false,
    this.accountingMode = false,
    this.categoryId = "0",
    this.transactionType = TransactionType.cashOut,
  }) : super(key: key);

  const KeyPadView.cashBookMode({
    Key? key,
    required this.model,
    this.isBigScreen = false,
    this.categoryId = "0",
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
      decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          //   colors: [Colors.blue[50]!, Colors.blue[100]!],
          // ),
          ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDisplay(paddingHeight, keypad),
          Expanded(child: _buildKeypad()),
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
          bottomLeft: Radius.circular(4),
          bottomRight: Radius.circular(4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
    return Column(
      children: [
        Text(
          "${NumberFormat('#,###').format(double.parse(keypad))} RWF",
          style: GoogleFonts.poppins(
            fontSize: 40,
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
                fontSize: 18,
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
    return Text(
      "${NumberFormat('#,###').format(double.tryParse(keypad) ?? 0.0)} RWF",
      style: GoogleFonts.poppins(
        fontSize: 40,
        fontWeight: FontWeight.w600,
        color: Colors.blue[800],
        height: 1.5,
      ),
    );
  }

  Widget _buildKeypad() {
    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['C', '0', widget.accountingMode ? 'Confirm' : '+'],
    ];

    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: keys.map((row) => _buildKeyPadRow(keys: row)).toList(),
      ),
    );
  }

  Widget _buildKeyPadRow({required List<String> keys}) {
    return Expanded(
      child: Row(
        children: keys.map((key) => _buildKeyPadButton(key: key)).toList(),
      ),
    );
  }

  Widget _buildKeyPadButton({required String key}) {
    final isSpecialKey = ['C', 'Confirm', '+'].contains(key);
    final backgroundColor = isSpecialKey ? Colors.blue[700] : Colors.white;
    final textColor = isSpecialKey ? Colors.white : Colors.blue[700];

    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Material(
          color: backgroundColor,
          elevation: 4,
          borderRadius: BorderRadius.circular(4),
          child: InkWell(
            borderRadius: BorderRadius.circular(4),
            onTap: () => _handleKeyPress(key),
            child: Center(
              child: key == 'Confirm'
                  ? Icon(Icons.check, color: textColor, size: 32)
                  : Text(
                      key,
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
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

  Future<void> _handleNumberKey(String key) async {
    ref.read(keypadProvider.notifier).addKey(key);
    HapticFeedback.lightImpact();
    widget.model.keyboardKeyPressed(
      isExpense: widget.transactionType == TransactionType.cashOut,
      reset: () {
        ref.read(keypadProvider.notifier).reset();
      },
      key: ref.watch(keypadProvider),
    );
    ref.refresh(transactionItemsProvider(ref
        .read(pendingTransactionProvider((
          widget.transactionType,
          widget.transactionType == TransactionType.cashOut ? true : false
        )))
        .value
        ?.id));
  }

  Future<void> _handleSpecialKey(String key) async {
    final transaction = ref.read(pendingTransactionProvider((
      widget.transactionType,
      widget.transactionType == TransactionType.cashOut ? true : false
    )));

    if (key == 'C') {
      await _handleNumberKey(key);
    } else if (key == 'Confirm') {
      await _handleConfirmKey(transaction, key);
    } else if (key == '+') {
      await _handlePlusKey(transaction);
    }
  }

  Future<void> _handleConfirmKey(
      AsyncValue<ITransaction> transaction, String key) async {
    log("Key: $key");

    // Get the current value from the keypadProvider
    final currentValue = ref.read(keypadProvider);

    // Convert the currentValue to a double
    final amount = double.tryParse(currentValue) ?? 0.0;

    widget.model.keypad.setCashReceived(amount: amount);

    bool confirmed = await showDialog(
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
              onPressed: () {
                // discount, transactionType: transactionType, isIncome: isIncome
                final bool isIncome =
                    (widget.transactionType == TransactionType.cashIn ||
                        widget.transactionType == TransactionType.sale);

                HandleTransactionFromCashBook(
                  cashReceived: amount,
                  paymentType: "Cash",
                  discount: 0,
                  transactionType: widget.transactionType,
                  isIncome: isIncome,
                );
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmed) {
      if (amount == 0 && key != "Confirm") {
        return;
      }
      Category? activeCat = ProxyService.realm
          .activeCategory(branchId: ProxyService.box.getBranchId()!);
      if (activeCat == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('A category must be selected'),
            duration: Duration(seconds: 3),
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {
                // Optional: Add an action when the snackbar is dismissed
              },
            ),
          ),
        );
        return;
      }
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
    ref.refresh(transactionItemsProvider(transaction.value?.id));
  }

  void HandleTransactionFromCashBook(
      {required String paymentType,
      required double cashReceived,
      required int discount,
      required bool isIncome,
      required String transactionType}) {
    widget.model.newTransactionPressed = false;
    final isExpense = (TransactionType.cashOut == widget.transactionType);
    final transaction = ref.watch(pendingTransactionProvider((
      widget.transactionType,
      isExpense,
    )));
    widget.model.keyboardKeyPressed(
      isExpense: widget.transactionType == TransactionType.cashOut,
      key: '+',
      reset: () {
        ref.read(keypadProvider.notifier).reset();
      },
    );
    Category? category = ProxyService.realm
        .activeCategory(branchId: ProxyService.box.getBranchId()!);
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    var useMobileLayout = shortestSide < 600;

    !useMobileLayout
        ? ProxyService.realm.collectPayment(
            cashReceived: cashReceived,
            transaction: transaction.value!,
            paymentType: paymentType,
            discount: discount.toDouble(),

            ///TODO: on big screen we do not have option to select category hence it is always a sale being recorded there
            ///in future we might improve it.
            transactionType: TransactionType.sale,
            categoryId: "0",
            isIncome: isIncome)
        : ProxyService.realm.collectPayment(
            cashReceived: cashReceived,
            transaction: transaction.value!,
            paymentType: paymentType,
            discount: discount.toDouble(),
            categoryId: category?.id.toString(),
            transactionType: category?.name ?? "",
            isIncome: isIncome);
    ref.refresh(transactionItemsProvider(transaction.value?.id));
  }
}
