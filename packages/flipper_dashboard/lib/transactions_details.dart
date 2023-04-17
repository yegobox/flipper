import 'package:flipper_models/isar_models.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_routing/receipt_types.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:stacked/stacked.dart';

class TransactionDetail extends StatefulWidget {
  const TransactionDetail({Key? key, required this.order}) : super(key: key);
  final Order order;
  @override
  State<TransactionDetail> createState() => _TransactionDetailState();
}

class _TransactionDetailState extends State<TransactionDetail> {
  List<Widget> _list(
      {required List<OrderItem> items, required BusinessHomeViewModel model}) {
    return items
        .map((item) => Column(
              children: [
                Slidable(
                    key: Key('slidable-${item.id}'),
                    child: Container(
                      height: 40,
                      margin: const EdgeInsets.all(6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.wallet),
                          Text(item.name),
                          const Spacer(),
                          Text(item.isRefunded != null && item.isRefunded!
                              ? "- FRW" +
                                  (item.price * item.qty).toInt().toString()
                              : "FRW " +
                                  (item.price * item.qty).toInt().toString()),
                        ],
                      ),
                    ),
                    startActionPane: ActionPane(
                      motion: ScrollMotion(
                        key: Key('dismissable-${item.id}'),
                      ),
                      children: [
                        SlidableAction(
                          onPressed: (_) {
                            refund(item.id, model);
                          },
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          icon: Icons.refresh_rounded,
                          label: 'Refund',
                        )
                      ],
                    ),
                    endActionPane: ActionPane(
                      motion: ScrollMotion(
                        key: Key('dismissable-${item.id}'),
                      ),
                      children: [
                        SlidableAction(
                          onPressed: (_) {
                            refund(item.id, model);
                          },
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          icon: Icons.refresh_rounded,
                          label: 'Refund',
                        )
                      ],
                    )),
              ],
            ))
        .toList();
  }

  final _routerService = locator<RouterService>();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BusinessHomeViewModel>.reactive(
        viewModelBuilder: () => BusinessHomeViewModel(),
        onViewModelReady: (model) async {
          List<OrderItem> items =
              await ProxyService.isarApi.orderItems(orderId: widget.order.id!);

          model.completedOrderItemsList = items;
        },
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                  'FRW ' + widget.order.subTotal.toInt().toString() + " Sale"),
              elevation: 1,
            ),
            body: Column(
              children: [
                OutlinedButton(
                  onPressed: () {
                    _routerService.navigateTo(AfterSaleRoute(
                        totalOrderAmount: widget.order.subTotal,
                        receiptType: ReceiptType.nr,
                        order: widget.order));
                  },
                  child: const Text('Issue Refund'),
                ),
                OutlinedButton(
                  onPressed: () {
                    _routerService.navigateTo(AfterSaleRoute(
                        totalOrderAmount: widget.order.subTotal,
                        receiptType: ReceiptType.cs,
                        order: widget.order));
                  },
                  child: const Text('New receipt'),
                ),
                ..._list(items: model.completedOrderItemsList, model: model),
              ],
            ),
          );
        });
  }

  Future<void> refund(int id, BusinessHomeViewModel model) async {
    ProxyService.isarApi.refund(itemId: id);
    List<OrderItem> items =
        await ProxyService.isarApi.orderItems(orderId: widget.order.id!);

    model.completedOrderItemsList = items;
  }
}
