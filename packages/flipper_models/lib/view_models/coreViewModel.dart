// ignore_for_file: unused_result

library flipper_models;

import 'dart:async';
import 'dart:developer';
import 'package:flipper_models/isar/random.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/_transaction.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/drive_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:realm/realm.dart';
import 'package:stacked/stacked.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'mixins/all.dart';

class CoreViewModel extends FlipperBaseModel
    with Properties, SharebleMethods, TransactionMixin {
  bool handlingConfirm = false;
  CoreViewModel() {}

  List<String> transactionPeriodOptions = [
    "Today",
    "This Week",
    "This Month",
    "This Year",
  ];
  List<String> profitTypeOptions = ["Net Profit", "Gross Profit"];
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

  void updateCategory({required Category category}) async {
    int branchId = ProxyService.box.getBranchId()!;
    for (Category category in categories) {
      if (category.focused) {
        Category cat = category;
        cat.focused = false;
        cat.branchId = branchId;
        cat.active = false;
        await ProxyService.realm.update(
          data: cat,
        );
      }
    }

    Category cat = category;
    cat.focused = true;
    cat.active = true;
    cat.branchId = branchId;
    await ProxyService.realm.update(
      data: cat,
    );
    app.loadCategories();
  }

  final talker = TalkerFlutter.init();
  Future<void> keyboardKeyPressed(
      {required String key, String? transactionType = 'custom'}) async {
    talker.info({'feature_name': 'keypad_tab'});
    if (double.tryParse(key) != null) {
      ProxyService.keypad.addKey(key);
    }

    ITransaction? pendingTransaction = await ProxyService.realm
        .manageTransaction(transactionType: transactionType!);

    /// query for an item that is not active so we can edit it
    /// if the item is not available it will be created
    List<TransactionItem> items = await ProxyService.realm.transactionItems(
        transactionId: pendingTransaction.id!,
        doneWithTransaction: false,
        active: false);

    switch (key) {
      case 'C':
        handleClearKey(items, pendingTransaction);

        break;

      case '+':
        ProxyService.realm.realm!.write(() {
          for (TransactionItem item in items) {
            /// mark the item on the transaction as true so next time we will create new one
            /// instead of updating existing one
            item.active = true;
            // Wait for 500ms before updating the next item
          }
        });
        ProxyService.keypad.reset();

        break;
      default:
        if (ProxyService.keypad.key.length == 1) {
          handleSingleDigitKey(items, pendingTransaction);
        } else if (ProxyService.keypad.key.length > 1) {
          handleMultipleDigitKey(items, pendingTransaction);
        }

        break;
    }
  }

  void handleClearKey(
      List<TransactionItem> items, ITransaction pendingTransaction) async {
    if (items.isEmpty) {
      ProxyService.keypad.reset();
      return;
    }
    ProxyService.keypad.reset();
    TransactionItem itemToDelete = items.last;
    await ProxyService.realm
        .delete(id: itemToDelete.id!, endPoint: 'transactionItem');

    List<TransactionItem> updatedItems = await ProxyService.realm
        .transactionItems(
            transactionId: pendingTransaction.id!,
            doneWithTransaction: false,
            active: true);
    pendingTransaction.subTotal =
        updatedItems.fold(0, (a, b) => a + (b.price * b.qty));
    pendingTransaction.updatedAt = DateTime.now().toIso8601String();
    await ProxyService.realm.update(data: pendingTransaction);

    ITransaction? updatedTransaction =
        await ProxyService.realm.getTransactionById(id: pendingTransaction.id!);
    keypad.setTransaction(updatedTransaction);
  }

  void handleSingleDigitKey(
      List<TransactionItem> items, ITransaction pendingTransaction) async {
    double amount = double.parse(ProxyService.keypad.key);

    if (amount == 0) return;

    Variant? variation = await ProxyService.realm.getCustomVariant();
    if (variation == null) return;

    Stock? stock =
        await ProxyService.realm.stockByVariantId(variantId: variation.id!);

    String name = variation.productName != 'Custom Amount'
        ? '${variation.productName}(${variation.name})'
        : variation.productName!;

    if (items.isEmpty) {
      TransactionItem newItem = TransactionItem(
        ObjectId(),
        id: randomNumber(),
        qty: 1,
        action: AppActions.created,
        price: amount / 1,
        variantId: variation.id!,
        name: name,
        branchId: ProxyService.box.getBranchId(),
        discount: 0.0,
        prc: variation.retailPrice,
        doneWithTransaction: false,
        active: false,
        transactionId: pendingTransaction.id!,
        createdAt: DateTime.now().toString(),
        updatedAt: DateTime.now().toString(),
        isTaxExempted: variation.isTaxExempted,
        remainingStock: stock?.currentStock ?? 0 - 1,
      );
      newItem.action = AppActions.created;
      await ProxyService.realm
          .addTransactionItem(transaction: pendingTransaction, item: newItem);
      items = await ProxyService.realm.transactionItems(
          transactionId: pendingTransaction.id!,
          doneWithTransaction: false,
          active: true);
    } else {
      items = await ProxyService.realm.transactionItems(
          transactionId: pendingTransaction.id!,
          doneWithTransaction: false,
          active: true);
    }
    keypad.setTransaction(pendingTransaction);
  }

  void handleMultipleDigitKey(
      List<TransactionItem> items, ITransaction pendingTransaction) async {
    talker.info(ProxyService.keypad.key);
    double amount = double.parse(ProxyService.keypad.key);
    Variant? variation = await ProxyService.realm.getCustomVariant();
    if (variation == null) return;

    if (items.isEmpty) {
      Stock? stock =
          await ProxyService.realm.stockByVariantId(variantId: variation.id!);

      String name = variation.productName != 'Custom Amount'
          ? '${variation.productName}(${variation.name})'
          : variation.productName!;

      TransactionItem? existTransactionItem = await ProxyService.realm
          .getTransactionItemByVariantId(
              variantId: variation.id!, transactionId: pendingTransaction.id);

      if (existTransactionItem != null) {
        existTransactionItem.qty = existTransactionItem.qty + 1;
        existTransactionItem.price = amount / 1; // price of one unit

        List<TransactionItem> items = await ProxyService.realm.transactionItems(
            transactionId: pendingTransaction.id!,
            doneWithTransaction: false,
            active: true);
        pendingTransaction.subTotal =
            items.fold(0, (a, b) => a + (b.price * b.qty) + amount);
        pendingTransaction.updatedAt = DateTime.now().toIso8601String();
        ProxyService.realm.update(data: pendingTransaction);
        ProxyService.realm.update(data: existTransactionItem);
      } else {
        TransactionItem newItem = TransactionItem(
          ObjectId(),
          id: randomNumber(),
          qty: 1,
          action: AppActions.created,
          price: amount / 1,
          variantId: variation.id!,
          name: name,
          branchId: ProxyService.box.getBranchId(),
          discount: 0.0,
          prc: variation.retailPrice,
          doneWithTransaction: false,
          active: false,
          transactionId: pendingTransaction.id!,
          createdAt: DateTime.now().toString(),
          updatedAt: DateTime.now().toString(),
          isTaxExempted: variation.isTaxExempted,
          remainingStock: stock?.currentStock ?? 0 - 1,
        );

        List<TransactionItem> items = await ProxyService.realm.transactionItems(
            transactionId: pendingTransaction.id!,
            doneWithTransaction: false,
            active: true);
        pendingTransaction.subTotal =
            items.fold(0, (a, b) => a + (b.price * b.qty) + amount);
        pendingTransaction.updatedAt = DateTime.now().toIso8601String();
        await ProxyService.realm.update(data: pendingTransaction);
        newItem.action = AppActions.created;
        await ProxyService.realm
            .addTransactionItem(transaction: pendingTransaction, item: newItem);
      }
    } else {
      TransactionItem item = items.last;
      item.price = amount;
      item.taxAmt = double.parse((amount * 18 / 118).toStringAsFixed(2));
      await ProxyService.realm.update(data: item);

      pendingTransaction.subTotal =
          items.fold(0, (a, b) => a + (b.price * b.qty));
      pendingTransaction.updatedAt = DateTime.now().toIso8601String();
      await ProxyService.realm.update(data: pendingTransaction);

      ITransaction? updatedTransaction = await ProxyService.realm
          .getTransactionById(id: pendingTransaction.id!);
      keypad.setTransaction(updatedTransaction);
    }
  }

  /// the function is useful on completing a sale since we need to look for this past transaction
  /// to add customer etc... we can not use getTransactions as it was a general function for all completed functions
  /// but this will be generic for this given transaction saved in a box it is very important to reach to collect cash screen
  /// for the initation of writing this transactionId in a box for later use!.
  Future<void> getTransactionById() async {
    int? id = ProxyService.box.readInt(key: 'transactionId');
    if (id != null) {
      log("id is: $id");
      await ProxyService.keypad.getTransactionById(id: id);
    }
  }

  void setName({String? name}) {
    categoryName = name;
    notifyListeners();
  }

  void loadCategories() {
    app.loadCategories();
  }

  ///create a new category and refresh list of categories
  Future<void> createCategory() async {
    final int? branchId = ProxyService.box.getBranchId();
    if (categoryName == null) return;
    final Category category = Category(ObjectId(),
        name: categoryName!,
        active: true,
        focused: false,
        branchId: branchId!,
        id: randomNumber());

    await ProxyService.realm.create(data: category);
    app.loadCategories();
  }

  ///list products availabe for sell
  Future<List<Product>> products() async {
    int branchId = ProxyService.box.getBranchId()!;
    return await ProxyService.realm.productsFuture(branchId: branchId);
  }

  Business get businesses => app.business;
  Branch? get branch => app.branch;

  void pop() {
    ProxyService.keypad.pop();
  }

  void reset() {
    ProxyService.keypad.reset();
  }

  void handleCustomQtySetBeforeSelectingVariation() {
    if (_currentItemStock != null) {
      keypad.setAmount(amount: _currentItemStock!.retailPrice * quantity);
    }
  }

  /// setAmount is the amount shown on top of product when increasing the quantity
  void customQtyIncrease(double quantity) {
    ProxyService.keypad.increaseQty(custom: true, qty: quantity);
    if (_currentItemStock != null) {
      keypad.setAmount(amount: _currentItemStock!.retailPrice * quantity);
    }
  }

  /// We take _variantsStocks[0] because we know
  void decreaseQty(Function callback) {
    ProxyService.keypad.decreaseQty();
    if (_currentItemStock != null) {
      keypad.setAmount(amount: _currentItemStock!.retailPrice * quantity);
    }
    callback(quantity);
  }

  /// setAmount is the amount shown on top of product when increasing the quantity

  void increaseQty({required Function callback, required bool custom}) {
    ProxyService.keypad.increaseQty(custom: custom);
    if (_currentItemStock != null) {
      keypad.setAmount(amount: _currentItemStock!.retailPrice * quantity);
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
    _currentItemStock = await ProxyService.realm
        .getStock(branchId: branchId, variantId: variantId);
  }

  Future<List<Variant>> getVariants({required int productId}) async {
    int branchId = ProxyService.box.getBranchId()!;
    _variants = await ProxyService.realm
        .variants(branchId: branchId, productId: productId);
    notifyListeners();
    return _variants;
  }

  Future<Variant?> getVariant({required int variantId}) async {
    return await ProxyService.realm.variant(variantId: variantId);
  }

  void toggleCheckbox({required int variantId}) {
    keypad.toggleCheckbox(variantId: variantId);
    rebuildUi();
  }

  List<ITransaction> transactions = [];
  void updateTransactionsList({required List<ITransaction> newTransactions}) {
    transactions.addAll(newTransactions);
  }

  Future<bool> saveCashBookTransaction(
      {required String cbTransactionType}) async {
    final transaction = await ProxyService.realm
        .manageTransaction(transactionType: TransactionType.custom);
    ITransaction cbTransaction = transaction;
    cbTransaction.cashReceived = cbTransaction.subTotal;
    cbTransaction.customerChangeDue = 0;
    cbTransaction.transactionType = cbTransactionType;
    cbTransaction.paymentType = "Cash";
    cbTransaction.status = 'completed';

    Category? activeCat = await ProxyService.realm
        .activeCategory(branchId: ProxyService.box.getBranchId()!);

    String? activeCatName = activeCat?.name;

    cbTransaction.categoryId = activeCatName;

    activeCat?.active = false;
    activeCat?.focused = false;
    await ProxyService.realm.update(data: activeCat);

    List<TransactionItem> cbTransactionItems = await ProxyService.realm
        .transactionItems(
            transactionId: cbTransaction.id!,
            doneWithTransaction: false,
            active: true);

    for (var item in cbTransactionItems) {
      item.doneWithTransaction = true;
      await ProxyService.realm.update(data: item);
    }
    List<ITransaction> tr = [];
    tr.add(cbTransaction);
    await ProxyService.realm.update(data: cbTransaction);
    updateTransactionsList(newTransactions: tr);
    notifyListeners();
    return Future<bool>.value(true);
  }

  Future<String> collectSPENNPayment(
      {required String phoneNumber,
      required double cashReceived,
      required String paymentType}) async {
    final transaction = await ProxyService.realm
        .manageTransaction(transactionType: TransactionType.custom);
    // await ProxyService.isar
    //     .spennPayment(amount: cashReceived, phoneNumber: phoneNumber);
    await ProxyService.realm.collectPayment(
        cashReceived: cashReceived,
        transaction: transaction,
        paymentType: paymentType);
    return "PaymentRecorded";
  }

  Future<void> collectPayment(
      {required String paymentType,
      required ITransaction transaction,
      required double amountReceived}) async {
    await ProxyService.realm.collectPayment(
      cashReceived: amountReceived,
      transaction: transaction,
      paymentType: paymentType,
    );
  }

  void registerLocation() async {
    final permission = await ProxyService.location.hasLocationPermission();
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
      required int transactionId,
      required String customerType,
      required String tinNumber}) {
    int branchId = ProxyService.box.getBranchId()!;
    ProxyService.realm.addCustomer(
        customer: Customer(
          ObjectId(),
          custNm: name,
          id: randomNumber(),
          action: AppActions.created,
          custTin: tinNumber,
          email: email,
          telNo: phone,
          updatedAt: DateTime.now(),
          branchId: branchId,
          custNo: randomNumber().toString().substring(0, 9),
          regrNm: randomNumber().toString().substring(0, 5),
          modrId: randomNumber().toString().substring(0, 5),
          regrId: randomNumber().toString().substring(0, 5),
          ebmSynced: false,
          tin: ProxyService.box.tin().toString(),
          modrNm: randomNumber().toString().substring(0, 5),
          bhfId: ProxyService.box.bhfId(),
          useYn: "N",
          customerType: customerType,
        ),
        transactionId: transactionId);
  }

  Future<void> assignToSale(
      {required int customerId, required int transactionId}) async {
    ProxyService.realm.assignCustomerToTransaction(
        customerId: customerId, transactionId: transactionId);
  }

  /// given a transactionId and a customer, remove the given customer from the
  /// given transaction
  Future<void> removeFromSale(
      {required int customerId, required int transactionId}) async {
    ProxyService.realm.removeCustomerFromTransaction(
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
    final currentTransaction = await ProxyService.realm
        .manageTransaction(transactionType: TransactionType.custom);
    ITransaction? transaction =
        await ProxyService.realm.getTransactionById(id: currentTransaction.id!);
    // Map map = transaction!;
    transaction!.note = note;
    ProxyService.realm.update(data: transaction);
    callback(1);
  }

  ///save ticket, this method take any existing pending transaction
  ///change status to parked, this allow the cashier to take another transaction of different client
  ///and resume this when he feel like he wants to,
  ///the note on transaction is served as display, therefore an transaction can not be parked without a note on it.
  void saveTicket(
      {required String ticketName,
      required String ticketNote,
      required ITransaction transaction}) async {
    transaction.status = PARKED;
    transaction.note = ticketNote;
    transaction.ticketName = ticketName;
    transaction.updatedAt = DateTime.now().toIso8601String();
    await ProxyService.realm.update(data: transaction);
  }

  Future resumeTransaction({required int ticketId}) async {
    ITransaction? _transaction =
        await ProxyService.realm.getTransactionById(id: ticketId);

    _transaction!.status = PENDING;
    await ProxyService.realm.update(data: _transaction);
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

    List<TransactionItem> items = await ProxyService.realm.transactionItems(
        transactionId: keypad.transaction!.id!,
        doneWithTransaction: false,
        active: true);

    num? totalPayable = items.fold(0, (a, b) => a! + (b.price * b.qty));

    num? totalDiscount = items.fold(0, (a, b) => a! + (b.discount.toInt()));

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
    await ProxyService.realm.delete(id: id, endPoint: 'transactionItem');

    updatePayable();

    return true;
  }

  /// this method is used to restore database from backup
  /// it return [1] if the restore was successful
  /// it return [2] if the restore was not successful and pass it for callback
  /// the UI can notify the user based on the return value
  void restoreBackUp(Function callback) async {
    if (ProxyService.remoteConfig.isBackupAvailable()) {
      Business? business = await ProxyService.realm.getBusiness();
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
      await drive.upload();
      callback(1);
    }
  }

  List<TransactionItem> transactionItems = [];

  void loadReport() async {
    int branchId = ProxyService.box.getBranchId()!;
    List<ITransaction> completedTransactions =
        await ProxyService.realm.completedTransactions(branchId: branchId);
    Set<TransactionItem> allItems = {};
    for (ITransaction completedTransaction in completedTransactions) {
      List<TransactionItem> transactionItems = await ProxyService.realm
          .getTransactionItemsByTransactionId(
              transactionId: completedTransaction.id);
      allItems.addAll(transactionItems.toSet());
    }
    transactionItems = allItems.toList();
    notifyListeners();
  }

  var _receiptReady = false;
  bool get receiptReady => _receiptReady;
  set receiptReady(bool value) {
    _receiptReady = value;
    notifyListeners();
  }

  List<ITransaction> _completedTransactions = [];
  List<ITransaction> get completedTransactionsList => _completedTransactions;
  set completedTransactionsList(List<ITransaction> value) {
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

  // check if the customer is attached to the transaction then can't be deleted
  // transaction need to be deleted or completed first.
  Future<void> deleteCustomer(int id, Function callback) async {
    final transaction = await ProxyService.realm
        .manageTransaction(transactionType: TransactionType.custom);
    if (transaction.customerId == null) {
      await ProxyService.realm.delete(id: id, endPoint: 'customer');
      callback("customer deleted");
    } else {
      callback("Customer is already attached to a transaction");
    }
  }

  /// This function gets the default tenant for the current user.
  ///
  /// The function first gets the user ID from the `ProxyService`.
  /// Then, it calls the `getTenantBYUserId` method on the `ProxyService` to get the tenant for the user ID.
  /// If the tenant is not found, the function throws an exception. because every default business owner should have
  /// one default tenant
  /// Finally, the function sets the tenant on the `app` object.

  void defaultBranch() async {
    final branch = await ProxyService.realm.activeBranch();

    app.setActiveBranch(branch: branch);
  }

  Future<void> setDefaultBusiness({required Business business}) async {
    app.setBusiness(business: business);
    List<Business> businesses = await ProxyService.realm
        .businesses(userId: ProxyService.box.getUserId()!);
    for (Business business in businesses) {
      await ProxyService.realm.update(data: business..isDefault = false);
    }
    ProxyService.realm.update(data: business..isDefault = true);
    ProxyService.box.writeInt(key: 'businessId', value: business.id!);
  }

  Future<void> setDefaultBranch({required Branch branch}) async {
    //first set other branch to not active
    List<Branch> branches = await ProxyService.realm
        .branches(businessId: ProxyService.box.getBusinessId());
    for (Branch branch in branches) {
      await ProxyService.realm.update(data: branch..isDefault = false);
    }
    ProxyService.realm.update(data: branch..isDefault = true);
    ProxyService.box.writeInt(key: 'branchId', value: branch.id!);
  }

  /// a method that listen on given tenantId and perform a sale to a POS
  /// this work with nfc card tapped on supported devices to perform sales
  /// []

  Future<void> sellWithCard(
      {required int tenantId, required ITransaction pendingTransaction}) async {
    Product? product =
        await ProxyService.realm.findProductByTenantId(tenantId: tenantId);

    clearPreviousSaleCounts();
    List<Variant> variants = await getVariants(productId: product!.id!);
    loadVariantStock(variantId: variants.first.id!);

    handleCustomQtySetBeforeSelectingVariation();

    keypad.setAmount(amount: variants.first.retailPrice * quantity);
    toggleCheckbox(variantId: variants.first.id!);
    increaseQty(callback: (quantity) {}, custom: true);
    Variant? variant = await ProxyService.realm.getVariantById(id: checked);
    Stock? stock =
        await ProxyService.realm.stockByVariantId(variantId: checked);
    await saveTransaction(
        variation: variant!,
        amountTotal: amountTotal,
        customItem: false,
        currentStock: stock!.currentStock,
        pendingTransaction: pendingTransaction);
  }

  List<Branch> branches = [];
  void branchesList(List<Branch> value) {
    branches = value;
    notifyListeners();
  }

  @override
  List<ListenableServiceMixin> get listenableServices =>
      [keypad, app, productService, settingService];

  Future<int> deleteTransactionByIndex(int transactionIndex) async {
    ITransaction? target = await getTransactionByIndex(transactionIndex);
    await ProxyService.realm
        .deleteTransactionByIndex(transactionIndex: transactionIndex);
    notifyListeners();

    if (target != null) {
      return target.id!;
    }
    return 403;
  }

  Future<ITransaction?> getTransactionByIndex(int transactionIndex) async {
    ITransaction? res =
        await ProxyService.realm.getTransactionById(id: transactionIndex);
    return res;
  }

  weakUp({required String pin, required int userId}) async {
    log(ProxyService.box.getUserId()!.toString(), name: 'weakUp');
    log('all matches', name: 'weakUp');
    ProxyService.realm.recordUserActivity(
      userId: userId,
      activity: 'session',
    );
    ProxyService.box.writeInt(key: 'userId', value: userId);
    Tenant? tenant = await ProxyService.realm.getTenantBYUserId(userId: userId);
    tenant?.sessionActive = true;
    ProxyService.realm.update(data: tenant);
  }

  Future<int> updateUserWithPinCode({required String pin}) async {
    Business? business = await ProxyService.realm
        .getBusiness(businessId: ProxyService.box.getBusinessId());

    /// set the pin for the current business default tenant
    // if (business != null) {
    /// get the default tenant
    await ProxyService.realm.getTenantBYUserId(
      userId: business.userId!,
    );
    // final response = await ProxyService.isar.update(
    //   data: User(
    //     id: tenant!.userId,
    //     phoneNumber: tenant.phoneNumber,
    //     pin: pin,
    //   ),
    // );
    // if (response == 200) {
    //   tenant.pin = int.tryParse(pin);
    //   ProxyService.isar.update(data: tenant);
    //   ProxyService.notification.sendLocalNotification(
    //       payload: Conversation(ObjectId(),
    //           userName: tenant.name,
    //           body: 'Pin has been added to your account successfully',
    //           avatar: "",
    //           channelType: "",
    //           messageId: randomNumber().toString(),
    //           createdAt: DateTime.now().toIso8601String(),
    //           fromNumber: tenant.phoneNumber,
    //           toNumber: tenant.phoneNumber,
    //           businessId: tenant.businessId));
    // }
    // return response;

    return 0;
  }
}
