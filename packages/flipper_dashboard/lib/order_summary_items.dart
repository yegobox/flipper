import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:number_display/number_display.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

final display = createDisplay(
  length: 8,
  decimal: 0,
);

List<Widget> buildItems(
    {required BusinessHomeViewModel model,
    required BuildContext context,
    required List<OrderItem> items}) {
  final List<Widget> list = [];

  if (items.isEmpty) {
    list.add(const Center(child: Text('Current order has no items')));
    return list;
  }

  for (OrderItem item in items) {
    list.add(
      Slidable(
        key: ValueKey(item.id),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) async {
                model.kOrder!.subTotal =
                    model.kOrder!.subTotal - (item.price * item.qty);
                await ProxyService.isarApi.update(data: model.kOrder);
                model.deleteOrderItem(id: item.id, context: context);
                model.currentOrder();
              },
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) async {
                model.kOrder!.subTotal =
                    model.kOrder!.subTotal - (item.price * item.qty);
                await ProxyService.isarApi.update(data: model.kOrder);
                model.deleteOrderItem(id: item.id, context: context);
                model.currentOrder();
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
            'RWF ' + display(item.price * item.qty).toString(),
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
