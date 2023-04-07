import 'dart:async';

import 'package:flipper_models/isar_models.dart' as isar;
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart' as material;
import 'package:pocketbase/pocketbase.dart';
import 'package:stacked/stacked.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flipper_models/isar_models.dart';
import 'proxy.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:flipper_nfc/flipper_nfc.dart';
import 'package:flutter/services.dart';

class AppService with ListenableServiceMixin {
  // required constants
  int? get userid => ProxyService.box.getUserId();
  int? get businessId => ProxyService.box.getBusinessId();
  int? get branchId => ProxyService.box.getBranchId();

  final _categories = ReactiveValue<List<Category>>([]);
  List<Category> get categories => _categories.value;

  final _business =
      ReactiveValue<isar.Business>(isar.Business(isDefault: false));
  isar.Business get business => _business.value;

  final _units = ReactiveValue<List<IUnit>>([]);
  List<IUnit> get units => _units.value;

  final _colors = ReactiveValue<List<PColor>>([]);
  List<PColor> get colors => _colors.value;

  final _currentColor = ReactiveValue<String>('#0984e3');
  String get currentColor => _currentColor.value;

  final _customer = ReactiveValue<Customer?>(null);
  Customer? get customer => _customer.value;
  void setCustomer(Customer? customer) {
    _customer.value = customer;
  }

  setCurrentColor({required String color}) {
    _currentColor.value = color;
  }

  setBusiness({required isar.Business business}) {
    _business.value = business;
  }

  void loadCategories() async {
    int? branchId = ProxyService.box.getBranchId();

    final List<Category> result =
        await ProxyService.isarApi.categories(branchId: branchId!);

    _categories.value = result;
    notifyListeners();
  }

  Future<void> loadUnits() async {
    int? branchId = ProxyService.box.getBranchId();
    final List<IUnit> result =
        await ProxyService.isarApi.units(branchId: branchId!);

    _units.value = result;
  }

  Future<void> loadColors() async {
    int? branchId = ProxyService.box.getBranchId();

    List<PColor> result =
        await ProxyService.isarApi.colors(branchId: branchId!);
    _colors.value = result;

    for (PColor color in result) {
      if (color.active) {
        setCurrentColor(color: color.name!);
      }
    }
  }

  bool _loggedIn = false;
  bool get hasLoggedInUser => _loggedIn;

  bool isLoggedIn() {
    // from bellow logic add check if we also have businessId and branchId
    _loggedIn = ProxyService.box.getUserId() == null ? false : true;
    return _loggedIn;
  }

  final _contacts = ReactiveValue<List<Business>>([]);
  List<Business> get contacts => _contacts.value;

  /// contact are business in other words
  Future<void> loadContacts() async {
    Stream<List<Business>> contacts =
        ProxyService.isarApi.contacts().asBroadcastStream();
    contacts.listen((event) {
      _contacts.value = event;
    });
  }

  /// check the default business/branch
  /// set the env the current user is operating in.

  Future<void> appInit() async {
    int? userId = ProxyService.box.getUserId();
    if (userId == null) return;
    List<isar.Business> businesses =
        await ProxyService.isarApi.businesses(userId: userId);
    if (businesses.isEmpty) {
      try {
        Business b = await ProxyService.isarApi
            .getOnlineBusiness(userId: userId.toString());
        businesses.add(b);
      } catch (e) {
        rethrow;
      }
    }
    if (businesses.length == 1) {
      await setActiveBusiness(businesses);
      await loadTenants(businesses);
      await loadCounters(businesses.first);

      ProxyService.box.write(key: 'businessId', value: businesses.first.id);
      bool defaultBranch = await setActiveBranch(businesses: businesses.first);

      if (!defaultBranch) {
        throw LoginChoicesException(term: "choose default branch");
      }
    } else {
      //we have more than one business check if there one set to be default then
      // do not throw the error
      bool defaultBusiness = false;
      for (Business business in businesses) {
        if (business.isDefault != null && business.isDefault == true) {
          ProxyService.box.write(key: 'businessId', value: business.id);
          await setActiveBusiness(businesses);
          await loadTenants(businesses);
          await loadCounters(businesses.first);
          defaultBusiness = true;
        }
      }
      if (!defaultBusiness) {
        throw LoginChoicesException(term: "Choose default business");
      }
    }
  }

  Future<void> loadTenants(List<isar.Business> businesses) async {
    List<ITenant> tenants = await ProxyService.isarApi
        .tenants(businessId: ProxyService.box.getBusinessId()!);
    if (tenants.isEmpty) {
      await ProxyService.isarApi
          .tenantsFromOnline(businessId: businesses.first.id!);
    }
  }

  Future<bool> setActiveBranch({required isar.Business businesses}) async {
    List<isar.Branch> branches =
        await ProxyService.isarApi.branches(businessId: businesses.id!);

    bool defaultBranch = false;
    for (Branch branch in branches) {
      if (branch.isDefault) {
        defaultBranch = true;
        ProxyService.box.write(key: 'branchId', value: branch.id);
      }
    }
    if (branches.length == 1) {
      defaultBranch = true;
      ProxyService.box.write(key: 'branchId', value: branches.first.id);
    }
    return defaultBranch;
  }

  Future<void> setActiveBusiness(List<isar.Business> businesses) async {
    ProxyService.appService.setBusiness(business: businesses.first);

    ProxyService.box.write(key: 'businessId', value: businesses.first.id);
  }

  Future<void> loadCounters(isar.Business business) async {
    if (await ProxyService.isarApi.size(object: Counter()) == 0) {
      await ProxyService.isarApi
          .loadCounterFromOnline(businessId: business.id!);
    }
  }

  NFCManager nfc = NFCManager();
  static final StreamController<String> cleanedDataController =
      StreamController<String>.broadcast();
  static Stream<String> get cleanedData => cleanedDataController.stream;

  // The extracted function for updating and reporting orders
  Future<void> pushOrders(Order order) async {
    List<OrderItem> updatedItems =
        await ProxyService.isarApi.orderItems(orderId: order.id!);
    order.subTotal = updatedItems.fold(0, (a, b) => a + (b.price * b.qty));

    /// fix@issue where the createdAt synced on server is older compared to when a transaction was completed.
    order.updatedAt = DateTime.now().toIso8601String();
    order.createdAt = DateTime.now().toIso8601String();

    RecordModel? variantRecord = await ProxyService.sync.push(order);
    if (variantRecord != null) {
      Order o = Order.fromRecord(variantRecord);
      o.remoteID = variantRecord.id;

      // /// keep the local ID unchanged to avoid complication
      o.id = order.id;

      await ProxyService.isarApi.update(data: o);
    }
  }

  Future<void> pushDataToServer() async {
    /// push stock
    List<Order> orders = await ProxyService.isarApi.getLocalOrders();
    for (Order order in orders) {
      await pushOrders(order);
    }

    List<Stock> stocks = await ProxyService.isarApi.getLocalStocks();
    for (Stock stock in stocks) {
      int stockId = stock.id!;

      RecordModel? stockRecord = await ProxyService.sync.push(stock);
      if (stockRecord != null) {
        Stock s = Stock.fromRecord(stockRecord);
        s.remoteID = stockRecord.id;

        /// keep the local ID unchanged to avoid complication
        s.id = stockId;
        s.action = actions["afterUpdate"];

        await ProxyService.isarApi.update(data: s);
      }
    }

    //push variant
    /// get variants
    List<Variant> variants = await ProxyService.isarApi.getLocalVariants();
    for (Variant variant in variants) {
      int variantId = variant.id!;

      RecordModel? variantRecord = await ProxyService.sync.push(variant);
      if (variantRecord != null) {
        Variant va = Variant.fromRecord(variantRecord);
        va.remoteID = variantRecord.id;

        // /// keep the local ID unchanged to avoid complication
        va.id = variantId;
        va.action = actions["afterUpdate"];
        await ProxyService.isarApi.update(data: va);
      }
    }

    /// pushing products data
    List<Product> products = await ProxyService.isarApi.getLocalProducts();
    for (Product product in products) {
      RecordModel? record = await ProxyService.sync.push(product);
      int oldId = product.id!;
      if (record != null) {
        Product product = Product.fromRecord(record);
        product.remoteID = record.id;

        /// keep the local ID unchanged to avoid complication
        product.id = oldId;
        product.action = actions["afterUpdate"];
        await ProxyService.isarApi.update(data: product);
      }
    }
  }

  Stream<bool> checkInternetConnectivity() async* {
    final Connectivity connectivity = Connectivity();
    yield await connectivity.checkConnectivity() != ConnectivityResult.none;

    await for (ConnectivityResult result
        in connectivity.onConnectivityChanged) {
      yield result != ConnectivityResult.none;
    }
  }

  material.Color _statusColor = material.Color(0xFF8B0000);

  material.Color get statusColor => _statusColor;

  String _statusText = "";

  String get statusText => _statusText;

  Future<void> appBarColor(material.Color color) async {
    if (!isWindows) {
      await FlutterStatusbarcolor.setStatusBarColor(color);
      _statusColor = color;
      if (useWhiteForeground(color)) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
          statusBarBrightness: Brightness.dark,
        ));
      } else {
        SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle.light.copyWith(
          statusBarBrightness: Brightness.light,
        ));
      }
    }
  }

  void updateStatusColor() {
    _statusText = "";
    appBarColor(material.Colors.black);

    ProxyService.appService
        .checkInternetConnectivity()
        .listen((currentInternetStatus) {
      if (!currentInternetStatus) {
        _statusColor = material.Colors.red;
        _statusText = "Connectivity issues";
        appBarColor(material.Color(0xFF8B0000));
      } else {
        _statusText = "";
        appBarColor(material.Colors.black);
      }
      notifyListeners();
    });
  }

  AppService() {
    listenToReactiveValues(
        [_categories, _units, _colors, _currentColor, _business, _contacts]);
  }
}
