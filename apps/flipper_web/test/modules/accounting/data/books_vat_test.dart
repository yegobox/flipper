import 'package:flipper_web/modules/accounting/data/accounting_document_poster.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_v3_models.dart';
import 'package:flipper_web/modules/accounting/data/services/vat_position_service.dart';
import 'package:flipper_web/modules/accounting/data/default_chart_of_accounts_seed.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_accounting_ledger_repository.dart';

void main() {
  group('BooksVatPosition', () {
    test('not registered: estimate and threshold', () {
      final p = BooksVatPosition.fromJson({
        'registered': false,
        'hasEbmBranch': false,
        'settingRegistered': false,
        'annualThreshold': 20000000,
        'quarterThreshold': 5000000,
        'position': {
          'registered': false,
          'vatOwed': 0,
          'monthEstimatedOutputVat': 180000,
          'monthPurchaseVat': 90000,
          'turnover12m': 17000000,
          'turnoverQuarter': 2000000,
          'threshold': 'near',
        },
      });
      expect(p.vatIsCost, isTrue);
      expect(p.hasEstimate, isTrue);
      expect(p.threshold, VatThreshold.near);
      expect(p.monthEstimatedOutputVat, 180000);
    });

    test('registered through EBM; estimate unavailable', () {
      final p = BooksVatPosition.fromJson({
        'registered': true,
        'hasEbmBranch': true,
        'settingRegistered': false,
        'position': null,
      });
      expect(p.vatIsCost, isFalse);
      expect(p.hasEstimate, isFalse);
      expect(p.threshold, VatThreshold.none);
    });
  });

  group('DocumentJournalPoster.postBillRecorded', () {
    const bill = AccountingDocument(
      id: 'BILL-7',
      who: 'Kigali Wholesale',
      date: '1 Nov 2026',
      due: '30 Nov 2026',
      status: DocStatus.sent,
      lines: [DocLine(desc: 'Rice', qty: 2, price: 10000)],
    );

    Future<List<JournalLine>> post({
      required bool capitalizeVat,
      List<Account> chart = defaultChartOfAccountsSeed,
    }) async {
      final repo = FakeAccountingLedgerRepository();
      await DocumentJournalPoster(repo, chart).postBillRecorded(
        businessId: 'biz',
        doc: bill,
        capitalizeVat: capitalizeVat,
      );
      return repo.entries.isEmpty ? const [] : repo.entries.single.lines;
    }

    final withoutVatAccount = [
      for (final a in defaultChartOfAccountsSeed)
        if (a.code != '2100') a,
    ];

    int dr(List<JournalLine> lines, String ac) =>
        lines.where((l) => l.ac == ac).fold(0, (s, l) => s + l.dr);

    test('registered business reclaims the VAT, as before', () async {
      final lines = await post(capitalizeVat: false);
      expect(dr(lines, '1200'), 20000);
      expect(dr(lines, '2100'), 3600);
    });

    test(
      'no VAT Payable account: nothing posts while VAT is reclaimable',
      () async {
        expect(
          await post(capitalizeVat: false, chart: withoutVatAccount),
          isEmpty,
        );
      },
    );

    test('no VAT Payable account is fine when the VAT is stock cost', () async {
      final lines = await post(capitalizeVat: true, chart: withoutVatAccount);
      expect(dr(lines, '1200'), 23600);
    });

    test('business not registered for VAT carries it as stock', () async {
      final lines = await post(capitalizeVat: true);
      expect(dr(lines, '1200'), 23600);
      expect(lines.where((l) => l.ac == '2100'), isEmpty);
      final debits = lines.fold(0, (s, l) => s + l.dr);
      final credits = lines.fold(0, (s, l) => s + l.cr);
      expect(debits, credits);
    });
  });
}
