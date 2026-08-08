import 'dart:async';

import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/sync/interfaces/tenant_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:supabase_models/brick/models/user.model.dart' show User;
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

import 'package:flipper_services/proxy.dart';
import 'package:brick_offline_first/brick_offline_first.dart';

mixin CapellaTenantMixin implements TenantInterface {
  Repository get repository;
  Talker get talker;
  // TODO(ditto-migration): port `deleteTenantsWithNullPin` to Ditto.
  @override
  Future<void> deleteTenantsWithNullPin({String? businessId}) {
    return ProxyService.legacyStrategy.deleteTenantsWithNullPin(businessId: businessId);
  }

  @override
  Future<Business?> activeBusiness({int? userId}) async {
    return (await repository.get<Business>(
      policy: OfflineFirstGetPolicy.localOnly,
      query: Query(
        where: [
          Where('id').isExactly(ProxyService.box.getBusinessId()),
        ],
      ),
    ))
        .firstOrNull;
  }

  // TODO(ditto-migration): port `getDefaultTenant` to Ditto.
  @override
  Stream<Tenant?> getDefaultTenant({required String businessId}) {
    return ProxyService.legacyStrategy.getDefaultTenant(businessId: businessId);
  }

  // TODO(ditto-migration): port `saveUser` to Ditto.
  @override
  Future<User> saveUser({required User user}) {
    return ProxyService.legacyStrategy.saveUser(user: user);
  }

  // TODO(ditto-migration): port `authUser` to Ditto.
  @override
  Future<User?> authUser({required String uuid}) async {
    return ProxyService.legacyStrategy.authUser(uuid: uuid);
  }

  // TODO(ditto-migration): port `createPin` to Ditto.
  @override
  Future<void> createPin({
    required HttpClientInterface flipperHttpClient,
    required String phoneNumber,
    required int pin,
    required String branchId,
    required String businessId,
    required int defaultApp,
  }) async {
    return ProxyService.legacyStrategy.createPin(flipperHttpClient: flipperHttpClient, phoneNumber: phoneNumber, pin: pin, branchId: branchId, businessId: businessId, defaultApp: defaultApp);
  }

  // TODO(ditto-migration): port `tenant` to Ditto.
  @override
  Future<Tenant?> tenant(
      {String? businessId,
      String? userId,
      String? tenantId,
      required bool fetchRemote}) {
    return ProxyService.legacyStrategy.tenant(businessId: businessId, userId: userId, tenantId: tenantId, fetchRemote: fetchRemote);
  }
}
