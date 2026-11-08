part of 'hotel_mixin.dart';

// Stay changes after booking: advances, a new departure, and the room nights
// that follow it. Library-private functions over [CapellaHotelMixin], kept
// here so hotel_mixin.dart stays reviewable; the mixin's overrides delegate.

Future<HotelStay> _hotelSaveAdvance(
  CapellaHotelMixin sync, {
  required String stayId,
  required HotelAdvance advance,
}) async {
  final ditto = sync.dittoHandle;
  if (ditto == null) throw StateError('Ditto not initialized');
  final stay = await sync.hotelStayById(id: stayId);
  if (stay == null) throw StateError('Stay $stayId not found');

  final advances = [...stay.advances];
  final at = advances.indexWhere((existing) => existing.id == advance.id);
  if (at >= 0) {
    advances[at] = advance;
  } else {
    advances.add(advance);
  }

  final updated = stay.copyWith(
    advances: advances,
    updatedAt: DateTime.now().toUtc(),
  );
  // Only this field: see HotelStay.toJson for why advances never ride on a
  // whole-document upsert.
  await ditto.store.execute(
    'UPDATE hotel_stays SET advances = :advances, updatedAt = :updatedAt '
    'WHERE _id = :id',
    arguments: {
      'id': stay.id,
      'advances': updated.advancesJson(),
      'updatedAt': updated.updatedAt!.toIso8601String(),
    },
  );
  return updated;
}

Future<HotelStay> _hotelChangeDeparture(
  CapellaHotelMixin sync, {
  required HotelStay stay,
  required DateTime checkOutAt,
}) async {
  if (!stay.isOpen) {
    throw StateError('This stay is already closed.');
  }
  if (!checkOutAt.isAfter(stay.checkInAt)) {
    throw StateError('Departure must be after arrival.');
  }
  final nights = hotelCalendarNights(stay.checkInAt, checkOutAt);

  // Another booking may already hold the nights being added.
  final others = (await sync.hotelStaysInRange(
    branchId: stay.branchId,
    from: stay.checkInAt,
    to: checkOutAt,
  )).where((other) => other.id != stay.id && other.roomId == stay.roomId);
  if (others.isNotEmpty) {
    throw StateError(
      'Room ${stay.roomName} is booked by ${others.first.guestName} '
      'for some of those nights.',
    );
  }

  final fresh = await sync.hotelStayById(id: stay.id) ?? stay;
  final updated = fresh.copyWith(expectedCheckOutAt: checkOutAt.toUtc());
  await sync.saveHotelStay(updated);

  if (updated.hasFolio) {
    await _hotelResizeRoomNights(sync, stay: updated, nights: nights);
  }
  return updated;
}

/// When [stay]'s folio already bills room nights, bills only the ones still
/// missing (topping the line up) and returns true; throws when none are.
/// Returns false when the folio bills no nights yet.
///
/// A second tap used to add every night again (or, on a non-EBM branch, a
/// whole second line).
Future<bool> _hotelTopUpBilledNights(
  CapellaHotelMixin sync,
  HotelStay stay,
) async {
  final lines = await sync.hotelFolioLines(transactionId: stay.transactionId);
  if (hotelRoomChargeLines(stay, lines).isEmpty) return false;
  final unbilled = stay.nights - hotelBilledNights(stay, lines);
  if (unbilled <= 0) {
    throw StateError(
      'All ${stay.nights} night${stay.nights == 1 ? ' is' : 's are'} '
      'already on the folio. Change the departure date to bill more.',
    );
  }
  await _hotelResizeRoomNights(sync, stay: stay, nights: stay.nights);
  return true;
}

/// Makes the folio's room-night lines add up to [nights], renaming the line
/// it changes so the invoice reads the true count. A folio with no room line
/// is left alone: checkout already offers to post one.
Future<void> _hotelResizeRoomNights(
  CapellaHotelMixin sync, {
  required HotelStay stay,
  required int nights,
}) async {
  final lines = await sync.hotelFolioLines(transactionId: stay.transactionId);
  final roomLines = hotelRoomChargeLines(stay, lines);
  if (roomLines.isEmpty) return;
  final billed = hotelBilledNights(stay, lines);
  if (billed == nights) return;

  // The other room lines stay as they are; the first absorbs the change.
  final first = roomLines.first;
  final target = first.qty + (nights - billed);
  if (target <= 0) {
    throw StateError(
      'The folio bills more nights on other lines than the new stay has. '
      'Remove those lines first.',
    );
  }
  await sync.setFolioLineQty(
    lineId: first.id,
    transactionId: stay.transactionId,
    qty: target,
    stockCap: target,
  );
  final ditto = sync.dittoHandle;
  if (ditto == null) return;
  await ditto.store.execute(
    'UPDATE transaction_items SET name = :name, updatedAt = :updatedAt '
    'WHERE _id = :id',
    arguments: {
      'id': first.id,
      'name': hotelRoomChargeName(
        roomName: stay.roomName,
        nights: target.toInt(),
      ),
      'updatedAt': DateTime.now().toUtc().toIso8601String(),
    },
  );
  cartLineDocCache.forget(stay.transactionId);
}

Future<List<HotelStay>> _hotelCheckedOutStays(
  CapellaHotelMixin sync, {
  required String branchId,
  required DateTime since,
}) async {
  final ditto = sync.dittoHandle;
  if (ditto == null) return const [];
  sync._ensureHotelStaysSync(ditto, branchId);
  final result = await ditto.store.execute(
    'SELECT * FROM hotel_stays WHERE branchId = :branchId '
    "AND status = 'checkedOut'",
    arguments: {'branchId': branchId},
  );
  final cutoff = since.toUtc();
  DateTime left(HotelStay s) => s.checkedOutAt ?? s.expectedCheckOutAt;
  return sync
      ._staysFromResult(result)
      .where((s) => !left(s).isBefore(cutoff))
      .toList()
    ..sort((a, b) => left(b).compareTo(left(a)));
}
