import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/hotel_mode/providers/hotel_mode_providers.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_tokens.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_shared_widgets.dart';
import 'package:flipper_models/models/hotel_room.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flipper_models/sync/utils/hotel_mode_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

/// One room on the front-desk board.
///
/// The card is state-first: the state strip and pill come from
/// [hotelRoomState], so the desk can never see a "vacant" room that already
/// has a guest in it.
class HotelRoomCard extends StatefulWidget {
  const HotelRoomCard({
    super.key,
    required this.room,
    required this.stay,
    required this.onTap,
    this.onLongPress,
    this.compact = false,
  });

  final HotelRoom room;
  final HotelStay? stay;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool compact;

  @override
  State<HotelRoomCard> createState() => _HotelRoomCardState();
}

class _HotelRoomCardState extends State<HotelRoomCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final state = hotelRoomState(room: widget.room, stay: widget.stay);
    final colors = hotelRoomStateColors(state);
    final blocked = state == HotelRoomState.outOfOrder;

    return MouseRegion(
      cursor: blocked ? SystemMouseCursors.basic : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: blocked ? null : widget.onTap,
        onLongPress: widget.onLongPress,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          padding: EdgeInsets.all(widget.compact ? 12 : 15),
          decoration: BoxDecoration(
            color: HotelTokens.surface,
            borderRadius: BorderRadius.circular(HotelTokens.radiusLg),
            border: Border.all(
              color: _hover && !blocked ? colors.ink : HotelTokens.line,
              width: 1.5,
            ),
            boxShadow: _hover && !blocked
                ? HotelTokens.shadow2
                : HotelTokens.shadow1,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.room.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: widget.compact ? 20 : 23,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        color: HotelTokens.ink1,
                      ),
                    ),
                  ),
                  HotelStatePill(state: state, compact: widget.compact),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${widget.room.roomType} · ${widget.room.capacity} guest'
                '${widget.room.capacity == 1 ? '' : 's'}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: HotelTokens.ink3,
                ),
              ),
              const Spacer(),
              _footer(state, colors.ink),
            ],
          ),
        ),
      ),
    );
  }

  Widget _footer(HotelRoomState state, Color ink) {
    final stay = widget.stay;

    if (stay != null) {
      final due = hotelStayIsDue(stay);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            stay.guestName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: HotelTokens.ink1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            due
                ? 'Due out ${DateFormat('d MMM, HH:mm').format(stay.expectedCheckOutAt.toLocal())}'
                : 'Out ${DateFormat('d MMM').format(stay.expectedCheckOutAt.toLocal())} · ${hotelStaySummary(stay)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: due ? HotelTokens.lossInk : HotelTokens.ink3,
            ),
          ),
        ],
      );
    }

    return Text(
      state == HotelRoomState.outOfOrder
          ? 'Blocked for maintenance'
          : state == HotelRoomState.dirty
          ? 'Awaiting housekeeping'
          : 'RWF ${NumberFormat('#,###').format(widget.room.nightlyRate)} / night',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.outfit(
        fontSize: 12.5,
        fontWeight: FontWeight.w700,
        color: state == HotelRoomState.vacant ? ink : HotelTokens.ink3,
      ),
    );
  }
}
