import 'package:flipper/model/category.dart';
import 'package:flipper/model/product.dart';
import 'package:flipper/model/tax.dart';
import 'package:flipper/model/variation.dart';
import 'package:couchbase_lite/couchbase_lite.dart';

import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flipper/services/flipperNavigation_service.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/ui/product/product_viewmodel.dart';
import 'package:flipper/ui/welcome/home/common_view_model.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

class AddProductViewmodel extends ProductViewModel {
  // ignore: unused_field
  final DatabaseService _databaseService = ProxyService.database;

  TextEditingController _description;
  bool _isLocked = true;
  TextEditingController _nameController;
  Product _product;
  String _productId;
  TextEditingController _retailPriceController;
  TextEditingController _supplierPriceController;

  @override
  // ignore: overridden_fields
  final Logger log = Logging.getLogger('add product view model:)');

  // ActionsTableData get actions;

  String get productId {
    return _productId;
  }

  bool get isLocked {
    return _isLocked;
  }

  TextEditingController get supplierPriceController {
    return _supplierPriceController;
  }

  TextEditingController get description {
    return _description;
  }

  TextEditingController get retailPriceController {
    return _retailPriceController;
  }

  Future<bool> onWillPop({BuildContext context}) async {
    return (await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text(
              'Are you sure?',
              style: TextStyle(color: Colors.black),
            ),
            content: const Text(
              'Do you want to exit',
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {},
                child: const Text('No'),
              ),
              FlatButton(
                onPressed: () {
                  onClose(context);
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  // ignore: always_declare_return_types
  onClose(BuildContext context) async {
    ProxyService.nav.pop();
  }

  Future<void> handleCreateItem({CommonViewModel vm}) async {
    log.d(_productId);
    await updateProduct(
      productId: _productId, //productId
      categoryId: vm.category == null ? '10' : vm.category.id,
      vm: vm,
    );

    final List<Map<String, dynamic>> variations = await _databaseService.filter(
      equator: AppTables.variation,
      property: 'table',
      and: true, //define that this query is and type.
      andEquator: _productId,
      andProperty: 'productId',
    );

    final Document variation = await _databaseService.getById(
        id: Variation.fromMap(variations[0]['main']).id);

    await updateVariation(
      variation: Variation.fromMap(variation.toMap()),
      supplyPrice: double.parse(supplierPriceController.text),
      variantName: 'Regular',
      retailPrice: double.parse(retailPriceController.text),
    );

    _nameController.text = ''; //this will reset button to disabled

    notifyListeners();
  }

  Future<void> updateVariation({
    Variation variation,
    double retailPrice,
    double supplyPrice,
    String variantName,
  }) async {
    if (variation != null) {
      final Document stock = await _databaseService.getById(id: variation.id);

      final Document variant = await _databaseService.getById(id: variation.id);

      variant.toMutable().setString('name', variantName);
      _databaseService.update(document: variant.toMutable());

      stock
          .toMutable()
          .setDouble('retailPrice', retailPrice)
          .setDouble('supplyPrice', supplyPrice);
      _databaseService.update(document: stock.toMutable());
    }
  }

  Future<bool> updateProduct(
      {CommonViewModel vm, String productId, String categoryId}) async {
    log.i('new name for product:' + nameController.text);
    log.i('categoryId for product:' + categoryId);

    final Document product = await _databaseService.getById(id: productId);
    product
        .toMutable()
        .setString('name', nameController.text)
        .setString('categoryId', categoryId)
        .setString('updatedAt', DateTime.now().toIso8601String());

    _databaseService.update(document: product.toMutable());
    return true;
  }

  void createVariant({String productId}) {
    _isLocked = true;
    notifyListeners();

    ProxyService.nav.navigateTo(Routing.addVariationScreen,
        arguments: AddVariationScreenArguments(productId: productId));
  }

  TextEditingController get nameController {
    return _nameController;
  }

  void lock() {
    // ignore: prefer_is_empty
    log.i(_nameController.text.length);
    _nameController.text.isEmpty ? _isLocked = true : _isLocked = false;
    notifyListeners();
  }

  void initFields(TextEditingController name, TextEditingController supplier,
      TextEditingController retail, TextEditingController description) {
    _nameController = name;
    _supplierPriceController = supplier;
    _retailPriceController = retail;
    _description = description;
  }

  Product get product {
    return _product;
  }

  // once full refacored
  // ignore: always_specify_types
  Future getTemporalProduct({BuildContext context, CommonViewModel vm}) async {
    setBusy(true);

    final List<Map<String, dynamic>> products = await _databaseService.filter(
      equator: 'tmp',
      property: 'name',
      and: true,
      andProperty: 'table',
      andEquator: AppTables.product,
    );
    if (products.isNotEmpty) {
      final Product product = Product.fromMap(products[0]['main']);
      // StoreProvider.of<AppState>(context).dispatch(action);
      _productId = product.id;
      _product = product;
    }
    setBusy(false);
    notifyListeners();
    return productId;
  }

  void navigateAddProduct() {
    final FlipperNavigationService _navigationService = ProxyService.nav;
    _navigationService.navigateTo(Routing.addProduct);
  }

  // this is a product to edit later on and add variation on it.
  Future createTemporalProduct(
      {String productName,
      String userId}) async {
    final Logger log = Logging.getLogger('Data manager   Model ....');

    final DatabaseService _databaseService = ProxyService.database;
    
    final category = await _databaseService.filter(
      equator: AppTables.category,
      property: 'table',
      and: true, 
      andEquator: 'custom',
      andProperty: 'name',
    );

    final List<Map<String, dynamic>> product = await _databaseService.filter(
      equator: productName,
      property: 'name',
      and: true,
      andProperty: 'table',
      andEquator: AppTables.product,
    );

    final List<Map<String, dynamic>> gettax = await _databaseService.filter(
      equator: AppTables.tax,
      property: 'table',
      and: true, 
      andEquator: 'Vat',
      andProperty: 'name',
    );
    log.d('categoryId:' + Category.fromMap(category[0]['main']).id);
    log.d('taxId:' + Tax.fromMap(gettax[0]['main']).id);

    

    if (product.isEmpty) {
      
      final Document productDoc = await _databaseService.insert(data: {
        'name': productName,
        'categoryId': Category.fromMap(category[0]['main']).id,
        'color': '#955be9',
        'id': Uuid().v1(),
        'active': true,
        'hasPicture': false,
        'channels': <String>[userId],
        'table': AppTables.product,
        'isCurrentUpdate': false,
        'isDraft': true,
        'taxId': Tax.fromMap(gettax[0]['main']).id,
        'businessId': businessId,
        'description': productName,
        'createdAt': DateTime.now().toIso8601String(),
      });

      final Document variant = await _databaseService.insert(data: {
        'isActive': false,
        'name': 'Regular',
        'unit': 'kg',
        'channels': <String>[userId],
        'table': AppTables.variation,
        'productId': productDoc.id,
        'sku': Uuid().v1().substring(0, 4),
        'id': Uuid().v1(),
        'createdAt': DateTime.now().toIso8601String(),
      });

      await _databaseService.insert(data: {
        'variantId': variant.id,
        'supplyPrice': 0,
        'canTrackingStock': false,
        'showLowStockAlert': false,
        'retailPrice': 0,
        'channels': [userId],
        'isActive': true,
        'table': AppTables.stock,
        'lowStock': 0,
        'currentStock': 0,
        'id': Uuid().v1(),
        'productId': productDoc.id,
        'branchId': branchId,
        'createdAt': DateTime.now().toIso8601String(),
      });

      await _databaseService.insert(data: {
        'branchId': branchId,
        'productId': productDoc.id,
        'table': AppTables.branchProduct,
        'id': Uuid().v1()
      });

      return productDoc.id;
    } else {
      final Product pro = Product.fromMap(product[0]['main']);
      return pro.id;
    }
  }
}
