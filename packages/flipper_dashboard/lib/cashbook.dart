import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'customappbar.dart';
import 'cashbook_transaction_list.dart';
import 'widgets/analytics_gauge/flipper_analytic.dart';
import 'package:flipper_dashboard/profile.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';

class Cashbook extends StatefulWidget {
  const Cashbook({super.key});

  @override
  State<Cashbook> createState() => _CashbookState();
}

class _CashbookState extends State<Cashbook> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        closeButton: CLOSEBUTTON.WIDGET,
        customLeadingWidget: Container(
            child: Text(
          '  Cash Book',
          style: GoogleFonts.poppins(
              fontSize: 17, color: Colors.grey, fontWeight: FontWeight.w600),
        )),
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              SizedBox(height: 80),
              SemiCircleGauge(
                dataOnGreenSide: 10000,
                dataOnRedSide: 5000,
                startPadding: 10,
              ),
              SizedBox(height: 20),
              Text('Today',
                  style: GoogleFonts.poppins(
                      fontSize: 17,
                      color: Colors.lightBlue,
                      fontWeight: FontWeight.w600)),
              SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: TransactionList(),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 75.0),
                    child: SizedBox(
                      height: 45,
                      width: 140,
                      child: OutlinedButton(
                        onPressed: null,
                        style: ButtonStyle(
                          side: MaterialStateProperty.all<BorderSide>(
                            const BorderSide(color: Colors.green),
                          ),
                          shape:
                              MaterialStateProperty.resolveWith<OutlinedBorder>(
                            (states) => RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0x008000)),
                          overlayColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered)) {
                                return Colors.green.withOpacity(0.04);
                              }
                              if (states.contains(MaterialState.focused) ||
                                  states.contains(MaterialState.pressed)) {
                                return Colors.green.withOpacity(0.12);
                              }
                              return null; // Defer to the widget's default.
                            },
                          ),
                        ),
                        child: const Text('Cash In',
                            style: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Padding(
                    padding: const EdgeInsets.only(top: 75.0),
                    child: SizedBox(
                      height: 45,
                      width: 140,
                      child: OutlinedButton(
                        onPressed: null,
                        style: ButtonStyle(
                          side: MaterialStateProperty.all<BorderSide>(
                            const BorderSide(color: Colors.red),
                          ),
                          shape:
                              MaterialStateProperty.resolveWith<OutlinedBorder>(
                            (states) => RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0x800000)),
                          overlayColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered)) {
                                return Colors.red.withOpacity(0.04);
                              }
                              if (states.contains(MaterialState.focused) ||
                                  states.contains(MaterialState.pressed)) {
                                return Colors.red.withOpacity(0.12);
                              }
                              return null; // Defer to the widget's default.
                            },
                          ),
                        ),
                        child: const Text('Cash Out',
                            style: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ),
                ],
              )
              //List of transactions will go here
              //Then the add transaction buttons underneath
            ],
          ),
        ),
      ),
    );
  }
}
