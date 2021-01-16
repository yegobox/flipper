import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/domain/redux/business/business_actions.dart';
import 'package:flipper/domain/redux/user/user_actions.dart';
import 'package:flipper_models/fuser.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:uuid/uuid.dart';
import 'package:flipper_services/proxy.dart';

List<Middleware<AppState>> userMiddleware(
  GlobalKey<NavigatorState> navigatorKey,
) {
  return [
    TypedMiddleware<AppState, CreateUser>(_createUser(navigatorKey)),
  ];
}

void Function(Store<AppState> store, dynamic action, NextDispatcher next)
    _createUser(GlobalKey<NavigatorState> navigatorKey) {
  // ignore: always_specify_types
  return (Store<AppState> store, action, next) async {
    if (store.state.user != null) {
      final FUser user = store.state.user;

      assert(store.state.user.id != null);

      // ignore: always_specify_types
      final Map<String, dynamic> mapUser = {
        'active': true,
        '_id': 'user_' + store.state.user.id.toString(),
        'uid': Uuid().v1(),
        'id': store.state.user.id.toString(),
        'channels': [store.state.user.id.toString()],
        'name': user.name.trim(),
        'token': user.token,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
        'email': user.email
      };

      final Document u = ProxyService.database
          .insert(id: store.state.user.id.toString(), data: mapUser);

      store.dispatch(WithUser(user: FUser.fromMap(u.jsonProperties)));

      store.dispatch(CreateBusinessOnSignUp());
    }
  };
}
