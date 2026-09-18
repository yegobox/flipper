import 'package:flutter/material.dart';

/// Design tokens for the desktop purchase-order screen.
///
/// Values are lifted from the "Purchase Order Desktop" handoff. It is a sibling
/// of the register handoff behind [PosTokens] but not the same palette (calmer
/// bg `#F1F3F7` vs `#F4F6FB`, warmer lines, an eight-step ink ramp), so the two
/// are kept apart rather than one bent to fit the other.
///
/// Type: the handoff specifies Manrope + JetBrains Mono. This package already
/// bundles Geist / Geist Mono as real assets — an offline-first app cannot
/// depend on a runtime font fetch — so those stand in, at the weights and sizes
/// the handoff calls for.
abstract final class OrderingTokens {
  // ── Fonts (package-scoped: this package ships the assets) ──
  static const String sans = 'packages/flipper_dashboard/Geist';
  static const String mono = 'packages/flipper_dashboard/Geist Mono';

  // ── Surfaces ──
  static const Color bg = Color(0xFFF1F3F7);
  static const Color surface = Color(0xFFFFFFFF);

  /// Table header / row hover.
  static const Color surfaceHeader = Color(0xFFFAFBFD);

  /// Inset cards (last-order, steppers).
  static const Color surfaceInset = Color(0xFFF7F9FC);

  /// Cart footer.
  static const Color surfaceFooter = Color(0xFFFDFEFF);

  // ── Lines ──
  static const Color line = Color(0xFFE4E8EF);
  static const Color lineSoft = Color(0xFFE9EDF3);
  static const Color lineFaint = Color(0xFFF2F4F8);
  static const Color lineStrong = Color(0xFFDDE2EA);

  // ── Ink ramp ──
  static const Color ink1 = Color(0xFF0F1720);
  static const Color ink2 = Color(0xFF3B4755);
  static const Color ink3 = Color(0xFF6B7684);
  static const Color ink4 = Color(0xFF8A93A2);
  static const Color ink5 = Color(0xFF9AA3B2);
  static const Color ink6 = Color(0xFFA8B0BD);
  static const Color ink7 = Color(0xFFB4BCC9);
  static const Color ink8 = Color(0xFFC3CAD6);

  /// Group header / thumb fallback ink.
  static const Color inkGroup = Color(0xFF4C5A6C);

  // ── Brand ──
  static const Color blue = Color(0xFF2563EB);
  static const Color blueHover = Color(0xFF1D4ED8);

  /// Selected rail item / stepper minus / finance chip fill.
  static const Color blueTint = Color(0xFFEFF4FE);

  /// Stepper minus hover.
  static const Color blueTint2 = Color(0xFFDBEAFE);

  /// Row background for a product already in the order.
  static const Color blueRow = Color(0xFFF7FAFF);

  /// Rail count text when the category is selected.
  static const Color blueCount = Color(0xFF6E96E8);

  /// Supplier thumb well on the picker.
  static const Color thumbWell = Color(0xFFEFF3FA);

  // ── Supplier chip (top bar) ──
  static const Color supplierBg = Color(0xFFE8F6FB);
  static const Color supplierBorder = Color(0xFFBCE3F0);
  static const Color supplierInk = Color(0xFF0E5C71);
  static const Color supplierIcon = Color(0xFF0E7490);
  static const Color supplierMeta = Color(0xFF4E8CA1);

  // ── Semantic ──
  static const Color good = Color(0xFF15803D);
  static const Color goodBg = Color(0xFFDCFCE7);
  static const Color warn = Color(0xFFB45309);
  static const Color warnBg = Color(0xFFFEF3C7);
  static const Color danger = Color(0xFFB4232A);
  static const Color dangerHover = Color(0xFF8C161C);
  static const Color dangerBg = Color(0xFFFDECEC);

  // ── Radii ──
  static const double rSm = 5;
  static const double rMd = 6;
  static const double rStepper = 9;
  static const double rControl = 10;
  static const double rCard = 12;

  // ── Layout ──
  static const double topBarHeight = 66;
  static const double railWidth = 186;
  static const double railMinWidth = 150;
  static const double cartWidth = 372;
  static const double cartMinWidth = 288;
  static const double cartMaxWidth = 430;

  /// Centered supplier-picker column.
  static const double pickerMaxWidth = 720;

  /// Catalog column widths, right-aligned (handoff: 96 / 104 / 104 / 132).
  static const double colStock = 96;
  static const double colMargin = 104;
  static const double colCost = 104;
  static const double colQty = 132;

  /// The catalog needs the rail + all four numeric columns + a readable name
  /// column before the three-pane split is worth it.
  static const double desktopMinWidth = 1000;

  /// Width the catalogue pane needs before the "Retail · margin" column earns
  /// its place. The four numeric columns are fixed, so below this the product
  /// name has nothing left and the row overflows instead of eliding. Margin is
  /// the one column that is context rather than part of the decision, so it is
  /// the one that goes — and the rail stops offering the toggle.
  static const double marginColumnMinPaneWidth = 700;

  static const Duration hover = Duration(milliseconds: 120);

  // ── Type ──
  static const TextStyle screenTitle = TextStyle(
    fontFamily: sans,
    fontSize: 16,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.16,
    color: ink1,
    height: 1.2,
  );

  static const TextStyle pickerTitle = TextStyle(
    fontFamily: sans,
    fontSize: 24,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.48,
    color: ink1,
    height: 1.25,
  );

  static const TextStyle pickerBody = TextStyle(
    fontFamily: sans,
    fontSize: 14.5,
    fontWeight: FontWeight.w500,
    color: ink3,
    height: 1.45,
  );

  /// Uppercase section label ("CATEGORIES", "PAY WITH").
  static const TextStyle eyebrow = TextStyle(
    fontFamily: sans,
    fontSize: 11.5,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.15,
    color: ink5,
    height: 1.2,
  );

  /// Catalog column header.
  static const TextStyle columnHeader = TextStyle(
    fontFamily: sans,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.99,
    color: ink5,
    height: 1.2,
  );

  /// Category divider inside the catalog.
  static const TextStyle groupHeader = TextStyle(
    fontFamily: sans,
    fontSize: 12,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.72,
    color: inkGroup,
    height: 1.2,
  );

  static const TextStyle productName = TextStyle(
    fontFamily: sans,
    fontSize: 14.5,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.14,
    color: ink1,
    height: 1.2,
  );

  static const TextStyle lineName = TextStyle(
    fontFamily: sans,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.14,
    color: ink1,
    height: 1.2,
  );

  static const TextStyle body = TextStyle(
    fontFamily: sans,
    fontSize: 13.5,
    fontWeight: FontWeight.w500,
    color: ink3,
    height: 1.35,
  );

  static const TextStyle bodyStrong = TextStyle(
    fontFamily: sans,
    fontSize: 13.5,
    fontWeight: FontWeight.w700,
    color: ink2,
    height: 1.35,
  );

  static const TextStyle label = TextStyle(
    fontFamily: sans,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: ink3,
    height: 1.3,
  );

  static const TextStyle badge = TextStyle(
    fontFamily: sans,
    fontSize: 11.5,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontFamily: sans,
    fontSize: 15.5,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.16,
    color: ink1,
    height: 1.2,
  );

  static const TextStyle placedTitle = TextStyle(
    fontFamily: sans,
    fontSize: 19,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.19,
    color: ink1,
    height: 1.25,
  );

  static const TextStyle submit = TextStyle(
    fontFamily: sans,
    fontSize: 15,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.15,
    color: Colors.white,
    height: 1.2,
  );

  /// Tabular numerals. Every figure on this screen is a quantity or an amount
  /// that sits in a right-aligned column, so proportional digits would jitter.
  static TextStyle monoStyle({
    double fontSize = 13,
    FontWeight fontWeight = FontWeight.w600,
    Color color = ink1,
  }) {
    return TextStyle(
      fontFamily: mono,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: 1.2,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
  }

  static TextStyle get monoMeta =>
      monoStyle(fontSize: 11.5, fontWeight: FontWeight.w500, color: ink4);

  static TextStyle get monoTotal => monoStyle(
    fontSize: 21,
    fontWeight: FontWeight.w700,
    color: ink1,
  ).copyWith(letterSpacing: -0.42);

  static const BorderRadius cardRadius = BorderRadius.all(
    Radius.circular(rCard),
  );
  static const BorderRadius controlRadius = BorderRadius.all(
    Radius.circular(rControl),
  );
  static const BorderRadius stepperRadius = BorderRadius.all(
    Radius.circular(rStepper),
  );

  static const List<BoxShadow> cardHoverShadow = [
    BoxShadow(
      color: Color(0x1A2563EB),
      offset: Offset(0, 3),
      blurRadius: 12,
    ),
  ];
}
