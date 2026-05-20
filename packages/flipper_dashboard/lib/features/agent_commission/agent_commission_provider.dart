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
import 'package:supabase_models/brick/models/transaction.model.dart';

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

DateTime? _periodStart(AgentCommissionPeriod period) {
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

void _logTxnSample(String label, List<ITransaction> txns, {int max = 5}) {
  if (txns.isEmpty) return;
  final samples = txns.take(max).map((t) {
    return 'id=${t.id} status=${t.status} branchId=${t.branchId} '
        'attributedAgentUserId=${t.attributedAgentUserId} '
        'agentCommissionAmount=${t.agentCommissionAmount} '
        'agentCommissionType=${t.agentCommissionType} '
        'agentCommissionValue=${t.agentCommissionValue} '
        'lastTouched=${t.lastTouched?.toIso8601String()} '
        'createdAt=${t.createdAt?.toIso8601String()}';
  });
  talker.info(
    '$_logTag $label (${txns.length} total, showing ≤$max):\n'
    '${samples.join('\n')}',
  );
}

Future<AgentCommissionSummary> fetchAgentCommissionSummary({
  required AgentCommissionPeriod period,
}) async {
  final userId = await resolveSessionUserId();
  final businessId = ProxyService.box.getBusinessId();
  final sessionBranchId = ProxyService.box.getBranchId();
  final periodStart = _periodStart(period);

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

  final capella = ProxyService.getStrategy(Strategy.capella);

  try {
    if (businessId != null && businessId.isNotEmpty) {
      final agents = await FlipperBaseModel.fetchAgentTenantsFromSupabase(
        businessId: businessId,
      );
      talker.info(
        '$_logTag agents from Supabase: count=${agents.length} '
        'userIds=${agents.map((t) => t.userId).whereType<String>().take(10).join(', ')}',
      );
      for (final tenant in agents) {
        if (tenant.userId == userId) {
          agentName = tenantDisplayName(tenant);
          break;
        }
      }
      if (agentName == null) {
        talker.warning(
          '$_logTag no agent tenant matched userId=$userId '
          '(display name will be missing)',
        );
      } else {
        talker.info('$_logTag matched agent display name: $agentName');
      }

      final businessUuid = await FlipperBaseModel.resolveBusinessUuidForTenants(
        businessId,
      );
      talker.info(
        '$_logTag businessUuid=$businessUuid (from box businessId=$businessId)',
      );
      if (businessUuid != null && businessUuid.isNotEmpty) {
        try {
          final business = await ProxyService.strategy.getBusiness(businessId: businessUuid);
          businessName = business?.name;
          talker.info('$_logTag business name from default strategy: $businessName');
        } catch (e) {
          talker.warning('$_logTag capella.getBusiness failed: $e');
          final bizRow = await Supabase.instance.client
              .from('businesses')
              .select('name')
              .eq('id', businessUuid)
              .maybeSingle();
          businessName = bizRow?['name'] as String?;
          talker.info(
            '$_logTag business name from Supabase fallback: $businessName',
          );
        }
      }
    } else {
      talker.warning(
        '$_logTag no businessId in box — skipping agent/business lookup',
      );
    }

    talker.info(
      '$_logTag querying Ditto transactions status=$COMPLETE '
      'attributedAgentUserId=$userId '
      'startDate=${periodStart?.toIso8601String() ?? 'none'}',
    );

    final transactions = await capella.transactions(
      status: COMPLETE,
      attributedAgentUserId: userId,
      startDate: periodStart,
      filterPeriodByCreatedAt: true,
    );

    talker.info(
      '$_logTag Ditto returned ${transactions.length} completed txn(s)',
    );

    final withCommission = transactions
        .where((t) => (t.agentCommissionAmount ?? 0) > 0)
        .toList();
    final zeroCommission = transactions
        .where((t) => (t.agentCommissionAmount ?? 0) <= 0)
        .toList();

    talker.info(
      '$_logTag filter breakdown: withCommission=${withCommission.length} '
      'zeroOrNullCommission=${zeroCommission.length}',
    );

    if (transactions.isEmpty) {
      talker.warning(
        '$_logTag no transactions — check: (1) sales completed in Ditto, '
        '(2) attributedAgentUserId on txn matches userId=$userId, '
        '(3) createdAt within period '
        '${periodStart?.toIso8601String() ?? 'all time'}',
      );
    } else if (withCommission.isEmpty) {
      talker.warning(
        '$_logTag ${transactions.length} txn(s) attributed to agent but none have '
        'agentCommissionAmount > 0 — commission may not be finalized at sale completion',
      );
      _logTxnSample('zero-commission samples', zeroCommission);
    } else {
      _logTxnSample('with-commission samples', withCommission);
    }

    final sales =
        withCommission.map(AgentCommissionSale.fromTransaction).toList()
          ..sort((a, b) {
            final aTime = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            final bTime = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            return bTime.compareTo(aTime);
          });

    if (sales.length > 500) {
      talker.info('$_logTag capping sales list from ${sales.length} to 500');
      sales.removeRange(500, sales.length);
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
