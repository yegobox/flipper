import 'package:flipper_models/sync/interfaces/system_interface.dart';
import 'package:flipper_models/helperModels/iuser.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

mixin CapellaSystemMixin implements SystemInterface {
  Repository get repository;
  Talker get talker;

  @override
  Future<void> configureSystem(String userPhone, IUser user, {required bool offlineLogin}) async {
    throw UnimplementedError('configureSystem needs to be implemented for Capella');
  }

  @override
  Future<void> configureTheBox(String userPhone, IUser user) async {
    throw UnimplementedError('configureTheBox needs to be implemented for Capella');
  }

  @override
  Future<void> saveNeccessaryData(IUser user) async {
    throw UnimplementedError('saveNeccessaryData needs to be implemented for Capella');
  }

  @override
  Future<void> suserbaseAuth() async {
    throw UnimplementedError('suserbaseAuth needs to be implemented for Capella');
  }
}
