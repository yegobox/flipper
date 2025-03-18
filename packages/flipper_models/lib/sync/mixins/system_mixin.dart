import 'package:flipper_models/helperModels/iuser.dart';
import 'package:flipper_models/sync/interfaces/system_interface.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase/supabase.dart' as superUser;
import 'package:supabase_flutter/supabase_flutter.dart';

mixin SystemMixin implements SystemInterface {
  @override
  Future<void> configureTheBox(String userPhone, IUser user) async {
    await ProxyService.box.writeInt(key: 'userId', value: user.id!);
    await ProxyService.box.writeString(key: 'userPhone', value: userPhone);
  }

  @override
  Future<void> saveNeccessaryData(IUser user) async {
    await ProxyService.box.writeInt(key: 'userId', value: user.id!);
    await ProxyService.box.writeString(key: 'token', value: user.token);
  }

  @override
  Future<void> configureSystem(String userPhone, IUser user,
      {required bool offlineLogin}) async {
    await configureTheBox(userPhone, user);
    await saveNeccessaryData(user);
    if (!offlineLogin) {
      await suserbaseAuth();
    }
  }

  @override
  Future<void> suserbaseAuth() async {
    try {
      final email = '${ProxyService.box.getBranchId()}@flipper.rw';
      final superUser.User? existingUser =
          Supabase.instance.client.auth.currentUser;

      if (existingUser == null) {
        await Supabase.instance.client.auth.signUp(
          email: email,
          password: email,
        );
      } else {
        await Supabase.instance.client.auth.signInWithPassword(
          email: email,
          password: email,
        );
      }
    } catch (e) {}
  }
}
