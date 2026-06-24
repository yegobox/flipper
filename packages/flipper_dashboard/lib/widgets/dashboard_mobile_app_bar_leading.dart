import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Leading row for mobile dashboard shell: gradient ring logo + Flipper wordmark.
class DashboardMobileAppBarLeading extends StatelessWidget {
  const DashboardMobileAppBarLeading({super.key, this.onOpenDrawer});

  final VoidCallback? onOpenDrawer;

  @override
  Widget build(BuildContext context) {
    final child = Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF22D3EE), Color(0xFF2563EB), Color(0xFF4F46E5)],
              ),
            ),
            alignment: Alignment.center,
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(3),
              child: ClipOval(
                child: Image.asset(
                  'assets/logo.png',
                  package: 'flipper_dashboard',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 9),
          Text(
            'Flipper',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );

    if (onOpenDrawer == null) return child;

    return InkWell(
      onTap: onOpenDrawer,
      borderRadius: BorderRadius.circular(12),
      child: child,
    );
  }
}
