import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_tokens.dart';
import 'package:flipper_dashboard/widgets/pos_handoff_icon.dart';
import 'package:flipper_models/sync/utils/bar_mode_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';

Color barColorForName(String name) {
  var h = 0;
  for (var i = 0; i < name.length; i++) {
    h = (h * 31 + name.codeUnitAt(i)) & 0x7fffffff;
  }
  return Color(barServerColors[h % barServerColors.length]);
}

String barAbbrevForName(String? name) {
  if (name == null || name.trim().isEmpty) return '?';
  final t = name.trim();
  if (t.length <= 3) return t.toUpperCase();
  return t.substring(0, 3);
}

/// Same mark + wordmark as [DashboardLayout] sidebar header / POS shell.
class BarFlipperBrand extends StatelessWidget {
  const BarFlipperBrand({
    super.key,
    this.logoSize = 30,
    this.wordmarkSize = 19,
    this.gap = 11,
  });

  final double logoSize;
  final double wordmarkSize;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PosHandoffIcons.svg('flipper-logo', size: logoSize),
        SizedBox(width: gap),
        Text(
          'FLIPPER',
          style: GoogleFonts.outfit(
            fontSize: wordmarkSize,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.01,
            color: BarTokens.ink1,
          ),
        ),
      ],
    );
  }
}

/// `.bar-status.open` pill with pip.
class BarOpenStatusPill extends StatelessWidget {
  const BarOpenStatusPill({super.key, this.label = 'Open', this.compact = false});

  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final h = compact ? 20.0 : 22.0;
    return Container(
      height: h,
      padding: const EdgeInsets.symmetric(horizontal: 9),
      decoration: BoxDecoration(
        color: BarTokens.blueTint,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: BarTokens.blue,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.22,
              color: BarTokens.blue,
            ),
          ),
        ],
      ),
    );
  }
}

/// Stacked server avatars (`.bar-tcard-servers .sv`).
class BarServerAvatarStack extends StatelessWidget {
  const BarServerAvatarStack({
    super.key,
    required this.initials,
    required this.colors,
    this.size = 24,
  });

  final List<String> initials;
  final List<Color> colors;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (initials.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: size,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < initials.length; i++)
            Transform.translate(
              offset: Offset(i == 0 ? 0 : -7.0 * i, 0),
              child: Container(
                width: size,
                height: size,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors[i % colors.length],
                  shape: BoxShape.circle,
                  border: Border.all(color: BarTokens.surface, width: 2),
                ),
                child: Text(
                  initials[i],
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// `.bar-tablehead` strip for POS tab panel.
class BarTableHead extends StatelessWidget {
  const BarTableHead({
    super.key,
    required this.tableBadge,
    required this.zoneName,
    required this.seats,
    required this.openedAt,
    this.openedBy,
    this.durationLabel,
  });

  final String tableBadge;
  final String zoneName;
  final int seats;
  final DateTime openedAt;
  final String? openedBy;
  final String? durationLabel;

  @override
  Widget build(BuildContext context) {
    final time = MaterialLocalizations.of(context).formatTimeOfDay(
      TimeOfDay.fromDateTime(openedAt),
    );
    final elapsed = durationLabel ?? barFormatDuration(DateTime.now().difference(openedAt));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: BarTokens.line)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: BarTokens.blue,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Text(
              tableBadge,
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.18,
              ),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      zoneName,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const BarOpenStatusPill(label: 'Open tab', compact: true),
                  ],
                ),
                const SizedBox(height: 2),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 0,
                  runSpacing: 2,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person_outline, size: 12, color: BarTokens.ink3),
                        const SizedBox(width: 4),
                        Text(
                          '$seats seats',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 12,
                            color: BarTokens.ink3,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    _dotSep(),
                    Text(
                      openedBy != null ? 'Opened $time by $openedBy' : 'Opened $time',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: BarTokens.ink3,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    _dotSep(),
                    Text(
                      '$elapsed open',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: BarTokens.ink3,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dotSep() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Container(
          width: 3,
          height: 3,
          decoration: const BoxDecoration(
            color: BarTokens.ink4,
            shape: BoxShape.circle,
          ),
        ),
      );
}

/// Server badge on a line (`.bar-line-server`).
class BarLineServerBadge extends StatelessWidget {
  const BarLineServerBadge({
    super.key,
    required this.initials,
    required this.firstName,
    required this.color,
  });

  final String initials;
  final String firstName;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.fromLTRB(3, 1, 7, 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 15,
            height: 15,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Text(
              initials,
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 5),
          Text(
            firstName.toUpperCase(),
            style: GoogleFonts.outfit(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.2,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Dashed border wrapper for empty table cards (`.bar-tcard.empty`).
class BarDashedCard extends StatelessWidget {
  const BarDashedCard({
    super.key,
    required this.child,
    this.radius = BarTokens.radiusMd,
    this.borderColor = BarTokens.lineStrong,
    this.backgroundColor = BarTokens.surface,
  });

  final Widget child;
  final double radius;
  final Color borderColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: CustomPaint(
        foregroundPainter: _DashedRRectPainter(
          radius: radius,
          color: borderColor,
        ),
        child: child,
      ),
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  _DashedRRectPainter({required this.radius, required this.color});

  final double radius;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final inset = 1.5 / 2;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        inset,
        inset,
        size.width - inset * 2,
        size.height - inset * 2,
      ),
      Radius.circular(radius - inset),
    );
    final path = Path()..addRRect(rrect);

    const dash = 7.0;
    const gap = 5.0;
    for (final metric in path.computeMetrics()) {
      var dist = 0.0;
      while (dist < metric.length) {
        final end = math.min(dist + dash, metric.length);
        canvas.drawPath(metric.extractPath(dist, end), paint);
        dist += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter old) =>
      old.color != color || old.radius != radius;
}

/// Open table card shell — solid border + left blue accent (`.bar-tcard.open`).
class BarOpenTableCardShell extends StatelessWidget {
  const BarOpenTableCardShell({
    super.key,
    required this.child,
    this.hovered = false,
  });

  final Widget child;
  final bool hovered;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 140),
      transform: Matrix4.translationValues(0, hovered ? -2 : 0, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(BarTokens.radiusMd),
        color: BarTokens.surface,
        border: Border.all(
          color: hovered ? BarTokens.blueTint2 : BarTokens.line,
          width: 1.5,
        ),
        boxShadow: hovered ? BarTokens.shadow2 : BarTokens.shadow1,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(BarTokens.radiusMd - 1.5),
        child: Stack(
          children: [
            const Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: ColoredBox(
                color: BarTokens.blue,
                child: SizedBox(width: 4),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}

/// Cashier chip (`.bar-chip`).
class BarCashierChip extends StatelessWidget {
  const BarCashierChip({
    super.key,
    required this.name,
    required this.role,
    required this.initials,
    required this.color,
  });

  final String name;
  final String role;
  final String initials;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.only(left: 6, right: 16),
      decoration: BoxDecoration(
        color: BarTokens.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: BarTokens.line),
        boxShadow: BarTokens.shadow1,
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Text(
              initials,
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w700,
                  fontSize: 13.5,
                ),
              ),
              Text(
                role,
                style: GoogleFonts.outfit(
                  fontSize: 11.5,
                  color: BarTokens.ink3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String? barFirstName(String? fullName) {
  if (fullName == null || fullName.trim().isEmpty) return null;
  return fullName.trim().split(RegExp(r'\s+')).first;
}

String barOpenerName(ITransaction tab, List<TransactionItem> lines) {
  for (final line in lines) {
    final n = line.loggedByName?.toString();
    if (n != null && n.isNotEmpty) {
      return barFirstName(n) ?? n;
    }
  }
  return barFirstName(tab.ticketName) ?? '';
}
