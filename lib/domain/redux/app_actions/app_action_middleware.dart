import 'package:flipper/couchbase.dart';
import 'package:flipper/data/main_database.dart';
import 'package:flipper/data/respositories/general_repository.dart';
import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/locator.dart';
import 'package:flipper/model/unit.dart';
import 'package:couchbase_lite/couchbase_lite.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flipper/util/data_manager.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:uuid/uuid.dart';

// ignore: non_constant_identifier_names
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
  // ignore: always_specify_types
  return (Store<AppState> store, CreateEmptyTempCategoryAction action, next) async {
    if (store.state.branch != null) {
      final DatabaseService _databaseService = locator<DatabaseService>();
      final Document doc =await   _databaseService.insert(data: {'branchId': store.state.branch.id,'name':action.name});
      
      store.dispatch(TempCategoryIdAction(categoryId: doc.id));
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
    // FIXME(richard): update the code
    //get this stock additional data for selling
    final StockTableData stock = await store.state.database.stockDao
        .getStockByVariantId(
            branchId: store.state.branch.id,
            variantId: store.state.cartItem.id);

    final ProductTableData product = await store.state.database.productDao
        .getItemById(productId: stock.productId);

    final VariationTableData variant = await store.state.database.variationDao
        .getVariationById(variantId: store.state.cartItem.id);

    await generalRepository.insertOrUpdateCart(

      store,
      //ignore: missing_required_param
      OrderDetailTableData(
        branchId: store.state.branch.id,
        quantity: store.state.currentIncrement.toDouble() ?? 1.0,
        variantName: store.state.cartItem.name,
        discountAmount: 0,
        stockId: stock.id,
        productName: product.name,
        discountRate: 0,
        subTotal: stock.retailPrice * store.state.currentIncrement,
        taxAmount: ((stock.retailPrice * store.state.currentIncrement) *
                (store.state.defaultTax==null?0:store.state.defaultTax.percentage.toInt())) /
            100,
        taxRate: store.state.defaultTax==null?0:store.state.defaultTax.percentage.toInt(),
        note: store.state.note ?? 'default',
        unit: variant.unit,
        orderId: store.state.order.id.toString(),
        variationId: variant.id,
        id: Uuid().v1(),
      ),
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
        customerChangeDue: action.customerChangeDue,
        orderNote: action.note,
        cashReceived: action.cashReceived,
      ),
    );

    //TODO:update the quantity of stock.
    //get this order details using this orderId
    //get variantId then update the stock current quantity minus the orderDetail quantity

    //update orderdetails
    DataManager.createTemporalOrder(generalRepository, store);

    DataManager.createTempProduct(store, 'custom-product');
    
    AppDatabase.instance.syncOrderLRemote(store);
  };
}
