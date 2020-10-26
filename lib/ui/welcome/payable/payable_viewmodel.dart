import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/locator.dart';
import 'package:flipper/model/order.dart';
import 'package:flipper/model/stock.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flipper/services/flipperNavigation_service.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:logger/logger.dart';
import 'package:redux/redux.dart';
import 'package:stacked/stacked.dart';
import 'package:couchbase_lite/couchbase_lite.dart';

class PayableViewModel extends BaseViewModel {
  final Logger log = Logging.getLogger('payable:)');
  final FlipperNavigationService _navigationService =
      locator<FlipperNavigationService>();
  final DatabaseService _databaseService = ProxyService.database;

  final List<Order> _order = <Order>[];
  List<Order> get data => _order;

  TextEditingController _note;
  TextEditingController get note {
    return _note;
  }

  MoneyMaskedTextController _payable;
  MoneyMaskedTextController get payable {
    return _payable;
  }

  int _total;
  int get total {
    return _total;
  }

  void initFields() {
    _payable = MoneyMaskedTextController(
        leftSymbol: '\RWF ', decimalSeparator: '.', thousandSeparator: ',');
    _note = TextEditingController();
    if (_note.text == null) {
      _note.text = 'Add a note'; //start by init with add note if empty
    } else if (_note.text.length > 4) {
      _note.text.substring(0, 4);
    }
  }

  // ignore: always_declare_return_types
  nvaigate() {
    _navigationService.navigateTo(
      Routing.completeSaleScreen,
      arguments: CompleteSaleScreenArguments(
        cashReceived: _total, //should keep in later
      ),
    );
  }

  void getOrder() {
    setBusy(true);

    //demo of listening on users table on every entry.
    _databaseService
        .observer(
            equator: AppTables.order,
            property: 'table') //order is what we refer to as cart
        .stream
        .listen((ResultSet event) {
      final List<Map<String, dynamic>> carts = event.map((Result result) {
        return result.toMap();
      }).toList();

      for (Map<String, dynamic> cart in carts) {
        // ignore: always_specify_types
        cart.forEach((String key, value) async {
          log.i(value);
          // final  Document stock = await _databaseService.getById(id:Cart.fromMap(value).variationId);

          final List<Map<String, dynamic>> sto = await _databaseService.filter(
            equator: Order.fromMap(value).variationId,
            property: 'variationId',
            and: true,
            andProperty: 'table',
            andEquator: AppTables.stock,
          );

          _total += (Stock.fromMap(sto[0]['main']).retailPrice.toInt() *
                  Order.fromMap(value).quantity)
              .toInt();

          _order.add(Order.fromMap(value));
        });
      }
      notifyListeners();

      setBusy(false);
    });
  }

  // ignore: always_declare_return_types
  onPlusButtonClicked({BuildContext context}) async {
    final Store<AppState> store = StoreProvider.of<AppState>(context);

    final List<Map<String, dynamic>> variants = await _databaseService.filter(
        property: 'productId', equator: store.state.tmpItem.id);
    // assume this is a custom product get it and update stock with the right amount from keypad
  }

  void onClearPad() {
    // StoreProvider.of<AppState>(context).dispatch(CleanKeyPad());
  }

  void normalKeypad() {
    
    //StoreProvider.of<AppState>(context).dispatch(
    //   KayPadAction(
    //     keyPad: KeyPad(
    //       (KeyPadBuilder k) => k
    //         ..amount = vm.keypad == null
    //             ? int.parse(buttonKeyName)

    //             : int.parse(vm.keypad.amount.toString() + buttonKeyName)
    //         ..note = 'note',
    //     ),
    //   ),
    // );
  }
}
