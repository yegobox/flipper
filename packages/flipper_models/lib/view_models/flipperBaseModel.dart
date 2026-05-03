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

  Future<void> loadTenants() async {
    final businessId = ProxyService.box.getBusinessId();
    if (businessId == null || businessId.isEmpty) {
      _tenants = [];
      notifyListeners();
      return;
    }

    List<Tenant> users;
    try {
      final raw = await Supabase.instance.client
          .from('tenants')
          .select()
          .eq('business_id', businessId)
          .order('name');

      final rows = List<Map<String, dynamic>>.from(
        (raw as List).map((e) => Map<String, dynamic>.from(e as Map)),
      );

      users = rows
          .where((r) => r['deleted_at'] == null)
          .map(_tenantFromSupabaseRow)
          .toList();

      if (users.isEmpty) {
        final rawJunction = await Supabase.instance.client
            .from('tenant_businesses')
            .select('tenants(*)')
            .eq('business_id', businessId);

        final seen = <String>{};
        for (final row in rawJunction as List) {
          final m = Map<String, dynamic>.from(row as Map);
          final nested = m['tenants'];
          if (nested is! Map) continue;
          final t = _tenantFromSupabaseRow(
            Map<String, dynamic>.from(nested),
          );
          if (t.deletedAt != null) continue;
          if (seen.add(t.id)) users.add(t);
        }
      }
    } catch (e, s) {
      debugPrint('loadTenants Supabase: $e\n$s');
      try {
        users = await ProxyService.strategy.tenants(businessId: businessId);
      } catch (_) {
        users = [];
      }
    }

    final uniqueUserIds = <String>{};
    final uniqueUsers = <Tenant>[];

    for (final user in users) {
      if (!uniqueUserIds.contains(user.id)) {
        uniqueUserIds.add(user.id);
        uniqueUsers.add(user);
      } else {
        try {
          await ProxyService.strategy
              .flipperDelete(id: user.id, endPoint: 'tenant');
        } catch (_) {
          // ignore duplicate cleanup failures
        }
      }
    }

    _tenants = [...uniqueUsers];
    notifyListeners();
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
