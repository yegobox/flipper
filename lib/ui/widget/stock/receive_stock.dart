import 'package:customappbar/customappbar.dart';
import 'package:flipper/domain/redux/app_state.dart';

import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/ui/welcome/home/common_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ReceiveStockScreen extends StatefulWidget {
  const ReceiveStockScreen({
    Key key,
    @required this.variationId,
  }) : super(key: key);
  final String variationId;
  @override
  _ReceiveStockScreenState createState() => _ReceiveStockScreenState();
}

class _ReceiveStockScreenState extends State<ReceiveStockScreen> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CommonViewModel>(
      distinct: true,
      converter: CommonViewModel.fromStore,
      builder: (BuildContext context, CommonViewModel vm) {
        return Scaffold(
          appBar: CommonAppBar(
            onPop: () {
              Routing.navigator.pop();
            },
            disableButton: false,
            title: 'Receive stock',
            onPressedCallback: () {
              Routing.navigator.pop();
            },
            showActionButton: true,
            actionButtonName: 'Save',
            icon: Icons.close,
            multi: 3,
            bottomSpacer: 52,
          ),
          body: Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40, 40, 40, 40),
              child: Column(
                children: <Widget>[
                  // FIXME:
                  // StreamBuilder(
                  //     stream: vm.database.stockDao.getStockByVariantStream(
                  //         branchId: vm.branch.id,
                  //         variationId: widget.variationId),
                  //     builder: (context,
                  //         AsyncSnapshot<List<StockTableData>> snapshot) {
                  //       if (snapshot.data == null) {
                  //         return Text('');
                  //       } else {
                  //         return ReceiveStockInputWidget(
                  //           variantId: widget.variationId,
                  //           vm: vm,
                  //           currentStock: snapshot.data[0].currentStock,
                  //         );
                  //       }
                  //     }),
                  Container(
                    height: 20,
                  ),
                  Text(
                      'Inventory tracking will be enabled by\n default for items with stock count. To turn \n tracking off, visit your flipper Dashboard')
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ReceiveStockInputWidget extends StatefulWidget {
  const ReceiveStockInputWidget({
    Key key,
    @required this.vm,
    @required this.variantId,
    this.currentStock,
  }) : super(key: key);
  final CommonViewModel vm;
  final String variantId;
  final int currentStock;
  @override
  _ReceiveStockInputWidgetState createState() =>
      _ReceiveStockInputWidgetState();
}

class _ReceiveStockInputWidgetState extends State<ReceiveStockInputWidget> {
  // FIXME:
  // Future receiveStock(CommonViewModel vm, double quantity) async {
  //   StockTableData stock = await vm.database.stockDao.getStockByVariantId(
  //       variantId: widget.variantId, branchId: vm.branch.id);
  //   //get a stock history by variantId then update it with: Received as reason every time an edit.
  //   StockHistoryTableData history = await vm.database.stockHistoryDao
  //       .getByVariantId(variantId: widget.variantId);

    // await vm.database.stockDao.updateStock(
    //   stock.copyWith(
    //     updatedAt: DateTime.now(),
    //     action: Defaults.RECEIVE.toString(),
    //     currentStock: quantity.toInt(),
    //     idLocal: stock.idLocal,
    //   ),
    // );

    // if (history == null) {
    //   await vm.database.stockHistoryDao.insert(
    //     //ignore:missing_required_param
    //     StockHistoryTableData(
    //         quantity: quantity.toInt(),
    //         variantId: widget.variantId,
    //         id: Uuid().v1(),
    //         note: 'Received ' + quantity.toString() + 'qty',
    //         reason: 'Received',
    //         stockId: stock.id,
    //         createdAt: DateTime.now(),
    //         updatedAt: DateTime.now()),
    //   );
    // } else {
    //   await vm.database.stockHistoryDao
    //       .updateHistory(history.copyWith(quantity: quantity.toInt()));
    // }
  // }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue:
          widget.currentStock == null ? '0' : widget.currentStock.toString(),
      keyboardType: TextInputType.number,
      textDirection: TextDirection.rtl,
      autofocus: true,
      style: const TextStyle(color: Colors.black),
      onChanged: (String count) async {
        if (count != '') {
          // FIXME:
          // await receiveStock(widget.vm, double.parse(count));
        }
      },
      decoration: const InputDecoration(
        hintText: 'Add Stock',
        focusColor: Colors.blue,
      ),
    );
  }
}
