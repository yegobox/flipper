import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/domain/redux/branch/branch_actions.dart';
import 'package:redux/redux.dart';

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
  return state.rebuild((a) => a..branch = action.branch.toBuilder());
}
