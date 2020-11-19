

import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/services/proxy.dart';

import 'package:flipper/services/database_service.dart';
import 'package:flipper/utils/data_manager.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:uuid/uuid.dart';

// ignore: non_constant_identifier_names
List<Middleware<AppState>> AppActionMiddleware(
  GlobalKey<NavigatorState> navigatorKey,
) {
  // ignore: always_specify_types
  return [
    TypedMiddleware<AppState, CreateEmptyTempCategoryAction>(
        _createTempCategory(navigatorKey)),
   
    TypedMiddleware<AppState, SavePayment>(
        _savePayment(navigatorKey)),
  ];
}


void Function(Store<AppState> store, CreateEmptyTempCategoryAction action,
        NextDispatcher next)
    _createTempCategory(GlobalKey<NavigatorState> navigatorKey,) {
  // ignore: always_specify_types
  return (Store<AppState> store, CreateEmptyTempCategoryAction action, next) async {
    if (store.state.branch != null) {
      final DatabaseService _databaseService = ProxyService.database;
      final id = Uuid().v1();
      _databaseService.insert(id:id, data: {'branchId': store.state.branch.id,'name':action.name});
     
      store.dispatch(TempCategoryIdAction(categoryId: id));
    }
  };
}




void Function(Store<AppState> store, SavePayment action, NextDispatcher next)
    _savePayment(GlobalKey<NavigatorState> navigatorKey,
        ) {
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
    DataManager.createTemporalOrder(store);

    
  };
}
