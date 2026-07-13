import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_tokens.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BarMobileTabBar extends StatelessWidget {
  const BarMobileTabBar({
    super.key,
    required this.lineCount,
    required this.total,
    required this.onTap,
    this.empty = false,
  });

  final int lineCount;
  final double total;
  final VoidCallback onTap;
  final bool empty;

  @override
  Widget build(BuildContext context) {
    if (empty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: const BoxDecoration(
          color: BarTokens.surface,
          border: Border(top: BorderSide(color: BarTokens.line)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 18, color: BarTokens.ink3),
            const SizedBox(width: 7),
            Text(
              'Tap products to start a tab',
              style: GoogleFonts.outfit(
                fontSize: 13,
                color: BarTokens.ink3,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      decoration: BoxDecoration(
        color: BarTokens.surface,
        border: const Border(top: BorderSide(color: BarTokens.line)),
        boxShadow: [
          BoxShadow(
            color: const Color(0x33102040).withValues(alpha: 0.12),
            offset: const Offset(0, -6),
            blurRadius: 20,
            spreadRadius: -12,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            height: BarTokens.mobileTabBarHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: BarTokens.gradBtn,
              boxShadow: BarTokens.shadow2,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    if (lineCount > 0)
                      Positioned(
                        top: -5,
                        right: -5,
                        child: Container(
                          constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '$lineCount',
                            style: GoogleFonts.outfit(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              color: BarTokens.blue,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'View tab',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          height: 1.15,
                        ),
                      ),
                      Text(
                        '$lineCount item${lineCount == 1 ? '' : 's'}',
                        style: GoogleFonts.outfit(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 11.5,
                          height: 1.15,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'RWF ${NumberFormat('#,###').format(total)}',
                  style: GoogleFonts.jetBrainsMono(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
