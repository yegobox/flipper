library flipper_models;

import 'dart:developer';

import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flutter/cupertino.dart';

import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/locator.dart' as loc;
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/product_service.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:realm/realm.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_services/constants.dart';
import 'package:stacked/stacked.dart';

import 'mixins/_product.dart';
import 'mixins/_transaction.dart';

class ProductViewModel extends FlipperBaseModel
    with ProductMixin, TransactionMixin {
  // extends ReactiveViewModel
  final AppService app = loc.getIt<AppService>();
  // ignore: annotate_overrides, overridden_fields
  final ProductService productService = loc.getIt<ProductService>();
  final _routerService = locator<RouterService>();

  List<IUnit> units = [];
  Future<void> loadUnits() async {
    int? branchId = ProxyService.box.getBranchId();
    units = await ProxyService.local.units(branchId: branchId!);
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

    colors = await ProxyService.local.colors(branchId: branchId!);
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
  Future<Product> getProduct({int? productId}) async {
    try {
      if (productId != null) {
        Product? product = ProxyService.local.getProduct(id: productId);
        setCurrentProduct(currentProduct: product!);
        setCurrentProduct(currentProduct: product);
        kProductName = product.name!;
        setCurrentColor(color: product.color);
        notifyListeners();
        return product;
      }

      /// create a temp product or return it if it exists
      Product? product = await ProxyService.local.createProduct(
        tinNumber: ProxyService.box.tin(),
        bhFId: ProxyService.box.bhfId() ?? "00",
        businessId: ProxyService.box.getBusinessId()!,
        branchId: ProxyService.box.getBranchId()!,
        product: Product(
          ObjectId(),
          id: randomNumber(),
          name: TEMP_PRODUCT,
          lastTouched: DateTime.now(),
          businessId: ProxyService.box.getBusinessId()!,
          color: COLOR,
          branchId: ProxyService.box.getBranchId()!,
        ),
      );

      setCurrentProduct(currentProduct: product!);
      kProductName = product.name!;
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
      ObjectId(),
      name: categoryName!,
      active: true,
      focused: false,
      branchId: branchId!,
      id: randomNumber(),
    );

    await ProxyService.local.create<Category>(data: category);
    app.loadCategories();
  }

  void updateCategory({required Category category}) async {
    ProxyService.local.realm!.write(() {
      int branchId = ProxyService.box.getBranchId()!;
      for (Category category in categories) {
        if (category.focused) {
          Category cat = category;
          cat.focused = false;
          cat.branchId = branchId;
          cat.active = false;
        }
      }

      Category cat = category;
      cat.focused = true;
      cat.active = true;
      cat.branchId = branchId;
    });
    app.loadCategories();
  }

  /// Should save a focused unit given the id to persist to
  /// the Id can be ID of product or variant
  void saveFocusedUnit(
      {required IUnit newUnit, String? id, required String type}) async {
    final int branchId = ProxyService.box.getBranchId()!;
    ProxyService.local.realm!.write(() {
      for (IUnit unit in units) {
        if (unit.active) {
          unit.active = false;
          unit.branchId = branchId;
        }
      }
      newUnit.active = true;
      newUnit.branchId = branchId;
      if (type == 'product') {
        product?.unit = newUnit.name;
        // get updated product
        product = ProxyService.local.getProduct(id: product!.id!);
      }

      if (type == 'variant') {
        // Update variants if needed
        // final Map data = product.toJson();
        // data['unit'] = unit.name;
        // ProxyService.isar.update(data: data);
      }
    });
    loadUnits();
    log('updating unit 4', name: 'saveFocusedUnit');
    notifyListeners();
  }

  void updateStock({required int variantId}) async {
    if (_stockValue != null) {
      Stock? stock = await ProxyService.local.stockByVariantId(
          variantId: variantId, branchId: ProxyService.box.getBranchId()!);
      ProxyService.local.realm!.writeAsync(() async {
        stock!.currentStock = _stockValue!;
      });
    }
  }

  double? _stockValue;
  double? get stockValue => _stockValue;
  void setStockValue({required double value}) {
    _stockValue = value;
    rebuildUi();
  }

  void deleteVariant({required int id}) async {
    Variant? variant = await ProxyService.local.variant(variantId: id);
    // can not delete regular variant every product should have a regular variant.
    if (variant!.name != 'Regular') {
      ProxyService.local.delete(
          id: id, endPoint: 'variation', flipperHttpClient: ProxyService.http);
      //this will reload the variations remain
      getProduct();
    }
  }

  Future<void> switchColor(
      {required PColor color, required WidgetRef widgetReference}) async {
    int branchId = ProxyService.box.getBranchId()!;
    for (PColor c in colors) {
      if (c.active) {
        final PColor? _color = await ProxyService.local.getColor(id: c.id!);
        ProxyService.local.realm!.write(() {
          _color!.active = false;
          _color.branchId = branchId;
        });
      }
    }

    final PColor? _color = await ProxyService.local.getColor(id: color.id!);
    ProxyService.local.realm!.write(() {
      _color!.active = true;
      _color.branchId = branchId;
      product!.color = color.name!;
      widgetReference
          .read(unsavedProductProvider.notifier)
          .emitProduct(value: product!);
    });

    setCurrentColor(color: color.name!);

    loadColors();
  }

  setUnit({required String unit}) {
    productService.setProductUnit(unit: unit);
    notifyListeners();
  }

  /// add variation to a product [variations],[retailPrice],[supplyPrice]

  void navigateAddVariation(
      {required int productId, required BuildContext context}) {
    _routerService.navigateTo(AddVariationRoute(productId: productId));
  }

  /// When called should check the related product's variant and set the retail and or supply price
  /// of related stock
  Future<void> updateRegularVariant({
    required bool inUpdateProcess,
    int? productId,
    double? supplyPrice,
    double? retailPrice,
  }) async {
    Product? product = ProxyService.local.getProduct(id: productId ?? 0);
    List<Variant> variants = await ProxyService.local.variants(
        branchId: ProxyService.box.getBranchId()!, productId: productId);

    ProxyService.local.realm!.writeAsync(() async {
      if (supplyPrice != null) {
        for (Variant variation in variants) {
          if (variation.name == "Regular") {
            variation.supplyPrice = supplyPrice;
            variation.productName = product!.name;

            variation.productId = variation.productId;
            Stock? stock = await ProxyService.local.stockByVariantId(
                variantId: variation.id!,
                branchId: ProxyService.box.getBranchId()!);

            stock!.supplyPrice = supplyPrice;
          }
        }
      }

      if (retailPrice != null) {
        for (Variant variation in variants) {
          if (variation.name == "Regular") {
            variation.retailPrice = retailPrice;
            variation.productId = variation.productId;
            variation.prc = retailPrice;

            variation.productName = product!.name;
            Stock? stock = await ProxyService.local.stockByVariantId(
                variantId: variation.id!,
                branchId: ProxyService.box.getBranchId()!);

            stock!.retailPrice = retailPrice;
          }
        }
      }
    });
  }

  /// Add a product into the favorites
  Future<int> addFavorite(
      {required int favIndex, required int productId}) async {
    final favorite = Favorite(
      ObjectId(),
      favIndex: favIndex,
      productId: productId,
      branchId: ProxyService.box.getBranchId(),
    );

    int res = await ProxyService.local.addFavorite(data: favorite);
    rebuildUi();

    return res;
  }

  Future<void> deleteProduct({required int productId}) async {
    //get variants->delete
    int branchId = ProxyService.box.getBranchId()!;
    List<Variant> variations = await ProxyService.local
        .variants(branchId: branchId, productId: productId);
    for (Variant variation in variations) {
      //get stock->delete
      Stock? stock = await ProxyService.local.stockByVariantId(
          variantId: variation.id!, branchId: ProxyService.box.getBranchId()!);

      await ProxyService.local.delete(
          id: variation.id!,
          endPoint: 'variant',
          flipperHttpClient: ProxyService.http);
      await ProxyService.local.delete(
          id: stock!.id!,
          endPoint: 'stock',
          flipperHttpClient: ProxyService.http);

      Favorite? fav =
          await ProxyService.local.getFavoriteByProdId(prodId: productId);
      if (fav != null) {
        await ProxyService.local.deleteFavoriteByIndex(favIndex: fav.id!);
      }
    }
    //then delete the product
    await ProxyService.local.delete(
        id: productId,
        endPoint: 'product',
        flipperHttpClient: ProxyService.http);
  }

  void updateExpiryDate(DateTime date) async {
    ProxyService.local.realm!.writeAsync(() async {
      product!.expiryDate = date.toIso8601String();
    });
    Product? cProduct = ProxyService.local.getProduct(id: product!.id!);
    setCurrentProduct(currentProduct: cProduct!);
    rebuildUi();
  }

  Stream<String> getProductName() async* {
    yield product != null ? product!.name! : '';
  }

  void deleteDiscount({id}) {
    ProxyService.local.delete(
        id: id, endPoint: 'discount', flipperHttpClient: ProxyService.http);
  }

  /// loop through transaction's items and update item with discount in consideration
  /// a discount can not go beyond the item's price
  Future<bool> applyDiscount({required Discount discount}) async {
    int branchId = ProxyService.box.getBranchId()!;
    ITransaction? transaction =
        await ProxyService.keypad.getPendingTransaction(branchId: branchId);

    if (transaction != null) {
      List<TransactionItem> transactionItems = await ProxyService.local
          .getTransactionItemsByTransactionId(transactionId: transaction.id);
      ProxyService.local.realm!.write(() {
        for (TransactionItem item in transactionItems) {
          if (item.price.toInt() <= discount.amount!) {
            item.discount = item.price;
          } else {
            item.discount = discount.amount!.toDouble();
          }
        }
      });
      return true;
    }
    return false;
  }

  Future<void> bindTenant(
      {required int tenantId, required int productId}) async {
    try {
      await ProxyService.local
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
