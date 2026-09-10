import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_tokens.dart';
import 'package:google_fonts/google_fonts.dart';

/// One headline number on the manager dashboard.
class HotelKpiCard extends StatelessWidget {
  const HotelKpiCard({
    super.key,
    required this.label,
    required this.value,
    required this.caption,
    required this.icon,
    required this.ink,
    required this.tint,
    this.emphasiseCaption = false,
    this.dense = false,
  });

  final String label;
  final String value;
  final String caption;
  final IconData icon;
  final Color ink;
  final Color tint;

  /// Colours the caption in the card's ink — used when it is a warning
  /// ("3 overdue") rather than background detail.
  final bool emphasiseCaption;

  /// Money values are long; give them a smaller type scale so they do not
  /// wrap inside a tile sized for a two-digit count.
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: HotelTokens.surface,
        borderRadius: BorderRadius.circular(HotelTokens.radiusLg),
        border: Border.all(color: HotelTokens.line),
        boxShadow: HotelTokens.shadow1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: tint,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, size: 16, color: ink),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: HotelTokens.ink3,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              maxLines: 1,
              style: GoogleFonts.outfit(
                fontSize: dense ? 20 : 28,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.8,
                height: 1.1,
                color: HotelTokens.ink1,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            caption,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 11.5,
              height: 1.3,
              fontWeight: emphasiseCaption ? FontWeight.w700 : FontWeight.w500,
              color: emphasiseCaption ? ink : HotelTokens.ink3,
            ),
          ),
        ],
      ),
    );
  }
}
