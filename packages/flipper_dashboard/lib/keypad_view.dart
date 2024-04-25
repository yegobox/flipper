// ignore_for_file: unused_result

library pos;

import 'dart:developer';

import 'package:flipper_dashboard/create/category_selector.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
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
        onTap: () async =>
            {await widget.model.keyboardKeyPressed(key: widget.value)},
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
  final bool transactionMode;
  final String transactionType;
  KeyPadView(
      {Key? key,
      required this.model,
      this.isBigScreen = false,
      this.transactionMode = false,
      this.transactionType = 'custom'})
      : super(key: key);
  KeyPadView.cashBookMode(
      {Key? key,
      required this.model,
      this.isBigScreen = false,
      required this.transactionMode,
      required this.transactionType})
      : super(key: key);

  @override
  KeyPadViewState createState() => KeyPadViewState();
}

class KeyPadViewState extends ConsumerState<KeyPadView> {
  @override
  Widget build(BuildContext context) {
    final transaction =
        ref.watch(pendingTransactionProvider(widget.transactionType));
    Widget plusOrSubmit;
    if (widget.transactionMode == false) {
      plusOrSubmit = Expanded(
        child: InkWell(
          splashColor: Color(0xFFDFF0FF),
          onTap: () async {
            HapticFeedback.lightImpact();
            await widget.model.keyboardKeyPressed(key: '+');
            ref.refresh(transactionItemsProvider(transaction.value?.value?.id));
          },
          child: Container(
            height: MediaQuery.of(context).size.height *
                0.2, // 20% of screen height
            width: MediaQuery.of(context).size.width,

            alignment: Alignment.center,
            child: Text(
              '+',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 38,
                  color: Colors.black),
            ),
          ),
        ),
      );
    } else {
      plusOrSubmit = Expanded(
        child: InkWell(
          splashColor: Color(0xFFDFF0FF),
          onTap: () async {
            log("Key: " + widget.model.key);
            widget.model.keypad.setCashReceived(
                amount: double.tryParse(widget.model.key) ?? 0.0);
            bool confirmed = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Save ${widget.transactionType} transaction'),
                  content:
                      Text('Are you sure you want to save this transaction?'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
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
              if (int.tryParse(widget.model.key) == null ||
                  int.tryParse(widget.model.key) == 0) {
                return;
              }
              await widget.model.keyboardKeyPressed(key: '+');

              await widget.model.collectPayment(
                paymentType: 'Cash',
                transaction: transaction.value!.value!,
                amountReceived: double.parse(widget.model.key),
              );
              HapticFeedback.lightImpact();
            }
          },
          child: Container(
            height: MediaQuery.of(context).size.height *
                0.2, // 20% of screen height
            width: MediaQuery.of(context).size.width,

            alignment: Alignment.center,
            child: Icon(Icons.check, color: Colors.black, size: 38),
          ),
        ),
      );
    }
    final screenHeight = widget.isBigScreen ? 200 : 600;
    final paddingHeight = screenHeight * 0.1; // 10% of screen height
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min, // set main axis size to min
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                vertical:
                    widget.transactionMode ? paddingHeight / 3 : paddingHeight),
            child: widget.transactionMode
                ? SizedBox(
                    height: 80,
                    child: Column(
                      children: [
                        Text(
                          NumberFormat('#,###').format(
                                  double.parse(widget.model.keypad.key)) +
                              " RWF",
                          style: GoogleFonts.poppins(
                            fontSize: 35,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff000000),
                            height: widget.transactionMode ? 1 : 1.5,
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 10),
                            widget.transactionType == 'Cash In'
                                ? Text('Cash in for',
                                    style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold))
                                : Text('Cash out for',
                                    style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                            Spacer(),
                            CategorySelector.transactionMode(
                                categories: widget.model.categories),
                          ],
                        )
                      ],
                    ),
                  )
                : Text(
                    NumberFormat('#,###').format(
                            double.tryParse(widget.model.keypad.key) ?? 0.0) +
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: InkWell(
                    splashColor: Color(0xFFDFF0FF),
                    onTap: () async {
                      HapticFeedback.lightImpact();
                      await widget.model.keyboardKeyPressed(key: '1');
                      ref.refresh(transactionItemsProvider(
                          transaction.value?.value?.id));
                    },
                    child: Container(
                        height: MediaQuery.of(context).size.height *
                            0.2, // 20% of screen height
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        child: Text(
                          '1',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 38,
                              color: Colors.black),
                        )),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    splashColor: Color(0xFFDFF0FF),
                    onTap: () async {
                      HapticFeedback.lightImpact();
                      await widget.model.keyboardKeyPressed(key: '2');
                      ref.refresh(transactionItemsProvider(
                          transaction.value?.value?.id));
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height *
                          0.2, // 20% of screen height
                      width: MediaQuery.of(context).size.width,

                      alignment: Alignment.center,
                      child: Text(
                        '2',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 38,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    splashColor: Color(0xFFDFF0FF),
                    onTap: () async {
                      HapticFeedback.lightImpact();
                      await widget.model.keyboardKeyPressed(key: '3');
                      ref.refresh(transactionItemsProvider(
                          transaction.value?.value?.id));
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height *
                          0.2, // 20% of screen height
                      width: MediaQuery.of(context).size.width,

                      alignment: Alignment.center,
                      child: Text(
                        '3',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 38,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    splashColor: Color(0xFFDFF0FF),
                    onTap: () async {
                      HapticFeedback.lightImpact();
                      await widget.model.keyboardKeyPressed(key: '4');
                      ref.refresh(transactionItemsProvider(
                          transaction.value?.value?.id));
                    },
                    child: Container(
                        height: MediaQuery.of(context).size.height *
                            0.2, // 20% of screen height
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        child: Text(
                          '4',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 38,
                              color: Colors.black),
                        )),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    splashColor: Color(0xFFDFF0FF),
                    onTap: () async {
                      HapticFeedback.lightImpact();
                      await widget.model.keyboardKeyPressed(key: '5');
                      ref.refresh(transactionItemsProvider(
                          transaction.value?.value?.id));
                    },
                    child: Container(
                        height: MediaQuery.of(context).size.height *
                            0.2, // 20% of screen height
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        child: Text(
                          '5',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 38,
                              color: Colors.black),
                        )),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    splashColor: Color(0xFFDFF0FF),
                    onTap: () async {
                      HapticFeedback.lightImpact();
                      await widget.model.keyboardKeyPressed(key: '6');
                      ref.refresh(transactionItemsProvider(
                          transaction.value?.value?.id));
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height *
                          0.2, // 20% of screen height
                      width: MediaQuery.of(context).size.width,

                      alignment: Alignment.center,
                      child: Text(
                        '6',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 38,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    splashColor: Color(0xFFDFF0FF),
                    onTap: () async {
                      HapticFeedback.lightImpact();
                      await widget.model.keyboardKeyPressed(key: '7');
                      ref.refresh(transactionItemsProvider(
                          transaction.value?.value?.id));
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height *
                          0.2, // 20% of screen height
                      width: MediaQuery.of(context).size.width,

                      alignment: Alignment.center,
                      child: Text(
                        '7',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 38,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    splashColor: Color(0xFFDFF0FF),
                    onTap: () async {
                      HapticFeedback.lightImpact();
                      await widget.model.keyboardKeyPressed(key: '8');
                      ref.refresh(transactionItemsProvider(
                          transaction.value?.value?.id));
                    },
                    child: Container(
                        height: MediaQuery.of(context).size.height *
                            0.2, // 20% of screen height
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        child: Text(
                          '8',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 38,
                              color: Colors.black),
                        )),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    splashColor: Color(0xFFDFF0FF),
                    onTap: () async {
                      HapticFeedback.lightImpact();
                      await widget.model.keyboardKeyPressed(key: '9');
                      ref.refresh(transactionItemsProvider(
                          transaction.value?.value?.id));
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height *
                          0.2, // 20% of screen height
                      width: MediaQuery.of(context).size.width,

                      alignment: Alignment.center,
                      child: Text(
                        '9',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 38,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    splashColor: Color(0xFFDFF0FF),
                    onTap: () async {
                      HapticFeedback.lightImpact();
                      await widget.model.keyboardKeyPressed(key: 'C');
                      ref.refresh(transactionItemsProvider(
                          transaction.value?.value?.id));
                    },
                    child: Container(
                        height: MediaQuery.of(context).size.height *
                            0.2, // 20% of screen height
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        child: Text(
                          'C',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 38,
                              color: Colors.black),
                        )),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    splashColor: Color(0xFFDFF0FF),
                    onTap: () async {
                      HapticFeedback.lightImpact();
                      await widget.model.keyboardKeyPressed(key: '0');
                      ref.refresh(transactionItemsProvider(
                          transaction.value?.value?.id));
                    },
                    child: Container(
                        height: MediaQuery.of(context).size.height *
                            0.2, // 20% of screen height
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        child: Text(
                          '0',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 38,
                              color: Colors.black),
                        )),
                  ),
                ),
                plusOrSubmit,
              ],
            ),
          ),
        ],
      ),
    );
  }

  void HandleTransactionFromCashBook() async {
    /// this will close the keypad
    widget.model.newTransactionPressed = false;
    final transaction =
        ref.watch(pendingTransactionProvider(widget.transactionType));
    await widget.model.keyboardKeyPressed(key: '+');
    widget.model
        .saveCashBookTransaction(cbTransactionType: widget.transactionType);
    ref.refresh(transactionItemsProvider(transaction.value?.value?.id));
  }
}
