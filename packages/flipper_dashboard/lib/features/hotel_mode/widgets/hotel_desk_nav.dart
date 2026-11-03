import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/hotel_mode/providers/hotel_mode_providers.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_layout_breakpoints.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_tokens.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Segmented nav across the three desk surfaces.
///
/// The folio is deliberately absent: it is reached by opening a room, not by
/// browsing, and it always has a back arrow of its own.
class HotelDeskNav extends ConsumerWidget {
  const HotelDeskNav({super.key, this.compact = false});

  final bool compact;

  static List<(HotelScreen, String, IconData)> _tabs(
    FlipperAppLocalizations l10n,
  ) => [
    (HotelScreen.dashboard, l10n.hotelNavToday, Icons.insights_outlined),
    (HotelScreen.rooms, l10n.hotelNavRooms, Icons.grid_view_rounded),
    (
      HotelScreen.calendar,
      l10n.hotelNavCalendar,
      Icons.calendar_month_outlined,
    ),
    (HotelScreen.quotes, l10n.hotelNavQuotes, Icons.request_quote_outlined),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // The host's own flag, so Today is hidden exactly when the host swaps it
    // for Rooms; the window width only stands in outside the host.
    final mobile =
        HotelLayoutScope.maybeMobileOf(context) ??
        HotelLayoutBreakpoints.isHotelMobileLayout(
          MediaQuery.sizeOf(context).width,
        );
    final current = hotelVisibleScreen(
      ref.watch(hotelModeProvider).screen,
      mobile: mobile,
    );

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: HotelTokens.surface2,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: HotelTokens.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (screen, label, icon) in _tabs(context.flipperL10n))
            // No Today tab on a phone: it would only redraw Rooms.
            if (!mobile || screen != HotelScreen.dashboard)
              _tab(ref, screen, label, icon, current == screen),
        ],
      ),
    );
  }

  Widget _tab(
    WidgetRef ref,
    HotelScreen screen,
    String label,
    IconData icon,
    bool selected,
  ) {
    return GestureDetector(
      onTap: () => ref.read(hotelModeProvider.notifier).setScreen(screen),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 12 : 16,
          vertical: compact ? 7 : 9,
        ),
        decoration: BoxDecoration(
          color: selected ? HotelTokens.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          boxShadow: selected ? HotelTokens.shadow1 : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: compact ? 15 : 16,
              color: selected ? HotelTokens.ink1 : HotelTokens.ink3,
            ),
            if (!compact) ...[
              const SizedBox(width: 7),
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: selected ? HotelTokens.ink1 : HotelTokens.ink3,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
