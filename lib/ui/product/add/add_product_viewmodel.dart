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
import 'package:flipper/ui/welcome/home/common_view_model.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper/utils/logger.dart';
import 'package:flipper/viewmodels/base_model.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class AddProductViewmodel extends BaseModel {
  Category _category;
  String _colorName;
  // ignore: unused_field
  final DatabaseService _databaseService = ProxyService.database;

  TextEditingController _description;
  Unit _focusedUnit;
  bool _isLocked = true;
  TextEditingController _nameController;
  TextEditingController _retailPriceController;
  final _sharedStateService = locator<SharedStateService>();
  TextEditingController _supplierPriceController;
  final List<Unit> _units = <Unit>[];

  // ignore: overridden_fields
  final Logger log = Logging.getLogger('add product view model:)');

  List<PColor> get colors => _sharedStateService.colors;

  ImageP get image => _sharedStateService.image;

  PColor get currentColor => _sharedStateService.currentColor;

  Product get product => _sharedStateService.product;

  // ActionsTableData get actions;

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

  Category get category {
    return _category;
  }

  Future<void> handleCreateItem() async {
    await updateProduct(
      productId: product.id, //productId
      categoryId: category == null ? '10' : category.id,
    );

    final variations = Query(_databaseService.db,
        'SELECT * WHERE table=\$VALUE AND productId=\$PRODUCTID');

    variations.parameters = {
      'VALUE': AppTables.variation,
      'PRODUCTID': product.id
    };

    final variationsResults = variations.execute();

    if (variationsResults.isNotEmpty) {
      for (Map map in variationsResults) {
        map.forEach((key, value) {
          final Document variation =
              _databaseService.getById(id: Variation.fromMap(value).id);

          updateVariation(
            variation: Variation.fromMap(variation.jsonProperties),
            supplyPrice: double.parse(supplierPriceController.text),
            variantName: 'Regular',
            retailPrice: double.parse(retailPriceController.text),
          );
        });
        notifyListeners();
      }
    }

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
      final Document stock = _databaseService.getById(id: variation.id);

      final Document variant = _databaseService.getById(id: variation.id);
        
      variant.properties['name']  =variantName;
      
      _databaseService.update(document: variant);

      stock.properties['retailPrice'] = retailPrice;
      stock.properties['supplyPrice'] = supplyPrice;
      
      _databaseService.update(document: stock);
    }
  }

  Future<bool> updateProduct(
      {CommonViewModel vm, String productId, String categoryId}) async {

    final Document product = _databaseService.getById(id: productId);
    assert(product != null);
    product.properties['name'] = nameController.text;
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

 
  // once full refacored
  // ignore: always_specify_types
  Future getTemporalProduct({BuildContext context, CommonViewModel vm}) async {
    setBusy(true);
    
    final q = Query(_databaseService.db, 'SELECT * WHERE table=\$VALUE AND name=\$NAME');

    q.parameters = {'VALUE': AppTables.product,'NAME':'tmp'};

    final products = q.execute();

    if (products.isNotEmpty) {
   
      for (Map map in products) {
        map.forEach((key,value){
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

  List<Unit> get units => _units;

  void loadUnits() {
    setBusy(true);

    final q = Query(_databaseService.db, 'SELECT * WHERE table=\$VALUE');

    q.parameters = {'VALUE':  AppTables.unit};
    
    q.addChangeListener((List results) {
   
       for (Map map in results) {

        map.forEach((key,value){
           _units.add(Unit.fromMap(value));
        });
        notifyListeners();
      }
    });
  }

  void updateProductWithCurrentUnit({Unit unit}) async {
    //NOTE: we update product variation not actual product as the unit is associated with variation.
   
     final q = Query(_databaseService.db, 'SELECT * WHERE table=\$VALUE AND productId=\$productId');

    q.parameters = {'VALUE': AppTables.variation,'productId':product.id};

    final variants = q.execute();

    if (variants.isNotEmpty) {
   
      for (Map map in variants) {
        map.forEach((key,value){
          //  _sharedStateService.setProduct(product: Product.fromMap(value));
        });
        notifyListeners();
      }
    }
    // FIXME(richard): finish the logic this logic seems to be invalid or too complicated for nothing
    // for (var i = 0; i < variants.length; i++) {
    //   final Variation variation = Variation.fromMap(variants[i]);
    //   final Document variationDocument =
    //       _databaseService.getById(id: variation.id);

    //   variationDocument.properties['unit']    =unit.name;
      
    //   _databaseService.update(document: variationDocument);
    // }
  }

  Unit get focusedUnit {
    return _focusedUnit;
  }

  void saveFocusedUnit({Unit unit}) async {
    // reset other focused if any!
    for (Unit unit in units) {
      final Document unitDoc = _databaseService.getById(id: unit.id);
      if (unit.focused) {
        unitDoc.properties['focused'] = false;
        _databaseService.update(document: unitDoc);
      }
    }
    _focusedUnit = unit;
    final Document unitDoc = _databaseService.getById(id: unit.id);
    
    unitDoc.properties['focused'] = false;
    _databaseService.update(document: unitDoc);
    notifyListeners();
  }
}
