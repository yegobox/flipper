// ignore_for_file: unused_result

library pos;

import 'dart:developer';

import 'package:flipper_dashboard/create/category_selector.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:universal_platform/universal_platform.dart';

final isMacOs = UniversalPlatform.isMacOS;
final isWindows = UniversalPlatform.isWindows;

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class KeyboardKey extends StatefulHookConsumerWidget {
  final String value;
  final CoreViewModel model;
  const KeyboardKey({
    Key? key,
    required this.model,
    required this.value,
  }) : super(key: key);

  @override
  KeyboardKeyState createState() => KeyboardKeyState();
}

class KeyboardKeyState extends ConsumerState<KeyboardKey> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: MediaQuery.of(context).size.height * 0.2, // 20% of screen height
      child: InkWell(
        onTap: () async => {
          await widget.model.keyboardKeyPressed(
            key: widget.value,
            reset: () {
              ref.read(keypadProvider.notifier).reset();
            },
          )
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromRGBO(0, 0, 0, 0.2),
              width: 0,
            ),
          ),
          child: Center(
            child: Text(
              widget.value,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontSize: 30, fontWeight: FontWeight.normal),
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class KeyPadView extends StatefulHookConsumerWidget {
  final CoreViewModel model;
  final bool isBigScreen;
  final bool accountingMode;
  final String transactionType;

  const KeyPadView({
    Key? key,
    required this.model,
    this.isBigScreen = false,
    this.accountingMode = false,
    this.transactionType = TransactionType.sale,
  }) : super(key: key);

  const KeyPadView.cashBookMode({
    Key? key,
    required this.model,
    this.isBigScreen = false,
    required this.accountingMode,
    required this.transactionType,
  }) : super(key: key);

  @override
  KeyPadViewState createState() => KeyPadViewState();
}

class KeyPadViewState extends ConsumerState<KeyPadView> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = widget.isBigScreen ? 200 : 600;
    final paddingHeight = screenHeight * 0.1; // 10% of screen height
    final keypad = ref.watch(keypadProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              vertical:
                  widget.accountingMode ? paddingHeight / 3 : paddingHeight),
          child: widget.accountingMode
              ? SizedBox(
                  height: 80,
                  child: Column(
                    children: [
                      Text(
                        NumberFormat('#,###').format(double.parse(keypad)) +
                            " RWF",
                        style: GoogleFonts.poppins(
                          fontSize: 35,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff000000),
                          height: widget.accountingMode ? 1 : 1.5,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 10),
                          widget.transactionType == TransactionType.cashIn
                              ? Text('Cash in for',
                                  style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold))
                              : Text('Cash out for',
                                  style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                          Spacer(),
                          CategorySelector.transactionMode(),
                        ],
                      )
                    ],
                  ),
                )
              : Text(
                  NumberFormat('#,###').format(double.tryParse(keypad) ?? 0.0) +
                      " RWF",
                  style: GoogleFonts.poppins(
                    fontSize: 35,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff000000),
                    height: 1.5,
                  ),
                ),
        ),
        Expanded(
          child: Column(
            children: [
              _buildKeyPadRow(
                keys: ['1', '2', '3'],
                onTap: _handleNumberKey,
              ),
              _buildKeyPadRow(
                keys: ['4', '5', '6'],
                onTap: _handleNumberKey,
              ),
              _buildKeyPadRow(
                keys: ['7', '8', '9'],
                onTap: _handleNumberKey,
              ),
              _buildKeyPadRow(
                keys: ['C', '0', widget.accountingMode ? 'Confirm' : '+'],
                onTap: _handleSpecialKey,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKeyPadButton({
    required String key,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return InkWell(
      splashColor: Color(0xFFDFF0FF),
      onTap: onTap,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: child,
      ),
    );
  }

  Widget _buildKeyPadRow({
    required List<String> keys,
    required Function(String key) onTap,
  }) {
    return Expanded(
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: keys.map((key) {
        return Expanded(
            child: _buildKeyPadButton(
          key: key,
          onTap: () => onTap(key),
          child: key == 'Confirm'
              ? Icon(Icons.check, color: Colors.black, size: 38)
              : Text(
                  key,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 38,
                    color: Colors.black,
                  ),
                ),
        ));
      }).toList(),
    ));
  }

  Future<void> _handleNumberKey(String key) async {
    ref.read(keypadProvider.notifier).addKey(key);
    HapticFeedback.lightImpact();
    await widget.model.keyboardKeyPressed(
      reset: () {
        ref.read(keypadProvider.notifier).reset();
      },
      key: ref.watch(keypadProvider),
    );
    ref.refresh(transactionItemsProvider(ref
        .read(pendingTransactionProvider(widget.transactionType))
        .value
        ?.id));
  }

  Future<void> _handleSpecialKey(String key) async {
    final transaction =
        ref.read(pendingTransactionProvider(widget.transactionType));

    if (key == 'C') {
      await _handleNumberKey(key);
    } else if (key == 'Confirm') {
      await _handleConfirmKey(transaction, key);
    } else if (key == '+') {
      await _handlePlusKey(transaction);
    } else {
      await _handleNumberKey(key);
    }
  }

  Future<void> _handleConfirmKey(
      AsyncValue<ITransaction> transaction, String key) async {
    log("Key: ${key}");
    widget.model.keypad.setCashReceived(amount: double.tryParse(key) ?? 0.0);
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
                HandleTransactionFromCashBook();
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
    if (confirmed) {
      if (int.tryParse(key) == null || int.tryParse(key) == 0) {
        return;
      }
      await widget.model.keyboardKeyPressed(
        key: '+',
        reset: () {
          ref.read(keypadProvider.notifier).reset();
        },
      );
      await widget.model.collectPayment(
        paymentType: 'Cash',
        discount: 0,
        transaction: transaction.value!,
        amountReceived: double.parse(key),
      );
      HapticFeedback.lightImpact();
    }
  }

  Future<void> _handlePlusKey(AsyncValue<ITransaction?> transaction) async {
    HapticFeedback.lightImpact();
    await widget.model.keyboardKeyPressed(
      key: '+',
      reset: () {
        ref.read(keypadProvider.notifier).reset();
      },
    );
    ref.refresh(transactionItemsProvider(transaction.value?.id));
  }

  void HandleTransactionFromCashBook() async {
    widget.model.newTransactionPressed = false;
    final transaction =
        ref.watch(pendingTransactionProvider(widget.transactionType));
    await widget.model.keyboardKeyPressed(
      key: '+',
      reset: () {
        ref.read(keypadProvider.notifier).reset();
      },
    );
    widget.model
        .saveCashBookTransaction(cbTransactionType: widget.transactionType);
    ref.refresh(transactionItemsProvider(transaction.value?.id));
  }
}
