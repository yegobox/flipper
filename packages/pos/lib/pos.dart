library pos;

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pos/payable/payable_view.dart';
import 'pos_viewmodel.dart';

class KeyPad extends StatelessWidget {
  KeyPad({Key key, this.model}) : super(key: key);
  final PosViewModel model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).copyWith(canvasColor: Colors.white).canvasColor,
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
  }
}

class Display extends StatefulWidget {
  Display({Key key, this.model}) : super(key: key);
  final PosViewModel model;

  @override
  _onCreate createState() => _onCreate(model);
}

class _onCreate extends State<Display> {
  PosViewModel model;
  TextEditingController etAddNote;
  String addNote;
  _onCreate(this.model);

  @override
  Widget build(BuildContext context) {
    etAddNote = TextEditingController(text: addNote);
    print("dddddddddddddd" + model.expression);
    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
        child: PayableView(model: model),
      ),
      Container(
        // height: 80,
        padding: const EdgeInsets.only(
            right: 20.0, top: 15.0, left: 20.0, bottom: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
                child: Container(
              alignment: Alignment.center,
              child: InkWell(onTap: () {}, child: _addNoteTextField()),
              // child: const Text(
              //   'Add a note',
              //   textAlign: TextAlign.left,
              //   style: const TextStyle(
              //     fontFeatures: [
              //       FontFeature.enable('sups'),
              //     ],
              //     fontSize: 15.0,
              //     color: Colors.black26,
              //   ),
              // ),
            )),
            Expanded(
              child: callText(model),
              // child:TextField(
              //   controller: etAmount,
              //   onChanged: (value) => userAmt = value,
              //   decoration: new InputDecoration(
              //       border: InputBorder.none,
              //       focusedBorder: InputBorder.none,
              //       contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
              //       hintText:'FRw0.00'
              //   ),
              //   style: const TextStyle(
              //     fontFeatures: [
              //       FontFeature.enable('sups'),
              //     ],
              //     fontSize: 28.0,
              //     color: const Color(0xffc2c7cc),
              //   ),
              // ),
            ),
          ],
        ),
      ),
    ]);

    // return Container(
    //   // width: double.infinity,
    //   color: Theme.of(context)
    //       .copyWith(canvasColor: Colors.white)
    //       .canvasColor, //this can be set to a visible color, when designing
    //   padding: const EdgeInsets.all(0.0),
    //   child: Column(
    //     children: views,
    //   ),
    //);
  }

  // Widget _addNoteTextField() {
  //   return TextField(
  //     keyboardType: TextInputType.text,
  //     cursorColor: const Color(0xffc2c7cc),
  //     controller: etAddNote,
  //
  //     autofocus: true,
  //     // onChanged: (value) => phoneNumber = value,
  //     style: TextStyle(
  //       color: const Color(0xffc2c7cc),
  //       fontSize: 16.0,
  //       fontFeatures: [
  //         FontFeature.enable('sups'),
  //       ],
  //     ),
  //     // decoration: const InputDecoration(
  //     //   labelStyle: TextStyle(
  //     //     color: const Color(0xffc2c7cc),
  //     //     fontFeatures: [
  //     //       FontFeature.enable('sups'),
  //     //     ],
  //     //   ),
  //     //   focusColor: const Color(0xffc2c7cc),
  //     //   filled: true,
  //     //   labelText: "Add a note",
  //     //),
  //   );
  // }

  Widget _addNoteTextField() {
    return Container(
      padding: EdgeInsets.only(right: 10),
      child: TextField(
        keyboardType: TextInputType.text,
        cursorColor: Colors.black26,
        controller: etAddNote,
        onChanged: (value) => addNote = value,
        style: const TextStyle(
          color: const Color(0xff3d454c),
          fontSize: 15,
          // fontFeatures: [
          //   FontFeature.enable('sups'),
          // ],
        ),
        decoration: const InputDecoration(
          hintText: "Add a note",
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
      // maxLines: 2,
    );
  }

  callText(PosViewModel model) {
    if (model.expression == "0.0" || model.expression == "") {
      return Text(
        'FRw0.0',
        textAlign: TextAlign.right,
        //  maxLines: 2,
        softWrap: true,
        style: const TextStyle(
          fontFeatures: [
            FontFeature.enable('sups'),
          ],
          fontSize: 25.0,
          color: const Color(0xffc2c7cc),
        ),
      );
    } else {
      return Text(
        'FRw' + model.expression,
        textAlign: TextAlign.right,
        //  maxLines: 2,
        softWrap: true,
        style: const TextStyle(
          fontFeatures: [
            FontFeature.enable('sups'),
          ],
          fontSize: 25.0,
          color: const Color(0xff3d454c),
        ),
      );
    }
  }
}

class Keyboard extends StatelessWidget {
  Keyboard({Key key, this.model}) : super(key: key);
  final PosViewModel model;
  var myDynamicAspectRatio = 1000 / 1;
  OverlayEntry sticky;
  List<PosViewModel> myGridList = new List();
  double maxHeight = 0;
  double maxWidth = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(top: 30),
      child: Column(
        // mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    child: InkWell(
                      onTap: () {
                        model.addKey("1");
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

                          // height: MediaQuery.of(context).size.height,
                          child: Text(
                            "1",
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
                        model.addKey("2");
                      },
                      child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: const Color(0xffc1c6cb)),
                              //left: BorderSide(width: 1.0, color: Color(0xFFFFDFDFDF)),
                              right: BorderSide(color: const Color(0xffc1c6cb)),
                              bottom:
                                  BorderSide(color: const Color(0xffc1c6cb)),
                              //bottom: BorderSide(width: 1.0, color: Color(0xFFFF7F7F7F)),
                            ),
                          ),
                          alignment: Alignment.center,

                          // height: MediaQuery.of(context).size.height,
                          child: Text(
                            "2",
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
                        model.addKey("3");
                      },
                      child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: const Color(0xffc1c6cb)),
                              right: BorderSide(color: const Color(0xffc1c6cb)),
                              bottom:
                                  BorderSide(color: const Color(0xffc1c6cb)),
                              // left: BorderSide(color: const Color(0xffc1c6cb)),
                              //bottom: BorderSide(width: 1.0, color: Color(0xFFFF7F7F7F)),
                            ),
                          ),
                          alignment: Alignment.center,

                          // height: MediaQuery.of(context).size.height,
                          child: Text(
                            "3",
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
                        model.addKey("4");
                      },
                      child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            border: Border(
                              // top: BorderSide(color: const Color(0xffc1c6cb)),
                              left: BorderSide(color: const Color(0xffc1c6cb)),
                              right: BorderSide(color: const Color(0xffc1c6cb)),
                              // bottom: BorderSide(color: const Color(0xffc1c6cb)),
                            ),
                          ),
                          alignment: Alignment.center,

                          // height: MediaQuery.of(context).size.height,
                          child: Text(
                            "4",
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
                        model.addKey("5");
                      },
                      child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            border: Border(
                              // top: BorderSide(color: const Color(0xffc1c6cb)),
                              //left: BorderSide(width: 1.0, color: Color(0xFFFFDFDFDF)),
                              right: BorderSide(color: const Color(0xffc1c6cb)),
                              //  bottom: BorderSide(color: const Color(0xffc1c6cb)),
                            ),
                          ),
                          alignment: Alignment.center,

                          // height: MediaQuery.of(context).size.height,
                          child: Text(
                            "5",
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
                        model.addKey("6");
                      },
                      child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            border: Border(
                              //  top: BorderSide(color: const Color(0xffc1c6cb)),
                              // left: BorderSide(color: const Color(0xffc1c6cb)),
                              //left: BorderSide(width: 1.0, color: Color(0xFFFFDFDFDF)),
                              right: BorderSide(color: const Color(0xffc1c6cb)),
                              //  bottom: BorderSide(color: const Color(0xffc1c6cb)),
                            ),
                          ),
                          alignment: Alignment.center,

                          // height: MediaQuery.of(context).size.height,
                          child: Text(
                            "6",
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
                        model.addKey("7");
                      },
                      child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: const Color(0xffc1c6cb)),
                              left: BorderSide(color: const Color(0xffc1c6cb)),
                              //left: BorderSide(width: 1.0, color: Color(0xFFFFDFDFDF)),
                              right: BorderSide(color: const Color(0xffc1c6cb)),
                              //  bottom: BorderSide(color: const Color(0xffc1c6cb)),
                            ),
                          ),
                          alignment: Alignment.center,

                          // height: MediaQuery.of(context).size.height,
                          child: Text(
                            "7",
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
                        model.addKey("8");
                      },
                      child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: const Color(0xffc1c6cb)),
                              // left: BorderSide(color: const Color(0xffc1c6cb)),
                              //left: BorderSide(width: 1.0, color: Color(0xFFFFDFDFDF)),
                              right: BorderSide(color: const Color(0xffc1c6cb)),
                              //  bottom: BorderSide(color: const Color(0xffc1c6cb)),
                            ),
                          ),
                          alignment: Alignment.center,

                          // height: MediaQuery.of(context).size.height,
                          child: Text(
                            "8",
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
                        model.addKey("9");
                      },
                      child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: const Color(0xffc1c6cb)),
                              // left: BorderSide(color: const Color(0xffc1c6cb)),
                              //left: BorderSide(width: 1.0, color: Color(0xFFFFDFDFDF)),
                              right: BorderSide(color: const Color(0xffc1c6cb)),
                              //  bottom: BorderSide(color: const Color(0xffc1c6cb)),
                            ),
                          ),
                          alignment: Alignment.center,

                          // height: MediaQuery.of(context).size.height,
                          child: Text(
                            "9",
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
                        model.addKey("C");
                      },
                      child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: const Color(0xffc1c6cb)),
                              left: BorderSide(color: const Color(0xffc1c6cb)),
                              //left: BorderSide(width: 1.0, color: Color(0xFFFFDFDFDF)),
                              right: BorderSide(color: const Color(0xffc1c6cb)),
                              bottom:
                                  BorderSide(color: const Color(0xffc1c6cb)),
                            ),
                          ),
                          alignment: Alignment.center,

                          // height: MediaQuery.of(context).size.height,
                          child: Text(
                            "C",
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
                        model.addKey("0");
                      },
                      child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: const Color(0xffc1c6cb)),
                              //left: BorderSide(color: const Color(0xffc1c6cb)),
                              //left: BorderSide(width: 1.0, color: Color(0xFFFFDFDFDF)),
                              right: BorderSide(color: const Color(0xffc1c6cb)),
                              bottom:
                                  BorderSide(color: const Color(0xffc1c6cb)),
                            ),
                          ),
                          alignment: Alignment.center,

                          // height: MediaQuery.of(context).size.height,
                          child: Text(
                            "0",
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
                        model.addKey("+");
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: const Color(0xffc1c6cb)),
                            //left: BorderSide(color: const Color(0xffc1c6cb)),
                            //left: BorderSide(width: 1.0, color: Color(0xFFFFDFDFDF)),
                            right: BorderSide(color: const Color(0xffc1c6cb)),
                            bottom: BorderSide(color: const Color(0xffc1c6cb)),
                          ),
                        ),
                        alignment: Alignment.center,

                        // height: MediaQuery.of(context).size.height,
                        child: Text(
                          "+",
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

// class Keyboard extends StatelessWidget {
//   Keyboard({Key key, this.model}) : super(key: key);
//   final PosViewModel model;
//   var myDynamicAspectRatio = 1000 / 1;
//   OverlayEntry sticky;
//   List<PosViewModel> myGridList = new List();
//   double maxHeight = 0;
//   double maxWidth = 0;
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     maxHeight = MediaQuery.of(context).size.height;
//     maxWidth = MediaQuery.of(context).size.width;
//     var myDynamicAspectRatio =  maxWidth / maxHeight;
//     // if(sticky != null) {
//     //   sticky.remove();
//     // }
//     // sticky = OverlayEntry(
//     //   builder: (context) => stickyBuilder(context),
//     // );
//     return GridView.count(
//       crossAxisCount: 3,
//       //childAspectRatio: 1.0,
//       childAspectRatio: myDynamicAspectRatio,
//       shrinkWrap: true,
//       //padding: const EdgeInsets.all(2.0),
//       physics: NeverScrollableScrollPhysics(),
//       // crossAxisSpacing: 4.0,
//       // padding: const EdgeInsets.all(2.0),
//       // crossAxisSpacing: 1.0,
//       children: <String>[
//         // @formatter:off
//         '1', '2', '3',
//         '4', '5', '6',
//         '7', '8', '9',
//         'C', '0', '+',
//         // @formatter:on
//       ].map((key) {
//         return GridTile(
//           child: KeyboardKey(key, model),
//         );
//       }).toList(),
//     );
//
//     // return Expanded(
//     //     child: Column(children: <Widget>[
//     //   Container(
//     //     margin: EdgeInsets.all(10),
//     //     child: Table(
//     //       border: TableBorder.all(),
//     //       children: [
//     //         TableRow(children: [
//     //           Column(children: [  GestureDetector(
//     //               onTap: () => {model.addKey('1')},
//     //               child:Container(
//     //                   child: Text('1'))),]),
//     //           Column(children: [  GestureDetector(
//     //               onTap: () => {model.addKey('2')},
//     //               child:Container(
//     //                   child: Text('2'))),]),
//     //           Column(children: [  GestureDetector(
//     //               onTap: () => {model.addKey('3')},
//     //               child:Container(
//     //                   child: Text('3'))),]),
//     //         ]),
//     //         TableRow(children: [
//     //           Column(children: [  GestureDetector(
//     //               onTap: () => {model.addKey('4')},
//     //               child:Container(
//     //                   child: Text('4'))),]),
//     //           Column(children: [  GestureDetector(
//     //               onTap: () => {model.addKey('5')},
//     //               child:Container(
//     //                   child: Text('5'))),]),
//     //           Column(children: [  GestureDetector(
//     //               onTap: () => {model.addKey('6')},
//     //               child:Container(
//     //                   child: Text('6'))),]),
//     //         ]),
//     //         TableRow(children: [
//     //           Column(children: [  GestureDetector(
//     //               onTap: () => {model.addKey('7')},
//     //               child:Container(
//     //                   child: Text('7'))),]),
//     //           Column(children: [  GestureDetector(
//     //               onTap: () => {model.addKey('8')},
//     //               child:Container(
//     //                   child: Text('8'))),]),
//     //           Column(children: [  GestureDetector(
//     //               onTap: () => {model.addKey('9')},
//     //               child:Container(
//     //                   child: Text('9'))),]),
//     //         ]),
//     //         TableRow(children: [
//     //           Column(children: [
//     //             GestureDetector(
//     //                 onTap: () => {model.addKey('C')},
//     //                 child:Container(
//     //                     child: Text('C'))),
//     //           ]),
//     //           Column(children: [
//     //             GestureDetector(
//     //                 onTap: () => {model.addKey('0')},
//     //                 child:Container(
//     //                     child: Text('0'))),
//     //           ]),
//     //           Column(children: [
//     //             GestureDetector(
//     //                 onTap: () => {model.addKey('+')},
//     //                 child:Container(
//     //                 child: Text('+'))),
//     //           ]),
//     //         ]),
//     //       ],
//     //     ),
//     //   ),
//     // ]));
//   }
//
//   // shouldUpdateGridList() {
//   //   bool isChanged = false;
//   //   for (PosViewModel gi in myGridList) {
//   //     gi
//   //     if (gi.width != null) {
//   //       if (gi.height > maxHeight) {
//   //         maxHeight = gi.height;
//   //         maxWidth = gi.width;
//   //         isChanged = true;
//   //       }
//   //     }
//   //   }
//   //   if (isChanged) {
//   //     myDynamicAspectRatio = maxWidth / maxHeight;
//   //     print("AspectRatio" + myDynamicAspectRatio.toString());
//   //   }
//   // }
//   //
//   // Widget stickyBuilder(BuildContext context) {
//   //   for(PosViewModel gi in myGridList) {
//   //     if(gi.width == null) {
//   //       final keyContext = gi.itemKey.currentContext;
//   //       if (keyContext != null) {
//   //         final box = keyContext.findRenderObject() as RenderBox;
//   //         print(box.size.height);
//   //         print(box.size.width);
//   //         gi.width = box.size.width;
//   //         gi.height = box.size.height;
//   //       }
//   //     }
//   //   }
//   //   shouldUpdateGridList();
//   //   return Container();
//   // }
//   //
//
// }

class KeyboardKey extends StatelessWidget {
  const KeyboardKey(this._keyValue, this.model);

  final PosViewModel model;
  final _keyValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      // child: SingleChildScrollView(
      child: SizedBox(
        width: 100,
        height: MediaQuery.of(context).size.height,
        child: InkWell(
          //enableFeedback: false,
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
      //  ),
    );
  }
}
