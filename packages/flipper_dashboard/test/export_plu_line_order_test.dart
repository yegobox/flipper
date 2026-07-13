import 'package:flipper_dashboard/export/export_report_transactions.dart';
import 'package:flipper_dashboard/export/utils/plu_detailed_report_row.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter_test/flutter_test.dart';

ITransaction _sale(String id) {
  final now = DateTime(2026, 7, 13, 12);
  return ITransaction(
    id: id,
    agentId: 'agent-1',
    branchId: 'b1',
    status: COMPLETE,
    transactionType: 'sale',
    paymentType: 'CASH',
    cashReceived: 0,
    customerChangeDue: 0,
    updatedAt: now,
    createdAt: now,
    isIncome: true,
    isExpense: false,
  );
}

TransactionItem _line({
  required String id,
  required String transactionId,
  required String name,
  required DateTime createdAt,
  DateTime? updatedAt,
  int itemSeq = 1,
  String? itemClsCd,
  String? itemCd,
  double splyAmt = 0,
}) {
  return TransactionItem(
    id: id,
    transactionId: transactionId,
    name: name,
    price: 100,
    qty: 1,
    discount: 0,
    prc: 100,
    ttCatCd: 'A',
    itemClsCd: itemClsCd,
    itemCd: itemCd,
    splyAmt: splyAmt,
    createdAt: createdAt,
    updatedAt: updatedAt ?? createdAt,
    itemSeq: itemSeq,
  );
}

void main() {
  group('exportPluItemsSalesOnly', () {
    test(
      'orders lines like POS cart (updatedAt DESC)',
      () {
        final sales = [_sale('sale-new'), _sale('sale-old')];

        final ordered = exportPluItemsSalesOnly([
          _line(
            id: 'line-old-b',
            transactionId: 'sale-old',
            name: 'FABLE009',
            createdAt: DateTime(2026, 7, 13, 12),
            updatedAt: DateTime(2026, 7, 13, 12, 2),
            itemSeq: 2,
          ),
          _line(
            id: 'line-new',
            transactionId: 'sale-new',
            name: 'PAIN COUPE',
            createdAt: DateTime(2026, 7, 13, 18),
            updatedAt: DateTime(2026, 7, 13, 18),
          ),
          _line(
            id: 'line-old-a',
            transactionId: 'sale-old',
            name: 'FABLE',
            createdAt: DateTime(2026, 7, 13, 12),
            updatedAt: DateTime(2026, 7, 13, 12, 1),
            itemSeq: 1,
          ),
        ], sales);

        expect(ordered.map((i) => i.name).toList(), [
          'PAIN COUPE',
          'FABLE009',
          'FABLE',
        ]);
      },
    );

    test('preserves cart updatedAt order after checkout (not itemSeq)', () {
      final sales = [_sale('sale-1')];

      final ordered = exportPluItemsSalesOnly([
        _line(
          id: 'fable009',
          transactionId: 'sale-1',
          name: 'FABLE009',
          createdAt: DateTime(2026, 7, 13, 18, 1),
          updatedAt: DateTime(2026, 7, 13, 18, 1),
          itemSeq: 1,
        ),
        _line(
          id: 'fable',
          transactionId: 'sale-1',
          name: 'FABLE',
          createdAt: DateTime(2026, 7, 13, 18, 2),
          updatedAt: DateTime(2026, 7, 13, 18, 2),
          itemSeq: 2,
        ),
        _line(
          id: 'pain',
          transactionId: 'sale-1',
          name: 'PAIN COUPE',
          createdAt: DateTime(2026, 7, 13, 18, 3),
          updatedAt: DateTime(2026, 7, 13, 18, 3),
          itemSeq: 99,
        ),
      ], sales);

      expect(ordered.map((i) => i.name).toList(), [
        'PAIN COUPE',
        'FABLE',
        'FABLE009',
      ]);
    });
  });

  group('pluDetailedReportRow', () {
    test('uses itemClsCd for ItemCode like the on-screen grid', () {
      final row = pluDetailedReportRow(
        _line(
          id: 'x',
          transactionId: 't',
          name: 'FABLE',
          createdAt: DateTime(2026, 7, 13),
          itemClsCd: '5020230602',
          itemCd: 'AC2AMCT0003004',
          splyAmt: 200,
        ),
        taxRatePercent: 18,
      );

      expect(row['ItemCode'], '5020230602');
      expect(row['TotalSales'], -100);
    });
  });
}
