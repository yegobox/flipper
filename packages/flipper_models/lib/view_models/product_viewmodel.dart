library flipper_models;

import 'dart:developer';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flutter/cupertino.dart';

import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/locator.dart' as loc;
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/product_service.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flutter_riverpod/src/consumer.dart';

import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_services/constants.dart';
import 'package:stacked/stacked.dart';

import 'mixins/_product.dart';

class ProductViewModel extends CoreViewModel with ProductMixin {
  // extends ReactiveViewModel
  final AppService app = loc.getIt<AppService>();
  // ignore: annotate_overrides, overridden_fields
  final ProductService productService = loc.getIt<ProductService>();
  final _routerService = locator<RouterService>();

  List<IUnit> units = [];
  Future<void> loadUnits() async {
    int? branchId = ProxyService.box.getBranchId();
    units = await ProxyService.strategy.units(branchId: branchId!);
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
    notifyListeners();
  }

  List<PColor> colors = [];

  Future<void> loadColors() async {
    int? branchId = ProxyService.box.getBranchId();

    colors = await ProxyService.strategy.colors(branchId: branchId!);
    notifyListeners();
    for (PColor color in colors) {
      if (color.active) {
        setCurrentColor(color: color.name!);
      }
    }
  }

  Stream<String> getBarCode() async* {
    yield productService.barCode;
  }

  /// Create a temporal product to use during this session of product creation
  /// the same product will be use if it is still temp product
  String? kProductName;
  Future<Product> getProduct({String? productId}) async {
    try {
      if (productId != null) {
        Product? product = await ProxyService.strategy.getProduct(
            id: productId,
            branchId: ProxyService.box.getBranchId()!,
            businessId: ProxyService.box.getBusinessId()!);
        setCurrentProduct(currentProduct: product!);
        setCurrentProduct(currentProduct: product);
        kProductName = product.name;
        setCurrentColor(color: product.color);
        notifyListeners();
        return product;
      }

      /// create a temp product or return it if it exists
      Product? product = await ProxyService.strategy.createProduct(
        createItemCode: true,
        tinNumber: ProxyService.box.tin(),
        bhFId: (await ProxyService.box.bhfId()) ?? "00",
        businessId: ProxyService.box.getBusinessId()!,
        branchId: ProxyService.box.getBranchId()!,
        product: Product(
          name: TEMP_PRODUCT,
          lastTouched: DateTime.now().toUtc(),
          businessId: ProxyService.box.getBusinessId()!,
          color: COLOR,
          branchId: ProxyService.box.getBranchId()!,
        ),
      );

      setCurrentProduct(currentProduct: product!);
      kProductName = product.name;
      setCurrentColor(color: product.color);
      rebuildUi();
      return product;
    } catch (e, s) {
      talker.error(s);
      rethrow;
    }
  }

  void setProductName({String? name}) {
    if (name == null) return;
    kProductName = name;
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
    if (categoryName == null) return;
    final Category category = Category(
      name: categoryName!,
      active: true,
      focused: false,
      branchId: branchId!,
    );

    await ProxyService.strategy.create<Category>(data: category);
    app.loadCategories();
  }

  void updateCategory({required Category category}) async {
    int branchId = ProxyService.box.getBranchId()!;
    for (Category category in categories) {
      if (category.focused) {
        ProxyService.strategy.updateCategory(
            categoryId: category.id,
            name: category.name,
            active: false,
            focused: false,
            branchId: branchId);
      }
    }

    ProxyService.strategy.updateCategory(
        categoryId: category.id,
        name: category.name,
        active: true,
        focused: true,
        branchId: branchId);

    app.loadCategories();
  }

  /// Should save a focused unit given the id to persist to
  /// the Id can be ID of product or variant
  void saveFocusedUnit(
      {required IUnit newUnit, String? id, required String type}) async {
    final int branchId = ProxyService.box.getBranchId()!;

    for (IUnit unit in units) {
      if (unit.active ?? false) {
        ProxyService.strategy.updateUnit(
            unitId: unit.id,
            name: unit.name,
            active: false,
            branchId: branchId);
      }
    }
    ProxyService.strategy.updateUnit(
        unitId: newUnit.id,
        name: newUnit.name,
        active: true,
        branchId: branchId);
    if (type == 'product') {
      ProxyService.strategy.updateProduct(
        productId: product!.id,
        unit: newUnit.name,
        branchId: ProxyService.box.getBranchId()!,
        businessId: ProxyService.box.getBusinessId()!,
      );
      // get updated product
      product = await ProxyService.strategy.getProduct(
          businessId: ProxyService.box.getBusinessId()!,
          id: product!.id,
          branchId: ProxyService.box.getBranchId()!);
    }

    loadUnits();

    notifyListeners();
  }

  void updateStock({required String variantId}) async {
    if (_stockValue != null) {
      Variant? variant = await ProxyService.strategy.getVariant(id: variantId);

      ProxyService.strategy
          .updateStock(stockId: variant!.stock!.id, currentStock: _stockValue!);
    }
  }

  double? _stockValue;
  double? get stockValue => _stockValue;
  void setStockValue({required double value}) {
    _stockValue = value;
    rebuildUi();
  }

  void deleteVariant({required String id}) async {
    Variant? variant = (await ProxyService.strategy
            .variants(variantId: id, branchId: ProxyService.box.getBranchId()!))
        .firstOrNull;
    // can not delete regular variant every product should have a regular variant.
    if (variant!.name != 'Regular') {
      ProxyService.strategy.flipperDelete(
          id: id, endPoint: 'variation', flipperHttpClient: ProxyService.http);
      //this will reload the variations remain
      getProduct();
    }
  }

  Future<void> switchColor(
      {required PColor color, required WidgetRef widgetReference}) async {
    for (PColor c in colors) {
      if (c.active) {
        final PColor? _color = await ProxyService.strategy.getColor(id: c.id);
        ProxyService.strategy
            .updateColor(colorId: _color!.id, active: false, name: _color.name);
      }
    }

    final PColor? _color = await ProxyService.strategy.getColor(id: color.id);

    ProxyService.strategy
        .updateColor(colorId: _color!.id, active: true, name: _color.name);

    widgetReference
        .read(unsavedProductProvider.notifier)
        .emitProduct(value: product!);

    setCurrentColor(color: color.name!);

    loadColors();
  }

  setUnit({required String unit}) {
    productService.setProductUnit(unit: unit);
    notifyListeners();
  }

  /// add variation to a product [variations],[retailPrice],[supplyPrice]

  void navigateAddVariation(
      {required String productId, required BuildContext context}) {
    _routerService.navigateTo(AddVariationRoute(productId: productId));
  }

  /// When called should check the related product's variant and set the retail and or supply price
  /// of related stock
  Future<void> updateRegularVariant({
    required bool inUpdateProcess,
    String? productId,
    double? supplyPrice,
    double? retailPrice,
  }) async {
    Product? product = await ProxyService.strategy.getProduct(
        businessId: ProxyService.box.getBusinessId()!,
        id: productId,
        branchId: ProxyService.box.getBranchId()!);
    List<Variant> variants = await ProxyService.strategy.variants(
        branchId: ProxyService.box.getBranchId()!, productId: productId);

    if (supplyPrice != null) {
      for (Variant variation in variants) {
        if (variation.name == "Regular") {
          ProxyService.strategy.updateVariant(
              updatables: [variation],
              variantId: variation.id,
              productName: product!.name,
              productId: variation.productId!,
              supplyPrice: supplyPrice,
              retailPrice: retailPrice);
        }
      }
    }

    if (retailPrice != null) {
      for (Variant variation in variants) {
        if (variation.name == "Regular") {
          ProxyService.strategy.updateVariant(
              updatables: [variation],
              variantId: variation.id,
              productName: product!.name,
              productId: variation.productId!,
              retailPrice: retailPrice);
        }
      }
    }
  }

  /// Add a product into the favorites
  Future<int> addFavorite(
      {required String favIndex, required String productId}) async {
    final favorite = Favorite(
      favIndex: favIndex,
      productId: productId,
      branchId: ProxyService.box.getBranchId(),
    );

    int res = await ProxyService.strategy.addFavorite(data: favorite);
    rebuildUi();

    return res;
  }

  Future<void> deleteProduct({required String productId}) async {
    try {
      //get variants->delete
      int branchId = ProxyService.box.getBranchId()!;
      List<Variant> variations = await ProxyService.strategy
          .variants(branchId: branchId, productId: productId);
      for (Variant variation in variations) {
        //get stock->delete
        /// deleting variant is supposed to cascade delete stock
        await ProxyService.strategy.flipperDelete(
            id: variation.id,
            endPoint: 'variant',
            flipperHttpClient: ProxyService.http);

        Favorite? fav =
            await ProxyService.strategy.getFavoriteByProdId(prodId: productId);
        if (fav != null) {
          await ProxyService.strategy.deleteFavoriteByIndex(favIndex: fav.id);
        }
      }
      //then delete the product
      await ProxyService.strategy.flipperDelete(
          id: productId,
          endPoint: 'product',
          flipperHttpClient: ProxyService.http);
    } catch (e, s) {
      talker.warning(e);
      talker.error(s);
    }
  }

  void updateExpiryDate(DateTime date) async {
    ProxyService.strategy.updateProduct(
      productId: product!.id,
      expiryDate: date.toIso8601String(),
      branchId: ProxyService.box.getBranchId()!,
      businessId: ProxyService.box.getBusinessId()!,
    );
    Product? cProduct = await ProxyService.strategy.getProduct(
        id: product!.id,
        branchId: ProxyService.box.getBranchId()!,
        businessId: ProxyService.box.getBusinessId()!);
    setCurrentProduct(currentProduct: cProduct!);
    rebuildUi();
  }

  Stream<String> getProductName() async* {
    yield product != null ? product!.name : '';
  }

  void deleteDiscount({id}) {
    ProxyService.strategy.flipperDelete(
        id: id, endPoint: 'discount', flipperHttpClient: ProxyService.http);
  }

  /// loop through transaction's items and update item with discount in consideration
  /// a discount can not go beyond the item's price
  Future<bool> applyDiscount({required Discount discount}) async {
    int branchId = ProxyService.box.getBranchId()!;
    ITransaction? transaction =
        await ProxyService.keypad.getPendingTransaction(branchId: branchId);

    if (transaction != null) {
      List<TransactionItem> transactionItems = await ProxyService.strategy
          .transactionItems(
              transactionId: transaction.id,
              branchId: (await ProxyService.strategy.activeBranch()).id);

      for (TransactionItem item in transactionItems) {
        if (item.price.toInt() <= discount.amount!) {
          // item.discount = item.price;
          ProxyService.strategy.updateTransactionItem(
              ignoreForReport: false,
              transactionItemId: item.id,
              discount: item.price.toDouble());
        } else {
          ProxyService.strategy.updateTransactionItem(
              transactionItemId: item.id,
              ignoreForReport: false,
              discount: discount.amount!.toDouble());
        }
      }

      return true;
    }
    return false;
  }

  Future<void> bindTenant(
      {required String tenantId, required String productId}) async {
    try {
      await ProxyService.strategy
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

  String? categoryName;
  void setCategoryName({required String name}) {
    categoryName = name;
    notifyListeners();
  }
}
