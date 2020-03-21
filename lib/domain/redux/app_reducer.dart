import 'package:flipper/domain/redux/authentication/auth_reducer.dart';
import 'package:flipper/domain/redux/bottom_sheet/bottom_sheet_reducer.dart';
import 'package:flipper/domain/redux/branch/branch_reducer.dart';
import 'package:flipper/domain/redux/business/business_reducer.dart';
import 'package:flipper/domain/redux/user/user_reducer.dart';
import 'package:flipper/home/selling/selling_reducer.dart';
import 'package:redux/redux.dart';

import '../app_actions.dart';
import 'app_actions/app_actions_reducer.dart';
import 'app_state.dart';

final appReducer = combineReducers<AppState>([
  TypedReducer<AppState, OnProductLoaded>(_null),
  ...authReducers,
  ...businessReducer,
  ...userReducers,
  ...bottomSheetReducer,
  ...appActionReducer,
  ...branchReducers,
  ...sellingReducer
]);
// ignore: missing_return
AppState _null(AppState state, OnProductLoaded action) {}
