import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/services/flipperNavigation_service.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flipper/util/data_manager.dart';
import 'package:flipper/util/logger.dart';
import 'package:flipper/viewmodels/base_model.dart';
import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:redux/redux.dart';

class AddProductViewmodel extends BaseModel {
  final Logger log = Logging.getLogger('add product view model:)');
  // ignore: unused_field
  final DatabaseService _databaseService = ProxyService.database;
  ActionsTableData _actionsSaveItem;
  // ActionsTableData get actions;

  ActionsTableData get action {
    return _actions;
  }

  
  ActionsTableData _actions;

  bool get isLocked{
    return _isLocked;
  }
  final bool _isLocked = true;
  


  Future<bool> onWillPop({BuildContext context}) async {
    return (await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text(
              'Are you sure?',
              style: TextStyle(color: Colors.black),
            ),
            content: const Text(
              'Do you want to exit an App',
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              FlatButton(
                // onPressed: () => Routing.navigator.pop(false),
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

  Future<bool> handleCreateItem({CommonViewModel vm, Store<AppState> store}) async {
    // final Store<AppState> store = StoreProvider.of<AppState>(context);

    await updateProduct(
      productId: vm.tmpItem.id,
      categoryId: store.state.category.id,
      vm: vm,
    );
    final VariationTableData variation = await vm.database.variationDao
        .getVariationById(variantId: vm.variant.id);

    await DataManager.updateVariation(
      variation: variation,
      supplyPrice: DataManager.supplyPrice ?? 0.0,
      store: store,
      variantName: 'Regular',
      retailPrice: DataManager.retailPrice ?? 0.0,
    );

    await resetSaveButtonStatus(vm);

    return true;
  }
  Future<bool> updateProduct(
      {CommonViewModel vm, String productId, String categoryId}) async {
    final ProductTableData product =
        await vm.database.productDao.getProductById(productId: productId);

    await vm.database.productDao.updateProduct(
      product.copyWith(
        name: DataManager.name,
        categoryId: categoryId,
        updatedAt: DateTime.now(),
        deletedAt: 'null',
      ),
    );
    return true;
  }
   Future<bool> resetSaveButtonStatus(CommonViewModel vm) async {
    await vm.database.actionsDao
        .updateAction(_actionsSaveItem.copyWith(isLocked: true));

    await vm.database.actionsDao
        .updateAction(_actions.copyWith(isLocked: true));
    return true;
  }
   void getSaveStatus(CommonViewModel vm) async {
    final ActionsTableData result =
        await vm.database.actionsDao.getActionBy('save');

      _actions = result;
    
  }
  void getSaveItemStatus(CommonViewModel vm) async {
    final ActionsTableData result =
        await vm.database.actionsDao.getActionBy('saveItem');
    
      _actionsSaveItem = result;
    notifyListeners();
  }
  void createVariant(CommonViewModel vm) {
    // _getSaveStatus(vm);
    if (_actions != null) {
      vm.database.actionsDao.updateAction(_actions.copyWith(isLocked: true));
      final FlipperNavigationService _navigationService =
         ProxyService.nav;

      _navigationService.navigateTo(Routing.addVariationScreen,
          arguments: AddVariationScreenArguments(
              retailPrice: DataManager.retailPrice,
              supplyPrice: DataManager.supplyPrice));
    }
  }
  Future<void> updateNameField(String name, CommonViewModel vm) async {
    if (name == '') {
      // _getSaveStatus(vm);
      // _getSaveItemStatus(vm);
      // if (_actions != null) {
      //   await vm.database.actionsDao
      //       .updateAction(_actions.copyWith(isLocked: true));
      //   _getSaveStatus(vm);
      //   _getSaveItemStatus(vm);
      // }
      
      DataManager.name = name;
      notifyListeners();
      
    } else if (_actions != null) {
      await vm.database.actionsDao
          .updateAction(_actions.copyWith(isLocked: false));
      // _getSaveStatus(vm);
      // _getSaveItemStatus(vm);
      
      DataManager.name = name;
      notifyListeners();
     
    } else {
      // _getSaveStatus(vm);
      // _getSaveItemStatus(vm);
      
        DataManager.name = name;
      notifyListeners();
    }
  }
  Future getProducts() {}
}
