import 'package:flipper/data/respositories/user_repository.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/domain/redux/business/business_actions.dart';
import 'package:flipper/domain/redux/user/user_actions.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> userMiddleware(
  UserRepository userRepository,
  GlobalKey<NavigatorState> navigatorKey,
) {
  return [
    TypedMiddleware<AppState, CreateUser>(
        _createUser(navigatorKey, userRepository)),
  ];
}

void Function(Store<AppState> store, dynamic action, NextDispatcher next)
    _createUser(
        GlobalKey<NavigatorState> navigatorKey, UserRepository userRepository) {
  return (store, action, next) async {
    if (store.state.user != null) {
      int userId = await userRepository.insertUser(store, store.state.user);
      store.dispatch(UserID(userId));
      store.dispatch(CreateBusinessOnSignUp());
    }
  };
}
