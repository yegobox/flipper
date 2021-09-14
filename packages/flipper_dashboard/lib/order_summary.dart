import 'package:flipper_dashboard/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/view_models/business_home_viewmodel.dart';
import 'package:number_display/number_display.dart';
import 'package:flipper_models/order_item.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flipper_services/proxy.dart';

class OrderSummary extends StatelessWidget {
  final display = createDisplay(
    length: 8,
    decimal: 0,
  );
  OrderSummary({Key? key}) : super(key: key);
  List<Widget> buildItems({required BusinessHomeViewModel model}) {
    final List<Widget> list = [];
    if (model.orders.isEmpty) {
      list.add(Center(child: Text('There is no current order')));
      return list;
    }
    for (OrderItem item in model.orders[0].orderItems) {
      list.add(
        Slidable(
          actionPane: const SlidableDrawerActionPane(),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () {
                model.deleteOrderItem(id: item.id);
              },
            )
          ],
          child: ListTile(
            contentPadding: const EdgeInsets.only(left: 40.0, right: 40.0),
            trailing: Text(
              'RWF ' + display(item.price).toString(),
              style: const TextStyle(color: Colors.black),
            ),
            leading: Text(
              item.name,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
            title: Row(
              children: [
                const Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 16.0,
                ),
                const Text(' '),
                Text(
                  item.count.toInt().toString(),
                )
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
      viewModelBuilder: () => BusinessHomeViewModel(),
      onModelReady: (model) {
        model.getTotal();
      },
      builder: (context, model, child) {
        if (model.orders.isEmpty) {
          return Scaffold(
            appBar: CustomAppBar(
              onPop: () {
                ProxyService.nav.back();
              },
              title: 'Summary',
              icon: Icons.close,
              multi: 3,
              bottomSpacer: 52,
            ),
            body: ListView(
              children: buildItems(
                model: model,
              ),
            ),
          );
        }
        return Scaffold(
          appBar: CustomAppBar(
            onPop: () {
              ProxyService.nav.back();
            },
            title: 'Total: Frw' + display(model.totalPayable).toString(),
            icon: Icons.close,
            multi: 3,
            bottomSpacer: 52,
          ),
          body: ListView(
            children: [
              ...buildItems(
                model: model,
              ),
              if (model.totalDiscount! > 0)
                ListTile(
                  contentPadding:
                      const EdgeInsets.only(left: 40.0, right: 40.0),
                  trailing: Text(
                    'RWF ' + display(model.totalDiscount).toString(),
                    style: const TextStyle(color: Colors.black),
                  ),
                  leading: Text(
                    'Discounts',
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 40.0, right: 40.0),
                trailing: Text(
                  'RWF ' +
                      display(model.totalDiscount! > 0
                              ? model.totalDiscount
                              : model.totalPayable)
                          .toString(),
                  style: const TextStyle(color: Colors.black),
                ),
                leading: Text(
                  'Total',
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
