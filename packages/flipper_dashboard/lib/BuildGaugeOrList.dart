import 'dart:developer';

import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'widgets/mini_app_icon.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'widgets/analytics_gauge/flipper_analytic.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';

Widget BuildGaugeOrList(
    {required BuildContext context,
    required CoreViewModel model,
    required String widgetType}) {
  final _routerService = locator<RouterService>();
  return StreamBuilder<List<ITransaction>>(
    initialData: null,
    stream: model.getTransactions(),
    builder: (context, snapshot) {
      if (model.transactions.isEmpty) {
        if (widgetType == 'gauge') {
          log("waiting with no data");
          return SemiCircleGauge(
            dataOnGreenSide: 0,
            dataOnRedSide: 0,
            startPadding: 0,
            profitType: model.profitType,
            areValueColumnsVisible: !model.newTransactionPressed,
          );
        } else {
          return SizedBox.shrink();
        }
      } else {
        DateTime oldDate;
        DateTime temporaryDate;

        if (model.transactionPeriod == 'Today') {
          DateTime tempToday = DateTime.now();
          oldDate = DateTime(tempToday.year, tempToday.month, tempToday.day);
        } else if (model.transactionPeriod == 'This Week') {
          oldDate = DateTime.now().subtract(Duration(days: 7));
          oldDate = DateTime(oldDate.year, oldDate.month, oldDate.day);
        } else if (model.transactionPeriod == 'This Month') {
          oldDate = DateTime.now().subtract(Duration(days: 30));
          oldDate = DateTime(oldDate.year, oldDate.month, oldDate.day);
        } else {
          oldDate = DateTime.now().subtract(Duration(days: 365));
          oldDate = DateTime(oldDate.year, oldDate.month, oldDate.day);
        }

        List<ITransaction> filteredTransactions = [];
        for (final transaction in model.transactions) {
          temporaryDate = DateTime.parse(transaction.createdAt);
          if (temporaryDate.isAfter(oldDate)) {
            filteredTransactions.add(transaction);
          }
        }

        switch (widgetType) {
          case 'gauge':
            double sum_cash_in = 0;
            double sum_cash_out = 0;
            for (final transaction in filteredTransactions) {
              if (transaction.transactionType == 'Cash Out') {
                sum_cash_out = transaction.subTotal + sum_cash_out;
              } else {
                sum_cash_in = transaction.subTotal + sum_cash_in;
              }
            }
            return SemiCircleGauge(
              dataOnGreenSide: sum_cash_in,
              dataOnRedSide: sum_cash_out,
              startPadding: 0,
              profitType: model.profitType,
              areValueColumnsVisible: !model.newTransactionPressed,
            );

          case 'list':
            if (filteredTransactions.length == 0) {
              return Center(
                child: Text(
                    'No records for ' + model.transactionPeriod.toLowerCase(),
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    )),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: filteredTransactions.length,
              itemBuilder: (context, index) {
                final transaction = filteredTransactions[index];
                return Container(
                  height: 70,
                  child: ListTile(
                    leading: Container(
                      height: 75,
                      width: 55,
                      child: Center(
                        child: MiniAppIcon(
                          icon: 'assets/flipper_transaction_icon.svg',
                          color: transaction.transactionType != 'Cash Out'
                              ? Color(0xFF4CAF50)
                              : Color(0xFFFF0331),
                          page: transaction.transactionType != 'Cash Out'
                              ? "Income"
                              : "Expense",
                          showPageName: false,
                          sideSize: 55,
                        ),
                      ),
                    ), // Icon before the title
                    title: Text(
                        NumberFormat('#,###').format(
                                double.parse(transaction.subTotal.toString())) +
                            " RWF",
                        style: GoogleFonts.poppins(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        DateFormat('dd/MM/yyyy')
                            .format(DateTime.parse(transaction.createdAt)),
                        style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey)),
                    trailing: Text(
                        DateFormat('HH:mm')
                            .format(DateTime.parse(transaction.createdAt)),
                        style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey)),

                    onTap: () => _routerService.navigateTo(
                        TransactionDetailRoute(transaction: transaction)),
                  ),
                );
              },
            );
          default:
            return Center(
              child: Text('Incorrect widget type',
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  )),
            );
        }
      }
    },
  );
}
