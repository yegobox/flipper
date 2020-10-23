import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/model/variation.dart';
import 'package:couchbase_lite/couchbase_lite.dart';

import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/ui/welcome/home/common_view_model.dart';
import 'package:flipper/utils/data_manager.dart';
import 'package:flipper/utils/logger.dart';
import 'package:flipper/viewmodels/base_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:logger/logger.dart';

class AddProductViewmodel extends BaseModel {
  // FIXME(richard): tomorrow I will work on this after finishing some work on renter app.

  final Logger log = Logging.getLogger('add product view model:)');
  // ignore: unused_field
  final DatabaseService _databaseService = ProxyService.database;
  
  // ActionsTableData get actions;

  

  String _productId;
  String get productId {
    return _productId;
  }

  bool get isLocked {
    return _isLocked;
  }
  bool _isLocked = true;

  
  TextEditingController _supplierPriceController;
  TextEditingController get supplierPriceController {
    return _supplierPriceController;
  }

  TextEditingController _description;
  TextEditingController get description {
    return _description;
  }

  TextEditingController _retailPriceController;
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

  Future<void> handleCreateItem(
      {CommonViewModel vm}) async {
    log.i('updating productId:'+vm.tmpItem.id);
    await updateProduct(
      productId: vm.tmpItem.id,
      categoryId:vm.category==null?'10': vm.category.id,
      vm: vm,
    );
    
    final Document variation = await _databaseService.getById(id:vm.variant.id);
    
    await updateVariation(
      variation: Variation.fromMap(variation.toMap()),
      supplyPrice: double.parse(supplierPriceController.text),
      variantName: 'Regular',
      retailPrice: double.parse(retailPriceController.text),
    );

    _nameController.text ='';//this will reset button to disabled

    notifyListeners();

  }
  Future<void> updateVariation({
    Variation variation,
    double retailPrice,
    double supplyPrice,
    String variantName,
  }) async {
    if (variation != null) {

      final Document stock = await _databaseService.getById(id:variation.id);

      final Document variant = await _databaseService.getById(id:variation.id);
     
      variant.toMutable()
      .setString('name',variantName);
      _databaseService.update(document: variant);

      stock.toMutable()
      .setDouble('retailPrice',retailPrice)
      .setDouble('supplyPrice',supplyPrice);
      _databaseService.update(document: stock);
    }
  }

  Future<bool> updateProduct(
      {CommonViewModel vm, String productId, String categoryId}) async {
      log.i('new name for product:'+nameController.text);
      log.i('categoryId for product:'+categoryId);

      final Document product = await _databaseService.getById(id:productId);
      product.toMutable()
      .setString('name', nameController.text)
      .setString('categoryId', categoryId)
      .setString('updatedAt',  DateTime.now().toIso8601String());
      
      _databaseService.update(document: product);
    return true;
  }

  void createVariant({String productId}) {
    _isLocked = true;
    notifyListeners();

    ProxyService.nav.navigateTo(Routing.addVariationScreen,
        arguments: AddVariationScreenArguments(productId:productId));
  }

  TextEditingController _nameController;
  TextEditingController get nameController {
    return _nameController;
  }
  void lock() {
    // ignore: prefer_is_empty
    log.i(_nameController.text.length);
    _nameController.text.isEmpty?_isLocked = true:_isLocked = false;
    notifyListeners();
  }

  void initFields(TextEditingController name,TextEditingController supplier,TextEditingController retail,TextEditingController description) {
    _nameController = name;
    _supplierPriceController = supplier;
    _retailPriceController = retail;
    _description = description;
  }
  // once full refacored
  // ignore: always_specify_types
  Future getTemporalProduct({BuildContext context, CommonViewModel vm}) async {
    setBusy(true);
    log.i(vm.user.id);
    // ignore: prefer_const_constructors
    final String productId = await DataManager.createTempProduct(
      store: StoreProvider.of<AppState>(context),
      userId: vm.user.id,
      productName: 'tmp',
    );

    setBusy(false);
    _productId = productId;
    notifyListeners();
    return productId;
  }
}
