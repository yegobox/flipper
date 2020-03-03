import 'package:flipper/data/respositories/user_repository.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/domain/redux/business/business_actions.dart';
import 'package:flipper/domain/redux/user/user_actions.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:uuid/uuid.dart';

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
      String userId = Uuid().v1();
      Map map = {
        'active': true,
        '_id': 'users',
        'id': userId,
        'name': user.name.replaceAll(
            new RegExp(r"\s\b|\b\s"), ""), //remove any white space from string
        'role': 'Admin',
        'permissions': '',
        'token': user.token,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
        'email': user.email
      };
      store.dispatch(UserID(userId: userId));
      await store.state.couch.createUser(map);
      store.dispatch(CreateBusinessOnSignUp());
    }
  };
}
