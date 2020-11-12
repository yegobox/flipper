
import 'package:flipper/locator.dart';
import 'package:flipper/model/category.dart';
import 'package:flipper/model/image.dart';
import 'package:flipper/model/pcolor.dart';
import 'package:flipper/model/product.dart';
import 'package:flipper/model/unit.dart';
import 'package:flipper/model/variation.dart';
import 'package:couchbase_lite/couchbase_lite.dart';

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

  Category get category{
    return _category;
  }

  Future<void> handleCreateItem() async {
    
    await updateProduct(
      productId: product.id, //productId
      categoryId: category == null ? '10' : category.id,
    );

    final List<Map<String, dynamic>> variations = await _databaseService.filter(
      equator: AppTables.variation,
      property: 'table',
      and: true, //define that this query is and type.
      andEquator: product.id,
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
        final List<Map<String, dynamic>> p = await _databaseService.filter(property: 'table',equator:'products');
    
    final Document product = await _databaseService.getById(id: productId);
    assert(product !=null);
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
      _sharedStateService.setProduct(product: Product.fromMap(products[0]['main']));
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

    _databaseService
        .observer(equator: AppTables.unit, property: 'table')
        .stream
        .listen((ResultSet event) {
      final List<Map<String, dynamic>> model = event.map((Result result) {
        return result.toMap();
      }).toList();

      // remove unnecessarry nesting "main"appended on each map value
      for (Map<String, dynamic> map in model) {
        map.forEach((String key, value) {
          log.i(value);
          _units.add(Unit.fromMap(value));
        });
      }
      notifyListeners();

      setBusy(false);
    });
  }

  void updateProductWithCurrentUnit({Unit unit}) async { //NOTE: we update product variation not actual product as the unit is associated with variation.
    final List<Map<String, dynamic>> variants = await _databaseService.filter(
      and: true,
      property: 'table',
      equator: AppTables.variation,
      andProperty: 'productId',
      andEquator: product.id,
    );
    for (var i = 0; i < variants.length; i++) {
      final Variation variation = Variation.fromMap(variants[i]);
      final Document variationDocument =
          await _databaseService.getById(id: variation.id);
      variationDocument.toMutable().setString('unit', unit.name);
      _databaseService.update(document: variationDocument);
    }
  }

  Unit get focusedUnit {
    return _focusedUnit;
  }

  void saveFocusedUnit({Unit unit}) async {
    // reset other focused if any!
    for (Unit unit in units) {
      final Document unitDoc = await _databaseService.getById(id: unit.id);
      if (unit.focused) {
        unitDoc.toMutable().setBoolean('focused', false);
        _databaseService.update(document: unitDoc);
      }
    }
    _focusedUnit = unit;
    final Document unitDoc = await _databaseService.getById(id: unit.id);
    unitDoc.toMutable().setBoolean('focused', false);
    _databaseService.update(document: unitDoc);
    notifyListeners();
  }
}
