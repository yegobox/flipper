library pos;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:universal_platform/universal_platform.dart';

import 'package:flipper_models/isar_models.dart';

final isWindows = UniversalPlatform.isWindows;
final isMacOs = UniversalPlatform.isMacOS;

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

// ignore: must_be_immutable
class KeyPadView extends StatelessWidget {
  const KeyPadView({Key? key, required this.model}) : super(key: key);
  final BusinessHomeViewModel model;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(111.0, 93.5, 101, 54.4),
            child: Text(
              "RWF${model.keypad.key}",
              style: GoogleFonts.poppins(
                  fontSize: 35,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff000000).withOpacity(0.25)),
            ),
          ),
          // InkWell(
          //   onTap: () {
          //     FlipperBottomSheet.showAddNoteToSaleBottomSheet(
          //       model: model,
          //       context: context,
          //     );
          //   },
          //   child: IgnorePointer(
          //     child: Container(
          //       padding: const EdgeInsets.only(
          //         right: 10,
          //         top: 10,
          //         left: 10,
          //         bottom: 15,
          //       ),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: <Widget>[
          //           Expanded(
          //             child: Container(
          //               alignment: Alignment.center,
          //               child: Container(
          //                 padding: const EdgeInsets.only(right: 10),
          //                 child: const TextButton(
          //                   onPressed: null,
          //                   child: Text(
          //                     'AddNote',
          //                     style: TextStyle(
          //                       fontWeight: FontWeight.w600,
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      model.addKey('1');
                    },
                    child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black.withOpacity(0.25),
                          ),
                        ),
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
                    onTap: () {
                      model.addKey('2');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black.withOpacity(0.25),
                        ),
                      ),
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
                    onTap: () {
                      model.addKey('3');
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black.withOpacity(0.25),
                        ),
                      ),
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
                    onTap: () {
                      model.addKey('4');
                    },
                    child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black.withOpacity(0.25),
                          ),
                        ),
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
                    onTap: () {
                      model.addKey('5');
                    },
                    child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black.withOpacity(0.25),
                          ),
                        ),
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
                    onTap: () {
                      model.addKey('6');
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black.withOpacity(0.25),
                        ),
                      ),
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
                    onTap: () {
                      model.addKey('7');
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black.withOpacity(0.25),
                        ),
                      ),
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
                    onTap: () {
                      model.addKey('8');
                    },
                    child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black.withOpacity(0.25),
                          ),
                        ),
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
                    onTap: () {
                      model.addKey('9');
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black.withOpacity(0.25),
                        ),
                      ),
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
                    onTap: () {
                      model.addKey('C');
                    },
                    child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black.withOpacity(0.25),
                          ),
                        ),
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
                    onTap: () {
                      model.addKey('0');
                    },
                    child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black.withOpacity(0.25),
                          ),
                        ),
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
                Expanded(
                  child: InkWell(
                    onTap: () {
                      model.addKey('+');
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black.withOpacity(0.25),
                        ),
                      ),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class KeyboardKey extends StatelessWidget {
  const KeyboardKey({
    Key? key,
    required this.model,
    required this.value,
  }) : super(key: key);
  final String value;
  final BusinessHomeViewModel model;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: MediaQuery.of(context).size.height,
      child: InkWell(
        onTap: () => {model.addKey(value)},
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
                  .bodyText1!
                  .copyWith(fontSize: 30, fontWeight: FontWeight.normal),
            ),
          ),
        ),
      ),
    );
  }
}
