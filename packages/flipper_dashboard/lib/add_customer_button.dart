import 'package:flipper_dashboard/customers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddCustomerButton extends StatelessWidget {
  AddCustomerButton({Key? key, required this.transactionId}) : super(key: key);

  final String? transactionId;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
      child: SizedBox(
        height: 60,
        width: double.infinity,
        child: TextButton(
            style: ButtonStyle(
              shape: WidgetStateProperty.resolveWith<OutlinedBorder>(
                (states) => RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
              backgroundColor:
                  WidgetStateProperty.all<Color>(const Color(0xffF2F2F2)),
              overlayColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.hovered)) {
                    return const Color(0xffF2F2F2);
                  }
                  if (states.contains(WidgetState.focused) ||
                      states.contains(WidgetState.pressed)) {
                    return const Color(0xffF2F2F2);
                  }
                  return null;
                },
              ),
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(10.0)),
                ),
                useRootNavigator: true,
                builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Customers(),
                  );
                },
              );
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
