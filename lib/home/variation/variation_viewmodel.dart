import 'package:couchbase_lite/couchbase_lite.dart';
import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/helper/constant.dart';
import 'package:flipper/model/stock.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/model/product.dart';
import 'package:flipper/model/variation.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flipper/utils/data_manager.dart';
import 'package:flipper/utils/logger.dart';
import 'package:flipper/viewmodels/base_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:logger/logger.dart';
import 'package:redux/redux.dart';
import 'package:uuid/uuid.dart';

class VariationViewModel extends BaseModel {
  final Logger log = Logging.getLogger('product observer:)');
  final DatabaseService _databaseService = ProxyService.database;
  List<Variation> variations;
  List<Variation> get data => variations;

  Product _product;
  Product get product => _product;

  Variation _variation;
  Variation get variation =>_variation;

  Stock _stock;
  Stock get stock =>_stock;

  void getStockByProductId({String productId, BuildContext context})async {
     final List<Map<String, dynamic>> product = await _databaseService.filter(
        property: 'tableName',
        equator: AppTables.variation +
            StoreProvider.of<AppState>(context).state.branch.id,
        and: true,
        andProperty: 'productId',
        andEquator: productId);

    _stock = Stock.fromMap(product[0]['main']);
    notifyListeners();
  }
  void getVariationById({String productId,BuildContext context})async {
     final List<Map<String, dynamic>> product = await _databaseService.filter(
        property: 'tableName',
        equator: AppTables.variation +
            StoreProvider.of<AppState>(context).state.branch.id,
        and: true,
        andProperty: 'productId',
        andEquator: productId);

    _variation = Variation.fromMap(product[0]['main']);
    notifyListeners();
  }
  Future<void> updateVariation({
    Variation variation,
   
  }) async {
    log.d('methid updateVariation needs to be implemented');
    // if (variation != null) {
    //   final StockTableData stock = await store.state.database.stockDao
    //       .getStockByVariantId(
    //           branchId: store.state.branch.id, variantId: variation.id);
    //   final VariationTableData variant = await store.state.database.variationDao
    //       .getVariationById(variantId: variation.id);
    //   await store.state.database.variationDao
    //       .updateVariation(variant.copyWith(name: variantName));

    //   await store.state.database.stockDao.updateStock(
    //     stock.copyWith(
    //       retailPrice: retailPrice,
    //       supplyPrice: supplyPrice,
    //     ),
    //   );
    // }
  }
  void getProductById({String productId, BuildContext context}) async {
    setBusy(true);
    final List<Map<String, dynamic>> product = await _databaseService.filter(
        property: 'tableName',
        equator: AppTables.product +
            StoreProvider.of<AppState>(context).state.branch.id,
        and: true,
        andProperty: 'id',
        andEquator: productId);

    _product = Product.fromMap(product[0]['main']);
    notifyListeners();
    setBusy(false);
  }

  Future closeAndDelete(
      {@required String productId, BuildContext context}) async {
    final Store<AppState> store = StoreProvider.of<AppState>(context);
    await DataManager.deleteProduct(store: store, productId: productId);
    ProxyService.nav.pop();
  }

  Future handleEditItem({dynamic selections}) async {
    TaxTableData tax;
    // FIXME(richard): handle updating item
    if (selections[0] == true) {
      //then use 18 % known id in database. 0 index we know it is 18% 0 otherwise
      // tax = await store.state.database.taxDao.getByName(
      //     name: 'Vat', businessId: store.state.currentActiveBusiness.id);
    }

    // final ProductTableData product =
    //     await vm.database.productDao.getItemById(productId: widget.productId);

    // vm.database.actionsDao.updateAction(_actions.copyWith(isLocked: true));

    // vm.database.productDao.updateProduct(
    //   product.copyWith(
    //     taxId: tax.id ?? product.taxId,
    //     name: _name ?? product.name,
    //     updatedAt: DateTime.now(),
    //   ),
    // );
    ProxyService.nav.pop();
  }

  void getProducts({BuildContext context}) {
    setBusy(true);

    //demo of listening on users table on every entry.
    _databaseService
        .observer(
            equator: AppTables.product +
                StoreProvider.of<AppState>(context).state.branch.id,
            property: 'tableName')
        .stream
        .listen((ResultSet event) {
      // variations = event.allResults();
      final List<Map<String, dynamic>> model = event.map((Result result) {
        return result.toMap();
      }).toList();
      final List<Product> list = <Product>[];
      // remove unnecessarry nesting "main"appended on each map value
      for (Map<String, dynamic> map in model) {
        // ignore: always_specify_types
        // ignore: always_specify_types
        map.forEach((String key, value) {
          list.add(value);
        });
      }
      notifyListeners();

      setBusy(false);
    });
  }

  bool get isLocked {
    return _isLocked;
  }

  bool _isLocked = true;
  void lock() {
    _isLocked = true;
    notifyListeners();
  }

  TextEditingController _nameController;
  TextEditingController get nameController {
    return _nameController;
  }

  TextEditingController _skuController;
  TextEditingController get skuController {
    return _skuController;
  }

  // editing
  TextEditingController _costController;
  TextEditingController get costController {
    return _costController;
  }
  TextEditingController _retailController;
  TextEditingController get retailController {
    return _retailController;
  }
  // done editing variation

  double supplierPrice;
  double get getSupplierPrice {
    return supplierPrice;
  }

  double retailPrice;
  double get getRetailPrice {
    return retailPrice;
  }

  // add variant
  // insert default regular variant, the product should have one variant

  Future<void> createVariant({BuildContext context, String productId}) async {
    final List<Map<String, dynamic>> _variant = await _databaseService.filter(
        property: 'tableName',
        equator: AppTables.variation +
            StoreProvider.of<AppState>(context).state.branch.id,
        and: true,
        andProperty: 'productId',
        andEquator: productId);
    final Store<AppState> store = StoreProvider.of<AppState>(context);

    if (_variant != null && _variant.isNotEmpty) {
      // a product should have one regular variant
      //we have regular variation no need to create another one
      _databaseService.insert(data: {
        'isActive': false,
        'name': nameController.text,
        'unit': 'kg',
        'channels': <String>[store.state.user.id],
        'tableName': AppTables.variation + store.state.branch.id,
        'productId': productId,
        'sku': Uuid().v1().substring(0, 4),
        'id': Uuid().v1(),
        'createdAt': DateTime.now().toIso8601String(),
      });
    }
  }
}
