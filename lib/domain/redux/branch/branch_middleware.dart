import 'package:flipper/couchbase.dart';
import 'package:flipper/data/main_database.dart';
import 'package:flipper/data/respositories/branch_repository.dart';
import 'package:flipper/data/respositories/general_repository.dart';
import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/domain/redux/authentication/auth_actions.dart';
import 'package:flipper/domain/redux/branch/branch_actions.dart';
import 'package:flipper/domain/redux/business/business_actions.dart';
import 'package:flipper/model/hint.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createBranchMiddleware(
    GlobalKey<NavigatorState> navigatorKey,
    BranchRepository branchRepository,
    GeneralRepository generalRepository) {
  return [
    TypedMiddleware<AppState, BusinessCreated>(
        _onBusinessCreated(navigatorKey, branchRepository, generalRepository)),
    TypedMiddleware<AppState, OnSetBranchHint>(
        _onSetBranchHint(navigatorKey, branchRepository)),
  ];
}

void Function(Store<AppState> store, dynamic action, NextDispatcher next)
    _onBusinessCreated(GlobalKey<NavigatorState> navigatorKey,
        BranchRepository branchRepo, GeneralRepository generalRepository) {
  return (store, action, next) async {
    store.dispatch(ResetAppAction());

    //final branchId = await branchRepo.insertBranch(store, branch);
    //create tax for this branch

    Map<String, dynamic> _mapBranch = {
      'active': true,
      'name': store.state.business.name,
      '_id': 'branches_' + store.state.userId.toString(),
      'channel': store.state.userId.toString(),
      'businessId': store.state.businessId,
      'id': 'branches_' + store.state.userId.toString(),
      'mapLatitude': store.state.business.latitude ?? 0.0,
      'mapLongitude': store.state.currentColor ?? 0.0,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };
    AppDatabase.instance.createBranch(_mapBranch);
    store.dispatch(VerifyAuthenticationState());
  };
}

void Function(Store<AppState> store, dynamic action, NextDispatcher next)
    _onSetBranchHint(
        GlobalKey<NavigatorState> navigatorKey, BranchRepository branchRepo) {
  return (Store<AppState> store, action, next) async {
    final List<BranchTableData> branches = await branchRepo.getBranches(store);
    if (store.state.branch == null) {
      if (branches.length == 1) {
        //we have only one branch then set it as hint
        final Hint _hint = Hint((HintBuilder h) => h
          ..name = branches[0].name
          ..type = HintType.Branch);
        store.dispatch(OnHintLoaded(hint: _hint));
      } else {
        if (store.state.branch == null) {
          final Hint _hint = Hint((HintBuilder h) => h
            ..name = branches[0].name
            ..type = HintType.Branch);
          store.dispatch(OnHintLoaded(hint: _hint));
        }
      }
    }
  };
}

//on create branch remember to fire the created branch as current branch
