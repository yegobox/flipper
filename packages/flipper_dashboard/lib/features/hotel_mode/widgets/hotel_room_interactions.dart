import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/hotel_mode/hotel_desk_actions.dart';
import 'package:flipper_dashboard/features/hotel_mode/providers/hotel_mode_providers.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_advance_sheet.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_check_in_sheet.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_housekeeping_sheet.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_shared_widgets.dart';
import 'package:flipper_localize/flipper_localize.dart';
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
      final choice = await _confirmArrival(context, existing);
      if (choice == _ArrivalChoice.advance) {
        // A deposit on a booking that has not arrived: the room stays held.
        if (!context.mounted) return;
        final draft = await HotelAdvanceSheet.show(
          context,
          guestName: existing.guestName,
        );
        if (draft == null) return;
        await HotelDeskActions.recordAdvance(
          ref: ref,
          stay: existing,
          clerk: clerk,
          amount: draft.amount,
          paymentMethod: draft.paymentMethod,
        );
        return;
      }
      if (choice != _ArrivalChoice.checkIn) return;
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
    // A phone has no hover hint for the long-press menu, so a tap on a room
    // being cleaned or blocked opens housekeeping instead of a dead-end toast.
    if (mobile) {
      await hotelShowHousekeepingMenu(
        context: context,
        room: room,
        mobile: true,
      );
      return;
    }
    ref
        .read(hotelModeProvider.notifier)
        .showToast(
          context.flipperL10n.hotelRoomIsState(
            room.name,
            hotelRoomStateText(context.flipperL10n, state).toLowerCase(),
          ),
        );
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
    guestEmail: draft.guestEmail,
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

enum _ArrivalChoice { checkIn, advance }

/// Arriving a reservation opens a billable folio, so it asks first. The desk
/// can also take an advance on the booking from here without checking in.
Future<_ArrivalChoice?> _confirmArrival(BuildContext context, HotelStay stay) {
  return showDialog<_ArrivalChoice>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(
        dialogContext.flipperL10n.hotelCheckInGuestQuestion(stay.guestName),
        style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
      ),
      content: Text(
        dialogContext.flipperL10n.hotelReservedArrivalBody(stay.roomName),
        style: GoogleFonts.outfit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text(dialogContext.flipperL10n.hotelNotYet),
        ),
        TextButton(
          key: const ValueKey('hotel-arrival-advance'),
          onPressed: () =>
              Navigator.of(dialogContext).pop(_ArrivalChoice.advance),
          child: Text(dialogContext.flipperL10n.hotelTakeAdvance),
        ),
        TextButton(
          onPressed: () =>
              Navigator.of(dialogContext).pop(_ArrivalChoice.checkIn),
          child: Text(dialogContext.flipperL10n.hotelCheckIn),
        ),
      ],
    ),
  );
}
