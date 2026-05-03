import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Leading row for mobile dashboard shell: gradient ring logo + Flipper wordmark.
class DashboardMobileAppBarLeading extends StatelessWidget {
  const DashboardMobileAppBarLeading({super.key, required this.onOpenDrawer});

  final VoidCallback onOpenDrawer;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onOpenDrawer,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF006AFE), Color(0xFF14B8A6)],
                ),
              ),
              alignment: Alignment.center,
              child: Container(
                width: 33,
                height: 33,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(4),
                child: ClipOval(
                  child: Image.asset(
                    'assets/logo.png',
                    package: 'flipper_dashboard',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Flipper',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
