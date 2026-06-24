import 'package:flipper_dashboard/utils/sale_agent_commission.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('agentCommissionNetBase', () {
    test('uses pre-tax subtotal when tax is separate', () {
      expect(
        agentCommissionNetBase(subTotal: 1000, taxAmount: 180),
        1000,
      );
    });
  });

  group('resolveAgentCommissionAmount', () {
    test('fixed returns value', () {
      expect(
        resolveAgentCommissionAmount(
          commissionType: 'fixed',
          commissionValue: 500,
          commissionBase: 10000,
        ),
        500,
      );
    });

    test('percent computes from net base after tax', () {
      expect(
        resolveAgentCommissionAmount(
          commissionType: 'percent',
          commissionValue: 10,
          commissionBase: 1000,
        ),
        100,
      );
    });

    test('percent returns null when base is zero', () {
      expect(
        resolveAgentCommissionAmount(
          commissionType: 'percent',
          commissionValue: 10,
          commissionBase: 0,
        ),
        isNull,
      );
    });
  });

  group('finalizeAgentCommissionAmount', () {
    ITransaction minimalTxn({
      String? attributedAgentUserId,
      String? agentCommissionType,
      num? agentCommissionValue,
      num? agentCommissionAmount,
    }) {
      return ITransaction(
        id: 't1',
        branchId: 'branch-1',
        agentId: 'cashier-1',
        status: 'pending',
        transactionType: 'sale',
        paymentType: 'Cash',
        cashReceived: 0,
        customerChangeDue: 0,
        updatedAt: DateTime.now(),
        isIncome: true,
        isExpense: false,
        attributedAgentUserId: attributedAgentUserId,
        agentCommissionType: agentCommissionType,
        agentCommissionValue: agentCommissionValue,
        agentCommissionAmount: agentCommissionAmount,
      );
    }

    test('percent resolves on net subtotal excluding tax', () {
      final txn = minimalTxn(
        attributedAgentUserId: 'agent-uid',
        agentCommissionType: 'percent',
        agentCommissionValue: 5,
      );
      finalizeAgentCommissionAmount(
        target: txn,
        subTotal: 2000,
        taxAmount: 360,
      );
      expect(txn.agentCommissionAmount, 100);
    });

    test('merge restores attribution from ditto row', () {
      final target = minimalTxn();
      final source = minimalTxn(
        attributedAgentUserId: 'u1',
        agentCommissionType: 'fixed',
        agentCommissionValue: 250,
        agentCommissionAmount: 250,
      );
      mergeAgentAttributionOnto(target, source);
      expect(target.attributedAgentUserId, 'u1');
      expect(target.agentCommissionAmount, 250);
    });
  });

  group('formatSaleAgentCommissionLabel', () {
    test('formats percent with resolved amount', () {
      expect(
        formatSaleAgentCommissionLabel(
          commissionType: 'percent',
          commissionValue: 5,
          resolvedAmount: 250,
        ),
        '5% (RWF 250)',
      );
    });
  });
}
