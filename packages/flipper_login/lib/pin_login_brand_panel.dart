import 'package:flipper_login/pin_login_signin_motion.dart';
import 'package:flipper_login/pin_login_signin_text.dart';
import 'package:flipper_login/signin_tokens.dart';
import 'package:flutter/material.dart';

/// Right-hand brand panel from `design_handoff_signin/signin/signin.jsx`.
class PinLoginBrandPanel extends StatefulWidget {
  const PinLoginBrandPanel({super.key});

  @override
  State<PinLoginBrandPanel> createState() => _PinLoginBrandPanelState();
}

class _PinLoginBrandPanelState extends State<PinLoginBrandPanel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;

  /// ANIMATIONS.md §6: per-card phase offsets 0s, 0.6s, 1.1s on a 6s cycle.
  static const List<double> _floatPhases = [0, 600 / 6000, 1100 / 6000];

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: SignInMotion.floatCycle,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return DecoratedBox(
      decoration: const BoxDecoration(gradient: SignInTokens.brandPanelGradient),
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
                    builder: (context, constraints) {
                      return Stack(
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
                                      color: Colors.white.withValues(alpha: 0.14),
                                      style: BorderStyle.solid,
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
                            phase: _floatPhases[0],
                            reduceMotion: reduceMotion,
                            child: const _MiniChartCard(),
                          ),
                          _floatingCard(
                            top: constraints.maxHeight * 0.4,
                            right: constraints.maxWidth * 0.08,
                            rotation: 0.087,
                            phase: _floatPhases[1],
                            reduceMotion: reduceMotion,
                            child: const _MiniSaleCard(),
                          ),
                          _floatingCard(
                            top: constraints.maxHeight * 0.6,
                            left: constraints.maxWidth * 0.16,
                            rotation: 0.07,
                            phase: _floatPhases[2],
                            reduceMotion: reduceMotion,
                            child: const _MiniStreakCard(),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const _BrandCopyBlock(),
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
        animation: _floatController,
        builder: (context, _) {
          final bob = reduceMotion
              ? 0.0
              : SignInMotion.floatTranslateY(
                  _floatController.value,
                  phase: phase,
                );
          return Transform.translate(
            offset: Offset(0, bob),
            child: Transform.rotate(
              angle: rotation,
              child: child,
            ),
          );
        },
      ),
    );
  }
}

class _BrandCopyBlock extends StatelessWidget {
  const _BrandCopyBlock();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 440),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'FLIPPER BUSINESS OS',
            style: context.signInText(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.2,
              color: const Color(0xFFBFD3FF),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Your shop, your team, your numbers — all in one place.',
            style: context.signInText(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              height: 1.2,
              letterSpacing: -0.6,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Pick up right where you left off. Today’s sales, stock, and reports are ready.',
            style: context.signInText(
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
          style: context.signInPinDigit(fontSize: 24).copyWith(
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: context.signInText(
            fontSize: 12.5,
            color: const Color(0xFFBFD3FF),
          ),
        ),
      ],
    );
  }
}

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
        color: SignInTokens.surface,
        borderRadius: BorderRadius.circular(SignInTokens.radiusMd),
        border: Border.all(color: SignInTokens.line),
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

  @override
  Widget build(BuildContext context) {
    const bars = [0.4, 0.64, 0.52, 0.86, 0.7, 1.0];
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
                  style: context.signInText(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: SignInTokens.ink3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.trending_up, size: 11, color: SignInTokens.win),
                  Text(
                    '18%',
                    style: context.signInText(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: SignInTokens.win,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'RWF 248,500',
            style: context.signInPinDigit(fontSize: 19).copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 9),
          SizedBox(
            height: 48,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < bars.length; i++)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: i < bars.length - 1 ? 4 : 0),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: i == bars.length - 1
                              ? SignInTokens.brandGradient
                              : null,
                          color: i == bars.length - 1
                              ? null
                              : SignInTokens.blueTint2,
                        ),
                        child: SizedBox(
                          height: 48 * bars[i],
                        ),
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
              color: SignInTokens.winTint,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.check_rounded, color: SignInTokens.win, size: 17),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New sale',
                  style: context.signInText(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Solar Kit · MoMo',
                  style: context.signInText(
                    fontSize: 11,
                    color: SignInTokens.ink3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            '+12,000',
            style: context.signInPinDigit(fontSize: 14).copyWith(
              fontWeight: FontWeight.w800,
              color: SignInTokens.win,
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
                style: context.signInPinDigit(fontSize: 16).copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'Sales streak',
                style: context.signInText(
                  fontSize: 11,
                  color: SignInTokens.ink3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
