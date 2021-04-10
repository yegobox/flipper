library pos;

import 'dart:ui';

import 'package:flipper_models/view_models/pos_viewmodel.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:pos/payable/payable_view.dart';
import 'package:stacked/stacked.dart';

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class KeyPad extends StatelessWidget {
  const KeyPad({Key key}) : super(key: key);
  // final PosViewModel model;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => PosViewModel(),
        builder: (BuildContext context, PosViewModel model, Widget child) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Display(
                    model: model,
                  ),
                  Expanded(child: Keyboard(model: model))
                ],
              ),
            ),
          );
        });
  }
}

class Display extends StatefulWidget {
  const Display({Key key, this.model}) : super(key: key);
  final PosViewModel model;

  @override
  _onCreate createState() => _onCreate(model);
}

// ignore: camel_case_types
class _onCreate extends State<Display> {
  _onCreate(this.model);

  PosViewModel model;
  TextEditingController etAddNote;
  String addNote;

  @override
  Widget build(BuildContext context) {
    etAddNote = TextEditingController(text: addNote);
    return Column(children: <Widget>[
      const Padding(
        padding: EdgeInsets.only(left: 5.0, right: 5.0),
        child: PayableView(),
      ),
      InkWell(
        onTap: () {
          ProxyService.inAppNav.navigateToPath({'path': 'add_note'});
        },
        child: IgnorePointer(
          child: Container(
            padding: const EdgeInsets.only(
                right: 20.0, top: 15.0, left: 20.0, bottom: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                    child: Container(
                  alignment: Alignment.center,
                  child: _addNoteTextField(model: model),
                )),
                Expanded(
                  child: callText(model),
                ),
              ],
            ),
          ),
        ),
      ),
    ]);
  }

  Widget _addNoteTextField({PosViewModel model}) {
    return Container(
      padding: const EdgeInsets.only(right: 10),
      child: TextField(
        keyboardType: TextInputType.text,
        cursorColor: Colors.black26,
        enableInteractiveSelection: false, // will disable paste operation
        focusNode: AlwaysDisabledFocusNode(),
        controller: etAddNote,
        onChanged: (value) => addNote = value,
        style: const TextStyle(
          color: Color(0xff3d454c),
          fontSize: 15,
        ),
        decoration: InputDecoration(
          hintText: model.keyPad.note.value ?? 'Add a note',
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
    );
  }

  Text callText(PosViewModel model) {
    if (model.keypadValue == '0.0') {
      return const Text(
        'FRw0.0',
        textAlign: TextAlign.right,
        softWrap: true,
        style: TextStyle(
          fontSize: 25.0,
          color: Color(0xffc2c7cc),
        ),
      );
    } else {
      return Text(
        'FRw' + model.keypadValue,
        textAlign: TextAlign.right,
        softWrap: true,
        style: const TextStyle(
          fontSize: 25.0,
          color: Color(0xffc2c7cc),
        ),
      );
    }
  }
}

// ignore: must_be_immutable
class Keyboard extends StatelessWidget {
  Keyboard({Key key, this.model}) : super(key: key);
  final PosViewModel model;
  var myDynamicAspectRatio = 1000 / 1;
  OverlayEntry sticky;
  List<PosViewModel> myGridList = [];
  double maxHeight = 0;
  double maxWidth = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    child: InkWell(
                      onTap: () {
                        model.addKey('1');
                      },
                      child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xffc1c6cb),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '1',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    fontSize: 30,
                                    color: const Color(0xff3d454c),
                                    fontWeight: FontWeight.normal),
                          )),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: InkWell(
                      onTap: () {
                        model.addKey('2');
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Color(0xffc1c6cb)),
                            right: BorderSide(color: Color(0xffc1c6cb)),
                            bottom: BorderSide(color: Color(0xffc1c6cb)),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '2',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: 30,
                              color: const Color(0xff3d454c),
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: InkWell(
                      onTap: () {
                        model.addKey('3');
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Color(0xffc1c6cb)),
                            right: BorderSide(color: Color(0xffc1c6cb)),
                            bottom: BorderSide(color: Color(0xffc1c6cb)),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '3',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: 30,
                              color: const Color(0xff3d454c),
                              fontWeight: FontWeight.normal),
                        ),
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
                  child: Container(
                    child: InkWell(
                      onTap: () {
                        model.addKey('4');
                      },
                      child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(color: Color(0xffc1c6cb)),
                              right: BorderSide(color: Color(0xffc1c6cb)),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '4',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    fontSize: 30,
                                    color: const Color(0xff3d454c),
                                    fontWeight: FontWeight.normal),
                          )),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: InkWell(
                      onTap: () {
                        model.addKey('5');
                      },
                      child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(color: Color(0xffc1c6cb)),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '5',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    fontSize: 30,
                                    color: const Color(0xff3d454c),
                                    fontWeight: FontWeight.normal),
                          )),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: InkWell(
                      onTap: () {
                        model.addKey('6');
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          border: Border(
                            right: BorderSide(color: Color(0xffc1c6cb)),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '6',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: 30,
                              color: const Color(0xff3d454c),
                              fontWeight: FontWeight.normal),
                        ),
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
                  child: Container(
                    child: InkWell(
                      onTap: () {
                        model.addKey('7');
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Color(0xffc1c6cb)),
                            left: BorderSide(color: Color(0xffc1c6cb)),
                            right: BorderSide(color: Color(0xffc1c6cb)),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '7',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: 30,
                              color: const Color(0xff3d454c),
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: InkWell(
                      onTap: () {
                        model.addKey('8');
                      },
                      child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Color(0xffc1c6cb)),
                              right: BorderSide(color: Color(0xffc1c6cb)),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '8',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    fontSize: 30,
                                    color: const Color(0xff3d454c),
                                    fontWeight: FontWeight.normal),
                          )),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: InkWell(
                      onTap: () {
                        model.addKey('9');
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Color(0xffc1c6cb)),
                            right: BorderSide(color: Color(0xffc1c6cb)),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '9',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: 30,
                              color: const Color(0xff3d454c),
                              fontWeight: FontWeight.normal),
                        ),
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
                  child: Container(
                    child: InkWell(
                      onTap: () {
                        model.addKey('C');
                      },
                      child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Color(0xffc1c6cb)),
                              left: BorderSide(color: Color(0xffc1c6cb)),
                              right: BorderSide(color: Color(0xffc1c6cb)),
                              bottom: BorderSide(color: Color(0xffc1c6cb)),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'C',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    fontSize: 30,
                                    color: const Color(0xff3d454c),
                                    fontWeight: FontWeight.normal),
                          )),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: InkWell(
                      onTap: () {
                        model.addKey('0');
                      },
                      child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Color(0xffc1c6cb)),
                              right: BorderSide(color: Color(0xffc1c6cb)),
                              bottom: BorderSide(color: Color(0xffc1c6cb)),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '0',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    fontSize: 30,
                                    color: const Color(0xff3d454c),
                                    fontWeight: FontWeight.normal),
                          )),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: InkWell(
                      onTap: () {
                        model.addKey('+');
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Color(0xffc1c6cb)),
                            right: BorderSide(color: Color(0xffc1c6cb)),
                            bottom: BorderSide(color: Color(0xffc1c6cb)),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '+',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: 40,
                              color: const Color(0xff2996cc),
                              fontWeight: FontWeight.normal),
                        ),
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
  const KeyboardKey(this._keyValue, this.model);

  final PosViewModel model;
  final _keyValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        width: 100,
        height: MediaQuery.of(context).size.height,
        child: InkWell(
          onTap: () => {model.addKey(_keyValue)},
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromRGBO(0, 0, 0, 0.2),
                width: 0.0,
              ),
            ),
            child: Center(
              child: Text(
                _keyValue,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontSize: 30, fontWeight: FontWeight.normal),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
