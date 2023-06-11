library flipper_models;

// import 'package:flipper_models/isar_models.dart';

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

// class ProductViewModel extends BusinessHomeViewModel {
class ProductViewModel extends TenantViewModel {
  // extends ReactiveViewModel
  final AppService app = loc.locator<AppService>();
  // ignore: annotate_overrides, overridden_fields
  final ProductService productService = loc.locator<ProductService>();
  final _routerService = locator<RouterService>();
  List<PColor> get colors => app.colors;

  List<IUnit> get units => app.units;

  get categories => app.categories;

  get product => productService.product;

  String? _productName;
  get productName => _productName;

  List<Variant>? get variants => productService.variants;

  Stream<String> getBarCode() async* {
    yield productService.barCode;
  }

  bool inUpdateProcess = false;

  /// Create a temporal product to use during this session of product creation
  /// the same product will be use if it is still temp product
  String kProductName = 'null';
  Future<Product> getTempOrCreateProduct({int? productId}) async {
    if (productId != null) {
      inUpdateProcess = true;
      Product? product = await ProxyService.isar.getProduct(id: productId);
      productService.setCurrentProduct(product: product!);
      kProductName = product.name;

      productService.variantsProduct(productId: product.id!);
      notifyListeners();
      return product;
    }
    int branchId = ProxyService.box.getBranchId()!;
    int businessId = ProxyService.box.getBusinessId()!;
    Product? isTemp =
        await ProxyService.isar.isTempProductExist(branchId: branchId);

    if (isTemp == null) {
      Product product = await ProxyService.isar.createProduct(
          product: Product(
              id: syncIdInt(),
              name: "temp",
              action: 'create',
              businessId: businessId,
              color: "#e74c3c",
              branchId: branchId)
            ..name = "temp"
            ..color = "#e74c3c"
            ..branchId = branchId
            ..businessId = businessId);
      await productService.variantsProduct(productId: product.id!);

      productService.setCurrentProduct(product: product);
      kProductName = product.name;
      rebuildUi();
      return product;
    }
    productService.setCurrentProduct(product: isTemp);
    await productService.variantsProduct(productId: isTemp.id!);
    rebuildUi();
    return isTemp;
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

  void loadUnits() {
    app.loadUnits();
  }

  void loadColors() {
    app.loadColors();
  }

  ///create a new category and refresh list of categories
  Future<void> createCategory() async {
    final int? branchId = ProxyService.box.getBranchId();
    final categoryId = DateTime.now().millisecondsSinceEpoch;
    if (productName == null) return;
    final Category category = Category()
      ..id = categoryId
      ..active = true
      ..focused = false
      ..name = productName!
      ..branchId = branchId!;
    await ProxyService.isar.create(data: category);
    app.loadCategories();
  }

  void updateCategory({required Category category}) async {
    int branchId = ProxyService.box.getBranchId()!;
    for (Category category in categories) {
      if (category.focused) {
        Category cat = category;
        cat.focused = !cat.focused;
        cat.branchId = branchId;
        cat.active = !cat.active;
        await ProxyService.isar.update(
          data: cat,
        );
      }
    }

    Category cat = category;
    cat.focused = !cat.focused;
    cat.active = !cat.active;
    cat.branchId = branchId;
    await ProxyService.isar.update(
      data: cat,
    );
    app.loadCategories();
  }

  /// Should save a focused unit given the id to persist to
  /// the Id can be ID of product or variant
  void saveFocusedUnit(
      {required IUnit newUnit, int? id, required String type}) async {
    for (IUnit unit in units) {
      if (unit.active) {
        unit.active = !unit.active;
        unit.branchId = ProxyService.box.getBranchId()!;
        await ProxyService.isar.update(
          data: unit,
        );
      }
    }
    IUnit unit = newUnit;
    unit.active = !unit.active;
    unit.branchId = ProxyService.box.getBranchId()!;
    await ProxyService.isar.update(
      data: unit,
    );
    if (type == 'product') {
      product.unit = unit.name;
      ProxyService.isar.update(data: product);
      final Product? uProduct =
          await ProxyService.isar.getProduct(id: product.id!!);
      productService.setCurrentProduct(product: uProduct!);
    }
    if (type == 'variant') {
      // final Map data = product.toJson();
      // data['unit'] = unit.name;
      // ProxyService.isar.update(data: data, endPoint: 'variant');
    }
    notifyListeners();
    app.loadUnits();
  }

  void updateStock({required int variantId}) async {
    if (_stockValue != null) {
      Stock? stock =
          await ProxyService.isar.stockByVariantId(variantId: variantId);

      stock!.currentStock = _stockValue!;

      ProxyService.isar.update(data: stock);
      if (await ProxyService.isar.isTaxEnabled()) {
        ProxyService.tax.saveStock(stock: stock);
      }
      productService.variantsProduct(productId: product.id!!);
    }
    productService.variantsProduct(productId: product.id!!);
  }

  double? _stockValue;
  double? get stockValue => _stockValue;
  void setStockValue({required double value}) {
    _stockValue = value;
    rebuildUi();
  }

  void deleteVariant({required int id}) async {
    Variant? variant = await ProxyService.isar.variant(variantId: id);
    // can not delete regular variant every product should have a regular variant.
    if (variant!.name != 'Regular') {
      ProxyService.isar.delete(id: id, endPoint: 'variation');
      //this will reload the variations remain
      getTempOrCreateProduct();
    }
  }

  Future<void> switchColor({required PColor color}) async {
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
    await ProxyService.isar.update(data: _color);

    app.setCurrentColor(color: color.name!);

    rebuildUi();

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
      {required int productId, required BuildContext context}) {
    _routerService.navigateTo(AddVariationRoute(productId: productId));
  }

  /// When called should check the related product's variant and set the retail and or supply price
  /// of related stock
  Future<void> updateRegularVariant(
      {double? supplyPrice, double? retailPrice, int? productId}) async {
    Product? product = await ProxyService.isar.getProduct(id: productId!);
    if (supplyPrice != null) {
      for (Variant variation in variants!) {
        if (variation.name == "Regular") {
          variation.supplyPrice = supplyPrice;
          variation.productName = product!.name;
          variation.action =
              inUpdateProcess ? actions["update"] : actions["create"];
          variation.productId = variation.productId;
          ProxyService.isar.update(data: variation);
          Stock? stock = await ProxyService.isar
              .stockByVariantId(variantId: variation.id!);

          if (stock != null) {
            stock.supplyPrice = supplyPrice;
            ProxyService.isar.update(data: stock);
          }
        }
      }
    }

    if (retailPrice != null) {
      for (Variant variation in variants!) {
        if (variation.name == "Regular") {
          variation.retailPrice = retailPrice;
          variation.productId = variation.productId;
          variation.prc = retailPrice;
          variation.action =
              inUpdateProcess ? actions["update"] : actions["create"];
          variation.productName = product!.name;
          ProxyService.isar.update(data: variation);
          Stock? stock = await ProxyService.isar
              .stockByVariantId(variantId: variation.id!);

          if (stock != null) {
            stock.retailPrice = retailPrice;

            await ProxyService.isar.update(data: stock);
          }
        }
      }
    }
    productService.variantsProduct(productId: product!.id!);
  }

  /// Add a product into the system
  Future<bool> addProduct({required Product mproduct}) async {
    ProxyService.analytics
        .trackEvent("product_creation", {'feature_name': 'product_creation'});
    // String mproductName =
    mproduct.name = productName;
    mproduct.barCode = productService.barCode.toString();
    mproduct.color = app.currentColor;
    mproduct.color = app.currentColor;

    mproduct.action = inUpdateProcess ? actions["update"] : actions["create"];

    final response = await ProxyService.isar.update(data: mproduct);
    List<Variant> variants =
        await ProxyService.isar.getVariantByProductId(productId: mproduct.id!);

    for (Variant variant in variants) {
      variant.productName = productName;
      variant.prc = variant.retailPrice;
      variant.productId = mproduct.id!;
      variant.pkgUnitCd = "NT";
      variant.action = inUpdateProcess ? actions["update"] : actions["create"];
      await ProxyService.isar.update(data: variant);
      if (await ProxyService.isar.isTaxEnabled()) {
        ProxyService.tax.saveItem(variation: variant);
      }
    }
    ProxyService.app.pushDataToServer();
    return response == 200;
  }

  /// Add a product into the favorites
  Future<int> addFavorite(
      {required int favIndex, required int productId}) async {
    final favorite =
        Favorite(favIndex, productId, ProxyService.box.getBranchId());

    int res = await ProxyService.isar.addFavorite(data: favorite);
    rebuildUi();
    ProxyService.app.pushDataToServer();
    return res;
  }

  void deleteProduct({required int productId}) async {
    //get variants->delete
    int branchId = ProxyService.box.getBranchId()!;
    List<Variant> variations = await ProxyService.isar
        .variants(branchId: branchId, productId: productId);
    for (Variant variation in variations) {
      await ProxyService.isar.delete(id: variation.id!, endPoint: 'variant');
      //get stock->delete
      Stock? stock =
          await ProxyService.isar.stockByVariantId(variantId: variation.id!);
      if (stock != null) {
        await ProxyService.isar.delete(id: stock.id!, endPoint: 'stock');
      }
      Favorite? fav =
          await ProxyService.isar.getFavoriteByProdId(prodId: productId);
      if (fav != null) {
        await ProxyService.isar.deleteFavoriteByIndex(favIndex: fav.id!);
      }
    }
    //then delete the product
    await ProxyService.isar.delete(id: productId, endPoint: 'product');
  }

  void updateExpiryDate(DateTime date) async {
    product.expiryDate = date.toIso8601String();
    ProxyService.isar.update(data: product);
    Product? cProduct = await ProxyService.isar.getProduct(id: product.id!);
    productService.setCurrentProduct(product: cProduct!);
    rebuildUi();
  }

  Stream<String> getProductName() async* {
    yield productService.product != null ? productService.product!.name : '';
  }

  void deleteDiscount({id}) {
    ProxyService.isar.delete(id: id, endPoint: 'discount');
  }

  /// loop through order's items and update item with discount in consideration
  /// a discount can not go beyond the item's price
  Future<bool> applyDiscount({required Discount discount}) async {
    int branchId = ProxyService.box.getBranchId()!;
    Order? order =
        await ProxyService.keypad.getPendingOrder(branchId: branchId);

    if (order != null) {
      List<OrderItem> orderItems =
          await ProxyService.isar.getOrderItemsByOrderId(orderId: order.id!);
      for (OrderItem item in orderItems) {
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
      {required int tenantId, required int productId}) async {
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
}
