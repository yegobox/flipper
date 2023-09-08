import 'package:flipper_dashboard/keypad_view.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CashBookCashOutPressed extends StatelessWidget {
  const CashBookCashOutPressed(
      {super.key, required this.model, required this.isBigScreen});
  final HomeViewModel model;
  final bool isBigScreen;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 10),
            Icon(FluentIcons.tray_item_add_24_regular),
            if (model.newTransactionType == 'Cash In')
              Text(' Cash In',
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.bold))
            else if (model.newTransactionType == 'Cash Out')
              Text(' Cash Out',
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            Spacer(),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                model.newTransactionPressed = false;
                model.notifyListeners();
              },
            )
          ],
        ),
        KeyPadView.cashBookMode(
          model: model,
          isBigScreen: isBigScreen,
          transactionMode: true,
          transactionType: model.newTransactionType,
        )
      ],
    );
  }
}
