import 'package:flipper_models/realm/schemas.dart';
import 'package:realm/realm.dart';

abstract class LocalRealmInterface {
  Future<LocalRealmInterface> configureLocal({required bool inTesting});
  Realm? rea;
  bool isRealmClosed();
  Future<void> refreshSession({required int branchId, int? refreshRate = 5});
  Future<List<UserActivity>> activities({required int userId});
  Future<String> dbPath();
}
