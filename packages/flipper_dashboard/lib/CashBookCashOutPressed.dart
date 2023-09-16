import 'package:flipper_dashboard/keypad_view.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/constants.dart';
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
            if (model.newTransactionType == TransactionType.cashIn)
              Text(' Cash In',
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.bold))
            else if (model.newTransactionType == TransactionType.cashOut)
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
