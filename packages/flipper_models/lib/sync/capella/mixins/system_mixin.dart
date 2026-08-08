import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/sync/interfaces/system_interface.dart';
import 'package:flipper_models/helperModels/iuser.dart';
import 'package:flipper_services/supabase_session_service.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

mixin CapellaSystemMixin implements SystemInterface {
  Repository get repository;
  Talker get talker;

  // TODO(ditto-migration): port `configureSystem` to Ditto.
  @override
  Future<void> configureSystem(String userPhone, IUser user,
      {required bool offlineLogin}) async {
    return ProxyService.legacyStrategy.configureSystem(userPhone, user, offlineLogin: offlineLogin);
  }

  // Declared on SystemInterface but implemented by neither database — nothing
  // in the app calls them through the strategy.
  @override
  Future<void> configureTheBox(String userPhone, IUser user) async {
    throw UnimplementedError('configureTheBox is not implemented');
  }

  @override
  Future<void> saveNeccessaryData(IUser user) async {
    throw UnimplementedError('saveNeccessaryData is not implemented');
  }

  @override
  Future<void> suserbaseAuth() async {
    await SupabaseSessionService.ensureAccessToken();
  }
}
