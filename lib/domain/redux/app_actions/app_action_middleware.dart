import 'package:flipper/data/main_database.dart';
import 'package:flipper/data/respositories/general_repository.dart';
import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/domain/redux/authentication/auth_actions.dart';
import 'package:flipper/model/unit.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/util/util.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> AppActionMiddleware(
  GlobalKey<NavigatorState> navigatorKey,
  GeneralRepository generalRepository,
) {
  return [
    TypedMiddleware<AppState, OnSetTab>(
        _setTab(navigatorKey, generalRepository)),
    TypedMiddleware<AppState, CreateUnit>(
        _createCategory(navigatorKey, generalRepository)),
    TypedMiddleware<AppState, PersistFocusedUnitAction>(
        _persistUnit(navigatorKey, generalRepository)),
    TypedMiddleware<AppState, CreateEmptyTempCategoryAction>(
        _createTempCategory(navigatorKey, generalRepository)),
    TypedMiddleware<AppState, SaveRegular>(
        _saveRegular(navigatorKey, generalRepository)),
    TypedMiddleware<AppState, SaveCart>(
        _saveCart(navigatorKey, generalRepository)),
    TypedMiddleware<AppState, SaveCartCustom>(
        _saveCartCustom(navigatorKey, generalRepository)),
    TypedMiddleware<AppState, SavePayment>(
        _savePayment(navigatorKey, generalRepository)),
  ];
}

void Function(Store<AppState> store, SaveRegular action, NextDispatcher next)
    _saveRegular(GlobalKey<NavigatorState> navigatorKey,
        GeneralRepository generalRepository) {
  return (store, action, next) async {
    StockTableData stock;
    int variationId;
    variationId = action.variantId;
//    stock = await store.state.database.stockDao.getStockByVariantId(
//        branchId: store.state.branch.id, variantId: action.variantId);
    final variant =
        await store.state.database.variationDao.getVariationById(variationId);
    await store.state.database.variationDao
        .updateVariation(variant.copyWith(name: 'Regular'));

    await store.state.database.stockDao.updateStock(
      stock.copyWith(
        retailPrice: action.retailPrice,
        costPrice: action.costPrice,
      ),
    );
//    stock = await store.state.database.stockDao.getStockByVariantId(
//        branchId: store.state.branch.id, variantId: action.variantId);
  };
}

void Function(Store<AppState> store, CreateEmptyTempCategoryAction action,
        NextDispatcher next)
    _createTempCategory(GlobalKey<NavigatorState> navigatorKey,
        GeneralRepository generalRepository) {
  return (store, action, next) async {
    if (store.state.branch != null) {
//      final categoryId = await generalRepository.insertCategory(
//        store,
//        //ignore: missing_required_param
//        CategoryTableData(
//          branchId: store.state.branch.id,
//          focused: false,
//          name: action.name,
//          createdAt: DateTime.now(),
//        ),
//      );
//      store.dispatch(TempCategoryIdAction(categoryId: categoryId));
    }
  };
}

void Function(Store<AppState> store, PersistFocusedUnitAction action,
        NextDispatcher next)
    _persistUnit(GlobalKey<NavigatorState> navigatorKey,
        GeneralRepository generalRepository) {
  return (store, action, next) {
    if (store.state.focusedUnit != null) {
      store.state.units.forEach((u) => {
            if (u.id == store.state.focusedUnit)
              {
                generalRepository.updateUnit(
                    store,
                    Unit((j) => j
                      ..id = u.id
                      ..businessId = u.businessId
                      ..branchId = u.branchId
                      ..focused = true
                      ..name = u.name))
              }
            else
              {
                generalRepository.updateUnit(
                    store,
                    Unit((j) => j
                      ..id = u.id
                      ..businessId = u.businessId
                      ..branchId = u.branchId
                      ..focused = false
                      ..name = u.name))
              }
          });
    }
  };
}

void Function(Store<AppState> store, CreateUnit action, NextDispatcher next)
    _createCategory(GlobalKey<NavigatorState> navigatorKey,
        GeneralRepository generalRepository) {
  return (store, action, next) {};
}

void Function(Store<AppState> store, dynamic action, NextDispatcher next)
    _setTab(
  GlobalKey<NavigatorState> navigatorKey,
  GeneralRepository generalRepository,
) {
  return (store, action, next) async {
    next(action);
    if (store.state.tab != null) {
      final updated = await generalRepository.updateTab(store, store.state.tab);
      if (!updated) {
        await generalRepository.insertTabs(store, store.state.tab);
      }
    }
  };
}

void Function(Store<AppState> store, SaveCartCustom action, NextDispatcher next)
    _saveCartCustom(GlobalKey<NavigatorState> navigatorKey,
        GeneralRepository generalRepository) {
  return (store, action, next) async {
    next(action);
//
//    await generalRepository.insertOrUpdateCart(
//      store,
//      //ignore: missing_required_param
//      CartTableData(
//        branchId: store.state.branch.id,
//        count: store.state.currentIncrement == null
//            ? 1
//            : store.state.currentIncrement,
//        variationName: store.state.cartItem.name,
//        orderId: store.state.order.id,
//        variationId: store.state.cartItem.id,
//        parentName: store.state.cartItem.parentName,
//      ),
//    );
  };
}

void Function(Store<AppState> store, SaveCart action, NextDispatcher next)
    _saveCart(GlobalKey<NavigatorState> navigatorKey,
        GeneralRepository generalRepository) {
  return (store, action, next) async {
    next(action);

//    await generalRepository.insertOrUpdateCart(
//      store,
//      //ignore: missing_required_param
//      CartTableData(
//        branchId: store.state.branch.id,
//        count: store.state.currentIncrement == null
//            ? 1
//            : store.state.currentIncrement,
//        variationName: store.state.cartItem.name,
//        orderId: store.state.order.id,
//        variationId: store.state.cartItem.variantId,
//        parentName: store.state.cartItem.parentName,
//      ),
//    );

    Router.navigator.maybePop();
  };
}

void Function(Store<AppState> store, SavePayment action, NextDispatcher next)
    _savePayment(GlobalKey<NavigatorState> navigatorKey,
        GeneralRepository generalRepository) {
  return (store, action, next) async {
    next(action);

    final order = await store.state.database.orderDao.getOrderById(store.state.order.id);
    Util.updateOrder(store,order.copyWith(orderNote: action.note,cashReceived: action.cashReceived));

    //this will clear all state and create new order if needed.
    store.dispatch(VerifyAuthenticationState());
  };
}
