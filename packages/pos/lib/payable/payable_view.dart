import 'package:flutter/material.dart';
import 'package:pos/payable/button.dart';
import 'package:pos/pos_viewmodel.dart';

class PayableView extends StatelessWidget {
  const PayableView({Key key, this.model}) : super(key: key);
  final PosViewModel model;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width - 22,
          margin: EdgeInsetsDirectional.only(top: 15),
          height: 60,
          color: Theme.of(context)
              .copyWith(canvasColor: HexColor('#2996CC'))
              .canvasColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Container(
                  child: callText(model),
                ),
              ),
              Expanded(
                child: FlatButton(
                  onPressed: () {
                    // model.nvaigate();
                  },
                  child: Container(
                    child: Text(
                      'Charge FRw' + model.expression,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              // Text(
              //   'FRW ' + model.expression,
              //   style: const TextStyle(
              //     fontSize: 20.0,
              //     color: Colors.white,
              //   ),
              // )
            ],
          ),
        ),
      ],
    );
  }

  callText(PosViewModel model) {
    if (model.expression == "0.0" || model.expression == "") {
      return const Text(
        'Tickets',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      );
    } else {
      return const Text(
        'Save',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      );
    }
  }
}
