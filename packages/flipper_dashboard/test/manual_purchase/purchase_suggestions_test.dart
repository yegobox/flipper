import 'package:flipper_dashboard/manual_purchase/purchase_suggestions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/all_models.dart';

InvoiceRecord _r(
  String name,
  int no, {
  String tin = '',
  bool recorded = true,
}) => (name: name, tin: tin, invoiceNo: no, recorded: recorded);

Purchase _p(String name, String tin, int invoice, {String reg = 'A'}) =>
    Purchase(
      spplrTin: tin,
      spplrNm: name,
      spplrBhfId: '00',
      spplrInvcNo: invoice,
      rcptTyCd: 'P',
      pmtTyCd: '01',
      cfmDt: '',
      salesDt: '',
      totItemCnt: 0,
      taxblAmtA: 0,
      taxblAmtB: 0,
      taxblAmtC: 0,
      taxblAmtD: 0,
      taxRtA: 0,
      taxRtB: 18,
      taxRtC: 0,
      taxRtD: 0,
      taxAmtA: 0,
      taxAmtB: 0,
      taxAmtC: 0,
      taxAmtD: 0,
      totTaxblAmt: 0,
      totTaxAmt: 0,
      totAmt: 0,
      regTyCd: reg,
      createdAt: DateTime(2026),
    );

void main() {
  group('suggestNextInvoiceNo', () {
    test('starts at 1 with no history', () {
      expect(suggestNextInvoiceNo(const []), 1);
    });

    test('follows the chosen supplier by TIN, ignoring name spelling', () {
      final next = suggestNextInvoiceNo(
        [
          _r('Kigali Wholesale', 40, tin: '100200300'),
          _r('KIGALI wholesale ltd', 41, tin: '100-200-300', recorded: false),
          _r('Other', 900),
        ],
        supplierName: 'Kigali Wholesale',
        supplierTin: '100200300',
      );
      expect(next, 42);
    });

    test('matches by name when either side has no TIN', () {
      final next = suggestNextInvoiceNo([
        _r('  Rice  Mill ', 7),
        _r('Other', 50),
      ], supplierName: 'rice mill');
      expect(next, 8);
    });

    test('new supplier continues the last recorded invoice', () {
      final next = suggestNextInvoiceNo([
        _r('A', 12),
        _r('B', 15),
      ], supplierName: 'Brand new');
      expect(next, 16);
    });

    test('RRA invoices of other suppliers never set the fallback', () {
      final next = suggestNextInvoiceNo([
        _r('A', 12),
        _r('KAPP', 11325737, recorded: false),
      ], supplierName: 'Brand new');
      expect(next, 13);
    });

    test('ignores zero and negative invoice numbers', () {
      expect(suggestNextInvoiceNo([_r('A', 0), _r('A', -4)]), 1);
    });
  });

  group('mergeSupplierOptions', () {
    test('saved suppliers come with their id; invoice-only ones without', () {
      final options = mergeSupplierOptions(
        saved: [Supplier(id: 's1', custNm: 'Kigali Wholesale', custTin: '')],
        purchases: [_p('DAPA Analytics Ltd', '123456789', 666)],
      );
      expect(options.map((o) => o.name), [
        'DAPA Analytics Ltd',
        'Kigali Wholesale',
      ]);
      expect(
        options.firstWhere((o) => o.name.startsWith('DAPA')).isSaved,
        isFalse,
      );
      expect(
        options.firstWhere((o) => o.name.startsWith('Kigali')).savedId,
        's1',
      );
    });

    test('one entry per supplier, preferring the saved one', () {
      final options = mergeSupplierOptions(
        saved: [Supplier(id: 's1', custNm: 'KAPP', custTin: '111222333')],
        purchases: [
          _p('Kapp Ltd', '111-222-333', 1),
          _p('kapp', '', 2),
          _p('KAPP', '111222333', 3),
        ],
      );
      expect(options, hasLength(1));
      expect(options.single.savedId, 's1');
    });

    test('same name but different TINs are different suppliers', () {
      final options = mergeSupplierOptions(
        saved: const [],
        purchases: [_p('Star', '111111111', 1), _p('Star', '222222222', 2)],
      );
      expect(options, hasLength(2));
    });

    test('skips blank names', () {
      final options = mergeSupplierOptions(
        saved: [Supplier(id: 's1', custNm: '  ')],
        purchases: [_p('', '', 1)],
      );
      expect(options, isEmpty);
    });
  });
}
