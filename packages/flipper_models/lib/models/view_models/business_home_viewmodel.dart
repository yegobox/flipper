library flipper_models;

// import './view_models/setting.dart';
import 'package:flipper_routing/routes.locator.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:flipper_models/models/models.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/keypad_service.dart';
import 'package:flipper_services/product_service.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/drive_service.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:flipper_services/language_service.dart';

// import './view_models/business.dart';
class BusinessHomeViewModel extends ReactiveViewModel {
  // Services
  // ThemeMode themeMode = ThemeMode.system;

  final settingService = locator<SettingsService>();
  final languageService = locator<LanguageService>();
  final bool _updateStarted = false;
  Setting? _setting;
  Setting? get setting => _setting;
  bool get updateStart => _updateStarted;
  String? defaultLanguage;

  Locale? klocale;

  Locale? get locale => klocale;

  String? getSetting() {
    klocale = Locale(ProxyService.box.read(key: 'defaultLanguage') ?? 'en');
    setLanguage(ProxyService.box.read(key: 'defaultLanguage') ?? 'en');
    return ProxyService.box.read(key: 'defaultLanguage');
  }

  void setLanguage(String lang) {
    defaultLanguage = null;
    klocale = Locale(lang);
    ProxyService.box.write(key: 'defaultLanguage', value: lang);
    defaultLanguage = lang;
    log.i(defaultLanguage);
    languageService.setLocale(lang: defaultLanguage!);
  }

  //change theme
  void onThemeModeChanged(ThemeMode mode) {
    settingService.setThemeMode(mode);
    notifyListeners();
  }

  //harmonize
  final log = getLogger('BusinessHomeViewModel');
  final KeyPadService keypad = locator<KeyPadService>();
  final ProductService productService = locator<ProductService>();
  final AppService _app = locator<AppService>();
  String get key => keypad.key;

  late String? longitude;
  late String? latitude;

  OrderFSync? get kOrder => keypad.order;
  List<OrderFSync> get tickets => keypad.tickets;

  int get countedOrderItems => keypad.count;

  double get amountTotal => keypad.amountTotal;

  int get checked => keypad.check;

  bool get groupValue => true;

  get quantity => keypad.quantity;

  StockSync? _currentItemStock;
  get currentItemStock => _currentItemStock;

  List<VariantSync> _variants = [];
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
        VariantSync? variation =
            await ProxyService.api.getCustomProductVariant();

        double amount = double.parse(ProxyService.keypad.key);

        await ProxyService.api.createOrder(
          customAmount: amount,
          variation: variation!,
          price: double.parse(ProxyService.keypad.key),
          //default on keypad
          quantity: 1,
        );
        OrderFSync? order =
            await ProxyService.keypad.getOrder(branchId: branchId);

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
    OrderFSync? od = await ProxyService.keypad.getOrder(branchId: branchId);
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
  Future<List<ProductSync>> products() async {
    int branchId = ProxyService.box.read(key: 'branchId');
    return await ProxyService.api.products(branchId: branchId);
  }

  List<BusinessSync> get businesses => _app.businesses;

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
    callback(keypad.quantity);
  }

  void setAmount({required double amount}) {
    ProxyService.keypad.setAmount(amount: amount);
  }

  void loadVariantStock({required int variantId}) async {
    int branchId = ProxyService.box.read(key: 'branchId');
    _currentItemStock = await ProxyService.api
        .getStock(branchId: branchId, variantId: variantId);
  }

  Future<List<VariantSync>> getVariants({required int productId}) async {
    int branchId = ProxyService.box.read(key: 'branchId');
    _variants = await ProxyService.api
        .variants(branchId: branchId, productId: productId);
    return _variants;
  }

  Future<VariantSync?> getVariant({required int variantId}) async {
    return await ProxyService.api.variant(variantId: variantId);
  }

  void toggleCheckbox({required int variantId}) {
    keypad.toggleCheckbox(variantId: variantId);
  }

  Future<bool> saveOrder(
      {required int variationId, required double amount}) async {
    int branchId = ProxyService.box.read(key: 'branchId');
    StockSync stock =
        await ProxyService.api.stockByVariantId(variantId: variationId);
    if (amountTotal != 0.0) {
      VariantSync? variation = await ProxyService.api.variant(
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
      List<OrderFSync> exist_orders =
          await ProxyService.api.orders(branchId: branchId);
      if (exist_orders.isNotEmpty) {
        /// if order exist then we need to update the orderItem that match with the item we want to update with new count
        /// if orderItem does not exist then we need to create a new orderItem
        for (OrderItemSync item in exist_orders[0].orderItems) {
          if (item.fvariantId == variationId) {
            Map data = {
              'count': item.count + quantity.toDouble(),
              'price': (item.count + quantity.toDouble()) *
                  (amountTotal / quantity.toDouble()),
              'fvariantId': variationId,
              'id': exist_orders[0].id,
              'name': name,
              'createdAt': item.createdAt,
              'updatedAt': item.updatedAt,
              'remainingStock': stock.currentStock.toInt() - quantity,
            };
            ProxyService.api.update(data: data, endPoint: 'order');
          }
        }

        /// if is a new item to be added to the list then it will be added to the list
        /// existOrderItem will return null which will go to adding item api.
        OrderItemSync? existOrderItem = ProxyService.api
            .getOrderItemByVariantId(
                variantId: variationId, orderId: exist_orders[0].id);
        // log.w(exist_orders.length);
        if (existOrderItem == null) {
          Map data = {
            'count': quantity.toDouble(),
            'price':
                (quantity.toDouble()) * (amountTotal / quantity.toDouble()),
            'fvariantId': variationId,
            'name': name,
            'forderId': exist_orders[0].id,
            'createdAt': DateTime.now().toString(),
            'updatedAt': DateTime.now().toString(),
            'remainingStock': stock.currentStock.toInt() - quantity,
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

      OrderFSync? order =
          await ProxyService.keypad.getOrder(branchId: branchId);

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

  void addNoteToSale({required String note, required Function callback}) async {
    if (kOrder == null) {
      return;
    }
    OrderFSync? order = await ProxyService.api.getOrderById(id: kOrder!.id);
    Map map = order.toJson();
    map['note'] = note;
    ProxyService.api.update(data: map, endPoint: 'order');
    callback(1);
  }

  ///save ticket, this method take any existing pending order
  ///change status to parked, this allow the cashier to take another order of different client
  ///and resume this when he feel like he wants to,
  ///the note on order is served as display, therefore an order can not be parked without a note on it.
  void saveTicket(Function callBack) async {
    //get the current order
    if (kOrder == null) return;
    OrderFSync? Korder = await ProxyService.api.getOrderById(id: kOrder!.id);
    Map map = Korder.toJson();
    map['status'] = parkedStatus;
    if (map['note'] == null || map['note'] == '') {
      callBack('error');
    } else {
      ProxyService.api.update(data: map, endPoint: 'order');
      //refresh order afterwards
      await currentOrder();
      callBack('saved');
    }
  }

  Future resumeOrder({required int ticketId}) async {
    OrderFSync? Korder = await ProxyService.api.getOrderById(id: ticketId);
    Map map = Korder.toJson();
    map['status'] = pendingStatus;
    await ProxyService.api.update(data: map, endPoint: 'order');
    await keypad.getTickets();
    await keypad.getOrder(branchId: ProxyService.box.read(key: 'branchId'));
    await currentOrder();
    await updatePayable();
  }

  /// the method return total amount of the order to be used in the payment
  /// @return num if there is discount applied to orderItem then it will return discount instead of price to be
  /// considered in the total amount payable
  // num? totalPayable = 0.0;
  // num? totalDiscount = 0.0;

  double get totalPayable => keypad.totalPayable;
  double get totalDiscount => keypad.totalDiscount;
  Future<num?> updatePayable() async {
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

    await keypad.getTickets();
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

  /// this method is used to restore database from backup
  /// it return [1] if the restore was successful
  /// it return [2] if the restore was not successful and pass it for callback
  /// the UI can notify the user based on the return value
  void restoreBackUp(Function callback) async {
    if (ProxyService.remoteConfig.isBackupAvailable()) {
      BusinessSync business = await ProxyService.api.getBusiness();
      final drive = GoogleDrive();
      if (business.backupFileId != null) {
        await drive.downloadGoogleDriveFile('data', business.backupFileId!);
        callback(1);
      } else {
        callback(2);
      }
    }
  }

  void backUpNow(Function callback) async {
    if (ProxyService.remoteConfig.isBackupAvailable()) {
      final drive = GoogleDrive();
      await drive.backUpNow();
      callback(1);
    }
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices =>
      [keypad, _app, productService, settingService, languageService];
}
