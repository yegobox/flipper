import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:riverpod/riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'widgets/mini_app_icon.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'widgets/analytics_gauge/flipper_analytic.dart';
import 'package:flipper_models/realm_model_export.dart';

Widget BuildGaugeOrList({
  required BuildContext context,
  required AsyncValue<List<ITransaction>> data,
  required CoreViewModel model,
  required String widgetType,
}) {
  final _routerService = locator<RouterService>();

  return data.when(
    data: (value) {
      if (value.isEmpty) {
        if (widgetType == 'gauge') {
          return SemiCircleGauge(
            dataOnGreenSide: 0,
            dataOnRedSide: 0,
            startPadding: 0,
            profitType: model.profitType,
            areValueColumnsVisible: !model.newTransactionPressed,
          );
        } else {
          return const SizedBox.shrink();
        }
      } else {
        // Filter transactions based on period
        final filteredTransactions = filterTransactionsByPeriod(
          transactions: value,
          period: model.transactionPeriod,
        );

        switch (widgetType) {
          case 'gauge':
            // Calculate sum for gauge
            final sumCashIn = filteredTransactions
                .where((transaction) =>
                    transaction.transactionType == TransactionType.cashIn)
                .fold(0.0, (sum, transaction) => sum + transaction.subTotal);
            final sumCashOut = filteredTransactions
                .where((transaction) =>
                    transaction.transactionType == TransactionType.cashOut)
                .fold(0.0, (sum, transaction) => sum + transaction.subTotal);

            return SemiCircleGauge(
              dataOnGreenSide: sumCashIn,
              dataOnRedSide: sumCashOut,
              startPadding: 0,
              profitType: model.profitType,
              areValueColumnsVisible: !model.newTransactionPressed,
            );

          case 'list':
            if (filteredTransactions.isEmpty) {
              return Center(
                child: Text(
                  'No records for ${model.transactionPeriod.toLowerCase()}',
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: filteredTransactions.length,
              itemBuilder: (context, index) {
                final transaction = filteredTransactions[index];
                return GestureDetector(
                  onTap: () => _routerService.navigateTo(
                    TransactionDetailRoute(transaction: transaction),
                  ),
                  child: Container(
                    height: 70,
                    child: ListTile(
                      leading: Container(
                        height: 75,
                        width: 55,
                        child: Center(
                          child: MiniAppIcon(
                            icon: 'assets/flipper_transaction_icon.svg',
                            color: transaction.isExpense == true
                                ? const Color(0xFFFF0331)
                                : const Color(0xFF4CAF50),
                            page: transaction.transactionType !=
                                    TransactionType.cashOut
                                ? "Income"
                                : "Expense",
                            showPageName: false,
                            sideSize: 55,
                          ),
                        ),
                      ),
                      title: Text(
                        NumberFormat('#,###').format(
                              double.parse(transaction.subTotal.toString()),
                            ) +
                            " RWF",
                        style: GoogleFonts.poppins(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        DateFormat('dd/MM/yyyy')
                            .format(DateTime.parse(transaction.createdAt!)),
                        style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      trailing: Text(
                        DateFormat('HH:mm')
                            .format(DateTime.parse(transaction.createdAt!)),
                        style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    ),
                  ),
                );
              },
            );
          default:
            return Center(
              child: Text(
                'Incorrect widget type',
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
        }
      }
    },
    error: (error, stackTrace) {
      return Text(error.toString());
    },
    loading: () {
      return const Text("Loading transactions");
    },
  );
}

List<ITransaction> filterTransactionsByPeriod({
  required List<ITransaction> transactions,
  required String period,
}) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final thisWeek = DateTime(now.year, now.month, now.day - (now.weekday - 1));
  final thisMonth = DateTime(now.year, now.month, 1);
  final thisYear = DateTime(now.year, 1, 1);

  switch (period) {
    case 'Today':
      return transactions.where((transaction) {
        final transactionDate = DateTime.parse(transaction.createdAt!);
        return transactionDate.isAfter(today);
      }).toList();
    case 'This Week':
      return transactions.where((transaction) {
        final transactionDate = DateTime.parse(transaction.createdAt!);
        return transactionDate.isAfter(thisWeek);
      }).toList();
    case 'This Month':
      return transactions.where((transaction) {
        final transactionDate = DateTime.parse(transaction.createdAt!);
        return transactionDate.isAfter(thisMonth);
      }).toList();
    case 'This Year':
      return transactions.where((transaction) {
        final transactionDate = DateTime.parse(transaction.createdAt!);
        return transactionDate.isAfter(thisYear);
      }).toList();
    default:
      return transactions;
  }
}
