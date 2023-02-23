import 'dart:async';

import 'package:flipper_models/isar_models.dart' as isar;
import 'package:flutter/material.dart' as material;
import 'package:flipper_services/constants.dart';
import 'package:stacked/stacked.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'proxy.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:flipper_nfc/flipper_nfc.dart';
import 'package:flutter/services.dart';

class AppService with ListenableServiceMixin {
  // required constants
  String? get userid => ProxyService.box.read(key: 'userId');
  int? get businessId => ProxyService.box.read(key: 'businessId');
  int? get branchId => ProxyService.box.read(key: 'branchId');

  final log = getLogger('AppService');

  final _categories = ReactiveValue<List<Category>>([]);
  List<Category> get categories => _categories.value;

  final _business =
      ReactiveValue<isar.Business>(isar.Business(isDefault: false));
  isar.Business get business => _business.value;

  final _units = ReactiveValue<List<IUnit>>([]);
  List<IUnit> get units => _units.value;

  final _colors = ReactiveValue<List<PColor>>([]);
  List<PColor> get colors => _colors.value;

  final _currentColor = ReactiveValue<String>('#ee5253');
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
    int? branchId = ProxyService.box.read(key: 'branchId');

    final List<Category> result =
        await ProxyService.isarApi.categories(branchId: branchId!);

    _categories.value = result;
    notifyListeners();
  }

  Future<void> loadUnits() async {
    int? branchId = ProxyService.box.read(key: 'branchId');
    final List<IUnit> result =
        await ProxyService.isarApi.units(branchId: branchId!);

    _units.value = result;
  }

  Future<void> loadColors() async {
    int? branchId = ProxyService.box.read(key: 'branchId');

    List<PColor> result =
        await ProxyService.isarApi.colors(branchId: branchId!);
    _colors.value = result;
    log.i(result.length);
    for (PColor color in result) {
      if (color.active) {
        setCurrentColor(color: color.name!);
      }
    }
  }

  bool _loggedIn = false;
  bool get hasLoggedInUser => _loggedIn;

  bool isLoggedIn() {
    _loggedIn = ProxyService.box.read(key: 'userId') == null ? false : true;
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
    String? userId = ProxyService.box.getUserId();
    List<isar.Business> businesses =
        await ProxyService.isarApi.businesses(userId: userId!);
    if (businesses.isEmpty) {
      businesses
          .add(await ProxyService.isarApi.getOnlineBusiness(userId: userId));
    }
    if (businesses.length == 1) {
      await setActiveBusiness(businesses);
      await loadTenants(businesses);
      await loadCounters(businesses.first);
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
          await setActiveBusiness(businesses);
          await loadTenants(businesses);
          await loadCounters(businesses.first);
          defaultBusiness = true;
        }
      }
      if (!defaultBusiness) {
        throw LoginChoicesException(term: "choose default business");
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

  Future<void> bootstraper() async {
    if (await ProxyService.isarApi.size(object: Product()) == 0 &&
        ProxyService.box.getBranchId() != null) {
      await ProxyService.isarApi.createProduct(
          product: Product()
            ..name = "Custom Amount"
            ..color = "#5A2328"
            ..branchId = ProxyService.box.getBranchId()!
            ..businessId = ProxyService.box.getBusinessId()!);
    }
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
  Future<void> updateAndReportOrder(Order order, String namesString) async {
    List<OrderItem> updatedItems =
        await ProxyService.isarApi.orderItems(orderId: order.id);
    order.subTotal = updatedItems.fold(0, (a, b) => a + (b.price * b.qty));

    /// fix@issue where the createdAt synced on server is older compared to when a transaction was completed.
    order.updatedAt = DateTime.now().toIso8601String();
    order.createdAt = DateTime.now().toIso8601String();
    order.reference = Uuid().v4();
    order.orderNumber = Uuid().v1();

    await ProxyService.remoteApi.create(
        collection:
            order.toJson(convertIdToString: true, itemName: namesString),
        collectionName: 'orders');
    order.reported = true;
    await ProxyService.isarApi.update(data: order);
  }

// The updated automaticBackup() method
  void automaticBackup() {
    ProxyService.isarApi
        .completedOrdersStream(
      branchId: ProxyService.box.getBranchId()!,
      status: completeStatus,
    )
        .listen((order) async {
      if (order == null) return;

      String namesString =
          (await ProxyService.isarApi.orderItems(orderId: order.id))
              .map((item) => item.name)
              .join(',');

      await updateAndReportOrder(order, namesString);
    });
  }

// The updated backup() method
  Future<void> backup() async {
    List<Order> completedOrders = await ProxyService.isarApi.completedOrders(
      branchId: ProxyService.box.getBranchId()!,
    );

    for (Order completedOrder in completedOrders) {
      if (!completedOrder.reported!) {
        String namesString = (await ProxyService.isarApi.orderItems(
          orderId: completedOrder.id,
        ))
            .map((item) => item.name)
            .join(',');

        await updateAndReportOrder(completedOrder, namesString);
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
    await FlutterStatusbarcolor.setStatusBarColor(color);
    _statusColor = color;
    if (useWhiteForeground(color)) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarBrightness: Brightness.dark,
      ));
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarBrightness: Brightness.light,
      ));
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
        backup();
      }
      notifyListeners();
    });
  }

  AppService() {
    listenToReactiveValues(
        [_categories, _units, _colors, _currentColor, _business, _contacts]);
  }
}
