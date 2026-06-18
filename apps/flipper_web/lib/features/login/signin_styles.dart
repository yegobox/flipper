import 'dart:math' as math;

import 'package:flipper_design_system/flipper_design_system.dart';
import 'package:flutter/material.dart';

// ── Design tokens (mirrors flipper_login/SignInTokens) ───────────────────────

abstract final class SITokens {
  static const Color surface     = Color(0xFFFFFFFF);
  static const Color surface2    = Color(0xFFF7F9FE);
  static const Color ink1        = Color(0xFF0B1220);
  static const Color ink2        = Color(0xFF4A5567);
  static const Color ink3        = Color(0xFF7E8AA0);
  static const Color line        = Color(0xFFE6ECF5);
  static const Color blue        = Color(0xFF2563EB);
  static const Color blueTint    = Color(0xFFEAF1FE);
  static const Color blueTint2   = Color(0xFFDEEAFD);
  static const Color win         = Color(0xFF10B981);
  static const Color winTint     = Color(0xFFDEF7EC);
  static const Color danger      = Color(0xFFC0392B);
  static const Color dangerTint  = Color(0xFFFDF1EF);

  static const double radiusMd           = 14;
  static const double formMaxWidth       = 380;
  static const double desktopBreakpoint  = 920;
  static const int    pinCellCount       = 6;
  static const double pinCellHeight      = 60;

  static const LinearGradient brandGradient = LinearGradient(
    colors: [Color(0xFF22D3EE), Color(0xFF2563EB), Color(0xFF4F46E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient brandPanelGradient = LinearGradient(
    begin: Alignment(0.7, -0.9),
    end: Alignment(-0.2, 1.2),
    colors: [Color(0xFF2C6BF0), Color(0xFF1D4ED8), Color(0xFF1E3A9E)],
    stops: [0.0, 0.46, 1.0],
  );
}

// ── Text-style helpers (mirrors flipper_login/PinLoginSignInText) ────────────

extension SITextExt on BuildContext {
  TextStyle siText({
    required double fontSize,
    FontWeight fontWeight = FontWeight.w400,
    Color? color,
    double? letterSpacing,
    double? height,
  }) =>
      Theme.of(this).textTheme.bodyMedium!.copyWith(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color ?? SITokens.ink1,
            letterSpacing: letterSpacing,
            height: height,
          );

  TextStyle siPinDigit({double fontSize = 24}) =>
      Theme.of(this).textTheme.headlineSmall!.copyWith(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: SITokens.ink1,
            letterSpacing: 2,
          );
}

// ── Animation constants (mirrors flipper_login/SignInMotion) ─────────────────

abstract final class SIMotion {
  static const Duration shake          = Duration(milliseconds: 400);
  static const Duration cellTransition = Duration(milliseconds: 150);
  static const Duration dotPop         = Duration(milliseconds: 120);
  static const Duration floatCycle     = Duration(milliseconds: 6000);
  static const double   floatAmplitude = 9.0;

  static Animation<double> pinShake(AnimationController c) =>
      TweenSequence<double>([
        TweenSequenceItem(tween: Tween(begin: 0.0, end: -6.0), weight: 20),
        TweenSequenceItem(tween: Tween(begin: -6.0, end: 6.0), weight: 20),
        TweenSequenceItem(tween: Tween(begin: 6.0, end: -6.0), weight: 20),
        TweenSequenceItem(tween: Tween(begin: -6.0, end: 6.0), weight: 20),
        TweenSequenceItem(tween: Tween(begin: 6.0, end: 0.0), weight: 20),
      ]).animate(CurvedAnimation(parent: c, curve: Curves.ease));

  static double floatY(double t, {double phase = 0}) {
    final v = (t + phase) % 1.0;
    return -floatAmplitude * math.sin(Curves.easeInOut.transform(v) * math.pi);
  }
}

// ── Brand header ──────────────────────────────────────────────────────────────

class SIBrandHeader extends StatelessWidget {
  const SIBrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const FlipperBrandBadge(size: 32),
        const SizedBox(width: 11),
        Text(
          'Flipper',
          style: context.siText(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

// ── Bottom bar ────────────────────────────────────────────────────────────────

class SIBottomBar extends StatelessWidget {
  const SIBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '© Flipper ${DateTime.now().year}',
          style: context.siText(fontSize: 13, color: SITokens.ink3),
        ),
        const Spacer(),
        const Icon(Icons.verified_user_outlined, size: 14, color: SITokens.win),
        const SizedBox(width: 6),
        Text(
          'Secured with end-to-end encryption',
          style: context.siText(fontSize: 12.5, color: SITokens.ink3),
        ),
      ],
    );
  }
}

// ── PIN cells ─────────────────────────────────────────────────────────────────

class SIPinCells extends StatelessWidget {
  final String pin;
  final bool showDigits;
  final bool hasError;
  final bool focused;
  final VoidCallback onTap;

  const SIPinCells({
    super.key,
    required this.pin,
    required this.showDigits,
    required this.hasError,
    required this.focused,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: List.generate(SITokens.pinCellCount, (i) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: i < SITokens.pinCellCount - 1 ? 10 : 0,
              ),
              child: _SIPinCell(
                index: i,
                digit: i < pin.length ? pin[i] : null,
                showDigit: showDigits,
                isActive: focused && i == pin.length && !hasError,
                hasError: hasError,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _SIPinCell extends StatelessWidget {
  final int index;
  final String? digit;
  final bool showDigit;
  final bool isActive;
  final bool hasError;

  const _SIPinCell({
    required this.index,
    required this.digit,
    required this.showDigit,
    required this.isActive,
    required this.hasError,
  });

  bool get filled => digit != null;

  @override
  Widget build(BuildContext context) {
    Color border     = SITokens.line;
    Color background = SITokens.surface;
    List<BoxShadow>? shadows;

    if (hasError) {
      border = SITokens.danger;
      background = SITokens.dangerTint;
    } else if (filled) {
      border = SITokens.blue;
      background = SITokens.blueTint;
    } else if (isActive) {
      border = SITokens.blue;
      shadows = [BoxShadow(color: SITokens.blueTint, spreadRadius: 4)];
    }

    return AnimatedContainer(
      duration: SIMotion.cellTransition,
      curve: Curves.ease,
      height: SITokens.pinCellHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(SITokens.radiusMd),
        border: Border.all(color: border, width: 1.5),
        boxShadow: shadows,
      ),
      child: filled
          ? (showDigit
              ? Text(digit!, style: context.siPinDigit(fontSize: 24))
              : _SIPinDot(key: ValueKey('dot-$index-$digit')))
          : null,
    );
  }
}

class _SIPinDot extends StatelessWidget {
  const _SIPinDot({super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: SIMotion.dotPop,
      curve: Curves.easeOut,
      builder: (_, scale, child) => Transform.scale(scale: scale, child: child),
      child: Container(
        width: 12,
        height: 12,
        decoration: const BoxDecoration(
          color: SITokens.ink1,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

// ── Status line ───────────────────────────────────────────────────────────────

class SIStatusLine extends StatelessWidget {
  final bool hasError;
  final bool isSuccess;
  final String message;
  final String successLabel;

  const SIStatusLine({
    super.key,
    required this.hasError,
    required this.isSuccess,
    this.message = '',
    this.successLabel = 'your business',
  });

  @override
  Widget build(BuildContext context) {
    if (isSuccess) {
      return Row(
        children: [
          const Icon(Icons.check_circle_outline, size: 15, color: SITokens.win),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              'Verified — opening $successLabel…',
              style: context.siText(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: SITokens.win,
              ),
            ),
          ),
        ],
      );
    }
    if (hasError && message.isNotEmpty) {
      return Row(
        children: [
          const Icon(Icons.info_outline, size: 15, color: SITokens.danger),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              message,
              style: context.siText(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: SITokens.danger,
              ),
            ),
          ),
        ],
      );
    }
    return const SizedBox(height: 18);
  }
}

// ── Auth-field style helper ───────────────────────────────────────────────────

OutlineInputBorder siInputBorder(Color color, {double width = 1}) {
  return OutlineInputBorder(
    borderRadius: Corners.s12Border,
    borderSide: BorderSide(color: color, width: width),
  );
}

InputDecoration siInputDecoration({
  required String hintText,
  required IconData prefixIcon,
  Widget? suffixIcon,
  bool hasError = false,
}) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: const TextStyle(color: Color(0xFFAEB8CA)),
    prefixIcon: Icon(prefixIcon, color: const Color(0xFF7E8AA0)),
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: SITokens.surface2,
    border: siInputBorder(const Color(0xFFD6DEEA)),
    enabledBorder: siInputBorder(const Color(0xFFD6DEEA)),
    focusedBorder: siInputBorder(
      hasError ? SITokens.danger : SITokens.blue,
      width: 1.6,
    ),
    errorBorder: siInputBorder(FlipperColors.error),
    focusedErrorBorder: siInputBorder(FlipperColors.error, width: 1.6),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  );
}

// ── Brand panel (mirrors PinLoginBrandPanel from flipper_login) ───────────────

class WebBrandPanel extends StatefulWidget {
  const WebBrandPanel({super.key});

  @override
  State<WebBrandPanel> createState() => _WebBrandPanelState();
}

class _WebBrandPanelState extends State<WebBrandPanel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _float;

  static const _phases = [0.0, 600 / 6000, 1100 / 6000];

  @override
  void initState() {
    super.initState();
    _float = AnimationController(
      vsync: this,
      duration: SIMotion.floatCycle,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return DecoratedBox(
      decoration: const BoxDecoration(gradient: SITokens.brandPanelGradient),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            right: -48,
            top: 48,
            child: Container(
              width: 520,
              height: 520,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF22D3EE).withValues(alpha: 0.4),
                    Colors.transparent,
                  ],
                  stops: const [0, 0.62],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) => Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Center(
                          child: Container(
                            width: 360,
                            height: 360,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.12),
                              ),
                            ),
                            child: Center(
                              child: Container(
                                width: 264,
                                height: 264,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color:
                                        Colors.white.withValues(alpha: 0.14),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        _floatingCard(
                          top: constraints.maxHeight * 0.14,
                          left: constraints.maxWidth * 0.12,
                          rotation: -0.087,
                          phase: _phases[0],
                          reduceMotion: reduceMotion,
                          child: const _MiniChartCard(),
                        ),
                        _floatingCard(
                          top: constraints.maxHeight * 0.4,
                          right: constraints.maxWidth * 0.08,
                          rotation: 0.087,
                          phase: _phases[1],
                          reduceMotion: reduceMotion,
                          child: const _MiniSaleCard(),
                        ),
                        _floatingCard(
                          top: constraints.maxHeight * 0.6,
                          left: constraints.maxWidth * 0.16,
                          rotation: 0.07,
                          phase: _phases[2],
                          reduceMotion: reduceMotion,
                          child: const _MiniStreakCard(),
                        ),
                      ],
                    ),
                  ),
                ),
                const _BrandCopy(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _floatingCard({
    double? top,
    double? left,
    double? right,
    required double rotation,
    required double phase,
    required bool reduceMotion,
    required Widget child,
  }) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      child: AnimatedBuilder(
        animation: _float,
        builder: (_, __) {
          final bob = reduceMotion
              ? 0.0
              : SIMotion.floatY(_float.value, phase: phase);
          return Transform.translate(
            offset: Offset(0, bob),
            child: Transform.rotate(angle: rotation, child: child),
          );
        },
      ),
    );
  }
}

class _BrandCopy extends StatelessWidget {
  const _BrandCopy();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 440),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'FLIPPER BUSINESS OS',
            style: context.siText(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.2,
              color: const Color(0xFFBFD3FF),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Your shop, your team, your numbers — all in one place.',
            style: context.siText(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              height: 1.2,
              letterSpacing: -0.6,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Pick up right where you left off. Today's sales, stock, and reports are ready.",
            style: context.siText(
              fontSize: 15.5,
              height: 1.5,
              color: const Color(0xFFD6E2FF),
            ),
          ),
          const SizedBox(height: 26),
          Row(
            children: [
              _stat(context, '12,400+', 'businesses'),
              const SizedBox(width: 28),
              _stat(context, 'RWF 1.2B', 'processed monthly'),
              const SizedBox(width: 28),
              _stat(context, '99.9%', 'uptime'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(BuildContext context, String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: context
              .siPinDigit(fontSize: 24)
              .copyWith(color: Colors.white, letterSpacing: -0.5),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style:
              context.siText(fontSize: 12.5, color: const Color(0xFFBFD3FF)),
        ),
      ],
    );
  }
}

// ── Mini product cards ────────────────────────────────────────────────────────

class _ProductCard extends StatelessWidget {
  final Widget child;
  final double width;

  const _ProductCard({required this.child, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: SITokens.surface,
        borderRadius: BorderRadius.circular(SITokens.radiusMd),
        border: Border.all(color: SITokens.line),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF102040).withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _MiniChartCard extends StatelessWidget {
  const _MiniChartCard();

  static const _bars = [0.4, 0.64, 0.52, 0.86, 0.7, 1.0];

  @override
  Widget build(BuildContext context) {
    return _ProductCard(
      width: 168,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Revenue · this week',
                  style: context.siText(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: SITokens.ink3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.trending_up, size: 11, color: SITokens.win),
                  Text(
                    '18%',
                    style: context.siText(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: SITokens.win,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'RWF 248,500',
            style:
                context.siPinDigit(fontSize: 19).copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 9),
          SizedBox(
            height: 48,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < _bars.length; i++)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: i < _bars.length - 1 ? 4 : 0,
                      ),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient:
                              i == _bars.length - 1 ? SITokens.brandGradient : null,
                          color: i == _bars.length - 1 ? null : SITokens.blueTint2,
                        ),
                        child: SizedBox(height: 48 * _bars[i]),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniSaleCard extends StatelessWidget {
  const _MiniSaleCard();

  @override
  Widget build(BuildContext context) {
    return _ProductCard(
      width: 178,
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: SITokens.winTint,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.check_rounded, color: SITokens.win, size: 17),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New sale',
                  style: context.siText(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Solar Kit · MoMo',
                  style: context.siText(fontSize: 11, color: SITokens.ink3),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            '+12,000',
            style: context.siPinDigit(fontSize: 14).copyWith(
              fontWeight: FontWeight.w800,
              color: SITokens.win,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStreakCard extends StatelessWidget {
  const _MiniStreakCard();

  @override
  Widget build(BuildContext context) {
    return _ProductCard(
      width: 152,
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF8A3D), Color(0xFFFF5A36)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.local_fire_department_rounded,
              color: Colors.white,
              size: 17,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '12 days',
                style: context
                    .siPinDigit(fontSize: 16)
                    .copyWith(fontWeight: FontWeight.w800),
              ),
              Text(
                'Sales streak',
                style: context.siText(fontSize: 11, color: SITokens.ink3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
