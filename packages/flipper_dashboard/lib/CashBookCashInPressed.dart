import 'package:flutter/material.dart';
import 'package:flipper_dashboard/BuildGaugeOrList.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flipper_models/isar_models.dart';

class CashBookCashInPressed extends StatelessWidget {
  final CoreViewModel model;

  const CashBookCashInPressed({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(model.transactionPeriod,
            style: GoogleFonts.poppins(
                fontSize: 17,
                color: Colors.lightBlue,
                fontWeight: FontWeight.w600)),
        SizedBox(height: 5),
        Expanded(
          child: BuildGaugeOrList(
            context: context,
            model: model,
            widgetType: 'list',
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: SizedBox(
                height: 41,
                width: 150,
                child: OutlinedButton(
                  onPressed: () {
                    model.newTransactionPressed = true;
                    model.newTransactionType = 'Cash In';
                    model.notifyListeners();
                  },
                  style: ButtonStyle(
                    side: MaterialStateProperty.all<BorderSide>(
                      const BorderSide(color: Colors.green),
                    ),
                    shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                      (states) => RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                    overlayColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        return Colors.green; // Defer to the widget's default.
                      },
                    ),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        Spacer(),
                        Text(
                          'Cash In',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: SizedBox(
                height: 41,
                width: 150,
                child: OutlinedButton(
                  onPressed: () {
                    model.newTransactionPressed = true;
                    model.newTransactionType = 'Cash Out';
                    model.notifyListeners();
                  },
                  style: ButtonStyle(
                    side: MaterialStateProperty.all<BorderSide>(
                      const BorderSide(color: Color(0xFFFF0331)),
                    ),
                    shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                      (states) => RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xFFFF0331)),
                    overlayColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        return Color(
                            0xFFFF0331); // Defer to the widget's default.
                      },
                    ),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.remove,
                          color: Colors.white,
                        ),
                        Spacer(),
                        Text(
                          'Cash Out',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ]),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
