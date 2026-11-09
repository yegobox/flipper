import 'dart:async';

import 'package:flipper_dashboard/features/bar_mode/bar_credit.dart';
import 'package:flipper_dashboard/features/hotel_mode/hotel_mode_settings.dart';
import 'package:flipper_dashboard/features/hotel_mode/providers/hotel_mode_providers.dart';
import 'package:flipper_dashboard/features/hotel_mode/services/hotel_quotation_actions.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_folio_widgets.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_reservation_sheet.dart';
import 'package:flipper_dashboard/utils/sale_receipt_settlement.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helpers/cash_movement_rules.dart';
import 'package:flipper_models/models/hotel_quotation.dart';
import 'package:flipper_models/helperModels/sale_completion_helpers.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/notifications_client.dart';
import 'package:flipper_models/models/hotel_room.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flipper_models/services/hotel_room_rra_service.dart';
import 'package:flipper_models/sync/utils/hotel_mode_utils.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/payment_methods.dart';
import 'package:flipper_services/notifications/notifications_host.dart';
import 'package:flipper_services/notifications/booking_notification_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/repository/storage.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';
import 'package:supabase_models/brick/models/variant.model.dart';
import 'package:uuid/uuid.dart';

/// Shared front-desk mutations used by both the desktop and mobile layouts.
///
/// Screens stay declarative; every write goes through here so the desktop and
/// mobile shells can never drift apart in behaviour.
abstract final class HotelDeskActions {
  static DatabaseSyncInterface get _sync =>
      ProxyService.getStrategy(Strategy.capella);

  static LocalStorage get _box => ProxyService.box;

  /// Wire values of the tenders an advance can be paid with — the same three
  /// the checkout takes.
  static const advanceMethods = ['Cash', kMobileMoney, 'DEBIT&CREDIT CARD'];

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
    final branchId = _box.getBranchId();
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
          .showToast(FlipperL10n.current.hotelAutoRoomChargeOff);
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
      notifier.showToast(
        FlipperL10n.current.hotelRoomChargeNotPosted(e.toString()),
      );
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
    final branchId = _box.getBranchId();
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
          .showToast(
            FlipperL10n.current.hotelRoomHeldFor(room.name, draft.guestName),
          );
      if (draft.advanceAmount > 0) {
        // The booking stands whatever happens here: a failed advance is
        // reported by recordAdvance and can be taken again from the room.
        return await recordAdvance(
              ref: ref,
              stay: stay,
              clerk: clerk,
              amount: draft.advanceAmount,
              paymentMethod: draft.advancePaymentMethod,
            ) ??
            stay;
      }
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
          notifier.showToast(FlipperL10n.current.hotelSmsOutOfCredits);
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
    final branchId = _box.getBranchId();
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
      final bytes = await HotelQuotationActions.buildPdf(
        quotation,
        awaitFreshNames: true,
      );

      // Same connector and bearer token as the payment rails.
      final client = await createBranchNotificationsClient();

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
        notifier.showToast(
          FlipperL10n.current.hotelQuotationNotSent(quotation.reference),
        );
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
      notifier.showToast(
        FlipperL10n.current.hotelQuotationEmailed(quotation.reference, email),
      );
      return QuotationSendResult.sent;
    } catch (e, st) {
      talker.error(
        'hotel: quotation ${quotation.reference} email failed',
        e,
        st,
      );
      notifier.showToast(
        FlipperL10n.current.hotelQuotationEmailFailed(
          quotation.reference,
          e.toString(),
        ),
      );
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
        FlipperL10n.current.hotelQuotationBooked(
          quotation.reference,
          room.name,
        ),
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
    final branchId = _box.getBranchId();
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
        notifier.showToast(
          FlipperL10n.current.hotelRoomNoLongerOnBranch(stay.roomName),
        );
        return;
      }
      await chargeRoomToFolio(ref: ref, room: room, stay: stay, clerk: clerk);
    } finally {
      notifier.endRoomCharge();
    }
  }

  /// The folio's lines as stored now, not as last streamed to the screen —
  /// used to re-total after posting a charge mid-checkout.
  static Future<List<TransactionItem>> folioLines(HotelStay stay) =>
      _sync.hotelFolioLines(transactionId: stay.transactionId);

  /// The folio [stay] bills to, read from the store now.
  ///
  /// Not cached on purpose: a folio older than the local history window can
  /// still be syncing down when its room is opened, and a remembered miss
  /// kept the desk from ever checking that guest out.
  static Future<ITransaction?> folio(HotelStay stay) =>
      _sync.hotelFolio(transactionId: stay.transactionId);

  static Future<void> cancelStay({
    required WidgetRef ref,
    required HotelStay stay,
  }) async {
    // Refund policy: a cancelled booking hands its advance back. Done first,
    // so a refund that fails leaves the booking (and the advance) in place
    // for the desk to retry, rather than a cancelled stay still holding money.
    await refundAdvances(stay: stay);
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

    // Advances as stored now: one may have been taken on another terminal
    // since this folio was opened.
    final live = await _sync.hotelStayById(id: stay.id) ?? stay;
    // The dialog asked for the balance net of [stay]'s advances. If they have
    // changed since, the tender and change it confirmed are for another
    // amount: show the desk the new balance and let it confirm again, before
    // anything is filed.
    if ((live.advanceHeld - stay.advanceHeld).abs() >= 0.5) {
      ref.read(hotelModeProvider.notifier).updateActiveStay(live);
      throw StateError(FlipperL10n.current.hotelAdvanceChangedReconfirm);
    }
    final hasAdvance = live.hasHeldAdvance;
    final total = (fresh.subTotal ?? 0).toDouble();
    final plan = HotelAdvanceSettlement.of(
      total: total,
      held: live.advanceHeld,
    );
    // An advance that covers the whole folio leaves nothing to tender: the
    // sale is filed under the method the advance was paid with.
    final tender = !hasAdvance || plan.balance > 0
        ? paymentType
        : live.advances.firstWhere((a) => a.isHeld).paymentMethod;

    // What the sale was paid with: today's tender plus the advance applied
    // to it, so a folio the advance part-paid reads as paid in full (and can
    // be refunded like any paid sale). Today's money is still only the
    // tender: the payment rows below carry the balance alone.
    final received = cashReceived + (hasAdvance ? plan.applied : 0);

    // What the receipt is filed against: the folio carries the room and its
    // extras, but the tender only exists at the desk.
    final invoiced = fresh.copyWith(
      paymentType: tender,
      cashReceived: received,
      customerChangeDue: customerChangeDue,
    );

    // Booked, filed and printed before the stay is closed, exactly as bar mode
    // settles a tab. A throw here leaves the guest checked in and the desk able
    // to retry, rather than a released room with no receipt behind it.
    await finalizeServiceModeSale(
      sync: _sync,
      transaction: invoiced,
      lines: lines,
      transactionId: stay.transactionId,
      // Only money taken today: the advance was counted the day it came in,
      // and is applied below. Without one this is the whole folio, as ever.
      payments: [
        if (!hasAdvance)
          PaymentLineForSaleCompletion(
            amount: (invoiced.subTotal ?? 0).toDouble(),
            method: paymentType,
          )
        else if (plan.balance > 0)
          PaymentLineForSaleCompletion(
            amount: plan.balance,
            method: paymentType,
          ),
      ],
      receiptContext: 'folio invoice',
      complete: (booked) => _sync.checkOutGuest(
        stay: live,
        transaction: booked,
        lines: lines,
        paymentType: tender,
        cashReceived: received,
        customerChangeDue: customerChangeDue,
      ),
    );

    final warning = hasAdvance
        ? await _applyAdvancesAfterSettle(
            stay: live,
            total: total,
            tender: tender,
            only: {
              for (final a in live.advances)
                if (a.isHeld) a.id,
            },
          )
        : null;

    talker.info(
      'hotel: folio ${stay.transactionId} invoiced and settled for '
      '${stay.roomName} (${lines.length} lines, $paymentType)',
    );

    ref
        .read(hotelModeProvider.notifier)
        .afterCheckOut(
          // A failed application outranks the success line: it is the only
          // place the desk learns the advance still waits in Billing.
          message:
              warning ?? FlipperL10n.current.hotelRoomCheckedOut(stay.roomName),
          autoLogout: HotelModeSettings.autoLogout,
        );
  }

  // --- Credit (ideni) ---

  /// Closes the stay with the folio on credit: receipted to [terms]' customer
  /// now, collected later from the Credit list.
  ///
  /// The same loan Bar Mode and the POS park: revenue and the receipt land
  /// today, and installments only record money. A held advance is a first
  /// payment on it, so the guest owes only the rest.
  static Future<void> checkOutOnCredit({
    required WidgetRef ref,
    required HotelStay stay,
    required ITransaction folio,
    required BarCreditTerms terms,
  }) async {
    await _sync.refreshFolioSubTotal(transactionId: stay.transactionId);
    final fresh =
        await _sync.hotelFolio(transactionId: stay.transactionId) ?? folio;
    final lines = await _sync.hotelFolioLines(
      transactionId: stay.transactionId,
    );
    final total = (fresh.subTotal ?? 0).toDouble();
    // Before anything is filed: an empty folio must not reach RRA.
    if (lines.isEmpty || total <= 0) {
      throw StateError(FlipperL10n.current.hotelCreditEmptyFolio);
    }

    final live = await _sync.hotelStayById(id: stay.id) ?? stay;
    final held = live.advances.where((a) => a.isHeld).toList();
    final plan = HotelAdvanceSettlement.of(
      total: total,
      held: live.advanceHeld,
    );
    if (plan.balance <= 0) {
      // Nothing would be owed: this is an ordinary checkout.
      throw StateError(FlipperL10n.current.hotelCreditNothingOwed);
    }

    final customer = terms.customer;
    final phone = (customer.telNo ?? '').replaceAll(RegExp(r'\D'), '');
    // The receipt reads the buyer's phone from the box, as Bar's credit does.
    _box.writeString(key: 'currentSaleCustomerPhoneNumber', value: phone);
    final booked = fresh.copyWith(
      subTotal: total,
      cashReceived: 0,
      customerChangeDue: 0,
      paymentType: BarCredit.tender,
      customerId: customer.id,
      customerName: terms.customerName,
      customerPhone: phone,
    );

    await finalizeServiceModeSale(
      sync: _sync,
      transaction: booked,
      lines: lines,
      transactionId: stay.transactionId,
      // Each advance under the method it came in by, then what is owed.
      payments: [
        for (final advance in held)
          PaymentLineForSaleCompletion(
            amount: advance.amount,
            method: advance.paymentMethod,
          ),
        PaymentLineForSaleCompletion(
          amount: plan.balance,
          method: BarCredit.tender,
        ),
      ],
      receiptContext: 'folio credit',
      complete: (invoiced) async {
        final loan = await _sync.parkBarTabAsLoan(
          transaction: invoiced,
          lines: lines,
          customerId: customer.id,
          customerName: terms.customerName,
          customerPhone: phone,
          dueDate: terms.dueDate,
          note: hotelCreditNote(live),
          alreadyPaid: plan.applied,
        );
        await _sync.releaseHotelStay(stay: live);
        return loan;
      },
    );

    final warning = held.isNotEmpty
        ? await _applyAdvancesAfterSettle(
            stay: live,
            total: total,
            tender: null,
            only: {for (final a in held) a.id},
          )
        : null;

    talker.info(
      'hotel: folio ${stay.transactionId} put on credit for '
      '${terms.customerName} (${stay.roomName}, owes ${plan.balance})',
    );
    ref
        .read(hotelModeProvider.notifier)
        .afterCheckOut(
          message:
              warning ??
              FlipperL10n.current.hotelCheckedOutOnCredit(
                stay.roomName,
                terms.customerName,
                hotelMoney(plan.balance.round()),
              ),
          autoLogout: HotelModeSettings.autoLogout,
        );
  }

  // --- Advances ---

  /// Takes money from a guest towards [stay] before it is invoiced.
  ///
  /// The money is a Cash Book "Booking advance" today, the day it is paid, so
  /// the drawer and the books agree tonight. It is not a sale: checkout
  /// invoices the whole stay and deducts it.
  static Future<HotelStay?> recordAdvance({
    required WidgetRef ref,
    required HotelStay stay,
    required Tenant clerk,
    required double amount,
    required String paymentMethod,
  }) async {
    final notifier = ref.read(hotelModeProvider.notifier);
    if (amount <= 0) return null;
    try {
      // Checked before any money is recorded: the sheet may have stayed open
      // while another terminal cancelled the booking or checked the guest
      // out, and an advance on a closed stay is never applied or refunded.
      final live = await _sync.hotelStayById(id: stay.id);
      if (live == null || !live.isOpen) {
        throw StateError(FlipperL10n.current.hotelAdvanceStayClosed);
      }
      final movement = await _advanceMovement(
        stay: stay,
        amount: amount,
        kind: kBookingAdvance,
        paymentMethod: paymentMethod,
      );
      final updated = await _sync.saveHotelAdvance(
        stayId: stay.id,
        advance: HotelAdvance(
          id: const Uuid().v4(),
          amount: amount,
          paymentMethod: paymentMethod,
          paidAt: DateTime.now().toUtc(),
          clerkTenantId: clerk.id,
          clerkName: clerk.name ?? 'Front desk',
          cashMovementId: movement.id,
        ),
      );
      notifier.updateActiveStay(updated);
      notifier.showToast(
        FlipperL10n.current.hotelAdvanceRecorded(
          hotelMoney(amount.round()),
          stay.guestName,
        ),
      );
      return updated;
    } catch (e, st) {
      talker.error('hotel: advance for ${stay.roomName} failed', e, st);
      notifier.showToast(
        FlipperL10n.current.hotelAdvanceFailed(
          e is StateError ? e.message : '$e',
        ),
      );
      return null;
    }
  }

  /// Hands every advance still held on [stay] back to the guest, one Cash
  /// Book "Booking advance refunded" per advance, each in the method it was
  /// paid with. Safe to call again: a refunded advance is never refunded twice.
  static Future<HotelStay> refundAdvances({required HotelStay stay}) async {
    var current = await _sync.hotelStayById(id: stay.id) ?? stay;
    for (final advance in current.advances.where((a) => a.isHeld).toList()) {
      final movement = await _advanceMovement(
        stay: current,
        amount: advance.amount,
        kind: kBookingAdvanceRefunded,
        paymentMethod: advance.paymentMethod,
      );
      current = await _sync.saveHotelAdvance(
        stayId: current.id,
        advance: advance.copyWith(
          status: HotelAdvanceStatus.refunded,
          settlementMovementId: movement.id,
        ),
      );
    }
    return current;
  }

  /// Applies [stay]'s held advances to its settled folio of [total].
  ///
  /// Writes a Cash Book "Booking advance applied" that leaves the drawer
  /// alone (the money was counted the day it came in), refunds any surplus,
  /// and marks the advances applied. With a [tender] the application is
  /// booked under it, netting against a sale filed under that tender;
  /// without one (a credit checkout) each advance is booked under its own
  /// method, netting against the payment row written for it.
  ///
  /// Safe to call again: only advances still held are touched, so a stay
  /// whose checkout went through but whose advances did not can be healed.
  static Future<HotelStay> settleHeldAdvances({
    required HotelStay stay,
    required double total,
    required String? tender,

    /// The advances a checkout netted its balance against. One taken on
    /// another terminal after that read was not deducted from what the guest
    /// paid, so it is left held (and listed in Billing) rather than applied
    /// to a sale already settled in full.
    Set<String>? only,
  }) async {
    var current = await _sync.hotelStayById(id: stay.id) ?? stay;
    final held = [
      for (final a in current.advances)
        if (a.isHeld && (only == null || only.contains(a.id))) a,
    ];
    if (held.isEmpty) return current;
    final plan = HotelAdvanceSettlement.of(
      total: total,
      held: held.fold<double>(0, (sum, a) => sum + a.amount),
    );

    final settledBy = <String, String>{};
    if (plan.applied > 0) {
      if (tender != null) {
        final movement = await _advanceMovement(
          stay: current,
          amount: plan.applied,
          kind: kBookingAdvanceApplied,
          paymentMethod: tender,
          updateShift: false,
        );
        for (final advance in held) {
          settledBy[advance.id] = movement.id;
        }
      } else {
        // Each advance in its own method, oldest first, and never more than
        // the folio: what exceeds it is the surplus refunded below.
        var left = plan.applied;
        for (final advance in held) {
          if (left < 0.5) break;
          final amount = advance.amount < left ? advance.amount : left;
          left -= amount;
          final movement = await _advanceMovement(
            stay: current,
            amount: amount,
            kind: kBookingAdvanceApplied,
            paymentMethod: advance.paymentMethod,
            updateShift: false,
          );
          settledBy[advance.id] = movement.id;
        }
      }
    }
    // The surplus goes back the way it came: the latest advances are the
    // ones not needed, each refunded in the method it was paid with.
    for (final part in hotelAdvanceSurplusByMethod(held, plan.surplus)) {
      final refund = await _advanceMovement(
        stay: current,
        amount: part.amount,
        kind: kBookingAdvanceRefunded,
        paymentMethod: part.method,
      );
      for (final id in part.advanceIds) {
        settledBy.putIfAbsent(id, () => refund.id);
      }
    }

    // Nothing to apply it to (a folio of zero): it all went back.
    final status = plan.applied > 0
        ? HotelAdvanceStatus.applied
        : HotelAdvanceStatus.refunded;
    // One write for all of them: a retry after a failure here finds them all
    // still held, never some settled and the rest settled a second time.
    return _sync.saveHotelAdvances(
      stayId: current.id,
      advances: [
        for (final advance in held)
          advance.copyWith(
            status: status,
            settlementMovementId: settledBy[advance.id],
          ),
      ],
    );
  }

  /// [settleHeldAdvances] after a checkout that already went through. A
  /// failure here must not look like a failed checkout — the guest has paid
  /// and left — so it is logged and returned as the warning the checkout
  /// shows instead of its success line, telling the desk to apply it from
  /// Billing. Null when the advances were applied.
  static Future<String?> _applyAdvancesAfterSettle({
    required HotelStay stay,
    required double total,
    required String? tender,
    required Set<String> only,
  }) async {
    try {
      await settleHeldAdvances(
        stay: stay,
        total: total,
        tender: tender,
        only: only,
      );
      return null;
    } catch (e, st) {
      talker.error(
        'hotel: advances on ${stay.roomName} not applied after checkout',
        e,
        st,
      );
      return FlipperL10n.current.hotelAdvanceNotApplied(stay.guestName);
    }
  }

  /// The tender [settleHeldAdvances] books a settled [folio]'s advances
  /// under: the sale's own for a paid checkout; none for a credit checkout,
  /// whose advances were payment rows in their own methods. A credit folio
  /// stays a credit checkout after the loan is paid off (when `isLoan` is
  /// cleared and the last installment's tender replaces `CREDIT`): its due
  /// date, which only a loan is given, still says so.
  static String? advanceTenderFor(ITransaction folio) {
    final wasCredit = folio.isLoan == true || folio.dueDate != null;
    return wasCredit ? null : folio.paymentType;
  }

  static Future<ITransaction> _advanceMovement({
    required HotelStay stay,
    required double amount,
    required String kind,
    required String paymentMethod,
    bool updateShift = true,
  }) async {
    final income = kind == kBookingAdvance;
    return _sync.completeCashMovement(
      branchId: stay.branchId,
      bhfId: (await _box.bhfId()) ?? '00',
      cashReceived: amount,
      isIncome: income,
      utilityVariantName: income
          ? TransactionType.cashIn
          : TransactionType.cashOut,
      paymentType: paymentMethod,
      discount: 0,
      countryCode: 'N/A',
      isProformaMode: _box.isProformaMode(),
      isTrainingMode: _box.isTrainingMode(),
      transactionTypeForRecord: kind,
      note: hotelAdvanceNote(stay),
      // A deposit owed back to the guest until checkout, not income.
      skipPersonalGoalAutoSweep: true,
      // The drawer only moves for cash: close-shift deducts non-cash tenders
      // from sales alone, so a card or MoMo advance counted here would be
      // expected in the drawer.
      updateShift: updateShift && hotelTenderIsCash(paymentMethod),
    );
  }

  // --- Departure ---

  /// Moves [stay]'s departure, re-billing the room nights to match.
  static Future<HotelStay?> changeDeparture({
    required WidgetRef ref,
    required HotelStay stay,
    required DateTime checkOutAt,
  }) async {
    final notifier = ref.read(hotelModeProvider.notifier);
    try {
      final updated = await _sync.changeHotelStayDeparture(
        stay: stay,
        checkOutAt: checkOutAt,
      );
      notifier.updateActiveStay(updated);
      notifier.showToast(
        FlipperL10n.current.hotelDepartureChanged(
          stay.roomName,
          FlipperL10n.current.hotelNightsCount(updated.nights),
        ),
      );
      return updated;
    } on StateError catch (e) {
      notifier.showToast(e.message);
      return null;
    }
  }

  static Future<void> setHousekeeping({
    required HotelRoom room,
    required HotelHousekeeping housekeeping,
  }) async {
    final branchId = _box.getBranchId();
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
