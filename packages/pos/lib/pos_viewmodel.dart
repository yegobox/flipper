import 'package:flipper_models/order.dart';
import 'package:flipper_services/constant.dart';
import 'package:flipper_services/keypad_service.dart';
import 'package:flipper_services/locator.dart';
// import 'package:flipper_services/logger.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';
import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';

class PosViewModel extends ReactiveViewModel {
  var digits = <String>['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  String keypadValue = '0.0';
  var operators = <String>['+', '-', '*', '/'];
  String result = '';
  final List<Order> _currentSale = [];
  List<Order> get currentSale => _currentSale;
  int _tab = 0;

  int get tab {
    return _tab;
  }

  int _items;
  int get items {
    return _items;
  }

  void switchTab(int tab) {
    _tab = tab;
    notifyListeners();
  }

  void initTab() {
    _tab = 0;
    notifyListeners();
  }

  final keyPad = locator<KeyPadService>();

  /// keep track of the order and count them should update local currentSale on
  /// payable widget so we know if we show save or tickets button
  /// we show tickets currentSale array is empty otherwise if we have dirty order i.e
  /// active and draft them we count them and show them as savable items i.e item to show when user click Current Sale.
  void countItemOnCurrentOrder() {
    final q = Query(
        ProxyService.database.db, 'SELECT  *  WHERE table=\$T AND status=\$S');

    q.parameters = {'T': AppTables.order, 'S': 'pending'};

    q.addChangeListener((List results) {
      _currentSale.clear();
      if (results.isNotEmpty) {
        for (Map map in results) {
          map.forEach((key, value) {
            // ProxyService.database.delete(id: value['id']);
            keyPad.totalPayable = Order.fromMap(value).amount;
            _currentSale.add(Order.fromMap(value));
          });
        }
        notifyListeners();
      } else {
        _currentSale.clear();
        notifyListeners();
      }
    });
  }

  void addKey(String key) {
    var _expr = keypadValue;
    var _result = '';
    if (result.isNotEmpty) {
      _expr = '';
      _result = '';
    }
    if (_expr == '0.0') {
      _expr = '';
    }

    if (operators.contains(key) && key != '+') {
      // Handle as an operator
      if (_expr.isNotEmpty && operators.contains(_expr[_expr.length - 1])) {
        _expr = _expr.substring(0, _expr.length - 1);
      }
      _expr += key;
    } else if (digits.contains(key) && key != '+') {
      _expr += key;
      keyPad.sellCustomAmount(
          customAmount: double.parse(_expr), takeNewOrder: false);
      notifyListeners();
    } else if (key == 'C') {
      while (_expr.isNotEmpty) {
        _expr = _expr.substring(0, _expr.length - 1);
      }
      ProxyService.sharedState.setClear(c: true);
    } else if (key == '+') {
      changeOrderStatus();
      _expr = '0.0';
      keypadValue = '';
    }
    keypadValue = _expr;
    result = _result;
    notifyListeners();
  }

  bool isOperator(String op) {
    return operators.contains(op);
  }

  bool isDigit(String op) {
    return digits.contains(op);
  }

  /// mark the order from draft  to false
  /// this will enable a user to add a new order to the keypad.
  /// This will also remove custom_orderId from local storage so it will create a new order
  /// for another time. NOTE: marking an order draft=false will leave an order still on currentSale
  void changeOrderStatus() {
    if (ProxyService.sharedPref.getCustomOrderId() != 'null') {
      final Document doc = ProxyService.database
          .getById(id: ProxyService.sharedPref.getCustomOrderId());

      doc.properties['draft'] = false;
      ProxyService.database.update(document: doc);
      ProxyService.sharedPref.removeKey(key: 'custom_orderId');
    }
  }

  /// this will take a user to save items to page aka tickets_view page
  /// if a user choose to save this pending item on current sale then a new ticket will be created with a name
  /// or can be added to existing tickets.
  void saveTicket() {
    //start the save ticket flow
    ProxyService.inAppNav.navigateTo(path: 'ticketsView');
  }

  /// view the existing tickets and resume the one you are intrested in
  /// then on resume all related order shall have active=true and draft =true
  /// with a status of pending that way it will be visible on current sale count.
  void viewTickets() {
    ProxyService.inAppNav.navigateTo(path: 'ticketsView');
  }

  void goSale() {
    if (keypadValue != '0.0' && keypadValue.isNotEmpty) {
      //TODO: show animation like square when amount ==0.0
      ProxyService.inAppNav.navigateTo(path: 'completeSaleView');
    }
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [keyPad];
}
