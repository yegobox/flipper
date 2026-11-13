import 'package:flipper_accounting/chart_account_resolver.dart';
import 'package:flipper_accounting/default_chart_of_accounts_seed.dart';
import 'package:flipper_accounting/purchase_journal_poster.dart';
import 'package:flipper_accounting/purchase_posting_input.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/in_memory_accounting_store.dart';

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

  group('PurchaseJournalPoster VAT', () {
    const biz = 'biz';
    PurchasePostingInput purchase({required bool capitalizeVat}) =>
        PurchasePostingInput(
          purchaseId: 'p1',
          supplierName: 'Vendor',
          invoiceNo: 42,
          pmtTyCd: '01',
          totAmt: 118000,
          totTaxAmt: 18000,
          purchaseDate: DateTime(2026, 11, 1),
          capitalizeVat: capitalizeVat,
          lines: const [
            PurchasePostingLine(description: 'Rice', qty: 4, unitPrice: 29500),
          ],
        );
    final je = PurchaseJournalPoster.entryId(biz, 'p1');

    Future<InMemoryAccountingStore> post(PurchasePostingInput p) async {
      final store = InMemoryAccountingStore();
      await PurchaseJournalPoster(store).postPurchaseRecorded(
        businessId: biz,
        purchase: p,
        accounts: defaultChartOfAccountsSeed,
      );
      return store;
    }

    test('registered business reclaims VAT through 2100, as before', () async {
      final store = await post(purchase(capitalizeVat: false));
      expect(
        store.linesOf(je),
        unorderedEquals([
          ('1200', 100000, 0),
          ('2100', 18000, 0),
          ('1010', 0, 118000),
        ]),
      );
    });

    test(
      'business not registered for VAT puts the VAT into stock cost',
      () async {
        final store = await post(purchase(capitalizeVat: true));
        expect(
          store.linesOf(je),
          unorderedEquals([('1200', 118000, 0), ('1010', 0, 118000)]),
        );
        expect(store.creditBalance('2100'), 0);
        // The VAT on the invoice is still recorded on the bill.
        final bill = store.doc(
          'accounting_documents',
          PurchaseJournalPoster.billDocId(biz, 'p1'),
        )!;
        expect(bill['vat_paid'], 18000);
      },
    );

    test(
      'capitalized purchase posts even when the chart has no 2100',
      () async {
        final store = InMemoryAccountingStore();
        await PurchaseJournalPoster(store).postPurchaseRecorded(
          businessId: biz,
          purchase: purchase(capitalizeVat: true),
          accounts: [
            for (final a in defaultChartOfAccountsSeed)
              if (a.code != '2100') a,
          ],
        );
        expect(store.linesOf(je), contains(('1200', 118000, 0)));
      },
    );
  });
}
