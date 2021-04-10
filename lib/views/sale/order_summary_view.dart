import 'package:customappbar/customappbar.dart';
import 'package:flipper_models/order.dart';
import 'package:flipper_models/view_models/complete_sale_viewmodel.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:number_display/number_display.dart';
import 'package:stacked/stacked.dart';

class OrderSummary extends StatelessWidget {
  final display = createDisplay(
    length: 8,
    decimal: 0,
  );
  List<Widget> buildItems({CompleteSaleViewModel model}) {
    final List<Widget> list = [];

    for (Order order in model.keypad.orders.value) {
      list.add(
        Slidable(
          actionPane: const SlidableDrawerActionPane(),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () {
                print('hello');
              },
            )
          ],
          child: ListTile(
              contentPadding: const EdgeInsets.only(left: 40.0, right: 40.0),
              trailing: Text(
                display(order.amount).toString(),
                style: const TextStyle(color: Colors.black),
              ),
              leading: Text(order.variantName,
                  style: const TextStyle(color: Colors.black)),
              // ignore: prefer_const_literals_to_create_immutables
              title: Row(children: [
                const Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 16.0,
                ),
                const Text(' '),
                Text(order.quantity.toInt().toString())
              ])),
        ),
      );
    }
    list.add(ListTile(
      contentPadding: const EdgeInsets.only(left: 40.0, right: 40.0),
      trailing: Text(
        display(model.keypad.orders.value.fold(0, (a, b) => a + b.amount))
            .toString(),
        style: const TextStyle(color: Colors.black),
      ),
      leading: const Text('Total', style: TextStyle(color: Colors.black)),
    ));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        builder:
            (BuildContext context, CompleteSaleViewModel model, Widget child) {
          return Scaffold(
            appBar: CustomAppBar(
              onPop: () {
                ProxyService.nav.pop();
              },
              title: 'Total: Frw' +
                  display(model.keypad.orders.value
                      .fold(0, (a, b) => a + b.amount)).toString(),
              icon: Icons.close,
              multi: 3,
              bottomSpacer: 52,
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView(children: buildItems(model: model)),
                )
              ],
            ),
          );
        },
        onModelReady: (CompleteSaleViewModel model) {
          model.keypad.getOrders();
        },
        viewModelBuilder: () => CompleteSaleViewModel());
  }
}
