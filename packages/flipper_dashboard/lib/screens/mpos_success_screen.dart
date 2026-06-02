import 'dart:math' as math;

import 'package:flipper_dashboard/theme/mpos_motion.dart';
import 'package:flipper_dashboard/utils/mpos_helpers.dart';
import 'package:flutter/material.dart';

/// Sale complete screen ([design_handoff_mobile_pos] Success + ANIMATIONS.md §3).
class MposSaleCompleteSnapshot {
  const MposSaleCompleteSnapshot({
    required this.total,
    required this.itemCount,
    required this.methodLabel,
    this.customerName,
    required this.tendered,
    required this.change,
  });

  final double total;
  final int itemCount;
  final String methodLabel;
  final String? customerName;
  final double tendered;
  final double change;
}

class MposSuccessScreen extends StatefulWidget {
  const MposSuccessScreen({
    super.key,
    required this.data,
    required this.onNewSale,
    this.onPrintReceipt,
  });

  final MposSaleCompleteSnapshot data;
  final VoidCallback onNewSale;
  final VoidCallback? onPrintReceipt;

  @override
  State<MposSuccessScreen> createState() => _MposSuccessScreenState();
}

class _MposSuccessScreenState extends State<MposSuccessScreen>
    with TickerProviderStateMixin {
  late final AnimationController _checkController;
  late final AnimationController _receiptController;
  late final AnimationController _confettiController;
  late final Animation<double> _checkScale;
  late final Animation<double> _receiptOpacity;
  late final Animation<Offset> _receiptSlide;

  bool _started = false;

  @override
  void initState() {
    super.initState();
    _checkController = AnimationController(
      vsync: this,
      duration: MposMotion.checkPop,
    );
    _checkScale = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _checkController, curve: MposMotion.overshoot),
    );

    _receiptController = AnimationController(
      vsync: this,
      duration: MposMotion.receiptIn,
    );
    final receiptCurve = CurvedAnimation(
      parent: _receiptController,
      curve: MposMotion.decelerate,
    );
    _receiptOpacity = Tween<double>(begin: 0, end: 1).animate(receiptCurve);
    _receiptSlide = Tween<Offset>(
      begin: const Offset(0, 0.02),
      end: Offset.zero,
    ).animate(receiptCurve);

    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    final reduced = MposMotion.reducedMotion(context);
    if (reduced) {
      _checkController.value = 1;
      _receiptController.value = 1;
    } else {
      _checkController.forward();
      Future<void>.delayed(MposMotion.receiptDelay, () {
        if (mounted) _receiptController.forward();
      });
      _confettiController.forward();
    }
  }

  @override
  void dispose() {
    _checkController.dispose();
    _receiptController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    final subline = '${d.methodLabel.toUpperCase()} · ${d.itemCount} '
        '${d.itemCount == 1 ? 'item' : 'items'}'
        '${d.customerName != null ? ' · ${d.customerName}' : ' · Walk-in'}';

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, -0.9),
                radius: 1.3,
                colors: [Color(0xFF1FB36B), Color(0xFF16A34A), Color(0xFF0F7A38)],
                stops: [0, 0.44, 1],
              ),
            ),
          ),
          if (!MposMotion.reducedMotion(context))
            AnimatedBuilder(
              animation: _confettiController,
              builder: (_, __) => CustomPaint(
                painter: _ConfettiPainter(_confettiController.value),
                size: Size.infinite,
              ),
            ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 26),
                    child: Column(
                      children: [
                        const SizedBox(height: 56),
                        ScaleTransition(
                          scale: _checkScale,
                          child: Container(
                            width: 104,
                            height: 104,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.28),
                              ),
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              size: 52,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Sale complete',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.02,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          subline,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14.5,
                            color: Color(0xFFDDF3E6),
                          ),
                        ),
                        const SizedBox(height: 26),
                        FadeTransition(
                          opacity: _receiptOpacity,
                          child: SlideTransition(
                            position: _receiptSlide,
                            child: _ReceiptCard(data: d),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    26,
                    14,
                    26,
                    16 + MediaQuery.paddingOf(context).bottom,
                  ),
                  child: Column(
                    children: [
                      _DoneButton(
                        solid: true,
                        label: 'New sale',
                        icon: Icons.add_rounded,
                        onTap: widget.onNewSale,
                      ),
                      const SizedBox(height: 10),
                      _DoneButton(
                        solid: false,
                        label: 'Print receipt',
                        icon: Icons.receipt_long_outlined,
                        onTap: widget.onPrintReceipt ?? widget.onNewSale,
                      ),
                    ],
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

class _ReceiptCard extends StatelessWidget {
  const _ReceiptCard({required this.data});

  final MposSaleCompleteSnapshot data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          _row('Total paid', data.total, big: true),
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(vertical: 10),
            color: Colors.white.withValues(alpha: 0.18),
          ),
          _row('Tendered', data.tendered),
          _row('Change', data.change),
        ],
      ),
    );
  }

  Widget _row(String k, double v, {bool big = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            k,
            style: TextStyle(
              fontSize: big ? 15 : 13,
              fontWeight: big ? FontWeight.w700 : FontWeight.w400,
              color: big ? Colors.white : const Color(0xFFDDF3E6),
            ),
          ),
          Text(
            'RWF ${mposMoneyLabel(v)}',
            style: TextStyle(
              fontSize: big ? 22 : 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

class _DoneButton extends StatelessWidget {
  const _DoneButton({
    required this.solid,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final bool solid;
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: solid ? Colors.white : Colors.white.withValues(alpha: 0.14),
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 54,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: solid
                ? null
                : Border.all(color: Colors.white.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: solid ? const Color(0xFF15803D) : Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                  color: solid ? const Color(0xFF15803D) : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.progress);

  final double progress;
  static final _rng = math.Random(42);
  static late final List<_Particle> _particles = List.generate(50, (_) {
    return _Particle(
      x: _rng.nextDouble(),
      delay: _rng.nextDouble() * 0.5,
      duration: 0.55 + _rng.nextDouble() * 0.45,
      hue: _rng.nextInt(360),
      size: 4 + _rng.nextDouble() * 6,
      isCircle: _rng.nextBool(),
    );
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _particles) {
      final t = ((progress - p.delay) / p.duration).clamp(0.0, 1.0);
      if (t <= 0) continue;
      final y = t * size.height * 1.1;
      final x = p.x * size.width + math.sin(t * math.pi * 4) * 12;
      final paint = Paint()
        ..color = HSLColor.fromAHSL(1, p.hue.toDouble(), 0.75, 0.55).toColor();
      if (p.isCircle) {
        canvas.drawCircle(Offset(x, y), p.size / 2, paint);
      } else {
        canvas.save();
        canvas.translate(x, y);
        canvas.rotate(t * math.pi * 4);
        canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.6),
          paint,
        );
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _Particle {
  _Particle({
    required this.x,
    required this.delay,
    required this.duration,
    required this.hue,
    required this.size,
    required this.isCircle,
  });

  final double x;
  final double delay;
  final double duration;
  final int hue;
  final double size;
  final bool isCircle;
}
