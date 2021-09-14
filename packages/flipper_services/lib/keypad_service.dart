import 'package:flipper/stack.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/order.dart';

class KeyPadService with ReactiveServiceMixin {
  final _key = ReactiveValue<String>("0.0");
  final log = getLogger('KeyPadService');
  Stack stack = Stack<String>();

  final _count = ReactiveValue<int>(0);

  get count => _count.value;

  final _quantity = ReactiveValue<int>(1);

  get quantity => _quantity.value;

  String get key => _key.value;

  final _countOrderItems = ReactiveValue<int>(0);

  int get countOrderItems => _countOrderItems.value;

  final _amountTotal = ReactiveValue<double>(0.0);

  double get amountTotal => _amountTotal.value;

  final _check = ReactiveValue<int>(0);

  int get check => _check.value;

  final _cashReceived = ReactiveValue<double>(0.0);

  get cashReceived => _cashReceived.value;

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
    _count.value = count;
  }

  final _tickets = ReactiveValue<List<OrderF>>([]);

  List<OrderF> get tickets => _tickets.value;
  Future<List<OrderF>> getTickets() async {
    List<OrderF> od = await ProxyService.api.tickets();

    //NOTE: we assume index[0] as pending order can not be more than one at the moment
    if (od.isNotEmpty) {
      _countOrderItems.value = od[0].orderItems.length;
    }
    _tickets.value = od;
    log.i(_tickets.value.length);
    notifyListeners();
    return _tickets.value;
  }

  final _orders = ReactiveValue<List<OrderF>>([]);

  List<OrderF> get orders => _orders.value;

  final _totalPayable = ReactiveValue<double>(0.0);
  double get totalPayable => _totalPayable.value;
  void setTotalPayable({required double amount}) {
    _totalPayable.value = amount;
  }

  final _totalDiscount = ReactiveValue<double>(0.0);
  double get totalDiscount => _totalDiscount.value;
  void setTotalDiscount({required double amount}) {
    _totalDiscount.value = amount;
  }

  void setOrders(List<OrderF> orders) {
    _orders.value = orders;
  }

  /// order can not be more than 1 lenght i.e at one instance
  /// we have one order but an order can have more than 1 orderitem(s)
  /// it is in this recard in application anywhere else it's okay to access orders[0]
  Future<List<OrderF>> getOrders({required int branchId}) async {
    List<OrderF> od = await ProxyService.api.orders(branchId: branchId);
    //
    //NOTE: we assume index[0] as pending order can not be more than one at the moment
    if (od.isNotEmpty) {
      _countOrderItems.value = od[0].orderItems.length;
    }
    _orders.value = od;
    notifyListeners();
    return _orders.value;
  }

  /// this function update _orders.value the same as getOrders but this takes id of the order we want
  /// it is very important to not fonfuse these functions. later on.
  Future<List<OrderF>> getOrderById({required int id}) async {
    List<OrderF> od = await ProxyService.api.getOrderById(id: id);
    //
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

  void customQtyIncrease({int? qty}) {
    _quantity.value = 0;
    _quantity.value = qty!;
    log.i(quantity);
    // notifyListeners();
  }

  void increaseQty() {
    _quantity.value++;
    log.i(quantity);
    // notifyListeners();
  }

  /// can not set -1 quantity
  void decreaseQty() {
    if (_quantity.value > 0) {
      _quantity.value--;
    }
    if (_quantity.value == 0) {
      _quantity.value = 1;
    }
    log.i(quantity);
    notifyListeners();
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
      _cashReceived,
      _totalPayable,
      _totalDiscount
    ]);
  }
}
