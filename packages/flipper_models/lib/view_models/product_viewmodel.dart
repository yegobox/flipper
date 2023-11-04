library flipper_models;

// import 'package:flipper_models/isar_models.dart';

import 'dart:developer';

import 'package:flipper_models/isar/random.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flutter/cupertino.dart';

import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/locator.dart' as loc;
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/product_service.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_services/constants.dart';
import 'package:stacked/stacked.dart';

class ProductViewModel extends FlipperBaseModel {
  // extends ReactiveViewModel
  final AppService app = loc.getIt<AppService>();
  // ignore: annotate_overrides, overridden_fields
  final ProductService productService = loc.getIt<ProductService>();
  final _routerService = locator<RouterService>();

  List<IUnit> units = [];
  Future<void> loadUnits() async {
    int? branchId = ProxyService.box.getBranchId();
    units = await ProxyService.isar.units(branchId: branchId!);
  }

  get categories => app.categories;

  List<Product> _products = [];

  List<Product> get products => _products
      .where((element) =>
          element.name != 'temp' && element.name != 'Custom Amount')
      .toList();

  set products(List<Product> value) {
    _products = value;
    log(value.toString(), name: 'load product on adding one');
  }

  Product? product = null;

  List<Product> get nonFavoriteProducts => _products
      .where((element) =>
          element.name != 'temp' &&
          element.name != 'Custom Amount' &&
          element.id != 1)
      .toList();
  set nonFavoriteProducts(List<Product> value) {
    products = value;
    notifyListeners();
  }

  setCurrentProduct({required Product currentProduct}) {
    product = currentProduct;
    notifyListeners();
  }

  String currentColor = '#0984e3';

  setCurrentColor({required String color}) {
    currentColor = color;
  }

  List<PColor> colors = [];

  Future<void> loadColors() async {
    int? branchId = ProxyService.box.getBranchId();

    colors = await ProxyService.isar.colors(branchId: branchId!);
    notifyListeners();
    for (PColor color in colors) {
      if (color.active) {
        setCurrentColor(color: color.name!);
      }
    }
  }

  String? _productName;
  get productName => _productName;

  Stream<String> getBarCode() async* {
    yield productService.barCode;
  }

  bool inUpdateProcess = false;

  /// Create a temporal product to use during this session of product creation
  /// the same product will be use if it is still temp product
  String kProductName = 'null';
  Future<Product> getProduct({String? productId}) async {
    if (productId != null) {
      inUpdateProcess = true;
      Product? product = await ProxyService.isar.getProduct(id: productId);
      setCurrentProduct(currentProduct: product!);
      setCurrentProduct(currentProduct: product);
      kProductName = product.name;

      notifyListeners();
      return product;
    }

    /// create a temp product or return it if it exists
    Product product = await ProxyService.isar.createProduct(
        product: Product(
            id: randomString(),
            name: TEMP_PRODUCT,
            action: AppActions.create,
            lastTouched: DateTime.now(),
            businessId: ProxyService.box.getBusinessId()!,
            color: COLOR,
            branchId: ProxyService.box.getBranchId()!));

    setCurrentProduct(currentProduct: product);
    kProductName = product.name;
    rebuildUi();
    return product;
  }

  void setName({String? name}) {
    _productName = name;
    notifyListeners();
  }

  bool _lock = false;
  bool get lock => _lock;
  void lockButton(bool value) {
    _lock = value;
    rebuildUi();
  }

  void loadCategories() {
    app.loadCategories();
  }

  ///create a new category and refresh list of categories
  Future<void> createCategory() async {
    final int? branchId = ProxyService.box.getBranchId();
    if (productName == null) return;
    final Category category = Category(
        name: productName!,
        active: true,
        focused: false,
        branchId: branchId!,
        id: randomString());

    await ProxyService.isar.create(data: category);
    app.loadCategories();
  }

  void updateCategory({required Category category}) async {
    int branchId = ProxyService.box.getBranchId()!;
    for (Category category in categories) {
      if (category.focused) {
        Category cat = category;
        cat.focused = false;
        cat.branchId = branchId;
        cat.active = false;
        await ProxyService.isar.update(
          data: cat,
        );
      }
    }

    Category cat = category;
    cat.focused = true;
    cat.active = true;
    cat.branchId = branchId;
    await ProxyService.isar.update(
      data: cat,
    );
    app.loadCategories();
  }

  /// Should save a focused unit given the id to persist to
  /// the Id can be ID of product or variant
  void saveFocusedUnit(
      {required IUnit newUnit, String? id, required String type}) async {
    final int branchId = ProxyService.box.getBranchId()!;
    log('updating unit', name: 'saveFocusedUnit');
    for (IUnit unit in units) {
      if (unit.active) {
        unit.active = false;
        unit.branchId = branchId;
        await ProxyService.isar.update(data: unit);
      }
    }
    log('updating unit 1', name: 'saveFocusedUnit');
    newUnit.active = true;
    newUnit.branchId = branchId;
    await ProxyService.isar.update(data: newUnit);
    log('updating unit 2', name: 'saveFocusedUnit');
    if (type == 'product') {
      product?.unit = newUnit.name;
      await ProxyService.isar.update(data: product);
      // get updated product
      product = await ProxyService.isar.getProduct(id: product!.id);
    }
    log('updating unit 3', name: 'saveFocusedUnit');

    if (type == 'variant') {
      // Update variants if needed
      // final Map data = product.toJson();
      // data['unit'] = unit.name;
      // ProxyService.isar.update(data: data);
    }

    loadUnits();
    log('updating unit 4', name: 'saveFocusedUnit');
    notifyListeners();
  }

  void updateStock({required String variantId}) async {
    if (_stockValue != null) {
      Stock? stock =
          await ProxyService.isar.stockByVariantId(variantId: variantId);

      stock!.currentStock = _stockValue!;

      ProxyService.isar.update(data: stock);
      if (await ProxyService.isar.isTaxEnabled()) {
        ProxyService.tax.saveStock(stock: stock);
      }
    }
  }

  double? _stockValue;
  double? get stockValue => _stockValue;
  void setStockValue({required double value}) {
    _stockValue = value;
    rebuildUi();
  }

  void deleteVariant({required String id}) async {
    Variant? variant = await ProxyService.isar.variant(variantId: id);
    // can not delete regular variant every product should have a regular variant.
    if (variant!.name != 'Regular') {
      ProxyService.isar.delete(id: id, endPoint: 'variation');
      //this will reload the variations remain
      getProduct();
    }
  }

  Future<void> switchColor(
      {required PColor color, required Product product}) async {
    int branchId = ProxyService.box.getBranchId()!;
    for (PColor c in colors) {
      if (c.active) {
        final PColor? _color = await ProxyService.isar.getColor(id: c.id);
        _color!.active = false;
        _color.branchId = branchId;
        await ProxyService.isar.update(data: _color);
      }
    }

    final PColor? _color = await ProxyService.isar.getColor(id: color.id);

    _color!.active = true;
    _color.branchId = branchId;
    product.color = color.name!;
    await ProxyService.isar.update(data: product);
    await ProxyService.isar.update(data: _color);

    setCurrentColor(color: color.name!);

    loadColors();
  }

  setUnit({required String unit}) {
    productService.setProductUnit(unit: unit);
    notifyListeners();
  }

  /// add variation to a product [variations],[retailPrice],[supplyPrice]
  Future<int> addVariant({
    List<Variant>? variations,
    required double retailPrice,
    required double supplyPrice,
  }) async {
    int result = await ProxyService.isar.addVariant(
      data: variations!,
      retailPrice: retailPrice,
      supplyPrice: supplyPrice,
    );
    return result;
  }

  void navigateAddVariation(
      {required String productId, required BuildContext context}) {
    _routerService.navigateTo(AddVariationRoute(productId: productId));
  }

  /// When called should check the related product's variant and set the retail and or supply price
  /// of related stock
  Future<void> updateRegularVariant(
      {double? supplyPrice, double? retailPrice, String? productId}) async {
    Product? product = await ProxyService.isar.getProduct(id: productId!);
    List<Variant> variants = await ProxyService.isar.variants(
        branchId: ProxyService.box.getBranchId()!, productId: productId);
    if (supplyPrice != null) {
      for (Variant variation in variants) {
        if (variation.name == "Regular") {
          variation.supplyPrice = supplyPrice;
          variation.productName = product!.name;
          variation.action =
              inUpdateProcess ? AppActions.update : AppActions.create;
          variation.productId = variation.productId;
          ProxyService.isar.update(data: variation);
          Stock? stock =
              await ProxyService.isar.stockByVariantId(variantId: variation.id);

          if (stock != null) {
            stock.supplyPrice = supplyPrice;
            stock.action =
                inUpdateProcess ? AppActions.update : AppActions.create;
            ProxyService.isar.update(data: stock);
          }
        }
      }
    }

    if (retailPrice != null) {
      for (Variant variation in variants) {
        if (variation.name == "Regular") {
          variation.retailPrice = retailPrice;
          variation.productId = variation.productId;
          variation.prc = retailPrice;
          variation.action =
              inUpdateProcess ? AppActions.update : AppActions.create;
          variation.productName = product!.name;
          ProxyService.isar.update(data: variation);
          Stock? stock =
              await ProxyService.isar.stockByVariantId(variantId: variation.id);

          if (stock != null) {
            stock.retailPrice = retailPrice;
            stock.action =
                inUpdateProcess ? AppActions.update : AppActions.create;
            await ProxyService.isar.update(data: stock);
          }
        }
      }
    }
  }

  /// Add a product into the system
  Future<bool> saveProduct({required Product mproduct}) async {
    ProxyService.analytics
        .trackEvent("product_creation", {'feature_name': 'product_creation'});
    // String mproductName =
    mproduct.name = productName;
    mproduct.barCode = productService.barCode.toString();
    mproduct.color = currentColor;

    Category? activeCat = await ProxyService.isar
        .activeCategory(branchId: ProxyService.box.getBranchId()!);

    String activeCatName = activeCat!.name;

    mproduct.categoryId = activeCatName;

    activeCat.active = false;
    activeCat.focused = false;
    await ProxyService.isar.update(data: activeCat);

    mproduct.action = inUpdateProcess ? AppActions.update : AppActions.create;

    final response = await ProxyService.isar.update(data: mproduct);
    List<Variant> variants =
        await ProxyService.isar.getVariantByProductId(productId: mproduct.id);

    for (Variant variant in variants) {
      variant.productName = productName;
      variant.prc = variant.retailPrice;
      variant.productId = mproduct.id;
      variant.pkgUnitCd = "NT";
      variant.action = inUpdateProcess ? AppActions.update : AppActions.create;
      await ProxyService.isar.update(data: variant);
      if (await ProxyService.isar.isTaxEnabled()) {
        ProxyService.tax.saveItem(variation: variant);
      }
    }
    ProxyService.sync.push();
    return response == 200;
  }

  /// Add a product into the favorites
  Future<int> addFavorite(
      {required int favIndex, required String productId}) async {
    final favorite = Favorite(
      favIndex: favIndex,
      productId: productId,
      branchId: ProxyService.box.getBranchId(),
      action: AppActions.create,
    );

    int res = await ProxyService.isar.addFavorite(data: favorite);
    rebuildUi();
    ProxyService.sync.push();
    return res;
  }

  void deleteProduct({required String productId}) async {
    //get variants->delete
    int branchId = ProxyService.box.getBranchId()!;
    List<Variant> variations = await ProxyService.isar
        .variants(branchId: branchId, productId: productId);
    for (Variant variation in variations) {
      await ProxyService.isar.delete(id: variation.id, endPoint: 'variant');
      //get stock->delete
      Stock? stock =
          await ProxyService.isar.stockByVariantId(variantId: variation.id);
      if (stock != null) {
        await ProxyService.isar.delete(id: stock.id, endPoint: 'stock');
      }
      Favorite? fav =
          await ProxyService.isar.getFavoriteByProdId(prodId: productId);
      if (fav != null) {
        await ProxyService.isar.deleteFavoriteByIndex(favIndex: fav.id);
      }
    }
    //then delete the product
    await ProxyService.isar.delete(id: productId, endPoint: 'product');
  }

  void updateExpiryDate(DateTime date) async {
    product!.expiryDate = date.toIso8601String();
    ProxyService.isar.update(data: product);
    Product? cProduct = await ProxyService.isar.getProduct(id: product!.id);
    setCurrentProduct(currentProduct: cProduct!);
    rebuildUi();
  }

  Stream<String> getProductName() async* {
    yield product != null ? product!.name : '';
  }

  void deleteDiscount({id}) {
    ProxyService.isar.delete(id: id, endPoint: 'discount');
  }

  /// loop through transaction's items and update item with discount in consideration
  /// a discount can not go beyond the item's price
  Future<bool> applyDiscount({required Discount discount}) async {
    int branchId = ProxyService.box.getBranchId()!;
    Transaction? transaction =
        await ProxyService.keypad.getPendingTransaction(branchId: branchId);

    if (transaction != null) {
      List<TransactionItem> transactionItems = await ProxyService.isar
          .getTransactionItemsByTransactionId(transactionId: transaction.id);
      for (TransactionItem item in transactionItems) {
        if (item.price.toInt() <= discount.amount! && item.discount == null) {
          item.discount = item.price;

          await ProxyService.isar.update(data: item);
        } else if (item.discount == null) {
          item.discount =
              discount.amount != null ? discount.amount!.toDouble() : 0.0;

          await ProxyService.isar.update(data: item);
        }
      }
      return true;
    }
    return false;
  }

  Future<void> bindTenant(
      {required int tenantId, required String productId}) async {
    try {
      await ProxyService.isar
          .bindProduct(productId: productId, tenantId: tenantId);
      rebuildUi();
    } catch (e) {
      // handle the exception
    }
  }

  String? searchkey = '';

  void search(String value) {
    searchkey = value;
    notifyListeners();
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [app, productService];

  bool isScanningMode = false; // Add a boolean variable for scanning mode

  void toggleScanningMode() {
    isScanningMode = !isScanningMode;
    rebuildUi();
  }
}
