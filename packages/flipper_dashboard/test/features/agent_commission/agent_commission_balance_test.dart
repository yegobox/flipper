import 'package:flipper_dashboard/features/agent_commission/models/agent_commission_payout.dart';
import 'package:flipper_dashboard/features/agent_commission/models/agent_commission_sale.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AgentCommissionBalance', () {
    test('balance is earned minus paid floored at zero', () {
      const balance = AgentCommissionBalance(earned: 1000, paid: 300);
      expect(balance.balance, 700);
    });

    test('balance does not go negative when overpaid', () {
      const balance = AgentCommissionBalance(earned: 500, paid: 800);
      expect(balance.balance, 0);
    });
  });

  group('AgentCommissionPayout.fromSupabaseRow', () {
    test('parses payout fields', () {
      final payout = AgentCommissionPayout.fromSupabaseRow({
        'id': 'p1',
        'business_id': 'b1',
        'agent_user_id': 'agent-1',
        'amount': 2500,
        'paid_at': '2026-05-01T10:00:00Z',
        'paid_by_user_id': 'owner-1',
        'note': 'May payout',
        'created_at': '2026-05-01T10:00:01Z',
      });

      expect(payout.id, 'p1');
      expect(payout.agentUserId, 'agent-1');
      expect(payout.amount, 2500);
      expect(payout.note, 'May payout');
      expect(payout.paidByUserId, 'owner-1');
    });
  });

  group('AgentCommissionSummary totals', () {
    test('totalCommission sums sale amounts', () {
      const summary = AgentCommissionSummary(
        sales: [
          AgentCommissionSale(id: 'a', commissionAmount: 100),
          AgentCommissionSale(id: 'b', commissionAmount: 250),
        ],
      );
      expect(summary.totalCommission, 350);
      expect(summary.saleCount, 2);
    });
  });
}
