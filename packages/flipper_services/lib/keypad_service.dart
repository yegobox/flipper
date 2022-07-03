import 'package:flipper_rw/stack.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/isar_models.dart';

class KeyPadService with ReactiveServiceMixin {
  final _key = ReactiveValue<String>("0.0");
  final log = getLogger('KeyPadService');
  Stack stack = Stack<String>();

  final _itemsOnSale = ReactiveValue<int>(0);

  get itemsOnSale => _itemsOnSale.value;

  setItemsOnSale({required int count}) {
    _itemsOnSale.value = count;
  }

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

  final _tickets = ReactiveValue<List<Order>>([]);

  List<Order> get tickets => _tickets.value;
  Future<List<Order>> getTickets() async {
    List<Order> ticket = await ProxyService.isarApi.tickets();
    //NOTE: we assume index[0] as pending order can not be more than one at the moment
    if (ticket.isNotEmpty) {
      _countOrderItems.value = ticket.first.orderItems.length;
    }
    _tickets.value = ticket;
    notifyListeners();
    return _tickets.value;
  }

  /// all the time we have one order being processed at the time.
  /// one order can have multiple order items.
  final _order = ReactiveValue<Order?>(null);

  Order? get order => _order.value;

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
  Future<Order?> getOrder({required int branchId}) async {
    Order? order = await ProxyService.isarApi.pendingOrder(branchId: branchId);
    log.d('getOrder: $order');
    if (order != null) {
      List<OrderItem> items =
          await ProxyService.isarApi.orderItems(orderId: order.id);
      _countOrderItems.value = items.length;
    }
    _order.value = order;
    return order;
  }

  /// this function update _orders.value the same as getOrders but this takes id of the order we want
  /// it is very important to not fonfuse these functions. later on.
  Future<Order?> getOrderById({required int id}) async {
    Order? od = await ProxyService.isarApi.getOrderById(id: id);

    _countOrderItems.value = od!.orderItems.length;

    _order.value = od;
    return _order.value!;
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
  }

  void increaseQty() {
    _quantity.value++;
    notifyListeners();
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
      _order,
      _countOrderItems,
      _quantity,
      _amountTotal,
      _check,
      _itemsOnSale,
      _cashReceived,
      _totalPayable,
      _totalDiscount
    ]);
  }
}
