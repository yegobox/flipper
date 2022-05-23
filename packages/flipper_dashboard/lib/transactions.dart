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
  List<Widget> list = [];
  List<Widget> _list({required List<Order> completedOrder}) {
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
            list = _list(completedOrder: completedOrders);
          });
        },
        viewModelBuilder: () => BusinessHomeViewModel(),
        builder: (context, model, child) {
          return Flexible(
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Transactions'),
                elevation: 1,
              ),
              body: list.isEmpty
                  ? const Center(child: Text("No Transactions"))
                  : ListView(
                      children: list,
                    ),
            ),
          );
        });
  }
}
