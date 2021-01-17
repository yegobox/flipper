import 'package:redux/redux.dart';

import '../app_state.dart';
import 'auth_actions.dart';

final authReducers = <AppState Function(AppState, dynamic)>[
  TypedReducer<AppState, OnAuthenticated>(_onAuthenticated),
  TypedReducer<AppState, OnLogoutSuccess>(_onLogout),
  TypedReducer<AppState, OrderCreated>(_onOrderCreated),
];

AppState _onAuthenticated(AppState state, OnAuthenticated action) {
  return state.rebuild((a) => a..user = action.user?.toBuilder());
}

AppState _onLogout(AppState state, OnLogoutSuccess action) {
  return state.clear();
}

AppState _onOrderCreated(AppState state, OrderCreated action) {
  return state.rebuild((a) => a.order = action.order.toBuilder());
}
