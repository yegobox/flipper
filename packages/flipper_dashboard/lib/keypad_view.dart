library pos;

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flutter/services.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:intl/intl.dart';
import 'package:flipper_dashboard/create/category_selector.dart';

final isWindows = UniversalPlatform.isWindows;
final isMacOs = UniversalPlatform.isMacOS;

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

// ignore: must_be_immutable
class KeyPadView extends StatelessWidget {
  KeyPadView(
      {Key? key,
      required this.model,
      this.isBigScreen = false,
      this.transactionMode = false,
      this.transactionType = 'n/a'})
      : super(key: key);

  KeyPadView.cashBookMode(
      {Key? key,
      required this.model,
      this.isBigScreen = false,
      required this.transactionMode,
      required this.transactionType})
      : super(key: key);
  final HomeViewModel model;
  final bool isBigScreen;
  final bool transactionMode;
  final String transactionType;

  @override
  Widget build(BuildContext context) {
    Widget plusOrSubmit;
    if (transactionMode == false) {
      plusOrSubmit = Expanded(
        child: InkWell(
          splashColor: Color(0xFFDFF0FF),
          onTap: () {
            HapticFeedback.lightImpact();
            model.keyboardKeyPressed(key: '+');
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
          onTap: () {
            log("Key: " + model.key);
            HapticFeedback.lightImpact();
            if ((model.kTransaction != null) &&
                ((model.key != '0') &&
                    (model.key != '0.0') &&
                    (model.key != '0.00'))) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Save $transactionType transaction'),
                    content:
                        Text('Are you sure you want to save this transaction?'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('Confirm'),
                        onPressed: () {
                          // Perform confirm action here
                          HandleTransactionFromCashBook();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Alert'),
                    content: Text('Please enter an amount.'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Close'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
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
    final screenHeight = isBigScreen ? 200 : 600;
    final paddingHeight = screenHeight * 0.1; // 10% of screen height
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min, // set main axis size to min
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: transactionMode ? paddingHeight / 3 : paddingHeight),
            child: transactionMode
                ? SizedBox(
                    height: 80,
                    child: Column(
                      children: [
                        Text(
                          NumberFormat('#,###')
                                  .format(double.parse(model.keypad.key)) +
                              " RWF",
                          style: GoogleFonts.poppins(
                            fontSize: 35,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff000000),
                            height: transactionMode ? 1 : 1.5,
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 10),
                            transactionType == 'Cash In'
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
                                categories: model.categories),
                          ],
                        )
                      ],
                    ),
                  )
                : Text(
                    NumberFormat('#,###')
                            .format(double.parse(model.keypad.key)) +
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
                    onTap: () {
                      HapticFeedback.lightImpact();
                      model.keyboardKeyPressed(key: '1');
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
                    onTap: () {
                      HapticFeedback.lightImpact();
                      model.keyboardKeyPressed(key: '2');
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
                    onTap: () {
                      HapticFeedback.lightImpact();
                      model.keyboardKeyPressed(key: '3');
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
                    onTap: () {
                      HapticFeedback.lightImpact();
                      model.keyboardKeyPressed(key: '4');
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
                    onTap: () {
                      HapticFeedback.lightImpact();
                      model.keyboardKeyPressed(key: '5');
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
                    onTap: () {
                      HapticFeedback.lightImpact();
                      model.keyboardKeyPressed(key: '6');
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
                    onTap: () {
                      HapticFeedback.lightImpact();
                      model.keyboardKeyPressed(key: '7');
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
                    onTap: () {
                      HapticFeedback.lightImpact();
                      model.keyboardKeyPressed(key: '8');
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
                    onTap: () {
                      HapticFeedback.lightImpact();
                      model.keyboardKeyPressed(key: '9');
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
                    onTap: () {
                      HapticFeedback.lightImpact();
                      model.keyboardKeyPressed(key: 'C');
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
                    onTap: () {
                      HapticFeedback.lightImpact();
                      model.keyboardKeyPressed(key: '0');
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
    model.newTransactionPressed = false;

    model.keyboardKeyPressed(key: '+');
    model.saveCashBookTransaction(cbTransactionType: transactionType);
  }
}

class KeyboardKey extends StatelessWidget {
  const KeyboardKey({
    Key? key,
    required this.model,
    required this.value,
  }) : super(key: key);
  final String value;
  final HomeViewModel model;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: MediaQuery.of(context).size.height * 0.2, // 20% of screen height
      child: InkWell(
        onTap: () => {model.keyboardKeyPressed(key: value)},
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromRGBO(0, 0, 0, 0.2),
              width: 0,
            ),
          ),
          child: Center(
            child: Text(
              value,
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
