library flipper_models;

import 'package:flipper/routes.locator.dart';
import 'package:flipper/routes.logger.dart';
import 'package:flipper_models/business.dart';
import 'package:flipper_models/order.dart';
import 'package:flipper_models/order_item.dart';
import 'package:flipper_models/product.dart';
import 'package:flipper_models/stock.dart';
import 'package:flipper_models/variants.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/keypad_service.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/proxy.dart';

class BusinessHomeViewModel extends ReactiveViewModel {
  final log = getLogger('BusinessHomeViewModel');
  final KeyPadService keypad = locator<KeyPadService>();
  final AppService _app = locator<AppService>();
  String get key => keypad.key;

  late String? longitude;
  late String? latitude;

  List<OrderF> get orders => keypad.orders;
  List<OrderF> get tickets => keypad.tickets;

  int get countedOrderItems => keypad.count;

  double get amountTotal => keypad.amountTotal;

  int get checked => keypad.check;

  bool get groupValue => true;

  get quantity => keypad.quantity;

  Stock? _currentItemStock = null;
  get currentItemStock => _currentItemStock;

  List<Variant> _variants = [];
  get variants => _variants;

  int _tab = 0;
  int get tab => _tab;
  String searchKey = '';
  String get searchCustomerkey => searchKey;
  void setSearch(String key) {
    searchKey = key;
    notifyListeners();
  }

  setTab({required int tab}) {
    _tab = tab;
  }

  void addKey(String key) async {
    if (key == 'C') {
      ProxyService.keypad.pop();
    } else if (key == '+') {
      if (double.parse(ProxyService.keypad.key) != 0.0) {
        //   await ProxyService.api.createProduct(product: customProductMock);
        Variant variation = await ProxyService.api.getCustomProductVariant();

        double amount = double.parse(ProxyService.keypad.key);

        await ProxyService.api.createOrder(
          customAmount: amount,
          variation: variation,
          price: double.parse(ProxyService.keypad.key),
          //default on keypad
          quantity: 1,
        );
        List<OrderF> orders = await ProxyService.keypad.getOrders();
        if (orders.isNotEmpty) {
          keypad.setCount(count: orders[0].orderItems.length);
        }
        ProxyService.keypad.reset();
      }
    } else {
      ProxyService.keypad.addKey(key);
    }
  }

  void getTickets() async {
    await ProxyService.keypad.getTickets();
  }

  void getOrders() async {
    List<OrderF> od = await ProxyService.keypad.getOrders();

    if (od.isNotEmpty && od[0].orderItems.isNotEmpty) {
      keypad.setCount(count: orders[0].orderItems.length);
    } else {
      keypad.setCount(count: 0);
    }
  }

  /// the function is useful on completing a sale since we need to look for this past order
  /// to add customer etc... we can not use getOrders as it was a general function for all completed functions
  /// but this will be generic for this given order saved in a box it is very important to reach to collect cash screen
  /// for the initation of writing this orderId in a box for later use!.
  Future<void> getOrderById() async {
    int? id = ProxyService.box.read(key: 'orderId');
    log.i(id);
    await ProxyService.keypad.getOrderById(id: id!);
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

  /// if deleting OrderItem leaves order with no OrderItem
  /// this function also delete the order
  Future<bool> deleteOrderItem({required int id}) async {
    OrderF order = orders[0];
    if (order.orderItems.isNotEmpty) {
      OrderItem? orderItem = await ProxyService.api.getOrderItem(id: id);
      ProxyService.api.delete(id: orderItem!.id, endPoint: 'orderItem');

      ProxyService.api.update(data: order.toJson(), endPoint: 'order');
    }
    getOrders();
    log.i(orders[0].orderItems[0].name);
    // since when crating an order we need to init orderItem with one default
    //regular the orderItems will never be empty so we check if length is 1 instead
    if (orders[0].orderItems.length == 1) {
      //delete the order too!
      ProxyService.api.delete(id: orders[0].id, endPoint: 'order');
    }
    getOrders();
    return false;
  }

  /// We take _variantsStocks[0] because we know
  void decreaseQty(Function callback) {
    ProxyService.keypad.decreaseQty();
    if (_currentItemStock != null) {
      keypad.setAmount(amount: _currentItemStock!.retailPrice * quantity);
    }
    callback(quantity);
  }

  void increaseQty(Function callback) {
    ProxyService.keypad.increaseQty();
    if (_currentItemStock != null) {
      keypad.setAmount(amount: _currentItemStock!.retailPrice * quantity);
    }
    callback(quantity);
  }

  void setAmount({required double amount}) {
    ProxyService.keypad.setAmount(amount: amount);
  }

  void loadVariantStock({required int variantId}) async {
    int branchId = ProxyService.box.read(key: 'branchId');
    _currentItemStock = await ProxyService.api
        .getStock(branchId: branchId, variantId: variantId);

    notifyListeners();
  }

  Future<List<Variant>> getVariants({required int productId}) async {
    int branchId = ProxyService.box.read(key: 'branchId');
    _variants = await ProxyService.api
        .variants(branchId: branchId, productId: productId);
    notifyListeners();
    return _variants;
  }

  Future<Variant?> getVariant({required int variantId}) async {
    return await ProxyService.api.variant(variantId: variantId);
  }

  void toggleCheckbox({required int variantId}) {
    keypad.toggleCheckbox(variantId: variantId);
  }

  Future saveOrder({required int variationId, required double amount}) async {
    Variant? variation = await ProxyService.api.variant(
      variantId: variationId,
    );
    await ProxyService.api.createOrder(
      customAmount: amountTotal,
      variation: variation!,
      price: amountTotal,
      quantity: quantity.toDouble(),
    );
    List<OrderF> orders = await ProxyService.keypad.getOrders();
    if (orders.isNotEmpty) {
      keypad.setCount(count: orders[0].orderItems.length);
    }
  }

  Future collectSPENNPayment(
      {required String phoneNumber, required double payableAmount}) async {
    if (orders.isEmpty && amountTotal != 0.0) {
      //should show a global snack bar
      return;
    }
    log.i(payableAmount);
    await ProxyService.api
        .spennPayment(amount: payableAmount, phoneNumber: phoneNumber);
    await ProxyService.api
        .collectCashPayment(cashReceived: payableAmount, order: orders[0]);
  }

  void collectCashPayment({required double payableAmount}) {
    if (orders.isEmpty && amountTotal != 0.0) {
      //should show a global snack bar
      return;
    }
    log.i(payableAmount);
    ProxyService.api
        .collectCashPayment(cashReceived: payableAmount, order: orders[0]);
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [keypad, _app];

  void registerLocation() async {
    final permission = await ProxyService.location.doWeHaveLocationPermission();
    if (permission) {
      final Map<String, String> location =
          await ProxyService.location.getLocation();
      longitude = location['longitude'];
      latitude = location['latitude'];

      notifyListeners();
    } else {
      final Map<String, String> location =
          await ProxyService.location.getLocation();
      longitude = location['longitude'];
      latitude = location['latitude'];
      notifyListeners();
    }
  }

  void addCustomer(
      {required String email,
      required String phone,
      required String name,
      required int orderId}) {
    log.i({'email': email, 'phone': phone, 'name': name});
    ProxyService.api.addCustomer(
        customer: {'email': email, 'phone': phone, 'name': name},
        orderId: orderId);
  }

  Future<void> assignToSale(
      {required int customerId, required int orderId}) async {
    ProxyService.api
        .assingOrderToCustomer(customerId: customerId, orderId: orderId);
  }

  /// as of when one sale is complete trying to sell second product
  /// the previous Qty and totalAmount where still visible in header which confuses
  /// this is to reset the value for a new sale to come!
  void clearPreviousSaleCounts() {
    keypad.setAmount(amount: 0);
    keypad.customQtyIncrease(qty: 1);
  }

  void addNoteToSale({required String note}) async {
    log.i(orders[0].id);
    List<OrderF?> order = await ProxyService.api.getOrderById(id: orders[0].id);
    Map map = order[0]!.toJson();
    map['note'] = note;
    ProxyService.api.update(data: map, endPoint: 'order');
  }

  ///save ticket, this method take any existing pending order
  ///change status to parked, this allow the cashier to take another order of different client
  ///and resume this when he feel like he wants to,
  ///the note on order is served as display, therefore an order can not be parked without a note on it.
  void saveTicket(Function error) async {
    //get the current order
    if (orders.isEmpty) return;
    List<OrderF?> Korders =
        await ProxyService.api.getOrderById(id: orders[0].id);
    Map map = Korders[0]!.toJson();
    map['status'] = parkedStatus;
    if (map['note'] == null || map['note'] == '') {
      return error('error');
    }
    ProxyService.api.update(data: map, endPoint: 'order');
    //refresh order afterwards
    getOrders();
  }

  Future resumeOrder({required int ticketId}) async {
    List<OrderF?> Korders = await ProxyService.api.getOrderById(id: ticketId);
    Map map = Korders[0]!.toJson();
    map['status'] = pendingStatus;
    await ProxyService.api.update(data: map, endPoint: 'order');
    getOrders();
  }
}
