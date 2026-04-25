import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// SVG assets for the mobile quick-access grid and revenue / expense summary cards
/// (stroke colors and backgrounds per design spec).
class DashboardQuickAccessSvgs {
  DashboardQuickAccessSvgs._();

  static const _xmlns = 'xmlns="http://www.w3.org/2000/svg"';

  // Drawer B (mobile) icons
  static String drawerHeaderGridIconWhite() => '''
<svg viewBox="0 0 24 24" fill="none" $_xmlns>
  <rect x="3" y="3" width="7" height="7" rx="1.5" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
  <rect x="14" y="3" width="7" height="7" rx="1.5" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
  <rect x="3" y="14" width="7" height="7" rx="1.5" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
  <rect x="14" y="14" width="7" height="7" rx="1.5" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  static String drawerCloseXIcon() => '''
<svg viewBox="0 0 14 14" fill="none" $_xmlns>
  <path d="M1 1l12 12M13 1L1 13" stroke="#4B4E58" stroke-width="1.8" stroke-linecap="round"/>
</svg>''';

  static String drawerScanQrIcon() => '''
<svg viewBox="0 0 24 24" fill="none" $_xmlns>
  <rect x="3" y="3" width="5" height="5" stroke="#2563EB" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
  <rect x="16" y="3" width="5" height="5" stroke="#2563EB" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
  <rect x="3" y="16" width="5" height="5" stroke="#2563EB" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M21 16h-4v5M21 21h.01M16 11h5M16 16v.01M11 3v5M11 11H3M11 16v5M3 11v5" stroke="#2563EB" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  static String drawerDashboardIconGreen() => '''
<svg viewBox="0 0 24 24" fill="none" $_xmlns>
  <rect x="3" y="3" width="7" height="7" rx="1.5" stroke="#16A34A" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
  <rect x="14" y="3" width="7" height="7" rx="1.5" stroke="#16A34A" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
  <rect x="3" y="14" width="7" height="7" rx="1.5" stroke="#16A34A" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
  <rect x="14" y="14" width="7" height="7" rx="1.5" stroke="#16A34A" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  static String drawerBusinessIconBlue() => '''
<svg viewBox="0 0 24 24" fill="none" $_xmlns>
  <rect x="3" y="3" width="7" height="7" rx="1.5" stroke="#2563EB" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
  <rect x="14" y="3" width="7" height="7" rx="1.5" stroke="#2563EB" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
  <rect x="3" y="14" width="7" height="7" rx="1.5" stroke="#2563EB" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
  <rect x="14" y="14" width="7" height="7" rx="1.5" stroke="#2563EB" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  static String drawerChevronDownIcon() => '''
<svg viewBox="0 0 16 16" fill="none" $_xmlns>
  <path d="M4 6l4 4 4-4" stroke="#C5C8D0" stroke-width="1.5" stroke-linecap="round"/>
</svg>''';

  static String drawerChevronRightIcon() => '''
<svg viewBox="0 0 14 14" fill="none" $_xmlns>
  <path d="M5 2l5 5-5 5" stroke="#C5C8D0" stroke-width="1.5" stroke-linecap="round"/>
</svg>''';

  static String drawerCloseShiftLockIcon() => '''
<svg viewBox="0 0 24 24" fill="none" $_xmlns>
  <rect x="3" y="11" width="18" height="11" rx="2" stroke="#DC2626" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M7 11V7a5 5 0 0110 0v4" stroke="#DC2626" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  static String drawerShiftWarningBadgeIcon() => '''
<svg viewBox="0 0 10 10" fill="none" $_xmlns>
  <path d="M5 2v3M5 7h.01" stroke="#DC2626" stroke-width="2" stroke-linecap="round"/>
</svg>''';

  static String drawerAuthShieldIcon() => '''
<svg viewBox="0 0 24 24" fill="none" $_xmlns>
  <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" stroke="#2563EB" stroke-width="1.6" stroke-linecap="round"/>
</svg>''';

  static String drawerOnlinePrintSyncIcon() => '''
<svg viewBox="0 0 24 24" fill="none" $_xmlns>
  <path d="M20.5 12A8.5 8.5 0 1112 3.5" stroke="#2563EB" stroke-width="1.6" stroke-linecap="round"/>
  <path d="M12 3.5V7M9 5h6" stroke="#2563EB" stroke-width="1.6" stroke-linecap="round"/>
</svg>''';

  static String drawerUserLoggingFileIcon() => '''
<svg viewBox="0 0 24 24" fill="none" $_xmlns>
  <path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z" stroke="#6366F1" stroke-width="1.6" stroke-linecap="round"/>
  <path d="M14 2v6h6M16 13H8M16 17H8M10 9H8" stroke="#6366F1" stroke-width="1.6" stroke-linecap="round"/>
</svg>''';

  static String drawerBackgroundSyncGridPlusIcon() => '''
<svg viewBox="0 0 24 24" fill="none" $_xmlns>
  <path d="M4 4h6v6H4zM14 4h6v6h-6zM4 14h6v6H4z" stroke="#2563EB" stroke-width="1.6" stroke-linecap="round"/>
  <path d="M14 17h6M17 14v6" stroke="#2563EB" stroke-width="1.6" stroke-linecap="round"/>
</svg>''';

  static String drawerSignOutIcon() => '''
<svg viewBox="0 0 24 24" fill="none" $_xmlns>
  <path d="M9 4H5a1 1 0 00-1 1v14a1 1 0 001 1h4" stroke="#DC2626" stroke-width="1.6" stroke-linecap="round"/>
  <path d="M15 16l4-4-4-4M9 12h10" stroke="#DC2626" stroke-width="1.6" stroke-linecap="round"/>
</svg>''';

  static Widget icon(String svg, {double? width, double? height}) {
    return SvgPicture.string(svg, width: width, height: height);
  }

  static bool hasSvgTile(String page) {
    switch (page) {
      case 'ServicesGigs':
      case 'POS':
      case 'Cashbook':
      case 'Transactions':
      case 'Contacts':
      case 'Support':
      case 'Credits':
      case 'Chat':
      case 'Settings':
      case 'ProductionOutput':
      case 'Orders':
        return true;
      default:
        return false;
    }
  }

  /// Rounded tile background behind the 24×24 icon (mobile only).
  static Color mobileTileBackground(String page) {
    switch (page) {
      case 'ServicesGigs':
      case 'Transactions':
        return const Color.fromRGBO(220, 38, 38, 0.09);
      case 'POS':
        return const Color.fromRGBO(37, 99, 235, 0.10);
      case 'Cashbook':
        return const Color.fromRGBO(124, 58, 237, 0.10);
      case 'Contacts':
        return const Color.fromRGBO(13, 148, 136, 0.10);
      case 'Support':
      case 'Credits':
        return const Color.fromRGBO(217, 119, 6, 0.10);
      case 'Chat':
        return const Color.fromRGBO(124, 58, 237, 0.10);
      case 'Settings':
        return const Color.fromRGBO(107, 114, 128, 0.10);
      case 'ProductionOutput':
      case 'Orders':
        return const Color.fromRGBO(37, 99, 235, 0.10);
      default:
        return Colors.grey.withValues(alpha: 0.1);
    }
  }

  static Widget mobileTileIcon(String page, {double size = 28}) {
    return SvgPicture.string(_svgForPage(page), width: size, height: size);
  }

  static String _svgForPage(String page) {
    switch (page) {
      case 'ServicesGigs':
        return _usersIcon('#DC2626');
      case 'POS':
        return _posIcon('#2563EB');
      case 'Cashbook':
        return _cashbookIcon('#7C3AED');
      case 'Transactions':
        return _transactionsIcon('#DC2626');
      case 'Contacts':
        return _usersIcon('#0D9488');
      case 'Support':
        return _supportIcon('#D97706');
      case 'Credits':
        return _creditsIcon();
      case 'Chat':
        return _aiChatIcon();
      case 'Settings':
        return _settingsIcon();
      case 'ProductionOutput':
        return _productionIcon();
      case 'Orders':
        return _ordersIcon();
      default:
        return _posIcon('#2563EB');
    }
  }

  static String revenueSummarySvg() =>
      '''
<svg viewBox="0 0 16 16" fill="none" $_xmlns>
  <path d="M8 2v12M5 5l3-3 3 3M3 12h10" stroke="#16A34A" stroke-width="1.6" stroke-linecap="round"/>
</svg>''';

  static String expensesSummarySvg() =>
      '''
<svg viewBox="0 0 16 16" fill="none" $_xmlns>
  <path d="M8 2v12M5 11l3 3 3-3M3 4h10" stroke="#DC2626" stroke-width="1.6" stroke-linecap="round"/>
</svg>''';

  static Widget revenueSummaryIcon() {
    return SvgPicture.string(revenueSummarySvg(), width: 16, height: 16);
  }

  static Widget expensesSummaryIcon() {
    return SvgPicture.string(expensesSummarySvg(), width: 16, height: 16);
  }

  static String _usersIcon(String stroke) =>
      '''
<svg viewBox="0 0 24 24" fill="none" $_xmlns>
  <path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2" stroke="$stroke" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
  <circle cx="9" cy="7" r="4" stroke="$stroke" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M23 21v-2a4 4 0 00-3-3.87" stroke="$stroke" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M16 3.13a4 4 0 010 7.75" stroke="$stroke" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  static String _posIcon(String stroke) =>
      '''
<svg viewBox="0 0 24 24" fill="none" $_xmlns>
  <rect x="3" y="3" width="7" height="7" rx="1.5" stroke="$stroke" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
  <rect x="14" y="3" width="7" height="7" rx="1.5" stroke="$stroke" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
  <rect x="3" y="14" width="7" height="7" rx="1.5" stroke="$stroke" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
  <rect x="14" y="14" width="7" height="7" rx="1.5" stroke="$stroke" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  static String _cashbookIcon(String stroke) =>
      '''
<svg viewBox="0 0 24 24" fill="none" $_xmlns>
  <path d="M4 19.5A2.5 2.5 0 016.5 17H20" stroke="$stroke" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M6.5 2H20v20H6.5A2.5 2.5 0 014 19.5v-15A2.5 2.5 0 016.5 2z" stroke="$stroke" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M9 7h6M9 11h4" stroke="$stroke" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  static String _transactionsIcon(String stroke) =>
      '''
<svg viewBox="0 0 24 24" fill="none" $_xmlns>
  <path d="M7 16l-4-4 4-4" stroke="$stroke" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M17 8l4 4-4 4" stroke="$stroke" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M14 4l-4 16" stroke="$stroke" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  static String _supportIcon(String stroke) =>
      '''
<svg viewBox="0 0 24 24" fill="none" $_xmlns>
  <path d="M21 15a2 2 0 01-2 2H7l-4 4V5a2 2 0 012-2h14a2 2 0 012 2z" stroke="$stroke" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  static String _creditsIcon() =>
      '''
<svg viewBox="0 0 24 24" fill="none" $_xmlns>
  <circle cx="12" cy="12" r="9" stroke="#D97706" stroke-width="1.6" stroke-linecap="round"/>
  <circle cx="12" cy="12" r="2" fill="#D97706"/>
  <circle cx="12" cy="5.5" r="1.2" fill="#DC2626"/>
  <line x1="12" y1="7" x2="12" y2="10" stroke="#D97706" stroke-width="1.6" stroke-linecap="round"/>
</svg>''';

  static String _aiChatIcon() =>
      '''
<svg viewBox="0 0 24 24" fill="none" $_xmlns>
  <path d="M21 15a2 2 0 01-2 2H7l-4 4V5a2 2 0 012-2h14a2 2 0 012 2z" stroke="#7C3AED" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
  <circle cx="8.5" cy="11" r="1" fill="#7C3AED"/>
  <circle cx="12" cy="11" r="1" fill="#7C3AED"/>
  <circle cx="15.5" cy="11" r="1" fill="#7C3AED"/>
</svg>''';

  static String _settingsIcon() =>
      '''
<svg viewBox="0 0 24 24" fill="none" $_xmlns>
  <path d="M12 15a3 3 0 100-6 3 3 0 000 6z" stroke="#6B7280" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M19.4 15a1.65 1.65 0 00.33 1.82l.06.06a2 2 0 010 2.83 2 2 0 01-2.83 0l-.06-.06a1.65 1.65 0 00-1.82-.33 1.65 1.65 0 00-1 1.51V21a2 2 0 01-2 2 2 2 0 01-2-2v-.09A1.65 1.65 0 009 19.4a1.65 1.65 0 00-1.82.33l-.06.06a2 2 0 01-2.83 0 2 2 0 010-2.83l.06-.06A1.65 1.65 0 004.68 15a1.65 1.65 0 00-1.51-1H3a2 2 0 01-2-2 2 2 0 012-2h.09A1.65 1.65 0 004.6 9a1.65 1.65 0 00-.33-1.82l-.06-.06a2 2 0 010-2.83 2 2 0 012.83 0l.06.06A1.65 1.65 0 009 4.68a1.65 1.65 0 001-1.51V3a2 2 0 012-2 2 2 0 012 2v.09a1.65 1.65 0 001 1.51 1.65 1.65 0 001.82-.33l.06-.06a2 2 0 012.83 0 2 2 0 010 2.83l-.06.06A1.65 1.65 0 0019.4 9a1.65 1.65 0 001.51 1H21a2 2 0 012 2 2 2 0 01-2 2h-.09a1.65 1.65 0 00-1.51 1z" stroke="#6B7280" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  static String _productionIcon() =>
      '''
<svg viewBox="0 0 24 24" fill="none" $_xmlns>
  <rect x="2" y="7" width="20" height="13" rx="2" stroke="#2563EB" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M2 10h20" stroke="#2563EB" stroke-width="1.6" stroke-linecap="round"/>
  <path d="M6 4h12" stroke="#2563EB" stroke-width="1.6" stroke-linecap="round"/>
  <rect x="5" y="14" width="3" height="2" rx="0.5" fill="#2563EB"/>
  <rect x="10" y="14" width="3" height="2" rx="0.5" fill="#2563EB"/>
  <rect x="15" y="14" width="4" height="2" rx="0.5" fill="#2563EB"/>
</svg>''';

  static String _ordersIcon() =>
      '''
<svg viewBox="0 0 24 24" fill="none" $_xmlns>
  <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2" stroke="#2563EB" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
  <rect x="9" y="3" width="6" height="4" rx="1" stroke="#2563EB" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M9 12h6M9 16h4" stroke="#2563EB" stroke-width="1.6" stroke-linecap="round"/>
  <circle cx="17" cy="17" r="3.5" fill="#DBEAFE" stroke="#2563EB" stroke-width="1.5"/>
  <text x="17" y="19.5" text-anchor="middle" font-size="5" font-weight="700" fill="#2563EB" font-family="sans-serif">A</text>
</svg>''';
}
