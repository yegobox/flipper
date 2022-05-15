library flipper_models;

import 'package:flipper_models/isar/receipt_signature.dart';
import 'package:flipper_routing/routes.locator.dart';
import 'package:flipper_routing/routes.logger.dart';
// import 'package:flipper_models/isar_models.dart';
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
import 'package:go_router/go_router.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:receipt/print.dart';
import 'package:qr_flutter/qr_flutter.dart';

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

  Order? get kOrder => keypad.order;

  double get amountTotal => keypad.amountTotal;

  int get checked => keypad.check;

  bool get groupValue => true;

  get quantity => keypad.quantity;

  Stock? _currentItemStock;
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
        Variant? variation = await ProxyService.isarApi.getCustomVariant();

        double amount = double.parse(ProxyService.keypad.key);

        await saveOrder(
            amount: amount, variationId: variation!.id, customItem: true);

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
    keypad.setItemsOnSale(count: 0);
    keypad.setTotalPayable(amount: 0.0);

    ProxyService.isarApi.pendingOrderStream().listen((order) async {
      if (order != null && order.status == pendingStatus) {
        keypad.setOrder(order);
        await order.orderItems.load();
        if (order.orderItems.isNotEmpty) {
          keypad.setItemsOnSale(count: order.orderItems.length);
        }
        keypad.setTotalPayable(amount: order.subTotal);
      } else {
        keypad.setOrder(null);
        keypad.setItemsOnSale(count: 0);
        keypad.setTotalPayable(amount: 0.0);
      }
      notifyListeners();
    });
    // in case there is nothhing to listen to and we need to refresh itemOnSale
    Order? order = await ProxyService.keypad
        .getOrder(branchId: ProxyService.box.getBranchId()!);
    keypad.setOrder(order);
    if (order != null) {
      await order.orderItems.load();
      keypad.setItemsOnSale(count: order.orderItems.length);
    } else {
      keypad.setItemsOnSale(count: 0);
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
    int branchId = ProxyService.box.read(key: 'branchId');
    return await ProxyService.isarApi.productsFuture(branchId: branchId);
  }

  Business get businesses => _app.business;

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
      keypad.setAmount(amount: _currentItemStock!.retailPrice! * quantity);
    }
    callback(quantity);
  }

  void handleCustomQtySetBeforeSelectingVariation() {
    if (_currentItemStock != null) {
      keypad.setAmount(amount: _currentItemStock!.retailPrice! * quantity);
    }
  }

  /// setAmount is the amount shown on top of product when increasing the quantity
  void customQtyIncrease(int quantity) {
    ProxyService.keypad.customQtyIncrease(qty: quantity);
    if (_currentItemStock != null) {
      keypad.setAmount(amount: _currentItemStock!.retailPrice! * quantity);
    }
  }

  /// setAmount is the amount shown on top of product when increasing the quantity

  void increaseQty(Function callback) {
    ProxyService.keypad.increaseQty();
    if (_currentItemStock != null) {
      keypad.setAmount(amount: _currentItemStock!.retailPrice! * quantity);
    }
    callback(keypad.quantity);
  }

  /// setAmount is the amount shown on top of product when increasing the quantity
  void setAmount({required double amount}) {
    ProxyService.keypad.setAmount(amount: amount);
  }

  void loadVariantStock({required int variantId}) async {
    int branchId = ProxyService.box.read(key: 'branchId');
    _currentItemStock = await ProxyService.isarApi
        .getStock(branchId: branchId, variantId: variantId);
  }

  Future<List<Variant>> getVariants({required int productId}) async {
    int branchId = ProxyService.box.getBranchId()!;
    _variants = await ProxyService.isarApi
        .variants(branchId: branchId, productId: productId);
    notifyListeners();
    return _variants;
  }

  Future<Variant?> getVariant({required int variantId}) async {
    return await ProxyService.isarApi.variant(variantId: variantId);
  }

  void toggleCheckbox({required int variantId}) {
    keypad.toggleCheckbox(variantId: variantId);
  }

  Future<bool> saveOrder({
    required int variationId,
    required double amount,
    required bool customItem,
  }) async {
    Variant? variation =
        await ProxyService.isarApi.variant(variantId: variationId);
    Stock? stock =
        await ProxyService.isarApi.stockByVariantId(variantId: variation!.id);

    String name = '';

    if (variation.name == 'Regular') {
      if (variation.productName != 'Custom Amount') {
        name = variation.productName + '(Regular)';
      } else {
        name = variation.productName;
      }
    } else {
      if (variation.productName != 'Custom Amount') {
        name = variation.productName + '(${variation.name})';
      } else {
        name = variation.productName;
      }
    }

    /// if variation  given it exist in the orderItems of currentPending order then we update the order with new count
    Order? pendingOrder = await ProxyService.isarApi.manageOrder();

    OrderItem? existOrderItem = await ProxyService.isarApi
        .getOrderItemByVariantId(
            variantId: variationId, orderId: pendingOrder.id);

    /// if is a new item to be added to the list then it will be added to the list
    /// existOrderItem will return null which will go to adding item api.
    await addOrderItems(
      variationId: variationId,
      pendingOrder: pendingOrder,
      name: name,
      variation: variation,
      stock: stock,
      amount: amount,
      isCustom: customItem,
      item: existOrderItem,
    );

    currentOrder();

    return true;
  }

  /// adding item to current order,
  /// it is important to note that custom item is not incremented
  /// when added and there is existing custom item in the list
  /// because we don't know if this is not something different you are selling at this point.
  Future<void> addOrderItems(
      {required int variationId,
      required Order? pendingOrder,
      required String name,
      required Variant variation,
      Stock? stock,
      required double amount,
      required bool isCustom,
      OrderItem? item}) async {
    /// just on custom item being sold we never update the orderItems
    /// we keep adding as we are not sure if it is the same item being sold or not.
    /// !isCustom as if it is custom we keep adding.
    ///now we will be updating the orderItem
    if (item != null && !isCustom) {
      item.qty = item.qty + quantity.toDouble();
      item.price = item.price + amount;
      pendingOrder!.subTotal = pendingOrder.subTotal + (amount);
      ProxyService.isarApi.update(data: pendingOrder);
      ProxyService.isarApi.updateOrderItem(order: pendingOrder, item: item);
      // return as have done update and we don't want to proceed.
      return;
    }
    if (pendingOrder != null) {
      OrderItem newItem = OrderItem()
        ..qty = isCustom ? 1 : quantity.toDouble()
        ..price = (quantity.toDouble()) * (amount / quantity.toDouble())
        ..variantId = variationId
        ..name = name
        ..discount = 0.0
        ..reported = false
        ..orderId = pendingOrder.id
        ..createdAt = DateTime.now().toString()
        ..updatedAt = DateTime.now().toString()

        /// RRA fields dutira muri variants (rent from variant model)
        ..dcRt = 0.0
        ..dcAmt = 0.0
        ..taxblAmt = pendingOrder.subTotal
        ..taxAmt =
            double.parse((variation.retailPrice * 18 / 118).toStringAsFixed(2))
        ..totAmt = variation.retailPrice
        ..itemSeq = variation.itemSeq
        ..isrccCd = variation.isrccCd
        ..isrccNm = variation.isrccNm
        ..isrcRt = variation.isrcRt
        ..isrcAmt = variation.isrcAmt
        ..taxTyCd = variation.taxTyCd
        ..bcd = variation.bcd
        ..itemClsCd = variation.itemClsCd
        ..itemTyCd = variation.itemTyCd
        ..itemStdNm = variation.itemStdNm
        ..orgnNatCd = variation.orgnNatCd
        ..pkg = variation.pkg
        ..itemCd = variation.itemCd
        ..pkgUnitCd = variation.pkgUnitCd
        ..qtyUnitCd = variation.qtyUnitCd
        ..itemNm = variation.itemNm
        ..prc = variation.prc
        ..splyAmt = variation.splyAmt
        ..tin = variation.tin
        ..bhfId = variation.bhfId
        ..dftPrc = variation.dftPrc
        ..addInfo = variation.addInfo
        ..isrcAplcbYn = variation.isrcAplcbYn
        ..useYn = variation.useYn
        ..regrId = variation.regrId
        ..regrNm = variation.regrNm
        ..modrId = variation.modrId
        ..modrNm = variation.modrNm
        // end of fields twakuye muri variants
        ..remainingStock = stock!.currentStock - quantity;
      pendingOrder.subTotal = pendingOrder.subTotal + amount;
      ProxyService.isarApi.update(data: pendingOrder);

      ProxyService.isarApi.addOrderItem(order: pendingOrder, item: newItem);
    }
  }

  Future collectSPENNPayment(
      {required String phoneNumber, required double cashReceived}) async {
    if (kOrder == null && amountTotal != 0.0) {
      //should show a global snack bar
      return;
    }
    log.i(cashReceived);
    await ProxyService.isarApi
        .spennPayment(amount: cashReceived, phoneNumber: phoneNumber);
    await ProxyService.isarApi
        .collectCashPayment(cashReceived: cashReceived, order: kOrder!);
  }

  void collectCashPayment({required double cashReceived}) {
    if (kOrder == null && amountTotal != 0.0) {
      //should show a global snack bar
      return;
    }
    ProxyService.isarApi
        .collectCashPayment(cashReceived: cashReceived, order: kOrder!);
    //reset current order back to 0

    keypad.setItemsOnSale(count: 0);
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
    ProxyService.isarApi.addCustomer(
        customer: {'email': email, 'phone': phone, 'name': name},
        orderId: orderId);
  }

  Future<void> assignToSale(
      {required int customerId, required int orderId}) async {
    ProxyService.isarApi
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
    Order? order = await ProxyService.isarApi.getOrderById(id: kOrder!.id);
    // Map map = order!;
    order!.note = note;
    ProxyService.isarApi.update(data: order);
    callback(1);
  }

  ///save ticket, this method take any existing pending order
  ///change status to parked, this allow the cashier to take another order of different client
  ///and resume this when he feel like he wants to,
  ///the note on order is served as display, therefore an order can not be parked without a note on it.
  void saveTicket(Function callBack) async {
    //get the current order
    if (kOrder == null) return;
    Order? _order = await ProxyService.isarApi.getOrderById(id: kOrder!.id);
    // Map map = _order.toJson();
    _order!.status = parkedStatus;
    if (_order.note == null || _order.note == '') {
      callBack('error');
    } else {
      ProxyService.isarApi.update(data: _order);
      //refresh order afterwards
      await currentOrder();
      callBack('saved');
    }
  }

  Future resumeOrder({required int ticketId}) async {
    Order? _order = await ProxyService.isarApi.getOrderById(id: ticketId);

    _order!.status = pendingStatus;
    await ProxyService.isarApi.update(data: _order);
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
    await keypad.order!.orderItems.load();

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
  Future<bool> deleteOrderItem(
      {required int id, required BuildContext context}) async {
    await ProxyService.isarApi.delete(id: id, endPoint: 'orderItem');

    await currentOrder();

    updatePayable();

    /// if there is no orderItem left in the order then navigate back
    if (keypad.order!.orderItems.isEmpty) {
      GoRouter.of(context).pop();
    }

    return true;
  }

  /// this method is used to restore database from backup
  /// it return [1] if the restore was successful
  /// it return [2] if the restore was not successful and pass it for callback
  /// the UI can notify the user based on the return value
  void restoreBackUp(Function callback) async {
    if (ProxyService.remoteConfig.isBackupAvailable()) {
      Business? business = await ProxyService.isarApi.getBusiness();
      final drive = GoogleDrive();
      if (business!.backupFileId != null) {
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

  List<OrderItem> orderItems = [];

  void loadReport() async {
    int branchId = ProxyService.box.getBranchId()!;
    List<Order> completedOrders =
        await ProxyService.isarApi.completedOrders(branchId: branchId);
    for (Order completedOrder in completedOrders) {
      orderItems.addAll(completedOrder.orderItems);
    }
    notifyListeners();
  }

  void printReceipt(
      {required List<OrderItem> items,
      required Business business,
      required Order oorder}) async {
    // get receipt from isar related to this order
    // get refreshed order with cash received
    Order? order = await ProxyService.isarApi.getOrderById(id: oorder.id);
    Receipt? receipt =
        await ProxyService.isarApi.getReceipt(orderId: order!.id);

    Print print = Print();
    print.feed(items);
    print.print(
      grandTotal: order.subTotal,
      currencySymbol: "RW",
      totalAEx: 0,
      totalB18: (order.subTotal * 18 / 118).toStringAsFixed(2),
      totalB: order.subTotal,
      totalTax: (order.subTotal * 18 / 118).toStringAsFixed(2),
      cash: order.subTotal,
      received: order.cashReceived,
      payMode: "Cash",
      bank: "-",
      mrc: receipt!.mrcNo,
      internalData: receipt.intrlData,
      // https://github.com/theyakka/qr.flutter/issues/4
      receiptQrCode: QrImageView(
        data: '000',
        version: QrVersions.auto,
        size: 200.0,
      ),
      receiptSignature: receipt.rcptSign,
      cashierName: business.name!,
      sdcId: receipt.sdcId,
      sdcReceiptNum: receipt.rcptNo.toString(),
      invoiceNum: receipt.totRcptNo,
      brandName: business.name!,
      brandAddress: business.adrs ?? "No address",
      brandTel: ProxyService.box.getUserPhone()!,
      brandTIN: business.tinNumber.toString(),
      brandDescription: business.name!,
      brandFooter: business.name!,
    );
  }

  var _receiptReady = false;
  bool get receiptReady => _receiptReady;
  set receiptReady(bool value) {
    _receiptReady = value;
    notifyListeners();
  }

  Future<void> generateRRAReceipt(
      {required List<OrderItem> items,
      required Business business,
      required Order order}) async {
    ReceiptSignature? receiptSignature =
        await ProxyService.tax.createReceipt(order: order, items: items);

    await ProxyService.isarApi
        .createReceipt(signature: receiptSignature!, order: order);
    receiptReady = true;
    notifyListeners();
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices =>
      [keypad, _app, productService, settingService, languageService];
}
