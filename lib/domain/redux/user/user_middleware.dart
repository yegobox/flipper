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
      var user = store.state.user;
      //int userId = await userRepository.insertUser(store, store.state.user);
      // store.dispatch(UserID(userId));
      Map map = {
        'active': true,
        '_id': 'users',
        'name': user.name,
        'role': 'Admin',
        'permissions': '',
        'token': user.token,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
        'email': user.email
      };
      store.state.couch.createUser(map);
      store.dispatch(CreateBusinessOnSignUp());
    }
  };
}
