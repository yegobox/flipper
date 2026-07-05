import 'package:flipper_routing/app.dialogs.dart';
import 'package:flipper_services/proxy.dart';

import 'package:stacked/stacked.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FlipperBaseModel extends ReactiveViewModel {
  List<Tenant> _tenants = [];
  List<Tenant> get tenants => _tenants;

  void deleteTenantById(int tenantId) {
    _tenants.removeWhere((tenant) => tenant.id == tenantId);
    notifyListeners();
  }

  void deleteTenant(Tenant tenant) {
    _tenants.remove(tenant);
    notifyListeners();
  }

  /// Whether this tenant is an Agent with a login user (POS sale attribution).
  static bool isAgentTenantForSale(Tenant t) {
    final type = (t.type ?? '').trim().toLowerCase();
    final uid = (t.userId ?? '').trim();
    return type == 'agent' && uid.isNotEmpty;
  }

  /// Agent tenants for [businessId] via Supabase — same pipeline as [loadTenants].
  static Future<List<Tenant>> fetchAgentTenantsFromSupabase({
    String? businessId,
  }) async {
    final id = businessId ?? ProxyService.box.getBusinessId();
    if (id == null || id.isEmpty) return const [];

    try {
      final businessUuid = await resolveBusinessUuidForTenants(id);
      if (businessUuid == null || businessUuid.isEmpty) return const [];

      final users = await fetchTenantsFromSupabase(businessUuid);
      final deduped = dedupeTenantsForDisplay(users);
      return deduped.where(isAgentTenantForSale).toList();
    } catch (e, s) {
      debugPrint('fetchAgentTenantsFromSupabase: $e\n$s');
      return const [];
    }
  }

  /// Resolves [businessId] from box to the businesses.id UUID used in Supabase.
  static Future<String?> resolveBusinessUuidForTenants(
    String businessId,
  ) async {
    try {
      final row = await Supabase.instance.client
          .from('businesses')
          .select('id')
          .eq('id', businessId)
          .maybeSingle();
      return row?['id']?.toString();
    } catch (e, s) {
      debugPrint('loadTenants resolve business uuid: $e\n$s');
      return null;
    }
  }

  /// Loads all tenants for a business from Supabase (not Brick).
  ///
  /// Many legacy rows have `tenants.business_id` null and are linked via `pins`.
  static Future<List<Tenant>> fetchTenantsFromSupabase(
    String businessUuid,
  ) async {
    final client = Supabase.instance.client;
    final byTenantId = <String, Tenant>{};

    void ingestRows(List<dynamic> raw) {
      for (final item in raw) {
        if (item is! Map) continue;
        final row = Map<String, dynamic>.from(item);
        if (row['deleted_at'] != null) continue;
        final rowBusinessId = row['business_id']?.toString();
        // Rows fetched via pins/junction can belong to another business
        // (same user, different business). Never show those here.
        if (rowBusinessId != null &&
            rowBusinessId.isNotEmpty &&
            rowBusinessId != businessUuid) {
          continue;
        }
        if (row['business_id'] == null) {
          row['business_id'] = businessUuid;
        }
        final tenant = tenantFromSupabaseRow(row);
        byTenantId.putIfAbsent(tenant.id, () => tenant);
      }
    }

    final direct = await client
        .from('tenants')
        .select()
        .eq('business_id', businessUuid)
        .order('name');
    ingestRows(direct as List);

    final pinRows = await client
        .from('pins')
        .select('user_id')
        .eq('business_id', businessUuid);

    final userIds = <String>{};
    for (final row in pinRows as List) {
      if (row is! Map) continue;
      final uid = row['user_id']?.toString();
      if (uid != null && uid.isNotEmpty) userIds.add(uid);
    }

    if (userIds.isNotEmpty) {
      final viaPins = await client
          .from('tenants')
          .select()
          .inFilter('user_id', userIds.toList())
          .order('name');
      ingestRows(viaPins as List);
    }

    final junction = await client
        .from('tenant_businesses')
        .select('tenants(*)')
        .eq('business_id', businessUuid)
        .isFilter('deleted_at', null);

    for (final row in junction as List) {
      if (row is! Map) continue;
      final nested = row['tenants'];
      if (nested is! Map) continue;
      ingestRows([nested]);
    }

    final tenants = byTenantId.values.toList()
      ..sort(
        (a, b) => (a.name ?? '').toLowerCase().compareTo(
          (b.name ?? '').toLowerCase(),
        ),
      );
    return tenants;
  }

  Future<void> loadTenants() async {
    final businessId = ProxyService.box.getBusinessId();
    if (businessId == null || businessId.isEmpty) {
      _tenants = [];
      notifyListeners();
      return;
    }

    List<Tenant> users;
    try {
      final businessUuid = await resolveBusinessUuidForTenants(businessId);
      if (businessUuid == null || businessUuid.isEmpty) {
        debugPrint('loadTenants: could not resolve business id "$businessId"');
        users = [];
      } else {
        users = await fetchTenantsFromSupabase(businessUuid);
        debugPrint(
          'loadTenants: businessUuid=$businessUuid count=${users.length}',
        );
      }
    } catch (e, s) {
      debugPrint('loadTenants Supabase: $e\n$s');
      users = [];
    }

    _tenants = dedupeTenantsForDisplay(users);
    notifyListeners();
  }

  /// One row per login identity in the UI (same [Tenant.userId] or same email).
  ///
  /// Prefers a row with [Tenant.businessId] set, then latest [Tenant.lastTouched].
  static List<Tenant> dedupeTenantsForDisplay(List<Tenant> users) {
    int score(Tenant t) {
      var s = 0;
      if (t.businessId != null && t.businessId!.isNotEmpty) s += 100;
      if (t.lastTouched != null) s += 10;
      return s;
    }

    String identityKey(Tenant t) {
      final uid = t.userId?.trim();
      if (uid != null && uid.isNotEmpty) return 'uid:$uid';
      final email = t.email?.trim().toLowerCase();
      if (email != null && email.isNotEmpty) return 'email:$email';
      final phone = t.phoneNumber?.trim();
      if (phone != null && phone.isNotEmpty) return 'phone:$phone';
      return 'id:${t.id}';
    }

    final bestByIdentity = <String, Tenant>{};
    for (final user in users) {
      final key = identityKey(user);
      final existing = bestByIdentity[key];
      if (existing == null) {
        bestByIdentity[key] = user;
        continue;
      }
      if (score(user) > score(existing)) {
        bestByIdentity[key] = user;
      } else if (score(user) == score(existing) &&
          user.id.compareTo(existing.id) < 0) {
        bestByIdentity[key] = user;
      }
    }

    return bestByIdentity.values.toList()..sort(
      (a, b) =>
          (a.name ?? '').toLowerCase().compareTo((b.name ?? '').toLowerCase()),
    );
  }

  /// PINs keyed by `user_id` for a business (from the `pins` table).
  static Future<Map<String, int>> fetchPinsByUserIdForBusiness(
    String businessUuid,
  ) async {
    final rows = await Supabase.instance.client
        .from('pins')
        .select('user_id, pin')
        .eq('business_id', businessUuid);

    final map = <String, int>{};
    for (final row in rows as List) {
      if (row is! Map) continue;
      final uid = row['user_id']?.toString();
      if (uid == null || uid.isEmpty) continue;
      final pinRaw = row['pin'];
      int? pin;
      if (pinRaw is int) {
        pin = pinRaw;
      } else if (pinRaw is num) {
        pin = pinRaw.toInt();
      } else if (pinRaw != null) {
        pin = int.tryParse(pinRaw.toString());
      }
      if (pin != null) map[uid] = pin;
    }
    return map;
  }

  /// Copies [tenant] with [pinsByUserId] when [Tenant.pin] is null.
  static Tenant withPinFromLookup(
    Tenant tenant,
    Map<String, int> pinsByUserId,
  ) {
    if (tenant.pin != null) return tenant;
    final uid = tenant.userId;
    if (uid == null || uid.isEmpty) return tenant;
    final pin = pinsByUserId[uid];
    if (pin == null) return tenant;
    return Tenant(
      id: tenant.id,
      name: tenant.name,
      phoneNumber: tenant.phoneNumber,
      email: tenant.email,
      nfcEnabled: tenant.nfcEnabled,
      businessId: tenant.businessId,
      userId: tenant.userId,
      imageUrl: tenant.imageUrl,
      lastTouched: tenant.lastTouched,
      deletedAt: tenant.deletedAt,
      pin: pin,
      isDefault: tenant.isDefault,
      sessionActive: tenant.sessionActive,
      type: tenant.type,
      allowBusinessLogin: tenant.allowBusinessLogin,
    );
  }

  /// Bar Mode staff roster — same tenants as User Management, with PINs merged
  /// from the `pins` table when `tenants.pin` is null.
  static Future<List<Tenant>> fetchBarStaffTenants({String? businessId}) async {
    final id = businessId ?? ProxyService.box.getBusinessId();
    if (id == null || id.isEmpty) return const [];

    final businessUuid = await resolveBusinessUuidForTenants(id);
    if (businessUuid == null || businessUuid.isEmpty) return const [];

    final pinsByUserId = await fetchPinsByUserIdForBusiness(businessUuid);
    var tenants = dedupeTenantsForDisplay(
      await fetchTenantsFromSupabase(businessUuid),
    ).map((t) => withPinFromLookup(t, pinsByUserId)).toList();

    final currentUserId = ProxyService.box.getUserId();
    if (currentUserId != null &&
        !tenants.any((t) => t.userId == currentUserId)) {
      final rows = await Supabase.instance.client
          .from('tenants')
          .select()
          .eq('user_id', currentUserId)
          .isFilter('deleted_at', null)
          .order('last_touched', ascending: false)
          .limit(1);
      if (rows.isNotEmpty) {
        final self = tenantFromSupabaseRow(
          Map<String, dynamic>.from(rows.first as Map),
        );
        tenants = [...tenants, withPinFromLookup(self, pinsByUserId)];
      }
    }

    tenants.sort(
      (a, b) => (a.name ?? '').toLowerCase().compareTo(
        (b.name ?? '').toLowerCase(),
      ),
    );
    return tenants;
  }

  static Tenant tenantFromSupabaseRow(Map<String, dynamic> r) {
    String sid(Object? v) => v?.toString() ?? '';

    final pinRaw = r['pin'];
    int? pin;
    if (pinRaw is int) {
      pin = pinRaw;
    } else if (pinRaw is num) {
      pin = pinRaw.toInt();
    } else if (pinRaw != null) {
      pin = int.tryParse(pinRaw.toString());
    }

    DateTime? parseTs(Object? v) {
      if (v == null) return null;
      if (v is DateTime) return v;
      return DateTime.tryParse(v.toString());
    }

    return Tenant(
      id: sid(r['id']),
      name: r['name'] as String?,
      phoneNumber: r['phone_number'] as String?,
      email: r['email'] as String?,
      nfcEnabled: (r['nfc_enabled'] as bool?) ?? false,
      businessId: r['business_id'] != null ? sid(r['business_id']) : null,
      userId: r['user_id'] != null ? sid(r['user_id']) : null,
      imageUrl: r['image_url'] as String?,
      lastTouched: parseTs(r['last_touched']),
      deletedAt: parseTs(r['deleted_at']),
      pin: pin,
      isDefault: r['is_default'] as bool?,
      sessionActive: r['session_active'] as bool?,
      type: (r['type'] as String?) ?? 'Agent',
      allowBusinessLogin: (r['allow_business_login'] as bool?) ?? false,
    );
  }

  /// keyboard events handler

  void handleKeyBoardEvents({required KeyEvent event}) {
    final DialogService _dialogService = locator<DialogService>();

    if (event.logicalKey == LogicalKeyboardKey.f9) {
      print("F9 is pressed");
      // Add your F9 key handling logic here
    } else if (event.logicalKey == LogicalKeyboardKey.f10) {
      print("F10 is pressed");
      // Add your F10 key handling logic here
    } else if (event.logicalKey == LogicalKeyboardKey.f12) {
      print("F12 is pressed");
      // Add your F12 key handling logic here
    } else if (event.logicalKey == LogicalKeyboardKey.escape) {
      print("Escape key is pressed");
      _dialogService.showCustomDialog(
        variant: DialogType.logOut,
        title: 'Log out',
      );
    }
  }
}
