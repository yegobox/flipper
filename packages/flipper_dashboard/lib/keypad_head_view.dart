import 'dart:ui';

import 'package:flutter/material.dart';

import 'keypad_view.dart';

class KeyPadHead extends StatelessWidget {
  KeyPadHead({
    Key? key,
    this.amount = 0.0,
    this.note,
    required this.onClick,
    required this.controller,
    this.payable,
  }) : super(key: key);
  final double amount;
  final String? note;
  final Function onClick;
  final TextEditingController controller;
  final Widget? payable;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 5.0, right: 5.0),
          child: payable ?? SizedBox.shrink(),
        ),
        InkWell(
          onTap: () {
            onClick();
          },
          child: IgnorePointer(
            child: Container(
              padding: const EdgeInsets.only(
                right: 20.0,
                top: 15.0,
                left: 20.0,
                bottom: 15.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                      child: Container(
                    alignment: Alignment.center,
                    child: Container(
                      padding: const EdgeInsets.only(right: 10),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        cursorColor: Colors.black26,
                        //will disable paste operation
                        enableInteractiveSelection: false,
                        focusNode: AlwaysDisabledFocusNode(),
                        controller: controller,
                        // onChanged: (value) => addNote = value,
                        style: const TextStyle(
                          color: Color(0xff3d454c),
                          fontSize: 15,
                        ),
                        decoration: InputDecoration(
                          hintText: note ?? 'Add a note',
                          border: InputBorder.none,
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                            fontSize: 15,
                            fontFeatures: [
                              FontFeature.enable('sups'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )),
                  Expanded(
                    child: Text(
                      'FRw' + amount.toString(),
                      textAlign: TextAlign.right,
                      softWrap: true,
                      style: const TextStyle(
                        fontSize: 25.0,
                        color: Color(0xffc2c7cc),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
