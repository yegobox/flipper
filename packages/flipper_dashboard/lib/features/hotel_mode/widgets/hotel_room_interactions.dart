import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/hotel_mode/hotel_desk_actions.dart';
import 'package:flipper_dashboard/features/hotel_mode/providers/hotel_mode_providers.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_check_in_sheet.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_housekeeping_sheet.dart';
import 'package:flipper_models/models/hotel_room.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flipper_models/sync/utils/hotel_mode_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Shared tap handling so desktop and mobile behave identically:
/// a vacant room opens check-in, an occupied/reserved room opens its folio.
Future<void> hotelHandleRoomTap({
  required BuildContext context,
  required WidgetRef ref,
  required HotelRoom room,
  required List<HotelStay> stays,
  required bool mobile,
}) async {
  final existing = hotelStayForRoom(room, stays);
  if (existing != null) {
    final clerk = ref.read(hotelModeProvider).activeClerk;
    // A reservation has no folio yet, so arriving is a check-in, not a resume.
    if (existing.status == HotelStayStatus.reserved) {
      if (clerk == null) return;
      final confirmed = await _confirmArrival(context, existing);
      if (!confirmed) return;
      await HotelDeskActions.checkInReservation(
        ref: ref,
        room: room,
        stay: existing,
        clerk: clerk,
      );
      return;
    }
    await HotelDeskActions.openStay(ref: ref, room: room, stay: existing);
    return;
  }

  final state = hotelRoomState(room: room, stay: null);
  if (!hotelRoomAcceptsCheckIn(state)) {
    ref
        .read(hotelModeProvider.notifier)
        .showToast('Room ${room.name} is ${hotelRoomStateLabel(state).toLowerCase()}');
    return;
  }

  final clerk = ref.read(hotelModeProvider).activeClerk;
  if (clerk == null) return;

  final draft = await HotelCheckInSheet.show(
    context,
    room: room,
    mobile: mobile,
  );
  if (draft == null) return;

  await HotelDeskActions.checkIn(
    ref: ref,
    room: room,
    clerk: clerk,
    guestName: draft.guestName,
    guestPhone: draft.guestPhone,
    checkInAt: draft.checkInAt,
    expectedCheckOutAt: draft.expectedCheckOutAt,
    nightlyRate: draft.nightlyRate,
    adults: draft.adults,
    children: draft.children,
  );
}

/// Long-press action: move a room through its housekeeping states.
Future<void> hotelShowHousekeepingMenu({
  required BuildContext context,
  required HotelRoom room,
  HotelStay? stay,
  bool mobile = false,
}) async {
  final choice = await HotelHousekeepingSheet.show(
    context,
    room: room,
    stay: stay,
    mobile: mobile,
  );
  if (choice == null || choice == room.housekeeping) return;
  await HotelDeskActions.setHousekeeping(room: room, housekeeping: choice);
}

/// Arriving a reservation opens a billable folio, so it asks first.
Future<bool> _confirmArrival(BuildContext context, HotelStay stay) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(
        'Check in ${stay.guestName}?',
        style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
      ),
      content: Text(
        'Room ${stay.roomName} is reserved for them. Checking in opens the '
        'folio and posts the room charge.',
        style: GoogleFonts.outfit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text('Not yet'),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: const Text('Check in'),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}
