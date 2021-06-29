// import 'package:flipper_models/view_models/pos_viewmodel.dart';
import 'package:flipper/localization.dart';
import 'package:flutter/material.dart';
import 'package:number_display/number_display.dart';

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}

class PayableView extends StatelessWidget {
  PayableView(
      {Key? key,
      this.tickets = 0,
      this.duePay = 0,
      this.orders = 0,
      required this.onClick,
      required this.ticketHandler})
      : super(key: key);
  final double tickets;
  final int orders;
  final double duePay;
  final Function onClick;
  final Function ticketHandler;

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
                ticketHandler();
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
                child: ticketText(
                    tickets: tickets.toInt(), orders: orders, context: context),
              ),
            ),
          ),
          Container(
            width: 0.5,
            height: 60,
            color: Colors.black54,
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                onClick();
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
                child: GestureDetector(
                    onTap: () {
                      onClick();
                    },
                    child: callCharge(payable: duePay, context: context)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget ticketText(
      {required int tickets,
      required int orders,
      required BuildContext context}) {
    if (tickets > 0 || orders == 0) {
      return Text(
        Localization.of(context)!.tickets,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      );
    } else if (orders > 0) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Container(
                child: Text(
                  Localization.of(context)!.save,
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
                  orders.toString() + ' New Item' + (tickets > 1 ? 's' : ''),
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
    } else {
      return SizedBox.shrink();
    }
  }

  Widget callCharge({required double payable, required BuildContext context}) {
    final display = createDisplay(
      length: 8,
      decimal: 4,
    );
    if (payable == 0.0) {
      return Text(
        Localization.of(context)!.charge + ' FRw' + display(payable).toString(),
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
                Localization.of(context)!.charge,
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
                  'FRw' + display(payable).toString(),
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
        ],
      );
    }
  }
}
