library flipper_models;

import 'package:flipper/routes.locator.dart';
import 'package:flipper_models/models/business.dart';
import 'package:flipper_models/models/order.dart';
import 'package:flipper_models/models/product.dart';
import 'package:flipper_models/models/variant_stock.dart';
import 'package:flipper_models/models/variation.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/keypad_service.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/proxy.dart';

class BusinessHomeViewModel extends ReactiveViewModel {
  final KeyPadService keypad = locator<KeyPadService>();
  final AppService _app = locator<AppService>();
  String get key => keypad.key;

  List<Order> get orders => keypad.orders;

  int get countedOrderItems => keypad.count;

  double get amountTotal => keypad.amountTotal;

  String get checked => keypad.check;

  bool get groupValue => true;

  get quantity => keypad.quantity;

  List<VariantStock> _variantsStocks = [];
  get variantsStocks => _variantsStocks;

  void addKey(String key) async {
    if (key == 'C') {
      ProxyService.keypad.pop();
    } else if (key == '+') {
      if (double.parse(ProxyService.keypad.key) != 0.0) {
        Variation variation = await ProxyService.api.getCustomProductVariant();

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
          keypad.setCount(count: orders[0].orderItems.length);
        }
        ProxyService.keypad.reset();
      }
    } else {
      ProxyService.keypad.addKey(key);
    }
  }

  void getOrders() async {
    List<Order> od = await ProxyService.keypad.getOrders();

    if (od.isNotEmpty && od[0].orderItems.isNotEmpty) {
      keypad.setCount(count: orders[0].orderItems.length);
    } else {
      keypad.setCount(count: 0);
    }
  }

  ///list products availabe for sell
  Future<List<Product>> products() async {
    return await ProxyService.api.products();
  }

  List<Business> get businesses => _app.businesses;

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

  /// We take _variantsStocks[0] because we know
  void decreaseQty() {
    ProxyService.keypad.decreaseQty();
    if (_variantsStocks.isNotEmpty) {
      keypad.setAmount(amount: _variantsStocks[0].retailPrice * quantity);
    }
  }

  void increaseQty() {
    ProxyService.keypad.increaseQty();
    if (_variantsStocks.isNotEmpty) {
      keypad.setAmount(amount: _variantsStocks[0].retailPrice * quantity);
    }
  }

  void setAmount({required double amount}) {
    ProxyService.keypad.setAmount(amount: amount);
  }

  void loadVariantStock({required String variantId}) async {
    String branchId = ProxyService.box.read(key: 'branchId');
    _variantsStocks = await ProxyService.api
        .variantStock(branchId: branchId, variantId: variantId);
    notifyListeners();
  }

  Future<String> getVariant({required String productId}) async {
    String branchId = ProxyService.box.read(key: 'branchId');
    List<Variation> variants = await ProxyService.api
        .variants(branchId: branchId, productId: productId);
    return variants[0].id;
  }

  void toggleCheckbox({required String variantId}) {
    keypad.toggleCheckbox(variantId: variantId);
  }

  Future saveOrder(
      {required String variationId, required double amount}) async {
    Variation variation = await ProxyService.api.variant(
      variantId: variationId,
    );
    await ProxyService.api.createOrder(
      customAmount: amountTotal,
      variation: variation,
      price: amountTotal,
      quantity: quantity.toDouble(),
    );
    List<Order> orders = await ProxyService.keypad.getOrders();
    if (orders.isNotEmpty) {
      keypad.setCount(count: orders[0].orderItems.length);
    }
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [keypad, _app];
}
