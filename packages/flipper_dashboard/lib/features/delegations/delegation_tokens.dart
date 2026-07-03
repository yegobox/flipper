import 'package:flutter/material.dart';

/// Design tokens from assets/design_handoff_transaction_delegations/styles.css
abstract final class DelegationTokens {
  static const green = Color(0xFF12B76A);
  static const greenDeep = Color(0xFF0A7A4D);
  static const greenTint = Color(0x1F12B76A);
  static const amber = Color(0xFFC88A1E);
  static const amberText = Color(0xFFB7791F);
  static const amberTint = Color(0x21C48A1E);
  static const red = Color(0xFFD64545);
  static const redTint = Color(0x1AD64545);

  static const ink = Color(0xFF0B2A20);
  static const text2 = Color(0xFF5E6F66);
  static const muted = Color(0xFF9DB0A6);

  static const page = Color(0xFFEEF1EE);
  static const card = Color(0xFFFFFFFF);
  static const tint = Color(0xFFF7FAF8);

  static const border = Color(0xFFE6EAE6);
  static const hairline = Color(0xFFEEF1EE);
  static const hoverBorder = Color(0xFFCFEBD9);
  static const iconBtnHoverBg = Color(0xFFF4F8F5);

  static const radiusCard = 16.0;
  static const radiusInput = 14.0;
  static const radiusChip = 10.0;
  static const radiusPanel = 12.0;
  static const radiusIcon = 12.0;
  static const radiusIconBtn = 11.0;
  static const radiusBadge = 999.0;
  static const radiusEmptyIcon = 16.0;

  static const maxContentWidth = 1080.0;

  static const shadowCard = <BoxShadow>[
    BoxShadow(
      color: Color(0x0A08201A),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
    BoxShadow(
      color: Color(0x0D08201A),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];

  static const shadowHover = <BoxShadow>[
    BoxShadow(
      color: Color(0x0D08201A),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
    BoxShadow(
      color: Color(0x1708201A),
      blurRadius: 34,
      offset: Offset(0, 14),
    ),
  ];

  static const focusRing = Color(0x2412B76A);

  static Color statusIconBg(String status) => switch (status) {
        'completed' => greenTint,
        'delegated' => amberTint,
        'failed' => redTint,
        _ => hairline,
      };

  static Color statusIconColor(String status) => switch (status) {
        'completed' => green,
        'delegated' => amber,
        'failed' => red,
        _ => text2,
      };

  static Color statusBadgeBg(String status) => statusIconBg(status);

  static Color statusBadgeText(String status) => switch (status) {
        'completed' => greenDeep,
        'delegated' => amberText,
        'failed' => red,
        _ => text2,
      };
}
