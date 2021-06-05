import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper/stack.dart';
import 'package:flipper_models/order.dart';

class KeyPadService with ReactiveServiceMixin {
  final _key = ReactiveValue<String>("0.0");

  Stack stack = Stack<String>();

  final _count = ReactiveValue<int>(0);

  get count => _count.value;

  final _quantity = ReactiveValue<int>(1);

  get quantity => _quantity.value;

  String get key => _key.value;

  final _orders = ReactiveValue<List<OrderF>>([]);

  List<OrderF> get orders => _orders.value;

  final _countOrderItems = ReactiveValue<int>(0);

  int get countOrderItems => _countOrderItems.value;

  final _amountTotal = ReactiveValue<double>(0.0);

  double get amountTotal => _amountTotal.value;

  final _check = ReactiveValue<int>(0);

  int get check => _check.value;

  final _cashReceived = ReactiveValue<double>(0.0);

  get cashReceived => _cashReceived;

  void addKey(String key) {
    stack.push(key);
    _key.value = stack.list.join('');
  }

  setAmount({required double amount}) {
    _amountTotal.value = amount;
  }

  setCashReceived({required double amount}) {
    _cashReceived.value = amount;
  }

  void toggleCheckbox({required int variantId}) {
    _check.value = variantId;
  }

  setCount({required int count}) {
    print(count);
    _count.value = count;
  }

  Future<List<OrderF>> getOrders() async {
    List<OrderF> od = await ProxyService.api.orders();
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

  void increaseQty() {
    _quantity.value++;
  }

  void decreaseQty() {
    _quantity.value--;
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

  //increase quantity

  KeyPadService() {
    listenToReactiveValues([
      _key,
      _orders,
      _countOrderItems,
      _quantity,
      _amountTotal,
      _check,
      _cashReceived
    ]);
  }
}
