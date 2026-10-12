import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/pos_cart_display_provider.dart';
import 'package:flipper_models/providers/tickets_provider.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter_test/flutter_test.dart';

ITransaction _ticket({
  String status = PENDING,
  String? deviceId = 'dev-u1',
  String? agentId = 'u1',
}) => ITransaction(
  branchId: 'b1',
  status: status,
  transactionType: 'sale',
  paymentType: 'Cash',
  subTotal: 900,
  cashReceived: 0,
  customerChangeDue: 0,
  updatedAt: DateTime.utc(2026, 1, 1),
  isIncome: true,
  isExpense: false,
  ticketName: 'Table 4',
  deviceId: deviceId,
  agentId: agentId,
);

void main() {
  group('resumedTicketPlace', () {
    test('a parked ticket is queued', () {
      expect(
        resumedTicketPlace(
          _ticket(status: PARKED),
          deviceId: 'dev-u1',
          userId: 'u1',
        ),
        ResumedTicketPlace.queued,
      );
    });

    test('resumed here by me is this till', () {
      expect(
        resumedTicketPlace(_ticket(), deviceId: 'dev-u1', userId: 'u1'),
        ResumedTicketPlace.thisTill,
      );
    });

    test('resumed on another device or by another user is another till', () {
      expect(
        resumedTicketPlace(_ticket(), deviceId: 'dev-u9', userId: 'u1'),
        ResumedTicketPlace.otherTill,
      );
      expect(
        resumedTicketPlace(_ticket(), deviceId: 'dev-u1', userId: 'u2'),
        ResumedTicketPlace.otherTill,
      );
    });

    test('unknown device id never claims the ticket as ours', () {
      expect(
        resumedTicketPlace(_ticket(), deviceId: null, userId: 'u1'),
        ResumedTicketPlace.otherTill,
      );
    });
  });

  group('isTakenOverPendingRow', () {
    test('only a PENDING row on a different device counts', () {
      expect(isTakenOverPendingRow(_ticket(), deviceId: 'dev-u1'), isFalse);
      expect(isTakenOverPendingRow(_ticket(), deviceId: 'dev-u9'), isTrue);
      expect(
        isTakenOverPendingRow(_ticket(status: COMPLETE), deviceId: 'dev-u9'),
        isFalse,
        reason: 'completion is handled by the sale paths, not take-over',
      );
      expect(
        isTakenOverPendingRow(_ticket(deviceId: null), deviceId: 'dev-u9'),
        isFalse,
      );
      expect(isTakenOverPendingRow(null, deviceId: 'dev-u9'), isFalse);
    });
  });
}
