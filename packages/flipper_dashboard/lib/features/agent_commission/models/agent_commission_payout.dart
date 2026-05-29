/// Lump-sum payout recorded by business owner / Settings admin.
class AgentCommissionPayout {
  const AgentCommissionPayout({
    required this.id,
    required this.businessId,
    required this.agentUserId,
    required this.amount,
    required this.paidAt,
    required this.paidByUserId,
    this.periodStart,
    this.periodEnd,
    this.note,
    this.createdAt,
  });

  final String id;
  final String businessId;
  final String agentUserId;
  final num amount;
  final DateTime paidAt;
  final String paidByUserId;
  final DateTime? periodStart;
  final DateTime? periodEnd;
  final String? note;
  final DateTime? createdAt;

  factory AgentCommissionPayout.fromSupabaseRow(Map<String, dynamic> row) {
    DateTime? parseTs(Object? v) {
      if (v == null) return null;
      if (v is DateTime) return v;
      return DateTime.tryParse(v.toString());
    }

    num parseNum(Object? v) {
      if (v is num) return v;
      return num.tryParse(v?.toString() ?? '') ?? 0;
    }

    return AgentCommissionPayout(
      id: row['id']?.toString() ?? '',
      businessId: row['business_id']?.toString() ?? '',
      agentUserId: row['agent_user_id']?.toString() ?? '',
      amount: parseNum(row['amount']),
      paidAt: parseTs(row['paid_at']) ?? DateTime.now(),
      paidByUserId: row['paid_by_user_id']?.toString() ?? '',
      periodStart: parseTs(row['period_start']),
      periodEnd: parseTs(row['period_end']),
      note: row['note'] as String?,
      createdAt: parseTs(row['created_at']),
    );
  }
}

/// Earned commission minus payouts in the selected period.
class AgentCommissionBalance {
  const AgentCommissionBalance({
    required this.earned,
    required this.paid,
  });

  final num earned;
  final num paid;

  num get balance {
    final raw = earned - paid;
    return raw < 0 ? 0 : raw;
  }
}
