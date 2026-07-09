import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_tokens.dart';
import 'package:google_fonts/google_fonts.dart';

class BarZoneTabBar extends StatelessWidget {
  const BarZoneTabBar({
    super.key,
    required this.zones,
    required this.selectedZone,
    required this.openCounts,
    required this.onSelect,
  });

  final List<String> zones;
  final String selectedZone;
  final Map<String, int> openCounts;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(18, 2, 18, 12),
        itemCount: zones.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final zone = zones[i];
          final isOn = zone == selectedZone;
          final open = openCounts[zone] ?? 0;

          return GestureDetector(
            onTap: () => onSelect(zone),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              height: 34,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: isOn ? BarTokens.ink1 : BarTokens.surface,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: isOn ? BarTokens.ink1 : BarTokens.line,
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    zone,
                    style: GoogleFonts.outfit(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: isOn ? Colors.white : BarTokens.ink2,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Text(
                    '$open',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isOn
                          ? Colors.white.withValues(alpha: 0.8)
                          : BarTokens.ink3,
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
