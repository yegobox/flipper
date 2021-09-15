library flipper_models;

import 'package:flipper_models/discount.dart';
import 'package:flipper_models/order.dart';
import 'package:flipper_models/order_item.dart';
import 'package:flipper_models/view_models/business_home_viewmodel.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:flipper_models/category.dart';
import 'package:flipper_models/product.dart';
import 'package:flipper_models/color.dart';
import 'package:flipper_models/stock.dart';
import 'package:flipper_models/unit.dart';
import 'package:flipper_models/product_mock.dart';
import 'package:flipper_models/variants.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/product_service.dart';

import 'package:flipper_services/constants.dart';

class ProductViewModel extends BusinessHomeViewModel {
  final AppService _appService = locator<AppService>();
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
    await productService.loadProducts(branchId: branchId);
  }

  /// Create a temporal product to use during this session of product creation
  /// the same product will be use if it is still temp product
  ///
  String kProductName = 'null';
  Future<int> loadTemporalproductOrEditIfProductIdGiven(
      {int? productId}) async {
    if (productId != null) {
      Product? product = await ProxyService.api.getProduct(id: productId);
      productService.setCurrentProduct(product: product!);
      kProductName = product.name;
      productService.variantsProduct(productId: product.id);
      notifyListeners();
      return product.id;
    }
    int branchId = ProxyService.box.read(key: 'branchId');
    List<Product> isTemp =
        await ProxyService.api.isTempProductExist(branchId: branchId);
    if (isTemp.isEmpty) {
      Product product =
          await ProxyService.api.createProduct(product: productMock);
      productService.variantsProduct(productId: product.id);

      productService.setCurrentProduct(product: product);
      kProductName = product.name;
      notifyListeners();
      return product.id;
    }

    productService.setCurrentProduct(product: isTemp[0]);
    productService.variantsProduct(productId: isTemp[0].id);
    notifyListeners();

    return isTemp[0].id;
  }

  void isPriceSet(bool bool) {
    _price = bool;
    _lock = !bool || _name == null;
    notifyListeners();
  }

  bool _price = false;

  void setName({String? name}) {
    _name = name;
    final cleaned = name?.trim();
    _lock = cleaned?.length == null || cleaned?.length == 0 || !_price;
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
    final String? userId = ProxyService.box.read(key: 'userId');
    final int? branchId = ProxyService.box.read(key: 'branchId');
    final categoryId = DateTime.now().millisecondsSinceEpoch;
    final Category category = new Category(
      id: categoryId,
      active: true,
      table: AppTables.category,
      focused: false,
      name: name,
      channels: [userId!],
      fbranchId: branchId!,
    );
    await ProxyService.api
        .create(endPoint: 'category', data: category.toJson());
    _appService.loadCategories();
  }

  void updateCategory({required Category category}) async {
    int branchId = ProxyService.box.read(key: 'branchId');
    for (Category category in categories) {
      if (category.focused) {
        Category cat = category;
        cat.focused = !cat.focused;
        cat.fbranchId = branchId;
        cat.active = !cat.active;
        int categoryId = category.id;
        await ProxyService.api.update(
          endPoint: 'category/$categoryId',
          data: cat.toJson(),
        );
      }
    }

    Category cat = category;
    cat.focused = !cat.focused;
    cat.active = !cat.active;
    cat.fbranchId = branchId;
    int categoryId = category.id;
    await ProxyService.api.update(
      endPoint: 'category/$categoryId',
      data: cat.toJson(),
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
        int id = unit.id;
        await ProxyService.api.update(
          endPoint: 'unit/$id',
          data: unit.toJson(),
        );
      }
    }
    Unit unit = newUnit;
    unit.active = !unit.active;
    int id = unit.id;
    await ProxyService.api.update(
      endPoint: 'unit/$id',
      data: unit.toJson(),
    );
    if (type == 'product') {
      final Map data = product.toJson();
      data['unit'] = unit.name;
      ProxyService.api.update(data: data, endPoint: 'product');
      final Product? uProduct =
          await ProxyService.api.getProduct(id: product.id);
      productService.setCurrentProduct(product: uProduct!);
    }
    if (type == 'variant') {
      // final Map data = product.toJson();
      // data['unit'] = unit.name;
      // ProxyService.api.update(data: data, endPoint: 'variant');
    }
    _appService.loadUnits();
  }

  void updateStock({required int variantId}) async {
    if (_stockValue != null) {
      Stock stock =
          await ProxyService.api.stockByVariantId(variantId: variantId);
      Map data = stock.toJson();
      data['currentStock'] = _stockValue;
      final int stockId = data['id'];

      ProxyService.api.update(data: data, endPoint: 'stock/$stockId');
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
    Variant? variant = await ProxyService.api.variant(variantId: id);
    // can not delete regular variant every product should have a regular variant.
    if (variant!.name != 'Regular') {
      ProxyService.api.delete(id: id, endPoint: 'variation');
      //this will reload the variations remain
      loadTemporalproductOrEditIfProductIdGiven();
    }
  }

  void browsePictureFromGallery({productId}) {
    ProxyService.upload.browsePictureFromGallery(productId: productId);
  }

  void takePicture({productId}) {
    ProxyService.upload.takePicture(productId: productId);
  }

  Future<void> switchColor({required PColor color}) async {
    int branchId = ProxyService.box.read(key: 'branchId');
    for (PColor c in colors) {
      if (c.active) {
        final PColor? _color =
            await ProxyService.api.getColor(id: c.id, endPoint: 'color');
        final Map mapColor = _color!.toJson();
        mapColor['active'] = false;
        mapColor['branchId'] = branchId;
        final id = mapColor['id'];
        ProxyService.api.update(data: mapColor, endPoint: 'color/$id');
      }
    }

    final PColor? _color =
        await ProxyService.api.getColor(id: color.id, endPoint: 'color');

    final Map mapColor = _color!.toJson();

    mapColor['active'] = true;
    mapColor['branchId'] = branchId;
    final id = mapColor['id'];
    ProxyService.api.update(data: mapColor, endPoint: 'color/$id');

    _appService.setCurrentColor(color: color.name!);

    loadColors();
  }

  setUnit({required String unit}) {
    productService.setProductUnit(unit: unit);
  }

  Future<int> addVariant(
      {List<Variant>? variations,
      required double retailPrice,
      required double supplyPrice}) async {
    int result = await ProxyService.api.addVariant(
        data: variations!, retailPrice: retailPrice, supplyPrice: supplyPrice);
    return result;
  }

  void navigateAddVariation({required int productId}) {
    ProxyService.nav.navigateTo(
      Routes.variation,
      arguments: AddVariationArguments(
        productId: productId,
      ),
    );
  }

  /// When called should check the related product's variant and set the retail and or supply price
  /// of related stock
  void updateRegularVariant({double? supplyPrice, double? retailPrice}) async {
    if (supplyPrice != null) {
      for (Variant variation in variants!) {
        if (variation.name == "Regular") {
          Map map = variation.toJson();
          map["supplyPrice"] = supplyPrice;
          map["fproductId"] = variation.fproductId;
          int ids = map['id'];
          ProxyService.api.update(data: map, endPoint: 'variant/$ids');
          Stock stock =
              await ProxyService.api.stockByVariantId(variantId: variation.id);
          Map data = stock.toJson();
          data['supplyPrice'] = supplyPrice;
          int id = data['id'];
          ProxyService.api.update(data: data, endPoint: 'stock/$id');
        }
      }
    }

    if (retailPrice != null) {
      for (Variant variation in variants!) {
        if (variation.name == "Regular") {
          Map map = variation.toJson();
          map["retailPrice"] = retailPrice;
          map["fproductId"] = variation.fproductId;
          int ids = map['id'];
          ProxyService.api.update(data: map, endPoint: 'variant/$ids');
          Stock stock =
              await ProxyService.api.stockByVariantId(variantId: variation.id);

          Map data = stock.toJson();
          data['retailPrice'] = retailPrice;
          int id = data['id'];
          ProxyService.api.update(data: data, endPoint: 'stock/$id');
        }
      }
    }
    productService.variantsProduct(productId: product.id);
  }

  Future<bool> addProduct({required Map mproduct, required String name}) async {
    mproduct['name'] = name;
    mproduct['barCode'] = productService.barCode.toString();
    log.i(productService.barCode);
    mproduct['color'] = currentColor;
    // update the variant with the product name
    List<Variant> variants =
        await ProxyService.api.getVariantByProductId(productId: mproduct['id']);
    for (Variant variant in variants) {
      Map v = variant.toJson();
      v['productName'] = name;
      v['fproductId'] = mproduct['id'];
      int id = v['id'];
      await ProxyService.api.update(data: v, endPoint: 'variant/$id');
    }
    final response =
        await ProxyService.api.update(data: mproduct, endPoint: 'product');
    return response == 200;
  }

  void deleteProduct({required int productId}) async {
    //get variants->delete
    int branchId = ProxyService.box.read(key: 'branchId');
    List<Variant> variations = await ProxyService.api
        .variants(branchId: branchId, productId: productId);
    for (Variant variation in variations) {
      ProxyService.api.delete(id: variation.id, endPoint: 'variation');
      //get stock->delete
      Stock stock =
          await ProxyService.api.stockByVariantId(variantId: variation.id);
      ProxyService.api.delete(id: stock.id, endPoint: 'stock');
    }
    //then delete the product
    ProxyService.api.delete(id: productId, endPoint: 'product');
    loadProducts(); //refresh list of products
  }

  void updateExpiryDate(DateTime date) async {
    Map kProduct = product.toJson();
    kProduct['expiryDate'] = date.toIso8601String();
    ProxyService.api.update(data: kProduct, endPoint: 'product');
    Product? Cproduct = await ProxyService.api.getProduct(id: kProduct['id']);
    productService.setCurrentProduct(product: Cproduct!);
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
    ProxyService.api.delete(id: id, endPoint: 'discount');
    loadProducts();
  }

  /// loop through order's items and update item with discount in consideration
  /// a discount can not go beyond the item's price
  void applyDiscount({required Discount discount}) async {
    int branchId = ProxyService.box.read(key: 'branchId');
    OrderF orders = await ProxyService.keypad.getOrder(branchId: branchId);

    for (OrderItem item in orders.orderItems) {
      /// if the item price is for example 10 and the discount is 200
      if (item.price.toInt() < discount.amount! && item.discount == null) {
        /// then the discount can not go beyond the item's price
        /// then the  item discount is the actual item price
        item.discount = item.price;
        //update the item in the order
        int id = item.id;
        ProxyService.api.update(data: item.toJson(), endPoint: 'orderItem/$id');
      } else if (item.discount == null) {
        int id = item.id;
        item.discount = item.price - discount.amount!.toDouble();
        ProxyService.api.update(data: item.toJson(), endPoint: 'orderItem/$id');
      }
      getTotal();
    }
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices =>
      [_appService, productService];
}
