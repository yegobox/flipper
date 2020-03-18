import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/util/HexColor.dart';
import 'package:flipper/util/flitter_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_redux/flutter_redux.dart';

class PayableWidget extends StatefulWidget {
  @override
  _PayableWidgetState createState() => _PayableWidgetState();
}

class _PayableWidgetState extends State<PayableWidget> {
  int _total = 0;

  @override
  Widget build(BuildContext context) {
    var payable = new MoneyMaskedTextController(
        leftSymbol: '\RWF ', decimalSeparator: ".", thousandSeparator: ",");
    payable.updateValue(0);

    _getOrderCart();

    return StoreConnector<AppState, CommonViewModel>(
      distinct: true,
      converter: CommonViewModel.fromStore,
      builder: (context, vm) {
        return Container(
          height: 66,
          color: HexColor(FlipperColors.blue),
          child: StreamBuilder(
            stream: vm.database.cartDao.getCartsStream(vm.order.id.toString()),
            builder: (context, AsyncSnapshot<List<CartTableData>> snapshot) {
              int cashReceived = 0;
              if (snapshot.data != null) {
                cashReceived = _total;
                payable.updateValue(_total.toDouble());
              } else {
                payable.updateValue(0);
              }
              return Row(
                children: <Widget>[
                  FlatButton(
                      color: HexColor(FlipperColors.blue),
                      onPressed: () {
                        StoreProvider.of<AppState>(context).dispatch(
                          SavePayment(
                            note: "note",
                            cashReceived: cashReceived,
                          ),
                        );
                      },
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(85, 0, 0, 0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "Charge  ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                  ),
                                ),
                                Text(
                                  payable.text,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ))
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _getPayable(List<CartTableData> carts, context) async {
    final store = StoreProvider.of<AppState>(context);
    int total = 0;
    for (var i = 0; i < carts.length; i++) {
      final stock = await store.state.database.stockDao.getStockByVariantId(
          variantId: carts[i].variationId, branchId: store.state.branch.id);

      total += (stock.retailPrice.toInt() * carts[i].count).toInt();
    }
    _total = total;
  }

  void _getOrderCart() async {
    final orderId = StoreProvider.of<AppState>(context).state.order.id;
    List<CartTableData> carts = await StoreProvider.of<AppState>(context)
        .state
        .database
        .cartDao
        .getCarts(orderId.toString());

    _getPayable(carts, context);
  }
}
