library flipper_services;

import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper_models/order.dart';
import 'package:flipper_models/variation.dart';
import 'package:flipper_models/view_models/Queries.dart';
import 'package:flipper_services/constant.dart';
import 'package:flipper_services/database_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/logger.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/shared_state_service.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart';
import 'package:uuid/uuid.dart';

class KeyPadService with ReactiveServiceMixin {
  KeyPadService() {
    listenToReactiveValues([orders, note]);
  }
  final _state = locator<SharedStateService>();
  final RxValue<Order> order = RxValue<Order>();

  // String note;
  final RxValue<String> note = RxValue<String>();

  final RxValue<List<Order>> orders = RxValue<List<Order>>(initial: []);

  Order get currentSales => order.value;

  final Logger log = Logging.getLogger('KeyPad:)');

  // final RxValue<double> setPayable = RxValue<double>(initial: 0.0);

  // double get payable => setPayable.value;

  final RxValue<double> setCashReceived = RxValue<double>(initial: 0.0);

  double get cashReceived => setCashReceived.value;

  final DatabaseService _db = ProxyService.database;

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
    // print(customAmount);
    // return;
    final Document variation = _db.getCustomProductVariant();

    final String stockId = _db.getStockIdGivenVariantId(
        variantId: Variation.fromMap(variation.map).id);

    pendingOrder(
        customAmount: customAmount,
        stockId: stockId,
        variation: Variation.fromMap(variation.map));
    getOrders();
  }

  /// create an order given a variation, a caller should
  /// specify if he/she wants to use a product's name in orderSummary or not.
  Order createOrder(
      {double customAmount,
      Variation variation,
      String stockId,
      bool useProductName = false,
      String orderType = 'custom',
      double quantity = 1}) {
    final id4 = Uuid().v1();
    final Document _doc = _db.insert(id: id4, data: {
      'reference': id4.substring(0, 4),
      'quantity': quantity,
      'orderNUmber': id4.substring(0, 5),
      'status': 'pending',
      'variantId': variation.id,
      'variantName': useProductName ? variation.productName : variation.name,
      'orderType': orderType,
      //used to check if order is parked becomes parked when false.
      'active': true,
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

    final Document doc = _db.getById(id: _doc.ID);
    order.value = Order.fromMap(doc.map);

    ProxyService.sharedPref.setCustomOrderId(orderId: id4);
    return order.value;
  }

  void updateOrder({@required Order order, @required double customAmount}) {
    final Document orderDocument = _db.getById(id: order.id);
    orderDocument.properties['amount'] = customAmount;
    _db.update(document: orderDocument);
    notifyListeners();
  }

  /// the pending order will return the existing order if draft and active are still true otherwise
  /// wise it will create a new active & draft order.
  /// Also it is very important to treat order as an item added to the
  /// this check if the current order's id from local storage is not completed if then remove it from local storage
  void pendingOrder(
      {double customAmount, String stockId, Variation variation}) async {
    // await ProxyService.sharedPref.removeKey(key: 'custom_orderId');
    await checkOrderAuthenticity();
    if (ProxyService.sharedPref.getCustomOrderId() == 'null' ||
        ProxyService.sharedPref.getCustomOrderId() == null) {
      final Order order = createOrder(
          stockId: stockId,
          variation: variation,
          useProductName: true,
          customAmount: customAmount,
          orderType: 'custom');
      updateOrder(customAmount: customAmount, order: order);
      notifyListeners();
    } else {
      final String id = ProxyService.sharedPref.getCustomOrderId();
      final Document doc = _db.getById(id: id);
      if (doc == null) {
        await ProxyService.sharedPref.removeKey(key: 'custom_orderId');
        final Order order = createOrder(
            stockId: stockId,
            variation: variation,
            useProductName: true,
            customAmount: customAmount,
            orderType: 'custom');
        updateOrder(customAmount: customAmount, order: order);
        notifyListeners();
        return;
      }
      order.value = Order.fromMap(doc.map);

      updateOrder(customAmount: customAmount, order: Order.fromMap(doc.map));
    }
  }

  Future<void> checkOrderAuthenticity() async {
    // await ProxyService.sharedPref.removeKey(key: 'custom_orderId');
    final String id = ProxyService.sharedPref.getCustomOrderId();
    final Document doc = _db.getById(id: id);
    if (doc != null && Order.fromMap(doc.map).status == 'completed') {
      await ProxyService.sharedPref.removeKey(key: 'custom_orderId');
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
  /// It is abandoned at least for now, in our app for now when it restart it will load the
  /// current pending order so the user if he/she is no longer interested in order he will
  /// need to click on C button to clean the keypad for now will not invoke the function on app start
  /// TODO: should use stack algorithm to remove one element by one as a user click on C button
  /// but for now it wipe everything.
  void cleanKeypad() {
    ProxyService.sharedState.clear.listen((e) {
      if (ProxyService.database.db != null) {
        final List<Order> _orders = ProxyService.api.currentOrders();
        for (Order order in _orders) {
          ProxyService.sharedPref.removeKey(key: 'custom_orderId');
          try {
            ProxyService.database.delete(id: order.id);
          } catch (e) {
            log.d(e);
          }
          ProxyService.sharedPref.removeKey(key: 'custom_orderId');
        }
      }
      getOrders();
    });
  }

  void getOrders() {
    orders.value.clear();
    if (ProxyService.database.db == null) return;
    // final List<Order> o = ProxyService.api.currentOrders();
    // ignore: avoid_function_literals_in_foreach_calls
    final q = Query(ProxyService.database.db, Queries.Q_3);
    q.parameters = {'T': AppTables.order, 'S': 'pending'};
    q.addChangeListener((results) {
      final t = results.allResults; //to avoid sgate! error
      if (t.isNotEmpty) {
        orders.value.clear();
        for (Map map in t) {
          orders.value.add(Order.fromMap(map));
        }
        notifyListeners();
      }
    });
  }

  int _tab = -1;

  int get tab {
    return _tab;
  }

  void switchTab(int tab) {
    _tab = tab;
  }

  void initTab() {
    _tab = 0;
  }
}
