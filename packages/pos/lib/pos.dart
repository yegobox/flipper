library pos;

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pos/payable/payable_view.dart';
import 'pos_viewmodel.dart';

class KeyPad extends StatelessWidget {
  const KeyPad({Key key, this.model}) : super(key: key);
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
            Expanded(
                child: Keyboard(model: model))
          ],
        ),
      ),
    );
  }
}

class Display extends StatelessWidget {
  const Display({Key key, this.model}) : super(key: key);
  final PosViewModel model;

  @override
  Widget build(BuildContext context) {
    final views = <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
        child: PayableView(model: model),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 20.0,top: 25.0,left: 20.0,bottom: 25.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                'Add a note',
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontFeatures: [
                    FontFeature.enable('sups'),
                  ],
                  fontSize: 15.0,
                  color: Colors.black26,
                ),
              ),
            ),
            Expanded(
              child: Text(
                'FRW ' + model.expression,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontFeatures: [
                    FontFeature.enable('sups'),
                  ],
                  fontSize: 20.0,
                  color: Colors.black26,
                ),
              ),
            ),

          ],
        ),
      ),
    ];

    return Container(
      // width: double.infinity,
      color: Theme.of(context)
          .copyWith(canvasColor: Colors.white)
          .canvasColor, //this can be set to a visible color, when designing
      padding: const EdgeInsets.all(0.0),
      child: Column(
        children: views,
      ),
    );
  }
}

class Keyboard extends StatelessWidget {
  const Keyboard({Key key, this.model}) : super(key: key);
  final PosViewModel model;
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      //childAspectRatio: 1.0,

      childAspectRatio: 1.1,
      //padding: const EdgeInsets.all(2.0),

      //crossAxisSpacing: 4.0,
     // padding: const EdgeInsets.all(2.0),
     // crossAxisSpacing: 1.0,
      children: <String>[
        // @formatter:off
        '1', '2', '3',
        '4', '5', '6',
        '7', '8', '9',
        'C', '0', '+',
        // @formatter:on
      ].map((key) {
        return GridTile(
          child: KeyboardKey(key, model),
        );
      }).toList(),
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
      // child: SingleChildScrollView(
        child: SizedBox(
          width: 100,
          height: 80,
          child: InkWell(
            enableFeedback: false,
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
