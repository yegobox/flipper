import 'package:flipper_models/helperModels/iuser.dart';
import 'package:flipper_models/sync/interfaces/system_interface.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/supabase_session_service.dart';
import 'dart:async';

mixin SystemMixin implements SystemInterface {
  @override
  Future<void> configureTheBox(String userPhone, IUser user) async {
    final id = user.id.trim();
    await ProxyService.box.writeString(key: 'userIdString', value: id);
    await ProxyService.box.writeString(key: 'userId', value: id);
    await ProxyService.box.writeString(key: 'userPhone', value: userPhone);
    final name = user.name?.trim();
    if (name != null && name.isNotEmpty) {
      await ProxyService.box.writeString(key: 'userName', value: name);
    }
  }

  @override
  Future<void> saveNeccessaryData(IUser user) async {
    final id = user.id.trim();
    await ProxyService.box.writeString(key: 'userIdString', value: id);
    await ProxyService.box.writeString(key: 'userId', value: id);
    await ProxyService.box.writeString(key: 'token', value: user.token ?? "");
  }

  @override
  Future<void> configureSystem(String userPhone, IUser user,
      {required bool offlineLogin}) async {
    await configureTheBox(userPhone, user);
    await saveNeccessaryData(user);
    if (!offlineLogin) {
      // Login choices does not need Supabase immediately; avoid blocking PIN login.
      unawaited(suserbaseAuth());
    }
  }

  @override
  Future<void> suserbaseAuth() async {
    await SupabaseSessionService.ensureAccessToken();
  }
}
