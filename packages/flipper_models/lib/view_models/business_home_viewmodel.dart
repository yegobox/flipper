library flipper_models;

import 'dart:async';
import 'package:flipper_models/isar/random.dart';
import 'package:flipper_models/isar/receipt_signature.dart';
import 'package:flipper_routing/receipt_types.dart';
import 'package:flipper_services/locator.dart';
import 'package:intl/intl.dart';
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
import 'package:flipper_models/isar_models.dart';
import 'package:receipt/print.dart';

class BusinessHomeViewModel extends ReactiveViewModel {
  final settingService = locator<SettingsService>();
  final languageService = locator<Language>();
  final KeyPadService keypad = locator<KeyPadService>();
  final ProductService productService = locator<ProductService>();
  final AppService app = locator<AppService>();
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
    languageService.setLocale(lang: defaultLanguage!);
  }

  //change theme
  void onThemeModeChanged(ThemeMode mode) {
    settingService.setThemeMode(mode);
    notifyListeners();
  }

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

  void keyboardKeyPressed({required String key}) async {
    ProxyService.analytics.trackEvent("keypad", {'feature_name': 'keypad_tab'});

    Order? pendingOrder = await ProxyService.isar.manageOrder();
    List<OrderItem> items = await ProxyService.isar
        .orderItems(orderId: pendingOrder.id!, doneWithOrder: false);

    switch (key) {
      case 'C':
        handleClearKey(items, pendingOrder);
        break;

      case '+':
        for (OrderItem item in items) {
          /// mark the item on the order as true so next time we will create new one
          /// instead of updating existing one
          item.doneWithOrder = true;
          await ProxyService.isar.update(data: item);
        }
        ProxyService.keypad.reset();
        rebuildUi();
        break;

      default:
        ProxyService.keypad.addKey(key);
        if (ProxyService.keypad.key.length == 1) {
          handleSingleDigitKey(items, pendingOrder);
        } else if (ProxyService.keypad.key.length > 1) {
          handleMultipleDigitKey(items, pendingOrder);
        }
        break;
    }
  }

  void handleClearKey(List<OrderItem> items, Order pendingOrder) async {
    if (items.isEmpty) {
      ProxyService.keypad.reset();
      return;
    }

    OrderItem itemToDelete = items.last;
    await ProxyService.isar.delete(id: itemToDelete.id!, endPoint: 'orderItem');

    List<OrderItem> updatedItems = await ProxyService.isar
        .orderItems(orderId: pendingOrder.id!, doneWithOrder: false);
    pendingOrder.subTotal =
        updatedItems.fold(0, (a, b) => a + (b.price * b.qty));
    pendingOrder.updatedAt = DateTime.now().toIso8601String();
    await ProxyService.isar.update(data: pendingOrder);
    ProxyService.keypad.reset();

    Order? updatedOrder =
        await ProxyService.isar.getOrderById(id: pendingOrder.id!);
    keypad.setOrder(updatedOrder);

    rebuildUi();
  }

  void handleSingleDigitKey(List<OrderItem> items, Order pendingOrder) async {
    double amount = double.parse(ProxyService.keypad.key);

    if (amount == 0.0) return;

    Variant? variation = await ProxyService.isar.getCustomVariant();
    if (variation == null) return;

    Stock? stock =
        await ProxyService.isar.stockByVariantId(variantId: variation.id!);
    if (stock == null) {
      stock = await ProxyService.isar.addStockToVariant(variant: variation);
    }

    String name = variation.productName != 'Custom Amount'
        ? '${variation.productName}(${variation.name})'
        : variation.productName;

    if (items.isEmpty) {
      OrderItem newItem =
          newOrderItem(amount, variation, name, pendingOrder, stock!);
      await ProxyService.isar.addOrderItem(order: pendingOrder, item: newItem);
      items = await ProxyService.isar
          .orderItems(orderId: pendingOrder.id!, doneWithOrder: false);
    } else {
      items = await ProxyService.isar
          .orderItems(orderId: pendingOrder.id!, doneWithOrder: false);
    }

    pendingOrder.subTotal = items.fold(0, (a, b) => a + (b.price * b.qty));
    pendingOrder.updatedAt = DateTime.now().toIso8601String();
    await ProxyService.isar.update(data: pendingOrder);

    keypad.setOrder(pendingOrder);
  }

  void handleMultipleDigitKey(List<OrderItem> items, Order pendingOrder) async {
    double amount = double.parse(ProxyService.keypad.key);
    Variant? variation = await ProxyService.isar.getCustomVariant();
    if (variation == null) return;

    if (items.isEmpty) {
      Stock? stock =
          await ProxyService.isar.stockByVariantId(variantId: variation.id!);
      if (stock == null) {
        stock = await ProxyService.isar.addStockToVariant(variant: variation);
      }

      String name = variation.productName != 'Custom Amount'
          ? '${variation.productName}(${variation.name})'
          : variation.productName;

      OrderItem? existOrderItem = await ProxyService.isar
          .getOrderItemByVariantId(
              variantId: variation.id!, orderId: pendingOrder.id!);

      if (existOrderItem != null) {
        existOrderItem.qty = existOrderItem.qty + 1;
        existOrderItem.price = amount / 1; // price of one unit

        List<OrderItem> items = await ProxyService.isar
            .orderItems(orderId: pendingOrder.id!, doneWithOrder: false);
        pendingOrder.subTotal =
            items.fold(0, (a, b) => a + (b.price * b.qty) + amount);
        pendingOrder.updatedAt = DateTime.now().toIso8601String();
        ProxyService.isar.update(data: pendingOrder);
        ProxyService.isar.update(data: existOrderItem);
      } else {
        OrderItem newItem =
            newOrderItem(amount, variation, name, pendingOrder, stock!);

        List<OrderItem> items = await ProxyService.isar
            .orderItems(orderId: pendingOrder.id!, doneWithOrder: false);
        pendingOrder.subTotal =
            items.fold(0, (a, b) => a + (b.price * b.qty) + amount);
        pendingOrder.updatedAt = DateTime.now().toIso8601String();
        await ProxyService.isar.update(data: pendingOrder);
        await ProxyService.isar
            .addOrderItem(order: pendingOrder, item: newItem);

        notifyListeners();
      }
    } else {
      OrderItem item = items.last;
      item.price = amount;
      item.taxAmt = double.parse((amount * 18 / 118).toStringAsFixed(2));
      await ProxyService.isar.update(data: item);

      pendingOrder.subTotal = items.fold(0, (a, b) => a + (b.price * b.qty));
      pendingOrder.updatedAt = DateTime.now().toIso8601String();
      await ProxyService.isar.update(data: pendingOrder);

      Order? updatedOrder =
          await ProxyService.isar.getOrderById(id: pendingOrder.id!);
      keypad.setOrder(updatedOrder);
    }
  }

  OrderItem newOrderItem(double amount, Variant variation, String name,
      Order pendingOrder, Stock stock) {
    return OrderItem(
      id: syncIdInt(),
      qty: 1,
      price: amount / 1,
      variantId: variation.id!,
      name: name,
      discount: 0.0,
      reported: false,
      doneWithOrder: false,
      orderId: pendingOrder.id!,
      createdAt: DateTime.now().toString(),
      updatedAt: DateTime.now().toString(),
      isTaxExempted: variation.isTaxExempted,
      remainingStock: stock.currentStock - 1,
    );
  }

  /// the function is useful on completing a sale since we need to look for this past order
  /// to add customer etc... we can not use getOrders as it was a general function for all completed functions
  /// but this will be generic for this given order saved in a box it is very important to reach to collect cash screen
  /// for the initation of writing this orderId in a box for later use!.
  Future<void> getOrderById() async {
    int? id = ProxyService.box.read(key: 'orderId');
    await ProxyService.keypad.getOrderById(id: id!);
  }

  ///list products availabe for sell
  Future<List<Product>> products() async {
    int branchId = ProxyService.box.getBranchId()!;
    return await ProxyService.isar.productsFuture(branchId: branchId);
  }

  Business get businesses => app.business;
  ITenant? get tenant => app.tenant;

  void pop() {
    ProxyService.keypad.pop();
  }

  void reset() {
    ProxyService.keypad.reset();
  }

  void handleCustomQtySetBeforeSelectingVariation() {
    if (_currentItemStock != null) {
      keypad.setAmount(amount: _currentItemStock!.retailPrice! * quantity);
    }
  }

  /// setAmount is the amount shown on top of product when increasing the quantity
  void customQtyIncrease(int quantity) {
    ProxyService.keypad.increaseQty(custom: true, qty: quantity);
    if (_currentItemStock != null) {
      keypad.setAmount(amount: _currentItemStock!.retailPrice! * quantity);
    }
  }

  /// We take _variantsStocks[0] because we know
  void decreaseQty(Function callback) {
    ProxyService.keypad.decreaseQty();
    if (_currentItemStock != null) {
      keypad.setAmount(amount: _currentItemStock!.retailPrice! * quantity);
    }
    callback(quantity);
  }

  /// setAmount is the amount shown on top of product when increasing the quantity

  void increaseQty({required Function callback, required bool custom}) {
    ProxyService.keypad.increaseQty(custom: custom);
    if (_currentItemStock != null) {
      keypad.setAmount(amount: _currentItemStock!.retailPrice! * quantity);
      rebuildUi();
    }
    callback(keypad.quantity);
  }

  /// setAmount is the amount shown on top of product when increasing the quantity
  void setAmount({required double amount}) {
    ProxyService.keypad.setAmount(amount: amount);
  }

  void loadVariantStock({required int variantId}) async {
    int branchId = ProxyService.box.getBranchId()!;
    _currentItemStock = await ProxyService.isar
        .getStock(branchId: branchId, variantId: variantId);
  }

  Future<List<Variant>> getVariants({required int productId}) async {
    int branchId = ProxyService.box.getBranchId()!;
    _variants = await ProxyService.isar
        .variants(branchId: branchId, productId: productId);
    notifyListeners();
    return _variants;
  }

  Future<Variant?> getVariant({required int variantId}) async {
    return await ProxyService.isar.variant(variantId: variantId);
  }

  void toggleCheckbox({required int variantId}) {
    keypad.toggleCheckbox(variantId: variantId);
    rebuildUi();
  }

  Future<bool> saveOrder({
    required int variationId,
    required double amountTotal,
    required bool customItem,
  }) async {
    Variant? variation =
        await ProxyService.isar.variant(variantId: variationId);
    Stock? stock =
        await ProxyService.isar.stockByVariantId(variantId: variation!.id!);

    String name = variation.productName != 'Custom Amount'
        ? '${variation.productName}(${variation.name})'
        : variation.productName;

    /// if variation  given it exist in the orderItems of currentPending order then we update the order with new count
    Order pendingOrder = await ProxyService.isar.manageOrder();

    OrderItem? existOrderItem = await ProxyService.isar.getOrderItemByVariantId(
        variantId: variationId, orderId: pendingOrder.id!);
    if (stock == null) {
      /// directly create stock for this variant, there is cases seen on production
      /// where a variant might not have a stock related to it, this might be because of faulty sync
      /// we add default stock then to it.
      stock = await ProxyService.isar.addStockToVariant(variant: variation);
    }
    await addOrderItems(
      variationId: variationId,
      pendingOrder: pendingOrder,
      name: name,
      variation: variation,
      stock: stock!,
      amountTotal: amountTotal,
      isCustom: customItem,
      item: existOrderItem,
    );

    notifyListeners();
    return true;
  }

  /// adding item to current order,
  /// it is important to note that custom item is not incremented
  /// when added and there is existing custom item in the list
  /// because we don't know if this is not something different you are selling at this point.
  Future<void> addOrderItems({
    required int variationId,
    required Order pendingOrder,
    required String name,
    required Variant variation,
    required Stock stock,
    required double amountTotal,
    required bool isCustom,
    OrderItem? item,
  }) async {
    if (item != null && !isCustom) {
      // Update existing order item
      item.qty += quantity.toDouble();
      item.price = amountTotal / quantity;

      List<OrderItem> items = await ProxyService.isar
          .orderItems(orderId: pendingOrder.id!, doneWithOrder: false);
      pendingOrder.subTotal = items.fold(0, (a, b) => a + (b.price * b.qty));
      pendingOrder.updatedAt = DateTime.now().toIso8601String();
      await ProxyService.isar.update(data: pendingOrder);
      await ProxyService.isar.update(data: item);
      return;
    }

    // Create a new order item
    OrderItem newItem = OrderItem(
      id: syncIdInt(),
      qty: isCustom ? 1 : quantity,
      price: amountTotal / quantity,
      variantId: variationId,
      name: name,
      discount: 0.0,
      reported: false,
      orderId: pendingOrder.id!,
      createdAt: DateTime.now().toString(),
      updatedAt: DateTime.now().toString(),
      isTaxExempted: variation.isTaxExempted,
      dcRt: 0.0,
      dcAmt: 0.0,
      taxblAmt: pendingOrder.subTotal,
      taxAmt: double.parse((amountTotal * 18 / 118).toStringAsFixed(2)),
      totAmt: variation.retailPrice,
      itemSeq: variation.itemSeq,
      isrccCd: variation.isrccCd,
      isrccNm: variation.isrccNm,
      isrcRt: variation.isrcRt,
      isrcAmt: variation.isrcAmt,
      taxTyCd: variation.taxTyCd,
      bcd: variation.bcd,
      itemClsCd: variation.itemClsCd,
      itemTyCd: variation.itemTyCd,
      itemStdNm: variation.itemStdNm,
      orgnNatCd: variation.orgnNatCd,
      pkg: variation.pkg,
      itemCd: variation.itemCd,
      pkgUnitCd: variation.pkgUnitCd,
      qtyUnitCd: variation.qtyUnitCd,
      itemNm: variation.itemNm,
      prc: variation.retailPrice,
      splyAmt: variation.splyAmt,
      tin: variation.tin,
      bhfId: variation.bhfId,
      dftPrc: variation.dftPrc,
      addInfo: variation.addInfo,
      isrcAplcbYn: variation.isrcAplcbYn,
      useYn: variation.useYn,
      regrId: variation.regrId,
      regrNm: variation.regrNm,
      modrId: variation.modrId,
      modrNm: variation.modrNm,
      remainingStock: stock.currentStock - quantity,
      doneWithOrder: false,
    );

    List<OrderItem> items = await ProxyService.isar
        .orderItems(orderId: pendingOrder.id!, doneWithOrder: false);
    pendingOrder.subTotal = items.fold(0, (a, b) => a + (b.price * b.qty));
    pendingOrder.updatedAt = DateTime.now().toIso8601String();
    await ProxyService.isar.update(data: pendingOrder);
    await ProxyService.isar.addOrderItem(order: pendingOrder, item: newItem);
  }

  Future collectSPENNPayment(
      {required String phoneNumber, required double cashReceived}) async {
    if (kOrder == null && amountTotal != 0.0) {
      //should show a global snack bar
      return;
    }
    await ProxyService.isar
        .spennPayment(amount: cashReceived, phoneNumber: phoneNumber);
    await ProxyService.isar
        .collectCashPayment(cashReceived: cashReceived, order: kOrder!);
  }

  Future<void> collectCashPayment() async {
    if (kOrder == null && amountTotal != 0.0) {
      return;
    }
    await ProxyService.isar
        .collectCashPayment(cashReceived: keypad.cashReceived, order: kOrder!);
  }

  void registerLocation() async {
    final permission = await ProxyService.location.doWeHaveLocationPermission();
    if (permission) {
      final Map<String, String> location =
          await ProxyService.location.getLocations();
      longitude = location['longitude'];
      latitude = location['latitude'];

      notifyListeners();
    } else {
      final Map<String, String> location =
          await ProxyService.location.getLocations();
      longitude = location['longitude'];
      latitude = location['latitude'];
      notifyListeners();
    }
  }

  void addCustomer(
      {required String email,
      required String phone,
      required String name,
      required int orderId,
      required String tinNumber}) {
    ProxyService.isar.addCustomer(customer: {
      'email': email,
      'phone': phone,
      'name': name,
      'tinNumber': tinNumber
    }, orderId: orderId);
  }

  Future<void> assignToSale(
      {required int customerId, required int orderId}) async {
    ProxyService.isar
        .assingOrderToCustomer(customerId: customerId, orderId: orderId);
  }

  /// as of when one sale is complete trying to sell second product
  /// the previous Qty and totalAmount where still visible in header which confuses
  /// this is to reset the value for a new sale to come!
  void clearPreviousSaleCounts() {
    keypad.setAmount(amount: 0);
    keypad.increaseQty(custom: true, qty: 1);
  }

  void addNoteToSale({required String note, required Function callback}) async {
    if (kOrder == null) {
      return;
    }
    Order? order = await ProxyService.isar.getOrderById(id: kOrder!.id!);
    // Map map = order!;
    order!.note = note;
    ProxyService.isar.update(data: order);
    callback(1);
  }

  ///save ticket, this method take any existing pending order
  ///change status to parked, this allow the cashier to take another order of different client
  ///and resume this when he feel like he wants to,
  ///the note on order is served as display, therefore an order can not be parked without a note on it.
  void saveTicket(
      {required String ticketName,
      required String ticketNote,
      required Order order}) async {
    order.status = parkedStatus;
    order.note = ticketNote;
    order.ticketName = ticketName;
    order.updatedAt = DateTime.now().toIso8601String();
    await ProxyService.isar.update(data: order);
  }

  Future resumeOrder({required int ticketId}) async {
    Order? _order = await ProxyService.isar.getOrderById(id: ticketId);

    _order!.status = pendingStatus;
    await ProxyService.isar.update(data: _order);
    await keypad.getPendingOrder(branchId: ProxyService.box.getBranchId()!);
    await await updatePayable();
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

    List<OrderItem> items = await ProxyService.isar
        .orderItems(orderId: keypad.order!.id!, doneWithOrder: false);

    num? totalPayable = items.fold(0, (a, b) => a! + (b.price * b.qty));

    num? totalDiscount = items.fold(
        0, (a, b) => a! + (b.discount == null ? 0 : b.discount!.toInt()));

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
  /// FIXMEsometime after deleteting orderItems are not reflecting
  Future<bool> deleteOrderItem(
      {required int id, required BuildContext context}) async {
    await ProxyService.isar.delete(id: id, endPoint: 'orderItem');

    Order? pendingOrder = await ProxyService.isar.manageOrder();
    List<OrderItem> items = await ProxyService.isar
        .orderItems(orderId: pendingOrder.id!, doneWithOrder: false);

    updatePayable();

    if (items.isEmpty) {
      Navigator.of(context).pop();
    }

    return true;
  }

  /// this method is used to restore database from backup
  /// it return [1] if the restore was successful
  /// it return [2] if the restore was not successful and pass it for callback
  /// the UI can notify the user based on the return value
  void restoreBackUp(Function callback) async {
    if (ProxyService.remoteConfig.isBackupAvailable()) {
      Business? business = await ProxyService.isar.getBusiness();
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
      await drive.upload();
      callback(1);
    }
  }

  List<OrderItem> orderItems = [];

  void loadReport() async {
    int branchId = ProxyService.box.getBranchId()!;
    List<Order> completedOrders =
        await ProxyService.isar.completedOrders(branchId: branchId);
    Set<OrderItem> allItems = {};
    for (Order completedOrder in completedOrders) {
      List<OrderItem> orderItems = await ProxyService.isar
          .getOrderItemsByOrderId(orderId: completedOrder.id!);
      allItems.addAll(orderItems.toSet());
    }
    orderItems = allItems.toList();
    notifyListeners();
  }

  void printReceipt(
      {required List<OrderItem> items,
      required Business business,
      required String receiptType,
      required Order oorder}) async {
    // get receipt from isar related to this order
    // get refreshed order with cash received
    Order? order = await ProxyService.isar.getOrderById(id: oorder.id!);
    Receipt? receipt = await ProxyService.isar.getReceipt(orderId: order!.id!);
    // get time formatted like hhmmss
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
      mrc: receipt!.mrcNo,
      internalData: receipt.intrlData,
      receiptQrCode: receipt.qrCode,
      receiptSignature: receipt.rcptSign,
      cashierName: business.name!,
      sdcId: receipt.sdcId,
      sdcReceiptNum: receipt.receiptType,
      invoiceNum: receipt.totRcptNo,
      brandName: business.name!,
      brandAddress: business.adrs ?? "Kigali,Rwanda",
      brandTel: ProxyService.box.getUserPhone()!,
      brandTIN: business.tinNumber.toString(),
      brandDescription: business.name!,
      brandFooter: business.name!,
      emails: [app.customer?.email ?? 'info@yegobox.com', 'info@yegobox.com'],
      customerTin: app.customer?.tinNumber.toString() ?? "0000000000",
      receiptType: receiptType,
    );
  }

  var _receiptReady = false;
  bool get receiptReady => _receiptReady;
  set receiptReady(bool value) {
    _receiptReady = value;
    notifyListeners();
  }

  Future<bool> generateRRAReceipt(
      {required List<OrderItem> items,
      required Business business,
      String? receiptType = "ns",
      required Order order,
      required Function callback}) async {
    // use local counter as long as it is marked as synced.
    Counter counter = await getCounter(receiptType);
    if (counter.backed != null && !counter.backed!) {
      callback("The counter is not up to date");
      return false;
    }
    Customer? customer =
        await ProxyService.isar.nGetCustomerByOrderId(id: order.id!);
    ReceiptSignature? receiptSignature = await ProxyService.tax.createReceipt(
        order: order,
        items: items,
        customer: customer,
        receiptType: receiptType!,
        counter: counter);
    if (receiptSignature == null) {
      callback("EBM V2 server is down, please try again later");
      return false;
    }
    order.receiptType = order.receiptType == null
        ? receiptType
        : order.receiptType! + "," + receiptType;

    // get the current drawer status
    await updateDrawer(receiptType, order);
    ProxyService.isar.update(data: order);
    String time = DateTime.now().toString().substring(11, 19);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyy').format(now);
    // qrCode with the following format (ddmmyyyy)#time(hhmmss)#sdc number#sdc_receipt_number#internal_data#receipt_signature
    String receiptNumber =
        "${receiptSignature.data.rcptNo}/${receiptSignature.data.totRcptNo}";
    String qrCode =
        '$formattedDate#$time#${receiptSignature.data.sdcId}#$receiptNumber#${receiptSignature.data.intrlData}#${receiptSignature.data.rcptSign}';
    await ProxyService.isar.createReceipt(
        signature: receiptSignature,
        order: order,
        qrCode: qrCode,
        counter: counter,
        receiptType: receiptNumber);
    // update counter, increment the counter
    ProxyService.isar.update(
        data: counter
          ..totRcptNo = receiptSignature.data.totRcptNo + 1
          ..backed = false
          ..curRcptNo = receiptSignature.data.rcptNo + 1);
    receiptReady = true;
    notifyListeners();
    return true;
  }

  Future<Counter> getCounter(String? receiptType) async {
    Counter? counter;
    int branchId = ProxyService.box.getBranchId()!;
    if (receiptType == "ns") {
      counter = await ProxyService.isar.nSCounter(branchId: branchId);
    }
    if (receiptType == ReceiptType.ts) {
      counter = await ProxyService.isar.tSCounter(branchId: branchId);
    }
    if (receiptType == ReceiptType.nr) {
      counter = await ProxyService.isar.nRSCounter(branchId: branchId);
    }
    if (receiptType == ReceiptType.cs) {
      counter = await ProxyService.isar.cSCounter(branchId: branchId);
    }
    if (receiptType == ReceiptType.ps) {
      counter = await ProxyService.isar.pSCounter(branchId: branchId);
    }
    return counter!;
  }

  Future<void> updateDrawer(String receiptType, Order order) async {
    Drawers? drawer = await ProxyService.isar
        .getDrawer(cashierId: ProxyService.box.getBusinessId()!);
    drawer!
      ..cashierId = ProxyService.box.getBusinessId()!
      ..nsSaleCount = receiptType == "NS"
          ? drawer.nsSaleCount ?? 0 + 1
          : drawer.nsSaleCount ?? 0
      ..trSaleCount = receiptType == "TR"
          ? drawer.trSaleCount ?? 0 + 1
          : drawer.trSaleCount ?? 0
      ..psSaleCount = receiptType == "PS"
          ? drawer.psSaleCount ?? 0 + 1
          : drawer.psSaleCount ?? 0
      ..csSaleCount = receiptType == "CS"
          ? drawer.csSaleCount ?? 0 + 1
          : drawer.csSaleCount ?? 0
      ..nrSaleCount = receiptType == "NR"
          ? drawer.nrSaleCount ?? 0 + 1
          : drawer.nrSaleCount ?? 0
      ..incompleteSale = 0
      ..totalCsSaleIncome = receiptType == "CS"
          ? drawer.totalCsSaleIncome ?? 0 + order.subTotal
          : drawer.totalCsSaleIncome ?? 0
      ..totalNsSaleIncome = receiptType == "NS"
          ? drawer.totalNsSaleIncome ?? 0 + order.subTotal
          : drawer.totalNsSaleIncome ?? 0
      ..openingDateTime = DateTime.now().toIso8601String()
      ..open = true;
    // update drawer
    await ProxyService.isar.update(data: drawer);
  }

  List<Order> _completedOrders = [];
  List<Order> get completedOrdersList => _completedOrders;
  set completedOrdersList(List<Order> value) {
    _completedOrders = value;
    notifyListeners();
  }

  List<OrderItem> _completedOrderItems = [];
  List<OrderItem> get completedOrderItemsList => _completedOrderItems;
  set completedOrderItemsList(List<OrderItem> value) {
    _completedOrderItems = value;
    notifyListeners();
  }

  Customer? get customer => app.customer;
  // check if the customer is attached to the order then can't be deleted
  // order need to be deleted or completed first.
  void deleteCustomer(int id, Function callback) {
    if (kOrder!.customerId == null) {
      ProxyService.isar.delete(id: id, endPoint: 'customer');
    } else {
      callback("Can't delete the customer");
    }
  }

  /// This function gets the default tenant for the current user.
  ///
  /// The function first gets the user ID from the `ProxyService`.
  /// Then, it calls the `getTenantBYUserId` method on the `ProxyService` to get the tenant for the user ID.
  /// If the tenant is not found, the function throws an exception. because every default business owner should have
  /// one default tenant
  /// Finally, the function sets the tenant on the `app` object.

  void defaultTenant() async {
    final userId = ProxyService.box.getUserId()!;
    final tenant = await ProxyService.isar.getTenantBYUserId(userId: userId);
    if (tenant == null) {
      throw Exception("could not find tenant with ${userId}");
    }
    app.setTenant(tenant: tenant);
  }

  void setDefaultBusiness({required Business business}) {
    app.setBusiness(business: business);
    ProxyService.isar.update(data: business..isDefault = true);
    ProxyService.box.write(key: 'businessId', value: business.id);
  }

  void setDefaultBranch({required Branch branch}) {
    ProxyService.isar.update(data: branch..isDefault = true);
    ProxyService.box.write(key: 'branchId', value: branch.id);
  }

  /// a method that listen on given tenantId and perform a sale to a POS
  /// this work with nfc card tapped on supported devices to perfom sales
  /// []

  Future<void> sellWithCard({required int tenantId}) async {
    Product? product =
        await ProxyService.isar.findProductByTenantId(tenantId: tenantId);

    clearPreviousSaleCounts();
    List<Variant> variants = await getVariants(productId: product!.id!);
    loadVariantStock(variantId: variants.first.id!);

    handleCustomQtySetBeforeSelectingVariation();

    keypad.setAmount(amount: variants.first.retailPrice * quantity);
    toggleCheckbox(variantId: variants.first.id!);
    increaseQty(callback: (quantity) {}, custom: true);
    await saveOrder(
      variationId: checked,
      amountTotal: amountTotal,
      customItem: false,
    );
  }

  List<Branch> branches = [];
  void branchesList(List<Branch> value) {
    branches = value;
    notifyListeners();
  }

  @override
  List<ListenableServiceMixin> get listenableServices =>
      [keypad, app, productService, settingService];
}
