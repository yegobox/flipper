import 'package:flipper_models/helperModels/iuser.dart';

abstract class SystemInterface {
  Future<void> configureSystem(String userPhone, IUser user,
      {required bool offlineLogin});
  Future<void> configureTheBox(String userPhone, IUser user);
  Future<void> saveNeccessaryData(IUser user);
  Future<void> suserbaseAuth();
}
