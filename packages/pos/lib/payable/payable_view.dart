import 'package:flutter/material.dart';
import 'package:pos/payable/button.dart';
import 'package:pos/pos_viewmodel.dart';

class PayableView extends StatelessWidget {
  const PayableView({Key key, this.model}) : super(key: key);
  final PosViewModel model;

  @override
  Widget build(BuildContext context) {
    return
        //Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        //  children: <Widget>[
        Container(
      width: MediaQuery.of(context).size.width - 22,
      margin: EdgeInsetsDirectional.only(top: 15),
      //height: 60,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.center,
              height: 60,
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context)
                  .copyWith(canvasColor: HexColor('#2996CC'))
                  .canvasColor,
              child: callText(model),
            ),
          ),
          Container(
            // padding: EdgeInsets.only(right: 3),
            width: 0.5,
            height: 60,
            color: Colors.black54,
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              height: 60,
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context)
                  .copyWith(canvasColor: HexColor('#2996CC'))
                  .canvasColor,
              child: callCharge(model),
            ),
          ),
        ],
      ),
      // ),
      // ],
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
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                child: Container(
                    child: Text(
              'Save',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ))),
            Container(
                child: Container(
                    child: Text(
              '1 New Item',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            )))
          ]);
    }
  }

  callCharge(PosViewModel model) {
    if (model.expression == "0.0" || model.expression == "") {
      return Text(
        'Charge FRw' + model.expression,
        style: const TextStyle(
          fontSize: 20.0,
          color: Colors.white,
        ),
      );
    } else {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                child: Container(
                    child: Text(
              'Charge',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ))),
            Container(
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                    child: Text(
              'FRw' + model.expression,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            )))
          ]);
    }
  }
}
