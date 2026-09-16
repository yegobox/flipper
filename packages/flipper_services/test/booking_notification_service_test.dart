import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flipper_models/notifications_client.dart';
import 'package:flipper_services/notifications/booking_notification_service.dart';
import 'package:flutter_test/flutter_test.dart';

/// Records what would have been sent, and answers with whatever the test wants.
class _FakeNotificationsClient extends NotificationsClient {
  _FakeNotificationsClient({this.response, this.throwError})
    : super(baseUrl: 'http://localhost/', logHttp: false);

  final BookingConfirmationResult? response;
  final Object? throwError;

  final List<BookingConfirmationPayload> calls = [];

  @override
  Future<BookingConfirmationResult> sendBookingConfirmation(
    BookingConfirmationPayload payload,
  ) async {
    calls.add(payload);
    final error = throwError;
    if (error != null) throw error;
    return response ??
        const BookingConfirmationResult(
          ok: true,
          sms: NotifyLegResult(attempted: true, status: 'sent'),
          email: NotifyLegResult(attempted: true, status: 'sent'),
        );
  }
}

HotelStay _stay({String? phone, String? email, String id = 's1'}) => HotelStay(
  id: id,
  branchId: 'b1',
  roomId: 'r1',
  roomName: '204',
  transactionId: 't1',
  guestName: 'Aline Uwase',
  guestPhone: phone,
  guestEmail: email,
  checkInAt: DateTime.utc(2026, 1, 10, 14),
  expectedCheckOutAt: DateTime.utc(2026, 1, 12, 11),
  nightlyRate: 50000,
);

void main() {
  late _FakeNotificationsClient client;

  setUp(() {
    client = _FakeNotificationsClient();
    BookingNotificationService.resetSentKeys();
    BookingNotificationService.clientOverride = () async => client;
  });

  tearDown(() {
    BookingNotificationService.clientOverride = null;
    BookingNotificationService.resetSentKeys();
  });

  Future<BookingNotificationOutcome> send(
    HotelStay stay, {
    HotelBookingEvent event = HotelBookingEvent.reserved,
    bool sms = true,
    bool email = true,
  }) {
    return BookingNotificationService.sendBookingConfirmation(
      stay: stay,
      event: event,
      sendSms: sms,
      sendEmail: email,
      // Supplied so the service never reaches for ProxyService in a unit test.
      businessName: 'Yego Hotel',
      branchName: 'Kigali',
      branchPhone: '+250788111222',
      currency: 'RWF',
    );
  }

  group('contact details decide what is attempted', () {
    test('no phone and no email makes no network call at all', () async {
      final outcome = await send(_stay());

      expect(outcome, BookingNotificationOutcome.noContact);
      expect(client.calls, isEmpty);
    });

    test('phone only asks for the SMS leg alone', () async {
      await send(_stay(phone: '0788360058'));

      expect(client.calls.single.sendSms, isTrue);
      expect(client.calls.single.sendEmail, isFalse);
      expect(client.calls.single.guestEmail, isNull);
    });

    test('email only asks for the email leg alone', () async {
      await send(_stay(email: 'aline@example.com'));

      expect(client.calls.single.sendEmail, isTrue);
      expect(client.calls.single.sendSms, isFalse);
      expect(client.calls.single.guestPhone, isNull);
    });

    test('both contacts ask for both legs', () async {
      await send(_stay(phone: '0788360058', email: 'aline@example.com'));

      expect(client.calls.single.sendSms, isTrue);
      expect(client.calls.single.sendEmail, isTrue);
    });

    test('a malformed email is treated as no email', () async {
      // Otherwise the server spends a round trip rejecting a phone number
      // somebody typed into the email box.
      final outcome = await send(_stay(email: '0788360058'));

      expect(outcome, BookingNotificationOutcome.noContact);
      expect(client.calls, isEmpty);
    });

    test('both channels disabled sends nothing', () async {
      final outcome = await send(
        _stay(phone: '0788360058', email: 'aline@example.com'),
        sms: false,
        email: false,
      );

      expect(outcome, BookingNotificationOutcome.disabled);
      expect(client.calls, isEmpty);
    });

    test('a guest with only a phone, on an email-only branch, is skipped',
        () async {
      final outcome = await send(_stay(phone: '0788360058'), sms: false);

      expect(outcome, BookingNotificationOutcome.noContact);
      expect(client.calls, isEmpty);
    });
  });

  group('idempotency', () {
    test('the same stay and event only sends once', () async {
      final stay = _stay(email: 'aline@example.com');

      expect(await send(stay), BookingNotificationOutcome.sent);
      expect(await send(stay), BookingNotificationOutcome.duplicate);
      expect(client.calls, hasLength(1));
    });

    test('reserve and check-in are separate messages', () async {
      final stay = _stay(email: 'aline@example.com');

      await send(stay, event: HotelBookingEvent.reserved);
      await send(stay, event: HotelBookingEvent.checkedIn);

      expect(client.calls, hasLength(2));
      expect(client.calls[0].event, 'reserved');
      expect(client.calls[1].event, 'checked_in');
    });

    test('different stays are not confused with each other', () async {
      await send(_stay(email: 'a@example.com', id: 's1'));
      await send(_stay(email: 'b@example.com', id: 's2'));

      expect(client.calls, hasLength(2));
    });

    test('the key is derived from the stay, so a double tap is caught',
        () async {
      // checkInGuest is idempotent per room and returns the *existing* stay on
      // a second tap, which is what makes this key stable.
      final stay = _stay(email: 'aline@example.com');
      expect(
        BookingNotificationService.idempotencyKeyFor(
          stay,
          HotelBookingEvent.checkedIn,
        ),
        'stay:s1:checked_in',
      );
    });

    test('the key is sent to the server as the durable backstop', () async {
      await send(_stay(email: 'aline@example.com'));
      expect(client.calls.single.idempotencyKey, 'stay:s1:reserved');
    });
  });

  group('failures never reach the desk', () {
    test('a throwing client does not propagate', () async {
      BookingNotificationService.clientOverride = () async =>
          _FakeNotificationsClient(throwError: StateError('network down'));

      final outcome = await send(_stay(email: 'aline@example.com'));
      expect(outcome, BookingNotificationOutcome.failed);
    });

    test('a failed send is not remembered, so a later retry can work',
        () async {
      final failing = _FakeNotificationsClient(
        throwError: StateError('network down'),
      );
      BookingNotificationService.clientOverride = () async => failing;
      await send(_stay(email: 'aline@example.com'));

      BookingNotificationService.clientOverride = () async => client;
      expect(
        await send(_stay(email: 'aline@example.com')),
        BookingNotificationOutcome.sent,
      );
    });

    test('out of credits is reported distinctly — the clerk can act on it',
        () async {
      BookingNotificationService.clientOverride = () async =>
          _FakeNotificationsClient(
            response: const BookingConfirmationResult(
              ok: true,
              sms: NotifyLegResult(
                attempted: true,
                status: 'insufficient_credits',
              ),
              email: NotifyLegResult(attempted: true, status: 'sent'),
            ),
          );

      expect(
        await send(_stay(phone: '0788360058', email: 'a@example.com')),
        BookingNotificationOutcome.outOfCredits,
      );
    });

    test('a 402 is not retried on every rebuild', () async {
      BookingNotificationService.clientOverride = () async =>
          _FakeNotificationsClient(
            throwError: NotifyInsufficientCreditsException('no credits'),
          );

      final stay = _stay(phone: '0788360058');
      expect(await send(stay), BookingNotificationOutcome.outOfCredits);
      // Retrying cannot help, so it is remembered rather than re-attempted.
      expect(await send(stay), BookingNotificationOutcome.duplicate);
    });

    test('a server-side duplicate is reported as one', () async {
      BookingNotificationService.clientOverride = () async =>
          _FakeNotificationsClient(
            response: const BookingConfirmationResult(
              ok: true,
              deduplicated: true,
            ),
          );

      expect(
        await send(_stay(email: 'a@example.com')),
        BookingNotificationOutcome.duplicate,
      );
    });
  });

  group('payload', () {
    test('carries the stay details the copy is built from', () async {
      await send(_stay(phone: '0788360058', email: 'aline@example.com'));

      final payload = client.calls.single;
      expect(payload.branchId, 'b1');
      expect(payload.stayId, 's1');
      expect(payload.guestName, 'Aline Uwase');
      expect(payload.roomName, '204');
      expect(payload.nights, 2);
      expect(payload.nightlyRate, 50000);
      expect(payload.businessName, 'Yego Hotel');
      expect(payload.branchName, 'Kigali');
    });

    test('serialises to the snake_case shape the route expects', () async {
      await send(_stay(email: 'aline@example.com'));

      final json = client.calls.single.toJson();
      expect(json['event'], 'reserved');
      expect(json['branch_id'], 'b1');
      expect(json['guest_email'], 'aline@example.com');
      expect(json['send_sms'], isFalse);
      expect(json['idempotency_key'], 'stay:s1:reserved');
      expect(json.containsKey('guest_phone'), isFalse);
    });
  });
}
