library flipper_services;

import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper_models/order.dart';
import 'package:flipper_models/variation.dart';
import 'package:flipper_services/constant.dart';
import 'package:flipper_services/database_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/logger.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/shared_state_service.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:uuid/uuid.dart';

enum ITEM { ITEMNAME, ITEMPRICE }

class KeyPadService with ReactiveServiceMixin {
  final _state = locator<SharedStateService>();
  final RxValue<Order> order = RxValue<Order>(initial: null);
  Order get currentSales => order.value;

  final Logger log = Logging.getLogger('O2:)');
  final RxValue<double> _totalAmount = RxValue<double>(initial: 0.0);
  double get totalAmount => _totalAmount.value;

  final List<Map> currentSale = [];
  List<Map> get currentSalesItem => currentSale;

  final RxValue<double> cash = RxValue<double>(initial: 0.0);
  double get amount => cash.value;

  // double total = 0.0;

  final DatabaseService _db = ProxyService.database;

  double totalPayable = 0.0;

  /// create new order,this method assume a cashier is still in progress of taking order
  /// then the amount passed assume that we are dealing with custom item
  /// if the takeNewOrder is not passed it will keep updating the current active and draft order
  void sellCustomAmount(
      {double customAmount = 0.0, bool takeNewOrder = false}) {
    // TODO: this was useful when a user did not have a custom item
    // _db.createCustomItem(
    //     branchId: _state.branch.id,
    //     userId: _state.user.id,
    //     businessId: _state.business.id);
    final Document variation = _db.getCustomProductVariant();
    print(Variation.fromMap(variation.jsonProperties).name);
    final String stockId = _db.getStockIdGivenProductId(
        variantId: Variation.fromMap(variation.jsonProperties).id);

    pendingOrder(
        customAmount: customAmount,
        stockId: stockId,
        variation: Variation.fromMap(variation.jsonProperties));
    order.listen((order) {
      if (order != null && order.active && order.draft && !takeNewOrder) {
        final Document orderDocument = _db.getById(id: order.id);
        orderDocument.properties['amount'] = customAmount;
        _db.update(document: orderDocument);
        _totalAmount.value = customAmount;
        notifyListeners();
        return;
      }
    });
  }

  Order createOrder(
      {double customAmount,
      Variation variation,
      String stockId,
      String orderType = 'custom'}) {
    final id4 = Uuid().v1().substring(0, 10);
    _db.insert(id: id4, data: {
      'reference': id4.substring(0, 4),
      'orderNUmber': id4.substring(0, 5),
      'status': 'pending',
      'variantId': variation.id,
      'variantName': variation.name,
      'orderType': orderType,
      'active':
          true, //used to check if order is parked becomes parked when false.
      'draft': true,
      'channels': [_state.user.id.toString()],
      'subTotal': customAmount,
      'table': AppTables.order,
      'amount': customAmount,
      'customerChangeDue': 0.0,
      'id': id4,
      'stockId': stockId,
      'branchId': _state.branch.id,
      'createdAt': DateTime.now().toIso8601String(),
    });
    order.value = null;

    final Document doc = _db.getById(id: id4);
    order.value = Order.fromMap(doc.jsonProperties);
    print(id4);
    ProxyService.sharedPref.setCustomOrderId(orderId: id4);
    return order.value;
  }

  /// the pending order will return the existing order if draft and active are still true otherwise
  /// wise it will create a new active & draft order.
  /// Also it is very important to treat order as an item added to the
  void pendingOrder(
      {double customAmount, String stockId, Variation variation}) {
    // ProxyService.sharedPref.removeKey(key: 'custom_orderId');
    if (ProxyService.sharedPref.getCustomOrderId() == 'null' ||
        ProxyService.sharedPref.getCustomOrderId() == null) {
      createOrder(
          stockId: stockId,
          variation: variation,
          customAmount: customAmount,
          orderType: 'custom');
      notifyListeners();
    } else {
      order.value = null;

      final String id = ProxyService.sharedPref.getCustomOrderId();

      final Document doc = _db.getById(id: id);

      order.value = Order.fromMap(doc.jsonProperties);
      notifyListeners();
    }
  }

  void updateStock({String stockId, double quantity}) {
    final Document stock = ProxyService.database.getById(id: stockId);
    stock.properties['currentStock'] =
        stock.properties['currentStock'].asDouble - quantity;
    ProxyService.database.update(document: stock);
  }

  /// the cleaning the keypad was meant like when the app start we should start fresh
  /// Note that this was to simulate the square app but due to it's complexity
  /// It is abandoned atleast for now, in our app for now when it restart it will load the
  /// current pending order so the user if he/she is no longer intrested in order he will
  /// need to click on C button to clean the keypad for now will not invoke the function on app start
  /// TODO: should use stack algorithm to remove one element by one as a user click on C button
  /// but for now it wipe everything.
  void cleanKeypad() {
    ProxyService.sharedState.clear.listen((e) {
      if (e != null) {
        ProxyService.sharedPref.removeKey(key: 'custom_orderId');
        if (ProxyService.database.db != null) {
          final q = Query(ProxyService.database.db,
              'SELECT  id  WHERE table=\$T AND status=\$S');
          q.parameters = {'T': AppTables.order, 'S': 'pending'};
          final results = q.execute();
          if (results.isNotEmpty) {
            for (Map id in results) {
              ProxyService.database.delete(id: id['id']);
            }
          }
          totalPayable = 0.0;
          notifyListeners();
        }
      }
    });
  }
}
