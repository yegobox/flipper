part of 'hotel_mixin.dart';

// Stay changes after booking: advances, a new departure, and the room nights
// that follow it. Library-private functions over [CapellaHotelMixin], kept
// here so hotel_mixin.dart stays reviewable; the mixin's overrides delegate.

Future<HotelStay> _hotelSaveAdvance(
  CapellaHotelMixin sync, {
  required String stayId,
  required HotelAdvance advance,
}) => _hotelSaveAdvances(sync, stayId: stayId, advances: [advance]);

/// Writes [advances] (new, or replacing the entry with the same id) onto the
/// stay in one UPDATE, so a settlement's advances change status together or
/// not at all.
Future<HotelStay> _hotelSaveAdvances(
  CapellaHotelMixin sync, {
  required String stayId,
  required List<HotelAdvance> advances,
}) async {
  final ditto = sync.dittoHandle;
  if (ditto == null) throw StateError('Ditto not initialized');
  final stay = await sync.hotelStayById(id: stayId);
  if (stay == null) throw StateError('Stay $stayId not found');

  final merged = [...stay.advances];
  for (final advance in advances) {
    final at = merged.indexWhere((existing) => existing.id == advance.id);
    if (at >= 0) {
      merged[at] = advance;
    } else {
      merged.add(advance);
    }
  }

  final updated = stay.copyWith(
    advances: merged,
    updatedAt: DateTime.now().toUtc(),
  );
  // Only this field: see HotelStay.toJson for why advances never ride on a
  // whole-document upsert. Matched exactly as [hotelStayById] found it, so a
  // stay whose `id` and `_id` differ is still the one written.
  await ditto.store.execute(
    'UPDATE hotel_stays SET advances = :advances, updatedAt = :updatedAt '
    'WHERE _id = :id OR id = :id',
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
  // Everything below is judged on the stay as stored, not the screen's copy:
  // another terminal may have checked the guest out (a receipted folio must
  // not be resized) or checked a reservation in on a different arrival.
  final fresh = await sync.hotelStayById(id: stay.id) ?? stay;
  if (!fresh.isOpen) {
    throw StateError('This stay is already closed.');
  }
  if (!checkOutAt.isAfter(fresh.checkInAt)) {
    throw StateError('Departure must be after arrival.');
  }
  final nights = hotelCalendarNights(fresh.checkInAt, checkOutAt);

  // Another booking may already hold the nights being added.
  final others = (await sync.hotelStaysInRange(
    branchId: fresh.branchId,
    from: fresh.checkInAt,
    to: checkOutAt,
  )).where((other) => other.id != fresh.id && other.roomId == fresh.roomId);
  if (others.isNotEmpty) {
    throw StateError(
      'Room ${fresh.roomName} is booked by ${others.first.guestName} '
      'for some of those nights.',
    );
  }

  // Stamped with the write's time, so a stream copy from before this change
  // is older and cannot put the old departure back on the folio screen.
  final updated = fresh.copyWith(
    expectedCheckOutAt: checkOutAt.toUtc(),
    updatedAt: DateTime.now().toUtc(),
  );

  // Checked before anything is saved: a folio that cannot take the new night
  // count must leave the departure as it was, not half-changed.
  final resize = updated.hasFolio
      ? await _hotelPlanRoomNights(sync, stay: updated, nights: nights)
      : null;
  await sync.saveHotelStay(updated);

  if (resize != null) {
    await _hotelApplyRoomNights(sync, stay: updated, plan: resize);
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
  final plan = await _hotelPlanRoomNights(sync, stay: stay, nights: nights);
  if (plan == null) return;
  await _hotelApplyRoomNights(sync, stay: stay, plan: plan);
}

/// The room line to change and its new quantity, or null when nothing needs
/// changing (no room line, or already [nights]). Throws when the other room
/// lines alone bill more than [nights].
Future<({TransactionItem line, num qty})?> _hotelPlanRoomNights(
  CapellaHotelMixin sync, {
  required HotelStay stay,
  required int nights,
}) async {
  final lines = await sync.hotelFolioLines(transactionId: stay.transactionId);
  final roomLines = hotelRoomChargeLines(stay, lines);
  if (roomLines.isEmpty) return null;
  final billed = hotelBilledNights(stay, lines);
  if (billed == nights) return null;

  // The other room lines stay as they are; the first absorbs the change.
  final first = roomLines.first;
  final target = first.qty + (nights - billed);
  if (target <= 0) {
    throw StateError(
      'The folio bills more nights on other lines than the new stay has. '
      'Remove those lines first.',
    );
  }
  return (line: first, qty: target);
}

Future<void> _hotelApplyRoomNights(
  CapellaHotelMixin sync, {
  required HotelStay stay,
  required ({TransactionItem line, num qty}) plan,
}) async {
  final ditto = sync.dittoHandle;
  if (ditto == null) return;
  final line = plan.line;
  // A line posted without tax codes (a branch off EBM whose room item could
  // not be made) keeps none: repricing it would assume 18% VAT it never had.
  // Whatever amounts it does store are scaled with it, so they never
  // describe the old night count.
  final unfiscalised = line.taxTyCd == null;
  final scale = line.qty == 0 ? 1 : plan.qty / line.qty;
  final scaled = <String, num>{
    if (unfiscalised)
      for (final (field, value) in [
        ('taxAmt', line.taxAmt),
        ('taxblAmt', line.taxblAmt),
        ('totAmt', line.totAmt),
      ])
        if (value != null) field: value * scale,
  };
  if (!unfiscalised) {
    await sync.setFolioLineQty(
      lineId: line.id,
      transactionId: stay.transactionId,
      qty: plan.qty,
      stockCap: plan.qty,
    );
  }
  await ditto.store.execute(
    'UPDATE transaction_items SET name = :name, '
    '${unfiscalised ? 'qty = :qty, ' : ''}'
    '${scaled.keys.map((f) => '$f = :$f, ').join()}'
    'updatedAt = :updatedAt '
    'WHERE _id = :id',
    arguments: {
      'id': line.id,
      'name': hotelRoomChargeName(
        roomName: stay.roomName,
        nights: plan.qty.toInt(),
      ),
      if (unfiscalised) 'qty': plan.qty,
      ...scaled,
      'updatedAt': DateTime.now().toUtc().toIso8601String(),
    },
  );
  cartLineDocCache.forget(stay.transactionId);
  if (unfiscalised) {
    await sync.refreshFolioSubTotal(transactionId: stay.transactionId);
  }
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
      // An advance still held after checkout is money not yet accounted for:
      // it stays listed, with its Apply action, however long ago they left.
      .where((s) => s.hasHeldAdvance || !left(s).isBefore(cutoff))
      .toList()
    ..sort((a, b) => left(b).compareTo(left(a)));
}
