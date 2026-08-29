import 'package:flipper_web/features/login/signin_styles.dart';
import 'package:flutter/material.dart';

/// HR's brand panel for the shared sign-in / sign-up screens.
///
/// Same panel geometry as Books' `WebBrandPanel` — gradient, glow, rings and
/// three floating cards — but the content is HR's: payroll, hiring and
/// attendance instead of revenue, sales and streaks. Registered in `main()`
/// via `brandPanelBuilder`.
///
/// Mirrors `Flipper HR Right Panel.html` (design project `personal`,
/// `hr/hr-verify.jsx`).
class HrBrandPanel extends StatefulWidget {
  const HrBrandPanel({super.key});

  @override
  State<HrBrandPanel> createState() => _HrBrandPanelState();
}

class _HrBrandPanelState extends State<HrBrandPanel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _float;

  /// Design's `animationDelay` per card, as a fraction of the 6s float cycle.
  static const _payrollPhase = 0.0;
  static const _hirePhase = 1100 / 6000;
  static const _streakPhase = 600 / 6000;

  @override
  void initState() {
    super.initState();
    _float = AnimationController(vsync: this, duration: SIMotion.floatCycle)
      ..repeat(reverse: true);
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
                // App logo: assets/hr_logo_transparent.png (see pubspec assets)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/hr_logo_transparent.png',
                      width: 140,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) => Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Center(child: _Rings()),
                        _floatingCard(
                          top: constraints.maxHeight * 0.14,
                          left: constraints.maxWidth * 0.12,
                          rotation: -0.087,
                          phase: _payrollPhase,
                          reduceMotion: reduceMotion,
                          child: const _MiniPayrollCard(),
                        ),
                        _floatingCard(
                          top: constraints.maxHeight * 0.4,
                          right: constraints.maxWidth * 0.08,
                          rotation: 0.087,
                          phase: _hirePhase,
                          reduceMotion: reduceMotion,
                          child: const _MiniHireCard(),
                        ),
                        _floatingCard(
                          top: constraints.maxHeight * 0.6,
                          left: constraints.maxWidth * 0.16,
                          rotation: 0.07,
                          phase: _streakPhase,
                          reduceMotion: reduceMotion,
                          child: const _MiniStreakCard(),
                        ),
                      ],
                    ),
                  ),
                ),
                const _HrBrandCopy(),
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

class _Rings extends StatelessWidget {
  const _Rings();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      height: 360,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Center(
        child: Container(
          width: 264,
          height: 264,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
          ),
        ),
      ),
    );
  }
}

class _HrBrandCopy extends StatelessWidget {
  const _HrBrandCopy();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 440),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'FLIPPER HR',
            style: context.siText(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.2,
              color: const Color(0xFFBFD3FF),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Your team, your time, your people — all in one place.',
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
            'Attendance, payroll, and leave are ready the moment you sign in.',
            style: context.siText(
              fontSize: 15.5,
              height: 1.5,
              color: const Color(0xFFD6E2FF),
            ),
          ),
          const SizedBox(height: 26),
          // Wrap, not Row: HR's stat labels are longer than Books' and would
          // overflow the 440px copy column on narrower desktop widths.
          Wrap(
            spacing: 28,
            runSpacing: 16,
            children: [
              _stat(context, '3,200+', 'employees managed'),
              _stat(context, 'RWF 480M', 'payroll processed monthly'),
              _stat(context, '99.9%', 'uptime'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(BuildContext context, String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
          style: context.siText(fontSize: 12.5, color: const Color(0xFFBFD3FF)),
        ),
      ],
    );
  }
}

// ── Mini cards ────────────────────────────────────────────────────────────────

class _MiniCard extends StatelessWidget {
  const _MiniCard({required this.child, required this.width});

  final Widget child;
  final double width;

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

class _MiniPayrollCard extends StatelessWidget {
  const _MiniPayrollCard();

  static const _bars = [0.46, 0.60, 0.54, 0.82, 0.68, 1.0];
  static const _barsHeight = 48.0;

  @override
  Widget build(BuildContext context) {
    return _MiniCard(
      width: 172,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Payroll · this month',
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
                    '6%',
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
            'RWF 18.2M',
            style: context
                .siPinDigit(fontSize: 19)
                .copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 9),
          SizedBox(
            height: _barsHeight,
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
                          gradient: i == _bars.length - 1
                              ? SITokens.brandGradient
                              : null,
                          color: i == _bars.length - 1
                              ? null
                              : SITokens.blueTint2,
                        ),
                        child: SizedBox(height: _barsHeight * _bars[i]),
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

class _MiniHireCard extends StatelessWidget {
  const _MiniHireCard();

  @override
  Widget build(BuildContext context) {
    return _MiniCard(
      width: 182,
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: SITokens.winTint,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.check_rounded,
              color: SITokens.win,
              size: 17,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New hire',
                  style: context.siText(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Amina K. · Sales',
                  style: context.siText(fontSize: 11, color: SITokens.ink3),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            'Day 1',
            style: context
                .siPinDigit(fontSize: 13)
                .copyWith(fontWeight: FontWeight.w800, color: SITokens.win),
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
    return _MiniCard(
      width: 168,
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '45 days',
                  style: context
                      .siPinDigit(fontSize: 16)
                      .copyWith(fontWeight: FontWeight.w800),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Attendance streak',
                  style: context.siText(fontSize: 11, color: SITokens.ink3),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
