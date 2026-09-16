import 'package:flipper_dashboard/features/bar_mode/theme/bar_tokens.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flipper_models/sync/utils/hotel_mode_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// "Charge to room" tender on the settle screen.
///
/// Full width rather than a third square beside Cash and Mobile Money: it is
/// not a way of taking money, it is a way of *not* taking it now, and it has a
/// guest to name once chosen.
class BarRoomChargeTile extends StatelessWidget {
  const BarRoomChargeTile({
    super.key,
    required this.selected,
    required this.stay,
    required this.onTap,
  });

  final bool selected;

  /// The guest picked so far — null until the picker has been through.
  final HotelStay? stay;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ink = selected ? BarTokens.violet : BarTokens.ink3;
    final chosen = stay;

    return Material(
      color: selected ? BarTokens.violetTint : BarTokens.surface,
      borderRadius: BorderRadius.circular(BarTokens.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(BarTokens.radiusMd),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(BarTokens.radiusMd),
            border: Border.all(
              color: selected ? BarTokens.violet : BarTokens.line,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.hotel_outlined, size: 22, color: ink),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Charge to room',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: selected ? BarTokens.violet : BarTokens.ink2,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      chosen == null
                          ? 'Bill a guest staying with us'
                          : hotelRoomChargeTarget(chosen),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w600,
                        fontSize: 12.5,
                        color: chosen == null ? BarTokens.ink3 : ink,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                chosen == null ? 'Choose' : 'Change',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w700,
                  fontSize: 12.5,
                  color: BarTokens.violet,
                ),
              ),
              const SizedBox(width: 2),
              const Icon(
                Icons.chevron_right,
                size: 18,
                color: BarTokens.violet,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
