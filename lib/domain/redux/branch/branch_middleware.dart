import 'package:flipper/data/respositories/general_repository.dart';
import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/domain/redux/authentication/auth_actions.dart';
import 'package:flipper/domain/redux/branch/branch_actions.dart';
import 'package:flipper/domain/redux/business/business_actions.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper/model/hint.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:uuid/uuid.dart';

List<Middleware<AppState>> createBranchMiddleware(
    GlobalKey<NavigatorState> navigatorKey,
    GeneralRepository generalRepository) {
  return [
    TypedMiddleware<AppState, BusinessCreated>(
        _onBusinessCreated(navigatorKey, generalRepository)),
    TypedMiddleware<AppState, OnSetBranchHint>(
        _onSetBranchHint(navigatorKey)),
  ];
}

void Function(Store<AppState> store, dynamic action, NextDispatcher next)
    _onBusinessCreated(GlobalKey<NavigatorState> navigatorKey,
         GeneralRepository generalRepository) {
  // ignore: always_specify_types
  return (Store<AppState> store, action, next) async {
    store.dispatch(ResetAppAction());

    //final branchId = await branchRepo.insertBranch(store, branch);
    //create tax for this branch

    // ignore: always_specify_types
    final Map<String, dynamic> _mapBranch = {
      'active': true,
      'name': store.state.business.name,
      '_id': 'branches_' + store.state.user.id.toString(),
      'channels': [store.state.user.id.toString()],
      'businessId': store.state.currentActiveBusiness.id,
      'id': Uuid().v1(),
      'table':  AppTables.branch,
      'mapLatitude': store.state.business.latitude ?? '0.0',
      'mapLongitude':store.state.business.longitude ?? ' 0.0',
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };

    ProxyService.database.insert(data:_mapBranch);
    store.dispatch(VerifyAuthenticationState());
  };
}

void Function(Store<AppState> store, dynamic action, NextDispatcher next)
    _onSetBranchHint(
        GlobalKey<NavigatorState> navigatorKey,  ) {
  // ignore: always_specify_types
  return (Store<AppState> store, action, next) async {
    // FIXME:
    // final List<Branch> branches = await branchRepo.getBranches(store);
    if (store.state.branch == null) {
      // if (branches.length == 1) {
        
        final Hint _hint = Hint((HintBuilder h) => h
          ..name = 'FIXME'
          ..type = HintType.Branch);
        store.dispatch(OnHintLoaded(hint: _hint));
      // } else {
      //   if (store.state.branch == null) {
      //     final Hint _hint = Hint((HintBuilder h) => h
      //       ..name = branches[0].name
      //       ..type = HintType.Branch);
      //     store.dispatch(OnHintLoaded(hint: _hint));
      //   }
      // }
    }
  };
}

//on create branch remember to fire the created branch as current branch
