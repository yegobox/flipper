import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helpers/ticket_resume_guard.dart';
import 'package:flipper_models/providers/pos_cart_display_provider.dart';
import 'package:flipper_models/providers/pos_payment_role_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const _ticketId = 'ticket-1';

ITransaction _ticket({double? subTotal}) => ITransaction(
  id: _ticketId,
  branchId: 'b1',
  status: 'pending',
  transactionType: 'sale',
  paymentType: 'Cash',
  cashReceived: 0,
  customerChangeDue: 0,
  updatedAt: DateTime.utc(2026, 1, 1),
  createdAt: DateTime.utc(2026, 1, 1),
  isIncome: true,
  isExpense: false,
  agentId: 'a1',
  ticketName: 'Table 4',
  subTotal: subTotal,
);

SettlingTillTicket _settling({double? subTotal = 4500}) => SettlingTillTicket(
  transactionId: _ticketId,
  displayRef: 'TICKET',
  creatorName: 'Staff',
  createdAt: DateTime.utc(2026, 1, 1),
  branchId: 'b1',
  ticketSnapshot: _ticket(subTotal: subTotal),
);

TransactionItem _line() => TransactionItem(
  id: 'line-1',
  name: 'Fanta',
  qty: 1,
  price: 1500,
  discount: 0,
  prc: 1500,
  ttCatCd: 'B',
  transactionId: _ticketId,
  branchId: 'b1',
  active: true,
);

void main() {
  group('settlingTicketLinesMissing', () {
    test('a collected ticket with a total but no lines is missing them', () {
      expect(
        settlingTicketLinesMissing(
          settling: _settling(),
          hasActiveLines: false,
          ticketSubTotal: 4500,
        ),
        isTrue,
      );
    });

    test('lines on this device mean nothing is missing', () {
      expect(
        settlingTicketLinesMissing(
          settling: _settling(),
          hasActiveLines: true,
          ticketSubTotal: 4500,
        ),
        isFalse,
      );
    });

    test('a ticket emptied by the operator (subTotal 0) is not missing', () {
      expect(
        settlingTicketLinesMissing(
          settling: _settling(),
          hasActiveLines: false,
          ticketSubTotal: 0,
        ),
        isFalse,
      );
    });

    test('no settling session means an ordinary empty cart', () {
      expect(
        settlingTicketLinesMissing(
          settling: null,
          hasActiveLines: false,
          ticketSubTotal: 4500,
        ),
        isFalse,
      );
    });
  });

  group('settlingTicketAwaitingLinesProvider', () {
    ProviderContainer container({
      required List<TransactionItem> lines,
      SettlingTillTicket? settling,
      ITransaction? liveRow,
    }) {
      final c = ProviderContainer(
        overrides: [
          effectiveSettlingTillTicketProvider.overrideWithValue(settling),
          posCartDisplayItemsProvider.overrideWithValue(lines),
          transactionByIdProvider(
            _ticketId,
          ).overrideWith((ref) => Stream.value(liveRow)),
        ],
      );
      addTearDown(c.dispose);
      return c;
    }

    test('waits while the ticket has a total and no lines', () {
      final c = container(lines: const [], settling: _settling());
      expect(c.read(settlingTicketAwaitingLinesProvider), isTrue);
    });

    test('stops waiting once lines arrive', () {
      final c = container(lines: [_line()], settling: _settling());
      expect(c.read(settlingTicketAwaitingLinesProvider), isFalse);
    });

    test('the live row wins over the snapshot once loaded', () async {
      final c = container(
        lines: const [],
        settling: _settling(subTotal: 4500),
        liveRow: _ticket(subTotal: 0),
      );
      final sub = c.listen(settlingTicketAwaitingLinesProvider, (_, __) {});
      addTearDown(sub.close);
      expect(sub.read(), isTrue, reason: 'snapshot stands in while loading');
      await c.read(transactionByIdProvider(_ticketId).future);
      expect(sub.read(), isFalse);
    });

    test('is false without a settling session', () {
      final c = container(lines: const []);
      expect(c.read(settlingTicketAwaitingLinesProvider), isFalse);
    });
  });

  group('ticketOpenOnAnotherDevice', () {
    test('a PENDING ticket held by another device is refused', () {
      expect(
        ticketOpenOnAnotherDevice(
          status: 'pending',
          ticketDeviceId: 'phone',
          deviceId: 'desktop',
        ),
        isTrue,
      );
    });

    test('this device may resume a ticket it already holds', () {
      expect(
        ticketOpenOnAnotherDevice(
          status: 'pending',
          ticketDeviceId: 'desktop',
          deviceId: 'desktop',
        ),
        isFalse,
      );
    });

    test('a parked ticket may be resumed whoever parked it', () {
      expect(
        ticketOpenOnAnotherDevice(
          status: 'parked',
          ticketDeviceId: 'phone',
          deviceId: 'desktop',
        ),
        isFalse,
      );
    });

    test('a PENDING row with no device stamp is not refused', () {
      expect(
        ticketOpenOnAnotherDevice(
          status: 'pending',
          ticketDeviceId: null,
          deviceId: 'desktop',
        ),
        isFalse,
      );
    });
  });
}
