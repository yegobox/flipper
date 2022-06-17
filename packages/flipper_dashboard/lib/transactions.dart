import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class Transactions extends StatefulWidget {
  const Transactions({Key? key, required this.model}) : super(key: key);
  final BusinessHomeViewModel model;

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  String lastSeen = "";
  bool defaultTransactions = true;
  List<Widget> list = [];
  List<Widget> zlist = [];
  List<Widget> _zTransactions({required List<Order> completedOrder}) {
    zlist.add(Column(children: [
      const Text('Trade Name: yegobox'),
      const Text('Daily report of Today'),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Opening Deposit'),
            Text('500 RWF'),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Total NS'),
            Text('50'),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Total NR'),
            Text('50'),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Total Taxes'),
            Text('RS-NS'),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Total CS'),
            Text('50'),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Total TS'),
            Text('50'),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Total PS'),
            Text('50'),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Total Sales per payment mode'),
            Text('50% cash'),
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

  List<Widget> _normalTransactions({required List<Order> completedOrder}) {
    for (Order order in completedOrder) {
      if (lastSeen != order.createdAt.substring(0, 10)) {
        setState(() {
          lastSeen = order.createdAt.substring(0, 10);
        });

        list.add(
          Container(
            margin: const EdgeInsets.fromLTRB(80, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(DateFormat.yMMMEd()
                    .format(DateTime.parse(order.createdAt))),
              ],
            ),
          ),
        );
      }
      list.add(
        Container(
          margin: const EdgeInsets.all(4),
          child: GestureDetector(
            onTap: () => GoRouter.of(context).push("/trDetail", extra: order),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(Icons.wallet),
                Text(order.subTotal.toString()),
                const Spacer(),
                Text(order.createdAt.toString().substring(11, 19)),
                const Icon(Icons.arrow_forward_ios),
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
    return ViewModelBuilder<BusinessHomeViewModel>.reactive(
        onModelReady: (model) async {
          List<Order> completedOrders = await ProxyService.isarApi
              .completedOrders(branchId: ProxyService.box.getBranchId()!);

          model.completedOrdersList = completedOrders;

          setState(() {
            list = _normalTransactions(completedOrder: completedOrders);
          });
          // for rra z report
          setState(() {
            zlist = _zTransactions(completedOrder: completedOrders);
          });
        },
        viewModelBuilder: () => BusinessHomeViewModel(),
        builder: (context, model, child) {
          return Flexible(
            child: Scaffold(
              appBar: AppBar(
                title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Transactions'),
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
                elevation: 1,
              ),
              body: defaultTransactions
                  ? (list.isEmpty
                      ? const Center(child: Text("No Transactions"))
                      : ListView(
                          children: list,
                        ))
                  : (zlist.isEmpty
                      ? const Center(child: Text("No Z Report"))
                      : ListView(
                          children: zlist,
                        )),
            ),
          );
        });
  }
}
