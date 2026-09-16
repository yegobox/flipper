import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flipper_models/notifications_client.dart';
import 'package:flipper_services/data_connector_url.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/models/business.model.dart';

enum HotelBookingEvent {
  reserved,
  checkedIn;

  /// Wire value the `/api/notify/booking-confirmation` route expects.
  String get wire =>
      this == HotelBookingEvent.reserved ? 'reserved' : 'checked_in';
}

/// Outcome of an attempt, for callers that want to react (only the
/// out-of-credits case is worth telling a clerk about).
enum BookingNotificationOutcome {
  /// At least one channel accepted the message.
  sent,

  /// The guest gave neither a phone number nor an email, so nothing was sent
  /// and no network call was made.
  noContact,

  /// Already sent for this stay and event.
  duplicate,

  /// The branch is out of credits, so the SMS leg did not go out.
  outOfCredits,

  /// Both settings toggles are off for this event.
  disabled,

  failed,
}

/// Sends the guest their booking confirmation.
///
/// Always fire-and-forget: a front desk with a guest standing in front of it
/// must never wait on, or be blocked by, a notification. Every path returns an
/// outcome rather than throwing.
abstract final class BookingNotificationService {
  /// Cheap first line of defence against a double tap inside one session.
  /// `checkInGuest` is idempotent per room and returns the *existing* stay on a
  /// second tap, so the key is stable and this actually catches it. The server
  /// dedupe map and the `messages.idempotency_key` index cover the cases this
  /// cannot: a second device, and a connector restart.
  static final Set<String> _sentKeys = <String>{};

  /// Visible for tests.
  static void resetSentKeys() => _sentKeys.clear();

  /// Injectable for tests; production leaves it null and the real client is
  /// built from the branch's `Ebm.dataConnectorUrl`.
  static Future<NotificationsClient> Function()? clientOverride;

  static String idempotencyKeyFor(HotelStay stay, HotelBookingEvent event) =>
      'stay:${stay.id}:${event.wire}';

  static Future<BookingNotificationOutcome> sendBookingConfirmation({
    required HotelStay stay,
    required HotelBookingEvent event,
    required bool sendSms,
    required bool sendEmail,
    int checkOutHour = 11,
    String? businessName,
    String? branchName,
    String? branchPhone,
    String? currency,
  }) async {
    if (!sendSms && !sendEmail) return BookingNotificationOutcome.disabled;

    final key = idempotencyKeyFor(stay, event);
    if (_sentKeys.contains(key)) {
      return BookingNotificationOutcome.duplicate;
    }

    final phone = _nonBlank(stay.guestPhone);
    final email = _validEmail(stay.guestEmail);

    final wantsSms = sendSms && phone != null;
    final wantsEmail = sendEmail && email != null;
    if (!wantsSms && !wantsEmail) {
      // Not a failure — plenty of walk-ins leave no contact details. Say so
      // once in the log so a desk wondering why nothing arrived can find out.
      talker.info(
        'hotel: no guest contact on stay ${stay.id} — '
        '${event.wire} confirmation skipped',
      );
      return BookingNotificationOutcome.noContact;
    }

    try {
      final client = await _client();
      final resolved = await _resolveIssuer(
        businessName: businessName,
        branchName: branchName,
        branchPhone: branchPhone,
      );

      final result = await client.sendBookingConfirmation(
        BookingConfirmationPayload(
          event: event.wire,
          branchId: stay.branchId,
          stayId: stay.id,
          reference: _referenceFor(stay),
          guestName: stay.guestName,
          guestPhone: wantsSms ? phone : null,
          guestEmail: wantsEmail ? email : null,
          roomName: stay.roomName,
          checkInAt: stay.checkInAt,
          checkOutAt: stay.expectedCheckOutAt,
          nights: stay.nights,
          adults: stay.adults,
          children: stay.children,
          nightlyRate: stay.nightlyRate,
          currency: currency ?? ProxyService.box.defaultCurrency(),
          businessName: resolved.businessName,
          branchName: resolved.branchName,
          branchPhone: resolved.branchPhone,
          checkOutHour: checkOutHour,
          sendSms: wantsSms,
          sendEmail: wantsEmail,
          idempotencyKey: key,
        ),
      );

      _sentKeys.add(key);

      if (result.deduplicated) return BookingNotificationOutcome.duplicate;
      if (result.outOfCredits) {
        talker.warning(
          'hotel: SMS confirmation for stay ${stay.id} skipped — '
          'branch ${stay.branchId} is out of credits',
        );
        return BookingNotificationOutcome.outOfCredits;
      }
      if (result.anySent) return BookingNotificationOutcome.sent;

      talker.warning(
        'hotel: ${event.wire} confirmation for stay ${stay.id} sent nothing '
        '(sms=${result.sms.status}, email=${result.email.status})',
      );
      return BookingNotificationOutcome.failed;
    } on NotifyInsufficientCreditsException {
      // Retrying cannot help, and re-attempting on every rebuild would just
      // fill the log — so the key is recorded even though nothing was sent.
      _sentKeys.add(key);
      return BookingNotificationOutcome.outOfCredits;
    } catch (e, s) {
      talker.error(
        'hotel: ${event.wire} confirmation failed for stay ${stay.id}',
        e,
        s,
      );
      return BookingNotificationOutcome.failed;
    }
  }

  static Future<NotificationsClient> _client() async {
    final override = clientOverride;
    if (override != null) return override();
    final url = await resolveEbmDataConnectorUrl();
    return createNotificationsClient(dataConnectorUrl: url ?? '');
  }

  /// Guests quote a room and a date back, not a UUID — but the server needs
  /// something in the reference slot, so fall back to a short stay id.
  static String _referenceFor(HotelStay stay) {
    final id = stay.id.replaceAll('-', '');
    if (id.length <= 6) return id.toUpperCase();
    return id.substring(0, 6).toUpperCase();
  }

  static Future<_Issuer> _resolveIssuer({
    String? businessName,
    String? branchName,
    String? branchPhone,
  }) async {
    if (businessName != null && branchName != null) {
      return _Issuer(businessName, branchName, branchPhone);
    }

    final strategy = ProxyService.getStrategy(Strategy.capella);

    Business? business;
    try {
      business = await strategy.getBusiness(
        businessId: ProxyService.box.getBusinessId(),
      );
    } catch (_) {}

    var resolvedBranch = branchName;
    if (resolvedBranch == null) {
      final branchId = ProxyService.box.getBranchId();
      if (branchId != null && branchId.isNotEmpty) {
        try {
          resolvedBranch = (await strategy.activeBranch(
            branchId: branchId,
          )).name;
        } catch (_) {}
      }
    }

    return _Issuer(
      businessName ?? business?.name,
      resolvedBranch,
      branchPhone ?? business?.phoneNumber,
    );
  }

  static String? _nonBlank(String? value) {
    final trimmed = value?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }

  /// Permissive on purpose: catches a phone number typed into the email box
  /// without rejecting valid but unusual addresses. The server checks again.
  static String? _validEmail(String? value) {
    final trimmed = _nonBlank(value);
    if (trimmed == null) return null;
    final ok = RegExp(r'^[^@\s]+@[^@\s.]+(\.[^@\s.]+)+$').hasMatch(trimmed);
    return ok ? trimmed : null;
  }
}

class _Issuer {
  const _Issuer(this.businessName, this.branchName, this.branchPhone);
  final String? businessName;
  final String? branchName;
  final String? branchPhone;
}
