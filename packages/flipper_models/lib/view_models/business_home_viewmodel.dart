library flipper_models;

import 'package:flipper_routing/routes.locator.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:flipper_models/business.dart';
import 'package:flipper_models/order.dart';
import 'package:flipper_models/order_item.dart';
import 'package:flipper_models/product.dart';
import 'package:flipper_models/stock.dart';
import 'package:flipper_models/variants.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/keypad_service.dart';
import 'package:flipper_services/product_service.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/drive_service.dart';

class BusinessHomeViewModel extends ReactiveViewModel {
  final log = getLogger('BusinessHomeViewModel');
  final KeyPadService keypad = locator<KeyPadService>();
  final ProductService productService = locator<ProductService>();
  final AppService _app = locator<AppService>();
  String get key => keypad.key;

  late String? longitude;
  late String? latitude;

  OrderF? get kOrder => keypad.order;
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
    int branchId = ProxyService.box.read(key: 'branchId');
    if (key == 'C') {
      ProxyService.keypad.pop();
    } else if (key == '+') {
      if (double.parse(ProxyService.keypad.key) != 0.0) {
        Variant variation = await ProxyService.api.getCustomProductVariant();

        double amount = double.parse(ProxyService.keypad.key);

        await ProxyService.api.createOrder(
          customAmount: amount,
          variation: variation,
          price: double.parse(ProxyService.keypad.key),
          //default on keypad
          quantity: 1,
        );
        OrderF? order = await ProxyService.keypad.getOrder(branchId: branchId);

        keypad.setCount(count: order != null ? order.orderItems.length : 0);

        updatePayable();
        ProxyService.keypad.reset();
      }
    } else {
      ProxyService.keypad.addKey(key);
    }
  }

  void getTickets() async {
    await ProxyService.keypad.getTickets();
  }

  Future<void> currentOrder() async {
    int branchId = ProxyService.box.read(key: 'branchId');
    OrderF? od = await ProxyService.keypad.getOrder(branchId: branchId);
    keypad.setCount(count: 0);
    if (od != null) {
      keypad.setOrder(od);
      if (od.orderItems.isNotEmpty) {
        keypad.setCount(count: od.orderItems.length);
      }
    }
    notifyListeners();
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
    int branchId = ProxyService.box.read(key: 'branchId');
    return await ProxyService.api.products(branchId: branchId);
  }

  List<Business> get businesses => _app.businesses;

  void pop() {
    ProxyService.keypad.pop();
  }

  void reset() {
    ProxyService.keypad.reset();
  }

  /// We take _variantsStocks[0] because we know
  void decreaseQty(Function callback) {
    ProxyService.keypad.decreaseQty();
    if (_currentItemStock != null) {
      keypad.setAmount(amount: _currentItemStock!.retailPrice * quantity);
    }
    callback(quantity);
  }

  void handleCustomQtySetBeforeSelectingVariation() {
    if (_currentItemStock != null) {
      keypad.setAmount(amount: _currentItemStock!.retailPrice * quantity);
    }
  }

  void customQtyIncrease(int quantity) {
    ProxyService.keypad.customQtyIncrease(qty: quantity);
    if (_currentItemStock != null) {
      keypad.setAmount(amount: _currentItemStock!.retailPrice * quantity);
    }
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
  }

  Future<List<Variant>> getVariants({required int productId}) async {
    int branchId = ProxyService.box.read(key: 'branchId');
    _variants = await ProxyService.api
        .variants(branchId: branchId, productId: productId);
    return _variants;
  }

  Future<Variant?> getVariant({required int variantId}) async {
    return await ProxyService.api.variant(variantId: variantId);
  }

  void toggleCheckbox({required int variantId}) {
    keypad.toggleCheckbox(variantId: variantId);
  }

  Future<bool> saveOrder(
      {required int variationId, required double amount}) async {
    int branchId = ProxyService.box.read(key: 'branchId');
    if (amountTotal != 0.0) {
      Variant? variation = await ProxyService.api.variant(
        variantId: variationId,
      );
      log.i(variation!.name);
      String name = '';
      if (variation.name == 'Regular') {
        name = variation.productName + '(Regular)';
      } else {
        name = variation.productName + '(${variation.name})';
      }

      /// if variation given given exist in the orderItems then we update the order with new count
      List<OrderF> exist_orders =
          await ProxyService.api.orders(branchId: branchId);
      if (exist_orders.isNotEmpty) {
        /// if order exist then we need to update the orderItem that match with the item we want to update with new count
        /// if orderItem does not exist then we need to create a new orderItem
        for (OrderItem item in exist_orders[0].orderItems) {
          if (item.fvariantId == variationId) {
            log.i(item.count + quantity.toDouble());
            log.i(amountTotal);
            Map data = {
              'count': item.count + quantity.toDouble(),
              'price': (item.count + quantity.toDouble()) *
                  (amountTotal / quantity.toDouble()),
              'fvariantId': variationId,
              'id': exist_orders[0].id,
              'name': name,
            };
            ProxyService.api.update(data: data, endPoint: 'order');
          }
        }

        /// if is a new item to be added to the list then it will be added to the list
        /// existOrderItem will return null which will go to adding item api.
        OrderItem? existOrderItem =
            ProxyService.api.getOrderItemByVariantId(variantId: variationId);
        // log.i(existOrderItem);
        if (existOrderItem == null) {
          Map data = {
            'count': quantity.toDouble(),
            'price':
                (quantity.toDouble()) * (amountTotal / quantity.toDouble()),
            'fvariantId': variationId,
            'name': name,
            'forderId': exist_orders[0].id,
          };
          ProxyService.api.addOrderItem(order: exist_orders[0], data: data);
        }
      } else {
        await ProxyService.api.createOrder(
          customAmount: amountTotal,
          variation: variation,
          price: amountTotal,
          useProductName: false,
          quantity: quantity.toDouble(),
        );
      }

      OrderF? order = await ProxyService.keypad.getOrder(branchId: branchId);

      keypad.setCount(count: order != null ? order.orderItems.length : 0);

      updatePayable();

      return true;
    } else {
      updatePayable();

      return false;
    }
  }

  Future collectSPENNPayment(
      {required String phoneNumber, required double payableAmount}) async {
    if (kOrder == null && amountTotal != 0.0) {
      //should show a global snack bar
      return;
    }
    log.i(payableAmount);
    await ProxyService.api
        .spennPayment(amount: payableAmount, phoneNumber: phoneNumber);
    await ProxyService.api
        .collectCashPayment(cashReceived: payableAmount, order: kOrder!);
  }

  void collectCashPayment({required double payableAmount}) {
    if (kOrder == null && amountTotal != 0.0) {
      //should show a global snack bar
      return;
    }
    log.i(payableAmount);
    ProxyService.api
        .collectCashPayment(cashReceived: payableAmount, order: kOrder!);
    //reset current order back to 0
    keypad.setCount(count: 0);
  }

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
    OrderF? order = await ProxyService.api.getOrderById(id: kOrder!.id);
    Map map = order.toJson();
    map['note'] = note;
    ProxyService.api.update(data: map, endPoint: 'order');
  }

  ///save ticket, this method take any existing pending order
  ///change status to parked, this allow the cashier to take another order of different client
  ///and resume this when he feel like he wants to,
  ///the note on order is served as display, therefore an order can not be parked without a note on it.
  void saveTicket(Function callBack) async {
    //get the current order
    if (kOrder == null) return;
    OrderF? Korder = await ProxyService.api.getOrderById(id: kOrder!.id);
    Map map = Korder.toJson();
    map['status'] = parkedStatus;
    if (map['note'] == null || map['note'] == '') {
      callBack('error');
    }
    ProxyService.api.update(data: map, endPoint: 'order');

    //refresh order afterwards
    await currentOrder();
    callBack('saved');
  }

  Future resumeOrder({required int ticketId}) async {
    OrderF? Korder = await ProxyService.api.getOrderById(id: ticketId);
    Map map = Korder.toJson();
    map['status'] = pendingStatus;
    await ProxyService.api.update(data: map, endPoint: 'order');
    await keypad.getTickets();
    await keypad.getOrder(branchId: ProxyService.box.read(key: 'branchId'));
    await currentOrder();
  }

  /// the method return total amount of the order to be used in the payment
  /// @return num if there is discount applied to orderItem then it will return discount instead of price to be
  /// considered in the total amount payable
  // num? totalPayable = 0.0;
  // num? totalDiscount = 0.0;

  double get totalPayable => keypad.totalPayable;
  double get totalDiscount => keypad.totalDiscount;
  num? updatePayable() {
    keypad.setTotalPayable(amount: 0.0);
    keypad.setTotalDiscount(amount: 0.0);
    if (keypad.order == null) return 0.0;
    num? totalPayable =
        keypad.order!.orderItems.fold(0, (a, b) => a! + (b.price));

    num? totalDiscount = keypad.order!.orderItems
        .fold(0, (a, b) => a! + (b.discount == null ? 0 : b.discount!.toInt()));
    keypad.setTotalPayable(
        amount: totalDiscount != 0.0
            ? (totalPayable! - totalDiscount!.toDouble())
            : totalPayable!.toDouble());
    keypad.setTotalDiscount(amount: totalDiscount!.toDouble());

    notifyListeners();
    return totalPayable;
  }

  /// if deleting OrderItem leaves order with no OrderItem
  /// this function also delete the order
  Future<bool> deleteOrderItem({required int id}) async {
    await ProxyService.api.delete(id: id, endPoint: 'orderItem');

    await currentOrder();

    updatePayable();

    /// if there is no orderItem left in the order then navigate back
    if (keypad.order!.orderItems.isEmpty) {
      ProxyService.nav.back();
    }

    return true;
  }

  void downloadBackup() {}

  void uploadBackup() async {
    Business business = await ProxyService.api.getBusiness();
    if (ProxyService.remoteConfig.isBackupAvailable()) {
      final drive = GoogleDrive();
      if (business.backupFileId != null) {
        drive.downloadGoogleDriveFile('data', business.backupFileId!);
      } else {
        drive.authenticate();
      }
    }
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices =>
      [keypad, _app, productService];
}
