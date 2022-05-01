import 'package:flipper_dashboard/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:number_display/number_display.dart';
import 'package:flipper_models/isar_models.dart';
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
    for (OrderItem item in model.kOrder!.orderItems) {
      list.add(
        Slidable(
          key: ValueKey(item.id),
          // The start action pane is the one at the right or the top side.
          endActionPane: ActionPane(
            // A motion is a widget used to control how the pane animates.
            motion: const ScrollMotion(),

            // All actions are defined in the children parameter.
            children: [
              // A SlidableAction can have an icon and/or a label.
              SlidableAction(
                onPressed: (_) {
                  model.deleteOrderItem(id: item.id, context: context);
                },
                backgroundColor: const Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          startActionPane: ActionPane(
            // A motion is a widget used to control how the pane animates.
            motion: const ScrollMotion(),

            // All actions are defined in the children parameter.
            children: [
              // A SlidableAction can have an icon and/or a label.
              SlidableAction(
                onPressed: (_) {
                  model.deleteOrderItem(id: item.id, context: context);
                },
                backgroundColor: const Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
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
                  item.qty.toInt().toString(),
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
                leading: const Text(
                  'Total',
                  style: TextStyle(
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
