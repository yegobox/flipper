import 'package:flipper_web/modules/accounting/data/accounting_document_poster.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_v3_models.dart';
import 'package:flipper_web/modules/accounting/data/services/vat_position_service.dart';
import 'package:flipper_web/modules/accounting/data/default_chart_of_accounts_seed.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../../../helpers/fake_accounting_ditto_store.dart';
import '../../../helpers/fake_accounting_ledger_repository.dart';

/// Ditto holding only Books' accounting settings document.
class _SettingsDitto extends FakeAccountingDittoStore {
  _SettingsDitto({this.vatRegistered});

  final bool? vatRegistered;

  @override
  Future<List<Map<String, dynamic>>> queryCollection(
    String collection,
    String query,
    Map<String, dynamic> args,
  ) async => [
    if (vatRegistered != null) {'vatRegistered': vatRegistered},
  ];
}

/// The connector's business-wide answer, or a failure.
class _Positions extends VatPositionService {
  _Positions({this.hasEbmBranch, this.error})
    : super(client: MockClient((_) async => http.Response('', 500)));

  final bool? hasEbmBranch;
  final Object? error;

  @override
  Future<BooksVatPosition?> position() async {
    if (error != null) throw error!;
    final ebm = hasEbmBranch;
    if (ebm == null) return null;
    return BooksVatPosition(
      registered: ebm,
      hasEbmBranch: ebm,
      settingRegistered: false,
    );
  }
}

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

  group('purchaseVatIsCost (POS purchases)', () {
    Future<bool> isCost(_Positions positions, {bool? vatRegistered}) =>
        purchaseVatIsCost(
          ditto: _SettingsDitto(vatRegistered: vatRegistered),
          businessId: 'biz',
          positions: positions,
        );

    test('another branch has EBM with VAT on: VAT to 2100', () async {
      // The selected branch may have no EBM; the business is registered.
      expect(await isCost(_Positions(hasEbmBranch: true)), isFalse);
    });

    test('no EBM branch and not registered in Books: capitalized', () async {
      expect(await isCost(_Positions(hasEbmBranch: false)), isTrue);
    });

    test('no EBM branch but registered in Books: VAT to 2100', () async {
      expect(
        await isCost(_Positions(hasEbmBranch: false), vatRegistered: true),
        isFalse,
      );
    });

    test('position unreadable: VAT stays on 2100', () async {
      expect(await isCost(_Positions()), isFalse);
    });

    test('connector failure: VAT stays on 2100', () async {
      expect(await isCost(_Positions(error: Exception('offline'))), isFalse);
    });
  });
}
