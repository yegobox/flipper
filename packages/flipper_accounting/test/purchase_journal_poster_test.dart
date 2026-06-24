import 'package:flipper_accounting/accounting_models.dart';
import 'package:flipper_accounting/chart_account_resolver.dart';
import 'package:flipper_accounting/default_chart_of_accounts_seed.dart';
import 'package:flipper_accounting/purchase_posting_input.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChartAccountResolver purchase credit', () {
    final roles = ChartAccountResolver(defaultChartOfAccountsSeed);

    test('cash purchase credits cash account', () {
      expect(roles.purchaseCreditAccount('01'), '1010');
    });

    test('credit purchase credits AP', () {
      expect(roles.purchaseCreditAccount('02'), '2010');
    });

    test('mobile money credits momo account', () {
      expect(roles.purchaseCreditAccount('06'), '1030');
    });
  });

  group('PurchasePostingInput amounts', () {
    test('derives net, vat, total from inclusive purchase', () {
      const input = PurchasePostingInput(
        purchaseId: 'p1',
        supplierName: 'Vendor',
        invoiceNo: 42,
        pmtTyCd: '01',
        totAmt: 118000,
        totTaxAmt: 18000,
        lines: [],
      );
      expect(input.netInventory, 100000);
      expect(input.vat, 18000);
      expect(input.total, 118000);
    });
  });
}
