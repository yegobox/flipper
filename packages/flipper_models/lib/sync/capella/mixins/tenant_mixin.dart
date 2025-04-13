import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/sync/interfaces/tenant_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:supabase_models/brick/models/user.model.dart' show User;
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

mixin CapellaTenantMixin implements TenantInterface {
  Repository get repository;
  Talker get talker;
  @override
  Future<Branch> activeBranch() {
    // TODO: implement activeBranch
    throw UnimplementedError();
  }

  @override
  Future<Business?> activeBusiness({int? userId}) {
    // TODO: implement activeBusiness
    throw UnimplementedError();
  }

  @override
  Stream<Tenant?> getDefaultTenant({required int businessId}) {
    // TODO: implement getDefaultTenant
    throw UnimplementedError();
  }

  @override
  Future<Tenant?> saveTenant(
      {required Business business,
      required Branch branch,
      String? phoneNumber,
      String? name,
      String? id,
      String? email,
      int? businessId,
      bool? sessionActive,
      int? branchId,
      String? imageUrl,
      int? pin,
      bool? isDefault,
      required HttpClientInterface flipperHttpClient,
      required String userType}) {
    // TODO: implement saveTenant
    throw UnimplementedError();
  }

  @override
  Future<User> saveUser({required User user}) {
    // TODO: implement saveUser
    throw UnimplementedError();
  }

  @override
  Future<User?> authUser({required String uuid}) async {
    // TODO: implement authUser
    throw UnimplementedError();
  }

  @override
  Future<void> createPin({
    required HttpClientInterface flipperHttpClient,
    required String phoneNumber,
    required int pin,
    required String branchId,
    required String businessId,
    required int defaultApp,
  }) async {
    throw UnimplementedError();
  }
}
