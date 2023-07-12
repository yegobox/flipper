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
  const TransactionDetail({Key? key, required this.transaction}) : super(key: key);
  final Transaction transaction;
  @override
  State<TransactionDetail> createState() => _TransactionDetailState();
}

class _TransactionDetailState extends State<TransactionDetail> {
  List<Widget> _list(
      {required List<TransactionItem> items, required HomeViewModel model}) {
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
                            refund(item.id!, model);
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
                            refund(item.id!, model);
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
    return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => HomeViewModel(),
        onViewModelReady: (model) async {
          List<TransactionItem> items = await ProxyService.isar
              .transactionItems(transactionId: widget.transaction.id!, doneWithTransaction: false);

          model.completedTransactionItemsList = items;
        },
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                  'FRW ' + widget.transaction.subTotal.toInt().toString() + " Sale"),
              elevation: 1,
            ),
            body: Column(
              children: [
                OutlinedButton(
                  onPressed: () {
                    _routerService.navigateTo(AfterSaleRoute(
                        totalTransactionAmount: widget.transaction.subTotal,
                        receiptType: ReceiptType.nr,
                        transaction: widget.transaction));
                  },
                  child: const Text('Issue Refund'),
                ),
                OutlinedButton(
                  onPressed: () {
                    _routerService.navigateTo(AfterSaleRoute(
                        totalTransactionAmount: widget.transaction.subTotal,
                        receiptType: ReceiptType.cs,
                        transaction: widget.transaction));
                  },
                  child: const Text('New receipt'),
                ),
                ..._list(items: model.completedTransactionItemsList, model: model),
              ],
            ),
          );
        });
  }

  Future<void> refund(int id, HomeViewModel model) async {
    ProxyService.isar.refund(itemId: id);
    List<TransactionItem> items = await ProxyService.isar
        .transactionItems(transactionId: widget.transaction.id!, doneWithTransaction: false);

    model.completedTransactionItemsList = items;
  }
}
