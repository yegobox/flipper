import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:redux/redux.dart';

class UserRepository {
  Future<void> logOut() async {
    await updateUserToken(null);
  }

  Future<void> updateUserToken(String token) async {}

  Future<UserTableData> checkAuth(Store<AppState> store) {
    return store.state.database.userDao.getUser();
  }
}
