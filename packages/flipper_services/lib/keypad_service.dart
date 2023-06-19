import 'package:flipper_ui/helpers/stack.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/isar_models.dart';

class KeyPadService with ListenableServiceMixin {
  final _key = ReactiveValue<String>("0.00");
  Stack stack = Stack<String>();

  final _quantity = ReactiveValue<double>(1.0);

  get quantity => _quantity.value;

  String get key => _key.value;

  final _countOrderItems = ReactiveValue<int>(0);

  int get countOrderItems => _countOrderItems.value;

  final _amountTotal = ReactiveValue<double>(0.00);

  double get amountTotal => _amountTotal.value;

  final _check = ReactiveValue<int>(0);

  int get check => _check.value;

  final _cashReceived = ReactiveValue<double>(0.00);

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
    notifyListeners();
  }

  void toggleCheckbox({required int variantId}) {
    _check.value = variantId;
  }

  /// all the time we have one order being processed at the time.
  /// one order can have multiple order items.
  final _order = ReactiveValue<Order?>(null);

  Order? get order => _order.value;

  final _totalPayable = ReactiveValue<double>(0.00);
  double get totalPayable => _totalPayable.value;
  void setTotalPayable({required double amount}) {
    _totalPayable.value = amount;
  }

  final _totalDiscount = ReactiveValue<double>(0.00);
  double get totalDiscount => _totalDiscount.value;
  void setTotalDiscount({required double amount}) {
    _totalDiscount.value = amount;
  }

  void setOrder(Order? order) async {
    if (order != null) {
      _order.value = order;
    } else {
      _order.value = null;
    }
  }

  /// order can not be more than 1 lenght i.e at one instance
  /// we have one order but an order can have more than 1 orderitem(s)
  /// it is in this recard in application anywhere else it's okay to access orders[0]
  Future<Order?> getPendingOrder({required int branchId}) async {
    Order? order = await ProxyService.isar.pendingOrder(branchId: branchId);

    if (order != null) {
      List<OrderItem> items = await ProxyService.isar
          .orderItems(orderId: order.id!, doneWithOrder: false);
      _countOrderItems.value = items.length;
    }
    _order.value = order;
    return order;
  }

  /// this function update _orders.value the same as getOrders but this takes id of the order we want
  /// it is very important to not fonfuse these functions. later on.
  Future<Order?> getOrderById({required int id}) async {
    Order? od = await ProxyService.isar.getOrderById(id: id);
    List<OrderItem> orderItems =
        await ProxyService.isar.getOrderItemsByOrderId(orderId: od!.id!);
    _countOrderItems.value = orderItems.length;

    _order.value = od;
    return _order.value!;
  }

  void reset() {
    _key.value = '0.0';
    while (stack.isNotEmpty) {
      stack.pop();
    }
    notifyListeners();
  }

  void increaseQty({required bool custom, double? qty}) {
    if (custom) {
      _quantity.value = 0;
      _quantity.value = qty ?? 1.0;
    } else {
      _quantity.value++;
      notifyListeners();
    }
  }

  /// can not set -1 quantity
  void decreaseQty() {
    if (_quantity.value > 0) {
      _quantity.value--;
    }
    if (_quantity.value == 0) {
      _quantity.value = 1;
    }
    notifyListeners();
  }

  /// before I used to remove the last written digit
  /// but with new structure the clear or + button set the key back to 0.0
  /// therefore there is no reason to use pop strategy but I am keeping the code
  /// here for later reference.
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
      _order,
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
