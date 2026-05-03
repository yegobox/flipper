import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Inline SVG strings for the admin / management dashboard.
/// Single source of truth — import [AdminDashboardSvgs] and use [AdminDashboardSvgs.picture].
abstract final class AdminDashboardSvgs {
  AdminDashboardSvgs._();

  static const String _xmlns = 'xmlns="http://www.w3.org/2000/svg"';

  // ---- Leads feature icon set (shared desktop + mobile) ----
  static const String leadsBackChevronLeft =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M15 18L9 12l6-6"/></svg>''';

  static const String leadsChevronRight24 =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M9 18l6-6-6-6"/></svg>''';

  static const String leadsCloseX =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M18 6L6 18M6 6l12 12"/></svg>''';

  static const String leadsPlusAdd =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M12 5v14M5 12h14"/></svg>''';

  static const String leadsFilter =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M4 6h16M7 12h10M10 18h4"/></svg>''';

  static const String leadsSearch =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><path d="M21 21l-4.35-4.35"/></svg>''';

  static const String leadsDownloadExport =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M12 3v12M8 11l4 4 4-4M3 19h18"/></svg>''';

  static const String leadsShareExternalLink =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M18 13v6a2 2 0 01-2 2H5a2 2 0 01-2-2V8a2 2 0 012-2h6"/><polyline points="15 3 21 3 21 9"/><line x1="10" y1="14" x2="21" y2="3"/></svg>''';

  static const String leadsUsersMultiple =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 00-3-3.87M16 3.13a4 4 0 010 7.75"/></svg>''';

  static const String leadsUserSingle =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>''';

  static const String leadsPhoneCall =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M22 16.92v3a2 2 0 01-2.18 2 19.8 19.8 0 01-8.63-3.07 19.5 19.5 0 01-6-6 19.8 19.8 0 01-3.07-8.67A2 2 0 014.11 2h3a2 2 0 012 1.72 12.84 12.84 0 00.7 2.81 2 2 0 01-.45 2.11L8.09 9.91a16 16 0 006 6l1.27-1.27a2 2 0 012.11-.45 12.84 12.84 0 002.81.7A2 2 0 0122 16.92z"/></svg>''';

  static const String leadsEmailEnvelope =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg>''';

  static const String leadsAiInfoCircle =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>''';

  static const String leadsDocumentProforma =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><polyline points="10 9 9 9 8 9"/></svg>''';

  static const String leadsSendPaperPlane =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><line x1="22" y1="2" x2="11" y2="13"/><polygon points="22 2 15 22 11 13 2 9 22 2"/></svg>''';

  static const String leadsPrint =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 6 2 18 2 18 9"/><path d="M6 18H4a2 2 0 01-2-2v-5a2 2 0 012-2h16a2 2 0 012 2v5a2 2 0 01-2 2h-2"/><rect x="6" y="14" width="12" height="8"/></svg>''';

  static const String leadsEditPencil =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 00-2 2v14a2 2 0 002 2h14a2 2 0 002-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 013 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>''';

  static const String leadsTrashDelete =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 01-2 2H8a2 2 0 01-2-2L5 6"/><path d="M10 11v6M14 11v6"/><path d="M9 6V4a1 1 0 011-1h4a1 1 0 011 1v2"/></svg>''';

  static const String leadsFlipperLogoLines =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><line x1="3" y1="6" x2="21" y2="6"/><line x1="3" y1="12" x2="15" y2="12"/><line x1="3" y1="18" x2="17" y2="18"/></svg>''';

  static const String leadsCheckmark =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>''';

  static const String leadsTrendingUp =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><polyline points="23 6 13.5 15.5 8.5 10.5 1 18"/><polyline points="17 6 23 6 23 12"/></svg>''';

  static const String leadsDollarCurrency =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 000 7h5a3.5 3.5 0 010 7H6"/></svg>''';

  static const String leadsHomePos =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>''';

  static const String leadsGridDashboard =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>''';

  static const String leadsMoreSettings =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="3"/><path d="M19.07 4.93a10 10 0 010 14.14M4.93 4.93a10 10 0 000 14.14"/></svg>''';

  static const String leadsClockHistory =
      '''<svg viewBox="0 0 24 24" fill="none" $_xmlns stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>''';

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
