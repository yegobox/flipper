import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/locator.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/services/flipperNavigation_service.dart';
import 'package:flipper/util/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redux/redux.dart';

class PayableWidget extends StatefulWidget {
  @override
  _PayableWidgetState createState() => _PayableWidgetState();
}

class _PayableWidgetState extends State<PayableWidget> {
  int _total = 0;
  final FlipperNavigationService _navigationService = locator<FlipperNavigationService>();

  @override
  Widget build(BuildContext context) {
    final MoneyMaskedTextController payable =  MoneyMaskedTextController(
        leftSymbol: '\RWF ', decimalSeparator: '.', thousandSeparator: ',');
    payable.updateValue(0);

    _getOrderCart();

    return StoreConnector<AppState, CommonViewModel>(
      distinct: true,
      converter: CommonViewModel.fromStore,
      builder: (BuildContext context, CommonViewModel vm) {
        return Container(
          height: 66,
          color: AppColors.darkBlue,
          // FIXME(richard): use couchbaselite here too
          // ignore: always_specify_types
          child: StreamBuilder(
            //always take the current order Id which should always be an a draft order.
            stream: vm.database.orderDetailDao
            // vm.order.id.toString()
                .getCartsStream(null),
            builder: (BuildContext context, AsyncSnapshot<List<OrderDetailTableData>> cart) {
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
                      color: AppColors.darkBlue,
                      onPressed: () {
                        _navigationService.navigateTo(
                          Routing.completeSaleScreen,
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
                                      color: Theme.of(context).accentColor,
                                      fontSize: Theme.of(context).textTheme
                                          .bodyText1.fontSize),
                                ),
                                Text(
                                  payable.text,
                                  style: GoogleFonts.lato(
                                      fontStyle: FontStyle.normal,
                                      color: Theme.of(context).accentColor,
                                      fontSize: Theme.of(context).textTheme
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
    final Store<AppState> store = StoreProvider.of<AppState>(context);
    int total = 0;
    for (int i = 0; i < carts.length; i++) {
      final StockTableData stock = await store.state.database.stockDao.getStockByVariantId(
          variantId: carts[i].variationId, branchId: store.state.branch.id);

      total += (stock.retailPrice.toInt() * carts[i].quantity).toInt();
    }
    _total = total;
  }

  void _getOrderCart() async {
    // FIXME(richard): fix order so it wont be null
    // final orderId = StoreProvider.of<AppState>(context).state.order.id;
    
    List<OrderDetailTableData> carts = await StoreProvider.of<AppState>(context)
        .state
        .database
        .orderDetailDao
        // orderId.toString()
        .getCart(null);

    _getPayable(carts, context);
  }
}
