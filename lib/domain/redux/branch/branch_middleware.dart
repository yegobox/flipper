import 'package:flipper/data/main_database.dart';
import 'package:flipper/data/respositories/branch_repository.dart';
import 'package:flipper/data/respositories/general_repository.dart';
import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/domain/redux/authentication/auth_actions.dart';
import 'package:flipper/domain/redux/branch/branch_actions.dart';
import 'package:flipper/domain/redux/business/business_actions.dart';
import 'package:flipper/model/branch.dart';
import 'package:flipper/model/hint.dart';
import 'package:flipper/model/unit.dart';
import 'package:flipper/util/util.dart';
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

void setUnits(store, branchId, GeneralRepository generalRepository) async {
  final kg = Unit((u) => u
    ..name = "kg"
    ..branchId = branchId
    ..businessId = store.state.businessId
    ..id = 1
    ..focused = false);

  final ounce = Unit((u) => u
    ..name = "ounce"
    ..businessId = store.state.businessId
    ..branchId = branchId
    ..id = 1
    ..focused = false);
  final pound = Unit((u) => u
    ..name = "pound"
    ..businessId = store.state.businessId
    ..id = 1
    ..branchId = branchId
    ..focused = false);
  final item = Unit((u) => u
    ..name = "item"
    ..businessId = store.state.businessId
    ..branchId = branchId
    ..id = 1
    ..focused = true);

  final custom = Unit((u) => u
    ..name = "custom"
    ..businessId = store.state.businessId
    ..branchId = branchId
    ..id = 1
    ..focused = false);

  await generalRepository.insertUnit(store, item);

  //toto: by setting each fire the progress to be used on SettingUpApplicationScreen as we set up each.. 25%
  await generalRepository.insertUnit(store, kg);
  //todo: by setting each fire the progress to be used on SettingUpApplicationScreen as we set up each.. 25%
  await generalRepository.insertUnit(store, ounce);
  //todo: by setting each fire the progress to be used on SettingUpApplicationScreen as we set up each.. 25%
  await generalRepository.insertUnit(store, pound);
  await generalRepository.insertUnit(store, custom);
  //todo: by setting each fire the progress to be used on SettingUpApplicationScreen as we set up each.. 25%
}

void Function(Store<AppState> store, dynamic action, NextDispatcher next)
    _onBusinessCreated(GlobalKey<NavigatorState> navigatorKey,
        BranchRepository branchRepo, GeneralRepository generalRepository) {
  return (store, action, next) async {
    if (store.state.branch != null) {
      final branch = Branch(
        (b) => b
          ..name = store.state.branch.name
          ..isActive = true,
      );
      final branchId = await branchRepo.insert(store, branch);

      await Util.getActiveBranch(store, branchId);
      //getting up the default units
      setUnits(store, branchId, generalRepository);
      //update store will all the thing we need and set all default values we want here
      store.dispatch(VerifyAuthenticationState());
    } else {
      //we are creating a branch from signup make is be like the same as business name.
      store.dispatch(ResetAppAction());
      final branch = Branch(
        (b) => b
          ..name = store.state.business.name
          ..isActive = true,
      );

      final branchId = await branchRepo.insert(store, branch);
      await Util.getActiveBranch(store, branchId);
      setUnits(store, branchId, generalRepository);
      store.dispatch(VerifyAuthenticationState());
    }
  };
}

void Function(Store<AppState> store, dynamic action, NextDispatcher next)
    _onSetBranchHint(
        GlobalKey<NavigatorState> navigatorKey, BranchRepository branchRepo) {
  return (store, action, next) async {
    List<BranchTableData> branches = await branchRepo.getBranches(store);
    if (store.state.branch == null) {
      if (branches.length == 1) {
        //we have only one branch then set it as hint
        final _hint = Hint((h) => h
          ..name = branches[0].name
          ..type = HintType.Branch);
        store.dispatch(OnHintLoaded(hint: _hint));
        //store.dispatch(ResetAppAction());
      } else {
        //todo: get the branch that is set as hint
        if (store.state.branch == null) {
          final _hint = Hint((h) => h
            ..name = branches[0].name
            ..type = HintType.Branch);
          store.dispatch(OnHintLoaded(hint: _hint));
        }
      }
    }
  };
}

//on create branch remember to fire the created branch as current branch
