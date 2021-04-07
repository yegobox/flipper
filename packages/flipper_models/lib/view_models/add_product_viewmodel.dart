library flipper_models;

import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper/utils/logger.dart';
import 'package:flipper/views/welcome/home/common_view_model.dart';
import 'package:flipper_models/category.dart';
import 'package:flipper_models/image.dart';
import 'package:flipper_models/pcolor.dart';
import 'package:flipper_models/product.dart';
import 'package:flipper_models/stock.dart';
import 'package:flipper_models/unit.dart';
import 'package:flipper_models/variation.dart';
import 'package:flipper_models/view_models/Queries.dart';
import 'package:flipper_services/database_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/shared_state_service.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';

class AddProductViewmodel extends ReactiveViewModel {
  final Logger log = Logging.getLogger('add product view model:)');

  Category _category;

  String _colorName;

  final DatabaseService _databaseService = ProxyService.database;

  String _description;

  Unit _focusedUnit;

  bool _isLocked = true;

  String _name;

  double _retailPriceController;

  final state = locator<SharedStateService>();

  double _supplierPriceController;

  int _test;

  Stock _stock;

  // ignore: missing_return
  String setName({String name}) {
    _name = name;
    notifyListeners();
  }

  void setSupplierPriceController({double price}) {
    _supplierPriceController = price;
    notifyListeners();
  }

  List<PColor> get colors => state.colors;

  ImageP get image => state.image;

  PColor get currentColor => state.currentColor;

  Product get product => state.product;

  bool get isLocked {
    return _isLocked;
  }

  int get test {
    return _test;
  }

  void tee() {
    _test++;
    notifyListeners();
  }

  void setRetailPriceController({double price}) {
    _retailPriceController = price;
    notifyListeners();
  }

  void onClose() async {
    ProxyService.nav.pop();
  }

  Category get category {
    return _category;
  }

  Future<void> handleCreateItem() async {
    assert(product != null);
    // assert(category != null);
    assert(_name != null);

    //first check the color given

    await updateProduct(
      productId: product.id,
      color: state.currentColor.name,
      categoryId: category == null ? '10' : category.id,
    );
    // we look for a regular variant which is always have id=to productID and updated it with pricing.
    // final Document variation = _databaseService.getById(id: product.id);
    final q = Query(_databaseService.db, Queries.Q_1);

    q.parameters = {'VALUE': AppTables.variation, 'PRODUCTID': product.id};

    final variations = q.execute();
    final List t = variations.allResults;
    if (t.isNotEmpty) {
      for (Map map in t) {
        //expect variation to be 1 as variant = one stock
        updateVariationsStock(
          variation: Variation.fromMap(map),
          productName: _name,
          supplyPrice: _supplierPriceController,
          retailPrice: _retailPriceController,
        );
      }
    }
  }

  Future<void> updatedVariation(
      {String productName, String variationId}) async {
    final variant = _databaseService.getById(id: variationId);
    variant.properties['productName'] = productName;
    _databaseService.update(document: variant);
  }

  Future<void> updateVariationsStock({
    Variation variation,
    String productName,
    double retailPrice,
    double supplyPrice,
  }) async {
    if (variation != null) {
      updatedVariation(productName: productName, variationId: variation.id);

      final q = Query(_databaseService.db, Queries.Q_2);

      q.parameters = {'VALUE': AppTables.stock, 'VARIANTID': variation.id};

      final stocks = q.execute();
      final List t = stocks.allResults;
      if (t.isNotEmpty) {
        for (Map map in t) {
          //expect stock to be 1 as variant = one stock
          _stock = Stock.fromMap(map);
          final stock = _databaseService.getById(id: _stock.id);
          assert(stock != null);
          assert(retailPrice != null);
          assert(supplyPrice != null);
          stock.properties['retailPrice'] = retailPrice;
          stock.properties['supplyPrice'] = supplyPrice;
          _databaseService.update(document: stock);
        }
      }
    }
  }

  Future<bool> updateProduct(
      {CommonViewModel vm,
      String productId,
      String categoryId,
      String color}) async {
    final Document product = _databaseService.getById(id: productId);

    assert(product != null);
    product.properties['name'] = _name;
    product.properties['color'] = color;
    product.properties['isDraft'] = false;
    product.properties['description'] = _description ?? 'No Description';

    product.properties['categoryId'] = categoryId;
    product.properties['updatedAt'] = DateTime.now().toIso8601String();

    _databaseService.update(document: product);
    return true;
  }

  void createVariant({String productId}) {
    _isLocked = true;
    notifyListeners();
    ProxyService.nav.navigateTo(Routing.addVariationScreen,
        arguments: AddVariationScreenArguments(productId: productId));
  }

  void lock() {
    _name.isEmpty ? _isLocked = true : _isLocked = false;
    notifyListeners();
  }

  // ignore: always_specify_types
  Future getTemporalProduct({CommonViewModel vm}) async {
    setBusy(true);

    final q = Query(_databaseService.db, Queries.Q_5);

    q.parameters = {'VALUE': AppTables.product, 'NAME': 'tmp'};

    final products = q.execute();
    final List t = products.allResults;
    if (t.isNotEmpty) {
      for (Map map in t) {
        //get the Regular variant to update when needed
        final regularVariant = Query(_databaseService.db, Queries.Q_7);
        state.setProduct(product: Product.fromMap(map));
        regularVariant.parameters = {
          'VALUE': AppTables.variation,
          'NAME': 'Regular',
          'PRODUCTID': Product.fromMap(map).id
        };
        final results = regularVariant.execute();
        final List tt = results.allResults;
        if (tt.isNotEmpty) {
          for (Map map in tt) {
            state.setVariation(variation: Variation.fromMap(map));
          }
        }
      }
      notifyListeners();
    }

    setBusy(false);
    notifyListeners();
  }

  String get colorName {
    return _colorName;
  }

  Unit get focusedUnit {
    return _focusedUnit;
  }

  void setDescription({String description}) {
    _description = description;
    notifyListeners();
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [state];
}
