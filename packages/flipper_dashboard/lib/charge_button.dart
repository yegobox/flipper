import 'dart:developer';

import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/box_models.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/services.dart';
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
      padding: const EdgeInsets.fromLTRB(19.0, 30, 19.0, 0),
      child: SizedBox(
        height: 60,
        width: double.infinity,
        child: TextButton(
          style: primaryButtonStyle.copyWith(
              shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                  (states) => RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)))),
          onPressed: () {
            model.kTransaction!.subTotal = duePay!;
            _routerService
                .navigateTo(PaymentsRoute(transaction: model.kTransaction!));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Spacer(),
              Text(
                FLocalization.of(context).charge +
                    ' ' +
                    NumberFormat('#,###').format(duePay ?? 0.00) +
                    ' FRw ',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 19,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              Spacer(),
              Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
