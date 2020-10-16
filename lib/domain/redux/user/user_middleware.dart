import 'package:flipper/couchbase.dart';
import 'package:flipper/data/respositories/user_repository.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/domain/redux/business/business_actions.dart';
import 'package:flipper/domain/redux/user/user_actions.dart';
import 'package:flipper/model/fuser.dart';
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
  // ignore: always_specify_types
  return (Store<AppState> store, action, next) async {
    if (store.state.user != null) {
      final FUser user = store.state.user;
      print(store.state.user);
      assert(store.state.user.id != null);
      final String userId = Uuid().v1();
      // ignore: always_specify_types
      final Map<String,dynamic> mapUser = {
        'active': true,
        '_id': 'user_' + store.state.user.id.toString(),
        'uid': Uuid().v1(),
        'id': userId,
        // ignore: always_specify_types
        'channels': [store.state.user.id.toString()],//users allowed to see a document.
        'name': user.name, //remove any white space from string
        'token': user.token,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
        'email': user.email
      };
      await AppDatabase.instance.createUser(mapUser);

      // store.dispatch(UserID(userId: store.state.user.id));
      
      // store.dispatch(WithUser(user: user));
      
      store.dispatch(CreateBusinessOnSignUp());
    }
  };
}
