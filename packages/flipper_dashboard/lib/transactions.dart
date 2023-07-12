import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class Transactions extends StatefulWidget {
  const Transactions({Key? key}) : super(key: key);

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  @override
  void initState() {
    super.initState();
  }

  final _routerService = locator<RouterService>();
  String lastSeen = "";
  bool defaultTransactions = true;
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

  List<Widget> _normalTransactions({required List<Transaction> completedTransaction}) {
    for (Transaction transaction in completedTransaction) {
      if (lastSeen != transaction.createdAt.substring(0, 10)) {
        setState(() {
          lastSeen = transaction.createdAt.substring(0, 10);
        });

        list.add(
          Container(
            margin: const EdgeInsets.fromLTRB(80, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(DateFormat.yMMMEd()
                    .format(DateTime.parse(transaction.createdAt))),
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
                .replaceWith(TransactionDetailRoute(transaction: transaction)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(Icons.wallet),
                Text(transaction.subTotal.toString()),
                const Spacer(),
                Text(transaction.createdAt.toString().substring(11, 19)),
                const Icon(FluentIcons.arrow_forward_20_regular),
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
    return ViewModelBuilder<HomeViewModel>.reactive(
        onViewModelReady: (model) async {
          List<Transaction> completedTransactions = await ProxyService.isar
              .completedTransactions(branchId: ProxyService.box.getBranchId()!);
          Drawers? drawer = await ProxyService.isar
              .getDrawer(cashierId: ProxyService.box.getBusinessId()!);

          model.completedTransactionsList = completedTransactions;

          setState(() {
            list = _normalTransactions(completedTransaction: completedTransactions);
          });
          // for rra z report
          setState(() {
            zlist = _zTransactions(drawer: drawer!);
          });
        },
        viewModelBuilder: () => HomeViewModel(),
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: const SizedBox.shrink(),
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Transactions',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          color: Colors.black),
                    ),
                    SizedBox(
                      width: 30,
                      child: SwitchListTile(
                          value: !defaultTransactions,
                          onChanged: (value) {
                            setState(() {
                              defaultTransactions = !defaultTransactions;
                            });
                          }),
                    )
                  ]),
              elevation: 0,
            ),
            body: defaultTransactions
                ? (list.isEmpty
                    ? Center(
                        child: Text(
                        "No Transactions",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            color: Colors.black),
                      ))
                    : ListView(
                        children: list,
                      ))
                : (zlist.isEmpty
                    ? Center(
                        child: Text(
                        "No Z Report",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            color: Colors.black),
                      ))
                    : ListView(
                        children: zlist,
                      )),
          );
        });
  }
}
