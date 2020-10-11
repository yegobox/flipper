import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/domain/redux/branch/branch_actions.dart';
import 'package:flipper/locator.dart';
import 'package:flipper/services/database_service.dart';
import 'package:redux/redux.dart';

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
   final DatabaseService _databaseService = locator<DatabaseService>();
  _databaseService.insert(id: '1ux-default-category',data:{'tableName':'categories_'+action.branch.id,'name':'custom'});

  return state.rebuild((AppStateBuilder a) => a..branch = action.branch.toBuilder());
}
