import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/box_models.dart';
import 'package:flipper_routing/app.router.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:intl/intl.dart';

class ChargeButton extends StatelessWidget {
  ChargeButton({Key? key, required this.duePay, required this.model})
      : super(key: key);
  final double? duePay;
  final HomeViewModel model;
  final _routerService = locator<RouterService>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(19.0, 0, 19.0, 0),
      child: SizedBox(
        height: 64,
        width: double.infinity,
        child: TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                (states) => RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              backgroundColor:
                  MaterialStateProperty.all<Color>(const Color(0xffF2F2F2)),
              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.hovered)) {
                    return const Color(0xffF2F2F2);
                  }
                  if (states.contains(MaterialState.focused) ||
                      states.contains(MaterialState.pressed)) {
                    return const Color(0xffF2F2F2);
                  }
                  return null;
                },
              ),
            ),
            onPressed: () {
              _routerService.navigateTo(PaymentsRoute(transaction: model.kTransaction!));
            },
            child: Text(
              FLocalization.of(context).charge +
                  ' ' +
                  NumberFormat('#,###').format(duePay ?? 0.00) +
                  ' FRw ',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 19,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            )),
      ),
    );
  }
}
