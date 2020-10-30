
import 'package:flipper/data/respositories/general_repository.dart';
import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/model/unit.dart';
import 'package:couchbase_lite/couchbase_lite.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flipper/utils/data_manager.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

// ignore: non_constant_identifier_names
List<Middleware<AppState>> AppActionMiddleware(
  GlobalKey<NavigatorState> navigatorKey,
  GeneralRepository generalRepository,
) {
  // ignore: always_specify_types
  return [
    TypedMiddleware<AppState, PersistFocusedUnitAction>(
        _persistUnit(navigatorKey, generalRepository)),
    TypedMiddleware<AppState, CreateEmptyTempCategoryAction>(
        _createTempCategory(navigatorKey, generalRepository)),
   
    TypedMiddleware<AppState, SavePayment>(
        _savePayment(navigatorKey, generalRepository)),
  ];
}


void Function(Store<AppState> store, CreateEmptyTempCategoryAction action,
        NextDispatcher next)
    _createTempCategory(GlobalKey<NavigatorState> navigatorKey,
        GeneralRepository generalRepository) {
  // ignore: always_specify_types
  return (Store<AppState> store, CreateEmptyTempCategoryAction action, next) async {
    if (store.state.branch != null) {
      final DatabaseService _databaseService = ProxyService.database;
      final Document doc =await   _databaseService.insert(data: {'branchId': store.state.branch.id,'name':action.name});
      
      store.dispatch(TempCategoryIdAction(categoryId: doc.id));
    }
  };
}

void Function(Store<AppState> store, PersistFocusedUnitAction action,
        NextDispatcher next)
    _persistUnit(GlobalKey<NavigatorState> navigatorKey,
        GeneralRepository generalRepository) {
  return (Store<AppState> store, PersistFocusedUnitAction action, next) {
    if (store.state.focusedUnit != null) {
      store.state.units.forEach((u) => {
            if (u.id == store.state.focusedUnit)
              {
                generalRepository.updateUnit(
                    store,
                    Unit((j) => j
                      ..id = u.id
                      ..focused = true
                      ..name = u.name))
              }
            else
              {
                generalRepository.updateUnit(
                    store,
                    Unit((j) => j
                      ..id = u.id
                      ..focused = false
                      ..name = u.name))
              }
          });
    }
  };
}



void Function(Store<AppState> store, SavePayment action, NextDispatcher next)
    _savePayment(GlobalKey<NavigatorState> navigatorKey,
        GeneralRepository generalRepository) {
  return (store, action, next) async {
    next(action);

  // FIXME:
    // final order =
    //     await store.state.database.orderDao.getOrderById(store.state.order.id);

    // DataManager.updateOrder(
    //   store,
    //   order.copyWith(
    //     status: 'completed',
    //     customerChangeDue: action.customerChangeDue,
    //     orderNote: action.note,
    //     cashReceived: action.cashReceived,
    //   ),
    // );

    // TODO(richard): update the quantity of stock.
    //get this order details using this orderId
    //get variantId then update the stock current quantity minus the orderDetail quantity

    //update orderdetails
    DataManager.createTemporalOrder(generalRepository, store);

    
  };
}
