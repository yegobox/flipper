import 'package:flipper_dashboard/pos_layout_breakpoints.dart';
import 'package:flipper_dashboard/widgets/admin_dashboard_svgs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

// The look shared by Admin Control's sections. Public so each section can live
// in its own file and be reused by the phone settings hub.

const Color kAdminCardBorder = Color(0xFFE5E7EB);

/// Matches [TicketsScreen] scaffold / app bar chrome.
const Color kAdminScaffoldBg = Color(0xFFF2F4F7);
const Color kAdminAppBarIconCircleBorder = Color(0xFFE0E4EB);

ButtonStyle adminAppBarCircleIconStyle() {
  return IconButton.styleFrom(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black87,
    shape: const CircleBorder(),
    side: const BorderSide(color: kAdminAppBarIconCircleBorder, width: 1),
    padding: const EdgeInsets.all(10),
    minimumSize: const Size(40, 40),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );
}

const Color kAdminBarBlue = Color(0xFF2563EB);
const Color kAdminBarOrange = Color(0xFFD97706);
const Color kAdminBarTeal = Color(0xFF0D9488);
const Color kAdminBarRed = Color(0xFFDC2626);
const Color kAdminBarSlate = Color(0xFF64748B);
const Color kAdminBarPurple = Color(0xFF7C3AED);
const Color kAdminBarReceipt = Color(0xFFEA580C);
const Color kAdminTitleText = Color(0xFF111827);
const Color kAdminSubtitleText = Color(0xFF6B7280);

BoxDecoration adminCardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: kAdminCardBorder),
  );
}

Widget adminSectionHeader(BuildContext context, String title, Color barColor) {
  return Padding(
    padding: const EdgeInsets.only(left: 2, bottom: 12),
    child: Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title.toUpperCase(),
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            color: kAdminTitleText,
          ),
        ),
      ],
    ),
  );
}

Widget adminSubSectionHeader(String title, Color barColor) {
  return Row(
    children: [
      Container(
        width: 3,
        height: 14,
        decoration: BoxDecoration(
          color: barColor,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      const SizedBox(width: 8),
      Text(
        title.toUpperCase(),
        style: GoogleFonts.outfit(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
          color: kAdminTitleText,
        ),
      ),
    ],
  );
}

Widget adminLeadingSvg(String svg, Color backgroundTint) {
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: backgroundTint,
      borderRadius: BorderRadius.circular(10),
    ),
    child: AdminDashboardSvgs.picture(svg, size: 24),
  );
}

bool adminIsValidPhoneNumber(String phone) {
  // Remove any spaces or special characters
  final cleanPhone = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');

  // Check if it starts with + and has 10-15 digits
  if (cleanPhone.startsWith('+')) {
    return RegExp(r'^\+\d{10,15}$').hasMatch(cleanPhone);
  }

  // If no +, check if it has a valid length for international numbers (including country code)
  return RegExp(r'^\d{10,15}$').hasMatch(cleanPhone);
}

String adminFormatPhoneNumber(String phone) {
  // Remove any spaces or special characters
  final cleanPhone = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');

  // If it doesn't start with +, add it
  if (!cleanPhone.startsWith('+')) {
    return '+$cleanPhone';
  }
  return cleanPhone;
}

class AdminSwitchRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? leading;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const AdminSwitchRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.leading,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (leading != null) ...[leading!, const SizedBox(width: 12)],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: kAdminTitleText,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: kAdminSubtitleText,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeTrackColor: PosLayoutBreakpoints.posAccentBlue,
          inactiveTrackColor: const Color(0xFFE5E7EB),
          inactiveThumbColor: Colors.white,
          activeThumbColor: Colors.white,
        ),
      ],
    );
  }
}

class AdminNavRow extends StatelessWidget {
  final Widget leading;
  final String title;
  final String subtitle;

  const AdminNavRow({
    super.key,
    required this.leading,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        leading,
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: kAdminTitleText,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: kAdminSubtitleText,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        SvgPicture.string(
          AdminDashboardSvgs.chevronRight,
          width: 14,
          height: 14,
        ),
      ],
    );
  }
}
