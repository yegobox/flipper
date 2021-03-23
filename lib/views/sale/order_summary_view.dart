import 'package:flipper/views/sale/complete_sale_viewmodel.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:customappbar/customappbar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:stacked/stacked.dart';

class OrderSummary extends StatelessWidget {
  List<Widget> buildItems({CompleteSaleViewModel model}) {
    final List<Widget> list = [];
    // ignore: avoid_function_literals_in_foreach_calls
    model.keypad.currentSalesItem.forEach((e) {
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
              e['price'].toStringAsFixed(0),
              style: const TextStyle(color: Colors.black),
            ),
            leading:
                Text(e['name'], style: const TextStyle(color: Colors.black)),
          ),
        ),
      );
    });
    model.keypad.setTotal.value = 0.0;
    // ignore: avoid_function_literals_in_foreach_calls
    model.keypad.currentSale.forEach((e) {
      model.keypad.setTotal.value += e['price'];
    });
    list.add(ListTile(
      contentPadding: const EdgeInsets.only(left: 40.0, right: 40.0),
      trailing: Text(
        model.keypad.total.toStringAsFixed(0),
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
            appBar: CommonAppBar(
              onPop: () {
                ProxyService.nav.pop();
              },
              title: 'Total: Frw' + model.keypad.total.toStringAsFixed(0),
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
          model.setCurrentItemKeyPadSaleValue();
        },
        viewModelBuilder: () => CompleteSaleViewModel());
  }
}
