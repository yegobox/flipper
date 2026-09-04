import 'package:flipper_models/providers/pos_payment_role_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';

ITransaction _txn({
  required String status,
  String? ticketName,
  String id = 'txn-abcdef123',
  String? reference,
}) {
  return ITransaction(
    id: id,
    branchId: 'b1',
    status: status,
    transactionType: 'sale',
    paymentType: 'Cash',
    cashReceived: 0,
    customerChangeDue: 0,
    updatedAt: DateTime.utc(2026, 1, 1),
    createdAt: DateTime.utc(2026, 1, 1),
    isIncome: true,
    isExpense: false,
    agentId: 'a1',
    ticketName: ticketName,
    reference: reference,
  );
}

void main() {
  group('recoverSettlingTillTicketFromResumedCart', () {
    test('rebuilds a session for a resumed ticket (PENDING + ticketName)', () {
      final settling = recoverSettlingTillTicketFromResumedCart(
        _txn(status: 'pending', ticketName: 'Till · E591A', reference: 'e591a'),
      );

      expect(settling, isNotNull);
      expect(settling!.transactionId, 'txn-abcdef123');
      expect(settling.displayRef, 'E591A');
      expect(settling.ticketName, 'Till · E591A');
      expect(settling.createdAt, DateTime.utc(2026, 1, 1));
    });

    test('falls back to a truncated id when the row has no reference', () {
      final settling = recoverSettlingTillTicketFromResumedCart(
        _txn(status: 'pending', ticketName: 'Walk-in'),
      );

      expect(settling?.displayRef, 'TXN-AB');
    });

    test('ignores a plain pending cart (no ticket name)', () {
      expect(
        recoverSettlingTillTicketFromResumedCart(_txn(status: 'pending')),
        isNull,
      );
      expect(
        recoverSettlingTillTicketFromResumedCart(
          _txn(status: 'pending', ticketName: '   '),
        ),
        isNull,
      );
    });

    test('ignores a ticket that is not resumed', () {
      expect(
        recoverSettlingTillTicketFromResumedCart(
          _txn(status: 'parked', ticketName: 'Till · E591A'),
        ),
        isNull,
      );
      expect(
        recoverSettlingTillTicketFromResumedCart(
          _txn(status: 'completed', ticketName: 'Till · E591A'),
        ),
        isNull,
      );
    });

    test('ignores a null row', () {
      expect(recoverSettlingTillTicketFromResumedCart(null), isNull);
    });
  });
}
