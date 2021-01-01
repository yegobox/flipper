import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper/locator.dart';
import 'package:flipper/model/category.dart';
import 'package:flipper/model/image.dart';
import 'package:flipper/model/pcolor.dart';
import 'package:flipper/model/product.dart';
import 'package:flipper/model/unit.dart';
import 'package:flipper/model/variation.dart';

import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/services/shared_state_service.dart';
import 'package:flipper/views/welcome/home/common_view_model.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper/utils/logger.dart';

import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper/model/stock.dart';

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

  final _sharedStateService = locator<SharedStateService>();

  double _supplierPriceController;

  int _test;

  Stock _stock;

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_sharedStateService];

  // ignore: missing_return
  String setName({String name}) {
    _name = name;
    notifyListeners();
  }

  void setSupplierPriceController({double price}) {
    _supplierPriceController = price;
    notifyListeners();
  }

  List<PColor> get colors => _sharedStateService.colors;

  ImageP get image => _sharedStateService.image;

  PColor get currentColor => _sharedStateService.currentColor;

  Product get product => _sharedStateService.product;

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
    await updateProduct(
      productId: product
          .id, //to make life easy we make a regular variant have the same id as product
      categoryId: category == null ? '10' : category.id,
    );
    // we look for a regular variant which is always have id=to productID and updated it with pricing.
    // final Document variation = _databaseService.getById(id: product.id);
    final q = Query(_databaseService.db,
        'SELECT * WHERE table=\$VALUE AND productId=\$PRODUCTID');

    q.parameters = {'VALUE': AppTables.variation, 'PRODUCTID': product.id};

    final variations = q.execute();

    if (variations.isNotEmpty) {
      for (Map map in variations) {
        map.forEach((key, value) {
          //expect variation to be 1 as variant = one stock
          updateRegularVariationStock(
            variation: Variation.fromMap(value),
            supplyPrice: _supplierPriceController,
            retailPrice: _retailPriceController,
          );
        });
      }
    }
  }

  Future<void> updateRegularVariationStock({
    Variation variation,
    double retailPrice,
    double supplyPrice,
  }) async {
    if (variation != null) {
      log.i(variation.id);

      final q = Query(_databaseService.db,
          'SELECT * WHERE table=\$VALUE AND variantId=\$VARIANT_ID');

      q.parameters = {'VALUE': AppTables.stock, 'VARIANT_ID': variation.id};

      final stocks = q.execute();

      if (stocks.isNotEmpty) {
        for (Map map in stocks) {
          map.forEach((key, value) {
            //expect stock to be 1 as variant = one stock
            _stock = Stock.fromMap(value);
            final stock = _databaseService.getById(id: _stock.id);
            assert(stock != null);
            assert(retailPrice != null);
            assert(supplyPrice != null);

            stock.properties['retailPrice'] = retailPrice;
            stock.properties['supplyPrice'] = supplyPrice;
            _databaseService.update(document: stock);
          });
        }
      }
    }
  }

  Future<bool> updateProduct(
      {CommonViewModel vm, String productId, String categoryId}) async {
    final Document product = _databaseService.getById(id: productId);
    assert(product != null);
    product.properties['name'] = _name;
    product.properties['isDraft'] = false;
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
    // ignore: prefer_is_empty
    log.i(_name.length);
    _name.isEmpty ? _isLocked = true : _isLocked = false;
    notifyListeners();
  }

  // once full refacored
  // ignore: always_specify_types
  Future getTemporalProduct({CommonViewModel vm}) async {
    setBusy(true);

    final q = Query(
        _databaseService.db, 'SELECT * WHERE table=\$VALUE AND name=\$NAME');

    q.parameters = {'VALUE': AppTables.product, 'NAME': 'tmp'};

    final products = q.execute();

    if (products.isNotEmpty) {
      for (Map map in products) {
        map.forEach((key, value) {
          _sharedStateService.setProduct(product: Product.fromMap(value));
        });
        notifyListeners();
      }
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
    _description = _description;
    notifyListeners();
  }
}
