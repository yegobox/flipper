// ignore_for_file: unused_result

library flipper_models;

import 'dart:async';
import 'dart:developer';

import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/_transaction.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/drive_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:realm/realm.dart';
import 'package:stacked/stacked.dart';

import 'mixins/all.dart';

class CoreViewModel extends FlipperBaseModel
    with Properties, SharebleMethods, TransactionMixin {
  bool handlingConfirm = false;
  Stream<List<AppNotification>> get notificationStream => ProxyService.local
      .notificationStream(identifier: ProxyService.box.getBranchId()!);

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

  // String get key => keypad.key;

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

  Future<bool> updateCategory({required Category category}) async {
    int branchId = ProxyService.box.getBranchId()!;

    try {
      await ProxyService.local.realm!.writeAsync(() {
        var allCategories = ProxyService.local.realm!
            .all<Category>()
            .where((cat) => cat.branchId == branchId);
        for (var cat in allCategories) {
          cat.focused = false;
          cat.active = false;
        }

        category.focused = true;
        category.active = true;
        category.branchId = branchId;
      });

      log("Updated category: ${category.name}, focused: ${category.focused}, active: ${category.active}");
      return true;
    } catch (e) {
      log("Error updating category: $e");
      return false;
    }
  }

  void keyboardKeyPressed(
      {required String key,
      required Function reset,
      required bool isExpense,
      String? transactionType = "Sale"}) {
    ITransaction? pendingTransaction = ProxyService.local.manageTransaction(
        branchId: ProxyService.box.getBranchId()!,
        transactionType: transactionType!,
        isExpense: isExpense);

    /// query for an item that is not active so we can edit it
    /// if the item is not available it will be created, if we are done with working with item
    /// we then change status of active from false to true
    List<TransactionItem> items = ProxyService.local.transactionItems(
        branchId: ProxyService.box.getBranchId()!,
        transactionId: pendingTransaction.id!,
        doneWithTransaction: false,
        active: false);

    switch (key) {
      case 'C':
        handleClearKey(items, pendingTransaction, reset);
        break;
      case '+':

        /// because we do not want to recoed expense to be part of transactions or sale
        /// so we do not record an item related to this transaction
        if (isExpense) return;
        ProxyService.local.realm!.write(() {
          for (TransactionItem item in items) {
            /// mark the item on the transaction as true so next time we will create new one
            /// instead of updating existing one
            item.active = true;
            // Wait for 500ms before updating the next item
          }
        });
        // ProxyService.keypad.reset();
        reset();

        break;
      default:

        /// because we do not want to recoed expense to be part of transactions or sale
        /// so we do not record an item related to this transaction
        if (isExpense) return;
        if (key.length == 1) {
          handleSingleDigitKey(items, pendingTransaction, double.parse(key));
        } else if (key.length > 1) {
          handleMultipleDigitKey(items, pendingTransaction, double.parse(key));
        }

        break;
    }
  }

  void handleClearKey(List<TransactionItem> items,
      ITransaction pendingTransaction, Function reset) async {
    try {
      if (items.isEmpty) {
        // ProxyService.keypad.reset();
        reset();
        return;
      }
      // ProxyService.keypad.reset();
      reset();
      TransactionItem itemToDelete = items.last;
      await ProxyService.local.delete(
          id: itemToDelete.id!,
          endPoint: 'transactionItem',
          flipperHttpClient: ProxyService.http);

      List<TransactionItem> updatedItems = await ProxyService.local
          .transactionItems(
              branchId: ProxyService.box.getBranchId()!,
              transactionId: pendingTransaction.id!,
              doneWithTransaction: false,
              active: true);
      ProxyService.local.realm!.write(() {
        pendingTransaction.subTotal =
            updatedItems.fold(0, (a, b) => a + (b.price * b.qty));
        pendingTransaction.updatedAt = DateTime.now().toIso8601String();
      });
      ITransaction? updatedTransaction = await ProxyService.local
          .getTransactionById(id: pendingTransaction.id!);
      keypad.setTransaction(updatedTransaction);
    } catch (e, s) {
      talker.error(e);
      talker.error(s);
    }
  }

  void handleSingleDigitKey(List<TransactionItem> items,
      ITransaction pendingTransaction, double amount) async {
    // double amount = double.parse(ProxyService.keypad.key);

    if (amount == 0) return;

    Variant? variation = await ProxyService.local.getCustomVariant(
        tinNumber: ProxyService.box.tin(),
        bhFId: ProxyService.box.bhfId() ?? "00",
        businessId: ProxyService.box.getBusinessId()!,
        branchId: ProxyService.box.getBranchId()!);
    if (variation == null) return;

    Stock? stock = await ProxyService.local.stockByVariantId(
        variantId: variation.id!, branchId: ProxyService.box.getBranchId()!);

    String name = variation.productName != 'Custom Amount'
        ? '${variation.productName}(${variation.name})'
        : variation.productName!;

    if (items.isEmpty) {
      TransactionItem newItem = TransactionItem(
        ObjectId(),
        id: randomNumber(),
        qty: 1,
        action: AppActions.created,
        price: amount,
        variantId: variation.id!,
        name: name,
        branchId: ProxyService.box.getBranchId(),
        discount: 0.0,
        prc: amount,
        doneWithTransaction: false,
        active: false,
        transactionId: pendingTransaction.id!,
        createdAt: DateTime.now().toString(),
        updatedAt: DateTime.now().toString(),
        isTaxExempted: variation.isTaxExempted,
        remainingStock: stock?.currentStock ?? 0 - 1,
      );
      newItem.action = AppActions.created;
      ProxyService.local.addTransactionItem(
        transaction: pendingTransaction,
        item: newItem,
        partOfComposite: false,
      );
    }
    keypad.setTransaction(pendingTransaction);
  }

  void handleMultipleDigitKey(List<TransactionItem> items,
      ITransaction pendingTransaction, double amount) async {
    // double amount = double.parse(ProxyService.keypad.key);
    Variant? variation = await ProxyService.local.getCustomVariant(
        tinNumber: ProxyService.box.tin(),
        bhFId: ProxyService.box.bhfId() ?? "00",
        businessId: ProxyService.box.getBusinessId()!,
        branchId: ProxyService.box.getBranchId()!);
    if (variation == null) return;

    if (items.isEmpty) {
      Stock? stock = await ProxyService.local.stockByVariantId(
          variantId: variation.id!, branchId: ProxyService.box.getBranchId()!);

      String name = variation.productName != 'Custom Amount'
          ? '${variation.productName}(${variation.name})'
          : variation.productName!;

      TransactionItem? existTransactionItem = await ProxyService.local
          .getTransactionItemByVariantId(
              variantId: variation.id!, transactionId: pendingTransaction.id);

      List<TransactionItem> items = ProxyService.local.transactionItems(
          branchId: ProxyService.box.getBranchId()!,
          transactionId: pendingTransaction.id!,
          doneWithTransaction: false,
          active: true);

      if (existTransactionItem != null) {
        await ProxyService.local.realm!.writeAsync(() {
          existTransactionItem.qty = existTransactionItem.qty + 1;
          existTransactionItem.price = amount;
          existTransactionItem.prc = amount;

          pendingTransaction.subTotal =
              items.fold(0, (a, b) => a + (b.price * b.qty) + amount);
          pendingTransaction.updatedAt = DateTime.now().toIso8601String();
        });
      } else {
        TransactionItem newItem = TransactionItem(
          ObjectId(),
          id: randomNumber(),
          qty: 1,
          action: AppActions.created,
          price: amount,
          variantId: variation.id!,
          name: name,
          branchId: ProxyService.box.getBranchId(),
          discount: 0.0,
          prc: amount,
          doneWithTransaction: false,
          active: false,
          transactionId: pendingTransaction.id!,
          createdAt: DateTime.now().toString(),
          updatedAt: DateTime.now().toString(),
          isTaxExempted: variation.isTaxExempted,
          remainingStock: stock?.currentStock ?? 0 - 1,
        );

        List<TransactionItem> items = ProxyService.local.transactionItems(
            branchId: ProxyService.box.getBranchId()!,
            transactionId: pendingTransaction.id!,
            doneWithTransaction: false,
            active: true);
        ProxyService.local.addTransactionItem(
          transaction: pendingTransaction,
          item: newItem,
          partOfComposite: false,
        );

        await ProxyService.local.realm!.writeAsync(() {
          pendingTransaction.subTotal =
              items.fold(0, (a, b) => a + (b.price * b.qty) + amount);
          pendingTransaction.updatedAt = DateTime.now().toIso8601String();
          newItem.action = AppActions.created;
        });
      }
    } else {
      await ProxyService.local.realm!.writeAsync(() {
        TransactionItem item = items.last;
        item.price = amount;
        item.taxAmt = double.parse((amount * 18 / 118).toStringAsFixed(2));

        pendingTransaction.subTotal =
            items.fold(0, (a, b) => a + (b.price * b.qty));
        pendingTransaction.updatedAt = DateTime.now().toIso8601String();
      });
      ITransaction? updatedTransaction = await ProxyService.local
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

    await ProxyService.local.create(data: category);
    app.loadCategories();
  }

  ///list products availabe for sell
  Future<List<Product>> products() async {
    int branchId = ProxyService.box.getBranchId()!;
    return await ProxyService.local.productsFuture(branchId: branchId);
  }

  Business get businesses => app.business;

  Branch? get branch => app.branch;

  // void pop() {
  //   ProxyService.keypad.pop();
  // }

  // void reset() {
  //   ProxyService.keypad.reset();
  // }

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
    _currentItemStock = await ProxyService.local
        .getStock(branchId: branchId, variantId: variantId);
  }

  Future<List<Variant>> getVariants({required int productId}) async {
    int branchId = ProxyService.box.getBranchId()!;
    _variants = await ProxyService.local
        .variants(branchId: branchId, productId: productId);
    notifyListeners();
    return _variants;
  }

  Future<Variant?> getVariant({required int variantId}) async {
    return await ProxyService.local.variant(variantId: variantId);
  }

  void toggleCheckbox({required int variantId}) {
    keypad.toggleCheckbox(variantId: variantId);
    rebuildUi();
  }

  List<ITransaction> transactions = [];

  Future<String> collectSPENNPayment(
      {required String phoneNumber,
      required double cashReceived,
      required String paymentType,
      String? categoryId,
      required String transactionType,
      required double discount}) async {
    final transaction = await ProxyService.local.manageTransaction(
        branchId: ProxyService.box.getBranchId()!,
        transactionType: TransactionType.sale,
        isExpense: false);

    await ProxyService.local.collectPayment(
        branchId: ProxyService.box.getBranchId()!,
        isProformaMode: ProxyService.box.isProformaMode(),
        isTrainingMode: ProxyService.box.isTrainingMode(),
        bhfId: ProxyService.box.bhfId() ?? "00",
        cashReceived: cashReceived,
        transaction: transaction,
        categoryId: categoryId,
        transactionType: transactionType,
        paymentType: paymentType,
        isIncome: true,
        discount: discount);
    return "PaymentRecorded";
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
    ProxyService.local.addCustomer(
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
          tin: ProxyService.box.tin(),
          modrNm: randomNumber().toString().substring(0, 5),
          bhfId: ProxyService.box.bhfId() ?? "00",
          useYn: "N",
          customerType: customerType,
        ),
        transactionId: transactionId);
  }

  void assignToSale({required int customerId, required int transactionId}) {
    ProxyService.local.assignCustomerToTransaction(
        customerId: customerId, transactionId: transactionId);
  }

  /// given a transactionId and a customer, remove the given customer from the
  /// given transaction
  Future<void> removeFromSale({required ITransaction transaction}) async {
    ProxyService.local.removeCustomerFromTransaction(transaction: transaction);
  }

  /// as of when one sale is complete trying to sell second product
  /// the previous Qty and totalAmount where still visible in header which confuses
  /// this is to reset the value for a new sale to come!
  void clearPreviousSaleCounts() {
    keypad.setAmount(amount: 0);
    keypad.increaseQty(custom: true, qty: 1);
  }

  void addNoteToSale({required String note, required Function callback}) async {
    final currentTransaction = await ProxyService.local.manageTransaction(
        branchId: ProxyService.box.getBranchId()!,
        transactionType: TransactionType.sale,
        isExpense: false);
    ITransaction? transaction =
        await ProxyService.local.getTransactionById(id: currentTransaction.id!);
    // Map map = transaction!;
    ProxyService.local.realm!.write(() {
      transaction!.note = note;
    });
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
    ProxyService.local.realm!.write(() {
      transaction.status = PARKED;
      transaction.note = ticketNote;
      transaction.ticketName = ticketName;
      transaction.updatedAt = DateTime.now().toIso8601String();
    });
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

    List<TransactionItem> items = ProxyService.local.transactionItems(
        branchId: ProxyService.box.getBranchId()!,
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
    await ProxyService.local.delete(
        id: id,
        endPoint: 'transactionItem',
        flipperHttpClient: ProxyService.http);

    updatePayable();

    return true;
  }

  /// this method is used to restore database from backup
  /// it return [1] if the restore was successful
  /// it return [2] if the restore was not successful and pass it for callback
  /// the UI can notify the user based on the return value
  void restoreBackUp(Function callback) async {
    if (ProxyService.remoteConfig.isBackupAvailable()) {
      Business? business = await ProxyService.local.getBusiness();
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
        await ProxyService.local.completedTransactions(branchId: branchId);
    Set<TransactionItem> allItems = {};
    for (ITransaction completedTransaction in completedTransactions) {
      List<TransactionItem> transactionItems = await ProxyService.local
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
    final transaction = await ProxyService.local.manageTransaction(
        branchId: ProxyService.box.getBranchId()!,
        transactionType: TransactionType.sale,
        isExpense: false);
    if (transaction.customerId == null) {
      await ProxyService.local.delete(
          id: id, endPoint: 'customer', flipperHttpClient: ProxyService.http);
      callback("customer deleted");
    } else {
      /// first detach the customer from trans
      ProxyService.local.realm!.write(() {
        transaction.customerId = null;
        ProxyService.local.delete(
            id: id, endPoint: 'customer', flipperHttpClient: ProxyService.http);
      });
      callback("customer deleted");
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
    final branch = await ProxyService.local.activeBranch();

    app.setActiveBranch(branch: branch);
  }

  /// a method that listen on given tenantId and perform a sale to a POS
  /// this work with nfc card tapped on supported devices to perform sales
  /// []

  Future<void> sellWithCard(
      {required int tenantId, required ITransaction pendingTransaction}) async {
    Product? product =
        await ProxyService.local.findProductByTenantId(tenantId: tenantId);

    clearPreviousSaleCounts();
    List<Variant> variants = await getVariants(productId: product!.id!);
    loadVariantStock(variantId: variants.first.id!);

    handleCustomQtySetBeforeSelectingVariation();

    keypad.setAmount(amount: variants.first.retailPrice * quantity);
    toggleCheckbox(variantId: variants.first.id!);
    increaseQty(callback: (quantity) {}, custom: true);
    Variant? variant = ProxyService.local.getVariantById(id: checked);
    Stock? stock = await ProxyService.local.stockByVariantId(
        variantId: checked, branchId: ProxyService.box.getBranchId()!);
    await saveTransaction(
        partOfComposite: false,
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
    await ProxyService.local
        .deleteTransactionByIndex(transactionIndex: transactionIndex);
    notifyListeners();

    if (target != null) {
      return target.id!;
    }
    return 403;
  }

  Future<ITransaction?> getTransactionByIndex(int transactionIndex) async {
    ITransaction? res =
        await ProxyService.local.getTransactionById(id: transactionIndex);
    return res;
  }

  weakUp({required String pin, required int userId}) async {
    ProxyService.local.recordUserActivity(
      userId: userId,
      activity: 'session',
    );
    ProxyService.box.writeInt(key: 'userId', value: userId);
    Tenant? tenant = await ProxyService.local.getTenantBYUserId(userId: userId);
    ProxyService.local.realm!.writeAsync(() async {
      tenant?.sessionActive = true;
    });
  }

  Future<int> updateUserWithPinCode({required String pin}) async {
    Business? business = await ProxyService.local
        .getBusiness(businessId: ProxyService.box.getBusinessId());

    /// set the pin for the current business default tenant
    // if (business != null) {
    /// get the default tenant
    await ProxyService.local.getTenantBYUserId(
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
