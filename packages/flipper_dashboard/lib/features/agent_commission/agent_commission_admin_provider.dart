import 'package:flipper_dashboard/features/agent_commission/agent_commission_provider.dart';
import 'package:flipper_dashboard/features/agent_commission/agent_commission_payout_repository.dart';
import 'package:flipper_dashboard/features/agent_commission/models/agent_commission_payout.dart';
import 'package:flipper_dashboard/features/agent_commission/models/agent_commission_sale.dart';
import 'package:flipper_dashboard/providers/agent_commission_access_provider.dart';
import 'package:flipper_dashboard/providers/business_agents_provider.dart';
import 'package:flipper_dashboard/utils/sale_agent_commission.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/view_models/flipperBaseModel.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';

const _logTag = '[AgentCommissionAdmin]';

/// Selected agent for owner/admin commission view (null → first agent).
final selectedCommissionAgentIdProvider = StateProvider<String?>((ref) => null);

class AgentCommissionAdminSummary {
  const AgentCommissionAdminSummary({
    required this.summary,
    required this.balance,
    required this.payouts,
    required this.agentUserId,
    this.payoutsUnavailable = false,
  });

  final AgentCommissionSummary summary;
  final AgentCommissionBalance balance;
  final List<AgentCommissionPayout> payouts;
  final String agentUserId;
  final bool payoutsUnavailable;
}

final agentCommissionAdminSummaryProvider =
    FutureProvider.autoDispose<AgentCommissionAdminSummary?>((ref) async {
  final canManage = await resolveCanManageAgentCommission();
  if (!canManage) return null;

  final period = ref.watch(agentCommissionPeriodProvider);
  final selectedAgentId = ref.watch(selectedCommissionAgentIdProvider);

  final agents = await ref.watch(businessAgentsProvider.future);
  if (agents.isEmpty) {
    return const AgentCommissionAdminSummary(
      summary: AgentCommissionSummary(sales: []),
      balance: AgentCommissionBalance(earned: 0, paid: 0),
      payouts: [],
      agentUserId: '',
    );
  }

  var agentUserId = selectedAgentId ?? agents.first.userId ?? '';
  if (!agents.any((t) => t.userId == agentUserId)) {
    agentUserId = agents.first.userId ?? '';
  }

  if (agentUserId.isEmpty) {
    talker.warning('$_logTag agents exist but none have userId');
    return const AgentCommissionAdminSummary(
      summary: AgentCommissionSummary(sales: []),
      balance: AgentCommissionBalance(earned: 0, paid: 0),
      payouts: [],
      agentUserId: '',
    );
  }

  final periodStart = periodStartFor(period);
  final repo = ref.watch(agentCommissionPayoutRepositoryProvider);

  List<AgentCommissionSale> sales;
  try {
    sales = await fetchCommissionSalesForAgent(
      agentUserId: agentUserId,
      period: period,
    );
  } catch (e, st) {
    talker.error('$_logTag fetchCommissionSalesForAgent failed', e, st);
    rethrow;
  }

  String? agentName;
  for (final tenant in agents) {
    if (tenant.userId == agentUserId) {
      agentName = tenantDisplayName(tenant);
      break;
    }
  }

  String? businessName;
  final businessId = agents.first.businessId ?? ProxyService.box.getBusinessId();
  if (businessId != null && businessId.isNotEmpty) {
    try {
      final businessUuid =
          await FlipperBaseModel.resolveBusinessUuidForTenants(businessId);
      if (businessUuid != null) {
        final business = await ProxyService.getStrategy(Strategy.cloudSync)
            .getBusiness(businessId: businessUuid);
        businessName = business?.name;
      }
    } catch (_) {
      // Optional display field.
    }
  }

  final summary = AgentCommissionSummary(
    sales: sales,
    businessName: businessName,
    agentName: agentName,
  );

  final earned = summary.totalCommission;
  var paid = 0.0;
  var payouts = <AgentCommissionPayout>[];
  var payoutsUnavailable = false;

  try {
    paid = (await repo.sumPayoutsForAgent(
      agentUserId: agentUserId,
      paidOnOrAfter: periodStart,
    ))
        .toDouble();
    payouts = await repo.listPayouts(
      agentUserId: agentUserId,
      paidOnOrAfter: periodStart,
      limit: 50,
    );
  } catch (e, st) {
    talker.error('$_logTag payout fetch failed', e, st);
    payoutsUnavailable = true;
  }

  return AgentCommissionAdminSummary(
    summary: summary,
    balance: AgentCommissionBalance(earned: earned, paid: paid),
    payouts: payouts,
    agentUserId: agentUserId,
    payoutsUnavailable: payoutsUnavailable,
  );
});

/// Resolves agent list for the admin picker.
final commissionAgentPickerProvider =
    FutureProvider.autoDispose<List<Tenant>>((ref) async {
  return ref.watch(businessAgentsProvider.future);
});
