import 'package:flipper_dashboard/utils/sale_agent_commission.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/flipperBaseModel.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Agent tenants for the logged-in business (Supabase, same as User Management).
final businessAgentsProvider =
    FutureProvider.autoDispose<List<Tenant>>((ref) async {
  return FlipperBaseModel.fetchAgentTenantsFromSupabase();
});

/// Resolve display name for an attributed agent user id.
final attributedAgentNameProvider = FutureProvider.autoDispose
    .family<String?, String>((ref, userId) async {
  if (userId.trim().isEmpty) return null;
  final agents = await ref.watch(businessAgentsProvider.future);
  for (final t in agents) {
    if (t.userId == userId) {
      return tenantDisplayName(t);
    }
  }
  return null;
});
