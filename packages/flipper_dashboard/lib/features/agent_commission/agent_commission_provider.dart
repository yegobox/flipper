import 'package:flipper_dashboard/features/agent_commission/models/agent_commission_sale.dart';
import 'package:flipper_dashboard/utils/sale_agent_commission.dart';
import 'package:flipper_models/helpers/agent_session_helper.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/view_models/flipperBaseModel.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
const _logTag = '[AgentCommission]';

enum AgentCommissionPeriod { today, week, month, all }

class AgentCommissionPeriodNotifier extends Notifier<AgentCommissionPeriod> {
  @override
  AgentCommissionPeriod build() => AgentCommissionPeriod.month;

  void setPeriod(AgentCommissionPeriod period) => state = period;
}

final agentCommissionPeriodProvider =
    NotifierProvider<AgentCommissionPeriodNotifier, AgentCommissionPeriod>(
      AgentCommissionPeriodNotifier.new,
    );

final agentCommissionSummaryProvider =
    FutureProvider.autoDispose<AgentCommissionSummary>((ref) async {
      final period = ref.watch(agentCommissionPeriodProvider);
      return fetchAgentCommissionSummary(period: period);
    });

DateTime? periodStartFor(AgentCommissionPeriod period) {
  final now = DateTime.now();
  switch (period) {
    case AgentCommissionPeriod.today:
      return DateTime(now.year, now.month, now.day);
    case AgentCommissionPeriod.week:
      return now.subtract(const Duration(days: 7));
    case AgentCommissionPeriod.month:
      return now.subtract(const Duration(days: 30));
    case AgentCommissionPeriod.all:
      return null;
  }
}

/// Completed attributed sales with commission for [agentUserId] in [period].
Future<List<AgentCommissionSale>> fetchCommissionSalesForAgent({
  required String agentUserId,
  required AgentCommissionPeriod period,
}) async {
  if (agentUserId.isEmpty) return const [];

  final periodStart = periodStartFor(period);
  final capella = ProxyService.getStrategy(Strategy.capella);

  talker.info(
    '$_logTag fetch sales agentUserId=$agentUserId period=$period '
    'startDate=${periodStart?.toIso8601String() ?? 'none'}',
  );

  final transactions = await capella.transactions(
    status: COMPLETE,
    attributedAgentUserId: agentUserId,
    startDate: periodStart,
    filterPeriodByCreatedAt: true,
    fetchRemote: true,
  );

  final withCommission = transactions
      .where((t) => (t.agentCommissionAmount ?? 0) > 0)
      .toList();

  final sales =
      withCommission.map(AgentCommissionSale.fromTransaction).toList()
        ..sort((a, b) {
          final aTime = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bTime = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          return bTime.compareTo(aTime);
        });

  if (sales.length > 500) {
    sales.removeRange(500, sales.length);
  }

  return sales;
}

Future<AgentCommissionSummary> fetchAgentCommissionSummary({
  required AgentCommissionPeriod period,
}) async {
  final userId = await resolveSessionUserId();
  final businessId = ProxyService.box.getBusinessId();
  final sessionBranchId = ProxyService.box.getBranchId();
  final periodStart = periodStartFor(period);

  talker.info(
    '$_logTag fetch start period=$period periodStart=${periodStart?.toIso8601String() ?? 'all'} '
    'userId=$userId businessId=$businessId sessionBranchId=$sessionBranchId '
    '(commission query ignores session branch — all attributed sales)',
  );

  if (userId == null || userId.isEmpty) {
    talker.warning('$_logTag abort: no logged-in userId in box');
    return const AgentCommissionSummary(sales: []);
  }

  String? businessName;
  String? agentName;

  try {
    if (businessId != null && businessId.isNotEmpty) {
      final agents = await FlipperBaseModel.fetchAgentTenantsFromSupabase(
        businessId: businessId,
      );
      for (final tenant in agents) {
        if (tenant.userId == userId) {
          agentName = tenantDisplayName(tenant);
          break;
        }
      }

      final businessUuid = await FlipperBaseModel.resolveBusinessUuidForTenants(
        businessId,
      );
      if (businessUuid != null && businessUuid.isNotEmpty) {
        try {
          final business =
              await ProxyService.strategy.getBusiness(businessId: businessUuid);
          businessName = business?.name;
        } catch (e) {
          talker.warning('$_logTag capella.getBusiness failed: $e');
          final bizRow = await Supabase.instance.client
              .from('businesses')
              .select('name')
              .eq('id', businessUuid)
              .maybeSingle();
          businessName = bizRow?['name'] as String?;
        }
      }
    }

    final sales = await fetchCommissionSalesForAgent(
      agentUserId: userId,
      period: period,
    );

    if (sales.isEmpty) {
      talker.warning(
        '$_logTag no commissioned sales for userId=$userId in period',
      );
    }

    talker.info(
      '$_logTag done: ${sales.length} sale(s), '
      'totalCommission=${sales.fold<num>(0, (s, x) => s + (x.commissionAmount ?? 0))}',
    );

    return AgentCommissionSummary(
      sales: sales,
      businessName: businessName,
      agentName: agentName,
    );
  } catch (e, st) {
    talker.error('$_logTag fetch failed', e, st);
    return AgentCommissionSummary(
      sales: const [],
      businessName: businessName,
      agentName: agentName,
    );
  }
}
