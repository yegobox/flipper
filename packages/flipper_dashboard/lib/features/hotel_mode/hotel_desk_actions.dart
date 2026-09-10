import 'dart:async';

import 'package:flipper_dashboard/features/hotel_mode/hotel_mode_settings.dart';
import 'package:flipper_dashboard/features/hotel_mode/providers/hotel_mode_providers.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_reservation_sheet.dart';
import 'package:flipper_dashboard/utils/sale_receipt_settlement.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/models/hotel_quotation.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/models/hotel_room.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flipper_models/services/hotel_room_rra_service.dart';
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
      adults: adults,
      children: children,
      note: note,
    );

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
  /// Rooms from the default plan carry no RRA item, so the first guest in one
  /// used to open a folio of zero with no way to bill it short of an admin
  /// visiting Rooms & floors. Registering on first use makes that invisible.
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
        adults: draft.adults,
        children: draft.children,
        note: draft.note,
      );

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

  // --- Quotations ---

  static Future<void> saveQuotation(HotelQuotation quotation) =>
      _sync.saveHotelQuotation(quotation);

  static Future<void> deleteQuotation({required String id}) async {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) return;
    await _sync.deleteHotelQuotation(id: id, branchId: branchId);
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
    final rooms = await _sync.hotelRooms(branchId: stay.branchId);
    HotelRoom? room;
    for (final candidate in rooms) {
      if (candidate.id == stay.roomId) {
        room = candidate;
        break;
      }
    }
    if (room == null) {
      ref
          .read(hotelModeProvider.notifier)
          .showToast('Room ${stay.roomName} is no longer on this branch');
      return;
    }
    await chargeRoomToFolio(ref: ref, room: room, stay: stay, clerk: clerk);
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
