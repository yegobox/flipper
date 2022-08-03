import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/box_models.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:number_display/number_display.dart';

class ChargeButton extends StatelessWidget {
  ChargeButton({Key? key, required this.duePay, required this.model})
      : super(key: key);
  final double? duePay;
  final BusinessHomeViewModel model;
  final display = createDisplay(
    length: 8,
    decimal: 4,
  );
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
                  return null;
                },
              ),
            ),
            onPressed: () {
              GoRouter.of(context).push(Routes.pay, extra: model.kOrder);
            },
            child: Text(
              FLocalization.of(context).charge +
                  ' FRw ' +
                  display(duePay ?? 0.00).toString(),
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 19,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            )),
      ),
    );
  }
}
