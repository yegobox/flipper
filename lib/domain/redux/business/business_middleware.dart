import 'package:flipper/data/main_database.dart';
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
    //todo: get yegobox id and other users information from yegobox and use them while creating flipper account
    if (store.state.business != null && store.state.userId != null) {

      int businessId =
          await businessRepository.insertBusiness(store, store.state.business);

      await businessRepository.assignBusinessToUser(
          store, businessId, store.state.userId);

      List<BusinessTableData> businessList =
          await businessRepository.getBusinesses(store);

      List<Business> businesses = [];

      businessList.forEach((b) => {
            businesses.add(
              Business(
                (bu) => bu
                  ..latitude = bu.latitude
                  ..longitude = bu.longitude
                  ..name = b.name
                  ..id = b.id,
              ),
            )
          });

      store.dispatch(BusinessId(businessId));

      store.dispatch(BusinessCreated());

      store.dispatch(OnBusinessLoaded(business: businesses));
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
        ..isActive = true);
      store.dispatch(RefreshBusinessList(updated));
    }
  };
}
