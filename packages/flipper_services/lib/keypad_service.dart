import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper/stack.dart';
import 'package:flipper_models/models/order.dart';

class KeyPadService with ReactiveServiceMixin {
  final _key = ReactiveValue<String>("0.0");

  Stack stack = Stack<String>();

  String get key => _key.value;

  final _orders = ReactiveValue<List<Order>>([]);
  List<Order> get orders => _orders.value;

  final _countOrderItems = ReactiveValue<int>(0);
  int get countOrderItems => _countOrderItems.value;

  void addKey(String key) {
    stack.push(key);
    _key.value = stack.list.join('');
  }

  Future<List<Order>> getOrders() async {
    List<Order> od = await ProxyService.api.orders();
    //NOTE: we assume index[0] as pending order can not be more than one at the moment
    if (od.isNotEmpty) {
      _countOrderItems.value = od[0].orderItems.length;
    }

    _orders.value = od;
    return _orders.value;
  }

  void reset() {
    _key.value = '0.0';
    while (stack.isNotEmpty) {
      stack.pop();
    }
  }

  void pop() {
    if (stack.isNotEmpty && stack.length > 1) {
      stack.pop();
      _key.value = stack.list.join('');
    } else if (stack.isNotEmpty) {
      stack.pop();
      _key.value = '0.0';
    }
  }

  KeyPadService() {
    listenToReactiveValues([_key, _orders, _countOrderItems]);
  }
}
