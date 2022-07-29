import 'package:flipper_routing/routes.router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class AddCustomerButton extends StatelessWidget {
  const AddCustomerButton({Key? key, required this.orderId}) : super(key: key);
  final int orderId;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(19.0, 10, 19.0, 0),
      child: SizedBox(
        height: 64,
        width: double.infinity,
        child: OutlinedButton(
            style: ButtonStyle(
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
                  return null; // Defer to the widget's default.
                },
              ),
            ),
            onPressed: () {
              GoRouter.of(context)
                  .push(Routes.customers + '/' + orderId.toString());
            },
            child: Text("Add Customer",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.black))),
      ),
    );
  }
}
