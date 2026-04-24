import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Inline SVG strings for the admin / management dashboard.
/// Single source of truth — import [AdminDashboardSvgs] and use [AdminDashboardSvgs.picture].
abstract final class AdminDashboardSvgs {
  AdminDashboardSvgs._();

  static const String _xmlns = 'xmlns="http://www.w3.org/2000/svg"';

  static const String backArrow =
      '''<svg viewBox="0 0 14 14" fill="none" $_xmlns><path d="M9 2L4 7l5 5" stroke="#4B4E58" stroke-width="1.8" stroke-linecap="round"/></svg>''';

  static const String chevronRight =
      '''<svg viewBox="0 0 14 14" fill="none" $_xmlns><path d="M5 2l5 5-5 5" stroke="#C5C8D0" stroke-width="1.5" stroke-linecap="round"/></svg>''';

  static const String posDefault =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns><rect x="3" y="3" width="7" height="7" rx="1.5" stroke="#2563EB" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/><rect x="14" y="3" width="7" height="7" rx="1.5" stroke="#2563EB" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/><rect x="3" y="14" width="7" height="7" rx="1.5" stroke="#2563EB" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/><rect x="14" y="14" width="7" height="7" rx="1.5" stroke="#2563EB" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/></svg>''';

  static const String ordersDefault =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns><path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2" stroke="#16A34A" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/><rect x="9" y="3" width="6" height="4" rx="1" stroke="#16A34A" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/><path d="M9 12h6M9 16h4" stroke="#16A34A" stroke-width="1.6" stroke-linecap="round"/></svg>''';

  static const String userManagement =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns><path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2" stroke="#2563EB" stroke-width="1.6" stroke-linecap="round"/><circle cx="9" cy="7" r="4" stroke="#2563EB" stroke-width="1.6" stroke-linecap="round"/><path d="M23 21v-2a4 4 0 00-3-3.87M16 3.13a4 4 0 010 7.75" stroke="#2563EB" stroke-width="1.6" stroke-linecap="round"/></svg>''';

  static const String branchManagement =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns><path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z" stroke="#0D9488" stroke-width="1.6" stroke-linecap="round"/><path d="M9 22V12h6v10" stroke="#0D9488" stroke-width="1.6" stroke-linecap="round"/></svg>''';

  static const String taxSettings =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns><path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z" stroke="#D97706" stroke-width="1.6" stroke-linecap="round"/><line x1="9" y1="22" x2="9" y2="12" stroke="#D97706" stroke-width="1.6" stroke-linecap="round"/><line x1="15" y1="22" x2="15" y2="12" stroke="#D97706" stroke-width="1.6" stroke-linecap="round"/><line x1="9" y1="17" x2="15" y2="17" stroke="#D97706" stroke-width="1.6" stroke-linecap="round"/></svg>''';

  static const String paymentMethods =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns><rect x="1" y="4" width="22" height="16" rx="2" stroke="#7C3AED" stroke-width="1.6" stroke-linecap="round"/><line x1="1" y1="10" x2="23" y2="10" stroke="#7C3AED" stroke-width="1.6" stroke-linecap="round"/></svg>''';

  static const String smsPhone =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns><path d="M3 2h3l1.5 3.5L6 7a9 9 0 004 4l1.5-1.5L15 11v3a1 1 0 01-1 1A13 13 0 012 3a1 1 0 011-1z" stroke="#0D9488" stroke-width="1.6" stroke-linecap="round"/></svg>''';

  static const String enableNotifications =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns><path d="M18 8A6 6 0 006 8c0 7-3 9-3 9h18s-3-2-3-9" stroke="#16A34A" stroke-width="1.6" stroke-linecap="round"/><path d="M13.73 21a2 2 0 01-3.46 0" stroke="#16A34A" stroke-width="1.6" stroke-linecap="round"/></svg>''';

  static const String administratorPin =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" stroke="#2563EB" stroke-width="1.6" stroke-linecap="round"/></svg>''';

  static const String resetAdministratorPin =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns><path d="M21.5 12A9.5 9.5 0 1112 2.5" stroke="#2563EB" stroke-width="1.6" stroke-linecap="round"/><path d="M12 2.5V6M9 4h6" stroke="#2563EB" stroke-width="1.6" stroke-linecap="round"/><circle cx="12" cy="12" r="1" stroke="#2563EB" stroke-width="1.6"/></svg>''';

  static const String debugMode =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns><path d="M8 2l1.5 1.5M16 2l-1.5 1.5M9 9h6M9 13h6M12 9v8M5 10H3M21 10h-2M5 14H3M21 14h-2M7 20a5 5 0 0010 0V10a5 5 0 00-10 0v10z" stroke="#D97706" stroke-width="1.6" stroke-linecap="round"/></svg>''';

  static const String ebm =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns><path d="M20.5 12A8.5 8.5 0 1112 3.5" stroke="#0D9488" stroke-width="1.6" stroke-linecap="round"/><path d="M12 3.5V7M9 5h6" stroke="#0D9488" stroke-width="1.6" stroke-linecap="round"/></svg>''';

  static const String hydrateData =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns><path d="M20.5 12A8.5 8.5 0 1112 3.5" stroke="#DC2626" stroke-width="1.6" stroke-linecap="round"/><path d="M12 3.5V7M9 5h6" stroke="#DC2626" stroke-width="1.6" stroke-linecap="round"/></svg>''';

  static const String transactionDelegation =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns><path d="M20.5 12A8.5 8.5 0 1112 3.5" stroke="#0D9488" stroke-width="1.6" stroke-linecap="round"/><path d="M12 3.5V7M9 5h6" stroke="#0D9488" stroke-width="1.6" stroke-linecap="round"/></svg>''';

  static const String taxService =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns><path d="M4 19.5A2.5 2.5 0 016.5 17H20" stroke="#7C3AED" stroke-width="1.6" stroke-linecap="round"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 014 19.5v-15A2.5 2.5 0 016.5 2z" stroke="#7C3AED" stroke-width="1.6" stroke-linecap="round"/><path d="M9 7h6M9 11h4" stroke="#7C3AED" stroke-width="1.6" stroke-linecap="round"/></svg>''';

  static const String assetDownload =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns><path d="M8 17l4 4 4-4M12 12v9" stroke="#2563EB" stroke-width="1.6" stroke-linecap="round"/><path d="M20.88 18.09A5 5 0 0018 9h-1.26A8 8 0 103 16.29" stroke="#2563EB" stroke-width="1.6" stroke-linecap="round"/></svg>''';

  static const String autoAddSearch =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns><path d="M12 2l2.4 7.4H22l-6.2 4.5 2.4 7.4L12 17l-6.2 4.3 2.4-7.4L2 9.4h7.6L12 2z" stroke="#EC4899" stroke-width="1.6" stroke-linecap="round"/></svg>''';

  static const String userLogging =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns><path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z" stroke="#6366F1" stroke-width="1.6" stroke-linecap="round"/><path d="M14 2v6h6M16 13H8M16 17H8M10 9H8" stroke="#6366F1" stroke-width="1.6" stroke-linecap="round"/></svg>''';

  static const String priceQtyAdjustment =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns><line x1="12" y1="1" x2="12" y2="23" stroke="#DC2626" stroke-width="1.6" stroke-linecap="round"/><path d="M17 5H9.5a3.5 3.5 0 000 7h5a3.5 3.5 0 010 7H6" stroke="#DC2626" stroke-width="1.6" stroke-linecap="round"/></svg>''';

  static const String decimalsCurrency =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns><rect x="2" y="5" width="20" height="14" rx="2" stroke="#16A34A" stroke-width="1.6" stroke-linecap="round"/><path d="M2 10h20" stroke="#16A34A" stroke-width="1.6" stroke-linecap="round"/><circle cx="7" cy="15" r="1" fill="#16A34A"/></svg>''';

  static const String infoCircle =
      '''<svg viewBox="0 0 16 16" fill="none" $_xmlns><circle cx="8" cy="8" r="6" stroke="#2563EB" stroke-width="1.5" stroke-linecap="round"/><path d="M8 7v4M8 5h.01" stroke="#2563EB" stroke-width="1.5" stroke-linecap="round"/></svg>''';

  static const String receiptLogoPlaceholder =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns><rect x="3" y="3" width="18" height="18" rx="2" stroke="#2563EB" stroke-width="1.6" stroke-linecap="round"/><circle cx="8.5" cy="8.5" r="1.5" stroke="#2563EB" stroke-width="1.6" stroke-linecap="round"/><path d="M21 15l-5-5L5 21" stroke="#2563EB" stroke-width="1.6" stroke-linecap="round"/></svg>''';

  static const String uploadIconWhite =
      '''<svg viewBox="0 0 16 16" fill="none" $_xmlns><path d="M8 2v9M5 5l3-3 3 3M2 12v2h12v-2" stroke="#FFFFFF" stroke-width="1.6" stroke-linecap="round"/></svg>''';

  /// Renders an inline SVG at [size]×[size] logical pixels.
  static Widget picture(String svgString, {double size = 24}) {
    return SvgPicture.string(svgString, width: size, height: size);
  }
}
