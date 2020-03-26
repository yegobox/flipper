import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/domain/redux/authentication/auth_actions.dart';
import 'package:redux/redux.dart';

class UserRepository {
  Future<void> logOut(Store<AppState> store) async {
    UserTableData user_exist = await store.state.database.userDao.getUser();
    if (user_exist == null) {
      store.state.database.userDao.deleteUser(user_exist);
    }

    store.dispatch(ResetAppAction(type: 'User'));
    //and should log a user out.
    store.dispatch(
      VerifyAuthenticationState(),
    );
  }

  Future<void> updateUserToken(String token, Store<AppState> store) async {
    //get current user
    UserTableData user_exist = await store.state.database.userDao.getUser();
    if (user_exist == null) {
      //todo: update flipper so it can send the notification accordingly.
      print('token:' + token);
      store.state.database.userDao
          .updateUser(user_exist.copyWith(token: token));
    }
  }

  Future<UserTableData> checkAuth(Store<AppState> store) {
    return store.state.database.userDao.getUser();
  }
}
