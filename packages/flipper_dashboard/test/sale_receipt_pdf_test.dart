import 'package:flipper_dashboard/services/sale_receipt_pdf.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';

ITransaction _sale({
  bool refunded = false,
  String? receiptFileName,
  String paymentType = 'CASH',
}) {
  final now = DateTime.now().toUtc();
  return ITransaction(
    id: 'tx-pdf-1',
    branchId: 'branch-1',
    agentId: 'agent-1',
    reference: '962702215298675',
    status: refunded ? 'refunded' : 'complete',
    transactionType: 'Sale',
    subTotal: 161000,
    paymentType: paymentType,
    cashReceived: 161000,
    customerChangeDue: 0,
    createdAt: now,
    updatedAt: now,
    isIncome: true,
    isExpense: false,
    isRefunded: refunded,
    refundedAmount: refunded ? 161000 : null,
    refundReason: refunded ? 'Customer request' : null,
    refundMethod: refunded ? 'cash' : null,
    receiptFileName: receiptFileName,
  );
}

List<TransactionItem> _items() => [
      TransactionItem(
        id: 'item-1',
        name: 'RYMAX HYDRAULIC',
        transactionId: 'tx-pdf-1',
        variantId: 'v1',
        qty: 4,
        price: 13000,
        prc: 13000,
        discount: 0,
        branchId: 'branch-1',
        ttCatCd: 'A',
      ),
      TransactionItem(
        id: 'item-2',
        name: 'OIL FILTER',
        transactionId: 'tx-pdf-1',
        variantId: 'v2',
        qty: 1,
        price: 12000,
        prc: 12000,
        discount: 0,
        branchId: 'branch-1',
        ttCatCd: 'A',
      ),
    ];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('builds a PDF for a sale with no stored EBM receipt', () async {
    final bytes = await SaleReceiptPdf.build(
      transaction: _sale(),
      items: _items(),
      currency: 'RWF',
      issuer: const SaleReceiptIssuer(
        businessName: 'Yego Auto Parts',
        branchName: 'Kigali',
        tin: '123456789',
      ),
    );

    expect(bytes.length, greaterThan(1000));
    expect(String.fromCharCodes(bytes.take(4)), '%PDF');
  });

  test('builds a PDF for a refunded sale with no line items', () async {
    final bytes = await SaleReceiptPdf.build(
      transaction: _sale(refunded: true),
      items: const [],
      currency: 'RWF',
    );

    expect(bytes.length, greaterThan(1000));
    expect(String.fromCharCodes(bytes.take(4)), '%PDF');
  });

  test('builds a PDF for a credit sale (no cash figures)', () async {
    final bytes = await SaleReceiptPdf.build(
      transaction: _sale(paymentType: 'CREDIT'),
      items: _items(),
      currency: 'RWF',
    );

    expect(String.fromCharCodes(bytes.take(4)), '%PDF');
  });
}
