import 'package:flipper/data/respositories/business_repository.dart';
import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/domain/redux/business/business_actions.dart';
import 'package:flipper/helper/constant.dart';
import 'package:flipper/model/business.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:couchbase_lite/couchbase_lite.dart';

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
        '_id':  AppTables.business + store.state.user.id.toString(),
        'categoryId': '10', //pet store a default id when signup on mobile
        'channels':[ store.state.user.id.toString()],
        'typeId': '1', //pet store a default id when signup on mobile
        'table': AppTables.business,
        'country': 'Rwanda',
        'currency': 'RWF',
        'name': store.state.business.name,
        'userId': store.state.user.id,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };

      
    final Document business = await ProxyService.database.insert(data:_mapBusiness);
    
      // ignore: always_specify_types
      final Map<String, dynamic> _notTax = {
        'active': true,
        '_id': 'taxes_' + store.state.user.id.toString(),
        'channels': [store.state.user.id.toString()],
        'businessId': business.id,
        'table': AppTables.tax,
        'createdAt': DateTime.now().toIso8601String(),
        'id': AppTables.tax + store.state.user.id.toString(),
        'updatedAt': DateTime.now().toIso8601String(),
        'isDefault': false,
        'name': 'No Tax',
        'percentage': 0,
      };

      await ProxyService.database.insert(data:_notTax);
      // ignore: always_specify_types
      final Map<String, dynamic> vat = {
        'active': true,
        '_id': 'taxes_' + store.state.user.id.toString(),
        'channels': [store.state.user.id.toString()],
        'businessId':  business.id,
        'table': AppTables.tax,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
        'id': AppTables.tax + store.state.user.id.toString(),
        'isDefault': true,
        'name': 'Vat',
        'percentage': 18,
      };
      // todo(richard): dispatch this tax, and on active business should load that tax.
      await ProxyService.database.insert(data:vat);
      store.dispatch(BusinessId(store.state.user.id.toString()));

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
