import 'package:supabase_models/brick/models/transaction.model.dart';

/// A completed sale attributed to the logged-in agent with resolved commission.
class AgentCommissionSale {
  const AgentCommissionSale({
    required this.id,
    this.createdAt,
    this.subTotal,
    this.commissionAmount,
    this.commissionType,
    this.commissionValue,
    this.customerName,
    this.reference,
  });

  final String id;
  final DateTime? createdAt;
  final double? subTotal;
  final num? commissionAmount;
  final String? commissionType;
  final num? commissionValue;
  final String? customerName;
  final String? reference;

  factory AgentCommissionSale.fromTransaction(ITransaction txn) {
    return AgentCommissionSale(
      id: txn.id,
      createdAt: txn.createdAt ?? txn.lastTouched,
      subTotal: txn.subTotal,
      commissionAmount: txn.agentCommissionAmount,
      commissionType: txn.agentCommissionType,
      commissionValue: txn.agentCommissionValue,
      customerName: txn.customerName,
      reference: txn.reference,
    );
  }

  factory AgentCommissionSale.fromSupabaseRow(Map<String, dynamic> row) {
    DateTime? createdAt;
    final rawCreated = row['created_at'];
    if (rawCreated is DateTime) {
      createdAt = rawCreated;
    } else if (rawCreated != null) {
      createdAt = DateTime.tryParse(rawCreated.toString());
    }

    num? parseNum(Object? v) {
      if (v == null) return null;
      if (v is num) return v;
      return num.tryParse(v.toString());
    }

    return AgentCommissionSale(
      id: row['id']?.toString() ?? '',
      createdAt: createdAt,
      subTotal: parseNum(row['sub_total'])?.toDouble(),
      commissionAmount: parseNum(row['agent_commission_amount']),
      commissionType: row['agent_commission_type'] as String?,
      commissionValue: parseNum(row['agent_commission_value']),
      customerName: row['customer_name'] as String?,
      reference: row['reference'] as String?,
    );
  }
}

/// Aggregated commission totals for the selected period.
class AgentCommissionSummary {
  const AgentCommissionSummary({
    required this.sales,
    this.businessName,
    this.agentName,
  });

  final List<AgentCommissionSale> sales;
  final String? businessName;
  final String? agentName;

  int get saleCount => sales.length;

  num get totalCommission => sales.fold<num>(
        0,
        (sum, s) => sum + (s.commissionAmount ?? 0),
      );

  num get totalSales => sales.fold<num>(
        0,
        (sum, s) => sum + (s.subTotal ?? 0),
      );
}
