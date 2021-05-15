library flipper_models;

import 'package:flipper/routes.locator.dart';
import 'package:flipper_models/models/business.dart';
import 'package:flipper_models/models/order.dart';
import 'package:flipper_models/models/product.dart';
import 'package:flipper_models/models/variation.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/keypad_service.dart';
import 'package:flipper_services/proxy.dart';

class BusinessHomeViewModel extends ReactiveViewModel {
  final KeyPadService _keypad = locator<KeyPadService>();
  String get key => _keypad.key;
  // keypad service
  get keyPad => null;

  get keypadValue => null;

  List<Order> get orders => _keypad.orders;

  int get countedOrderItems => _keypad.count;

  void addKey(String key) async {
    if (key == 'C') {
      ProxyService.keypad.pop();
    } else if (key == '+') {
      if (double.parse(ProxyService.keypad.key) != 0.0) {
        Variation variation = await ProxyService.api.getCustomProductVariant();
        // Stock stock =
        //     await ProxyService.api.stockByVariantId(variantId: variation.id);
        double amount = double.parse(ProxyService.keypad.key);

        await ProxyService.api.createOrder(
          customAmount: amount,
          variation: variation,
          price: double.parse(ProxyService.keypad.key),
          //default on keypad
          quantity: 1,
        );
        List<Order> orders = await ProxyService.keypad.getOrders();
        if (orders.isNotEmpty) {
          _keypad.setCount(count: orders[0].orderItems.length);
        }
        ProxyService.keypad.reset();
      }
    } else {
      ProxyService.keypad.addKey(key);
    }
  }

  void getOrders() async {
    List<Order> od = await ProxyService.keypad.getOrders();

    if (od[0].orderItems.isNotEmpty) {
      _keypad.setCount(count: orders[0].orderItems.length);
    } else {
      _keypad.setCount(count: 0);
      ProxyService.nav.back(); //if no item then navigate back home!
    }
  }

  // products methods
  Future<List<Product>> products() async {
    return await ProxyService.api.products();
  }

  List<Business> _businesses = [];
  List<Business> get businesses => _businesses;
  void loadBusinesses() async {
    List<Business>? response = await ProxyService.api.businesses();
    _businesses = response!;
    notifyListeners();
  }

  void pop() {
    ProxyService.keypad.pop();
  }

  void reset() {
    ProxyService.keypad.reset();
  }

  Future<bool> deleteOrderItem({required String id}) async {
    Order order = orders[0];
    if (order.orderItems.isNotEmpty) {
      order.orderItems.removeWhere((element) => element.id == id);
      ProxyService.api.update(data: order.toJson(), endPoint: 'order');
    }
    getOrders();
    return false;
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_keypad];
}
