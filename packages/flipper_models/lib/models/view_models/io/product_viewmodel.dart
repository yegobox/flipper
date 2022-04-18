library flipper_models;

// import 'package:flipper_models/models/models.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:flipper_routing/routes.logger.dart';

import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/product_service.dart';

import 'package:flipper_services/constants.dart';

// class ProductViewModel extends BusinessHomeViewModel {
class ProductViewModel extends ReactiveViewModel {
  // extends ReactiveViewModel
  final AppService _appService = locator<AppService>();
  // ignore: annotate_overrides, overridden_fields
  final log = getLogger('ProductViewModel');
  final ProductService productService = locator<ProductService>();

  List<PColor> get colors => _appService.colors;

  List<Unit> get units => _appService.units;

  get categories => _appService.categories;

  get product => productService.product;

  String? _name;

  get name => _name;

  get currentColor => _appService.currentColor;

  List<Variant>? get variants => productService.variants;

  Stream<String> getBarCode() async* {
    yield productService.barCode;
  }

  Future<void> loadProducts() async {
    int branchId = ProxyService.box.read(key: 'branchId');
    productService.loadProducts(branchId: branchId);
  }

  /// Create a temporal product to use during this session of product creation
  /// the same product will be use if it is still temp product
  ///
  String kProductName = 'null';
  Future<int> loadTemporalproductOrEditIfProductIdGiven(
      {int? productId}) async {
    if (productId != null) {
      Product? product = await ProxyService.isarApi.getProduct(id: productId);
      productService.setCurrentProduct(product: product!);
      kProductName = product.name;
      productService.variantsProduct(productId: product.id);
      notifyListeners();
      return product.id;
    }
    int branchId = ProxyService.box.getBranchId()!;
    Product? isTemp =
        await ProxyService.isarApi.isTempProductExist(branchId: branchId);

    if (isTemp == null) {
      Product product = await ProxyService.isarApi.createProduct(
          product: Product()
            ..name = "temp"
            ..color = "#5A2328"
            ..branchId = ProxyService.box.getBranchId()!
            ..businessId = ProxyService.box.getBusinessId()!);
      productService.variantsProduct(productId: product.id);

      productService.setCurrentProduct(product: product);
      kProductName = product.name;
      notifyListeners();
      return product.id;
    }

    productService.setCurrentProduct(product: isTemp);
    productService.variantsProduct(productId: isTemp.id);
    notifyListeners();

    return isTemp.id;
  }

  void isPriceSet(bool price) {
    _price = price;
    _lock = !price || _name == null;
    notifyListeners();
  }

  bool _price = false;

  void setName({String? name}) {
    _name = name;
    final cleaned = name?.trim();
    _lock = cleaned?.length == null || !_price;
    notifyListeners();
  }

  bool _lock = false;
  bool get lock => _lock;

  void loadCategories() {
    _appService.loadCategories();
  }

  void loadUnits() {
    _appService.loadUnits();
  }

  void loadColors() {
    _appService.loadColors();
  }

  ///create a new category and refresh list of categories
  Future<void> createCategory() async {
    final int? branchId = ProxyService.box.read(key: 'branchId');
    final categoryId = DateTime.now().millisecondsSinceEpoch;
    if (name == null) return;
    final Category category = Category()
      ..id = categoryId
      ..active = true
      ..table = AppTables.category
      ..focused = false
      ..name = name
      ..branchId = branchId!;
    await ProxyService.isarApi.create(endPoint: 'category', data: category);
    _appService.loadCategories();
  }

  void updateCategory({required Category category}) async {
    int branchId = ProxyService.box.read(key: 'branchId');
    for (Category category in categories) {
      if (category.focused) {
        Category cat = category;
        cat.focused = !cat.focused;
        cat.branchId = branchId;
        cat.active = !cat.active;
        int categoryId = category.id;
        await ProxyService.isarApi.update(
          endPoint: 'category/$categoryId',
          data: cat,
        );
      }
    }

    Category cat = category;
    cat.focused = !cat.focused;
    cat.active = !cat.active;
    cat.branchId = branchId;
    int categoryId = category.id;
    await ProxyService.isarApi.update(
      endPoint: 'category/$categoryId',
      data: cat,
    );
    _appService.loadCategories();
  }

  /// Should save a focused unit given the id to persist to
  /// the Id can be ID of product or variant
  void saveFocusedUnit(
      {required Unit newUnit, int? id, required String type}) async {
    for (Unit unit in units) {
      if (unit.active) {
        unit.active = !unit.active;
        unit.branchId = ProxyService.box.getBranchId()!;
        await ProxyService.isarApi.update(
          data: unit,
        );
      }
    }
    Unit unit = newUnit;
    unit.active = !unit.active;
    unit.branchId = ProxyService.box.getBranchId()!;
    await ProxyService.isarApi.update(
      data: unit,
    );
    if (type == 'product') {
      product.unit = unit.name;
      ProxyService.isarApi.update(data: product);
      final Product? uProduct =
          await ProxyService.isarApi.getProduct(id: product.id);
      productService.setCurrentProduct(product: uProduct!);
    }
    if (type == 'variant') {
      // final Map data = product.toJson();
      // data['unit'] = unit.name;
      // ProxyService.isarApi.update(data: data, endPoint: 'variant');
    }
    _appService.loadUnits();
  }

  void updateStock({required int variantId}) async {
    if (_stockValue != null) {
      Stock? stock =
          await ProxyService.isarApi.stockByVariantId(variantId: variantId);
      // Map data = stock;
      stock!.currentStock = _stockValue!;
      final int stockId = stock.id;

      ProxyService.isarApi.update(data: stock, endPoint: 'stock/$stockId');
      productService.variantsProduct(productId: product.id);
    }
    productService.variantsProduct(productId: product.id);
  }

  double? _stockValue;
  double? get stockValue => _stockValue;
  void setStockValue({required double value}) {
    _stockValue = value;
    notifyListeners();
  }

  void deleteVariant({required int id}) async {
    Variant? variant = await ProxyService.isarApi.variant(variantId: id);
    // can not delete regular variant every product should have a regular variant.
    if (variant!.name != 'Regular') {
      ProxyService.isarApi.delete(id: id, endPoint: 'variation');
      //this will reload the variations remain
      loadTemporalproductOrEditIfProductIdGiven();
    }
  }

  void browsePictureFromGallery(
      {required int productId, required Function callBack}) {
    ProxyService.upload.browsePictureFromGallery(
        productId: productId,
        onComplete: (res) {
          callBack(res);
        });
  }

  void takePicture({required int productId, required Function callBack}) {
    ProxyService.upload.takePicture(
        productId: productId,
        onComplete: (res) {
          callBack(res);
        });
  }

  Future<void> switchColor({required PColor color}) async {
    int branchId = ProxyService.box.read(key: 'branchId');
    for (PColor c in colors) {
      if (c.active) {
        final PColor? _color = await ProxyService.isarApi.getColor(id: c.id);
        _color!.active = false;
        _color.branchId = branchId;
        ProxyService.isarApi.update(data: _color);
      }
    }

    final PColor? _color = await ProxyService.isarApi.getColor(id: color.id);

    _color!.active = true;
    _color.branchId = branchId;
    ProxyService.isarApi.update(data: _color);

    _appService.setCurrentColor(color: color.name!);

    loadColors();
  }

  setUnit({required String unit}) {
    productService.setProductUnit(unit: unit);
  }

  /// add variation to a product [variations],[retailPrice],[supplyPrice]
  Future<int> addVariant(
      {List<Variant>? variations,
      required double retailPrice,
      required double supplyPrice}) async {
    int result = await ProxyService.isarApi.addVariant(
        data: variations!, retailPrice: retailPrice, supplyPrice: supplyPrice);
    return result;
  }

  void navigateAddVariation(
      {required int productId, required BuildContext context}) {
    GoRouter.of(context).push("/variation/$productId");
  }

  /// When called should check the related product's variant and set the retail and or supply price
  /// of related stock
  void updateRegularVariant({double? supplyPrice, double? retailPrice}) async {
    if (supplyPrice != null) {
      for (Variant variation in variants!) {
        if (variation.name == "Regular") {
          variation.supplyPrice = supplyPrice;
          variation.productId = variation.productId;
          ProxyService.isarApi.update(data: variation);
          Stock? stock = await ProxyService.isarApi
              .stockByVariantId(variantId: variation.id);

          if (stock != null) {
            stock.supplyPrice = supplyPrice;
            ProxyService.isarApi.update(data: stock);
          }
        }
      }
    }

    if (retailPrice != null) {
      for (Variant variation in variants!) {
        if (variation.name == "Regular") {
          variation.retailPrice = retailPrice;
          variation.productId = variation.productId;

          ProxyService.isarApi.update(data: variation);
          Stock? stock = await ProxyService.isarApi
              .stockByVariantId(variantId: variation.id);

          if (stock != null) {
            stock.retailPrice = retailPrice;

            ProxyService.isarApi.update(data: stock);
          }
        }
      }
    }
    productService.variantsProduct(productId: product.id);
  }

  /// Add a product into the system
  Future<bool> addProduct(
      {required Product mproduct, required String name}) async {
    mproduct.name = name;
    mproduct.barCode = productService.barCode.toString();
    mproduct.color = currentColor;
    mproduct.color = currentColor;
    mproduct.draft = false;
    List<Variant> variants = await ProxyService.isarApi
        .getVariantByProductId(productId: mproduct.id);

    for (Variant variant in variants) {
      variant.productName = name;
      variant.productId = mproduct.id;
      await ProxyService.isarApi.update(data: variant);
    }
    final response = await ProxyService.isarApi.update(data: mproduct);
    return response == 200;
  }

  void deleteProduct({required int productId}) async {
    //get variants->delete
    int branchId = ProxyService.box.read(key: 'branchId');
    List<Variant> variations = await ProxyService.isarApi
        .variants(branchId: branchId, productId: productId);
    for (Variant variation in variations) {
      ProxyService.isarApi.delete(id: variation.id, endPoint: 'variation');
      //get stock->delete
      Stock? stock =
          await ProxyService.isarApi.stockByVariantId(variantId: variation.id);
      if (stock != null) {
        ProxyService.isarApi.delete(id: stock.id, endPoint: 'stock');
      }
    }
    //then delete the product
    ProxyService.isarApi.delete(id: productId, endPoint: 'product');
    loadProducts(); //refresh list of products
  }

  void updateExpiryDate(DateTime date) async {
    Map kProduct = product.toJson();
    kProduct['expiryDate'] = date.toIso8601String();
    ProxyService.isarApi.update(data: kProduct);
    Product? cProduct =
        await ProxyService.isarApi.getProduct(id: kProduct['id']);
    productService.setCurrentProduct(product: cProduct!);
    notifyListeners();
  }

  void filterProduct({required String searchKey}) {
    int branchId = ProxyService.box.read(key: 'branchId');
    productService.filtterProduct(searchKey: searchKey, branchId: branchId);
  }

  void addToMenu({required int productId}) {
    log.i('can add to menu');
  }

  Stream<String> getProductName() async* {
    yield productService.product != null ? productService.product!.name : '';
  }

  void deleteDiscount({id}) {
    ProxyService.isarApi.delete(id: id, endPoint: 'discount');
    loadProducts();
  }

  /// loop through order's items and update item with discount in consideration
  /// a discount can not go beyond the item's price
  Future<bool> applyDiscount({required DiscountSync discount}) async {
    int branchId = ProxyService.box.read(key: 'branchId');
    Order? order = await ProxyService.keypad.getOrder(branchId: branchId);

    if (order != null) {
      for (OrderItem item in order.orderItems) {
        if (item.price.toInt() <= discount.amount! && item.discount == null) {
          item.discount = item.price;

          await ProxyService.isarApi.update(data: item);
        } else if (item.discount == null) {
          item.discount =
              discount.amount != null ? discount.amount!.toDouble() : 0.0;

          await ProxyService.isarApi.update(data: item);
        }
      }
      // TODOD: update the order commented this may cause issue. as I no longer extends businessHomeViewmodel
      // updatePayable();
      return true;
    }
    return false;
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices =>
      [_appService, productService];
}
