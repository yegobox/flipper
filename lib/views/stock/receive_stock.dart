import 'package:customappbar/customappbar.dart';
import 'package:flipper/domain/redux/app_state.dart';

import 'package:flipper/services/proxy.dart';
import 'package:flipper/views/welcome/home/common_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ReceiveStockScreen extends StatefulWidget {
  const ReceiveStockScreen({
    Key key,
    @required this.id,
  }) : super(key: key);
  final String id;
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
              ProxyService.nav.pop();
            },
            disableButton: false,
            title: 'Receive stock',
            onPressedCallback: () {
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
                    variantId: widget.id,
                    currentStock: 0,
                  ),
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
    );
  }
}

class ReceiveStockInputWidget extends StatefulWidget {
  const ReceiveStockInputWidget({
    Key key,
    @required this.variantId,
    this.currentStock,
  }) : super(key: key);

  final String variantId;
  final int currentStock;
  @override
  _ReceiveStockInputWidgetState createState() =>
      _ReceiveStockInputWidgetState();
}

class _ReceiveStockInputWidgetState extends State<ReceiveStockInputWidget> {
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
