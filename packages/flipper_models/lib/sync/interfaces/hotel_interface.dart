import 'dart:async';

import 'package:flipper_models/models/hotel_branch_settings.dart';
import 'package:flipper_models/models/hotel_quotation.dart';
import 'package:flipper_models/models/hotel_room.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';

/// Hotel Mode front-desk service (Capella + Ditto implementation).
///
/// Deliberately mirrors [BarInterface]: rooms play the part of tables, stays
/// the part of tabs, and folio lines the part of tab lines — so the two modes
/// share the same offline-first Ditto shape and the same RRA-safe line path.
abstract class HotelInterface {
  // --- Branch settings (synced across devices) ---

  Future<HotelBranchSettings?> hotelBranchSettings({required String branchId});

  Stream<HotelBranchSettings?> hotelBranchSettingsStream({
    required String branchId,
  });

  Future<void> saveHotelBranchSettings(HotelBranchSettings settings);

  // --- Rooms ---

  Stream<List<HotelRoom>> hotelRoomsStream({required String branchId});

  Future<List<HotelRoom>> hotelRooms({required String branchId});

  Future<void> saveHotelRoom(HotelRoom room);

  Future<void> deleteHotelRoom({required String id, required String branchId});

  Future<void> seedDefaultRooms({required String branchId});

  Future<void> setHotelRoomHousekeeping({
    required String roomId,
    required String branchId,
    required HotelHousekeeping housekeeping,
  });

  // --- Stays (open bookings holding a room) ---

  /// Reserved + in-house stays for the branch.
  Stream<List<HotelStay>> hotelStaysStream({required String branchId});

  Future<List<HotelStay>> hotelStays({required String branchId});

  Future<HotelStay?> hotelStayForRoom({
    required String branchId,
    required String roomId,
  });

  Future<HotelStay?> hotelStayById({required String id});

  Future<void> saveHotelStay(HotelStay stay);

  /// Open a folio and put [guestName] in [room].
  ///
  /// Idempotent per room: an existing open stay is returned untouched so a
  /// double tap at the desk never creates a second folio.
  Future<HotelStay> checkInGuest({
    required String branchId,
    required HotelRoom room,
    required String guestName,
    required DateTime checkInAt,
    required DateTime expectedCheckOutAt,
    required double nightlyRate,
    required String clerkTenantId,
    required String clerkName,
    String? guestPhone,
    int adults = 1,
    int children = 0,
    String? note,
  });

  /// Cancel a reservation / undo a mistaken check-in that has no charges.
  Future<void> cancelHotelStay({required HotelStay stay});

  /// Open + reserved stays touching the half-open range `[from, to)`.
  Future<List<HotelStay>> hotelStaysInRange({
    required String branchId,
    required DateTime from,
    required DateTime to,
  });

  /// Hold [room] for a future arrival.
  ///
  /// Creates no folio — a reservation is not billable until the guest turns up,
  /// and a PARKED transaction per future booking would clutter the ticket list.
  /// Throws [StateError] when the room is already taken for that range.
  Future<HotelStay> reserveRoom({
    required String branchId,
    required HotelRoom room,
    required String guestName,
    required DateTime checkInAt,
    required DateTime expectedCheckOutAt,
    required double nightlyRate,
    required String clerkTenantId,
    required String clerkName,
    String? guestPhone,
    int adults = 1,
    int children = 0,
    String? note,
  });

  /// Turn a reservation into an in-house stay: opens the folio and, when the
  /// branch is configured for it, posts the room charge.
  Future<HotelStay> checkInReservation({
    required HotelStay stay,
    required String clerkTenantId,
    required String clerkName,
  });

  // --- Charging other outlets to a room ---

  /// In-house stays whose folio can take a charge, for a "charge to room"
  /// picker in the bar, restaurant or retail POS.
  Future<List<HotelStay>> chargeableStays({required String branchId});

  /// Moves every line of [cartTransactionId] onto [stay]'s folio and disposes
  /// of the now-empty cart.
  ///
  /// The lines move rather than being re-created, so their RRA fields —
  /// `itemCd`, tax amounts, the lot — survive exactly as the selling outlet
  /// computed them. The guest then leaves with one invoice for the stay
  /// instead of one per outlet.
  ///
  /// Returns the number of lines moved. Throws [StateError] if the stay has no
  /// folio, which is the case for a reservation that has not arrived.
  Future<int> transferCartToFolio({
    required String cartTransactionId,
    required HotelStay stay,
    required String clerkTenantId,
    required String clerkName,
  });

  // --- Quotations ---

  Stream<List<HotelQuotation>> hotelQuotationsStream({
    required String branchId,
  });

  Future<List<HotelQuotation>> hotelQuotations({required String branchId});

  Future<void> saveHotelQuotation(HotelQuotation quotation);

  Future<void> deleteHotelQuotation({
    required String id,
    required String branchId,
  });

  /// Accept [quotation] and hold the room it priced.
  ///
  /// Throws [StateError] if the room was sold to someone else in the meantime.
  Future<HotelStay> convertQuotationToReservation({
    required HotelQuotation quotation,
    required HotelRoom room,
    required String clerkTenantId,
    required String clerkName,
  });

  // --- Folio (charges on the stay's PARKED transaction) ---

  Future<ITransaction?> hotelFolio({required String transactionId});

  /// Open (PARKED) folios for the branch — the manager dashboard's
  /// "pending payments" figure is the sum of their subtotals.
  Future<List<ITransaction>> hotelOpenFolios({required String branchId});

  Stream<List<ITransaction>> hotelOpenFoliosStream({required String branchId});

  Future<List<TransactionItem>> hotelFolioLines({
    required String transactionId,
  });

  Stream<List<TransactionItem>> hotelFolioLinesStream({
    required String transactionId,
  });

  Future<void> addChargeToFolio({
    required String transactionId,
    required String branchId,
    required String variantId,
    required String productName,
    required num defaultPrice,
    required num stock,
    required String clerkTenantId,
    required String clerkName,
    num qty = 1,
    String? color,
    String? sku,
  });

  /// Post `nights × [nightlyRate]` for [stay] using the branch room-charge
  /// product. No-op when the branch has not configured one.
  Future<void> postRoomCharge({
    required HotelStay stay,
    required String clerkTenantId,
    required String clerkName,
  });

  Future<void> setFolioLineQty({
    required String lineId,
    required String transactionId,
    required num qty,
    required num stockCap,
  });

  Future<void> setFolioLinePrice({
    required String lineId,
    required String transactionId,
    required num price,
  });

  Future<void> deleteFolioLine({
    required String lineId,
    required String transactionId,
  });

  Future<void> refreshFolioSubTotal({required String transactionId});

  /// Settle the folio, close the stay and drop the room to `dirty`.
  Future<ITransaction> checkOutGuest({
    required HotelStay stay,
    required ITransaction transaction,
    required String paymentType,
    required double cashReceived,
    required double customerChangeDue,
  });
}
