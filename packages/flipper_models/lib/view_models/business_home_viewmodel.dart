library flipper_models;

import 'package:flipper/routes.locator.dart';
import 'package:flipper_models/models/business.dart';
import 'package:flipper_models/models/order.dart';
import 'package:flipper_models/models/product.dart';
import 'package:flipper_models/models/stock.dart';
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
  int _countOrderItems = 0;
  int get countedOrderItems => _countOrderItems;

  void addKey(String key) async {
    if (key == 'C') {
      ProxyService.keypad.pop();
    } else if (key == '+') {
      // print(double.parse(ProxyService.keypad.key));
      if (double.parse(ProxyService.keypad.key) != 0.0) {
        Variation variation = await ProxyService.api.getCustomProductVariant();

        Stock stock =
            await ProxyService.api.stockByVariantId(variantId: variation.id);

        double amount = double.parse(ProxyService.keypad.key);

        await ProxyService.api.createOrder(
          customAmount: amount,
          variation: variation,
          price: stock.retailPrice,
          quantity: 1, //default on keypad
        );
        List<Order> orders = await ProxyService.keypad.getOrders();
        if (orders.isNotEmpty) {
          _countOrderItems = orders[0].orderItems.length;
        }
        ProxyService.keypad.reset();
      }
    } else {
      ProxyService.keypad.addKey(key);
    }
  }

  void getOrders() async {
    List<Order> od = await ProxyService.keypad.getOrders();

    if (od.isNotEmpty) {
      _countOrderItems = od[0].orderItems.length;
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

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_keypad];
}
