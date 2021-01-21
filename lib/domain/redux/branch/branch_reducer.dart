import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/domain/redux/branch/branch_actions.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/database_service.dart';
import 'package:redux/redux.dart';
import 'package:uuid/uuid.dart';

// ignore: always_specify_types
final branchReducers = <AppState Function(AppState, dynamic)>[
  TypedReducer<AppState, OnBranchLoaded>(_onBranchLoaded),
  TypedReducer<AppState, OnCurrentBranchAction>(_onActiveBranch),
  TypedReducer<AppState, OnHintLoaded>(_onHintLoaded),
];

AppState _onBranchLoaded(AppState state, OnBranchLoaded action) {
  return state.rebuild((a) => a..branches = action.branches);
}

AppState _onHintLoaded(AppState state, OnHintLoaded action) {
  return state.rebuild((a) => a..hint = action.hint.toBuilder());
}

AppState _onActiveBranch(AppState state, OnCurrentBranchAction action) {
  //create default category if does not exist on active branch

  return state
      .rebuild((AppStateBuilder a) => a..branch = action.branch.toBuilder());
}
