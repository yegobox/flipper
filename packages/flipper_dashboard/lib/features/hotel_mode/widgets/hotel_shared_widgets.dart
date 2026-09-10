import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/hotel_mode/providers/hotel_mode_providers.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_tokens.dart';
import 'package:flipper_dashboard/widgets/pos_handoff_icon.dart';
import 'package:flipper_models/sync/utils/hotel_mode_utils.dart';
import 'package:google_fonts/google_fonts.dart';

/// Same mark + wordmark as the POS shell and Bar Mode header.
class HotelDeskBrand extends StatelessWidget {
  const HotelDeskBrand({
    super.key,
    this.logoSize = 30,
    this.wordmarkSize = 19,
    this.gap = 11,
  });

  final double logoSize;
  final double wordmarkSize;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PosHandoffIcons.svg('flipper-logo', size: logoSize),
        SizedBox(width: gap),
        Text(
          'FLIPPER',
          style: GoogleFonts.outfit(
            fontSize: wordmarkSize,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.01,
            color: HotelTokens.ink1,
          ),
        ),
      ],
    );
  }
}

/// Status pill for a room card / folio header.
class HotelStatePill extends StatelessWidget {
  const HotelStatePill({super.key, required this.state, this.compact = false});

  final HotelRoomState state;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = hotelRoomStateColors(state);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 3 : 4.5,
      ),
      decoration: BoxDecoration(
        color: colors.tint,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: compact ? 6 : 7,
            height: compact ? 6 : 7,
            decoration: BoxDecoration(
              color: colors.ink,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: compact ? 5 : 6),
          Text(
            hotelRoomStateLabel(state),
            style: GoogleFonts.outfit(
              fontSize: compact ? 10.5 : 11.5,
              fontWeight: FontWeight.w700,
              color: colors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

/// One counter in the header strip ("12 Vacant").
class HotelStatChip extends StatelessWidget {
  const HotelStatChip({
    super.key,
    required this.label,
    required this.value,
    required this.ink,
    required this.tint,
  });

  final String label;
  final int value;
  final Color ink;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$value',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: ink,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: ink,
            ),
          ),
        ],
      ),
    );
  }
}

/// Avatar + name chip for the clerk on duty.
class HotelClerkChip extends StatelessWidget {
  const HotelClerkChip({
    super.key,
    required this.name,
    required this.role,
    required this.color,
  });

  final String name;
  final String role;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            hotelClerkInitials(name),
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Staff names and role labels are user data, so they get a ceiling
        // rather than being allowed to widen the header that hosts them.
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 170),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: HotelTokens.ink1,
                ),
              ),
              Text(
                role,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: HotelTokens.ink3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Pill-shaped floor selector, mirroring the Bar Mode zone tab bar.
class HotelFloorTabBar extends StatelessWidget {
  const HotelFloorTabBar({
    super.key,
    required this.floors,
    required this.selectedFloorId,
    required this.vacantCounts,
    required this.onSelect,
  });

  /// `(id, name)` pairs in display order.
  final List<(String, String)> floors;

  /// `null` = All.
  final String? selectedFloorId;
  final Map<String, int> vacantCounts;
  final ValueChanged<String?> onSelect;

  @override
  Widget build(BuildContext context) {
    final entries = <(String?, String)>[(null, 'All floors'), ...floors];

    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(18, 2, 18, 12),
        itemCount: entries.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final (id, name) = entries[i];
          final isOn = id == selectedFloorId;
          final vacant = id == null
              ? vacantCounts.values.fold(0, (a, b) => a + b)
              : (vacantCounts[id] ?? 0);

          return GestureDetector(
            onTap: () => onSelect(id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              height: 34,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: isOn ? HotelTokens.ink1 : HotelTokens.surface,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: isOn ? HotelTokens.ink1 : HotelTokens.line,
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.outfit(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: isOn ? Colors.white : HotelTokens.ink2,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Text(
                    '$vacant',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isOn
                          ? Colors.white.withValues(alpha: 0.8)
                          : HotelTokens.ink3,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Transient confirmation toast (check-in / checkout).
class HotelToast extends StatefulWidget {
  const HotelToast({
    super.key,
    required this.message,
    required this.onDone,
    this.mobile = false,
  });

  final String message;
  final VoidCallback onDone;
  final bool mobile;

  @override
  State<HotelToast> createState() => _HotelToastState();
}

class _HotelToastState extends State<HotelToast> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2600), () {
      if (mounted) widget.onDone();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: widget.mobile ? 26 : 34,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          decoration: BoxDecoration(
            color: HotelTokens.toastBg,
            borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
            boxShadow: HotelTokens.shadow2,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                size: 18,
                color: HotelTokens.toastCheck,
              ),
              const SizedBox(width: 10),
              Text(
                widget.message,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
