import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/hotel_mode/hotel_desk_actions.dart';
import 'package:flipper_dashboard/features/hotel_mode/providers/hotel_mode_providers.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_layout_breakpoints.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_tokens.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_desk_nav.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_reservation_sheet.dart';
import 'package:flipper_models/models/hotel_room.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flipper_models/sync/utils/hotel_mode_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

/// Availability calendar: rooms down, days across.
///
/// Every cell is a night, coloured by [HotelDayState]. Tapping a free night
/// starts a reservation for that room on that date, which is the only way a
/// future booking gets created.
class HotelCalendarScreen extends ConsumerWidget {
  const HotelCalendarScreen({super.key});

  static const _roomColumnWidth = 150.0;
  static const _rowHeight = 46.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomsAsync = ref.watch(hotelRoomsProvider);
    final stays = ref.watch(hotelStaysProvider).value ?? const <HotelStay>[];
    final anchor = ref.watch(hotelCalendarAnchorProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = HotelLayoutBreakpoints.isHotelMobileLayout(
          constraints.maxWidth,
        );

        // Fill the window rather than stopping at a fixed cell width: pick the
        // number of days that lands nearest the target cell size, then divide
        // the space exactly between them. A wider desk shows more of the month
        // instead of empty grey.
        final available = math.max(
          0.0,
          constraints.maxWidth - _roomColumnWidth,
        );
        final target = compact ? 54.0 : 78.0;
        final minCell = compact ? 44.0 : 56.0;
        final dayCount = (available / target).floor().clamp(
          compact ? 4 : 7,
          31,
        );
        final days = hotelCalendarDays(from: anchor, days: dayCount);
        // Below the minimum the grid scrolls sideways instead of squashing.
        final cellWidth = math.max(minCell, available / dayCount);

        return Container(
          color: HotelTokens.posBg,
          child: Column(
            children: [
              _header(context, ref, days, compact),
              Expanded(
                child: roomsAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('$e')),
                  data: (rooms) => rooms.isEmpty
                      ? _empty()
                      : _grid(
                          context,
                          ref,
                          rooms,
                          stays,
                          days,
                          cellWidth,
                          compact,
                          constraints.maxWidth,
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _header(
    BuildContext context,
    WidgetRef ref,
    List<DateTime> days,
    bool compact,
  ) {
    final anchor = ref.watch(hotelCalendarAnchorProvider);
    final notifier = ref.read(hotelCalendarAnchorProvider.notifier);
    final span = days.length;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 14 : 30,
        vertical: 14,
      ),
      decoration: const BoxDecoration(
        color: HotelTokens.surface,
        border: Border(bottom: BorderSide(color: HotelTokens.line)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) => Row(
              children: [
                HotelDeskNav(compact: compact),
                const Spacer(),
                // The legend is the widest optional item; drop it before the
                // paging controls, which the desk cannot work without.
                if (!compact && constraints.maxWidth >= 900) ...[
                  _legend(),
                  const SizedBox(width: 18),
                ],
                _navButton(Icons.chevron_left, () => notifier.shiftDays(-span)),
                const SizedBox(width: 6),
                _todayButton(notifier),
                const SizedBox(width: 6),
                _navButton(Icons.chevron_right, () => notifier.shiftDays(span)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${DateFormat('d MMM').format(days.first)} — '
            '${DateFormat('d MMM yyyy').format(days.last)}',
            style: GoogleFonts.outfit(
              fontSize: compact ? 16 : 19,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
              color: HotelTokens.ink1,
            ),
          ),
          Text(
            'Tap a free night to hold the room · '
            '${DateFormat('MMMM yyyy').format(anchor)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: HotelTokens.ink3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _legend() {
    Widget dot(Color ink, String label) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: ink,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: HotelTokens.ink3,
          ),
        ),
      ],
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        dot(HotelTokens.vacantInk, 'Free'),
        const SizedBox(width: 14),
        dot(HotelTokens.reservedInk, 'Reserved'),
        const SizedBox(width: 14),
        dot(HotelTokens.occupiedInk, 'In house'),
        const SizedBox(width: 14),
        dot(HotelTokens.blockedInk, 'Blocked'),
      ],
    );
  }

  Widget _navButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: HotelTokens.surface,
      borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
            border: Border.all(color: HotelTokens.line, width: 1.5),
          ),
          child: Icon(icon, size: 19, color: HotelTokens.ink2),
        ),
      ),
    );
  }

  Widget _todayButton(HotelCalendarAnchor notifier) {
    return Material(
      color: HotelTokens.surface,
      borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
      child: InkWell(
        onTap: notifier.today,
        borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
            border: Border.all(color: HotelTokens.line, width: 1.5),
          ),
          child: Text(
            'Today',
            style: GoogleFonts.outfit(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: HotelTokens.ink2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _empty() {
    return Center(
      child: Text(
        'No rooms on this branch yet.',
        style: GoogleFonts.outfit(
          fontSize: 14.5,
          fontWeight: FontWeight.w600,
          color: HotelTokens.ink3,
        ),
      ),
    );
  }

  Widget _grid(
    BuildContext context,
    WidgetRef ref,
    List<HotelRoom> rooms,
    List<HotelStay> stays,
    List<DateTime> days,
    double cellWidth,
    bool compact,
    double viewportWidth,
  ) {
    // One horizontal scroller wrapping both the day header and the body, so
    // the columns cannot drift out of alignment while paging sideways. The
    // grid never renders narrower than the viewport.
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: math.max(
          viewportWidth,
          _roomColumnWidth + cellWidth * days.length,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _dayHeader(rooms, stays, days, cellWidth),
            Expanded(
              child: ListView.builder(
                itemCount: rooms.length,
                itemExtent: _rowHeight,
                itemBuilder: (context, i) => _roomRow(
                  context,
                  ref,
                  rooms[i],
                  stays,
                  days,
                  cellWidth,
                  compact,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dayHeader(
    List<HotelRoom> rooms,
    List<HotelStay> stays,
    List<DateTime> days,
    double cellWidth,
  ) {
    final today = hotelDateOnly(DateTime.now());

    return Container(
      height: 56,
      decoration: const BoxDecoration(
        color: HotelTokens.surface,
        border: Border(bottom: BorderSide(color: HotelTokens.line)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: _roomColumnWidth,
            child: Padding(
              padding: const EdgeInsets.only(left: 14),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Room',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                    color: HotelTokens.ink4,
                  ),
                ),
              ),
            ),
          ),
          for (final day in days)
            SizedBox(
              width: cellWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('E').format(day),
                    style: GoogleFonts.outfit(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: day == today ? HotelTokens.blue : HotelTokens.ink4,
                    ),
                  ),
                  Text(
                    DateFormat('d').format(day),
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: day == today ? HotelTokens.blue : HotelTokens.ink1,
                    ),
                  ),
                  Text(
                    '${hotelFreeRoomCountForDay(rooms: rooms, stays: stays, day: day)} free',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: HotelTokens.ink4,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _roomRow(
    BuildContext context,
    WidgetRef ref,
    HotelRoom room,
    List<HotelStay> stays,
    List<DateTime> days,
    double cellWidth,
    bool compact,
  ) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: HotelTokens.line)),
      ),
      child: Row(
        children: [
          Container(
            width: _roomColumnWidth,
            height: _rowHeight,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            color: HotelTokens.surface,
            child: Row(
              children: [
                Text(
                  room.name,
                  style: GoogleFonts.outfit(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: HotelTokens.ink1,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    room.roomType,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: HotelTokens.ink3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          for (final day in days)
            _cell(context, ref, room, stays, day, cellWidth, compact),
        ],
      ),
    );
  }

  Widget _cell(
    BuildContext context,
    WidgetRef ref,
    HotelRoom room,
    List<HotelStay> stays,
    DateTime day,
    double cellWidth,
    bool compact,
  ) {
    final state = hotelDayState(room: room, stays: stays, day: day);
    final colors = hotelDayStateColors(state);
    final free = state == HotelDayState.free;
    final past = day.isBefore(hotelDateOnly(DateTime.now()));

    HotelStay? occupant;
    for (final stay in stays) {
      if (stay.roomId == room.id && hotelStayCoversDay(stay, day)) {
        occupant = stay;
        break;
      }
    }

    return SizedBox(
      width: cellWidth,
      height: _rowHeight,
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Tooltip(
          message: occupant != null
              ? '${occupant.guestName} · ${DateFormat('d MMM').format(occupant.checkInAt.toLocal())} → '
                    '${DateFormat('d MMM').format(occupant.expectedCheckOutAt.toLocal())}'
              : free
              ? 'Free — tap to hold ${room.name}'
              : 'Blocked for maintenance',
          waitDuration: const Duration(milliseconds: 400),
          child: Material(
            color: free ? HotelTokens.surface : colors.tint,
            borderRadius: BorderRadius.circular(7),
            child: InkWell(
              onTap: (free && !past)
                  ? () => _startReservation(
                      context,
                      ref,
                      room,
                      stays,
                      day,
                      compact,
                    )
                  : null,
              borderRadius: BorderRadius.circular(7),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(
                    color: free ? HotelTokens.line : colors.ink,
                    width: free ? 1 : 1.4,
                  ),
                ),
                alignment: Alignment.center,
                child: occupant == null
                    ? (past
                          ? null
                          : Icon(Icons.add, size: 13, color: HotelTokens.ink4))
                    : Text(
                        compact
                            ? occupant.guestName.characters.first.toUpperCase()
                            : occupant.guestName.split(' ').first,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: colors.ink,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _startReservation(
    BuildContext context,
    WidgetRef ref,
    HotelRoom room,
    List<HotelStay> stays,
    DateTime day,
    bool compact,
  ) async {
    final clerk = ref.read(hotelModeProvider).activeClerk;
    if (clerk == null) return;

    final draft = await HotelReservationSheet.show(
      context,
      room: room,
      initialCheckIn: day,
      clashingStays: stays.where((s) => s.roomId == room.id).toList(),
      mobile: compact,
    );
    if (draft == null) return;

    await HotelDeskActions.reserve(
      ref: ref,
      room: room,
      clerk: clerk,
      draft: draft,
    );
  }
}
