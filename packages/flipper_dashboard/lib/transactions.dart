import 'package:flipper_dashboard/DateCoreWidget.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
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
  @override
  void initState() {
    super.initState();
  }

  final _routerService = locator<RouterService>();
  String lastSeen = "";
  bool defaultTransactions = true;
  int displayedTransactionType = 0;
  List<String> transactionTypeOptions = ["All", "Sales", "Purchases"];
  List<Widget> list = [];
  List<Widget> zlist = [];
  List<Widget> _zTransactions({required Drawers drawer}) {
    zlist.add(Column(children: [
      Text('Trade Name: ${drawer.tradeName}'),
      const Text('Daily report for Today'),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Opening Deposit'),
            Text('${drawer.openingBalance} RWF'),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total NS'),
            Text(drawer.nsSaleCount.toString()),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total NR'),
            Text(drawer.nrSaleCount.toString()),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total Taxes'),
            Text(((drawer.totalNsSaleIncome ?? 0) -
                    (drawer.totalCsSaleIncome ?? 0))
                .toString()),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total CS'),
            Text(drawer.csSaleCount.toString()),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total TS'),
            Text(drawer.trSaleCount.toString()),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total PS'),
            Text(drawer.psSaleCount.toString())
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Total Sales per payment mode'),
            Text('100% cash'),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('All Discounts'),
            Text('0'),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Incomplete sales'),
            Text('0'),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Other Transactions'),
            Text('0'),
          ],
        ),
      )
    ]));
    return zlist;
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

  List<Widget> _normalTransactions(
      {required List<ITransaction> completedTransaction}) {
    for (ITransaction transaction in completedTransaction) {
      if (displayedTransactionType == 1 &&
          transaction.transactionType == TransactionType.cashOut) {
        continue;
      }
      if (displayedTransactionType == 2 &&
          transaction.transactionType != TransactionType.cashOut) {
        continue;
      }
      Color gradientColorOne =
          transaction.isExpense == true ? Colors.red : Colors.greenAccent;

      String typeOfTransaction =
          transaction.isExpense == true ? "Expense" : "Income";
      if (lastSeen != transaction.createdAt!.substring(0, 10)) {
        lastSeen = transaction.createdAt!.substring(0, 10);

        list.add(
          Container(
            margin: const EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: Column(
              children: [
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(isEquivalentToToday(transaction.createdAt!),
                        style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF006AFE))),
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        );
      }
      list.add(
        Container(
          margin: const EdgeInsets.all(4),
          child: GestureDetector(
            onTap: () => _routerService
                .navigateTo(TransactionDetailRoute(transaction: transaction)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 5),
                Column(
                  children: [
                    Center(
                      child: MiniAppIcon(
                        icon: 'assets/flipper_transaction_icon.svg',
                        color: gradientColorOne,
                        page: "Transaction",
                        showPageName: false,
                        sideSize: 50,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(transaction.subTotal.toRwf(),
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        )),
                    Text(typeOfTransaction,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        )),
                  ],
                ),
                const Spacer(),
                Text(transaction.createdAt.toString().substring(11, 16),
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey)),
                const Icon(FluentIcons.chevron_right_20_regular),
              ],
            ),
          ),
        ),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CoreViewModel>.reactive(
      onViewModelReady: (model) async {
        Drawers? drawer = await ProxyService.local
            .getDrawer(cashierId: ProxyService.box.getUserId()!);

        // for rra z report
        setState(() {
          zlist = _zTransactions(drawer: drawer!);
        });
      },
      viewModelBuilder: () => CoreViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            actions: [datePicker()],
            title: Text('Transactions'),
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
                  : ListView(children: zlist),
        );
      },
    );
  }

  Widget buildList(BuildContext context, CoreViewModel model) {
    final transactionsData = ref.watch(transactionsStreamProvider);
    list.clear();
    return transactionsData.when(
      data: (value) {
        list = _normalTransactions(completedTransaction: value);
        return ListView(
          children: list,
        );
      },
      error: (error, stackTrace) {
        return Text(error.toString());
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
