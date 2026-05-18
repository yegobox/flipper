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

  /// Resolves [businessId] from box to the businesses.id UUID used in Supabase.
  static Future<String?> _resolveBusinessUuid(String businessId) async {
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
  static Future<List<Tenant>> _fetchTenantsFromSupabase(
    String businessUuid,
  ) async {
    final client = Supabase.instance.client;
    final byTenantId = <String, Tenant>{};

    void ingestRows(List<dynamic> raw) {
      for (final item in raw) {
        if (item is! Map) continue;
        final row = Map<String, dynamic>.from(item);
        if (row['deleted_at'] != null) continue;
        if (row['business_id'] == null) {
          row['business_id'] = businessUuid;
        }
        final tenant = _tenantFromSupabaseRow(row);
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
      final businessUuid = await _resolveBusinessUuid(businessId);
      if (businessUuid == null || businessUuid.isEmpty) {
        debugPrint('loadTenants: could not resolve business id "$businessId"');
        users = [];
      } else {
        users = await _fetchTenantsFromSupabase(businessUuid);
        debugPrint(
          'loadTenants: businessUuid=$businessUuid count=${users.length}',
        );
      }
    } catch (e, s) {
      debugPrint('loadTenants Supabase: $e\n$s');
      users = [];
    }

    _tenants = _dedupeTenantsForDisplay(users);
    notifyListeners();
  }

  /// One row per login identity in the UI (same [Tenant.userId] or same email).
  ///
  /// Prefers a row with [Tenant.businessId] set, then latest [Tenant.lastTouched].
  static List<Tenant> _dedupeTenantsForDisplay(List<Tenant> users) {
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

    return bestByIdentity.values.toList()
      ..sort(
        (a, b) => (a.name ?? '').toLowerCase().compareTo(
              (b.name ?? '').toLowerCase(),
            ),
      );
  }

  static Tenant _tenantFromSupabaseRow(Map<String, dynamic> r) {
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
