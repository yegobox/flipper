import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/box_models.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:number_display/number_display.dart';

Widget callCharge({required double payable, required BuildContext context}) {
  final display = createDisplay(
    length: 8,
    decimal: 4,
  );
  if (payable == 0.0) {
    return Text(
      FLocalization.of(context).charge + ' FRW ' + payable.toString(),
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    );
  } else {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          FLocalization.of(context).charge,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              'FRw' + display(payable).toString(),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class ChargeButton extends StatelessWidget {
  const ChargeButton({Key? key, required this.duePay, required this.model})
      : super(key: key);
  final double? duePay;
  final BusinessHomeViewModel model;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(19.0, 0, 19.0, 0),
      child: SizedBox(
        height: 64,
        width: double.infinity,
        child: OutlinedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(const Color(0xff006AFE)),
              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.hovered)) {
                    return Colors.blue.withOpacity(0.04);
                  }
                  if (states.contains(MaterialState.focused) ||
                      states.contains(MaterialState.pressed)) {
                    return Colors.blue.withOpacity(0.12);
                  }
                  return null; // Defer to the widget's default.
                },
              ),
            ),
            onPressed: () {
              GoRouter.of(context).push(Routes.pay, extra: model.kOrder);
            },
            child: callCharge(
              payable: duePay ?? 0.00,
              context: context,
            )),
      ),
    );
  }
}
