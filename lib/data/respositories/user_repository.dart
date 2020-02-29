import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/model/user.dart';
import 'package:redux/redux.dart';

class UserRepository {
  Future<int> insertUser(Store<AppState> store, User user) {
    //ignore:missing_required_param
    var u = new UserTableData(
        email: user.email,
        username: user.name,
        bearerToken: user.token,
        refreshToken: user.token);
    return store.state.database.userDao.insertUser(u);
  }

  Future<void> logOut() async {
    await updateUserToken(null);
  }

  Future<void> updateUserToken(String token) async {}

  Future<UserTableData> checkAuth(Store<AppState> store) {
    return store.state.database.userDao.getUser();
  }
}
