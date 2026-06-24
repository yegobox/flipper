import 'package:flipper_dashboard/providers/business_agents_provider.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helpers/agent_session_helper.dart';
import 'package:flipper_models/view_models/flipperBaseModel.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// True when the logged-in user is an Agent tenant for this business.
final isCurrentUserAgentProvider = FutureProvider.autoDispose<bool>((ref) async {
  final uid = await resolveSessionUserId();
  if (uid == null || uid.isEmpty) return false;
  final agents = await ref.watch(businessAgentsProvider.future);
  return agents.any((t) => t.userId == uid);
});

/// Business owner or Settings admin — can view all agents and record payouts.
///
/// Uses Supabase directly so this works on web (Capella) where
/// [ProxyService.strategy.getBusiness] / [isAdmin] may be unimplemented.
Future<bool> resolveCanManageAgentCommission() async {
  final uid = await resolveSessionUserId();
  if (uid == null || uid.isEmpty) return false;

  final businessId = ProxyService.box.getBusinessId();
  if (businessId == null || businessId.isEmpty) return false;

  final businessUuid =
      await FlipperBaseModel.resolveBusinessUuidForTenants(businessId);
  if (businessUuid == null || businessUuid.isEmpty) return false;

  final client = Supabase.instance.client;

  try {
    final ownerRow = await client
        .from('businesses')
        .select('id')
        .eq('id', businessUuid)
        .eq('user_id', uid)
        .maybeSingle();
    if (ownerRow != null) return true;
  } catch (_) {
    // Fall through to Settings admin check.
  }

  try {
    final rows = await client
        .from('accesses')
        .select('feature_name, access_level, status, expires_at')
        .eq('business_id', businessUuid)
        .eq('user_id', uid)
        .eq('status', 'active');

    final now = DateTime.now();
    for (final row in rows as List<dynamic>) {
      if (row is! Map) continue;
      final feature =
          (row['feature_name'] as String?)?.trim().toLowerCase() ?? '';
      final level =
          (row['access_level'] as String?)?.trim().toLowerCase() ?? '';
      final expiresRaw = row['expires_at'];
      DateTime? expires;
      if (expiresRaw is String) {
        expires = DateTime.tryParse(expiresRaw);
      } else if (expiresRaw is DateTime) {
        expires = expiresRaw;
      }
      if (feature == AppFeature.Settings.toLowerCase() &&
          level == AccessLevel.ADMIN.toLowerCase() &&
          (expires == null || expires.isAfter(now))) {
        return true;
      }
    }
  } catch (_) {
    // Offline or Supabase unavailable.
  }

  // Brick/CoreSync fallback when Supabase access query is empty (local cache).
  try {
    final business =
        await ProxyService.getStrategy(Strategy.cloudSync).getBusiness(
      businessId: businessUuid,
    );
    if (business?.userId != null && business!.userId == uid) return true;

    return await ProxyService.getStrategy(Strategy.cloudSync).isAdmin(
      userId: uid,
      appFeature: AppFeature.Settings,
    );
  } catch (_) {
    return false;
  }
}

final canManageAgentCommissionProvider =
    FutureProvider.autoDispose<bool>((ref) async {
  return resolveCanManageAgentCommission();
});

/// Quick-access grid and side menu visibility.
final showAgentCommissionNavProvider = Provider.autoDispose<bool>((ref) {
  final isAgent = ref.watch(isCurrentUserAgentProvider).maybeWhen(
        data: (v) => v,
        orElse: () => false,
      );
  final canManage = ref.watch(canManageAgentCommissionProvider).maybeWhen(
        data: (v) => v,
        orElse: () => false,
      );
  return isAgent || canManage;
});

final sideMenuShowAgentCommissionProvider = showAgentCommissionNavProvider;
