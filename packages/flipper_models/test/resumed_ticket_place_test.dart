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

  group('pinnedCartMovedAway', () {
    ({bool movedAway, String? holder}) step(
      String? rowDevice,
      String? holder, {
      String status = PENDING,
    }) => pinnedCartMovedAway(
      status: status,
      rowDevice: rowDevice,
      holderDevice: holder,
      thisDevice: 'dev-now',
    );

    test('a new cart carrying an older id of this till is not a take-over', () {
      // Ditto init re-stamped deviceName after the cart was minted.
      final first = step('dev-earlier', null);
      expect(first.movedAway, isFalse);
      final again = step('dev-earlier', first.holder);
      expect(again.movedAway, isFalse);
    });

    test('moving to another till after pinning is a take-over', () {
      final pinned = step('dev-now', null);
      expect(pinned.holder, 'dev-now');
      expect(step('dev-other', pinned.holder).movedAway, isTrue);
    });

    test('a stale-id cart taken over is still caught', () {
      final pinned = step('dev-earlier', null);
      expect(step('dev-other', pinned.holder).movedAway, isTrue);
    });

    test('coming back to this till resets the holder', () {
      final back = step('dev-now', 'dev-other');
      expect(back.movedAway, isFalse);
      expect(back.holder, 'dev-now');
    });

    test('completed or device-less rows never count', () {
      expect(step('dev-other', 'dev-now', status: COMPLETE).movedAway, isFalse);
      expect(step(null, 'dev-now').movedAway, isFalse);
    });
  });
}
