import 'package:flipper_web/modules/accounting/data/accounting_document_math.dart';
import 'package:flipper_web/modules/accounting/data/accounting_v3_models.dart';
import 'package:flipper_web/modules/accounting/data/mapper/document_row_mapper.dart';
import 'package:flipper_web/modules/accounting/data/mapper/transaction_aging.dart';
import 'package:flutter_test/flutter_test.dart';

AccountingDocument _bill(
  String id, {
  required String due,
  DocStatus status = DocStatus.sent,
  int? total = 100000,
  int paid = 0,
}) => AccountingDocument(
  id: id,
  who: 'Kigali Wholesale',
  date: '1 Aug 2026',
  due: due,
  status: status,
  lines: const [DocLine(desc: 'Rice', qty: 1, price: 1)],
  total: total,
  amountPaid: paid,
  supplierId: 'sup-1',
);

void main() {
  group('document balance', () {
    test('stored total wins over the line-derived total', () {
      final b = _bill('BILL-1', due: '1 Sep 2026', total: 118000);
      expect(docGrandTotal(b), 118000);
    });

    test('older documents without a stored total use their lines', () {
      const legacy = AccountingDocument(
        id: 'BILL-2',
        who: 'X',
        date: '',
        due: '',
        status: DocStatus.sent,
        lines: [DocLine(desc: 'a', qty: 1, price: 1000)],
      );
      expect(docGrandTotal(legacy), 1180);
      expect(docBalance(legacy), 1180);
    });

    test('balance subtracts payments and a paid document owes nothing', () {
      expect(docBalance(_bill('B', due: '', paid: 40000)), 60000);
      expect(docBalance(_bill('B', due: '', status: DocStatus.paid)), 0);
      expect(docIsOpen(_bill('B', due: '', status: DocStatus.draft)), isFalse);
      expect(
        docIsOpen(_bill('B', due: '', status: DocStatus.partiallyPaid)),
        isTrue,
      );
    });
  });

  group('deriveApAgingFromBills', () {
    final now = DateTime(2026, 10, 3);

    test('buckets the open balance by days past the due date', () {
      final rows = deriveApAgingFromBills([
        _bill('NOT-DUE', due: '20 Oct 2026', paid: 25000),
        _bill('LATE-10', due: '23 Sep 2026'),
        _bill('LATE-45', due: '19 Aug 2026'),
        _bill('LATE-90', due: '1 Jun 2026'),
      ], now: now);

      final byInv = {for (final r in rows) r.inv: r};
      expect(byInv['NOT-DUE']!.current, 75000);
      expect(byInv['LATE-10']!.d30, 100000);
      expect(byInv['LATE-45']!.d60, 100000);
      expect(byInv['LATE-90']!.d90, 100000);
      expect(byInv['NOT-DUE']!.partyId, 'sup-1');
    });

    test('skips drafts and settled bills', () {
      final rows = deriveApAgingFromBills([
        _bill('DRAFT', due: '1 Sep 2026', status: DocStatus.draft),
        _bill('PAID', due: '1 Sep 2026', status: DocStatus.paid),
        _bill('FULLY', due: '1 Sep 2026', paid: 100000),
      ], now: now);
      expect(rows, isEmpty);
    });
  });

  group('DocumentRowMapper pay-later fields', () {
    test('reads cached amounts written by the payment poster', () {
      final doc = DocumentRowMapper.documentFromRow({
        'id': 'biz_bill_BILL-7',
        'doc_number': 'BILL-7',
        'status': 'sent',
        'total': 118000,
        'amount_paid': 50000,
        'source': 'purchase',
        'supplier_id': 'sup-9',
      });
      expect(doc.total, 118000);
      expect(doc.amountPaid, 50000);
      expect(doc.source, 'purchase');
      expect(doc.supplierId, 'sup-9');
    });

    test('never writes amount_paid, and stores part paid as sent', () {
      final row = DocumentRowMapper.documentToRow(
        businessId: 'biz',
        kind: DocKind.bill,
        doc: _bill(
          'BILL-8',
          due: '',
          status: DocStatus.partiallyPaid,
          paid: 30000,
        ),
      );
      expect(row.containsKey('amount_paid'), isFalse);
      expect(row.containsKey('balance'), isFalse);
      expect(row['status'], 'sent');
      expect(row['total'], 100000);
    });
  });

  group('legacy purchase bills and payments', () {
    const legacy = AccountingDocument(
      id: 'BILL-9',
      who: 'Old Supplier',
      date: '1 Jun 2026',
      due: '1 Jul 2026',
      status: DocStatus.sent,
      lines: [DocLine(desc: 'Rice', qty: 2, price: 5900)],
      purchaseId: 'p-old',
    );

    test('their total is the VAT-inclusive line sum', () {
      expect(docGrandTotal(legacy), 11800);
    });

    test('they stay out of what is owed', () {
      expect(legacy.isLegacyPurchaseBill, isTrue);
      expect(docIsOpen(legacy), isFalse);
      expect(
        deriveApAgingFromBills([legacy], now: DateTime(2026, 10, 3)),
        isEmpty,
      );
    });

    test('editing one never writes a total that would re-open it', () {
      final row = DocumentRowMapper.documentToRow(
        businessId: 'biz',
        kind: DocKind.bill,
        doc: legacy,
      );
      expect(row.containsKey('total'), isFalse);
    });

    test('amount paid comes from payment records when the cache lags', () {
      final bill = _bill('BILL-1', due: '', paid: 400).copyWith(paidUpfront: 0);
      // Two devices paid 600 and 400 offline; the cache kept only 400.
      final applied = withPaymentsApplied(bill, 1000);
      expect(applied.amountPaid, 1000);
      expect(docBalance(applied), 99000);
      // A cache ahead of not-yet-synced payments is kept.
      expect(withPaymentsApplied(bill, 0).amountPaid, 400);
    });

    test('drafts and settled bills cannot be paid', () {
      expect(
        billCanBePaid(_bill('B', due: '', status: DocStatus.draft)),
        isFalse,
      );
      expect(
        billCanBePaid(_bill('B', due: '', status: DocStatus.paid)),
        isFalse,
      );
      expect(
        billCanBePaid(_bill('B', due: '', status: DocStatus.overdue)),
        isTrue,
      );
    });
  });
}
