import 'package:flipper/data/main_database.dart';
import 'package:flipper/data/respositories/general_repository.dart';
import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/model/unit.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/util/data_manager.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:uuid/uuid.dart';

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
    TypedMiddleware<AppState, SavePayment>(
        _savePayment(navigatorKey, generalRepository)),
  ];
}

void Function(Store<AppState> store, SaveRegular action, NextDispatcher next)
    _saveRegular(GlobalKey<NavigatorState> navigatorKey,
        GeneralRepository generalRepository) {
  return (store, action, next) async {
    StockTableData stock;

    await store.state.database.stockDao.updateStock(
      stock.copyWith(
        retailPrice: action.retailPrice,
        supplyPrice: action.costPrice,
      ),
    );
  };
}

void Function(Store<AppState> store, CreateEmptyTempCategoryAction action,
        NextDispatcher next)
    _createTempCategory(GlobalKey<NavigatorState> navigatorKey,
        GeneralRepository generalRepository) {
  return (store, action, next) async {
    if (store.state.branch != null) {
      final categoryId = await generalRepository.insertCategory(
        store,
        //ignore: missing_required_param
        CategoryTableData(
          branchId: store.state.branch.id,
          id: Uuid().v1(),
          focused: true,
          name: action.name,
          createdAt: DateTime.now(),
        ),
      );
      store.dispatch(TempCategoryIdAction(categoryId: categoryId));
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

void Function(Store<AppState> store, SaveCart action, NextDispatcher next)
    _saveCart(GlobalKey<NavigatorState> navigatorKey,
        GeneralRepository generalRepository) {
  return (store, action, next) async {
    next(action);

    //get this stock additional data for selling
    StockTableData stock = await store.state.database.stockDao
        .getStockByVariantId(
            branchId: store.state.branch.id,
            variantId: store.state.cartItem.id);

    await generalRepository.insertOrUpdateCart(
      store,
      //ignore: missing_required_param
      OrderDetailData(
          branchId: store.state.branch.id,
          count: store.state.currentIncrement ?? 1,
          variantName: store.state.cartItem.name,
          price: stock.retailPrice,
          discountAmount: 0,
          discountRate: 0,
          quantity: store.state.currentIncrement.toDouble(),
          subTotal: stock.retailPrice * store.state.currentIncrement,
          taxAmount: ((stock.retailPrice * store.state.currentIncrement) *
                  store.state.defaultTax.percentage.toInt()) /
              100,
          taxRate: store.state.defaultTax.percentage.toInt(),
          note: 'note',
          unit: store.state.cartItem.unit,
          orderId: store.state.order.id.toString(),
          variationId: store.state.cartItem.id,
          id: store.state.cartItem.id),
    );
  };
}

void Function(Store<AppState> store, SavePayment action, NextDispatcher next)
    _savePayment(GlobalKey<NavigatorState> navigatorKey,
        GeneralRepository generalRepository) {
  return (store, action, next) async {
    next(action);

    final order =
        await store.state.database.orderDao.getOrderById(store.state.order.id);

    DataManager.updateOrder(
        store,
        order.copyWith(
            status: 'completed',
            orderNote: action.note,
            cashReceived: action.cashReceived));

    DataManager.createTemporalOrder(generalRepository, store);

    //todo: what happen if I sell this custom product
    //then on create of new product start by editing this custom product:
    //the problem: we can loose control of which has been sold for that purpose.
    //solution 1: we keep the name custom for the flow of the product creation
    //         2: we name a custom selling on POS to custom-product
    //         3: we keep refering custom-product as an item sold without stock or actual flow,just sell of fly
    //         4: ensure this custom-product is loaded when app start.
    DataManager.createTempProduct(store, 'custom-product');
  };
}
