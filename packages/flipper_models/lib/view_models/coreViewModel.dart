// ignore_for_file: unused_result

library flipper_models;

import 'dart:async';
import 'dart:developer';

import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/_transaction.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/drive_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:stacked/stacked.dart';
import 'package:flipper_models/db_model_export.dart' as brick;
import 'mixins/all.dart';

// Constants for magic values
class PurchaseConstants {
  static const String purchaseReceiptType = "P";
  static const String countryCode = "RW";
  static const String productType = "2";
  static const String packagingUnit = "CT";
  static const String quantityUnit = "BJ";
  static const String defaultBranchId = "00";
}

// Custom exceptions
class PurchaseAcceptanceException implements Exception {
  final String message;
  final Exception? originalException;

  PurchaseAcceptanceException(this.message, [this.originalException]);

  @override
  String toString() => originalException != null
      ? 'PurchaseAcceptanceException: $message (Original: ${originalException})'
      : 'PurchaseAcceptanceException: $message';
}

class TaxReportingException extends PurchaseAcceptanceException {
  TaxReportingException(String message, [Exception? originalException])
      : super(message, originalException);
}

class CoreViewModel extends FlipperBaseModel
    with Properties, SharebleMethods, TransactionMixinOld {
  bool handlingConfirm = false;
  // Stream<List<AppNotification>> get notificationStream => ProxyService.strategy
  //     .notificationStream(identifier: ProxyService.box.getBranchId()!);

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

  String get checked => keypad.check;

  bool get groupValue => true;

  get quantity => keypad.quantity;

  Variant? _currentItemStock;

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

  Future<bool> updateCategoryCore({required Category category}) async {
    int branchId = ProxyService.box.getBranchId()!;

    try {
      List<Category> allCategories = await ProxyService.strategy.categories(
        branchId: branchId,
      );
      for (var cat in allCategories) {
        ProxyService.strategy.updateCategory(
            categoryId: cat.id,
            focused: false,
            active: false,
            branchId: branchId);
      }

      ProxyService.strategy.updateCategory(
          categoryId: category.id,
          focused: true,
          active: true,
          branchId: branchId);

      log("Updated category: ${category.name}, focused: ${category.focused}, active: ${category.active}");
      return true;
    } catch (e) {
      log("Error updating category: $e");
      return false;
    }
  }

  Future<void> keyboardKeyPressed(
      {required String key,
      required Function reset,
      required bool isExpense,
      String? transactionType = "Sale"}) async {
    ITransaction? pendingTransaction = await ProxyService.strategy
        .manageTransaction(
            branchId: ProxyService.box.getBranchId()!,
            transactionType: transactionType!,
            isExpense: isExpense);

    /// query for an item that is not active so we can edit it
    /// if the item is not available it will be created, if we are done with working with item
    /// we then change status of active from false to true
    List<TransactionItem> items = await ProxyService.strategy.transactionItems(
        branchId: (await ProxyService.strategy.activeBranch()).id,
        transactionId: pendingTransaction?.id,
        doneWithTransaction: false,
        active: false);

    switch (key) {
      case 'C':
        handleClearKey(items, pendingTransaction, reset);
        break;
      case '+':

        /// because we do not want to record expense to be part of transactions or sale
        /// so we do not record an item related to this transaction
        if (isExpense) return;

        for (TransactionItem item in items) {
          item.active = true;
          ProxyService.strategy.updateTransactionItem(
            transactionItemId: item.id,
            ignoreForReport: false,
            active: true,
          );
        }

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
      ITransaction? pendingTransaction, Function reset) async {
    try {
      if (items.isEmpty) {
        // ProxyService.keypad.reset();
        reset();
        return;
      }
      // ProxyService.keypad.reset();
      reset();
      TransactionItem itemToDelete = items.last;
      await ProxyService.strategy.flipperDelete(
          id: itemToDelete.id,
          endPoint: 'transactionItem',
          flipperHttpClient: ProxyService.http);

      List<TransactionItem> updatedItems = await ProxyService.strategy
          .transactionItems(
              branchId: (await ProxyService.strategy.activeBranch()).id,
              transactionId: pendingTransaction?.id,
              doneWithTransaction: false,
              active: true);

      ProxyService.strategy.updateTransaction(
        transaction: pendingTransaction,
        subTotal: updatedItems.fold(0, (a, b) => a! + (b.price * b.qty)),
      );
      ITransaction? updatedTransaction =
          (await ProxyService.strategy.transactions(id: pendingTransaction?.id))
              .firstOrNull;
      keypad.setTransaction(updatedTransaction);
    } catch (e, s) {
      talker.error(e);
      talker.error(s);
    }
  }

  void handleSingleDigitKey(List<TransactionItem> items,
      ITransaction? pendingTransaction, double amount) async {
    // double amount = double.parse(ProxyService.keypad.key);

    if (amount == 0) return;

    Variant? variation = await ProxyService.strategy.getCustomVariant(
        tinNumber: ProxyService.box.tin(),
        bhFId: (await ProxyService.box.bhfId()) ?? "00",
        businessId: ProxyService.box.getBusinessId()!,
        branchId: ProxyService.box.getBranchId()!);
    if (variation == null) return;

    String name = variation.productName != 'Custom Amount'
        ? '${variation.productName}(${variation.name})'
        : variation.productName!;

    if (items.isEmpty) {
      ProxyService.strategy.addTransactionItem(
        transaction: pendingTransaction,
        lastTouched: DateTime.now().toUtc(),
        discount: 0.0,
        ignoreForReport: false,
        compositePrice: 0.0,
        quantity: quantity.toInt(),
        currentStock: variation.stock?.currentStock ?? 0 - 1,
        partOfComposite: false,
        variation: variation,
        name: name,
        amountTotal: amountTotal,
      );
    }
    keypad.setTransaction(pendingTransaction);
  }

  void handleMultipleDigitKey(List<TransactionItem> items,
      ITransaction? pendingTransaction, double amount) async {
    // double amount = double.parse(ProxyService.keypad.key);
    Variant? variation = await ProxyService.strategy.getCustomVariant(
        tinNumber: ProxyService.box.tin(),
        bhFId: (await ProxyService.box.bhfId()) ?? "00",
        businessId: ProxyService.box.getBusinessId()!,
        branchId: ProxyService.box.getBranchId()!);
    if (variation == null) return;

    if (items.isEmpty) {
      String name = variation.productName != 'Custom Amount'
          ? '${variation.productName}(${variation.name})'
          : variation.productName!;

      TransactionItem? existTransactionItem = await ProxyService.strategy
          .getTransactionItem(
              variantId: variation.id, transactionId: pendingTransaction?.id);

      List<TransactionItem> items = await ProxyService.strategy
          .transactionItems(
              branchId: (await ProxyService.strategy.activeBranch()).id,
              transactionId: pendingTransaction?.id,
              doneWithTransaction: false,
              active: true);

      if (existTransactionItem != null) {
        ProxyService.strategy.updateTransactionItem(
          transactionItemId: existTransactionItem.id,
          qty: existTransactionItem.qty + 1,
          price: amount,
          ignoreForReport: false,
          prc: amount,
        );
        ProxyService.strategy.updateTransaction(
          transaction: pendingTransaction,
          subTotal: items.fold(0, (a, b) => a! + (b.price * b.qty) + amount),
        );
      } else {
        List<TransactionItem> items = await ProxyService.strategy
            .transactionItems(
                branchId: (await ProxyService.strategy.activeBranch()).id,
                transactionId: pendingTransaction?.id,
                doneWithTransaction: false,
                active: true);
        ProxyService.strategy.addTransactionItem(
          transaction: pendingTransaction,
          lastTouched: DateTime.now().toUtc(),
          discount: 0.0,
          ignoreForReport: false,
          compositePrice: 0.0,
          quantity: 1,
          currentStock: variation.stock?.currentStock ?? 0 - 1,
          partOfComposite: false,
          variation: variation,
          name: name,
          amountTotal: amountTotal,
        );

        await ProxyService.strategy.updateTransaction(
          transaction: pendingTransaction,
          subTotal: items.fold(0, (a, b) => a! + (b.price * b.qty) + amount),
        );
      }
    } else {
      await ProxyService.strategy.updateTransactionItem(
        transactionItemId: items.last.id,
        ignoreForReport: false,
        taxAmt: double.parse((amount * 18 / 118).toStringAsFixed(2)),
        price: amount,
        prc: double.parse((amount * 18 / 118).toStringAsFixed(2)),
      );

      await ProxyService.strategy.updateTransaction(
        transaction: pendingTransaction,
        subTotal: items.fold(0, (a, b) => a! + (b.price * b.qty)),
      );
      ITransaction? updatedTransaction =
          (await ProxyService.strategy.transactions(id: pendingTransaction?.id))
              .firstOrNull;
      keypad.setTransaction(updatedTransaction);
    }
  }

  /// the function is useful on completing a sale since we need to look for this past transaction
  /// to add customer etc... we can not use getTransactions as it was a general function for all completed functions
  /// but this will be generic for this given transaction saved in a box it is very important to reach to collect cash screen
  /// for the initation of writing this transactionId in a box for later use!.
  Future<void> getTransactionById() async {
    String? id = ProxyService.box.transactionId();

    await ProxyService.keypad.getTransactionById(id: id);
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
    final Category category = Category(
      name: categoryName!,
      active: true,
      focused: false,
      branchId: branchId!,
    );

    await ProxyService.strategy.create(data: category);
    app.loadCategories();
  }

  Business get businesses => app.business;

  Branch? get branch => app.branch;

  Future<void> handleCustomQtySetBeforeSelectingVariation() async {
    ProxyService.keypad.decreaseQty();

    if (_currentItemStock != null) {
      keypad.setAmount(
          amount: (_currentItemStock?.retailPrice ?? 0) * quantity);
    }
  }

  /// setAmount is the amount shown on top of product when increasing the quantity
  Future<void> customQtyIncrease(double quantity) async {
    ProxyService.keypad.increaseQty(custom: true, qty: quantity);

    if (_currentItemStock != null) {
      keypad.setAmount(
          amount: (_currentItemStock?.retailPrice ?? 0) * quantity);
    }
  }

  /// We take _variantsStocks[0] because we know
  Future<void> decreaseQty(Function callback) async {
    ProxyService.keypad.decreaseQty();

    if (_currentItemStock != null) {
      keypad.setAmount(
          amount: (_currentItemStock?.retailPrice ?? 0) * quantity);
    }
    callback(quantity);
  }

  /// setAmount is the amount shown on top of product when increasing the quantity

  Future<void> increaseQty(
      {required Function callback, required bool custom}) async {
    ProxyService.keypad.increaseQty(custom: custom);
    ProxyService.keypad.decreaseQty();

    if (_currentItemStock != null) {
      keypad.setAmount(
          amount: (_currentItemStock?.retailPrice ?? 0) * quantity);
      rebuildUi();
    }
    callback(keypad.quantity);
  }

  /// setAmount is the amount shown on top of product when increasing the quantity
  void setAmount({required double amount}) {
    ProxyService.keypad.setAmount(amount: amount);
  }

  void loadVariantStock({required String variantId}) async {
    _currentItemStock = await ProxyService.strategy.getVariant(id: variantId);
  }

  Future<List<Variant>> getVariants({required String productId}) async {
    int branchId = ProxyService.box.getBranchId()!;
    _variants = await ProxyService.strategy.variants(
        branchId: branchId,
        productId: productId,
        taxTyCds: ProxyService.box.vatEnabled() ? ['A', 'B', 'C'] : ['D']);
    notifyListeners();
    return _variants;
  }

  // Future<Variant?> getVariant({required String variantId}) async {
  //   return (await ProxyService.strategy.variants(
  //           taxTyCds: ProxyService.box.vatEnabled() ? ['A', 'B', 'C'] : ['D'],
  //           variantId: variantId,
  //           branchId: ProxyService.box.getBranchId()!))
  //       .firstOrNull;
  // }

  void toggleCheckbox({required String variantId}) {
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
    final transaction = await ProxyService.strategy.manageTransaction(
        branchId: ProxyService.box.getBranchId()!,
        transactionType: TransactionType.sale,
        isExpense: false);

    await ProxyService.strategy.collectPayment(
        countryCode: "N/A",
        branchId: ProxyService.box.getBranchId()!,
        isProformaMode: ProxyService.box.isProformaMode(),
        isTrainingMode: ProxyService.box.isTrainingMode(),
        bhfId: await ProxyService.box.bhfId() ?? "00",
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

  Future<void> addCustomer(
      {required String email,
      required String phone,
      required String name,
      required String transactionId,
      required String customerType,
      String? id,
      String? tinNumber}) async {
    int branchId = ProxyService.box.getBranchId()!;
    ProxyService.strategy.addCustomer(
        customer: Customer(
          id: id,
          custNm: name,
          custTin: tinNumber ?? phone,
          email: email,
          telNo: phone,
          updatedAt: DateTime.now().toUtc(),
          branchId: branchId,
          custNo: tinNumber ?? phone,
          regrNm: randomNumber().toString().substring(0, 5),
          modrId: randomNumber().toString().substring(0, 5),
          regrId: randomNumber().toString().substring(0, 5),
          ebmSynced: false,
          modrNm: randomNumber().toString().substring(0, 5),
          bhfId: await ProxyService.box.bhfId() ?? "00",
          useYn: "N",
          customerType: customerType,
        ),
        transactionId: transactionId);
  }

  void assignToSale(
      {required String customerId, required String transactionId}) {
    ProxyService.strategy.assignCustomerToTransaction(
        customerId: customerId, transactionId: transactionId);
  }

  /// given a transactionId and a customer, remove the given customer from the
  /// given transaction
  Future<void> removeFromSale({required ITransaction transaction}) async {
    ProxyService.strategy
        .removeCustomerFromTransaction(transaction: transaction);
  }

  /// as of when one sale is complete trying to sell second product
  /// the previous Qty and totalAmount where still visible in header which confuses
  /// this is to reset the value for a new sale to come!
  void clearPreviousSaleCounts() {
    keypad.setAmount(amount: 0);
    keypad.increaseQty(custom: true, qty: 1);
  }

  void addNoteToSale({required String note, required Function callback}) async {
    final currentTransaction = await ProxyService.strategy.manageTransaction(
        branchId: ProxyService.box.getBranchId()!,
        transactionType: TransactionType.sale,
        isExpense: false);
    ITransaction? transaction =
        (await ProxyService.strategy.transactions(id: currentTransaction?.id))
            .firstOrNull;

    ProxyService.strategy.updateTransaction(
      transaction: transaction!,
      note: note,
    );
    callback(1);
  }

  ///save ticket, this method take any existing pending transaction
  ///change status to parked, this allow the cashier to take another transaction of different client
  ///and resume this when he feel like he wants to,
  ///the note on transaction is served as display, therefore an transaction can not be parked without a note on it.
  Future<void> saveTicket(
      {required String ticketName,
      required String ticketNote,
      required ITransaction transaction,
      String? customerId}) async {
    // Only park if a ticket name is provided.
    if (ticketName.isNotEmpty) {
      // If a customer is attached, check if they already have a parked ticket.
      if (customerId != null) {
        final existingParkedTransactions =
            await ProxyService.strategy.transactions(
          customerId: customerId,
          status: PARKED,
        );

        if (existingParkedTransactions.isNotEmpty) {
          final existingTransaction = existingParkedTransactions.first;

          // Merge the new transaction into the existing one.
          await ProxyService.strategy.mergeTransactions(
            from: transaction,
            to: existingTransaction,
          );

          // Create a new pending transaction for the next sale.
          // await newTransaction(typeOfThisTransactionIsExpense: false);
          ProxyService.strategy.manageTransaction(
            branchId: ProxyService.box.getBranchId()!,
            transactionType: SALE,
            isExpense: true,
          );
          return; // End execution.
        }
      }

      // If no customer or no existing parked ticket, park the current transaction as new.
      final items = await ProxyService.strategy
          .transactionItems(transactionId: transaction.id);
      await ProxyService.strategy.updateTransaction(
        transaction: transaction,
        status: PARKED,
        note: ticketNote,
        ticketName: ticketName,
        customerId: customerId,
        subTotal:
            items.fold(0.0, (sum, item) => sum! + (item.price * item.qty)),
        updatedAt: DateTime.now().toUtc(),
      );

      // Create a new pending transaction for the next sale.
      ProxyService.strategy.manageTransaction(
        branchId: ProxyService.box.getBranchId()!,
        transactionType: SALE,
        isExpense: true,
      );
    }
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

    List<TransactionItem> items = await ProxyService.strategy.transactionItems(
        branchId: (await ProxyService.strategy.activeBranch()).id,
        transactionId: keypad.transaction!.id,
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
      {required String id, required BuildContext context}) async {
    await ProxyService.strategy.flipperDelete(
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
      Business? business = await ProxyService.strategy
          .getBusiness(businessId: ProxyService.box.getBusinessId()!);
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
    List<ITransaction> completedTransactions = await ProxyService.strategy
        .transactions(branchId: branchId, status: COMPLETE);
    Set<TransactionItem> allItems = {};
    for (ITransaction completedTransaction in completedTransactions) {
      List<TransactionItem> transactionItems = await ProxyService.strategy
          .transactionItems(
              branchId: (await ProxyService.strategy.activeBranch()).id,
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
  Future<void> deleteCustomer(String id, Function callback) async {
    final transaction = await ProxyService.strategy.manageTransaction(
        branchId: ProxyService.box.getBranchId()!,
        transactionType: TransactionType.sale,
        isExpense: false);
    if (transaction?.customerId == null) {
      await ProxyService.strategy.flipperDelete(
          id: id, endPoint: 'customer', flipperHttpClient: ProxyService.http);
      callback("customer deleted");
    } else {
      /// first detach the customer from trans
      ProxyService.strategy
          .updateTransaction(transaction: transaction, customerId: null);
      ProxyService.strategy.flipperDelete(
          id: id, endPoint: 'customer', flipperHttpClient: ProxyService.http);

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
    final branch = await ProxyService.strategy.activeBranch();

    app.setActiveBranch(branch: branch);
  }

  /// a method that listen on given tenantId and perform a sale to a POS
  /// this work with nfc card tapped on supported devices to perform sales
  /// []

  Future<void> sellWithCard(
      {required String tenantId,
      required ITransaction pendingTransaction}) async {
    Product? product =
        await ProxyService.strategy.findProductByTenantId(tenantId: tenantId);

    clearPreviousSaleCounts();
    List<Variant> variants = await getVariants(productId: product!.id);
    loadVariantStock(variantId: variants.first.id);

    handleCustomQtySetBeforeSelectingVariation();

    keypad.setAmount(amount: variants.first.retailPrice! * quantity);
    toggleCheckbox(variantId: variants.first.id);
    increaseQty(callback: (quantity) {}, custom: true);
    Variant? variant = await ProxyService.strategy.getVariant(id: checked);

    await ProxyService.strategy.saveTransactionItem(
        partOfComposite: false,
        doneWithTransaction: false,
        variation: variant!,
        ignoreForReport: false,
        amountTotal: amountTotal,
        customItem: false,
        currentStock: variant.stock!.currentStock!,
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

  Future<String> deleteTransactionByIndex(String transactionIndex) async {
    ITransaction? target = await getTransactionByIndex(transactionIndex);
    await ProxyService.strategy
        .deleteTransactionByIndex(transactionIndex: transactionIndex);
    notifyListeners();

    if (target != null) {
      return target.id;
    }
    return "403";
  }

  Future<ITransaction?> getTransactionByIndex(String transactionIndex) async {
    ITransaction? res =
        (await ProxyService.strategy.transactions(id: transactionIndex))
            .firstOrNull;
    return res;
  }

  weakUp({required String pin, required int userId}) async {
    // ProxyService.strategy.recordUserActivity(
    //   userId: userId,
    //   activity: 'session',
    // );
    ProxyService.box.writeInt(key: 'userId', value: userId);
    Tenant? tenant = await ProxyService.strategy.getTenant(userId: userId);

    ProxyService.strategy.updateTenant(
        tenantId: tenant!.id,
        sessionActive: true,
        branchId: ProxyService.box.getBranchId()!);
  }

  Future<int> updateUserWithPinCode({required String pin}) async {
    Business? business = await ProxyService.strategy
        .getBusiness(businessId: ProxyService.box.getBusinessId());

    /// set the pin for the current business default tenant
    // if (business != null) {
    /// get the default tenant
    await ProxyService.strategy.getTenant(
      userId: business!.userId!,
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
    //       payload: Conversation(
    //           userName: tenant.name,
    //           body: 'Pin has been added to your account successfully',
    //           avatar: "",
    //           channelType: "",
    //           messageId: randomNumber().toString(),
    //           createdAt: DateTime.now().toUtc(),
    //           fromNumber: tenant.phoneNumber,
    //           toNumber: tenant.phoneNumber,
    //           businessId: tenant.businessId));
    // }
    // return response;

    return 0;
  }

  DateTime selectedDate = DateTime.now();
  Future<RwApiResponse>? futureImportResponse;
  Future<RwApiResponse>? futurePurchaseResponse;
  bool isLoading = false;
  List<Purchase> salesList = [];
  List<Variant>? rwResponse;

  String convertDateToString(DateTime date) {
    final outputFormat = DateFormat('yyyyMMddHHmmss');
    return outputFormat.format(date);
  }

  Future<List<Variant>> fetchImportData({
    required bool isImport,
  }) async {
    isLoading = true;
    notifyListeners();

    brick.Business? business = await ProxyService.strategy
        .getBusiness(businessId: ProxyService.box.getBusinessId()!);

    final data = await ProxyService.strategy.selectImportItems(
      tin: business?.tinNumber ?? ProxyService.box.tin(),
      bhfId: (await ProxyService.box.bhfId()) ?? "00",
    );

    rwResponse = data;

    isLoading = false;
    notifyListeners();
    return data;
  }

  Future<List<Purchase>> fetchPurchaseData({
    required DateTime selectedDate,
    required bool isImport,
  }) async {
    isLoading = true;
    notifyListeners();
    final url = await ProxyService.box.getServerUrl();
    final rwResponse = await ProxyService.tax.selectTrnsPurchaseSales(
      URI: url!,
      tin: ProxyService.box.tin(),
      bhfId: (await ProxyService.box.bhfId()) ?? "00",
      lastReqDt: convertDateToString(selectedDate),
    );

    salesList = rwResponse.data?.saleList ?? [];
    isLoading = false;
    notifyListeners();
    return rwResponse.data?.saleList ?? [];
  }

  Future<void> acceptPurchase({
    @deprecated required List<Purchase> purchases,
    required String pchsSttsCd,
    Map<String, Variant>? itemMapper,
    required Purchase purchase,
    Variant? clickedVariant,
  }) async {
    try {
      _setLoading(true);
      talker.debug("Starting purchase acceptance for ${purchase.id}");

      final business = await _getBusiness();
      await _reportPurchaseToTaxService(purchase, business, pchsSttsCd);

      if (_shouldProcessMappings(pchsSttsCd, itemMapper)) {
        await _handleVariantMappings(itemMapper!, purchase);
      }
      await _processPurchaseVariants(
          purchase: purchase, pchsSttsCd: pchsSttsCd, itemMapper: itemMapper);

      _setLoading(false);
      talker.info("Successfully processed purchase ${purchase.id}");
    } catch (e, s) {
      _handlePurchaseError(e, s);
      throw PurchaseAcceptanceException("Failed to accept purchase",
          e is Exception ? e : Exception(e.toString()));
    }
  }

  Future<void> _processPurchaseVariants({
    required Purchase purchase,
    required String pchsSttsCd,
    required Map<String, Variant>? itemMapper,
  }) async {
    for (final purchaseVariant in purchase.variants!) {
      final originalStatus = purchaseVariant.pchsSttsCd;
      final isMapped =
          itemMapper?.values.any((v) => v.id == purchaseVariant.id) ?? false;

      // Skip already handled variants
      if (originalStatus == "02" ||
          originalStatus == "03" ||
          originalStatus == "04") {
        talker.debug(
            "Skipping already-processed variant: ${purchaseVariant.name} (status: $originalStatus)");
        continue;
      }

      talker.debug(
          "Processing variant: ${purchaseVariant.name} (${purchaseVariant.id})");
      talker.debug(
          " - Incoming status: $pchsSttsCd, Original status: $originalStatus, isMapped: $isMapped");

      bool shouldPersist = false;

      if (pchsSttsCd == "02" && !isMapped) {
        // Treat as new variant
        purchaseVariant.assigned = false;
        purchaseVariant.pchsSttsCd = "02";

        await _processNewVariant(purchaseVariant, purchase, updateIo: false);

        // No need to call updateVariant here because _processNewVariant does it
      } else if (pchsSttsCd == "04") {
        // Reject variant
        purchaseVariant.assigned = true;
        purchaseVariant.pchsSttsCd = "04";
        shouldPersist = true;
      } else {
        // Other status updates not handled by _processNewVariant
        purchaseVariant.pchsSttsCd = pchsSttsCd;
        shouldPersist = true;
      }

      // Persist updates if not handled by _processNewVariant
      if (shouldPersist) {
        await ProxyService.strategy.updateVariant(
          updatables: [purchaseVariant],
          updateIo: false,
        );
      }

      // Optionally update local UI or memory-only state
    }
  }

  Future<void> _processNewVariant(Variant variant, Purchase purchase,
      {required bool updateIo}) async {
    // Default values in case we can't extract from itemCd
    String countryCode = PurchaseConstants.countryCode;
    String productType = PurchaseConstants.productType;
    String packagingUnit = PurchaseConstants.packagingUnit;
    String quantityUnit = PurchaseConstants.quantityUnit;
    bool isService = false;

    // Check if the variant already has an itemCd (not assigned to any existing variant)
    if (variant.itemCd != null && variant.itemCd!.isNotEmpty) {
      final String itemCd = variant.itemCd!;

      // Extract components from itemCd (format: XX0YYYY0000000)
      // XX: Country code (2 chars)
      // 0: Product type (1 digit)
      // YY: Packaging unit (2 chars)
      // YY: Quantity unit (2 chars)
      // 0000000: Sequence number

      // Extract country code (first 2 characters)
      if (itemCd.length >= 2) {
        countryCode = itemCd.substring(0, 2);
        talker.debug("Extracted country code from itemCd: $countryCode");
      }

      // Extract product type (3rd character)
      if (itemCd.length >= 3) {
        productType = itemCd.substring(2, 3);
        // Check if it's a service (product type "3")
        isService = productType == "3";
        talker.debug(
            "Extracted product type from itemCd: $productType (isService: $isService)");
      }

      // Extract packaging unit (4th and 5th characters)
      if (itemCd.length >= 5) {
        packagingUnit = itemCd.substring(3, 5);
        talker.debug("Extracted packaging unit from itemCd: $packagingUnit");
      }

      // Extract quantity unit (6th and 7th characters)
      if (itemCd.length >= 7) {
        quantityUnit = itemCd.substring(5, 7);
        talker.debug("Extracted quantity unit from itemCd: $quantityUnit");
      }

      // Remember if it's a service for later use
      // We'll still generate a new itemCd for services
    }

    // Generate new itemCd using extracted components for ALL variants (including services)
    variant.itemCd = await ProxyService.strategy.itemCode(
      countryCode: countryCode,
      productType: productType,
      packagingUnit: packagingUnit,
      quantityUnit: quantityUnit,
      branchId: ProxyService.box.getBranchId()!,
    );

    variant.ebmSynced = false;
    variant.itemTyCd = productType;

    // Special handling for services (no stock assignment)
    if (isService) {
      talker.debug(
          "Item ${variant.id} is a service (code 3), no stock assignment needed");

      await ProxyService.strategy.updateVariant(
        updatables: [variant],
        purchase: purchase,
        approvedQty: null, // No stock for services
        invoiceNumber: purchase.spplrInvcNo,
        updateIo: updateIo,
      );

      // Still update IO but with null approvedQty for services
      await ProxyService.strategy.updateIoFunc(
        variant: variant,
        purchase: purchase,
        approvedQty: null,
      );
    } else {
      // Normal handling for non-service items
      await ProxyService.strategy.updateVariant(
        updatables: [variant],
        purchase: purchase,
        approvedQty: variant.stock?.currentStock,
        invoiceNumber: purchase.spplrInvcNo,
        updateIo: updateIo,
      );

      // update io
      await ProxyService.strategy.updateIoFunc(
        variant: variant,
        purchase: purchase,
        approvedQty: variant.stock?.currentStock,
      );
    }
  }

  bool _shouldProcessMappings(
      String pchsSttsCd, Map<String, Variant>? itemMapper) {
    return itemMapper != null && pchsSttsCd == "02" && itemMapper.isNotEmpty;
  }

  Future<void> _handleVariantMappings(
    Map<String, Variant> itemMapper,
    Purchase purchase,
  ) async {
    for (final entry in itemMapper.entries) {
      final existingVariantId = entry.key;
      final variantFromPurchase = entry.value;
      // variantFromPurchase.assi

      if (existingVariantId == variantFromPurchase.id) {
        talker.debug(
            "Skipping self-mapping for variant ID: ${variantFromPurchase.id}");
        continue;
      }

      final existingVariant = await ProxyService.strategy.getVariant(
        id: existingVariantId,
      );

      if (existingVariant != null && variantFromPurchase.pchsSttsCd != "03") {
        await _updateMappedVariant(
          existingVariant: existingVariant,
          purchaseVariant: variantFromPurchase,
          purchase: purchase,
        );
      }
    }
  }

  Future<void> _updateMappedVariant({
    required Variant existingVariant,
    required Variant purchaseVariant,
    required Purchase purchase,
  }) async {
    // When mapping, the item from the purchase should be marked as assigned.
    purchaseVariant.assigned = true;
    await _updateVariantStock(
      item: purchaseVariant,
      existingVariantToUpdate: existingVariant,
    );

    purchaseVariant.pchsSttsCd = "03"; // Mapped status

    await ProxyService.strategy.updateVariant(
      updatables: [purchaseVariant],
    );

    existingVariant.ebmSynced = false;
    await ProxyService.strategy.updateVariant(
      updatables: [existingVariant],
      purchase: purchase,
      approvedQty: purchaseVariant.stock?.currentStock,
      invoiceNumber: purchase.spplrInvcNo,
      updateIo: false,
    );
    // update io
    await ProxyService.strategy.updateIoFunc(
      variant: existingVariant,
      purchase: purchase,
      approvedQty: purchaseVariant.stock?.currentStock,
    );
  }

// Private helper methods

  void _setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  Future<Business> _getBusiness() async {
    final businessId = ProxyService.box.getBusinessId();
    final business =
        await ProxyService.strategy.getBusiness(businessId: businessId);

    if (business == null) {
      throw PurchaseAcceptanceException(
          "Business not found for ID: $businessId");
    }

    return business;
  }

  Future<void> _reportPurchaseToTaxService(
    Purchase purchase,
    Business business,
    String pchsSttsCd,
  ) async {
    if (purchase.variants == null || purchase.variants!.isEmpty) {
      talker.warning("Purchase ${purchase.id} has no variants");
      return;
    }

    final bhfId = (await ProxyService.strategy
                .ebm(branchId: ProxyService.box.getBranchId()!))
            ?.bhfId ??
        await ProxyService.box.bhfId();
    final serverUrl = await ProxyService.box.getServerUrl() ?? "";

    // Skip tax service call in test environment
    if (serverUrl.isEmpty) {
      talker.warning("Tax service unavailable in test environment");
      return;
    }

    final rwApiResponse = await ProxyService.tax.savePurchases(
      item: purchase,
      business: business,
      variants: purchase.variants!,
      bhfId: bhfId!,
      rcptTyCd: PurchaseConstants.purchaseReceiptType,
      URI: serverUrl,
      pchsSttsCd: pchsSttsCd,
    );

    if (rwApiResponse.resultCd != "000") {
      throw TaxReportingException(
        "Tax service reported error: ${rwApiResponse.resultMsg}",
      );
    }
  }

  void _handlePurchaseError(Object error, StackTrace stackTrace) {
    talker.error("Purchase acceptance failed", error, stackTrace);
    _setLoading(false);
  }

  Future<void> approveAllImportItems(List<Variant> importItems,
      {required Map<String, Variant> variantMap}) async {
    try {
      setBusy(true);

      final tasks = <Future>[];
      for (final variant in importItems) {
        if (variant.imptItemSttsCd == "2") {
          tasks.add(processImportItem(variant, variantMap));
        }
      }
      await Future.wait(tasks);
      notifyListeners();
    } catch (e, s) {
      talker.error(s);
      setError(e);
    } finally {
      setBusy(false);
    }
  }

  Future<void> processImportItem(
    Variant incomingImportVariant,
    Map<String, Variant> variantToMapTo,
  ) async {
    incomingImportVariant.taxName = "B";
    incomingImportVariant.taxTyCd = "B";

    final URI = await ProxyService.box.getServerUrl() ?? "";
    Variant? existingVariantToUpdate;

    /// we have item to map, this means we are taking incoming import's Qty
    /// and assign it to existing variant's stock.
    if (variantToMapTo.isNotEmpty) {
      existingVariantToUpdate = variantToMapTo[incomingImportVariant.id];
      if (existingVariantToUpdate != null) {
        existingVariantToUpdate.ebmSynced = false;
        await _updateVariantStock(
            item: incomingImportVariant,
            existingVariantToUpdate: existingVariantToUpdate);

        /// get updated variant with new stock
        existingVariantToUpdate = await ProxyService.strategy
                .getVariant(id: existingVariantToUpdate.id) ??
            incomingImportVariant;

        /// we mark this item as 3 approved since it's stock has been merged with existing, and also as ebm synced to avoid accidental
        /// syncing it again.
        // item.imptItemSttsCd = "3";
        incomingImportVariant.ebmSynced = true;
        incomingImportVariant.imptItemSttsCd = "3";
        existingVariantToUpdate.ebmSynced = true;
        incomingImportVariant.assigned = true;
        await ProxyService.strategy
            .updateVariant(updatables: [incomingImportVariant]);
        await ProxyService.strategy.updateVariant(
          updatables: [existingVariantToUpdate],
          approvedQty: incomingImportVariant.stock?.currentStock,
        );
      }
    } else {
      existingVariantToUpdate = incomingImportVariant;
      existingVariantToUpdate.itemCd = await ProxyService.strategy.itemCode(
        countryCode: existingVariantToUpdate.orgnNatCd ?? "RW",
        productType: "2",
        packagingUnit: existingVariantToUpdate.pkgUnitCd ?? "CT",
        quantityUnit: existingVariantToUpdate.qtyUnitCd ?? "BJ",
        branchId: ProxyService.box.getBranchId()!,
      );
      existingVariantToUpdate.imptItemSttsCd = "3";
      existingVariantToUpdate.assigned = false;

      await _updateVariant(
        existingVariantToUpdate,
        approvedQty: incomingImportVariant.stock?.currentStock,
      );
      // get freshly updated Variant with its updated stock.
      existingVariantToUpdate = await ProxyService.strategy
              .getVariant(id: existingVariantToUpdate.id) ??
          incomingImportVariant;
    }

    // Use sarTyCd = ""0"2" for imports (same as purchases) to ensure consistent recording
    // "02" is the code for Incoming purchase/import in the system

    await ProxyService.tax
        .updateImportItems(item: incomingImportVariant, URI: URI);
  }

  Future<void> _updateVariantStock(
      {required Variant item, required Variant existingVariantToUpdate}) async {
    await ProxyService.strategy.updateStock(
        stockId: existingVariantToUpdate.stock!.id,
        appending: true,
        rsdQty: item.stock!.currentStock,
        initialStock: item.stock!.currentStock,
        currentStock: item.stock!.currentStock,
        value: item.stock!.currentStock! * item.retailPrice!);
  }

  Future<void> _updateVariant(Variant variant, {double? approvedQty}) async {
    await ProxyService.strategy.updateVariant(
      updatables: [variant],
      approvedQty: approvedQty,
    );
  }

  Future<void> rejectImportItem(Variant item) async {
    try {
      item.imptItemSttsCd = "4";
      item.ebmSynced = false;
      await ProxyService.strategy.updateVariant(updatables: [item]);

      await ProxyService.tax.updateImportItems(
        item: item,
        URI: await ProxyService.box.getServerUrl() ?? "",
      );

      item.ebmSynced = true;
      ProxyService.strategy.updateVariant(updatables: [item]);
    } catch (e) {
      rethrow; // Re-throw the exception to be caught in the UI
    }
  }
}
