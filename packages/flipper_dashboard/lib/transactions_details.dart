import 'package:flipper_models/isar_models.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stacked/stacked.dart';

class TransactionDetail extends StatefulWidget {
  const TransactionDetail({Key? key, required this.order}) : super(key: key);
  final Order order;
  @override
  State<TransactionDetail> createState() => _TransactionDetailState();
}

class _TransactionDetailState extends State<TransactionDetail> {
  List<Widget> _list({required List<OrderItem> items}) {
    return items
        .map((item) => Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.wallet),
                      Text(item.name),
                      const Spacer(),
                      Text("FRW " + (item.price * item.qty).toInt().toString()),
                    ],
                  ),
                ),
              ],
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BusinessHomeViewModel>.reactive(
        viewModelBuilder: () => BusinessHomeViewModel(),
        onModelReady: (model) async {
          List<OrderItem> items =
              await ProxyService.isarApi.orderItems(orderId: widget.order.id);
          model.completedOrderItemsList = items;
        },
        builder: (context, model, child) {
          return Flexible(
            child: Scaffold(
              appBar: AppBar(
                title: Text('FRW ' +
                    widget.order.subTotal.toInt().toString() +
                    " Sale"),
                elevation: 1,
              ),
              body: Column(
                children: [
                  OutlinedButton(
                    onPressed: () {
                      GoRouter.of(context).push(
                          Routes.afterSale +
                              "/${widget.order.subTotal}/${ReceiptType.nr}",
                          extra: widget.order);
                    },
                    child: const Text('Issue Refund'),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      GoRouter.of(context).push(
                          Routes.afterSale +
                              "/${widget.order.subTotal}/${ReceiptType.cs}",
                          extra: widget.order);
                    },
                    child: const Text('New receipt'),
                  ),
                  ..._list(items: model.completedOrderItems)
                ],
              ),
            ),
          );
        });
  }
}
