import 'package:flipper/couchbase.dart';
import 'package:flipper/data/respositories/business_repository.dart';
import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/domain/redux/business/business_actions.dart';
import 'package:flipper/helper/constant.dart';
import 'package:flipper/model/business.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createBusinessMiddleware(
  GlobalKey<NavigatorState> navigatorKey,
  BusinessRepository businessRepository,
) {
  //
  return [
    TypedMiddleware<AppState, CreateBusinessOnSignUp>(
        _createBusiness(navigatorKey, businessRepository)),
    TypedMiddleware<AppState, CreateBusiness>(
        _createBusiness(navigatorKey, businessRepository)),
    TypedMiddleware<AppState, SetActiveBusiness>(
        _switchActiveBusiness(navigatorKey, businessRepository)),
  ];
}


void Function(Store<AppState> store, dynamic action, NextDispatcher next)
    _createBusiness(
  GlobalKey<NavigatorState> navigatorKey,
  BusinessRepository businessRepository,
) {
  // ignore: always_specify_types
  return (Store<AppState> store, action, next) async {
    next(action);

    if (store.state.business != null) {
     
      final Map<String, dynamic> _mapBusiness = {
        'active': true,
        '_id':  AppTables.business + store.state.userId.toString(),
        'categoryId': '10', //pet store a default id when signup on mobile
        'channels':[ store.state.userId.toString()],
        'typeId': '1', //pet store a default id when signup on mobile
        'tableName': AppTables.business + store.state.userId.toString(),
        'country': 'Rwanda',
        'currency': 'RWF',
        'id':  AppTables.business + store.state.userId.toString(),
        'name': store.state.business.name,
        'userId': store.state.userId,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };

     final String businessId= await AppDatabase.instance.createBusiness(_mapBusiness);

      // ignore: always_specify_types
      final Map<String, dynamic> _notTax = {
        'active': true,
        '_id': 'taxes_' + businessId,
        'channels': [store.state.userId.toString()],
        'businessId': businessId,
        'tableName': AppTables.tax + store.state.userId.toString(),
        'createdAt': DateTime.now().toIso8601String(),
        'id': 'taxes_' + store.state.userId.toString(),
        'updatedAt': DateTime.now().toIso8601String(),
        'isDefault': false,
        'name': 'No Tax',
        'percentage': 0,
      };

      await AppDatabase.instance.createTax(_notTax);
      // ignore: always_specify_types
      final Map<String, dynamic> vat = {
        'active': true,
        '_id': 'taxes_' + businessId,
        'channels': [store.state.userId.toString()],
        'businessId': businessId,
        'tableName': AppTables.tax + store.state.userId.toString(),
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
        'id': 'taxes_' + businessId,
        'isDefault': true,
        'name': 'Vat',
        'percentage': 18,
      };
      // todo(richard): dispatch this tax, and on active business should load that tax.
      await AppDatabase.instance.createTax(vat);
      store.dispatch(BusinessId(businessId));

      store.dispatch(BusinessCreated());
    }
  };
}

void Function(Store<AppState> store, dynamic action, NextDispatcher next)
    _switchActiveBusiness(
  GlobalKey<NavigatorState> navigatorKey,
  BusinessRepository businessRepository,
) {
  // ignore: always_specify_types
  return (Store<AppState> store, action, next) async {
    next(action);

      // todo(richard): on switch business please dispatch taxes, branches etc...
    if (store.state.currentActiveBusiness != null ||
        store.state.nextActiveBusiness != null) {
      //remove active from previous active business
      //add active to new
      if (store.state.nextActiveBusiness != null) {
        //set business
        businessRepository.update(store, store.state.nextActiveBusiness,
            active: true);
      }
      if (store.state.currentActiveBusiness != null) {
        businessRepository.update(store, store.state.currentActiveBusiness,
            active: false);
      }
      final Business updated = Business((BusinessBuilder b) => b
        ..id = store.state.nextActiveBusiness.id
        ..name = store.state.nextActiveBusiness.name
        ..longitude = b.longitude
        ..latitude = b.latitude
        ..hexColor = store.state.nextActiveBusiness.hexColor
        ..active = true);
      store.dispatch(RefreshBusinessList(updated));
    }
  };
}
