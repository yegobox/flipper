import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/hotel_mode/providers/hotel_mode_providers.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_tokens.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Segmented nav across the three desk surfaces.
///
/// The folio is deliberately absent: it is reached by opening a room, not by
/// browsing, and it always has a back arrow of its own.
class HotelDeskNav extends ConsumerWidget {
  const HotelDeskNav({super.key, this.compact = false});

  final bool compact;

  static const _tabs = <(HotelScreen, String, IconData)>[
    (HotelScreen.dashboard, 'Today', Icons.insights_outlined),
    (HotelScreen.rooms, 'Rooms', Icons.grid_view_rounded),
    (HotelScreen.calendar, 'Calendar', Icons.calendar_month_outlined),
    (HotelScreen.quotes, 'Quotes', Icons.request_quote_outlined),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(hotelModeProvider).screen;

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
          for (final (screen, label, icon) in _tabs)
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
