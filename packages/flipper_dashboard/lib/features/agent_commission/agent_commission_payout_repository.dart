import 'package:flipper_dashboard/features/agent_commission/agent_commission_provider.dart';
import 'package:flipper_dashboard/features/agent_commission/models/agent_commission_payout.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/helpers/agent_session_helper.dart';
import 'package:flipper_models/view_models/flipperBaseModel.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const _logTag = '[AgentCommissionPayout]';

class AgentCommissionPayoutException implements Exception {
  AgentCommissionPayoutException(this.message);
  final String message;

  @override
  String toString() => message;
}

class AgentCommissionPayoutRepository {
  AgentCommissionPayoutRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<String?> _resolveBusinessUuid() async {
    final businessId = ProxyService.box.getBusinessId();
    if (businessId == null || businessId.isEmpty) return null;
    return FlipperBaseModel.resolveBusinessUuidForTenants(businessId);
  }

  bool _isMissingTableError(PostgrestException e) {
    final code = e.code ?? '';
    final msg = e.message.toLowerCase();
    return code == '42P01' ||
        msg.contains('agent_commission_payouts') &&
            (msg.contains('does not exist') || msg.contains('not found'));
  }

  Future<List<AgentCommissionPayout>> listPayouts({
    required String agentUserId,
    DateTime? paidOnOrAfter,
    DateTime? paidBefore,
    int limit = 100,
  }) async {
    if (agentUserId.isEmpty) return const [];

    final businessUuid = await _resolveBusinessUuid();
    if (businessUuid == null || businessUuid.isEmpty) return const [];

    try {
      var query = _client
          .from('agent_commission_payouts')
          .select()
          .eq('business_id', businessUuid)
          .eq('agent_user_id', agentUserId);

      if (paidOnOrAfter != null) {
        query = query.gte('paid_at', paidOnOrAfter.toUtc().toIso8601String());
      }
      if (paidBefore != null) {
        query = query.lt('paid_at', paidBefore.toUtc().toIso8601String());
      }

      final rows = await query.order('paid_at', ascending: false).limit(limit);
      return rows
          .map((r) => AgentCommissionPayout.fromSupabaseRow(
                Map<String, dynamic>.from(r as Map),
              ))
          .toList();
    } on PostgrestException catch (e, st) {
      if (_isMissingTableError(e)) {
        talker.warning(
          '$_logTag agent_commission_payouts table missing — apply migration '
          '20260529120000_agent_commission_payouts.sql',
        );
        return const [];
      }
      talker.error('$_logTag listPayouts failed', e, st);
      rethrow;
    }
  }

  Future<num> sumPayoutsForAgent({
    required String agentUserId,
    DateTime? paidOnOrAfter,
    DateTime? paidBefore,
  }) async {
    final payouts = await listPayouts(
      agentUserId: agentUserId,
      paidOnOrAfter: paidOnOrAfter,
      paidBefore: paidBefore,
      limit: 5000,
    );
    return payouts.fold<num>(0, (sum, p) => sum + p.amount);
  }

  Future<AgentCommissionPayout> insertPayout({
    required String agentUserId,
    required num amount,
    String? note,
    AgentCommissionPeriod? period,
  }) async {
    if (amount <= 0) {
      throw AgentCommissionPayoutException('Payout amount must be greater than zero.');
    }

    final businessUuid = await _resolveBusinessUuid();
    if (businessUuid == null || businessUuid.isEmpty) {
      throw AgentCommissionPayoutException('No business selected.');
    }

    final paidBy = await resolveSessionUserId();
    if (paidBy == null || paidBy.isEmpty) {
      throw AgentCommissionPayoutException('Sign in to record a payout.');
    }

    final periodStart = period != null ? periodStartFor(period) : null;
    final now = DateTime.now();

    final payload = <String, dynamic>{
      'business_id': businessUuid,
      'agent_user_id': agentUserId,
      'amount': amount,
      'paid_by_user_id': paidBy,
      'paid_at': now.toUtc().toIso8601String(),
      if (note != null && note.trim().isNotEmpty) 'note': note.trim(),
      if (periodStart != null)
        'period_start': periodStart.toUtc().toIso8601String(),
      'period_end': now.toUtc().toIso8601String(),
    };

    try {
      final row = await _client
          .from('agent_commission_payouts')
          .insert(payload)
          .select()
          .single();
      return AgentCommissionPayout.fromSupabaseRow(
        Map<String, dynamic>.from(row),
      );
    } on PostgrestException catch (e) {
      if (_isMissingTableError(e)) {
        throw AgentCommissionPayoutException(
          'Payout storage is not set up yet. Ask your admin to run the latest '
          'Supabase migration (agent_commission_payouts).',
        );
      }
      throw AgentCommissionPayoutException(
        e.message.isNotEmpty ? e.message : 'Could not record payout.',
      );
    }
  }
}

final agentCommissionPayoutRepositoryProvider =
    Provider<AgentCommissionPayoutRepository>(
  (ref) => AgentCommissionPayoutRepository(),
);
