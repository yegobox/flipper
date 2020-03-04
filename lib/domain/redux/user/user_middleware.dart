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

      assert(store.state.userId != null);
      String userId = Uuid().v1();
      Map mapUser = {
        'active': true,
        '_id': 'user_' + store.state.userId.toString(),
        'id': userId,
        'channel': store.state.userId.toString(),
        'name': user.name, //remove any white space from string
        'token': user.token,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
        'email': user.email
      };
      await store.state.couch.createUser(mapUser);
      store.dispatch(UserID(userId: store.state.userId));
      store.dispatch(CreateBusinessOnSignUp());
    }
  };
}
