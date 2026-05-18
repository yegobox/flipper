import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const String kCommissionOnlySessionKey = 'commissionOnlySession';

/// Persists whether the current session is commission-only (restricted agent login).
Future<void> setCommissionOnlySession(bool value) async {
  await ProxyService.box.writeBool(key: kCommissionOnlySessionKey, value: value);
}

bool isCommissionOnlySession() {
  return ProxyService.box.readBool(key: kCommissionOnlySessionKey) ?? false;
}

/// True when the user is an Agent for [businessId] without full business login.
Future<bool> resolveCommissionOnlyLogin({
  String? userId,
  String? businessId,
}) async {
  final uid = userId ?? ProxyService.box.getUserId();
  final bid = businessId ?? ProxyService.box.getBusinessId();
  if (uid == null || uid.isEmpty || bid == null || bid.isEmpty) {
    return false;
  }

  try {
    final row = await Supabase.instance.client
        .from('tenants')
        .select('type, allow_business_login')
        .eq('user_id', uid)
        .eq('business_id', bid)
        .maybeSingle();
    if (row != null) {
      final type = (row['type'] as String?) ?? '';
      final allowLogin = row['allow_business_login'] as bool? ?? false;
      return type == 'Agent' && !allowLogin;
    }
  } catch (_) {
    // Fall back to local tenant cache when offline.
  }

  final tenants = await ProxyService.strategy.tenants(businessId: bid);
  final match = tenants.where((t) => t.userId == uid).firstOrNull;
  if (match == null) return false;
  return match.type == 'Agent' && !match.allowBusinessLogin;
}
