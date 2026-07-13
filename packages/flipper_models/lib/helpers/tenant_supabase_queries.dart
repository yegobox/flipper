import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/flipperBaseModel.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Direct Supabase reads for [Tenant] (aligned with [FlipperBaseModel.loadTenants]).
abstract final class TenantSupabaseQueries {
  static SupabaseClient get _client => Supabase.instance.client;

  static Future<Tenant?> byUserId(
    String userId, {
    String? scopeBusinessId,
  }) async {
    try {
      Future<List<dynamic>> fetchRows({String? businessUuid}) async {
        var query = _client
            .from('tenants')
            .select()
            .eq('user_id', userId)
            .isFilter('deleted_at', null);
        if (businessUuid != null && businessUuid.isNotEmpty) {
          query = query.eq('business_id', businessUuid);
        }
        return await query.order('last_touched', ascending: false).limit(1);
      }

      String? businessUuid;
      final resolvedScope = scopeBusinessId ?? ProxyService.box.getBusinessId();
      if (resolvedScope != null && resolvedScope.isNotEmpty) {
        businessUuid =
            await FlipperBaseModel.resolveBusinessUuidForTenants(resolvedScope);
      }

      var rows = await fetchRows(businessUuid: businessUuid);
      if (rows.isEmpty && businessUuid != null) {
        rows = await fetchRows();
      }
      if (rows.isEmpty) return null;
      return FlipperBaseModel.tenantFromSupabaseRow(
        Map<String, dynamic>.from(rows.first as Map),
      );
    } catch (e, s) {
      debugPrint('TenantSupabaseQueries.byUserId: $e\n$s');
      return null;
    }
  }

  static Future<Tenant?> byPin(int pin) async {
    try {
      final row = await _client
          .from('tenants')
          .select()
          .eq('pin', pin)
          .isFilter('deleted_at', null)
          .maybeSingle();
      if (row == null) return null;
      return FlipperBaseModel.tenantFromSupabaseRow(
        Map<String, dynamic>.from(row),
      );
    } catch (e, s) {
      debugPrint('TenantSupabaseQueries.byPin: $e\n$s');
      return null;
    }
  }

  static Future<Tenant?> byId(String tenantId) async {
    try {
      final row = await _client
          .from('tenants')
          .select()
          .eq('id', tenantId)
          .isFilter('deleted_at', null)
          .maybeSingle();
      if (row == null) return null;
      return FlipperBaseModel.tenantFromSupabaseRow(
        Map<String, dynamic>.from(row),
      );
    } catch (e, s) {
      debugPrint('TenantSupabaseQueries.byId: $e\n$s');
      return null;
    }
  }

  static Future<Tenant?> firstForBusiness(String businessId) async {
    try {
      final businessUuid =
          await FlipperBaseModel.resolveBusinessUuidForTenants(businessId);
      if (businessUuid == null || businessUuid.isEmpty) return null;

      final rows = await _client
          .from('tenants')
          .select()
          .eq('business_id', businessUuid)
          .isFilter('deleted_at', null)
          .order('name')
          .limit(1);
      if (rows.isEmpty) return null;
      return FlipperBaseModel.tenantFromSupabaseRow(
        Map<String, dynamic>.from(rows.first as Map),
      );
    } catch (e, s) {
      debugPrint('TenantSupabaseQueries.firstForBusiness: $e\n$s');
      return null;
    }
  }

  /// Tries [userId] match first, then numeric [pin] when [value] parses as int.
  static Future<Tenant?> byUserIdOrPin(String value) async {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    final byUser = await byUserId(trimmed);
    if (byUser != null) return byUser;
    final pin = int.tryParse(trimmed);
    if (pin != null) return byPin(pin);
    return null;
  }


  static Future<List<Tenant>> listByUserId(String userId) async {
    try {
      final rows = await _client
          .from('tenants')
          .select()
          .eq('user_id', userId)
          .isFilter('deleted_at', null)
          .order('name');
      return (rows as List)
          .map(
            (row) => FlipperBaseModel.tenantFromSupabaseRow(
              Map<String, dynamic>.from(row as Map),
            ),
          )
          .toList();
    } catch (e, s) {
      debugPrint('TenantSupabaseQueries.listByUserId: $e\n$s');
      return const [];
    }
  }

  static Future<Tenant?> defaultForBusiness(String businessId) async {
    try {
      final businessUuid =
          await FlipperBaseModel.resolveBusinessUuidForTenants(businessId);
      if (businessUuid == null || businessUuid.isEmpty) return null;

      final businessRow = await _client
          .from('businesses')
          .select('user_id')
          .eq('id', businessUuid)
          .maybeSingle();
      final ownerUserId = businessRow?['user_id']?.toString();
      if (ownerUserId != null && ownerUserId.isNotEmpty) {
        final ownerTenant = await _client
            .from('tenants')
            .select()
            .eq('business_id', businessUuid)
            .eq('user_id', ownerUserId)
            .isFilter('deleted_at', null)
            .maybeSingle();
        if (ownerTenant != null) {
          return FlipperBaseModel.tenantFromSupabaseRow(
            Map<String, dynamic>.from(ownerTenant),
          );
        }
      }

      return firstForBusiness(businessId);
    } catch (e, s) {
      debugPrint('TenantSupabaseQueries.defaultForBusiness: $e\n$s');
      return null;
    }
  }

  static Future<Tenant?> getTenant({String? userId, int? pin}) async {
    if (userId != null) return byUserId(userId);
    if (pin != null) return byPin(pin);
    throw Exception('UserId or Pin is required');
  }

  /// Resolves the tenants.id UUID for [tenant] in [businessUuid].
  ///
  /// Bar roster rows may use [Tenant.userId] as [Tenant.id] when the row was
  /// synthesized from `pins` without a matching `tenants` record.
  static Future<String?> tenantUuidForBusiness({
    required Tenant tenant,
    required String businessUuid,
    String? scopeBusinessId,
  }) async {
    final existing = await byId(tenant.id);
    if (existing != null) return existing.id;

    final userId = tenant.userId?.trim();
    if (userId == null || userId.isEmpty) return null;

    final byUser = await byUserId(userId, scopeBusinessId: scopeBusinessId);
    if (byUser != null) return byUser.id;

    try {
      final junction = await _client
          .from('tenant_businesses')
          .select('tenant_id')
          .eq('business_id', businessUuid);
      final tenantIds = <String>[];
      for (final row in junction as List) {
        if (row is! Map) continue;
        final id = row['tenant_id']?.toString();
        if (id != null && id.isNotEmpty) tenantIds.add(id);
      }
      if (tenantIds.isEmpty) return null;

      final rows = await _client
          .from('tenants')
          .select('id')
          .inFilter('id', tenantIds)
          .eq('user_id', userId)
          .isFilter('deleted_at', null)
          .order('last_touched', ascending: false)
          .limit(1);
      if (rows.isEmpty) return null;
      return (rows.first as Map)['id']?.toString();
    } catch (e, s) {
      debugPrint('TenantSupabaseQueries.tenantUuidForBusiness: $e\n$s');
      return null;
    }
  }

  /// Removes staff from a business: tenant access, orphan rows, and login PIN.
  static Future<void> removeStaffFromBusiness({
    required Tenant tenant,
    String? businessId,
  }) async {
    final scopedBusinessId = businessId ?? ProxyService.box.getBusinessId();
    if (scopedBusinessId == null || scopedBusinessId.isEmpty) {
      throw StateError('No active business');
    }

    final businessUuid =
        await FlipperBaseModel.resolveBusinessUuidForTenants(scopedBusinessId);
    if (businessUuid == null || businessUuid.isEmpty) {
      throw StateError('Could not resolve business');
    }

    final userId = tenant.userId?.trim();
    final tenantUuid = await tenantUuidForBusiness(
      tenant: tenant,
      businessUuid: businessUuid,
      scopeBusinessId: scopedBusinessId,
    );

    if (tenantUuid != null && tenantUuid.isNotEmpty) {
      await _client.rpc(
        'remove_tenant_access',
        params: {
          'p_tenant_id': tenantUuid,
          'p_business_id': businessUuid,
        },
      );
    } else if (userId == null || userId.isEmpty) {
      await _client.from('tenants').delete().eq('id', tenant.id);
    }

    if (userId != null && userId.isNotEmpty) {
      await _client.from('pins').delete().eq('user_id', userId);
    }
  }
}
