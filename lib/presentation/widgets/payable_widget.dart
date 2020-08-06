import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/theme.dart';
import 'package:flipper/util/HexColor.dart';
import 'package:flipper/util/flitter_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';

class PayableWidget extends StatefulWidget {
  @override
  _PayableWidgetState createState() => _PayableWidgetState();
}

class _PayableWidgetState extends State<PayableWidget> {
  int _total = 0;

  @override
  Widget build(BuildContext context) {
    var payable = new MoneyMaskedTextController(
        leftSymbol: '\RWF ', decimalSeparator: '.', thousandSeparator: ',');
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
            //always take the current order Id which should always be an a draft order.
            stream: vm.database.orderDetailDao
                .getCartsStream(vm.order.id.toString()),
            builder: (context, AsyncSnapshot<List<OrderDetailTableData>> cart) {
              int cashReceived = 0;
              if (cart.data != null) {
                cashReceived = _total;
                payable.updateValue(_total.toDouble());
              } else {
                payable.updateValue(0);
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                      color: HexColor(FlipperColors.blue),
                      onPressed: () {
                        Router.navigator.pushNamed(
                          Router.compleSaleScreen,
                          arguments: CompleteSaleScreenArguments(
                            cashReceived: cashReceived,
                          ),
                        );
                      },
                      child: Row(
                        children: <Widget>[
                          Center(
                            child: Row(
                              children: <Widget>[
                                Text(
                                  'Charge  ',
                                  style: GoogleFonts.lato(
                                      fontStyle: FontStyle.normal,
                                      color: AppTheme.payableTheme.accentColor,
                                      fontSize: AppTheme.payableTheme.textTheme
                                          .bodyText1.fontSize),
                                ),
                                Text(
                                  payable.text,
                                  style: GoogleFonts.lato(
                                      fontStyle: FontStyle.normal,
                                      color: AppTheme.payableTheme.accentColor,
                                      fontSize: AppTheme.payableTheme.textTheme
                                          .bodyText1.fontSize),
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

  void _getPayable(List<OrderDetailTableData> carts, context) async {
    final store = StoreProvider.of<AppState>(context);
    int total = 0;
    for (var i = 0; i < carts.length; i++) {
      final stock = await store.state.database.stockDao.getStockByVariantId(
          variantId: carts[i].variationId, branchId: store.state.branch.id);

      total += (stock.retailPrice.toInt() * carts[i].quantity).toInt();
    }
    _total = total;
  }

  void _getOrderCart() async {
    final orderId = StoreProvider.of<AppState>(context).state.order.id;
    List<OrderDetailTableData> carts = await StoreProvider.of<AppState>(context)
        .state
        .database
        .orderDetailDao
        .getCart(orderId.toString());

    _getPayable(carts, context);
  }
}
