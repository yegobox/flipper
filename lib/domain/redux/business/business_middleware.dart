import 'package:flipper/data/respositories/business_repository.dart';
import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/domain/redux/business/business_actions.dart';
import 'package:flipper/model/business.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createBusinessMiddleware(
  GlobalKey<NavigatorState> navigatorKey,
  BusinessRepository businessRepository,
) {
  return [
    TypedMiddleware<AppState, CreateBusinessOnSignUp>(
        _createBusiness(navigatorKey, businessRepository)),
    TypedMiddleware<AppState, CreateBusiness>(
        _createBusiness(navigatorKey, businessRepository)),
    TypedMiddleware<AppState, SetActiveBusiness>(
        _setActive(navigatorKey, businessRepository)),
  ];
}

void Function(Store<AppState> store, dynamic action, NextDispatcher next)
    _createBusiness(
  GlobalKey<NavigatorState> navigatorKey,
  BusinessRepository businessRepository,
) {
  return (store, action, next) async {
    next(action);

    if (store.state.business != null) {
//      int businessId =
//          await businessRepository.insertBusiness(store, store.state.business);
      //todo: insert business document.
//      await businessRepository.assignBusinessToUser(
//          store, businessId, store.state.userId);
      Map map = {
        'active': true,
        '_id': 'businesses',
        'businessCategoryId': 1,
        'businessTypeId': 1,
        'businessUrl': '',
        'country': 'Rwanda',
        'currency': 'RWF',
        'id': 1,
        'name': store.state.business.name,
        'taxRate': 18,
        'timeZone': '',
        'userId': '',
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };
      store.state.couch.createBusiness(map);

      store.dispatch(BusinessId(1));

      store.dispatch(BusinessCreated());
    }
  };
}

void Function(Store<AppState> store, dynamic action, NextDispatcher next)
    _setActive(
  GlobalKey<NavigatorState> navigatorKey,
  BusinessRepository businessRepository,
) {
  return (store, action, next) async {
    next(action);
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
      final updated = Business((b) => b
        ..id = store.state.nextActiveBusiness.id
        ..abbreviation = store.state.nextActiveBusiness.abbreviation
        ..name = store.state.nextActiveBusiness.name
        ..longitude = b.longitude
        ..latitude = b.latitude
        ..hexColor = store.state.nextActiveBusiness.hexColor
        ..active = true);
      store.dispatch(RefreshBusinessList(updated));
    }
  };
}
