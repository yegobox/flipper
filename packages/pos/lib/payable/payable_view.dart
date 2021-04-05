
import 'package:flutter/material.dart';
import 'package:pos/payable/button.dart';
import 'package:flipper_models/view_models/pos_viewmodel.dart';
import 'package:number_display/number_display.dart';

class PayableView extends StatelessWidget {
  const PayableView({Key key, this.model}) : super(key: key);
  final PosViewModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 22,
      margin: const EdgeInsetsDirectional.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () {
                if (model.keyPad.payable == 0.0) {
                  model.viewTickets();
                } else {
                  model.saveTicket();
                }
              },
              child: Container(
                alignment: Alignment.center,
                height: 60,
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context)
                    .copyWith(
                      canvasColor: HexColor('#2996CC'),
                    )
                    .canvasColor,
                child: ticketText(model),
              ),
            ),
          ),
          Container(
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
                  .copyWith(
                    canvasColor: HexColor('#2996CC'),
                  )
                  .canvasColor,
              child: GestureDetector(
                  onTap: () {
                    model.goSale();
                  },
                  child: callCharge(model)),
            ),
          ),
        ],
      ),
    );
  }

  Widget ticketText(PosViewModel model) {
    if (model.currentSale.isEmpty) {
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
                child: const Text(
                  'Save',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Container(
              child: Container(
                child: Text(
                  model.currentSale.length.toString() +
                      ' New Item' +
                      (model.currentSale.length > 1 ? 's' : ''),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ]);
    }
  }

  Widget callCharge(PosViewModel model) {
    final display = createDisplay(
      length: 8,
      decimal: 2,
    );
    if (model.keyPad.payable == 0.0) {
      return Text(
        'Charge FRw' + display(model.keyPad.payable).toString(),
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
                child: const Text(
                  'Charge',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Flexible(
              child: Container(
                child: Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    'FRw' + display(model.keyPad.payable).toString(),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ]);
    }
  }
}
