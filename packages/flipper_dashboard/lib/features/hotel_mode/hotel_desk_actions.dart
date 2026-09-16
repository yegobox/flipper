import 'dart:async';

import 'package:flipper_dashboard/features/hotel_mode/hotel_mode_settings.dart';
import 'package:flipper_dashboard/features/hotel_mode/providers/hotel_mode_providers.dart';
import 'package:flipper_dashboard/features/hotel_mode/services/hotel_quotation_actions.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_reservation_sheet.dart';
import 'package:flipper_dashboard/utils/sale_receipt_settlement.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/models/hotel_quotation.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/notifications_client.dart';
import 'package:flipper_models/models/hotel_room.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flipper_models/services/hotel_room_rra_service.dart';
import 'package:flipper_services/data_connector_url.dart';
import 'package:flipper_services/notifications/booking_notification_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';
import 'package:supabase_models/brick/models/variant.model.dart';

/// Shared front-desk mutations used by both the desktop and mobile layouts.
///
/// Screens stay declarative; every write goes through here so the desktop and
/// mobile shells can never drift apart in behaviour.
abstract final class HotelDeskActions {
  static DatabaseSyncInterface get _sync =>
      ProxyService.getStrategy(Strategy.capella);

  /// Check [guestName] into [room] and open the folio screen on it.
  static Future<HotelStay?> checkIn({
    required WidgetRef ref,
    required HotelRoom room,
    required Tenant clerk,
    required String guestName,
    required DateTime checkInAt,
    required DateTime expectedCheckOutAt,
    required double nightlyRate,
    String? guestPhone,
    String? guestEmail,
    int adults = 1,
    int children = 0,
    String? note,
  }) async {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) return null;

    final stay = await _sync.checkInGuest(
      branchId: branchId,
      room: room,
      guestName: guestName,
      checkInAt: checkInAt,
      expectedCheckOutAt: expectedCheckOutAt,
      nightlyRate: nightlyRate,
      clerkTenantId: clerk.id,
      clerkName: clerk.name ?? 'Front desk',
      guestPhone: guestPhone,
      guestEmail: guestEmail,
      adults: adults,
      children: children,
      note: note,
    );

    _notifyBooking(stay, HotelBookingEvent.checkedIn, ref);

    // Open the folio first. Registering a room with RRA is a network round
    // trip, and the desk should not watch a spinner with a guest in front of
    // it — the charge arrives on the folio's own observer when it lands.
    final folio = await _sync.hotelFolio(transactionId: stay.transactionId);
    ref
        .read(hotelModeProvider.notifier)
        .openFolio(room: room, stay: stay, folio: folio);

    if (HotelModeSettings.autoPostRoomCharge) {
      unawaited(
        chargeRoomToFolio(ref: ref, room: room, stay: stay, clerk: clerk),
      );
    } else {
      // Deliberate, but it used to leave the desk with a folio of zero and no
      // trace of the decision anywhere — not in the log, not on screen.
      talker.info(
        'hotel: room charge skipped for ${stay.roomName} — '
        '"Post the room charge at check-in" is off for this branch.',
      );
      ref
          .read(hotelModeProvider.notifier)
          .showToast('Auto room charge is off — use + Room charge');
    }
    return stay;
  }

  /// Bills [stay]'s nights, registering the room with RRA first if nobody has.
  ///
  /// That registration is a safety net, not the normal path. Rooms created in
  /// Rooms & floors register on creation, and seeded rooms are swept in the
  /// background by [HotelRoomRraService.registerUnregisteredRooms] when Hotel
  /// Mode opens. It only fires when a guest reaches a room before the sweep
  /// did — a branch that was offline at open, or a sweep that gave up — and
  /// registering here is still better than a folio nobody can bill.
  ///
  /// Best effort by design: a branch with no EBM configuration still gets its
  /// guest a key, and the desk gets told why the charge is missing.
  static Future<void> chargeRoomToFolio({
    required WidgetRef ref,
    required HotelRoom room,
    required HotelStay stay,
    required Tenant clerk,
  }) async {
    final notifier = ref.read(hotelModeProvider.notifier);
    // Logged at every step: a toast lasts three seconds and this runs in the
    // background, so without a trail a folio of zero has no explanation by the
    // time anyone asks.
    talker.info(
      'hotel: charging room ${room.name} to folio ${stay.transactionId} '
      '(registered=${room.isRegisteredWithRra})',
    );
    try {
      if (!room.isRegisteredWithRra) {
        talker.info('hotel: registering room ${room.name} with RRA…');
        await HotelRoomRraService.registerRoom(room);
        talker.info('hotel: room ${room.name} registered');
      }
      await _sync.postRoomCharge(
        stay: stay,
        clerkTenantId: clerk.id,
        clerkName: clerk.name ?? 'Front desk',
      );
      talker.info('hotel: room charge posted for ${room.name}');
    } on StateError catch (e) {
      talker.error('hotel: room charge failed for ${room.name}: ${e.message}');
      notifier.showToast(e.message);
    } catch (e, st) {
      talker.error('hotel: room charge failed for ${room.name}', e, st);
      notifier.showToast('Room charge not posted: $e');
    }
  }

  /// Hold [room] for a future arrival. Surfaces the clash as a toast rather
  /// than throwing at the desk.
  static Future<HotelStay?> reserve({
    required WidgetRef ref,
    required HotelRoom room,
    required Tenant clerk,
    required HotelReservationDraft draft,
  }) async {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) return null;

    try {
      final stay = await _sync.reserveRoom(
        branchId: branchId,
        room: room,
        guestName: draft.guestName,
        checkInAt: draft.checkInAt,
        expectedCheckOutAt: draft.checkOutAt,
        nightlyRate: draft.nightlyRate,
        clerkTenantId: clerk.id,
        clerkName: clerk.name ?? 'Front desk',
        guestPhone: draft.guestPhone,
        guestEmail: draft.guestEmail,
        adults: draft.adults,
        children: draft.children,
        note: draft.note,
      );

      _notifyBooking(stay, HotelBookingEvent.reserved, ref);

      ref
          .read(hotelModeProvider.notifier)
          .showToast('Room ${room.name} held for ${draft.guestName}');
      return stay;
    } on StateError catch (e) {
      ref.read(hotelModeProvider.notifier).showToast(e.message);
      return null;
    }
  }

  /// Turn a reservation into an in-house stay and open its folio.
  static Future<void> checkInReservation({
    required WidgetRef ref,
    required HotelRoom room,
    required HotelStay stay,
    required Tenant clerk,
  }) async {
    final arrived = await _sync.checkInReservation(
      stay: stay,
      clerkTenantId: clerk.id,
      clerkName: clerk.name ?? 'Front desk',
    );

    _notifyBooking(arrived, HotelBookingEvent.checkedIn, ref);

    if (HotelModeSettings.autoPostRoomCharge) {
      unawaited(
        chargeRoomToFolio(ref: ref, room: room, stay: arrived, clerk: clerk),
      );
    }

    final folio = await _sync.hotelFolio(transactionId: arrived.transactionId);
    ref
        .read(hotelModeProvider.notifier)
        .openFolio(room: room, stay: arrived, folio: folio);
  }

  /// Confirm a booking to the guest, if the branch asked for it.
  ///
  /// Fire-and-forget on purpose: a clerk with a guest at the counter must never
  /// wait on a mail provider, and a failed confirmation must never fail the
  /// check-in that already happened. Duplicate suppression lives in
  /// [BookingNotificationService] and, beyond it, on the server — `checkInGuest`
  /// is idempotent per room and hands back the *existing* stay on a double tap,
  /// so this would otherwise send twice.
  static void _notifyBooking(
    HotelStay stay,
    HotelBookingEvent event,
    WidgetRef ref,
  ) {
    final wanted = event == HotelBookingEvent.reserved
        ? HotelModeSettings.notifyOnReserve
        : HotelModeSettings.notifyOnCheckIn;
    if (!wanted) return;

    final sendSms = HotelModeSettings.notifyGuestSms;
    final sendEmail = HotelModeSettings.notifyGuestEmail;
    if (!sendSms && !sendEmail) return;

    // Read the notifier now, not in the callback: the desk may have navigated
    // away by the time the send returns, and `ref.read` on a disposed ref
    // throws — inside an unawaited future that is an unhandled async error,
    // from the one path that must never disturb the desk.
    final notifier = ref.read(hotelModeProvider.notifier);

    unawaited(
      BookingNotificationService.sendBookingConfirmation(
        stay: stay,
        event: event,
        sendSms: sendSms,
        sendEmail: sendEmail,
        checkOutHour: HotelModeSettings.checkOutHour,
      ).then((outcome) {
        // Only one outcome is worth a toast: a clerk can top up credits, but
        // cannot do anything about a mail provider being slow, and a toast per
        // failed confirmation would train them to ignore toasts.
        if (outcome != BookingNotificationOutcome.outOfCredits) return;
        try {
          notifier.showToast('SMS not sent — branch is out of credits');
        } catch (e) {
          talker.info('hotel: credits toast dropped, desk closed: $e');
        }
      }),
    );
  }

  // --- Quotations ---

  static Future<void> saveQuotation(HotelQuotation quotation) =>
      _sync.saveHotelQuotation(quotation);

  static Future<void> deleteQuotation({required String id}) async {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) return;
    await _sync.deleteHotelQuotation(id: id, branchId: branchId);
  }

  /// Email [quotation] to the guest as a PDF.
  ///
  /// Returns [QuotationSendResult.noEmail] when there is nobody to send to, so
  /// the caller can prompt for an address and try again rather than showing a
  /// failure for something the clerk can fix in one field.
  static Future<QuotationSendResult> sendQuotation({
    required WidgetRef ref,
    required HotelQuotation quotation,
  }) async {
    final notifier = ref.read(hotelModeProvider.notifier);
    final email = quotation.guestEmail?.trim();
    if (email == null || email.isEmpty) return QuotationSendResult.noEmail;

    try {
      final businessName = await HotelQuotationActions.resolveBusinessName();
      final bytes = await HotelQuotationActions.buildPdf(quotation);

      final url = await resolveEbmDataConnectorUrl();
      final client = await createNotificationsClient(
        dataConnectorUrl: url ?? '',
      );

      final result = await client.sendEmail(
        to: [email],
        subject: HotelQuotationActions.emailSubject(quotation, businessName),
        htmlBody: HotelQuotationActions.emailHtml(quotation, businessName),
        plainText: HotelQuotationActions.emailPlain(quotation, businessName),
        attachments: [
          NotifyAttachment(
            name: HotelQuotationActions.fileName(quotation),
            bytes: bytes,
          ),
        ],
        branchId: quotation.branchId,
        idempotencyKey: HotelQuotationActions.idempotencyKey(quotation),
      );

      if (!result.ok) {
        // The route answered, but not with a send. Leaving the status alone
        // keeps the card honest and lets the desk try again.
        talker.warning(
          'hotel: quotation ${quotation.reference} was not accepted for '
          'delivery to $email',
        );
        notifier.showToast('${quotation.reference} was not sent — try again');
        return QuotationSendResult.failed;
      }

      // Only now is it "sent" — flipping the status before the send would
      // leave a quotation claiming to have reached a guest it never did.
      await saveQuotation(
        quotation.copyWith(
          status: HotelQuotationStatus.sent,
          sentAt: DateTime.now().toUtc(),
        ),
      );
      notifier.showToast('${quotation.reference} emailed to $email');
      return QuotationSendResult.sent;
    } catch (e, st) {
      talker.error('hotel: quotation ${quotation.reference} email failed', e, st);
      notifier.showToast('Could not email ${quotation.reference}: $e');
      return QuotationSendResult.failed;
    }
  }

  /// Accept a quotation and hold the room it priced.
  static Future<void> convertQuotation({
    required WidgetRef ref,
    required HotelQuotation quotation,
    required HotelRoom room,
    required Tenant clerk,
  }) async {
    final notifier = ref.read(hotelModeProvider.notifier);
    try {
      await _sync.convertQuotationToReservation(
        quotation: quotation,
        room: room,
        clerkTenantId: clerk.id,
        clerkName: clerk.name ?? 'Front desk',
      );
      notifier.showToast(
        '${quotation.reference} booked · Room ${room.name} held',
      );
    } on StateError catch (e) {
      notifier.showToast(e.message);
    }
  }

  /// Resume an existing stay (occupied / reserved card tapped).
  static Future<void> openStay({
    required WidgetRef ref,
    required HotelRoom room,
    required HotelStay stay,
  }) async {
    final folio = await _sync.hotelFolio(transactionId: stay.transactionId);
    ref
        .read(hotelModeProvider.notifier)
        .openFolio(room: room, stay: stay, folio: folio);
  }

  static Future<void> addCharge({
    required WidgetRef ref,
    required Variant variant,
    required HotelStay stay,
    required Tenant clerk,
    num qty = 1,
  }) async {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) return;

    await _sync.addChargeToFolio(
      transactionId: stay.transactionId,
      branchId: branchId,
      variantId: variant.id,
      productName: variant.name,
      defaultPrice: variant.retailPrice ?? 0,
      stock: (variant.stock?.currentStock ?? 999).toInt(),
      clerkTenantId: clerk.id,
      clerkName: clerk.name ?? 'Front desk',
      qty: qty,
      color: variant.color,
      sku: variant.sku,
    );
  }

  static Future<void> changeQty({
    required WidgetRef ref,
    required HotelStay stay,
    required TransactionItem line,
    required int delta,
  }) async {
    const stockCap = 999;
    await _sync.setFolioLineQty(
      lineId: line.id,
      transactionId: stay.transactionId,
      qty: line.qty + delta,
      stockCap: stockCap,
    );
  }

  static Future<void> deleteLine({
    required WidgetRef ref,
    required HotelStay stay,
    required TransactionItem line,
  }) async {
    await _sync.deleteFolioLine(
      lineId: line.id,
      transactionId: stay.transactionId,
    );
  }

  /// The folio's own "Room charge" button. Looks the room up so it can be
  /// registered on demand, exactly as check-in does.
  static Future<void> postRoomCharge({
    required WidgetRef ref,
    required HotelStay stay,
    required Tenant clerk,
  }) async {
    final notifier = ref.read(hotelModeProvider.notifier);
    // A room's first charge registers it with RRA, which is a network round
    // trip — long enough that a clerk taps again and bills a second night.
    if (ref.read(hotelModeProvider).roomChargeInFlight) return;
    notifier.beginRoomCharge();

    try {
      final rooms = await _sync.hotelRooms(branchId: stay.branchId);
      HotelRoom? room;
      for (final candidate in rooms) {
        if (candidate.id == stay.roomId) {
          room = candidate;
          break;
        }
      }
      if (room == null) {
        notifier.showToast('Room ${stay.roomName} is no longer on this branch');
        return;
      }
      await chargeRoomToFolio(ref: ref, room: room, stay: stay, clerk: clerk);
    } finally {
      notifier.endRoomCharge();
    }
  }

  static Future<void> cancelStay({
    required WidgetRef ref,
    required HotelStay stay,
  }) async {
    await _sync.cancelHotelStay(stay: stay);
    ref.read(hotelModeProvider.notifier).backToRooms();
  }

  /// Settle the folio and release the room to housekeeping.
  static Future<void> checkOut({
    required WidgetRef ref,
    required HotelStay stay,
    required ITransaction folio,
    required String paymentType,
    required double cashReceived,
    required double customerChangeDue,
  }) async {
    await _sync.refreshFolioSubTotal(transactionId: stay.transactionId);
    final fresh =
        await _sync.hotelFolio(transactionId: stay.transactionId) ?? folio;

    final lines = await _sync.hotelFolioLines(
      transactionId: stay.transactionId,
    );

    // What the receipt is filed against: the folio carries the room and its
    // extras, but the tender only exists at the desk.
    final invoiced = fresh.copyWith(
      paymentType: paymentType,
      cashReceived: cashReceived,
      customerChangeDue: customerChangeDue,
    );

    // Filed and printed before the stay is closed, exactly as bar mode settles
    // a tab. A throw here leaves the guest checked in and the desk able to
    // retry, rather than a released room with no receipt behind it.
    await issueSaleReceipt(
      sync: _sync,
      transaction: invoiced,
      lines: lines,
      receiptContext: 'folio invoice',
    );

    await _sync.checkOutGuest(
      stay: stay,
      transaction: invoiced,
      paymentType: paymentType,
      cashReceived: cashReceived,
      customerChangeDue: customerChangeDue,
    );

    await recordSalePaymentAndScheduleStock(
      sync: _sync,
      transaction: invoiced,
      lines: lines,
      transactionId: stay.transactionId,
      paymentType: paymentType,
      amount: (invoiced.subTotal ?? 0).toDouble(),
    );

    talker.info(
      'hotel: folio ${stay.transactionId} invoiced and settled for '
      '${stay.roomName} (${lines.length} lines, $paymentType)',
    );

    ref
        .read(hotelModeProvider.notifier)
        .afterCheckOut(
          message: 'Room ${stay.roomName} checked out',
          autoLogout: HotelModeSettings.autoLogout,
        );
  }

  static Future<void> setHousekeeping({
    required HotelRoom room,
    required HotelHousekeeping housekeeping,
  }) async {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) return;
    await _sync.setHotelRoomHousekeeping(
      roomId: room.id,
      branchId: branchId,
      housekeeping: housekeeping,
    );
  }
}

/// Why a quotation send did or did not happen.
enum QuotationSendResult {
  sent,

  /// No address on the quotation — prompt for one and retry.
  noEmail,
  failed,
}
