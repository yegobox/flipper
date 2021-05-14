library flipper_models;

import 'package:flipper/routes.locator.dart';
import 'package:flipper_models/models/business.dart';
import 'package:flipper_models/models/order.dart';
import 'package:flipper_models/models/product.dart';
import 'package:flipper_models/models/product_mock.dart';
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

  void addKey(String key) async {
    if (key == 'C') {
      ProxyService.keypad.pop();
    } else if (key == '+') {
      Variation variation = await ProxyService.api.getCustomProductVariant();

      Stock stock =
          await ProxyService.api.stockByVariantId(variantId: variation.id);

      double amount = double.parse(ProxyService.keypad.key);

      ProxyService.api.createOrder(
          customAmount: amount, variation: variation, stockId: stock.id);
      ProxyService.keypad.getOrders();
      ProxyService.keypad.reset();
    } else {
      ProxyService.keypad.addKey(key);
    }
  }

  void getOrders() {
    ProxyService.keypad.getOrders();
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
