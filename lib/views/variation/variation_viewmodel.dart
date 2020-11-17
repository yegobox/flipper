
import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/locator.dart';
import 'package:flipper/services/shared_state_service.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper/model/stock.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/model/product.dart';
import 'package:flipper/model/variation.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flipper/utils/logger.dart';
import 'package:flipper/viewmodels/base_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:logger/logger.dart';
import 'package:redux/redux.dart';
import 'package:uuid/uuid.dart';

class VariationViewModel extends BaseModel {
  final Logger log = Logging.getLogger('variation model:)');
  final DatabaseService _databaseService = ProxyService.database;
  List<Variation> variations;
  List<Variation> get data => variations;

  Product _product;
  Product get product => _product;

  Variation _variation;
  Variation get variation => _variation;

  Stock _stock;
  Stock get stock => _stock;

  final sharedStateService = locator<SharedStateService>();

  void getStockByProductId({String productId, BuildContext context}) async {
    
    final q = Query(_databaseService.db, 'SELECT * WHERE table=\$VALUE AND productId=\$productId');

    q.parameters = {'VALUE': AppTables.variation,'productId':productId};

    
    q.addChangeListener((List results) {
   
       for (Map map in results) {

        map.forEach((key,value){
           _stock = Stock.fromMap(value);
        });
        notifyListeners();
      }
    });
  }

  void getVariationById({String productId, BuildContext context}) async {
   
    final q = Query(_databaseService.db, 'SELECT * WHERE table=\$VALUE AND productId=\$productId');

    q.parameters = {'VALUE': AppTables.variation,'productId':productId};

    
    q.addChangeListener((List results) {
   
       for (Map map in results) {

        map.forEach((key,value){
           _variation = Variation.fromMap(value);
        });
        notifyListeners();
      }
    });
    
  }

  void getProductById({String productId, BuildContext context}) async {
    setBusy(true);

     final q = Query(_databaseService.db, 'SELECT * WHERE table=\$VALUE AND id=\$productId');

    q.parameters = {'VALUE': AppTables.product,'productId':productId};

    final productResults = q.execute();
     for (Map map in productResults) {

        map.forEach((key,value){
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

    
    q.addChangeListener((List results) {
   
       for (Map map in results) {

        map.forEach((key,value){
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
    final Store<AppState> store = StoreProvider.of<AppState>(context);

    // create variation
    final Document variant = _databaseService.insert(data: {
      'isActive': false,
      'name': nameController.text,
      'unit': 'kg',
      'channels': <String>[store.state.user.id],
      'table': AppTables.variation,
      'productId': productId,
      'sku': Uuid().v1().substring(0, 4),
      'id': Uuid().v1(),
      'createdAt': DateTime.now().toIso8601String(),
    });

    //create stock
    // ignore: unused_local_variable
    final Document stock = _databaseService.insert(data: {
      'variantId': variant.ID,
      'supplyPrice': double.parse(costController.text),
      'canTrackingStock': false,
      'showLowStockAlert': false,
      'retailPrice': double.parse(retailController.text),
      'channels': [store.state.user.id],
      'isActive': true,
      'table': AppTables.stock,
      'lowStock': 0,
      'currentStock': 0,
      'id': Uuid().v1(),
      'productId': productId,
      'branchId': store.state.branch.id,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  void initFields(TextEditingController name, TextEditingController cost,
      TextEditingController retail) {
    _nameController = name;
    _costController = cost;
    _retailController = retail;
  }

  void updateVariation({Variation variation})async {
    
    // TODO(richard): [lonald] implement update variation
    log.i(variation);
    await ProxyService.toast.showCustomSnackBar(
      title: 'Feedback',
      message: 'Update method is not implemented',
      duration: const Duration(
        milliseconds: 1500,
      ),
    );
  }

  void closeAndDelete({BuildContext context, String productId})async {
    log.i(productId);
    // TODO(richard): [lonald] implement delete product
    await ProxyService.toast.showCustomSnackBar(
      title: 'Feedback',
      message: 'delete method is not implemented',
      duration: const Duration(
        milliseconds: 1500,
      ),
    );
  }

  void handleEditItem({List<bool> selections})async {
    // TODO(richard): [lonald] implement edit product
    
    await ProxyService.toast.showCustomSnackBar(
      title: 'Feedback',
      message: 'edit method is not implemented',
      duration: const Duration(
        milliseconds: 1500,
      ),
    );
  }
}
