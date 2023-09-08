library flipper_models;

import 'dart:async';
import 'dart:developer';
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

class HomeViewModel extends ReactiveViewModel {
  final settingService = getIt<SettingsService>();
  final languageService = getIt<Language>();
  final KeyPadService keypad = getIt<KeyPadService>();
  final ProductService productService = getIt<ProductService>();
  final AppService app = getIt<AppService>();
  final bool _updateStarted = false;
  Setting? _setting;

  bool newTransactionPressed = false;

  String newTransactionType = 'none';
  String transactionPeriod = "Today";
  String profitType = "Net Profit";
  Setting? get setting => _setting;
  bool get updateStart => _updateStarted;
  String? defaultLanguage;

  Locale? klocale;

  Locale? get locale => klocale;
  get categories => app.categories;

  String? getSetting() {
    klocale =
        Locale(ProxyService.box.readString(key: 'defaultLanguage') ?? 'en');
    setLanguage(ProxyService.box.readString(key: 'defaultLanguage') ?? 'en');
    return ProxyService.box.readString(key: 'defaultLanguage');
  }

  void setLanguage(String lang) {
    defaultLanguage = null;
    klocale = Locale(lang);
    ProxyService.box.writeString(key: 'defaultLanguage', value: lang);
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

  Transaction? get kTransaction => keypad.transaction;

  double get amountTotal => keypad.amountTotal;

  String get checked => keypad.check;

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

    Transaction? pendingTransaction =
        await ProxyService.isar.manageTransaction();
    List<TransactionItem> items = await ProxyService.isar.transactionItems(
        transactionId: pendingTransaction.id, doneWithTransaction: false);

    switch (key) {
      case 'C':
        handleClearKey(items, pendingTransaction);
        break;

      case '+':
        for (TransactionItem item in items) {
          /// mark the item on the transaction as true so next time we will create new one
          /// instead of updating existing one
          item.doneWithTransaction = true;
          await ProxyService.isar.update(data: item);
        }
        ProxyService.keypad.reset();
        rebuildUi();
        break;
      default:
        ProxyService.keypad.addKey(key);
        if (ProxyService.keypad.key.length == 1) {
          handleSingleDigitKey(items, pendingTransaction);
        } else if (ProxyService.keypad.key.length > 1) {
          handleMultipleDigitKey(items, pendingTransaction);
        }
        break;
    }
  }

  void handleClearKey(
      List<TransactionItem> items, Transaction pendingTransaction) async {
    if (items.isEmpty) {
      ProxyService.keypad.reset();
      return;
    }

    TransactionItem itemToDelete = items.last;
    await ProxyService.isar
        .delete(id: itemToDelete.id, endPoint: 'transactionItem');

    List<TransactionItem> updatedItems = await ProxyService.isar
        .transactionItems(
            transactionId: pendingTransaction.id, doneWithTransaction: false);
    pendingTransaction.subTotal =
        updatedItems.fold(0, (a, b) => a + (b.price * b.qty));
    pendingTransaction.updatedAt = DateTime.now().toIso8601String();
    await ProxyService.isar.update(data: pendingTransaction);
    ProxyService.keypad.reset();

    Transaction? updatedTransaction =
        await ProxyService.isar.getTransactionById(id: pendingTransaction.id);
    keypad.setTransaction(updatedTransaction);

    rebuildUi();
  }

  void handleSingleDigitKey(
      List<TransactionItem> items, Transaction pendingTransaction) async {
    double amount = double.parse(ProxyService.keypad.key);

    if (amount == 0.0) return;

    Variant? variation = await ProxyService.isar.getCustomVariant();
    if (variation == null) return;

    Stock? stock =
        await ProxyService.isar.stockByVariantId(variantId: variation.id);
    if (stock == null) {
      stock = await ProxyService.isar.addStockToVariant(variant: variation);
    }

    String name = variation.productName != 'Custom Amount'
        ? '${variation.productName}(${variation.name})'
        : variation.productName;

    if (items.isEmpty) {
      TransactionItem newItem = newTransactionItem(
          amount, variation, name, pendingTransaction, stock!);
      newItem.action = AppActions.created;
      await ProxyService.isar
          .addTransactionItem(transaction: pendingTransaction, item: newItem);
      items = await ProxyService.isar.transactionItems(
          transactionId: pendingTransaction.id, doneWithTransaction: false);
    } else {
      items = await ProxyService.isar.transactionItems(
          transactionId: pendingTransaction.id, doneWithTransaction: false);
    }

    pendingTransaction.subTotal =
        items.fold(0, (a, b) => a + (b.price * b.qty));
    pendingTransaction.updatedAt = DateTime.now().toIso8601String();
    await ProxyService.isar.update(data: pendingTransaction);

    keypad.setTransaction(pendingTransaction);
  }

  void handleMultipleDigitKey(
      List<TransactionItem> items, Transaction pendingTransaction) async {
    double amount = double.parse(ProxyService.keypad.key);
    Variant? variation = await ProxyService.isar.getCustomVariant();
    if (variation == null) return;

    if (items.isEmpty) {
      Stock? stock =
          await ProxyService.isar.stockByVariantId(variantId: variation.id);
      if (stock == null) {
        stock = await ProxyService.isar.addStockToVariant(variant: variation);
      }

      String name = variation.productName != 'Custom Amount'
          ? '${variation.productName}(${variation.name})'
          : variation.productName;

      TransactionItem? existTransactionItem = await ProxyService.isar
          .getTransactionItemByVariantId(
              variantId: variation.id, transactionId: pendingTransaction.id);

      if (existTransactionItem != null) {
        existTransactionItem.qty = existTransactionItem.qty + 1;
        existTransactionItem.price = amount / 1; // price of one unit

        List<TransactionItem> items = await ProxyService.isar.transactionItems(
            transactionId: pendingTransaction.id, doneWithTransaction: false);
        pendingTransaction.subTotal =
            items.fold(0, (a, b) => a + (b.price * b.qty) + amount);
        pendingTransaction.updatedAt = DateTime.now().toIso8601String();
        ProxyService.isar.update(data: pendingTransaction);
        ProxyService.isar.update(data: existTransactionItem);
      } else {
        TransactionItem newItem = newTransactionItem(
            amount, variation, name, pendingTransaction, stock!);

        List<TransactionItem> items = await ProxyService.isar.transactionItems(
            transactionId: pendingTransaction.id, doneWithTransaction: false);
        pendingTransaction.subTotal =
            items.fold(0, (a, b) => a + (b.price * b.qty) + amount);
        pendingTransaction.updatedAt = DateTime.now().toIso8601String();
        await ProxyService.isar.update(data: pendingTransaction);
        newItem.action = AppActions.created;
        await ProxyService.isar
            .addTransactionItem(transaction: pendingTransaction, item: newItem);

        notifyListeners();
      }
    } else {
      TransactionItem item = items.last;
      item.price = amount;
      item.taxAmt = double.parse((amount * 18 / 118).toStringAsFixed(2));
      await ProxyService.isar.update(data: item);

      pendingTransaction.subTotal =
          items.fold(0, (a, b) => a + (b.price * b.qty));
      pendingTransaction.updatedAt = DateTime.now().toIso8601String();
      await ProxyService.isar.update(data: pendingTransaction);

      Transaction? updatedTransaction =
          await ProxyService.isar.getTransactionById(id: pendingTransaction.id);
      keypad.setTransaction(updatedTransaction);
    }
  }

  TransactionItem newTransactionItem(double amount, Variant variation,
      String name, Transaction pendingTransaction, Stock stock) {
    int branchId = ProxyService.box.getBranchId()!;
    return TransactionItem(
      id: randomString(),
      qty: 1,
      lastTouched: DateTime.now(),
      action: AppActions.create,
      price: amount / 1,
      variantId: variation.id,
      name: name,
      branchId: branchId,
      discount: 0.0,
      doneWithTransaction: false,
      transactionId: pendingTransaction.id,
      createdAt: DateTime.now().toString(),
      updatedAt: DateTime.now().toString(),
      isTaxExempted: variation.isTaxExempted,
      remainingStock: stock.currentStock - 1,
    );
  }

  /// the function is useful on completing a sale since we need to look for this past transaction
  /// to add customer etc... we can not use getTransactions as it was a general function for all completed functions
  /// but this will be generic for this given transaction saved in a box it is very important to reach to collect cash screen
  /// for the initation of writing this transactionId in a box for later use!.
  Future<void> getTransactionById() async {
    String? id = ProxyService.box.readString(key: 'transactionId');
    if (id != null) {
      log("id is: $id");
      await ProxyService.keypad.getTransactionById(id: id);
    }
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
  void customQtyIncrease(double quantity) {
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

  void loadVariantStock({required String variantId}) async {
    int branchId = ProxyService.box.getBranchId()!;
    _currentItemStock = await ProxyService.isar
        .getStock(branchId: branchId, variantId: variantId);
  }

  Future<List<Variant>> getVariants({required String productId}) async {
    int branchId = ProxyService.box.getBranchId()!;
    _variants = await ProxyService.isar
        .variants(branchId: branchId, productId: productId);
    notifyListeners();
    return _variants;
  }

  Future<Variant?> getVariant({required String variantId}) async {
    return await ProxyService.isar.variant(variantId: variantId);
  }

  void toggleCheckbox({required String variantId}) {
    keypad.toggleCheckbox(variantId: variantId);
    rebuildUi();
  }

  List<Transaction> transactions = [];
  void updateTransactionsList({required List<Transaction> newTransactions}) {
    transactions.addAll(newTransactions);
    // rebuildUi();
  }

  Future<bool> saveCashBookTransaction(
      {required String cbTransactionType}) async {
    Transaction cbTransaction = kTransaction!;
    cbTransaction.cashReceived = cbTransaction.subTotal;
    cbTransaction.customerChangeDue = 0;
    cbTransaction.transactionType = cbTransactionType;
    cbTransaction.paymentType = "Cash";
    cbTransaction.status = 'completed';

    List<TransactionItem> cbTransactionItems = await ProxyService.isar
        .transactionItems(
            transactionId: cbTransaction.id, doneWithTransaction: false);

    for (var item in cbTransactionItems) {
      item.doneWithTransaction = true;
      await ProxyService.isar.update(data: item);
    }
    List<Transaction> tr = [];
    tr.add(cbTransaction);
    await ProxyService.isar.update(data: cbTransaction);
    updateTransactionsList(newTransactions: tr);
    notifyListeners();
    return Future<bool>.value(true);
  }

  Future<bool> saveTransaction({
    required String variationId,
    required double amountTotal,
    required bool customItem,
  }) async {
    Variant? variation =
        await ProxyService.isar.variant(variantId: variationId);
    Stock? stock =
        await ProxyService.isar.stockByVariantId(variantId: variation!.id);

    String name = variation.productName != 'Custom Amount'
        ? '${variation.productName}(${variation.name})'
        : variation.productName;

    /// if variation  given it exist in the transactionItems of currentPending transaction then we update the transaction with new count
    Transaction pendingTransaction =
        await ProxyService.isar.manageTransaction();

    TransactionItem? existTransactionItem = await ProxyService.isar
        .getTransactionItemByVariantId(
            variantId: variationId, transactionId: pendingTransaction.id);
    if (stock == null) {
      /// directly create stock for this variant, there is cases seen on production
      /// where a variant might not have a stock related to it, this might be because of faulty sync
      /// we add default stock then to it.
      stock = await ProxyService.isar.addStockToVariant(variant: variation);
    }
    await addTransactionItems(
      variationId: variationId,
      pendingTransaction: pendingTransaction,
      name: name,
      variation: variation,
      stock: stock!,
      amountTotal: amountTotal,
      isCustom: customItem,
      item: existTransactionItem,
    );

    notifyListeners();
    return true;
  }

  /// adding item to current transaction,
  /// it is important to note that custom item is not incremented
  /// when added and there is existing custom item in the list
  /// because we don't know if this is not something different you are selling at this point.
  Future<void> addTransactionItems({
    required String variationId,
    required Transaction pendingTransaction,
    required String name,
    required Variant variation,
    required Stock stock,
    required double amountTotal,
    required bool isCustom,
    TransactionItem? item,
  }) async {
    if (item != null && !isCustom) {
      // Update existing transaction item
      item.qty += quantity.toDouble();
      item.price = amountTotal / quantity;

      List<TransactionItem> items = await ProxyService.isar.transactionItems(
          transactionId: pendingTransaction.id, doneWithTransaction: false);
      pendingTransaction.subTotal =
          items.fold(0, (a, b) => a + (b.price * b.qty));
      pendingTransaction.updatedAt = DateTime.now().toIso8601String();
      await ProxyService.isar.update(data: pendingTransaction);
      await ProxyService.isar.update(data: item);
      return;
    }
    int branchId = ProxyService.box.getBranchId()!;
    // Create a new transaction item
    TransactionItem newItem = TransactionItem(
      id: randomString(),
      branchId: branchId,
      lastTouched: DateTime.now(),
      action: AppActions.create,
      qty: isCustom ? 1.0 : quantity,
      price: amountTotal / quantity,
      variantId: variationId,
      name: name,
      discount: 0.0,
      transactionId: pendingTransaction.id,
      createdAt: DateTime.now().toString(),
      updatedAt: DateTime.now().toString(),
      isTaxExempted: variation.isTaxExempted,
      dcRt: 0.0,
      dcAmt: 0.0,
      taxblAmt: pendingTransaction.subTotal,
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
      doneWithTransaction: false,
    );

    List<TransactionItem> items = await ProxyService.isar.transactionItems(
        transactionId: pendingTransaction.id, doneWithTransaction: false);
    pendingTransaction.subTotal =
        items.fold(0, (a, b) => a + (b.price * b.qty));
    pendingTransaction.updatedAt = DateTime.now().toIso8601String();
    await ProxyService.isar.update(data: pendingTransaction);
    newItem.action = AppActions.created;
    await ProxyService.isar
        .addTransactionItem(transaction: pendingTransaction, item: newItem);
  }

  Future<String> collectSPENNPayment(
      {required String phoneNumber,
      required double cashReceived,
      required String paymentType}) async {
    await ProxyService.isar
        .spennPayment(amount: cashReceived, phoneNumber: phoneNumber);
    await ProxyService.isar.collectPayment(
        cashReceived: cashReceived,
        transaction: kTransaction!,
        paymentType: paymentType);
    return "PaymentRecorded";
  }

  Future<void> collectPayment({required String paymentType}) async {
    if (kTransaction == null && amountTotal != 0.0) {
      return;
    }
    await ProxyService.isar.collectPayment(
        cashReceived: keypad.cashReceived,
        transaction: kTransaction!,
        paymentType: paymentType);
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
      required String transactionId,
      required String tinNumber}) {
    ProxyService.isar.addCustomer(customer: {
      'email': email,
      'phone': phone,
      'name': name,
      'tinNumber': tinNumber
    }, transactionId: transactionId);
  }

  Future<void> assignToSale(
      {required int customerId, required String transactionId}) async {
    ProxyService.isar.assingTransactionToCustomer(
        customerId: customerId, transactionId: transactionId);
  }

  /// as of when one sale is complete trying to sell second product
  /// the previous Qty and totalAmount where still visible in header which confuses
  /// this is to reset the value for a new sale to come!
  void clearPreviousSaleCounts() {
    keypad.setAmount(amount: 0);
    keypad.increaseQty(custom: true, qty: 1);
  }

  void addNoteToSale({required String note, required Function callback}) async {
    if (kTransaction == null) {
      return;
    }
    Transaction? transaction =
        await ProxyService.isar.getTransactionById(id: kTransaction!.id);
    // Map map = transaction!;
    transaction!.note = note;
    ProxyService.isar.update(data: transaction);
    callback(1);
  }

  ///save ticket, this method take any existing pending transaction
  ///change status to parked, this allow the cashier to take another transaction of different client
  ///and resume this when he feel like he wants to,
  ///the note on transaction is served as display, therefore an transaction can not be parked without a note on it.
  void saveTicket(
      {required String ticketName,
      required String ticketNote,
      required Transaction transaction}) async {
    transaction.status = PARKED;
    transaction.note = ticketNote;
    transaction.ticketName = ticketName;
    transaction.updatedAt = DateTime.now().toIso8601String();
    await ProxyService.isar.update(data: transaction);
  }

  Future resumeTransaction({required String ticketId}) async {
    Transaction? _transaction =
        await ProxyService.isar.getTransactionById(id: ticketId);

    _transaction!.status = PENDING;
    await ProxyService.isar.update(data: _transaction);
    await keypad.getPendingTransaction(
        branchId: ProxyService.box.getBranchId()!);
    await await updatePayable();
  }

  /// the method return total amount of the transaction to be used in the payment
  /// @return num if there is discount applied to transactionItem then it will return discount instead of price to be
  /// considered in the total amount payable
  // num? totalPayable = 0.0;
  // num? totalDiscount = 0.0;

  double get totalPayable => keypad.totalPayable;

  double get totalDiscount => keypad.totalDiscount;

  Future<num?> updatePayable() async {
    keypad.setTotalPayable(amount: 0.0);

    keypad.setTotalDiscount(amount: 0.0);

    if (keypad.transaction == null) return 0.0;

    List<TransactionItem> items = await ProxyService.isar.transactionItems(
        transactionId: keypad.transaction!.id, doneWithTransaction: false);

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

  /// if deleting TransactionItem leaves transaction with no TransactionItem
  /// this function also delete the transaction
  /// FIXMEsometime after deleteting transactionItems are not reflecting
  Future<bool> deleteTransactionItem(
      {required int id, required BuildContext context}) async {
    await ProxyService.isar.delete(id: id, endPoint: 'transactionItem');

    Transaction? pendingTransaction =
        await ProxyService.isar.manageTransaction();
    List<TransactionItem> items = await ProxyService.isar.transactionItems(
        transactionId: pendingTransaction.id, doneWithTransaction: false);

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

  List<TransactionItem> transactionItems = [];

  void loadReport() async {
    int branchId = ProxyService.box.getBranchId()!;
    List<Transaction> completedTransactions =
        await ProxyService.isar.completedTransactions(branchId: branchId);
    Set<TransactionItem> allItems = {};
    for (Transaction completedTransaction in completedTransactions) {
      List<TransactionItem> transactionItems = await ProxyService.isar
          .getTransactionItemsByTransactionId(
              transactionId: completedTransaction.id);
      allItems.addAll(transactionItems.toSet());
    }
    transactionItems = allItems.toList();
    notifyListeners();
  }

  void printReceipt(
      {required List<TransactionItem> items,
      required Business business,
      required String receiptType,
      required Transaction otransaction}) async {
    // get receipt from isar related to this transaction
    // get refreshed transaction with cash received
    Transaction? transaction =
        await ProxyService.isar.getTransactionById(id: otransaction.id);
    Receipt? receipt =
        await ProxyService.isar.getReceipt(transactionId: transaction!.id);
    // get time formatted like hhmmss
    Print print = Print();
    print.feed(items);
    print.print(
      grandTotal: transaction.subTotal,
      currencySymbol: "RW",
      totalAEx: 0,
      totalB18: (transaction.subTotal * 18 / 118).toStringAsFixed(2),
      totalB: transaction.subTotal,
      totalTax: (transaction.subTotal * 18 / 118).toStringAsFixed(2),
      cash: transaction.subTotal,
      received: transaction.cashReceived,
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
      {required List<TransactionItem> items,
      required Business business,
      String? receiptType = "ns",
      required Transaction transaction,
      required Function callback}) async {
    // use local counter as long as it is marked as synced.
    Counter counter = await getCounter(receiptType);
    // TODO: re-implement the logic to make sure counter is up to date
    // if (counter.backed != null && !counter.backed!) {
    //   callback("The counter is not up to date");
    //   return false;
    // }
    Customer? customer =
        await ProxyService.isar.nGetCustomerByTransactionId(id: transaction.id);
    ReceiptSignature? receiptSignature = await ProxyService.tax.createReceipt(
        transaction: transaction,
        items: items,
        customer: customer,
        receiptType: receiptType!,
        counter: counter);
    if (receiptSignature == null) {
      callback("EBM V2 server is down, please try again later");
      return false;
    }
    transaction.receiptType = transaction.receiptType == null
        ? receiptType
        : transaction.receiptType! + "," + receiptType;

    // get the current drawer status
    await updateDrawer(receiptType, transaction);
    ProxyService.isar.update(data: transaction);
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
        transaction: transaction,
        qrCode: qrCode,
        counter: counter,
        receiptType: receiptNumber);
    // update counter, increment the counter
    ProxyService.isar.update(
        data: counter
          ..totRcptNo = receiptSignature.data.totRcptNo + 1
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

  Future<void> updateDrawer(String receiptType, Transaction transaction) async {
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
          ? drawer.totalCsSaleIncome ?? 0 + transaction.subTotal
          : drawer.totalCsSaleIncome ?? 0
      ..totalNsSaleIncome = receiptType == "NS"
          ? drawer.totalNsSaleIncome ?? 0 + transaction.subTotal
          : drawer.totalNsSaleIncome ?? 0
      ..openingDateTime = DateTime.now().toIso8601String()
      ..open = true;
    // update drawer
    await ProxyService.isar.update(data: drawer);
  }

  List<Transaction> _completedTransactions = [];
  List<Transaction> get completedTransactionsList => _completedTransactions;
  set completedTransactionsList(List<Transaction> value) {
    _completedTransactions = value;
    notifyListeners();
  }

  List<TransactionItem> _completedTransactionItems = [];
  List<TransactionItem> get completedTransactionItemsList =>
      _completedTransactionItems;
  set completedTransactionItemsList(List<TransactionItem> value) {
    _completedTransactionItems = value;
    notifyListeners();
  }

  Customer? get customer => app.customer;
  // check if the customer is attached to the transaction then can't be deleted
  // transaction need to be deleted or completed first.
  void deleteCustomer(int id, Function callback) {
    if (kTransaction!.customerId == null) {
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
    ProxyService.box.writeInt(key: 'businessId', value: business.id);
  }

  void setDefaultBranch({required Branch branch}) {
    ProxyService.isar.update(data: branch..isDefault = true);
    ProxyService.box.writeInt(key: 'branchId', value: branch.id);
  }

  /// a method that listen on given tenantId and perform a sale to a POS
  /// this work with nfc card tapped on supported devices to perfom sales
  /// []

  Future<void> sellWithCard({required int tenantId}) async {
    Product? product =
        await ProxyService.isar.findProductByTenantId(tenantId: tenantId);

    clearPreviousSaleCounts();
    List<Variant> variants = await getVariants(productId: product!.id);
    loadVariantStock(variantId: variants.first.id);

    handleCustomQtySetBeforeSelectingVariation();

    keypad.setAmount(amount: variants.first.retailPrice * quantity);
    toggleCheckbox(variantId: variants.first.id);
    increaseQty(callback: (quantity) {}, custom: true);
    await saveTransaction(
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

//Transaction functions
  Stream<List<Transaction>> getTransactions(
      {required String transactionStatus}) {
    Stream<List<Transaction>> res = ProxyService.isar.transactionsStreams();
    return res;
  }

  Future<List<double>> getTransactionsAmountsSum(
      {required String period}) async {
    List<double> res =
        await ProxyService.isar.getTransactionsAmountsSum(period: period);

    return res;
  }

  Stream<List<Transaction>> getLocalTransactions() {
    Stream<List<Transaction>> res = ProxyService.isar.transactionsStreams();
    return res;
  }

  Stream<List<Transaction>> getCashInTransactions() {
    Stream<List<Transaction>> res =
        ProxyService.isar.transactionsStreams(isCashOut: false);
    return res;
  }

  Stream<List<Transaction>> getCashOutTransactions() {
    Stream<List<Transaction>> res =
        ProxyService.isar.transactionsStreams(isCashOut: true);
    return res;
  }

  Future<String> deleteTransactionByIndex(String transactionIndex) async {
    Transaction? target = await getTransactionByIndex(transactionIndex);
    await ProxyService.isar
        .deleteTransactionByIndex(transactionIndex: transactionIndex);
    notifyListeners();
    ProxyService.sync.push();
    if (target != null) {
      return target.id;
    }
    return '403';
  }

  Future<Transaction?> getTransactionByIndex(String transactionIndex) async {
    Transaction? res =
        await ProxyService.isar.getTransactionById(id: transactionIndex);
    return res;
  }

  weakUp({required String pin}) async {
    log(pin, name: 'weakUp');
    // 91102
    log(ProxyService.box.getUserId()!.toString(), name: 'weakUp');
    if (pin.allMatches(ProxyService.box.getUserId()!.toString()).isNotEmpty) {
      log('all matches', name: 'weakUp');
      ProxyService.isar.recordUserActivity(
        userId: ProxyService.box.getUserId()!,
        activity: 'session',
      );
      ProxyService.box.writeInt(key: 'userId', value: int.parse(pin));
      ITenant? tenant = await ProxyService.isar
          .getTenantBYUserId(userId: ProxyService.box.getUserId()!);
      tenant?.sessionActive = true;
      ProxyService.isar.update(data: tenant);
    }
  }
}
