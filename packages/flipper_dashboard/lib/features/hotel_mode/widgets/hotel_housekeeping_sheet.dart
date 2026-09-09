import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_tokens.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_shared_widgets.dart';
import 'package:flipper_models/models/hotel_room.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flipper_models/sync/utils/hotel_mode_utils.dart';
import 'package:google_fonts/google_fonts.dart';

/// One housekeeping choice, with what it means for the desk.
class _HousekeepingOption {
  const _HousekeepingOption({
    required this.value,
    required this.label,
    required this.meaning,
    required this.icon,
    required this.ink,
    required this.tint,
  });

  final HotelHousekeeping value;
  final String label;
  final String meaning;
  final IconData icon;
  final Color ink;
  final Color tint;
}

const _options = <_HousekeepingOption>[
  _HousekeepingOption(
    value: HotelHousekeeping.clean,
    label: 'Clean',
    meaning: 'Ready to sell — the desk can check a guest in.',
    icon: Icons.bed_outlined,
    ink: HotelTokens.vacantInk,
    tint: HotelTokens.vacantTint,
  ),
  _HousekeepingOption(
    value: HotelHousekeeping.dirty,
    label: 'Needs cleaning',
    meaning: 'Held back from sale until housekeeping releases it.',
    icon: Icons.cleaning_services_outlined,
    ink: HotelTokens.dirtyInk,
    tint: HotelTokens.dirtyTint,
  ),
  _HousekeepingOption(
    value: HotelHousekeeping.inspected,
    label: 'Inspected',
    meaning: 'Cleaned and checked by a supervisor. Sellable.',
    icon: Icons.verified_outlined,
    ink: HotelTokens.occupiedInk,
    tint: HotelTokens.occupiedTint,
  ),
  _HousekeepingOption(
    value: HotelHousekeeping.outOfOrder,
    label: 'Out of order',
    meaning: 'Blocked for maintenance. Never offered to a guest.',
    icon: Icons.build_outlined,
    ink: HotelTokens.blockedInk,
    tint: HotelTokens.blockedTint,
  ),
];

/// Housekeeping status picker for a room.
///
/// A dialog on desktop and a sheet on mobile — one widget, so the guard that
/// stops an occupied room being blocked cannot drift between the two.
class HotelHousekeepingSheet extends StatelessWidget {
  const HotelHousekeepingSheet({
    super.key,
    required this.room,
    this.stay,
    this.mobile = false,
  });

  final HotelRoom room;
  final HotelStay? stay;
  final bool mobile;

  static Future<HotelHousekeeping?> show(
    BuildContext context, {
    required HotelRoom room,
    HotelStay? stay,
    required bool mobile,
  }) {
    if (mobile) {
      return showModalBottomSheet<HotelHousekeeping>(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (_) => SafeArea(
          child: HotelHousekeepingSheet(room: room, stay: stay, mobile: true),
        ),
      );
    }
    return showDialog<HotelHousekeeping>(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: HotelHousekeepingSheet(room: room, stay: stay),
        ),
      ),
    );
  }

  /// A guest in the room outranks any housekeeping state, so blocking it would
  /// leave the board claiming the room is both occupied and unsellable.
  bool get _isOccupied => stay?.status == HotelStayStatus.inHouse;

  @override
  Widget build(BuildContext context) {
    final state = hotelRoomState(room: room, stay: stay);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
        color: HotelTokens.surface,
        borderRadius: mobile
            ? const BorderRadius.vertical(
                top: Radius.circular(HotelTokens.mobileSheetRadius),
              )
            : BorderRadius.circular(HotelTokens.mobileSheetRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (mobile) ...[
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: HotelTokens.lineStrong,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 14),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Housekeeping · Room ${room.name}',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                        color: HotelTokens.ink1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${room.roomType} · sleeps ${room.capacity}',
                      style: GoogleFonts.outfit(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: HotelTokens.ink3,
                      ),
                    ),
                  ],
                ),
              ),
              HotelStatePill(state: state),
            ],
          ),
          if (_isOccupied) ...[
            const SizedBox(height: 14),
            _occupiedNotice(),
          ],
          const SizedBox(height: 16),
          for (final option in _options) ...[
            _optionRow(context, option),
            if (option != _options.last) const SizedBox(height: 8),
          ],
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: GoogleFonts.outfit(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: HotelTokens.ink2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _occupiedNotice() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: HotelTokens.occupiedTint,
        borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            size: 17,
            color: HotelTokens.occupiedInk,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              '${stay!.guestName} is in this room. Check them out before '
              'blocking it for maintenance.',
              style: GoogleFonts.outfit(
                fontSize: 12,
                height: 1.35,
                fontWeight: FontWeight.w600,
                color: HotelTokens.occupiedInk,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _optionRow(BuildContext context, _HousekeepingOption option) {
    final isCurrent = option.value == room.housekeeping;
    final disabled =
        _isOccupied && option.value == HotelHousekeeping.outOfOrder;

    return Opacity(
      opacity: disabled ? 0.45 : 1,
      child: Material(
        color: isCurrent ? option.tint : HotelTokens.surface,
        borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
        child: InkWell(
          onTap: disabled ? null : () => Navigator.of(context).pop(option.value),
          borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
              border: Border.all(
                color: isCurrent ? option.ink : HotelTokens.line,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isCurrent ? option.ink : option.tint,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    option.icon,
                    size: 19,
                    color: isCurrent ? Colors.white : option.ink,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option.label,
                        style: GoogleFonts.outfit(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: HotelTokens.ink1,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        disabled
                            ? 'Unavailable while the room is occupied.'
                            : option.meaning,
                        style: GoogleFonts.outfit(
                          fontSize: 11.5,
                          height: 1.3,
                          fontWeight: FontWeight.w500,
                          color: HotelTokens.ink3,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isCurrent) ...[
                  const SizedBox(width: 8),
                  Icon(Icons.check_circle, size: 20, color: option.ink),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
