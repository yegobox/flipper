import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked_services/stacked_services.dart';

class AddCustomerButton extends StatelessWidget {
  AddCustomerButton({Key? key, required this.transactionId}) : super(key: key);
  final _routerService = locator<RouterService>();

  final int transactionId;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(19.0, 30, 19.0, 0),
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
              _routerService.navigateTo(CustomersRoute(
                transactionId: transactionId,
              ));
            },
            child: Text("Add Customer",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Color(0xff006AFE)))),
      ),
    );
  }
}
