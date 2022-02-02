import 'package:flipper_dashboard/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:number_display/number_display.dart';
import 'package:flipper_models/models/models.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

class OrderSummary extends StatelessWidget {
  final display = createDisplay(
    length: 8,
    decimal: 0,
  );
  OrderSummary({Key? key}) : super(key: key);
  List<Widget> buildItems(
      {required BusinessHomeViewModel model, required BuildContext context}) {
    final List<Widget> list = [];
    if (model.kOrder == null) {
      list.add(const Center(child: Text('There is no current order')));
      return list;
    }
    for (OrderItemSync item in model.kOrder!.orderItems) {
      list.add(
        Slidable(
          actionPane: const SlidableDrawerActionPane(),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () {
                model.deleteOrderItem(id: item.id, context: context);
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
        model.updatePayable();
      },
      builder: (context, model, child) {
        if (model.kOrder == null) {
          return Scaffold(
            appBar: CustomAppBar(
              onPop: () {
                GoRouter.of(context).pop();
              },
              title: 'Summary',
              icon: Icons.close,
              multi: 3,
              bottomSpacer: 52,
            ),
            body: ListView(
              children: buildItems(
                context: context,
                model: model,
              ),
            ),
          );
        }
        return Scaffold(
          appBar: CustomAppBar(
            onPop: () {
              GoRouter.of(context).pop();
            },
            title: 'Total: Frw' + display(model.totalPayable).toString(),
            icon: Icons.close,
            multi: 3,
            bottomSpacer: 52,
          ),
          body: ListView(
            children: [
              ...buildItems(
                context: context,
                model: model,
              ),
              if (model.totalDiscount > 0)
                ListTile(
                  contentPadding:
                      const EdgeInsets.only(left: 40.0, right: 40.0),
                  trailing: Text(
                    '- RWF ' + display(model.totalDiscount).toString(),
                    style: const TextStyle(color: Colors.black),
                  ),
                  leading: const Text(
                    'Discounts',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 40.0, right: 40.0),
                trailing: Text(
                  'RWF ' +
                      display(model.totalDiscount > 0
                              ? (model.totalPayable)
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
