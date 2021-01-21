import 'package:built_collection/built_collection.dart';
import 'package:flipper/domain/redux/user/user_actions.dart';
import 'package:redux/redux.dart';

import '../app_state.dart';

final userReducers = <AppState Function(AppState, dynamic)>[
  TypedReducer<AppState, WithUser>(_withUser),
  TypedReducer<AppState, WithUsers>(_withUsers),
];


AppState _withUsers(AppState state, WithUsers action) {
  // ignore: always_specify_types
  return state.rebuild((AppStateBuilder a) => a..users = ListBuilder(action.users));
}


AppState _withUser(AppState state, WithUser action) {
  return state.rebuild((AppStateBuilder a) => a..user = action.user.toBuilder());
}
