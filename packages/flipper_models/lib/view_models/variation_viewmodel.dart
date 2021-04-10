library flipper_models;

import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper/utils/logger.dart';
import 'package:flipper_models/product.dart';
import 'package:flipper_models/stock.dart';
import 'package:flipper_models/unit.dart';
import 'package:flipper_models/variant_stock.dart';
import 'package:flipper_models/variation.dart';
import 'package:flipper_services/database_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/shared_state_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

import 'Queries.dart';
import 'base_model.dart';

class VariationViewModel extends BaseModel {
  final Logger log = Logging.getLogger('variation model:)');
  final DatabaseService _databaseService = ProxyService.database;
  final List<VariantStock> _variations = [];
  List<VariantStock> get variations => _variations;

  Product _product;
  Product get product => _product;

  Variation _variation;
  Variation get variation => _variation;

  Stock _stock;
  Stock get stock => _stock;

  final sharedStateService = locator<SharedStateService>();

  void getStockByProductId({String productId, BuildContext context}) async {
    final q = Query(_databaseService.db, Queries.Q_1);

    q.parameters = {'VALUE': AppTables.variation, 'PRODUCTID': productId};

    q.addChangeListener((results) {
      for (Map map in results.allResults) {
        _stock = Stock.fromMap(map);
        notifyListeners();
      }
    });
  }

  void getVariationsByProductId({String productId}) async {
    final q = Query(_databaseService.db, Queries.Q_13);

    q.parameters = {'PRODUCTID': productId ?? sharedStateService.product.id};
    q.addChangeListener((results) {
      // issue found in the join query is that it show result of two joined doc even though I expect one!
      for (Map map in results.allResults) {
        _variations.clear();
        if (map.length > 2) {
          _variations.add(VariantStock.fromMap(map));
        }
        notifyListeners();
      }
    });
  }

  void getProductById({String productId, BuildContext context}) async {
    setBusy(true);

    final q = Query(
        _databaseService.db, 'SELECT * WHERE table=\$VALUE AND id=\$productId');

    q.parameters = {'VALUE': AppTables.product, 'productId': productId};

    final productResults = q.execute();
    for (Map map in productResults.allResults) {
      map.forEach((key, value) {
        _product = Product.fromMap(value);
      });
      notifyListeners();
    }
  }

  void getProducts({BuildContext context}) {
    setBusy(true);

    final List<Product> list = <Product>[];

    final q = Query(_databaseService.db, 'SELECT * WHERE table=\$VALUE');

    q.parameters = {'VALUE': AppTables.variation};

    q.addChangeListener((results) {
      for (Map map in results.allResults) {
        map.forEach((key, value) {
          list.add(Product.fromMap(value));
        });
        setBusy(false);
        notifyListeners();
      }
    });
  }

  bool get isLocked {
    return _isLocked;
  }

  bool _isLocked = true;
  void lock() {
    // ONE
    _nameController.text.isEmpty ? _isLocked = true : _isLocked = false;
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
  // create a variation and create stock related to it with supplier and cost price
  Future<void> createVariant({BuildContext context, String productId}) async {
    String unit;
    for (Unit u in ProxyService.sharedState.units) {
      if (u.focused) {
        unit = u.name;
      }
    }
    // create variation
    final String id = Uuid().v1();
    final Document variant = _databaseService.insert(id: id, data: {
      'isActive': true,
      'name': nameController.text,
      'unit': unit,
      'channels': <String>[ProxyService.sharedState.user.id.toString()],
      'table': AppTables.variation,
      'productId': productId,
      'sku': Uuid().v1().substring(0, 4), //todo: also consider user input
      'id': id,
      'createdAt': DateTime.now().toIso8601String(),
    });

    //create stock
    // ignore: unused_local_variable
    final stockId = Uuid().v1();
    _databaseService.insert(id: stockId, data: {
      'variantId': variant.ID,
      'supplyPrice': double.parse(costController.text),
      'canTrackingStock': false,
      'showLowStockAlert': false,
      'retailPrice': double.parse(retailController.text),
      'channels': [ProxyService.sharedState.user.id.toString()],
      'isActive': true,
      'table': AppTables.stock,
      'lowStock': 0.0,
      'currentStock': 0.0,
      'id': stockId,
      'productId': productId,
      'branchId': ProxyService.sharedState.branch.id,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  void initFields(TextEditingController name, TextEditingController cost,
      TextEditingController retail) {
    _nameController = name;
    _costController = cost;
    _retailController = retail;
  }

  void updateVariation({Variation variation}) async {
    // log.i(variation);
    await ProxyService.toast.showCustomSnackBar(
      title: 'Feedback',
      message: 'Update method is not implemented',
      duration: const Duration(
        milliseconds: 1500,
      ),
    );
  }

  void closeAndDelete({BuildContext context, String productId}) async {
    log.i(productId);
    // TODO(richard): implement delete product
    await ProxyService.toast.showCustomSnackBar(
      title: 'Feedback',
      message: 'delete method is not implemented',
      duration: const Duration(
        milliseconds: 1500,
      ),
    );
  }

  void handleEditItem({List<bool> selections}) async {
    // TODO(richard):  implement edit product

    await ProxyService.toast.showCustomSnackBar(
      title: 'Feedback',
      message: 'edit method is not implemented',
      duration: const Duration(
        milliseconds: 1500,
      ),
    );
  }
}
