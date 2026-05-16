import 'package:flipper_models/helperModels/iuser.dart';
import 'package:flipper_models/sync/interfaces/system_interface.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/supabase_session_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

mixin SystemMixin implements SystemInterface {
  @override
  Future<void> configureTheBox(String userPhone, IUser user) async {
    await ProxyService.box.writeString(key: 'userId', value: user.id);
    await ProxyService.box.writeString(key: 'userPhone', value: userPhone);
  }

  @override
  Future<void> saveNeccessaryData(IUser user) async {
    await ProxyService.box.writeString(key: 'userId', value: user.id);
    await ProxyService.box.writeString(key: 'token', value: user.token ?? "");
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
    await SupabaseSessionService.ensureAccessToken();
  }
}
