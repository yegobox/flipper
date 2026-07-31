import 'package:flipper_models/helpers/ticket_handover_idempotency.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';

ITransaction _txn({int? invoiceNumber, int? receiptNumber}) {
  return ITransaction(
    id: 't1',
    branchId: 'b1',
    status: 'awaitingHandover',
    transactionType: 'sale',
    paymentType: 'Cash',
    cashReceived: 0,
    customerChangeDue: 0,
    updatedAt: DateTime.utc(2026, 1, 1),
    isIncome: true,
    isExpense: false,
    agentId: 'a1',
    invoiceNumber: invoiceNumber,
    receiptNumber: receiptNumber,
  );
}

TransactionItem _line({
  required String id,
  required String itemTyCd,
  required num qty,
  required int quantityShipped,
}) {
  return TransactionItem(
    id: id,
    name: 'Item',
    qty: qty,
    price: 10,
    discount: 0,
    prc: 10,
    ttCatCd: 'B',
    itemTyCd: itemTyCd,
    variantId: 'v1',
    quantityShipped: quantityShipped,
  );
}

void main() {
  group('ticketHasFiscalInvoice', () {
    test('false when all fiscal counters missing', () {
      expect(ticketHasFiscalInvoice(_txn()), isFalse);
    });

    test('true when invoiceNumber set', () {
      expect(ticketHasFiscalInvoice(_txn(invoiceNumber: 42)), isTrue);
    });

    test('true when only receiptNumber set', () {
      expect(ticketHasFiscalInvoice(_txn(receiptNumber: 7)), isTrue);
    });
  });

  group('ticketStockLinesNeedDeduction', () {
    test('false when only services', () {
      final items = <TransactionItem>[
        _line(id: 'i1', itemTyCd: '3', qty: 1, quantityShipped: 0),
      ];
      expect(ticketStockLinesNeedDeduction(items), isFalse);
    });

    test('true when stock line not marked shipped', () {
      final items = <TransactionItem>[
        _line(id: 'i1', itemTyCd: '2', qty: 2, quantityShipped: 0),
      ];
      expect(ticketStockLinesNeedDeduction(items), isTrue);
    });

    test('false when stock lines already shipped', () {
      final items = <TransactionItem>[
        _line(id: 'i1', itemTyCd: '2', qty: 2, quantityShipped: 2),
      ];
      expect(ticketStockLinesNeedDeduction(items), isFalse);
    });
  });
}
