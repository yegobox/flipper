import 'package:customappbar/customappbar.dart';

import 'package:flipper/views/stock/stock_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';

class ReceiveStockScreen extends StatelessWidget {
  const ReceiveStockScreen({
    Key key,
    @required this.id,
  }) : super(key: key);
  final String id;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        builder: (BuildContext context, StockViewModel model, Widget child) {
          return Scaffold(
            appBar: CommonAppBar(
              onPop: () {
                ProxyService.nav.pop();
              },
              disableButton: false,
              title: 'Receive stock',
              onPressedCallback: () {
                model.updateStock(variantId: id);
                ProxyService.nav.pop();
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
                    // TODO: improve the widget to take previous instock qty
                    ReceiveStockInputWidget(
                        variantId: id, currentStock: 0, model: model),
                    Container(
                      height: 20,
                    ),
                    const Text(
                        'Inventory tracking will be enabled by\n default for items with stock count. To turn \n tracking off, visit your flipper Dashboard')
                  ],
                ),
              ),
            ),
          );
        },
        viewModelBuilder: () => StockViewModel());
  }
}

class ReceiveStockInputWidget extends StatelessWidget {
  const ReceiveStockInputWidget(
      {Key key, @required this.variantId, this.currentStock, this.model})
      : super(key: key);

  final String variantId;
  final int currentStock;
  final StockViewModel model;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: currentStock == null ? '0' : currentStock.toString(),
      keyboardType: TextInputType.number,
      textDirection: TextDirection.rtl,
      autofocus: true,
      style: const TextStyle(color: Colors.black),
      onChanged: (String count) async {
        if (count != '') {
          model.setStockValue(value: double.parse(count));
        }
      },
      decoration: const InputDecoration(
        hintText: 'Add Stock',
        focusColor: Colors.blue,
      ),
    );
  }
}
