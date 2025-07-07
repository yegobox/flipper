import 'package:flipper_dashboard/DateCoreWidget.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'widgets/mini_app_icon.dart';
import 'widgets/radio_buttons.dart';

class Transactions extends StatefulHookConsumerWidget {
  const Transactions({Key? key}) : super(key: key);

  @override
  TransactionsState createState() => TransactionsState();
}

class TransactionsState extends ConsumerState<Transactions>
    with DateCoreWidget {
  final _routerService = locator<RouterService>();
  String lastSeen = "";
  bool defaultTransactions = true;
  int displayedTransactionType = 0;
  List<String> transactionTypeOptions = ["All", "Sales", "Purchases"];
  List<Widget> list = [];
  List<Widget> zlist = [];

  @override
  void initState() {
    super.initState();
  }

  List<Widget> _zTransactions() {
    zlist = []; // Clear existing items
    zlist.add(
      Card(
        margin: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Trade Name: ',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Daily report for Today',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            _buildZReportRow(
                'Opening Deposit', '${ProxyService.box.defaultCurrency()}'),
            _buildZReportRow('Total NS', "0"),
            _buildZReportRow('Total NR', "0"),
            _buildZReportRow(
              'Total Taxes',
              "0".toString(),
            ),
            _buildZReportRow('Total CS', "0"),
            _buildZReportRow('Total TS', "0"),
            _buildZReportRow('Total PS', "0"),
            _buildZReportRow('Total Sales per payment mode', '100% cash'),
            _buildZReportRow('All Discounts', '0'),
            _buildZReportRow('Incomplete sales', '0'),
            _buildZReportRow('Other Transactions', '0'),
          ],
        ),
      ),
    );
    return zlist;
  }

  Widget _buildZReportRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String isEquivalentToToday(String isoString) {
    DateTime dateTime = DateTime.parse(isoString);
    DateTime today = DateTime.now();

    if (dateTime.year == today.year &&
        dateTime.month == today.month &&
        dateTime.day == today.day) {
      return 'Today';
    } else {
      return DateFormat.yMMMEd().format(DateTime.parse(isoString));
    }
  }

  // Helper to get the correct date for display/filtering
  DateTime _getEffectiveDate(ITransaction transaction) {
    return transaction.lastTouched ?? transaction.createdAt!;
  }

  List<Widget> _normalTransactions(
      {required List<ITransaction> completedTransaction}) {
    list.clear(); // Clear existing items
    for (ITransaction transaction in completedTransaction) {
      if (displayedTransactionType == 1 &&
          transaction.transactionType == TransactionType.cashOut) {
        continue;
      }
      if (displayedTransactionType == 2 &&
          transaction.transactionType != TransactionType.cashOut) {
        continue;
      }

      final effectiveDate = _getEffectiveDate(transaction);
      if (lastSeen != effectiveDate.toIso8601String().substring(0, 10)) {
        lastSeen = effectiveDate.toIso8601String().substring(0, 10);
        list.add(_buildDateHeader(transaction));
      }

      list.add(_buildTransactionItem(transaction));
    }
    return list;
  }

  Widget _buildDateHeader(ITransaction transaction) {
    final effectiveDate = _getEffectiveDate(transaction);
    return Container(
      margin: const EdgeInsets.fromLTRB(30, 10, 0, 10),
      child: Text(
        isEquivalentToToday(effectiveDate.toIso8601String()),
        style: GoogleFonts.poppins(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF006AFE),
        ),
      ),
    );
  }

  Widget _buildTransactionItem(ITransaction transaction) {
    Color gradientColorOne =
        transaction.isExpense == true ? Colors.red : Colors.blue;
    String typeOfTransaction =
        transaction.isExpense == true ? "Expense" : "Income";

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: InkWell(
        onTap: () => _routerService
            .navigateTo(TransactionDetailRoute(transaction: transaction)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              MiniAppIcon(
                icon: 'assets/flipper_transaction_icon.svg',
                color: gradientColorOne,
                page: "Transaction",
                showPageName: false,
                sideSize: 50,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.subTotal!.toCurrencyFormatted(
                          symbol: ProxyService.box.defaultCurrency()),
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      typeOfTransaction,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                _getEffectiveDate(transaction).toString().substring(11, 16),
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
              const Icon(FluentIcons.chevron_right_20_regular),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CoreViewModel>.reactive(
      onViewModelReady: (model) async {
        setState(() {
          zlist = _zTransactions();
        });
      },
      viewModelBuilder: () => CoreViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            actions: [datePicker()],
            title: const Text('Transactions'),
          ),
          body: defaultTransactions
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 13.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RadioButtons(
                            buttonLabels: transactionTypeOptions,
                            onChanged: (newPeriod) {
                              setState(() {
                                list = [];
                                displayedTransactionType = newPeriod;
                              });
                            },
                          ),
                          const Divider(
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: buildList(context, model),
                    ),
                  ],
                )
              : zlist.isEmpty
                  ? Center(
                      child: Text(
                        "No Z Report",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async => setState(() {}),
                      child: ListView(children: zlist),
                    ),
        );
      },
    );
  }

  Widget buildList(BuildContext context, CoreViewModel model) {
    final transactionsData = ref.watch(dashboardTransactionsProvider);
    return transactionsData.when(
      data: (value) {
        final transactions = _normalTransactions(completedTransaction: value);
        return RefreshIndicator(
          onRefresh: () async => setState(() {}),
          child: ListView(
            children: transactions,
          ),
        );
      },
      error: (error, stackTrace) {
        return Center(
          child: Text(
            error.toString(),
            style: GoogleFonts.poppins(color: Colors.red),
          ),
        );
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
