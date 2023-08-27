import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move_to_background/move_to_background.dart';

Future<bool> onWillPop(
    {
    required BuildContext context,
    required String message}) async {
  final shouldPop = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm'),
        content: Text(message),
        actions: <Widget>[
          OutlinedButton(
            child: Text('No',
                style: GoogleFonts.poppins(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                )),
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
            onPressed: () => Navigator.of(context).pop(false),
          ),
          OutlinedButton(
            child: Text('Yes',
                style: GoogleFonts.poppins(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                )),
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
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      );
    },
  );

  if (shouldPop == true) {
    /// @Decision: maybe a user does not want to close the day yet instead he want
    /// to just send the app in background, hence why I have commented out
    /// the code to trigger the closing drawer, for that
    /// a user will have to be explicit
    await MoveToBackground.moveTaskToBack();
    // Drawers? drawer = await ProxyService.isar
    //     .getDrawer(cashierId: ProxyService.box.getBusinessId()!);
    // _routerService
    //     .replaceWith(DrawerScreenRoute(open: "close", drawer: drawer));
    return false;
  } else {
    return false;
  }
}
