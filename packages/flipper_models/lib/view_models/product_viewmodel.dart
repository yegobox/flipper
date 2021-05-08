library flipper_models;

import 'package:flipper/routes.router.dart';
import 'package:flipper_models/models/category.dart';
import 'package:flipper_models/models/product.dart';
import 'package:flipper_models/models/color.dart';
import 'package:flipper_models/models/stock.dart';
import 'package:flipper_models/models/unit.dart';
import 'package:flipper_models/models/product_mock.dart';
import 'package:flipper_models/models/variation.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/product_service.dart';
import 'package:uuid/uuid.dart';

import 'package:flipper_services/constants.dart';

class ProductViewModel extends ReactiveViewModel {
  final AppService _appService = locator<AppService>();
  final ProductService _productService = locator<ProductService>();
  List<Product> _products = [];
  get products => _products;

  List<PColor> get colors => _appService.colors;

  List<Unit> get units => _appService.units;

  get categories => _appService.categories;

  get product => _productService.product;
  String? _name;
  get name => _name;

  get currentColor => _appService.currentColor;

  List<Variation>? get variants => _productService.variants;

  Future<List<Product>> loadProducts() async {
    _products = await ProxyService.api.products();

    notifyListeners();
    return _products;
  }

  /// Create a temporal product to use during this session of product creation
  /// the same product will be use if it is still temp product
  ///
  Future<String> createTemporalProduct() async {
    final List<Product> isTemp = await ProxyService.api.isTempProductExist();
    if (isTemp.isEmpty) {
      Product product =
          await ProxyService.api.createProduct(product: productMock);
      _productService.variantsProduct(productId: product.id);

      _productService.setCurrentProduct(product: product);
      notifyListeners();
      return product.id;
    }
    // ProxyService.api.delete(id: isTemp[0].id);
    // return "d";
    _productService.setCurrentProduct(product: isTemp[0]);
    _productService.variantsProduct(productId: isTemp[0].id);

    return isTemp[0].id;
  }

  void setName({String? name}) {
    _name = name;
    final cleaned = name?.trim();
    _lock = cleaned?.length == null || cleaned?.length == 0;
    notifyListeners();
  }

  bool _lock = false;
  bool get lock => _lock;

  void loadCategories() {
    print('#1');
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
    final String? branchId = ProxyService.box.read(key: 'branchId');
    final categoryId = Uuid().v1();
    final Category category = new Category(
      id: categoryId,
      active: true,
      table: AppTables.category,
      focused: false,
      name: name,
      channels: [userId!],
      branchId: branchId!,
    );
    await ProxyService.api
        .create(endPoint: 'category', data: category.toJson());
    _appService.loadCategories();
  }

  void updateCategory({required Category category}) async {
    for (Category category in categories) {
      if (category.focused) {
        Category cat = category;
        cat.focused = !cat.focused;
        cat.active = !cat.active;
        String categoryId = category.id;
        await ProxyService.api.update(
          endPoint: 'category/$categoryId',
          data: cat.toJson(),
        );
      }
    }

    Category cat = category;
    cat.focused = !cat.focused;
    cat.active = !cat.active;

    String categoryId = category.id;
    await ProxyService.api.update(
      endPoint: 'category/$categoryId',
      data: cat.toJson(),
    );
    _appService.loadCategories();
  }

  /// Should save a focused unit given the id to persist to
  /// the Id can be ID of product or variant
  void saveFocusedUnit(
      {required Unit newUnit, String? id, required String type}) async {
    for (Unit unit in units) {
      if (unit.focused) {
        unit.focused = !unit.focused;
        String id = unit.id;
        await ProxyService.api.update(
          endPoint: 'unit/$id',
          data: unit.toJson(),
        );
      }
    }
    Unit unit = newUnit;
    unit.focused = !unit.focused;
    String id = unit.id;
    await ProxyService.api.update(
      endPoint: 'unit/$id',
      data: unit.toJson(),
    );
    if (type == 'product') {
      final Map data = product.toJson();
      data['unit'] = unit.name;
      ProxyService.api.update(data: data, endPoint: 'product');
      final Product uProduct =
          await ProxyService.api.getProduct(id: product.id);
      _productService.setCurrentProduct(product: uProduct);
    }
    if (type == 'variant') {
      // final Map data = product.toJson();
      // data['unit'] = unit.name;
      // ProxyService.api.update(data: data, endPoint: 'variant');
    }
    _appService.loadUnits();
  }

  void updateStock({required String variantId}) async {
    if (_stockValue != null) {
      Stock stock =
          await ProxyService.api.stockByVariantId(variantId: variantId);
      Map data = stock.toJson();
      data['currentStock'] = _stockValue;
      ProxyService.api.update(data: data, endPoint: 'stock');
      _productService.variantsProduct(productId: product.id);
    }
    // ProxyService.api.stockByVariantIdStream(variantId: variantId);
    _productService.variantsProduct(productId: product.id);
  }

  double? _stockValue;
  double? get stockValue => _stockValue;
  void setStockValue({required double value}) {
    _stockValue = value;
    notifyListeners();
  }

  void deleteVariant({required String id}) {
    ProxyService.api.delete(id: id);
    createTemporalProduct(); //this will reload the variations remain
  }

  void browsePictureFromGallery({productId}) {
    ProxyService.upload.browsePictureFromGallery(productId: productId);
  }

  void takePicture({productId}) {
    ProxyService.upload.takePicture(productId: productId);
  }

  Future<void> switchColor({required PColor color}) async {
    for (PColor c in colors) {
      if (c.active) {
        final PColor _color = await ProxyService.api.getColor(id: c.id);
        final Map mapColor = _color.toJson();
        mapColor['active'] = false;
        ProxyService.api.update(data: mapColor, endPoint: 'color');
      }
    }

    final PColor _color = await ProxyService.api.getColor(id: color.id);

    final Map mapColor = _color.toJson();

    mapColor['active'] = true;

    ProxyService.api.update(data: mapColor, endPoint: 'color');

    _appService.setCurrentColor(color: color.name);

    loadColors();
  }

  setUnit({required String unit}) {
    _productService.setProductUnit(unit: unit);
  }

  Future<int> addVariant({
    required String name,
    required double retailPrice,
    required double supplyPrice,
    bool canTrackingStock = false,
    required String productId,
    String? sku,
  }) async {
    Variation data = new Variation(
      name: name,
      sku: sku!,
      productId: _productService.product!.id,
      unit: _productService.currentUnit!,
      channels: [_productService.userId!],
      productName: _productService.product!.name,
      branchId: _productService.branchId!,
      id: '',
      table: '',
    );
    int result = await ProxyService.api.addVariant(data: data.toJson());
    return result;
  }

  void navigateAddVariation({required String productId}) {
    ProxyService.nav.navigateTo(
      Routes.addVariation,
      arguments: AddVariationArguments(
        productId: productId,
      ),
    );
  }

  /// When called should check the related product's variant and set the retail and or supply price
  /// of related stock
  void updateRegularVariant({double? supplyPrice, double? retailPrice}) async {
    if (supplyPrice != null) {
      for (Variation variation in variants!) {
        if (variation.name == "Regular") {
          Stock stock =
              await ProxyService.api.stockByVariantId(variantId: variation.id);
          Map data = stock.toJson();
          data['supplyPrice'] = supplyPrice;
          String id = data['id'];
          ProxyService.api.update(data: data, endPoint: 'stock/$id');
        }
      }
    }
    if (retailPrice != null) {
      for (Variation variation in variants!) {
        if (variation.name == "Regular") {
          Stock stock =
              await ProxyService.api.stockByVariantId(variantId: variation.id);
          Map data = stock.toJson();
          data['retailPrice'] = retailPrice;
          String id = data['id'];
          ProxyService.api.update(data: data, endPoint: 'stock/$id');
        }
      }
    }
    _productService.variantsProduct(productId: product.id);
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices =>
      [_appService, _productService];
}
