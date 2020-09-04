import 'package:redux/redux.dart';

import 'data/main_database.dart';
import 'domain/redux/app_state.dart';

Future<int> logout({Store<AppState> store}) async {
  final UserTableData user = await store.state.database.userDao.getUser();
  final int logout = await store.state.database.userDao.deleteUser(user);
  return logout;
}
