import 'package:flipper_dashboard/features/agent_commission/models/agent_commission_sale.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';

void main() {
  test('AgentCommissionSale.fromTransaction maps commission fields', () {
    final sale = AgentCommissionSale.fromTransaction(
      ITransaction(
        id: 'tx-1',
        branchId: 'branch-1',
        agentId: 'cashier',
        status: 'completed',
        transactionType: 'sale',
        paymentType: 'Cash',
        cashReceived: 1000,
        customerChangeDue: 0,
        createdAt: DateTime.parse('2026-05-18T10:00:00Z'),
        updatedAt: DateTime.parse('2026-05-18T10:00:00Z'),
        isIncome: true,
        isExpense: false,
        subTotal: 1000,
        agentCommissionAmount: 50,
        agentCommissionType: 'percent',
        agentCommissionValue: 5,
        customerName: 'Jane',
        reference: 'abc123',
      ),
    );

    expect(sale.id, 'tx-1');
    expect(sale.commissionAmount, 50);
    expect(sale.commissionType, 'percent');
    expect(sale.customerName, 'Jane');
    expect(sale.subTotal, 1000);
  });

  test('AgentCommissionSale.fromSupabaseRow maps commission fields', () {
    final sale = AgentCommissionSale.fromSupabaseRow({
      'id': 'tx-1',
      'created_at': '2026-05-18T10:00:00Z',
      'sub_total': 1000,
      'agent_commission_amount': 50,
      'agent_commission_type': 'percent',
      'agent_commission_value': 5,
      'customer_name': 'Jane',
      'reference': 'abc123',
    });

    expect(sale.id, 'tx-1');
    expect(sale.commissionAmount, 50);
    expect(sale.commissionType, 'percent');
    expect(sale.customerName, 'Jane');
    expect(sale.subTotal, 1000);
  });

  test('AgentCommissionSummary totals commission', () {
    const summary = AgentCommissionSummary(
      sales: [
        AgentCommissionSale(id: 'a', commissionAmount: 100),
        AgentCommissionSale(id: 'b', commissionAmount: 250, subTotal: 5000),
      ],
    );
    expect(summary.saleCount, 2);
    expect(summary.totalCommission, 350);
    expect(summary.totalSales, 5000);
  });
}
