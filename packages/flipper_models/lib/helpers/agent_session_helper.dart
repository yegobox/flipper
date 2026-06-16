import 'package:flipper_services/proxy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const String kCommissionOnlySessionKey = 'commissionOnlySession';

/// Persists whether the current session is commission-only (restricted agent login).
Future<void> setCommissionOnlySession(bool value) async {
  await ProxyService.box.writeBool(
    key: kCommissionOnlySessionKey,
    value: value,
  );
}

bool isCommissionOnlySession() {
  return ProxyService.box.readBool(key: kCommissionOnlySessionKey) ?? false;
}

/// Login identity from box (prefers API `userIdString`) or Ditto user_access `id`.
Future<String?> resolveSessionUserId({String? userId}) async {
  if (userId != null && userId.trim().isNotEmpty) {
    return userId.trim();
  }

  final fromBox = ProxyService.box.getUserId();
  if (fromBox == null || fromBox.isEmpty) {
    return null;
  }

  if (!ProxyService.ditto.isReady()) {
    return fromBox;
  }

  try {
    final access = await ProxyService.ditto.getUserAccess(fromBox);
    final accessId = access?['id']?.toString().trim();
    if (accessId != null && accessId.isNotEmpty) {
      return accessId;
    }
  } catch (_) {
    // Use box value when Ditto is unavailable.
  }

  return fromBox;
}

/// Resolves commission-only status, persists it, and returns the result.
Future<bool> refreshCommissionOnlySession({
  String? userId,
  String? businessId,
}) async {
  final commissionOnly = await resolveCommissionOnlyLogin(
    userId: userId,
    businessId: businessId,
  );
  await setCommissionOnlySession(commissionOnly);
  return commissionOnly;
}

/// True when the user is an Agent for [businessId] without full business login.
Future<bool> resolveCommissionOnlyLogin({
  String? userId,
  String? businessId,
}) async {
  final uid = await resolveSessionUserId(userId: userId);
  final bid = businessId ?? ProxyService.box.getBusinessId();
  if (uid == null || uid.isEmpty || bid == null || bid.isEmpty) {
    return false;
  }

  // One targeted, authoritative tenant lookup, time-bounded so a slow or
  // offline network can never stall navigation into the app (this runs on the
  // blocking login path before routing). On timeout/error we keep the last
  // resolved value persisted by [setCommissionOnlySession] rather than firing
  // another network query, so we stay both fresh-when-online and fast-when-not.
  try {
    final row = await Supabase.instance.client
        .from('tenants')
        .select('type, allow_business_login')
        .eq('user_id', uid)
        .eq('business_id', bid)
        .maybeSingle()
        .timeout(const Duration(seconds: 5));
    if (row == null) return false;
    final type = (row['type'] as String?) ?? '';
    final allowLogin = row['allow_business_login'] as bool? ?? false;
    return type == 'Agent' && !allowLogin;
  } catch (_) {
    // Slow/offline network — preserve the last authoritative result.
    return isCommissionOnlySession();
  }
}
