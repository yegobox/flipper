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

  void addKey(String key) {
    stack.push(key);
    _key.value = stack.list.join('');
  }

  void getOrders() async {
    final result = await ProxyService.api.orders();
    print(result);
    _orders.value = result;
  }

  void reset() {
    _key.value = '0.0';
  }

  void pop() {
    if (stack.isNotEmpty && stack.length > 1) {
      stack.pop();
      _key.value = stack.list.join('');
    } else {
      stack.pop();
      _key.value = '0.0';
    }
  }

  KeyPadService() {
    listenToReactiveValues([_key, _orders]);
  }
}
